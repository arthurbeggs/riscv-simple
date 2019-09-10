// Autor: Lucas Neves Carvalho
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
module NoteController
(
	input RESET,
	input ChannelInfo CHANNEL,
	input EnvelopeData ENVELOPE,
	input NoteData COMMAND,
	input NoteData NOTE,
	output NoteData oNOTE
);

// --- Processa comandos
reg state = 1'b0;
reg working = 1'b1;
reg [6:0] pitch = 7'b0;

always @(posedge CHANNEL.clock)
	if (CHANNEL.last && CHANNEL.pass) begin
		state <= COMMAND.state;
		pitch <= COMMAND.pitch;
	end
	
always @(posedge CHANNEL.clock) begin
	oNOTE.pitch <= replace ? pitch : NOTE.pitch;
	oNOTE.state <= ~RESET & (replace ? state : NOTE.state);
	working <= working ? ~replace | ~state : CHANNEL.last & CHANNEL.pass;
end

wire replace = working && (CHANNEL.pass && state && &ENVELOPE.instant || NOTE.pitch == pitch);

endmodule

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
module NoteInfoDatabase
(
	input ChannelInfo CHANNEL,
	input NoteData NOTE,
	output NoteInfo OUT
);

// --- Lê a frequência
NoteTable noteTable
(
	.address(NOTE.pitch),
	.clock(CHANNEL.clock),
	.q(OUT.step)
);

always @(posedge CHANNEL.clock)
	OUT.state <= NOTE.state;

endmodule

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
typedef struct packed {
	logic [15:0] step;
	logic state;
} NoteInfo;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
typedef struct packed {
	logic [6:0] pitch;
	logic state;
} NoteData;
