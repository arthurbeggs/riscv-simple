module LFSR_word    (
	output reg [31:0] out,
	input clk
	);
	
reg b32;
wire linear_feedback,lf1,lf2,lf3;

assign lf1 = out[31] ^ out[21];
assign lf2 = out[1] ^ lf1;
assign lf3 = out[0] ^ lf2;
assign linear_feedback = lf3 ^ 1'b1;

always @(posedge clk) begin
	b32 = linear_feedback;   //	out[32] = linear_feedback;
	out = {b32,out[31:1]};   //out = out >> 1'b1;
end 

endmodule
