module mouse_hugo(
	CLOCK_50,
	reset,
	// Bidirectionals
	PS2_CLK,					// PS2 Clock
 	PS2_DAT,					// PS2 Data

	// Outputs
	received_data_history,
	received_data_en,			// If 1 - new data has been received
	command_auto
);

//Input
input CLOCK_50;
input wire reset;
//Inout
inout PS2_CLK,PS2_DAT;
//Output
output [7:0] received_data_history[3:0];
output received_data_en;

reg [7:0] received_data;
wire command_was_sent,error_communication_timed_out;
reg [7:0] received_data_history_raw[3:0];

wire send_command;
reg [7:0]the_command;
output command_auto;
reg set_command_auto_trigger,reset_command_auto_trigger;

initial
begin
set_command_auto_trigger<=1'b0;
reset_command_auto_trigger<=1'b1;
end

assign send_command=command_auto;
assign the_command=8'hF4;

assign command_auto=(set_command_auto_trigger)^(reset_command_auto_trigger);



initial
begin
received_data_history[0]<=8'b00000000;
received_data_history[1]<=8'b00000000;
received_data_history[2]<=8'b00000000;
received_data_history[3]<=8'b00000000;

received_data_history_raw[0]<=8'b00000000;
received_data_history_raw[1]<=8'b00000000;
received_data_history_raw[2]<=8'b00000000;
received_data_history_raw[3]<=8'b00000000;
end

always @(posedge received_data_en)
begin
received_data_history_raw[3]=received_data_history_raw[2];
received_data_history_raw[2]=received_data_history_raw[1];
received_data_history_raw[1]=received_data_history_raw[0];
received_data_history_raw[0]=received_data;

end

PS2_Controller CONT_1 (
	// Inputs
	.CLOCK_50(CLOCK_50),
	.reset(reset),

	.the_command(the_command),
	.send_command(send_command),

	// Bidirectionals
	.PS2_CLK(PS2_CLK),					// PS2 Clock
 	.PS2_DAT(PS2_DAT),					// PS2 Data

	// Outputs
	.command_was_sent(command_was_sent),
	.error_communication_timed_out(error_communication_timed_out),

	.received_data(received_data),
	.received_data_en(received_data_en)			// If 1 - new data has been received
);



always @(negedge received_data_en)
begin
if(received_data_history_raw[0]==8'h00&&received_data_history_raw[1]==8'hAA)
begin
set_command_auto_trigger<=~set_command_auto_trigger;
end

if(received_data_history_raw[0]==8'hF4&&received_data_history_raw[1]==8'hF4&&received_data_history_raw[2]==8'h00&&received_data_history_raw[3]==8'hAA||
   received_data_history_raw[0]==8'hF4&&received_data_history_raw[1]==8'hF4&&received_data_history_raw[2]==8'h00&&received_data_history_raw[3]==8'h00)
begin
set_alinhador_trigger<=1'b0;
end
end

int contador;
initial
begin
contador=0;
end

always @(posedge CLOCK_50)
begin
if(command_auto)
begin
contador=contador+1;
if(contador==100)
begin
reset_command_auto_trigger=set_command_auto_trigger;
contador=0;
end
end
end


int contador_alinhador;
initial
contador_alinhador<=0;

reg set_alinhador_trigger,reset_alinhador_trigger;
initial
begin
set_alinhador_trigger=1'b1;
reset_alinhador_trigger=1'b1;
end

wire alinhador;
assign alinhador=set_alinhador_trigger^reset_alinhador_trigger;

always @(negedge received_data_en)
begin
if(received_data_history_raw[0]==8'hF4&&received_data_history_raw[1]==8'hF4&&received_data_history_raw[2]==8'h00&&received_data_history_raw[3]==8'hAA)
begin
contador_alinhador=0;
end
else if(alinhador)
begin
contador_alinhador=contador_alinhador+1;
if(contador_alinhador==3)
begin
contador_alinhador=0;
received_data_history[3]=received_data_history_raw[3];
received_data_history[2]=received_data_history_raw[2];
received_data_history[1]=received_data_history_raw[1];
received_data_history[0]=received_data_history_raw[0];
end
end
end

endmodule
