module IrDA_decoder(
	 //IrDA data
    input         iCLK_50,
    input         iCLK,
    input         Reset,
    input         iIRDA_RXD,    //    IrDA Receiver
	 //IO
	 input  [31:0] wAddress,
	 output [31:0] oCode,
		 //output [31:0] oCode_temp,
		 //output [31:0] oOutput,
		 //output        odata_ready,
		 //output        odata_ready_buf,
		 //output        owritten,
		 //output  [3:0] ocommand,
		 //output  [2:0] ocontrol,
	 input         wReadEnable,
	 input [1:0]   iselect //seleciona entre IRDABYTE, IRDAHALFWORD, IRDAWORD
);

wire [3:0] command;     //qual eh o comando? (botao apertado)
wire [2:0] control;     //qual o controle que enviou o sinal?
wire invalid;           //Se o controle ou comando nao esta registrado

wire [31:0] irda_code;  //valor recebido pelo IrDA
wire data_ready;

wire [15:0] instrucao;  //Para o registrador de saida
wire [15:0] controle;  //Para o registrador de saida

//reg [31:0] CodeData;
reg [31:0] Output;

reg  [7:0] data_ready_count;
wire [7:0] data_ready_begin;
wire [7:0] data_ready_end;

assign data_ready_begin = 8'h30;
assign data_ready_end = 8'h3A;

reg written;
reg data_ready_buf;

//assign owritten = written;
//assign ocontrol = control;
//assign ocommand = command;
//assign odata_ready_buf = data_ready_buf;
//assign odata_ready = data_ready;
//assign oCode_temp = {instrucao, controle};
//assign oOutput = Output;

initial
begin
	//CodeData <= 32'h00000000;
	Output <= 32'h80000000;
	written <= 1'b0;
	data_ready_count <= 8'b0;
end

//Instrucao
//BIT: 15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
//     in NU NU NU NU NU NU NU NU NU cm cm cm cm  0  0
//legenda: in = bit de invalido, controle ou comando que nao existe
//NU = bit nao utilizado (default = 0)
//cm = command

//`ifndef PIPELINE
assign instrucao = {invalid, 9'b0, command, 2'b0};
//`endif
//`ifdef PIPELINE
//assign instrucao = {invalid, 8'b0, command, 3'b0};
//`endif

