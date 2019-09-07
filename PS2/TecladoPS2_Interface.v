module TecladoPS2_Interface(
    input iCLK,
    input iCLK_50,
    input Reset,
    inout PS2_KBCLK,
    inout PS2_KBDAT,
	 
    //  Barramento de IO
    input         wReadEnable, wWriteEnable,
    input  [3:0]  wByteEnable,
    input  [31:0] wAddress, wWriteData,
    output [31:0] wReadData,

    // Para o Coprocessador 0 - Interrupcao
    output reg ps2_scan_ready_clock,
    output reg keyboard_interrupt
    );


wire [7:0]  PS2scan_code;
reg  [7:0]  PS2history[7:0]; 		// buffer de 8 bytes
wire        PS2scan_ready, PS2read;

oneshot pulser(
   .pulse_out(PS2read),
   .trigger_in(PS2scan_ready),
   .clk(iCLK_50)
);

keyboard kbd(
  .keyboard_clk(PS2_KBCLK),
  .keyboard_data(PS2_KBDAT),
  .clock50(iCLK_50),
  .reset(Reset),
  .read(PS2read),
  .scan_ready(PS2scan_ready),
  .scan_code(PS2scan_code)
);

always @(posedge PS2scan_ready)
		ps2_scan_ready_clock    <= ~ps2_scan_ready_clock;

always @(posedge iCLK)
		keyboard_interrupt      <= ps2_scan_ready_clock;


always @(posedge PS2scan_ready or posedge Reset)
begin
    if(Reset)
        begin
        PS2history[7] <= 8'b0;
        PS2history[6] <= 8'b0;
        PS2history[5] <= 8'b0;
        PS2history[4] <= 8'b0;
        PS2history[3] <= 8'b0;
        PS2history[2] <= 8'b0;
        PS2history[1] <= 8'b0;
        PS2history[0] <= 8'b0;
        end
    else
        begin
        PS2history[7] <= PS2history[6];
        PS2history[6] <= PS2history[5];
        PS2history[5] <= PS2history[4];
        PS2history[4] <= PS2history[3];
        PS2history[3] <= PS2history[2];
        PS2history[2] <= PS2history[1];
        PS2history[1] <= PS2history[0];
        PS2history[0] <= PS2scan_code;
		  end
end		  


//always @(posedge PS2scan_ready)
always @(posedge iCLK_50 or posedge Reset)
begin
	if(Reset)
		shift <=1'b0;
	else
		if(PS2scan_ready)
		 if(PS2scan_code == 8'h12 || PS2scan_code == 8'h59)		// Shift
			if(PS2history[1] == 8'hF0)	// tecla Shift solta	
					shift <= 1'b0;
			else
					shift <= 1'b1;	  
end

always @(posedge iCLK_50 or posedge Reset)
begin	
	if(Reset)
		begin
			PS2_Pronto <= 1'b0;
			PS2_ASCII <= 8'h0;
		end
	else
	begin
		if(PS2scan_ready && ~PS2_Pronto)
			begin
						if(PS2scan_code != 8'h12 && 
							PS2scan_code != 8'h59 && 
							PS2scan_code < 8'h80 &&
							PS2history[1] != 8'hF0) // não informa shift, F0, não imprimivel, nem a soltura
							begin							
								PS2_Pronto <= 1'b1;
								PS2_ASCII <= ascii_code;
							end
			end

		if(PS2_Leu && PS2_Pronto)
					begin
						PS2_Pronto <= 1'b0;
						//PS2_ASCII <= 8'b0;
					end
	end
end

reg PS2_Pronto, PS2_Leu, shift;
reg [7:0] PS2_ASCII;
wire [7:0] ascii_code;
scan2ascii s2a (
	.scan(PS2scan_code),
	.shift(shift),
	.ascii(ascii_code)
);


wire [127:0] KeyMap;  // Buffer de 128 bits com o mapa do teclado
keyscan keys1 (
	.Clock(iCLK_50),
	.Reset(Reset), 
	.PS2scan_ready(PS2scan_ready), 
	.PS2scan_code(PS2scan_code),
	.KeyMap (KeyMap)
);


always @(*)
        if(wReadEnable)
            begin
					 if (wAddress==KDMMIO_DATA_ADDRESS)	// lw neste endereço indica que o buffer foi lido
					 	 PS2_Leu <= 1'b1;
					 else
						 PS2_Leu <= 1'b0;

					 if(wAddress==KDMMIO_CTRL_ADDRESS)		 wReadData <= {31'b0,PS2_Pronto}; else
					 if(wAddress==KDMMIO_DATA_ADDRESS)		 wReadData <= {24'b0,PS2_ASCII}; else
                if(wAddress==BUFFER0_TECLADO_ADDRESS)  wReadData <= {PS2history[3],PS2history[2],PS2history[1],PS2history[0]}; else
                if(wAddress==BUFFER1_TECLADO_ADDRESS)  wReadData <= {PS2history[7],PS2history[6],PS2history[5],PS2history[4]}; else
					 if(wAddress==KEYMAP0_ADDRESS)  wReadData <= KeyMap[31:0]; else
					 if(wAddress==KEYMAP1_ADDRESS)  wReadData <= KeyMap[63:32]; else
					 if(wAddress==KEYMAP2_ADDRESS)  wReadData <= KeyMap[95:64]; else
					 if(wAddress==KEYMAP3_ADDRESS)  wReadData <= KeyMap[127:96]; else
						wReadData	<= 32'hzzzzzzzz;
            end
         else
				begin
					wReadData	<= 32'hzzzzzzzz;
					PS2_Leu 		<= 1'b0;
				end

endmodule

