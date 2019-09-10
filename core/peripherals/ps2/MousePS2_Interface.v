module MousePS2_Interface(
	input iCLK,
	input iCLK_50,
	input Reset,
	inout PS2_KBCLK,	
 	inout PS2_KBDAT,
	//  Barramento de IO
	input wReadEnable, wWriteEnable,
	input [3:0] wByteEnable,
	input [31:0] wAddress, wWriteData,
	output [31:0] wReadData,
	// Interrupcao
	output reg reg_mouse_keyboard,
	output received_data_en_contador_enable
);

assign reg_mouse_keyboard = 1'b0; //  ?????

reg [7:0] received_data_history[3:0];
wire received_data_en;

reg received_data_en_contador_enable_xor1,received_data_en_contador_enable_xor2;
//wire received_data_en_contador_enable;
int received_data_en_contador;

assign received_data_en_contador_enable=received_data_en_contador_enable_xor1^received_data_en_contador_enable_xor2;

initial
	begin
		received_data_en_contador<=0;
		received_data_en_contador_enable_xor1<=1'b1;
		received_data_en_contador_enable_xor2<=1'b1;
	end

always @(negedge received_data_en)
	begin
		received_data_en_contador_enable_xor1<=~received_data_en_contador_enable_xor1;
	end

always @(posedge iCLK)
	begin
		if(received_data_en_contador_enable)
			begin
				received_data_en_contador=received_data_en_contador+1;
				if(received_data_en_contador==2)
					begin
						received_data_en_contador=0;
						received_data_en_contador_enable_xor2=received_data_en_contador_enable_xor1;
					end
			end
	end

//reg reg_mouse_keyboard;

mouse_hugo mouse1(
	.CLOCK_50(iCLK_50),
	.reset(Reset),
	// Bidirectionals
	.PS2_CLK(PS2_KBCLK),					// PS2 Clock
 	.PS2_DAT(PS2_KBDAT),					// PS2 Data

	// Outputs
	.received_data_history(received_data_history),
	.received_data_en(received_data_en),			// If 1 - new data has been received
	.command_auto(command_auto)
);

wire command_auto;

	always @(*)
		if(wReadEnable)
			if(wAddress==BUFFERMOUSE_ADDRESS) wReadData <= {received_data_history[3],received_data_history[2],received_data_history[1],received_data_history[0]};
			else wReadData <= 32'hzzzzzzzz;
		else wReadData <= 32'hzzzzzzzz;


////////////////////////////////////Fim 2013/2

endmodule