always @(*) begin
	case (iselect)
		IRDABYTE:
			controle <= {13'b0, control};
		IRDAHALFWORD:
			controle <= {12'b0, control, 1'b0};
		IRDAWORD:
			controle <= {11'b0, control, 2'b0};
		default:
			controle <= {13'b0, control};
	endcase
end

always @(posedge iCLK) begin
	if(~data_ready)
		data_ready_count <= 8'b0;
	else if (data_ready_count < data_ready_end)
		data_ready_count <= data_ready_count + 1'b1;
	else
		data_ready_count <= 1'b0;
	
	if (data_ready_count >= data_ready_begin && data_ready_count < data_ready_end)
		data_ready_buf <= 1'b1;
	else
		data_ready_buf <= 1'b0;
end

always @(posedge iCLK) begin
		if (wReadEnable && wAddress == IRDA_DECODER_ADDRESS)
			Output = 32'h80000000; //invalid
		else if (data_ready_buf && !written)
			begin
				//Output <= CodeData;
				Output <= {instrucao, controle};
				written <= 1'b1;
			end
		if (!data_ready_buf)
			written <= 1'b0;
end

always @(*) begin
		if (wReadEnable && wAddress == IRDA_DECODER_ADDRESS)
				oCode <= Output;
		else
			oCode <= 32'hzzzzzzzz;
end

/*
always @(*)
	if (wReadEnable)
		begin
			if (wAddress == IRDA_DECODER_ADDRESS)
				oCode <= {instrucao, controle};
			else
				oCode <= 32'hzzzzzzzz;
		end
	else
		oCode <= 32'hzzzzzzzz;
*/

//Le o que foi recebido pelo IrDA
IrDA_Interface irda(
	.iCLK_50(iCLK_50),
	.iCLK(iCLK),
	.Reset(Reset),
	.iIRDA_RXD(iIRDA_RXD),
	.wReadEnable(1'b1),
	.wWriteEnable(1'b0),
	.wByteEnable(4'b0000), //NAO FAZ A MENOR DIFERENCA
	.wAddress(IRDA_READ_ADDRESS),
	.wWriteData(32'h00000000),
	.wReadData(irda_code),
	.oDATA_READY(data_ready)
);

always @(*) begin
	case(irda_code[15:0])
		CONTROL1:
			begin
				control <= 3'd0;
				case (irda_code[31:16])
					CON1COMMAND1:
						begin
							invalid <= 1'b0;
							command <= 4'd0;
						end
					CON1COMMAND2:
						begin
							invalid <= 1'b0;
							command <= 4'd1;
						end
					CON1COMMAND3:
						begin
							invalid <= 1'b0;
							command <= 4'd2;
						end
					CON1COMMAND4:
						begin
							invalid <= 1'b0;
							command <= 4'd3;
						end
					CON1COMMAND5:
						begin
							invalid <= 1'b0;
							command <= 4'd4;
						end
					CON1COMMAND6:
						begin
							invalid <= 1'b0;
							command <= 4'd5;
						end
					CON1COMMAND7:
						begin
							invalid <= 1'b0;
							command <= 4'd6;
						end
					CON1COMMAND8:
						begin
							invalid <= 1'b0;
							command <= 4'd7;
						end
					CON1COMMAND9:
						begin
							invalid <= 1'b0;
							command <= 4'd8;
						end
					CON1COMMAND10:
						begin
							invalid <= 1'b0;
							command <= 4'd9;
						end
					CON1COMMAND11:
						begin
							invalid <= 1'b0;
							command <= 4'd10;
						end
					CON1COMMAND12:
						begin
							invalid <= 1'b0;
							command <= 4'd11;
						end
					CON1COMMAND13:
						begin
							invalid <= 1'b0;
							command <= 4'd12;
						end
					CON1COMMAND14:
						begin
							invalid <= 1'b0;
							command <= 4'd13;
						end
					CON1COMMAND15:
						begin
							invalid <= 1'b0;
							command <= 4'd14;
						end
					CON1COMMAND16:
						begin
							invalid <= 1'b0;
							command <= 4'd15;
						end
					default:
						begin
							invalid <= 1'b1;
							command <= 4'd0; //desnecessario
						end
				endcase
			end
		CONTROL2:
			begin
				control <= 3'd1;
				case (irda_code[31:16])
					CON2COMMAND1:
						begin
							invalid <= 1'b0;
							command <= 4'd0;
						end
					CON2COMMAND2:
						begin
							invalid <= 1'b0;
							command <= 4'd1;
						end
					CON2COMMAND3:
						begin
							invalid <= 1'b0;
							command <= 4'd2;
						end
					CON2COMMAND4:
						begin
							invalid <= 1'b0;
							command <= 4'd3;
						end
					CON2COMMAND5:
						begin
							invalid <= 1'b0;
							command <= 4'd4;
						end
					CON2COMMAND6:
						begin
							invalid <= 1'b0;
							command <= 4'd5;
						end
					CON2COMMAND7:
						begin
							invalid <= 1'b0;
							command <= 4'd6;
						end
					CON2COMMAND8:
						begin
							invalid <= 1'b0;
							command <= 4'd7;
						end
					CON2COMMAND9:
						begin
							invalid <= 1'b0;
							command <= 4'd8;
						end
					CON2COMMAND10:
						begin
							invalid <= 1'b0;
							command <= 4'd9;
						end
					CON2COMMAND11:
						begin
							invalid <= 1'b0;
							command <= 4'd10;
						end
					CON2COMMAND12:
						begin
							invalid <= 1'b0;
							command <= 4'd11;
						end
					CON2COMMAND13:
						begin
							invalid <= 1'b0;
							command <= 4'd12;
						end
					CON2COMMAND14:
						begin
							invalid <= 1'b0;
							command <= 4'd13;
						end
					CON2COMMAND15:
						begin
							invalid <= 1'b0;
							command <= 4'd14;
						end
					CON2COMMAND16:
						begin
							invalid <= 1'b0;
							command <= 4'd15;
						end
					default:
						begin
							invalid <= 1'b1;
							command <= 4'd0; //desnecessario
						end
				endcase
			end
		CONTROL3:
			begin
				control <= 3'd2;
				case (irda_code[31:16])
					CON3COMMAND1:
						begin
							invalid <= 1'b0;
							command <= 4'd0;
						end
					CON3COMMAND2:
						begin
							invalid <= 1'b0;
							command <= 4'd1;
						end
					CON3COMMAND3:
						begin
							invalid <= 1'b0;
							command <= 4'd2;
						end
					CON3COMMAND4:
						begin
							invalid <= 1'b0;
							command <= 4'd3;
						end
					CON3COMMAND5:
						begin
							invalid <= 1'b0;
							command <= 4'd4;
						end
					CON3COMMAND6:
						begin
							invalid <= 1'b0;
							command <= 4'd5;
						end
					CON3COMMAND7:
						begin
							invalid <= 1'b0;
							command <= 4'd6;
						end
					CON3COMMAND8:
						begin
							invalid <= 1'b0;
							command <= 4'd7;
						end
					CON3COMMAND9:
						begin
							invalid <= 1'b0;
							command <= 4'd8;
						end
					CON3COMMAND10:
						begin
							invalid <= 1'b0;
							command <= 4'd9;
						end
					CON3COMMAND11:
						begin
							invalid <= 1'b0;
							command <= 4'd10;
						end
					CON3COMMAND12:
						begin
							invalid <= 1'b0;
							command <= 4'd11;
						end
					CON3COMMAND13:
						begin
							invalid <= 1'b0;
							command <= 4'd12;
						end
					CON3COMMAND14:
						begin
							invalid <= 1'b0;
							command <= 4'd13;
						end
					CON3COMMAND15:
						begin
							invalid <= 1'b0;
							command <= 4'd14;
						end
					CON3COMMAND16:
						begin
							invalid <= 1'b0;
							command <= 4'd15;
						end
					default:
						begin
							invalid <= 1'b1;
							command <= 4'd0; //desnecessario
						end
				endcase
			end
		CONTROL4:
			begin
				control <= 3'd3;
				case (irda_code[31:16])
					CON4COMMAND1:
						begin
							invalid <= 1'b0;
							command <= 4'd0;
						end
					CON4COMMAND2:
						begin
							invalid <= 1'b0;
							command <= 4'd1;
						end
					CON4COMMAND3:
						begin
							invalid <= 1'b0;
							command <= 4'd2;
						end
					CON4COMMAND4:
						begin
							invalid <= 1'b0;
							command <= 4'd3;
						end
					CON4COMMAND5:
						begin
							invalid <= 1'b0;
							command <= 4'd4;
						end
					CON4COMMAND6:
						begin
							invalid <= 1'b0;
							command <= 4'd5;
						end
					CON4COMMAND7:
						begin
							invalid <= 1'b0;
							command <= 4'd6;
						end
					CON4COMMAND8:
						begin
							invalid <= 1'b0;
							command <= 4'd7;
						end
					CON4COMMAND9:
						begin
							invalid <= 1'b0;
							command <= 4'd8;
						end
					CON4COMMAND10:
						begin
							invalid <= 1'b0;
							command <= 4'd9;
						end
					CON4COMMAND11:
						begin
							invalid <= 1'b0;
							command <= 4'd10;
						end
					CON4COMMAND12:
						begin
							invalid <= 1'b0;
							command <= 4'd11;
						end
					CON4COMMAND13:
						begin
							invalid <= 1'b0;
							command <= 4'd12;
						end
					CON4COMMAND14:
						begin
							invalid <= 1'b0;
							command <= 4'd13;
						end
					CON4COMMAND15:
						begin
							invalid <= 1'b0;
							command <= 4'd14;
						end
					CON4COMMAND16:
						begin
							invalid <= 1'b0;
							command <= 4'd15;
						end
					default:
						begin
							invalid <= 1'b1;
							command <= 4'd0; //desnecessario
						end
				endcase
			end
		CONTROL5:
			begin
				control <= 3'd4;
				case (irda_code[31:16])
					CON5COMMAND1:
						begin
							invalid <= 1'b0;
							command <= 4'd0;
						end
					CON5COMMAND2:
						begin
							invalid <= 1'b0;
							command <= 4'd1;
						end
					CON5COMMAND3:
						begin
							invalid <= 1'b0;
							command <= 4'd2;
						end
					CON5COMMAND4:
						begin
							invalid <= 1'b0;
							command <= 4'd3;
						end
					CON5COMMAND5:
						begin
							invalid <= 1'b0;
							command <= 4'd4;
						end
					CON5COMMAND6:
						begin
							invalid <= 1'b0;
							command <= 4'd5;
						end
					CON5COMMAND7:
						begin
							invalid <= 1'b0;
							command <= 4'd6;
						end
					CON5COMMAND8:
						begin
							invalid <= 1'b0;
							command <= 4'd7;
						end
					CON5COMMAND9:
						begin
							invalid <= 1'b0;
							command <= 4'd8;
						end
					CON5COMMAND10:
						begin
							invalid <= 1'b0;
							command <= 4'd9;
						end
					CON5COMMAND11:
						begin
							invalid <= 1'b0;
							command <= 4'd10;
						end
					CON5COMMAND12:
						begin
							invalid <= 1'b0;
							command <= 4'd11;
						end
					CON5COMMAND13:
						begin
							invalid <= 1'b0;
							command <= 4'd12;
						end
					CON5COMMAND14:
						begin
							invalid <= 1'b0;
							command <= 4'd13;
						end
					CON5COMMAND15:
						begin
							invalid <= 1'b0;
							command <= 4'd14;
						end
					CON5COMMAND16:
						begin
							invalid <= 1'b0;
							command <= 4'd15;
						end
					default:
						begin
							invalid <= 1'b1;
							command <= 4'd0; //desnecessario
						end
				endcase
			end
		CONTROL6:
			begin
				control <= 3'd5;
				case (irda_code[31:16])
					CON6COMMAND1:
						begin
							invalid <= 1'b0;
							command <= 4'd0;
						end
					CON6COMMAND2:
						begin
							invalid <= 1'b0;
							command <= 4'd1;
						end
					CON6COMMAND3:
						begin
							invalid <= 1'b0;
							command <= 4'd2;
						end
					CON6COMMAND4:
						begin
							invalid <= 1'b0;
							command <= 4'd3;
						end
					CON6COMMAND5:
						begin
							invalid <= 1'b0;
							command <= 4'd4;
						end
					CON6COMMAND6:
						begin
							invalid <= 1'b0;
							command <= 4'd5;
						end
					CON6COMMAND7:
						begin
							invalid <= 1'b0;
							command <= 4'd6;
						end
					CON6COMMAND8:
						begin
							invalid <= 1'b0;
							command <= 4'd7;
						end
					CON6COMMAND9:
						begin
							invalid <= 1'b0;
							command <= 4'd8;
						end
					CON6COMMAND10:
						begin
							invalid <= 1'b0;
							command <= 4'd9;
						end
					CON6COMMAND11:
						begin
							invalid <= 1'b0;
							command <= 4'd10;
						end
					CON6COMMAND12:
						begin
							invalid <= 1'b0;
							command <= 4'd11;
						end
					CON6COMMAND13:
						begin
							invalid <= 1'b0;
							command <= 4'd12;
						end
					CON6COMMAND14:
						begin
							invalid <= 1'b0;
							command <= 4'd13;
						end
					CON6COMMAND15:
						begin
							invalid <= 1'b0;
							command <= 4'd14;
						end
					CON6COMMAND16:
						begin
							invalid <= 1'b0;
							command <= 4'd15;
						end
					default:
						begin
							invalid <= 1'b1;
							command <= 4'd0; //desnecessario
						end
				endcase
			end
		CONTROL7:
			begin
				control <= 3'd6;
				case (irda_code[31:16])
					CON7COMMAND1:
						begin
							invalid <= 1'b0;
							command <= 4'd0;
						end
					CON7COMMAND2:
						begin
							invalid <= 1'b0;
							command <= 4'd1;
						end
					CON7COMMAND3:
						begin
							invalid <= 1'b0;
							command <= 4'd2;
						end
					CON7COMMAND4:
						begin
							invalid <= 1'b0;
							command <= 4'd3;
						end
					CON7COMMAND5:
						begin
							invalid <= 1'b0;
							command <= 4'd4;
						end
					CON7COMMAND6:
						begin
							invalid <= 1'b0;
							command <= 4'd5;
						end
					CON7COMMAND7:
						begin
							invalid <= 1'b0;
							command <= 4'd6;
						end
					CON7COMMAND8:
						begin
							invalid <= 1'b0;
							command <= 4'd7;
						end
					CON7COMMAND9:
						begin
							invalid <= 1'b0;
							command <= 4'd8;
						end
					CON7COMMAND10:
						begin
							invalid <= 1'b0;
							command <= 4'd9;
						end
					CON7COMMAND11:
						begin
							invalid <= 1'b0;
							command <= 4'd10;
						end
					CON7COMMAND12:
						begin
							invalid <= 1'b0;
							command <= 4'd11;
						end
					CON7COMMAND13:
						begin
							invalid <= 1'b0;
							command <= 4'd12;
						end
					CON7COMMAND14:
						begin
							invalid <= 1'b0;
							command <= 4'd13;
						end
					CON7COMMAND15:
						begin
							invalid <= 1'b0;
							command <= 4'd14;
						end
					CON7COMMAND16:
						begin
							invalid <= 1'b0;
							command <= 4'd15;
						end
					default:
						begin
							invalid <= 1'b1;
							command <= 4'd0; //desnecessario
						end
				endcase
			end
		CONTROL8:
			begin
				control <= 3'd7;
				case (irda_code[31:16])
					CON8COMMAND1:
						begin
							invalid <= 1'b0;
							command <= 4'd0;
						end
					CON8COMMAND2:
						begin
							invalid <= 1'b0;
							command <= 4'd1;
						end
					CON8COMMAND3:
						begin
							invalid <= 1'b0;
							command <= 4'd2;
						end
					CON8COMMAND4:
						begin
							invalid <= 1'b0;
							command <= 4'd3;
						end
					CON8COMMAND5:
						begin
							invalid <= 1'b0;
							command <= 4'd4;
						end
					CON8COMMAND6:
						begin
							invalid <= 1'b0;
							command <= 4'd5;
						end
					CON8COMMAND7:
						begin
							invalid <= 1'b0;
							command <= 4'd6;
						end
					CON8COMMAND8:
						begin
							invalid <= 1'b0;
							command <= 4'd7;
						end
					CON8COMMAND9:
						begin
							invalid <= 1'b0;
							command <= 4'd8;
						end
					CON8COMMAND10:
						begin
							invalid <= 1'b0;
							command <= 4'd9;
						end
					CON8COMMAND11:
						begin
							invalid <= 1'b0;
							command <= 4'd10;
						end
					CON8COMMAND12:
						begin
							invalid <= 1'b0;
							command <= 4'd11;
						end
					CON8COMMAND13:
						begin
							invalid <= 1'b0;
							command <= 4'd12;
						end
					CON8COMMAND14:
						begin
							invalid <= 1'b0;
							command <= 4'd13;
						end
					CON8COMMAND15:
						begin
							invalid <= 1'b0;
							command <= 4'd14;
						end
					CON8COMMAND16:
						begin
							invalid <= 1'b0;
							command <= 4'd15;
						end
					default:
						begin
							invalid <= 1'b1;
							command <= 4'd0; //desnecessario
						end
				endcase
			end
		default:
			begin
				control <= 3'd0; //desncessario
				invalid <= 1'b1;
				command <= 4'd0; //desnecessario
			end
	endcase
end

endmodule
