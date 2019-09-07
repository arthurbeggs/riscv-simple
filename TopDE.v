/* RISC-V v.2.0 */

`ifndef PARAM
	`include "Parametros.v"
`endif

 

module TopDE (
      ///////// ADC Analog-Digital Converter/////////
      inout              ADC_CS_N,
      output             ADC_DIN,
      input              ADC_DOUT,
      output             ADC_SCLK,

      ///////// AUD Audio Codec /////////
      input              AUD_ADCDAT,
      inout              AUD_ADCLRCK,
      inout              AUD_BCLK,
      output             AUD_DACDAT,
      inout              AUD_DACLRCK,
      output             AUD_XCK,

      ///////// CLOCK /////////
      input              CLOCK_50,
      input              CLOCK2_50,
//      input              CLOCK3_50,
//      input              CLOCK4_50,

      ///////// DRAM Syncronous Dynamic RAM/////////
//      output      [12:0] DRAM_ADDR,
//      output      [1:0]  DRAM_BA,
//      output             DRAM_CAS_N,
//      output             DRAM_CKE,
//      output             DRAM_CLK,
//      output             DRAM_CS_N,
//      inout       [15:0] DRAM_DQ,
//      output             DRAM_LDQM,
//      output             DRAM_RAS_N,
//      output             DRAM_UDQM,
//      output             DRAM_WE_N,

      ///////// FAN /////////
//      output             FAN_CTRL,

      ///////// FPGA I2C controler /////////
      output             FPGA_I2C_SCLK,
      inout              FPGA_I2C_SDAT,

      ///////// GPIO Generic Paralel I/O/////////
      inout     [35:0]         GPIO_0,
//    inout     [35:0]         GPIO_1,
 

      ///////// DISPLAYS HEX /////////
      output      [6:0]  HEX0,
      output      [6:0]  HEX1,
      output      [6:0]  HEX2,
      output      [6:0]  HEX3,
      output      [6:0]  HEX4,
      output      [6:0]  HEX5,


      ///////// HPS - Hard Processor System  ARMv7/////////
//      inout              HPS_CONV_USB_N,
//      output      [14:0] HPS_DDR3_ADDR,
//      output      [2:0]  HPS_DDR3_BA,
//      output             HPS_DDR3_CAS_N,
//      output             HPS_DDR3_CKE,
//      output             HPS_DDR3_CK_N,
//      output             HPS_DDR3_CK_P,
//      output             HPS_DDR3_CS_N,
//      output      [3:0]  HPS_DDR3_DM,
//      inout       [31:0] HPS_DDR3_DQ,
//      inout       [3:0]  HPS_DDR3_DQS_N,
//      inout       [3:0]  HPS_DDR3_DQS_P,
//      output             HPS_DDR3_ODT,
//      output             HPS_DDR3_RAS_N,
//      output             HPS_DDR3_RESET_N,
//      input              HPS_DDR3_RZQ,
//      output             HPS_DDR3_WE_N,
//      output             HPS_ENET_GTX_CLK,
//      inout              HPS_ENET_INT_N,
//      output             HPS_ENET_MDC,
//      inout              HPS_ENET_MDIO,
//      input              HPS_ENET_RX_CLK,
//      input       [3:0]  HPS_ENET_RX_DATA,
//      input              HPS_ENET_RX_DV,
//      output      [3:0]  HPS_ENET_TX_DATA,
//      output             HPS_ENET_TX_EN,
//      inout       [3:0]  HPS_FLASH_DATA,
//      output             HPS_FLASH_DCLK,
//      output             HPS_FLASH_NCSO,
//      inout              HPS_GSENSOR_INT,
//      inout              HPS_I2C1_SCLK,
//      inout              HPS_I2C1_SDAT,
//      inout              HPS_I2C2_SCLK,
//      inout              HPS_I2C2_SDAT,
//      inout              HPS_I2C_CONTROL,
//      inout              HPS_KEY,
//      inout              HPS_LED,
//      inout              HPS_LTC_GPIO,
//      output             HPS_SD_CLK,
//      inout              HPS_SD_CMD,
//      inout       [3:0]  HPS_SD_DATA,
//      output             HPS_SPIM_CLK,
//      input              HPS_SPIM_MISO,
//      output             HPS_SPIM_MOSI,
//      inout              HPS_SPIM_SS,
//      input              HPS_UART_RX,
//      output             HPS_UART_TX,
//      input              HPS_USB_CLKOUT,
//      inout       [7:0]  HPS_USB_DATA,
//      input              HPS_USB_DIR,
//      input              HPS_USB_NXT,


      ///////// IRDA InfraRed Data Associaton /////////
//      input              IRDA_RXD,
//      output             IRDA_TXD,

      ///////// KEY Push-Bottom /////////
      input       [3:0]  KEY,

      ///////// LEDR  LED Red/////////
      output      [9:0]  LEDR,

      ///////// PS2 Interface /////////
      inout              PS2_CLK,
      inout              PS2_CLK2,
      inout              PS2_DAT,
      inout              PS2_DAT2,

      ///////// SW  Switches /////////
      input       [9:0]  SW,

      ///////// TD  TV Decoder /////////
      input             TD_CLK27,
      input      [7:0]  TD_DATA,
      input             TD_HS,
      output            TD_RESET_N,
      input             TD_VS,

      ///////// VGA Interface /////////
      output      [7:0]  VGA_B,
      output             VGA_BLANK_N,
      output             VGA_CLK,
      output      [7:0]  VGA_G,
      output             VGA_HS,
      output      [7:0]  VGA_R,
      output             VGA_SYNC_N,
      output             VGA_VS,
		

	 ////// Pinos virtuais para simulação ///////////
   // output          MClock2, //Clock25, Clock50, Clock100,
    output  [31:0]  PC, 
	 output  [31:0]  Instrucao,
    output  [31:0]  BR_Leitura1, 
	 output  [31:0]  BR_Leitura2, 
	 output  [31:0]  BR_Escrita, 
	 output  [31:0]  Saida_ULA, 
    input   [ 4:0]  RegDispSelect,
	 output  [31:0]  RegDisp,
	 output  [31:0]  FRegDisp,
	 output 	[31:0]  CSRegDisp,
    output  [31:0]  MemD_Endereco, 
	 output  [31:0]  MemD_DadoEscrita, 
	 output  [31:0]  MemD_DadoLeitura,
    output  [ 3:0]  MemD_ByteEnable, 
    output  [ 5:0]  Estado,
	 output  [31:0]  Debug,


	 output  [ 2:0]  Uniao
//	 output 	[ 0:0]  MClock,
//	 output 	[ 0:0]  LeMem, 
//	 output 	[ 0:0]  EscreveMem

`ifdef RV32IMF
	 ,
	 output  [31:0]  Saida_FPULA,
	 output  [31:0]  FRegister1,
	 output  [31:0]  FRegister2,
	 output  [31:0]  Entrada1_FPULA,
	 output  [31:0]  Entrada_FRegister,
	 output          Escreve_FReg
