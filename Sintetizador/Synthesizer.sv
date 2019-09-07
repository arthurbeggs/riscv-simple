// Autor: Lucas Neves Carvalho
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
module SampleSynthesizer
(
	input SynthesizerConfiguration CONFIG,
	input ChannelInfo CHANNEL,
	input NoteInfo INFO,
	input ChannelData DATA,
	output ChannelData oDATA
);

// --- Oscilador.
Oscillator oscillator
(
	.CONFIG(CONFIG.oscillator),
	.CHANNEL,
	.INFO,
	.SINE(sine),
	.DATA(DATA.oscillator),
	.oDATA(oDATA.oscillator),
	.OUT(sample)
);

wire signed [15:0] sample;

// --- Filtro.
DigitalFilter digitalFilter
(
	.CONFIG(CONFIG.filter),
	.CHANNEL,
	.SINE(sine),
	.DATA(DATA.filter),
	.oDATA(oDATA.filter),
	.IN(CHANNEL.pass ? DATA.sample : sample),
	.OUT(filtered_sample)
);

wire signed [15:0] filtered_sample;

// --- Envelope.
Envelope envelope
(
	.CONFIG(CONFIG.envelope),
	.CHANNEL,
	.INFO,
	.DATA(DATA.envelope),
	.oDATA(oDATA.envelope),
	.OUT(env)
);

wire [7:0] env;
wire [23:0] aux1;
assign aux1={ { 8 { DATA.sample[15] } }, DATA.sample } * env >> 8;
// --- Saída.
always @(posedge CHANNEL.clock)
	if (CHANNEL.pass)
//		oDATA.sample <= { { 8 { DATA.sample[15] } }, DATA.sample } * env >> 8;
		oDATA.sample <= aux1[15:0];
	else
		oDATA.sample <= filtered_sample;
		
// --- Seno.
SineCalculator sineCalculator
(
	.CLK(~CHANNEL.clock),
	.ANGLE(CHANNEL.pass ? DigitalFilterSine::Angle(INFO) : OscillatorSine::Angle(DATA.oscillator)),
	.OUT(sine)
);

Sample sine;

endmodule

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
module PolyphonicSynthesizer
(
	input SAMPLE_CLK, // O clock de amostragem.
	input FASTER_CLK, // Um clock 64x mais rápido que SAMPLE_CLK.
	input NoteData COMMAND, // O comando a ser tratado.
	input SynthesizerConfiguration CONFIG, // Configurações.
	output Sample OUT // Uma amostra, deve ser lida na borda de subida do SAMPLE_CLK.
);

// --- Canais.
ChannelInfo channelInfo;
ChannelData channelData[0:7];

ChannelBank channelBank(.CLK(FASTER_CLK), .CHANNEL(channelInfo));

// --- Notas.
NoteData noteData[0:7];

NoteController noteController
(
	.RESET(1'b0),
	.CHANNEL(channelInfo),
	.ENVELOPE(channelData[7].envelope),
	.COMMAND,
	.NOTE(noteData[7]),
	.oNOTE(noteData[0])
);

// --- Informações da nota.
NoteInfo noteInfo;

NoteInfoDatabase noteInfoDatabase
(
	.CHANNEL(channelInfo),
	.NOTE(noteData[6]),
	.OUT(noteInfo)
);

// --- Síntese.
SampleSynthesizer sampleSynthesizer
(
	.CONFIG,
	.CHANNEL(channelInfo),
	.INFO(noteInfo),
	.DATA(channelData[7]),
	.oDATA(channelData[0])
);

// --- Mixagem dos canais.
Mixer mixer
(
	.EN(1'b1),
	.CHANNEL(channelInfo),
	.SAMPLE(channelData[7].sample),
	.OUT(OUT)
);

// --- Rotação de canais.
generate
	genvar i;
	
	for (i = 0; i < 7; i = i + 1) begin : channelRotation
		always @(posedge channelInfo.clock) begin
			channelData[i + 1] <= channelData[i];
			noteData[i + 1] <= noteData[i];
		end
	end
endgenerate

endmodule

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
typedef struct packed {
	OscillatorConfiguration oscillator;
	DigitalFilterConfiguration filter;
	EnvelopeConfiguration envelope;
} SynthesizerConfiguration;
