
//--- VGA Adapter Settings
/* The following settings adjust whether the VGA Adapter operates
 * in monochromatic or color mode. If the adapter is to operate in
 * color mode, the developer may specify the range of colors by
 * selecting the width of each color channel (i.e. RED, GREEN, BLUE).
 */

/* Color Modes:
 *	Comment the line below to enable color support 
 */
`define COLOR_MODE 1

module VgaAdapter(
	input resetn,
	input iCLK,
	input CLOCK_50,
	input CLOCK2_50,
	input [31:0] color_in,
	output [31:0] color_out,
	input [31:0] address,
	input iMemWrite,
	output reg [9:0] VGA_R,
	output reg [9:0] VGA_G,
	output reg [9:0] VGA_B,
	output reg VGA_HS,
	output reg VGA_VS,
	output reg VGA_BLANK,
	output VGA_SYNC,
	output VGA_CLK,
	input [3:0] iByteEnable,
	output reg [4:0] oVGASelect,
	input wire [31:0] iVGARead,
	input wire iDebugEnable,
	input wire frameselect
);

/* From VGAAdapterInterface.v */

		reg MemWritten1;
		reg MemWritten0;
		/*
		 * Avoids writing twice in a CPU cycle, since the memory is not necessarily
		 * synchronous.*/

		always @(iCLK) begin
			MemWritten0 <= iCLK;
			MemWritten1 <= iCLK;
		end

		wire frame0 = (address >= BEGINNING_VGA0  && address <= END_VGA0);
		wire frame1 = (address >= BEGINNING_VGA1  && address <= END_VGA1);
		
		wire writeEnable0 = (iMemWrite && ~MemWritten0 && frame0);
		wire writeEnable1 = (iMemWrite && ~MemWritten1 && frame1);


	//--- Timing information
	/* Do not modify these values unless you know what you are doing.
	 * Incorrect values may cause harm to the monitor.
	 */
	parameter C_VERT_NUM_PIXELS  = 10'd480;
	parameter C_VERT_SYNC_START  = 10'd493;
	parameter C_VERT_SYNC_END    = 10'd494; //(C_VERT_SYNC_START + 2 - 1); 
	parameter C_VERT_TOTAL_COUNT = 10'd525;

	parameter C_HORZ_NUM_PIXELS  = 10'd640;
	parameter C_HORZ_SYNC_START  = 10'd659;
	parameter C_HORZ_SYNC_END    = 10'd754; //(C_HORZ_SYNC_START + 96 - 1); 
	parameter C_HORZ_TOTAL_COUNT = 10'd800;
	
	//--- Clock Generator
	/* The following module, provided by Quartus, declares a derived clock
	 * inside the FPGA. The following derived clock, operates at 25MHz, which is
	 * the frequency required for 640x480@60Hz.
	 */
	VgaPll xx (.refclk(CLOCK2_50), .rst(1'b0), .outclk_0(VGA_CLK),.outclk_1(),.locked());
	
	//--- CRT Controller (25 mhz)
	/* These counters are responsible for traversing the onscreen pixels and
	 * generating the approperiate sync and enable signals for the monitor.
	 */
	reg [9:0] xCounter, yCounter;
	
	//- Horizontal Counter
	wire xCounter_clear = (xCounter == (C_HORZ_TOTAL_COUNT-1));

	always @(posedge VGA_CLK or negedge resetn) begin
		if (!resetn)
			xCounter <= 10'd0;
		else if (xCounter_clear)
			xCounter <= 10'd0;
		else
		begin
			xCounter <= xCounter + 1'b1;
		end
	end
	
	//- Vertical Counter
	wire yCounter_clear = (yCounter == (C_VERT_TOTAL_COUNT-1)); 

	always @(posedge VGA_CLK or negedge resetn) begin
		if (!resetn)
			yCounter <= 10'd0;
		else if (xCounter_clear && yCounter_clear)
			yCounter <= 10'd0;
		else if (xCounter_clear)		//Increment when x counter resets
			yCounter <= yCounter + 1'b1;
	end
	
	//--- Frame buffer
	//Dual port RAM read at 25 MHz, written at 50 MHZ (synchronous with rest of circuit)

	wire [31:0] readData0;
	wire [31:0] readData1;

	// assign writeAddr = 12'd320 * y + x;  // 640

	// To go from 320x240 to 640x480, each pixel is drawn twice
	// This is achieved by ignoring the LSB of each counter
//	wire [14:0] readAddr  = 12'd80 * yCounter[9:1] + xCounter[9:3];
	wire [16:0] readAddr;
	assign readAddr=(12'd320*yCounter[9:1]+xCounter[9:1]); // Endereco em bytes

	// To go from byte address to word address, two xCounter bits are ignored
	// The ignored bits define the byte to be drawn as a pixel

// Port A = video output, read only
// Port B = processor load/store
MemoryVGA memVGA0 (
	.address_a(readAddr[16:2]),
	.address_b(address[16:2]),
	.byteena_b(iByteEnable),
	.clock_a(VGA_CLK),
	.clock_b(CLOCK_50),
	.data_a(32'b0),
	.data_b(color_in),
	.wren_a(1'b0),
	.wren_b(writeEnable0),
	.q_a(readData0),
	.q_b(color_out0)
);


MemoryVGA1 memVGA1 (
	.address_a(readAddr[16:2]),
	.address_b(address[16:2]),
	.byteena_b(iByteEnable),
	.clock_a(VGA_CLK),
	.clock_b(CLOCK_50),
	.data_a(32'b0),
	.data_b(color_in),
	.wren_a(1'b0),
	.wren_b(writeEnable1),
	.q_a(readData1),
	.q_b(color_out1)
);

	wire [31:0] color_out0, color_out1;
	
	assign color_out = frame0 ? color_out0 : (frame1 ? color_out1 : ZERO);
	
	wire [31:0] readData = frameselect ? readData1 : readData0;
	
	wire [7:0] pixelData;
	
always @(*) // Not sure why it starts from 01 instead of 00
		case (readAddr[1:0])
			2'b01: pixelData = readData[ 7: 0];
			2'b10: pixelData = readData[15: 8];
			2'b11: pixelData = readData[23:16];
			2'b00: pixelData = readData[31:24];
		endcase	
	
	wire [29:0] fpixelData;

	RegDisplay RegDisp0 (
		.ixCounter(xCounter),
		.iyCounter(yCounter),
		.iPixel(pixelData),
		.iData(iVGARead),
		.iEnable(iDebugEnable),
		.oPixel(fpixelData),
		.oSelect(oVGASelect)
	);

	always @(*) begin
		// New version, bits are distributed more evenly
		VGA_R = fpixelData[ 9: 0]; //{fpixelData[2:0], fpixelData[2:0], fpixelData[2:0], fpixelData[2]}; // 3 bits R
		VGA_G = fpixelData[19:10]; //{fpixelData[5:3], fpixelData[5:3], fpixelData[5:3], fpixelData[5]}; // 3 bits G
		VGA_B = fpixelData[29:20]; //{fpixelData[7:6], fpixelData[7:6], fpixelData[7:6], fpixelData[7:6], fpixelData[7:6]}; // 2 bits B

	end

	//--- Output Display Sync and Enable
	/* The following outputs are delayed by two clock cycles total because
	 * of the ram. One cycle is added explicitly below and another cycle
	 * is added on the registered output.
	 */
	reg VGA_HS1;
	reg VGA_VS1;
	reg VGA_BLANK1;
	
	always @(posedge VGA_CLK) begin
		//- Sync Generator (ACTIVE LOW)
		VGA_HS1 <= ~((xCounter >= C_HORZ_SYNC_START) && (xCounter <= C_HORZ_SYNC_END));
		VGA_VS1 <= ~((yCounter >= C_VERT_SYNC_START) && (yCounter <= C_VERT_SYNC_END));
		
		//- Current X and Y is valid pixel range
		VGA_BLANK1 <= ((xCounter < C_HORZ_NUM_PIXELS) && (yCounter < C_VERT_NUM_PIXELS));	
	
		//- Add 1 cycle delay
		VGA_HS <= VGA_HS1;
		VGA_VS <= VGA_VS1;
		VGA_BLANK <= VGA_BLANK1;	
	end
	
	assign VGA_SYNC = 1'b1;

endmodule
	