`endif	 

`ifdef PIPELINE
	// Pinos virtuais para debug do pipeline
	,
	output 	[31:0] wiIF_PC,
	output 	[31:0] wiIF_Instr,
	output 	[31:0] wiIF_PC4,	
	
	output 	[31:0] wID_PC,
	output 	[31:0] wID_Instr,
	output 	[31:0] wID_PC4,
	
	output 	[31:0] wEX_PC,    
	output 	[31:0] wEX_Read1,  
	output 	[31:0] wEX_Read2, 		
	output 	[ 4:0] wEX_Rs1,			
	output 	[ 4:0] wEX_Rs2,				
	output 	[ 4:0] wEX_Rd,				
	output 	[ 2:0] wEX_Funct3,		
	output 	[ 4:0] wEX_CALUControl,

	output   [ 6:0] wEX_Uniao,
	output 	[ 1:0] wEX_COrigAULA,	
	output	[ 1:0] wEX_COrigBULA,	
//	output 	[ 0:0] wEX_CMemRead, 	
//	output	[ 0:0] wEX_CMemWrite,	
//	output	[ 0:0] wEX_CRegWrite,
	
	output 	[31:0] wEX_Immediate,   
	output 	[31:0] wEX_PC4,	
	output 	[11:0] wEX_CSR,
	output 	[31:0] wEX_CSRead,
	output 	[31:0] wEX_Instr,
	output 	[NTYPE-1:0] wEX_InstrType,		

	output 	[31:0] wMEM_PC,          
	output 	[31:0] wMEM_ALUresult,  
	output 	[31:0] wMEM_ForwardB, 
	
	output 	[ 6:0] wMEM_Uniao,
