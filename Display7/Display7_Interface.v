module Display7_Interface (
	output [6:0] HEX0_D, HEX1_D, HEX2_D, HEX3_D, HEX4_D, HEX5_D,
	input [31:0] Output
	);
	

Decoder7 Dec0 (
	.In(Output[3:0]),
	.Out(HEX0_D)
	);

Decoder7 Dec1 (
	.In(Output[7:4]),
	.Out(HEX1_D)
	);

Decoder7 Dec2 (
	.In(Output[11:8]),
	.Out(HEX2_D)
	);

Decoder7 Dec3 (
	.In(Output[15:12]),
	.Out(HEX3_D)
	);

Decoder7 Dec4 (
	.In(Output[19:16]),
	.Out(HEX4_D)
	);

Decoder7 Dec5 (
	.In(Output[23:20]),
	.Out(HEX5_D)
	);

	
endmodule