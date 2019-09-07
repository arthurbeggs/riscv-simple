/*
 * VGAAdapterInterface
 *
 * CPU interface module to the VGA Adapter.
 */
module VGA_Interface (
    input             iRST, iCLK_50, iCLK2_50, iCLK,
    output            oVGA_HS, oVGA_VS, oVGA_BLANK_N, oVGA_SYNC_N,oVGA_CLK,
    output     [7:0]  oVGA_R, oVGA_G, oVGA_B,
    output reg [4:0]  oVGASelect,
    input wire [31:0] iVGARead,
    input wire        iDebugEnable,
	 input wire			 iframesw,

    //  Barramento de IO
    input         wReadEnable, wWriteEnable,
    input  [3:0]  wByteEnable,
    input  [31:0] wAddress, wWriteData,
    output [31:0] wReadData
    );


wire [31:0] wReadVGA;
wire [3:0]  ByteSelect;
wire [9:0] oVGA_R2, oVGA_G2, oVGA_B2;
assign oVGA_R=oVGA_R2[9:2];
assign oVGA_G=oVGA_G2[9:2];
assign oVGA_B=oVGA_B2[9:2];

VgaAdapter VGA0(
    //.resetn(~iRST),
	 .resetn(1'b1),
    .iCLK(iCLK),
    .CLOCK_50(iCLK_50),
	 .CLOCK2_50(iCLK2_50),
    .color_in(wWriteData),
    .color_out(wReadVGA),
    .address(wAddress),
    .iMemWrite(wWriteEnable),
    .VGA_R(oVGA_R2),
    .VGA_G(oVGA_G2),
    .VGA_B(oVGA_B2),
    .VGA_HS(oVGA_HS),
    .VGA_VS(oVGA_VS),
    .VGA_BLANK(oVGA_BLANK_N),
    .VGA_SYNC(oVGA_SYNC_N),
    .VGA_CLK(oVGA_CLK),
    .iByteEnable(ByteSelect),
    // .iByteEnable(wByteEnable),
    .oVGASelect(oVGASelect),
    .iVGARead(iVGARead),
    .iDebugEnable(iDebugEnable),
	 .frameselect(frameselect)
);

wire frame0 = (wAddress>=BEGINNING_VGA0 && wAddress <= END_VGA0);
wire frame1 = (wAddress>=BEGINNING_VGA1 && wAddress <= END_VGA1);

always @(*)
    if(wReadEnable)
        if (frame0 || frame1)
				wReadData <= wReadVGA;
			else
				if(wAddress==FRAMESELECT)
					wReadData <= Frame;
				else wReadData   <= 32'hzzzzzzzz;
    else wReadData    <= 32'hzzzzzzzz;

	 
reg [31:0] Frame;
initial Frame = ZERO;

always @(posedge iCLK)
	if(wWriteEnable)
		if(wAddress==FRAMESELECT)
			Frame <= wWriteData;
		else
			Frame <= Frame;

wire frameselect = Frame[0] ^ iframesw;		

// Implementação em hardware da transparência 0xC7
always @(*)
    if (wWriteEnable) begin
        if (frame0 || frame1) begin
            if (wWriteData[7:0]   == 8'hC7)
                ByteSelect[0]   = 1'b0;
            else
                ByteSelect[0]   = wByteEnable[0];

            if (wWriteData[15:8]  == 8'hC7)
                ByteSelect[1]   = 1'b0;
            else
                ByteSelect[1]   = wByteEnable[1];

            if (wWriteData[23:16] == 8'hC7)
                ByteSelect[2]   = 1'b0;
            else
                ByteSelect[2]   = wByteEnable[2];

            if (wWriteData[31:24] == 8'hC7)
                ByteSelect[3]   = 1'b0;
            else
                ByteSelect[3]   = wByteEnable[3];
        end
        else    ByteSelect      = 4'h0;
    end
    else    ByteSelect      = 4'h0;


endmodule
