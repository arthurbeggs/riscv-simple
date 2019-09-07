module Sintetizador
(
	/*
	 * Entradas do CODEC de áudio da própria DE2.
	 */
	input wire AUD_DACLRCK,
	input wire AUD_BCLK,
	
	/*
	 * Comando de início/fim de uma nota.
	 */
	input wire NOTE_PLAY,			// 1: Iniciará a nota definida por NOTE_PITCH; 0: Terminará a nota definida por NOTE_PITCH.
	input wire [6:0] NOTE_PITCH,	// O índice da nota a ser iniciada/terminada, como definido no padrão MIDI.
	
	/*
	 * Configurações do oscilador.
	 */
	input wire [1:0] WAVE,	// Define a forma de onda das notas:
							// 0 - Mudo; 1 - Senoide; 2 - Quadrada; 3 - Dente de serra.
	input wire NOISE_EN,	// Ativa (1) ou desativa (0) a geração de ruído na saída do oscilador.
	
	/*
	 * Configurações do filtro.
	 */
	input wire FILTER_EN,	// Ativa (1) ou desativa (0) a filtragem na saída do oscilador.
	input wire [7:0] FILTER_QUALITY,	// O fator de qualidade do filtro. (ponto fixo Q8)
	
	/*
	 * Configurações do envelope aplicado durante a vida de uma nota.
	 */
	input wire [6:0] ATTACK_DURATION,	// Duração da fase de Attack da nota.
	input wire [6:0] DECAY_DURATION,	// Duração da fase de Decay da nota.
	input wire [6:0] SUSTAIN_AMPLITUDE,	// Amplitude da fase de Sustain da nota.
	input wire [6:0] RELEASE_DURATION,	// Duração da fase de Release da nota.
	
	/*
	 * Amostra de saída do sintetizador.
	 */
	output reg [15:0] SAMPLE_OUT
);

// --- Buffered output
wire [15:0] sample;

always @(posedge AUD_DACLRCK)
	SAMPLE_OUT <= sample;
	
// --- Note
NoteData noteData;

assign noteData.state = NOTE_PLAY;
assign noteData.pitch = NOTE_PITCH;

// --- Configuration
SynthesizerConfiguration synthConfig;

assign synthConfig.oscillator.wave = WAVE;
assign synthConfig.oscillator.noise = NOISE_EN;

assign synthConfig.filter.q = FILTER_QUALITY;
assign synthConfig.filter.on = FILTER_EN;

assign synthConfig.envelope.attack_duration = ATTACK_DURATION;
assign synthConfig.envelope.decay_duration = DECAY_DURATION;
assign synthConfig.envelope.sustain_amplitude = SUSTAIN_AMPLITUDE;
assign synthConfig.envelope.release_duration = RELEASE_DURATION;

// --- Synthesizer
PolyphonicSynthesizer synth
(
	.SAMPLE_CLK(AUD_DACLRCK),
	.FASTER_CLK(AUD_BCLK),
	.COMMAND(noteData),
	.CONFIG(synthConfig),
	.OUT(sample)
);

endmodule
