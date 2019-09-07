// Autor: Lucas Neves Carvalho
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
module ChannelBank
(
	input CLK, // Um clock 64 vezes mais rápido que o de amostragem
	output ChannelInfo CHANNEL // O canal atual
);

// --- Saída.
assign CHANNEL.clock = clk64[1];
assign CHANNEL.last = &channel[2:0];
assign CHANNEL.pass = channel[3];

// --- Rotaciona o canal.
reg [3:0] channel = 4'b0;

always @(posedge clk64[1])
	channel <= channel + 4'b1;
	
// --- Clocking.
reg [1:0] clk64 = 2'b0;

always @(posedge CLK)
	clk64 <= clk64 + 2'b1;

endmodule

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
module Mixer
(
	input EN,
	input ChannelInfo CHANNEL,
	input Sample SAMPLE,
	output Sample OUT
);

// --- Mixagem final.
Sample mixed = 16'b0;
			
always @(posedge CHANNEL.clock)
	if (!CHANNEL.pass && CHANNEL.last)
		mixed <= mix;
		
assign OUT = mixed;

// --- Mixagem de cada canal.
Sample mixing = 16'b0;

always @(posedge CHANNEL.clock)
	mixing <= CHANNEL.pass ? 16'b0 : mix;
		
wire signed [15:0] mix = mixing + (EN ? SAMPLE : 16'b0);

endmodule

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
typedef struct packed {
	logic clock; // O clock usado no canal.
	logic last; // Indica se este é o último canal.
	logic pass; // Indica se esta é a segunda passagem.
} ChannelInfo;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
typedef logic signed [15:0] Sample;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
typedef struct packed {
	OscillatorData oscillator;
	DigitalFilterData filter;
	EnvelopeData envelope;
	Sample sample;
} ChannelData;
