// Autor: Lucas Neves Carvalho
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
module DigitalFilter
(
	input DigitalFilterConfiguration CONFIG,
	input ChannelInfo CHANNEL,
	input Sample SINE,
	input DigitalFilterData DATA,
	output DigitalFilterData oDATA,
	input Sample IN,
	output Sample OUT
);

// --- Atualiza os registradores. (em duas passagens)
always @(posedge CHANNEL.clock)
	if (!CHANNEL.pass) begin
		oDATA.z1 <= ~DATA.z2;
		oDATA.z2 <= sample_k;
	end else begin
		oDATA.z1 <= sum1;
		oDATA.z2 <= sum2;
	end
	
assign OUT = CONFIG.on ? sum0[31:16] : IN;

// --- Somadores. (saturação)
wire signed [32:0] sum0e = DATA.z1 + sample_k;
wire signed [31:0] sum0 = ^sum0e[32:31] ? { sum0e[32], { 31 { ~sum0e[32] } } } : sum0e[31:0];

wire signed [34:0] sum1e = { { 3 { DATA.z1[31] } }, DATA.z1 } + { sample_c[31], sample_c, { 2 { sample_c[0] } } };
wire signed [31:0] sum1 = &(sum1e[33:31] ^ { 3 { ~sum1e[34] } }) ? sum1e[31:0] : { sum1e[34], { 31 { ~sum1e[34] } } };

wire signed [32:0] sum2e = DATA.z2 + sample_d;
wire signed [31:0] sum2 = ^sum2e[32:31] ? { sum2e[32], { 31 { ~sum2e[32] } } } : sum2e[31:0];

// --- Multiplicadores.
wire signed [31:0] sample_k = in32 * k; // Q15 * Q16 = Q31
wire signed [31:0] sample_c = IN * c; // Q15 * Q14 = Q29
wire signed [31:0] sample_d = in32 * d; // Q15 * Q16 = Q31

wire signed [31:0] in32 = { { 16 { IN[15] } }, IN }; // Q15

// --- Coeficientes.
wire [15:0] k = ~d >> 1; // Q16
wire [23:0] aux1=cos * CONFIG.q >> 8; // Q14
wire signed [15:0] c;
assign c = aux1[15:0];
//wire signed [15:0] c = cos * CONFIG.q >> 8; // Q14
wire [15:0] d = CONFIG.q * CONFIG.q; // Q16

// wire [15:0] d2 = d * d >> 16; // Q16 Retirado para reduzir o numero de Warnings

// --- Cosseno.
wire signed [23:0] cos = { { 8 { SINE[15] } }, SINE };

endmodule

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
package DigitalFilterSine;
	function logic [11:0] Angle(NoteInfo INFO);
		return { INFO.step[15], ~INFO.step[15], INFO.step[14:5] };
	endfunction
endpackage

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
typedef struct packed {
	logic [7:0] q; // Q8
	logic on;
} DigitalFilterConfiguration;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
typedef struct packed {
	logic signed [31:0] z1; // Q31
	logic signed [31:0] z2; // Q31
} DigitalFilterData;
