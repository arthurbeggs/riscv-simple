/*
 * Decoder 7
 *
 * Decodes a 4 bit input into the equivalent 7 bit word to print in the 7
 * segment display.
 */
module Decoder7 (
	input wire [3:0] In,
	output reg [6:0] Out
	);

	always @(*)
	begin
		case (In)
			4'b0000: Out = ~7'b0111111; 
			4'b0001: Out = ~7'b0000110;
			4'b0010: Out = ~7'b1011011; 
			4'b0011: Out = ~7'b1001111; 

			4'b0100: Out = ~7'b1100110; 
			4'b0101: Out = ~7'b1101101; 
			4'b0110: Out = ~7'b1111101; 
			4'b0111: Out = ~7'b0000111; 
 
			4'b1000: Out = ~7'b1111111; 
			4'b1001: Out = ~7'b1101111;
			4'b1010: Out = ~7'b1110111; 
			4'b1011: Out = ~7'b1111100; 

			4'b1100: Out = ~7'b0111001; 
			4'b1101: Out = ~7'b1011110; 
			4'b1110: Out = ~7'b1111001; 
			4'b1111: Out = ~7'b1110001; 

			default: Out = ~7'b0000000;
		endcase
	end
endmodule