//	output   [ 0:0] wMEM_CMemRead,  
//	output   [ 0:0] wMEM_CMemWrite, 
//	output   [ 0:0] wMEM_CRegWrite, 

	output 	[ 4:0] wMEM_Rd,
	output 	[ 2:0] wMEM_Funct3,	
	output 	[31:0] wMEM_PC4,
	output 	[11:0] wMEM_CSR,
	output 	[31:0] wMEM_CSRead,
	output 	[31:0] wMEM_Instr,
	output 	[NTYPE-1:0] wMEM_InstrType,

	output 	[31:0] wWB_PC,  			
	output 	[31:0] wWB_MemLoad,		
	output 	[31:0] wWB_ALUresult, 	
	output 	[ 4:0] wWB_Rd,

	output 	[ 4:0] wWB_Uniao, 	
	output 	[31:0] wWB_PC4,

	output 	[11:0] wWB_CSR,
	output 	[31:0] wWB_CSRead,
	output 	[NTYPE-1:0] wWB_InstrType,
	
	output 	[31:0] wWB_RegWrite
	
`endif	

);



// ******** Sinais de monitoramento *****************************************
wire [31:0] mPC; 
wire [31:0] mInstr;
wire [31:0] mDebug;
wire [ 4:0] mRegDispSelect;
wire [31:0] mRegDisp;
wire [31:0] mCSRegDisp;
wire [31:0] mFRegDisp;
wire [ 5:0] mControlState;
wire [ 4:0] mVGASelect;
wire [31:0] mVGARead;
wire [31:0] mCSRVGARead;
wire [31:0] mFVGARead;
wire [31:0] mRead1;
wire [31:0] mRead2;
wire [31:0] mRegWrite;
wire [31:0] mULA;	
wire 			mEbreak;

`ifdef RV32IMF
wire [31:0] mFPALU;
wire [31:0] mFRead1;
wire [31:0] mFRead2;
wire [31:0] mOrigAFPALU;
wire [31:0] mFWriteData;
wire        mCFRegWrite;
`endif	

`ifdef PIPELINE

wire [    	31:0] oiIF_PC,oiIF_Instr, oiIF_PC4, oWB_RegWrite;
wire [NIFID-1 :0] oRegIFID;
wire [NIDEX-1 :0] oRegIDEX;
wire [NEXMEM-1:0] oRegEXMEM;
wire [NMEMWB-1:0] oRegMEMWB;

assign wiIF_PC				= oiIF_PC;
assign wiIF_Instr			= oiIF_Instr;
assign wiIF_PC4			= oiIF_PC4;

assign wID_PC   			= oRegIFID[31: 0];
assign wID_Instr 			= oRegIFID[63:32];
assign wID_PC4				= oRegIFID[95:64];


assign wEX_PC     		= oRegIDEX[ 31:  0];
assign wEX_Read1  		= oRegIDEX[ 63: 32];
assign wEX_Read2  		= oRegIDEX[ 95: 64];
assign wEX_Rs1				= oRegIDEX[100: 96];
assign wEX_Rs2				= oRegIDEX[105:101];
assign wEX_Rd				= oRegIDEX[110:106];
assign wEX_Funct3			= oRegIDEX[113:111];
assign wEX_CALUControl	= oRegIDEX[118:114];


