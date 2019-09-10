module keyscan(
	input Clock,
	input Reset,
	input PS2scan_ready,
	input [7:0] PS2scan_code,
	output reg [127:0] KeyMap
	);

	reg [7:0] PS2scan_codeant;
	
	always @(posedge Clock  or posedge Reset)
		if(Reset)
			begin
				KeyMap <= 128'b0;
				PS2scan_codeant <= 8'b0;
			end	
		else
		if(PS2scan_ready)
		begin
			if (PS2scan_codeant == 8'hF0)
				begin
					if(PS2scan_code <= 8'h80)
						KeyMap[PS2scan_code[6:0]] <= 1'b0;
				end
			else
				begin
					if(PS2scan_code <= 8'h80)
						KeyMap[PS2scan_code[6:0]] <= 1'b1;  // Os scancodes >0x80 não são mapeados
				end
	
			PS2scan_codeant <= PS2scan_code;
	  end
		
endmodule
