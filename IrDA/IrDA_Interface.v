// Relatorio questao B.10) - Grupo 2 - (2/2016)

module IrDA_Interface(
    input         iCLK_50,
    input         iCLK,
    input         Reset,
    output        oIRDA_TXD,    //    IrDA Transmitter
    input         iIRDA_RXD,    //    IrDA Receiver
    //  Barramento de IO
    input         wReadEnable, wWriteEnable,
    input  [3:0]  wByteEnable,
    input  [31:0] wAddress, wWriteData,
	 output oDATA_READY,
    output [31:0] wReadData
);

assign oIRDA_TXD=1'b0; //não tem TX
wire 			data_ready;
reg 			[31:0] data;
//reg 			[31:0] control;



//IrDA_transmitter IrDAtx();
IrDA_receiver IrDArx(
	.iCLK(iCLK_50),       		 //clk 50MHz
	.iRST_n(1'b1),       		 //reset nao esta ativado, pois o reset ja reseta o processador
	.iIRDA(iIRDA_RXD),          //IR code input
	.oDATA_READY(data_ready),   //data ready
	.oDATA(data)    		       //decode data output
);

//assign oDATA_READY = data_ready;

/*
always @ ( posedge iCLK ) begin
	if (wWriteEnable) begin
		if (wAddress == IRDA_CONTROL_ADDRESS) begin
			control <= wWriteData;
		end
	end
end
*/

always @(*) begin
	if(wReadEnable)
		if(wAddress == IRDA_READ_ADDRESS) 
			begin
				wReadData = data;
				oDATA_READY = data_ready;
			end
		else 
			if(wAddress == IRDA_CONTROL_ADDRESS) 
				begin
					wReadData <= 32'b0;//{31'b0,busy};	
					oDATA_READY = 1'b0;
				end
			else 
				begin
					wReadData <= 32'hzzzzzzzz;
					oDATA_READY <= 1'b0;
				end
	else 
		begin
			wReadData <= 32'hzzzzzzzz;
			oDATA_READY = 1'b0;
		end
end	
	
// ******** para selecionar por controle ******* \\
// Se for usar esse codigo, lembrar que tem que 
// colocar no case de data[15:0] os bits mais significativos 
// dos controles de voces
// Isto serve para que se for usar multiplos controles a quantidade
// de interferencias entre eles diminua, nessa configuracao cada controle
// vai ter um endereco de memorio proprio, porem para vc ler esse endereco,
// tem que se passado antes pelo CONTROL_ADDRESS qual esta querendo ler.

//reg   [31:0] player_one;
//reg   [31:0] player_two;
//reg   [31:0] player_three;
//reg   [31:0] player_four;
//
//codigo dos controles usados
//always @ ( posedge iCLK ) begin
//	if(data_ready)
//		case (data[15:0])
//			16'h7F80: player_one = data;
//			16'h2C2C: player_two = data;
//			16'h2487: player_three = data;
//			16'h46B9: player_four = data;
//			default: ;
//		endcase
//end


//always @(*)
//	if(wReadEnable)
//		begin
//			if (wAddress == IRDA_READ_ADDRESS) begin
//				case (control)
//					0: wReadData = player_one ;
//					1: wReadData = player_two;
//					2: wReadData = player_three;
//					3: wReadData = player_four;
//					default: wReadData = 32'hzzzzzzzz;
//				endcase
//
//			end else if (wAddress == IRDA_CONTROL_ADDRESS) begin
//				wReadData = {31'b0,busy};
//			end else begin
//				wReadData = 32'hzzzzzzzz;
//			end
//		end
//	else wReadData = 32'hzzzzzzzz;

// ********************************************** \\






/////////////////////// TX //////////////////////
// TX nao suportado na DE2-70
//reg				busy;
//reg 			[31:0] txdata;
//wire			txstart;
//wire 			irClk;
//
//
//IrDA_clk irCLOCK(
//	.clk(iCLK_50),
//	.new_freq(irClk)
//);
//
//
//IrDA_transmitter IrDAtx(
//	.iCLK(iCLK_50),         		//clk 50MHz
//	.SINAL(irClk),
//	.iDATA(txdata),         		//data input
//	.iTXD_READY(txstart),	  		//bit de inicio
//	.oTXD_BUSY(busy),	  			//bit do transmissor enviando dado
//	.oIRDA_TXD(oIRDA_TXD)
//);
//
//
//always @(posedge iCLK)
//	if (wWriteEnable) begin
//		if (wAddress == IRDA_WRITE_ADDRESS) begin
//			txdata <= wWriteData;
//			txstart <= 1'b1;
//		end
//	end else begin
//		txstart <= 1'b0;
//	end
//


endmodule