assign wEX_COrigAULA		= oRegIDEX[120:119];
assign wEX_COrigBULA		= oRegIDEX[122:121];
assign wEX_Uniao			= {oRegIDEX[125:123],oRegIDEX[227],oRegIDEX[128:126]};



assign wEX_Immediate    = oRegIDEX[160:129];
assign wEX_PC4				= oRegIDEX[192:161];
assign wEX_CSRead 		= oRegIDEX[224:193];
assign wEX_CSR 			= oRegIDEX[239:228];

assign wEX_Instr			= oRegIDEX[271:240];

assign wEX_InstrType		= oRegIDEX[NTYPE+275-1:275];

assign wMEM_PC          = oRegEXMEM[ 31:  0];
assign wMEM_ALUresult   = oRegEXMEM[ 63: 32];
assign wMEM_ForwardB 	= oRegEXMEM[ 95: 64]; 
assign wMEM_Uniao			= {oRegEXMEM[ 98: 96],oRegEXMEM[142],oRegEXMEM[109:107]};

assign wMEM_Rd				= oRegEXMEM[103: 99];
assign wMEM_Funct3		= oRegEXMEM[106:104];
assign wMEM_PC4			= oRegEXMEM[141:110];
assign wMEM_CSR			= oRegEXMEM[154:143];
assign wMEM_CSRead 		= oRegEXMEM[186:155];

assign wMEM_Instr			= oRegIDEX[218:187];

assign wMEM_InstrType	= oRegEXMEM[NTYPE+224-1:224];

assign wWB_PC  			= oRegMEMWB[ 31:  0];
assign wWB_MemLoad		= oRegMEMWB[ 63: 32];
assign wWB_ALUresult 	= oRegMEMWB[ 95: 64];
assign wWB_Rd				= oRegMEMWB[100: 96];

assign wWB_Uniao			= {oRegMEMWB[137],oRegMEMWB[101],oRegMEMWB[104:102]};

assign wWB_PC4				= oRegMEMWB[136:105];

assign wWB_CSR  			= oRegMEMWB[149:138];
assign wWB_CSRead 		= oRegMEMWB[181:150];

assign wWB_InstrType  	= oRegMEMWB[NTYPE+279-1:279];

assign wWB_RegWrite     = oWB_RegWrite;

