
`ifndef PARAM
	`include "../Parametros.v"
`endif

`timescale 1 ns / 1 ps

module TopDE_tb;


reg iCLOCK;


always
	#10 iCLOCK = ~iCLOCK;	// T=10+10 Clock de 50MHz

	reg [9:0] iSW;
	reg [3:0] iKEY;
	wire [9:0] oLEDR;
	
	
	 wire          oMClock; //Clock25, Clock50, Clock100;
    wire  [31:0]  oPC;
	 wire  [31:0]  oInstrucao;
    wire  [31:0]  oBR_Leitura1; 
	 wire  [31:0]  oBR_Leitura2; 
	 wire  [31:0]  oBR_Escrita;
	 wire  [31:0]  oSaida_ULA;
    reg   [4:0]   iRegDispSelect;
	 wire  [31:0]  oRegDisp;
	 wire  [31:0]  oRegDispFPU;
    wire  [7:0]   oFlagsFPU;
    wire          oLeMem; 
	 wire 			oEscreveMem;
    wire  [31:0]  oMemD_Endereco; 
	 wire  [31:0]  oMemD_DadoEscrita; 
	 wire  [31:0]  oMemD_DadoLeitura;
    wire  [3:0]   oMemD_ByteEnable;
    wire  [6:0]   oEstado;
	 wire  [31:0]  oDebug;

	 
TopDE top1 (
      .ADC_CS_N(),
      .ADC_DIN(),
      .ADC_DOUT(),
      .ADC_SCLK(),
      .AUD_ADCDAT(),
      .AUD_ADCLRCK(),
      .AUD_BCLK(),
      .AUD_DACDAT(),
      .AUD_DACLRCK(),
      .AUD_XCK(),
      .CLOCK2_50(iCLOCK),
      .CLOCK3_50(iCLOCK),
      .CLOCK4_50(iCLOCK),
      .CLOCK_50(iCLOCK),
      .DRAM_ADDR(),
      .DRAM_BA(),
      .DRAM_CAS_N(),
      .DRAM_CKE(),
      .DRAM_CLK(),
      .DRAM_CS_N(),
      .DRAM_DQ(),
      .DRAM_LDQM(),
      .DRAM_RAS_N(),
      .DRAM_UDQM(),
      .DRAM_WE_N(),
      .FAN_CTRL(),
      .FPGA_I2C_SCLK(),
      .FPGA_I2C_SDAT(),
      .GPIO_0(),
      .GPIO_1(),
      .HEX0(),
      .HEX1(),
      .HEX2(),
      .HEX3(),
      .HEX4(),
      .HEX5(),
		.IRDA_RXD(),
      .IRDA_TXD(),
      .KEY(iKEY),
      .LEDR(oLEDR),
      .PS2_CLK(),
      .PS2_CLK2(),
      .PS2_DAT(),
      .PS2_DAT2(),
      .SW(iSW),
      .TD_CLK27(),
      .TD_DATA(),
      .TD_HS(),
      .TD_RESET_N(),
      .TD_VS(),
      .VGA_B(),
      .VGA_BLANK_N(),
      .VGA_CLK(),
      .VGA_G(),
      .VGA_HS(),
      .VGA_R(),
      .VGA_SYNC_N(),
      .VGA_VS(),

	 .MClock(MClock), //Clock25, Clock50, Clock100,
    .PC(PC), 
	 .Instrucao(oInstrucao),
    .BR_Leitura1(oBR_Leitura1), 
	 .BR_Leitura2(oBR_Leitura2), 
	 .BR_Escrita(oBR_Escrita), 
	 .Saida_ULA(oSaida_ULA), 
    .RegDispSelect(iRegDispSelect),
	 .RegDisp(oRegDisp),
	 .RegDispFPU(oRegDispFPU),
    .FlagsFPU(oFlagsFPU),
    .LeMem(oLeMem), 
	 .EscreveMem(oEscreveMem),
    .MemD_Endereco(oMemD_Endereco), 
	 .MemD_DadoEscrita(oMemD_DadoEscrita), 
	 .MemD_DadoLeitura(oMemD_DadoLeitura),
    .MemD_ByteEnable(oMemD_ByteEnable), 
    .Estado(oEstado),
	 .Debug(oDebug)
		
);	
	

	
initial
	begin
	
		$display($time, " << Inicio da Simulacao >> ");
		iCLOCK=1'b0;
		iSW=10'b0000000010;
		iKEY=4'b1111;
		iRegDispSelect = 5'b01000;
	
		#100
		iKEY=4'b1001;
		
		#400
		iKEY=4'b1111;
		
		#1400
		$display($time, "<< Final da Simulacao >>");
		$stop;
	end

	
initial
	begin			
		$display("time, iClock, Clock, iKEY, PC, Instr, LEDR"); 
		$monitor("%d, %d, %d, %b, %h, %h, %b",$time,iCLOCK, oMClock,iKEY,oPC,oInstrucao,oLEDR);	
	
	end


endmodule
