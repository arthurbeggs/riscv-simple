// Autor: Lucas Neves Carvalho
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
module Oscillator
(
	input OscillatorConfiguration CONFIG,
	input ChannelInfo CHANNEL,
	input NoteInfo INFO,
	input Sample SINE,
	input OscillatorData DATA,
	output OscillatorData oDATA,
	output Sample OUT
);

// --- Acumulador
always @(posedge CHANNEL.clock)
	if (CHANNEL.pass)
		oDATA.accumulator <= DATA.accumulator;
	else
		oDATA.accumulator <= DATA.accumulator + INFO.step;
		
// --- Ruído.
reg [14:0] noise = 15'b11111111;

always @(posedge CHANNEL.clock)
	if (CHANNEL.pass && CHANNEL.last)
		noise <= { noise[13:0], noise[14] ^ noise[13] };
	
// --- Formas de onda
wire signed [15:0] out = CONFIG.wave == 2'd1 ? { { 3 { SINE[15] } }, SINE[14:2] } :
								CONFIG.wave == 2'd2 ? { 3'b0, DATA.accumulator[16], 12'b0 } :
								CONFIG.wave == 2'd3 ? { 3'b0, DATA.accumulator[16:4] } :
								16'b0;

// --- Saída.
assign OUT = { out[15:13], CONFIG.noise ? noise[12:0] : out[12:0] };

endmodule

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
package OscillatorSine;
	function logic [11:0] Angle(OscillatorData DATA);
		return DATA.accumulator[16:5];
	endfunction
endpackage

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
typedef struct packed {
	logic [1:0] wave;
	logic noise;
} OscillatorConfiguration;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
typedef struct packed {
	logic [16:0] accumulator;
} OscillatorData;