`endif



// **************  Definicao do endereco inicial do PC  ************************* 
wire [31:0] PCinicial = BEGINNING_TEXT;


// ********************** Barramento de Dados *********************************** 
wire [31:0] DAddress, DWriteData;
wire [31:0] DReadData;
wire        DWriteEnable, DReadEnable;
wire [ 3:0] DByteEnable;

// ********************** Barramento de Instrucoes ******************************* 
wire [31:0] IAddress, IWriteData;
wire [31:0] IReadData;
wire        IWriteEnable, IReadEnable;
wire [ 3:0] IByteEnable;


// ************* Para simulacao <Nomes ajustados> ******************************
//assign Clock25			= oCLK_25;
//assign Clock50			= oCLK_50;
//assign Clock100       = oCLK_100;
assign PC            	= mPC;
assign Instrucao    		= mInstr;
assign BR_Leitura1		= mRead1;
assign BR_Leitura2		= mRead2;
assign BR_Escrita			= mRegWrite;
assign Saida_ULA			= mULA;
assign mRegDispSelect 	= RegDispSelect;
assign RegDisp       	= mRegDisp;
assign FRegDisp       	= mFRegDisp;
assign CSRegDisp        = mCSRegDisp;
assign MemD_Endereco		= DAddress;
assign MemD_DadoEscrita	= DWriteData;
assign MemD_DadoLeitura	= DReadData;
assign MemD_ByteEnable  = DByteEnable;
assign Estado    			= mControlState;
assign Debug  				= mDebug;


assign Uniao				= {CLK,DReadEnable,DWriteEnable};
//assign MClock				= CLK;
//assign LeMem     			= DReadEnable;
//assign EscreveMem    	= DWriteEnable;

`ifdef RV32IMF
assign Saida_FPULA		 = mFPALU;
assign FRegister1        = mFRead1;
assign FRegister2        = mFRead2;
assign Entrada1_FPULA    = mOrigAFPALU;
assign Entrada_FRegister = mFWriteData;
assign Escreve_FReg      = mCFRegWrite;
//assign Uniao             = {LeMem, EscreveMem, mCFRegWrite};
`endif

// ********************* Gerador e gerenciador de Clock *********************
wire CLK, oCLK_50, oCLK_25, oCLK_100, oCLK_150, oCLK_200, oCLK_27, oCLK_18;
wire Reset, CLKSelectFast, CLKSelectAuto;


CLOCK_Interface CLOCK0(
	 .iCLK_50(CLOCK_50),						 // 50MHz
    .oCLK_50(oCLK_50),                  // 50MHz  <<  Que será usado em todos os dispositivos	 
    .oCLK_100(oCLK_100),                // 100MHz
	 .oCLK_150(oCLK_150),
    .oCLK_200(oCLK_200),                // 200MHz Usado no SignalTap II
	 .oCLK_25(oCLK_25),						 // Usado na VGA
	 .oCLK_27(oCLK_27),
	 .oCLK_18(oCLK_18),						 // Usado no Audio
    .CLK(CLK),                          // Clock da CPU
    .Reset(Reset),                      // Reset de todos os dispositivos
    .CLKSelectFast(CLKSelectFast),      // Para visualização
    .CLKSelectAuto(CLKSelectAuto),      // Para visualização
    .iKEY(KEY),                         // controles dos clocks e reset
    .fdiv({3'b0,SW[4:0]}),              // divisor da frequencia CLK = iCLK_50/fdiv
    .Timer(SW[5]),                      // Timer de 10 segundos 
	 .iBreak(wbreak)			 				 // Break Point
);



// ********************************* CPU ************************************
CPU CPU0 (
    .iCLK(CLK),             				// Clock real do Processador
    .iCLK50(oCLK_50),       				// Clock 50MHz fixo, usado so na FPU Uniciclo
    .iRST(Reset),
    .iInitialPC(PCinicial),

    // Sinais de monitoramento
    .mPC(mPC),
    .mInstr(mInstr),
    .mDebug(mDebug),
    .mRegDispSelect(mRegDispSelect),
    .mRegDisp(mRegDisp),
	 .mCSRegDisp(mCSRegDisp),
	 .mFRegDisp(mFRegDisp),
    .mControlState(mControlState),
    .mVGASelect(mVGASelect),
    .mVGARead(mVGARead),
	 .mCSRVGARead(mCSRVGARead),
	 .mFVGARead(mFVGARead),
	 .mRead1(mRead1),
	 .mRead2(mRead2),
	 .mRegWrite(mRegWrite),
	 .mULA(mULA),
	 .mEbreak(mEbreak),
	 
`ifdef RV32IMF
	 .mFPALU(mFPALU),
	 .mFRead1(mFRead1),
    .mFRead2(mFRead2),
    .mOrigAFPALU(mOrigAFPALU),
	 .mFWriteData(mFWriteData),
	 .mCFRegWrite(mCFRegWrite),
`endif

    // Barramento Dados
    .DwReadEnable(DReadEnable), 
	 .DwWriteEnable(DWriteEnable),
    .DwByteEnable(DByteEnable),
    .DwAddress(DAddress), 
	 .DwWriteData(DWriteData),
	 .DwReadData(DReadData),

    // Barramento Instrucoes
    .IwReadEnable(IReadEnable), 
	 .IwWriteEnable(IWriteEnable),
    .IwByteEnable(IByteEnable),
    .IwAddress(IAddress), 
	 .IwWriteData(IWriteData), 
	 .IwReadData(IReadData)
	 
	 
`ifdef PIPELINE
	,
	 .oiIF_PC(oiIF_PC),
	 .oiIF_Instr(oiIF_Instr),
	 .oiIF_PC4(oiIF_PC4),
	 .oRegIFID(oRegIFID),
	 .oRegIDEX(oRegIDEX),
	 .oRegEXMEM(oRegEXMEM),
	 .oRegMEMWB(oRegMEMWB),
	 .oWB_RegWrite(oWB_RegWrite)
