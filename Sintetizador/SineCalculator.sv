// Autor: Lucas Neves Carvalho
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
module SineCalculator
(
	input CLK, // Armazena o ângulo na borda de subida.
	input SineAngle ANGLE,
	output Sample OUT
);

// --- Saída
assign OUT = negative ? -signed_value : signed_value;

reg negative = 1'b0;

always @(posedge CLK)
	negative <= ANGLE[11];

// --- Ajusta o endereço
wire [9:0] index = ANGLE[9:0];
wire [9:0] quarter = index ^ { 10 { ANGLE[10] } };

// --- Look-Up Table
wire [15:0] value;
wire signed [15:0] signed_value = { 1'b0, value[15:1] };

SineTable sineTable(.address(quarter), .clock(CLK), .q(value));

endmodule

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
typedef logic [11:0] SineAngle;