`endif
	 
	 

);



// ************************* Memoria RAM Interface **************************

`ifdef MULTICICLO // Multiciclo

Memory_Interface MEMORY(
    .iCLK(CLK), 
	 .iCLKMem(oCLK_50),
    // Barramento
    .wReadEnable(DReadEnable), 
	 .wWriteEnable(DWriteEnable),
    .wByteEnable(DByteEnable),
    .wAddress(DAddress), 
	 .wWriteData(DWriteData), 
	 .wReadData(DReadData)
);

`else		// Uniciclo e Pipeline

DataMemory_Interface MEMDATA(
    .iCLK(CLK), 
	 .iCLKMem(oCLK_50), 
    // Barramento de dados
    .wReadEnable(DReadEnable), 
	 .wWriteEnable(DWriteEnable),
    .wByteEnable(DByteEnable),
    .wAddress(DAddress), 
	 .wWriteData(DWriteData), 
	 .wReadData(DReadData)
);

CodeMemory_Interface MEMCODE(
    .iCLK(CLK), 
	 .iCLKMem(oCLK_50),
    // Barramento de Instrucoes
    .wReadEnable(IReadEnable), 
	 .wWriteEnable(IWriteEnable),
    .wByteEnable(IByteEnable),
    .wAddress(IAddress), 
	 .wWriteData(IWriteData), 
	 .wReadData(IReadData)
);

`endif



// ****************LEDR Interface  ************************************* 
assign LEDR[9:4]   = mControlState;
assign LEDR[3]		 = 1'b0;
assign LEDR[2]     = CLKSelectAuto;
assign LEDR[1]     = CLKSelectFast;
assign LEDR[0]     = CLK;


	 
// ********************* 7 Segment Displays Interface ********************** 
wire [31:0] wOutput;

assign wOutput = 	SW[9:8]==2'b11 ? mPC :
						SW[9:8]==2'b10 ? mInstr :
						SW[9:8]==2'b01 ? mDebug :
						SW[9:8]==2'b00 ? 32'b0 : 32'b0; // slot livre

Display7_Interface Display70(	
	.HEX0_D(HEX0), 
	.HEX1_D(HEX1), 
	.HEX2_D(HEX2), 
	.HEX3_D(HEX3), 
	.HEX4_D(HEX4), 
	.HEX5_D(HEX5), 
	.Output(wOutput)
);



// ********************* StopWatch Interface *****************************
STOPWATCH_Interface  stopwatch0 (
	.iCLK(CLK),
   .iCLK_50(oCLK_50), 
    // Barramento
    .wReadEnable(DReadEnable), 
	 .wWriteEnable(DWriteEnable),
    .wByteEnable(DByteEnable),
    .wAddress(DAddress), 
	 .wWriteData(DWriteData), 
	 .wReadData(DReadData)
);



// **************************** LFSR Interface *****************************
LFSR_interface  lfsr0 (
	.iCLK(CLK),
	.iCLK_50(oCLK_50),
	// Barramento
    .wReadEnable(DReadEnable), 
	 .wWriteEnable(DWriteEnable),
    .wByteEnable(DByteEnable),
    .wAddress(DAddress), 
	 .wWriteData(DWriteData), 
	 .wReadData(DReadData)
);
											
	 
// **************************** Break Interface ***************************** 
wire wbreak;

Break_Interface  break0 (
   .iCLK_50(oCLK_50), 
	.iCLK(CLK), 
	.iEbreak(mEbreak),
	.Reset(Reset),
   .oBreak(wbreak),
	.iKEY(KEY),
	.iPC(mPC),
    // Barramento
    .wReadEnable(DReadEnable), 
	 .wWriteEnable(DWriteEnable),
    .wByteEnable(DByteEnable),
    .wAddress(DAddress), 
	 .wWriteData(DWriteData), 
	 .wReadData(DReadData)
);									

	
// ***************************** VGA Interface ******************************
wire [4:0]  wVGASelectIn;
wire [31:0] wVGAReadIn;
assign wVGAReadIn       = (~SW[7] ? mVGARead : mFVGARead); // POR FALTA DE SW ALTEREI O mFVGARead(Float) para mCSRVGARead(Control Status)
assign mVGASelect       = wVGASelectIn;

VGA_Interface VGA0 (
    .iCLK(CLK), 
	 .iCLK_50(oCLK_50),
	 .iCLK2_50(CLOCK2_50), 
	 .iRST(Reset),
	 .oVGA_CLK(VGA_CLK),
    .oVGA_HS(VGA_HS), 
	 .oVGA_VS(VGA_VS), 
	 .oVGA_BLANK_N(VGA_BLANK_N), 
	 .oVGA_SYNC_N(VGA_SYNC_N),
    .oVGA_R(VGA_R), 
	 .oVGA_G(VGA_G), 
	 .oVGA_B(VGA_B),
    .oVGASelect(wVGASelectIn),
    .iVGARead(wVGAReadIn),
    .iDebugEnable(SW[9]),
	 .iframesw(SW[6]),
    // Barramento
    .wReadEnable(DReadEnable), 
	 .wWriteEnable(DWriteEnable),
    .wByteEnable(DByteEnable),
    .wAddress(DAddress), 
	 .wWriteData(DWriteData), 
	 .wReadData(DReadData)
);



// ************************* Teclado PS2 Interface ************************** 
wire ps2_scan_ready_clock, keyboard_interrupt;

TecladoPS2_Interface TecladoPS20 (
    .iCLK(CLK), 
	 .iCLK_50(oCLK_50), 
	 .Reset(Reset),
    .PS2_KBCLK(PS2_CLK),
    .PS2_KBDAT(PS2_DAT),
    // Barramento
    .wReadEnable(DReadEnable), 
	 .wWriteEnable(DWriteEnable),
    .wByteEnable(DByteEnable),
    .wAddress(DAddress), 
	 .wWriteData(DWriteData), 
	 .wReadData(DReadData)
    //Interrupcao
//    .ps2_scan_ready_clock(ps2_scan_ready_clock),
//    .keyboard_interrupt(keyboard_interrupt)
);



// ************************* Audio CODEC Interface **************************
wire audio_clock_flip_flop, audio_proc_clock_flip_flop;

AudioCODEC_Interface Audio0 (
    .iCLK(CLK), 
	 .iCLK_50(oCLK_50),  
    .iCLK_18(oCLK_18),
	 .Reset(Reset),
    .oTD1_RESET_N(TD_RESET_N),
    .I2C_SDAT(FPGA_I2C_SDAT),
    .oI2C_SCLK(FPGA_I2C_SCLK),
    .AUD_ADCLRCK(AUD_ADCLRCK),
    .iAUD_ADCDAT(AUD_ADCDAT),
    .AUD_DACLRCK(AUD_DACLRCK),
    .oAUD_DACDAT(AUD_DACDAT),
    .AUD_BCLK(AUD_BCLK),
    .oAUD_XCK(AUD_XCK),
    // Para o sintetizador
    .wsaudio_outL(wsaudio_outL),
    .wsaudio_outR(wsaudio_outR),
    // Barramento
    .wReadEnable(DReadEnable), 
	 .wWriteEnable(DWriteEnable),
    .wByteEnable(DByteEnable),
    .wAddress(DAddress), 
	 .wWriteData(DWriteData), 
	 .wReadData(DReadData)
    // Interrupcao
//    .audio_clock_flip_flop(audio_clock_flip_flop),
//    .audio_proc_clock_flip_flop(audio_proc_clock_flip_flop)
);






// ************************ Sintetizador Interface ************************* 
wire [15:0] wsaudio_outL, wsaudio_outR;

Sintetizador_Interface Sintetizador0 (
    .iCLK(CLK), 
	 .iCLK_50(oCLK_50), 
	 .Reset(Reset),
    .AUD_DACLRCK(AUD_DACLRCK),
    .AUD_BCLK(AUD_BCLK),
    .wsaudio_outL(wsaudio_outL), 
	 .wsaudio_outR(wsaudio_outR),
    //  Barramento
    .wReadEnable(DReadEnable), 
	 .wWriteEnable(DWriteEnable),
    .wByteEnable(DByteEnable),
    .wAddress(DAddress), 
	 .wWriteData(DWriteData), 
	 .wReadData(DReadData)
);




// ***************************** RS232 Interface *****************************
RS232_Interface Serial0 (
    .iCLK(CLK),
	 .iCLK_50(oCLK_50),
	 .Reset(Reset),
	 .iUART_RXD(GPIO_0[27]),
    .oUART_TXD(GPIO_0[26]),
    //  Barramento
    .wReadEnable(DReadEnable), 
	 .wWriteEnable(DWriteEnable),
    .wByteEnable(DByteEnable),
    .wAddress(DAddress), 
	 .wWriteData(DWriteData), 
	 .wReadData(DReadData)
);




/**************** Analog-Digital Converter Interface ***************************/
ADC_Interface ADCI0 (
    .iCLK_50(oCLK_50),
    .iCLK(CLK),
    .Reset(Reset),
    .ADC_CS_N(ADC_CS_N),
    .ADC_DIN(ADC_DIN),
    .ADC_DOUT(ADC_DOUT),
    .ADC_SCLK(ADC_SCLK),
    //  Barramento
    .wReadEnable(DReadEnable), 
	 .wWriteEnable(DWriteEnable),
    .wByteEnable(DByteEnable),
    .wAddress(DAddress), 
	 .wWriteData(DWriteData), 
	 .wReadData(DReadData)
);





// **************************** Mouse Interface *****************************
//wire reg_mouse_keyboard, received_data_en_contador_enable;
//
//MousePS2_Interface Mouse0 (
//  .iCLK(CLK), 
//	 .iCLK_50(oCLK_50), 
//	 .Reset(Reset),
//  .PS2_KBCLK(PS2_CLK),
//  .PS2_KBDAT(PS2_DAT),
//  //  Barramento
//  .wReadEnable(DReadEnable), 
//	 .wWriteEnable(DWriteEnable),
//  .wByteEnable(DByteEnable),
//  .wAddress(DAddress), 
//	 .wWriteData(DWriteData), 
//	 .wReadData(DReadData),
//  // Interrupcao
//  .reg_mouse_keyboard(reg_mouse_keyboard),
//  .received_data_en_contador_enable(received_data_en_contador_enable)
//);



// **************************** IrDA Interface *****************************
//IrDA_Interface  IrDA0 (
// .iCLK_50(oCLK_50), 
//	.iCLK(CLK), 
//	.Reset(Reset),
// .oIRDA_TXD(IRDA_TXD),    //    IrDA Transmitter
// .iIRDA_RXD(IRDA_RXD),    //    IrDA Receiver
// //  Barramento
// .wReadEnable(DReadEnable), 
//	.wWriteEnable(DWriteEnable),
// .wByteEnable(DByteEnable),
// .wAddress(DAddress), 
//	.wWriteData(DWriteData), 
//	.wReadData(DReadData)
//);
//
//IrDA_decoder  IrDA_decoder0 (
// .iCLK_50(oCLK_50), 
//	.iCLK(CLK), 
//	.Reset(Reset),
// .iIRDA_RXD(IRDA_RXD),    //    IrDA Receiver
//	
//	.wAddress(DAddress),
//	.oCode(DReadData),
//	.wReadEnable(DReadEnable),
//	.iselect(IRDAWORD)
//);




endmodule




