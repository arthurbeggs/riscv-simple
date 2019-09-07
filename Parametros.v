/*

 Adaptado para a placa de desenvolvimento DE1-SoC.
 Prof. Marcus Vinicius Lamar   2019/1
 UnB - Universidade de Brasilia
 Dep. Ciencia da Computacao
 
*/

// **************************************************** 
// * Escolha o tipo de processador a ser implementado *
//`define UNICICLO
//`define MULTICICLO 
`define PIPELINE


// ****************************************************
// * Escolha a ISA a ser implementada                 *
//`define RV32I
//`define RV32IM
`define RV32IMF


`ifndef PARAM
`define PARAM


/* Parametros Gerais*/
parameter
    ON          = 1'b1,
    OFF         = 1'b0,
    ZERO        = 32'h00000000,	 
	 
/* Operacoes da ULA */
	OPAND		= 5'd0,
	OPOR		= 5'd1,
	OPXOR		= 5'd2,
	OPADD		= 5'd3,
	OPSUB		= 5'd4,
	OPSLT		= 5'd5,
	OPSLTU	= 5'd6,
	OPSLL		= 5'd7,
	OPSRL		= 5'd8,
	OPSRA		= 5'd9,
	OPLUI		= 5'd10,
	OPMUL		= 5'd11,
	OPMULH	= 5'd12,
	OPMULHU	= 5'd13,
	OPMULHSU	= 5'd14,
	OPDIV		= 5'd15,
	OPDIVU	= 5'd16,
	OPREM		= 5'd17,
	OPREMU	= 5'd18,
	OPNULL	= 5'd31, // saída ZERO
		
/* Operacoes da ULA FP */
	FOPADD      = 5'd0,
	FOPSUB      = 5'd1,
	FOPMUL      = 5'd2,
	FOPDIV      = 5'd3,
	FOPSQRT     = 5'd4,
	FOPABS      = 5'd5,
	FOPCEQ      = 5'd6,
	FOPCLT      = 5'd7,
	FOPCLE      = 5'd8,
	FOPCVTSW    = 5'd9,
	FOPCVTWS    = 5'd10,		
	FOPMV       = 5'd11,
	FOPSGNJ     = 5'd12,
	FOPSGNJN    = 5'd13,
	FOPSGNJX    = 5'd14,
	FOPMAX      = 5'd15,
	FOPMIN      = 5'd16,
	FOPCVTSWU   = 5'd17,
	FOPCVTWUS   = 5'd18,
	FOPNULL		= 5'd31, // saída EEEEEEEE

/* Campo OpCode */
	OPC_LOAD       	= 7'b0000011,
	OPC_OPIMM     		= 7'b0010011,
	OPC_AUIPC      	= 7'b0010111,
	OPC_STORE      	= 7'b0100011,
	OPC_RTYPE    		= 7'b0110011,
	OPC_LUI       	 	= 7'b0110111,
	OPC_BRANCH     	= 7'b1100011,
	OPC_JALR       	= 7'b1100111,
	OPC_JAL        	= 7'b1101111,
	OPC_SYS				= 7'b1110111,
	OPC_URET				= 7'b1110011,
	OPC_FRTYPE        = 7'b1010011,
	OPC_FLOAD         = 7'b0000111,
	OPC_FSTORE        = 7'b0100111,	
	OPC_SYSTEM		  = 7'b1110011,


/* Campo Funct7 */
	FUNCT7_ADD			 = 7'b0000000,
   FUNCT7_SUB         = 7'b0100000,
	FUNCT7_SLL			 = 7'b0000000,
	FUNCT7_SLT			 = 7'b0000000,
	FUNCT7_SLTU			 = 7'b0000000,
	FUNCT7_XOR			 = 7'b0000000,
   FUNCT7_SRL         = 7'b0000000,
	FUNCT7_SRA         = 7'b0100000,
	FUNCT7_OR			 = 7'b0000000,
	FUNCT7_AND			 = 7'b0000000,
	FUNCT7_MULDIV	    = 7'b0000001,
	FUNCT7_FADD_S		 = 7'b0000000,
	FUNCT7_FSUB_S      = 7'b0000100,
	FUNCT7_FMUL_S      = 7'b0001000,
	FUNCT7_FDIV_S      = 7'b0001100,
	FUNCT7_FSQRT_S     = 7'b0101100,
	FUNCT7_FCVT_S_W_WU = 7'b1101000,
	FUNCT7_FCVT_W_WU_S = 7'b1100000,
	FUNCT7_FMV_S_X     = 7'b1111000,
	FUNCT7_FMV_X_S     = 7'b1110000,
	FUNCT7_FCOMPARE    = 7'b1010000,
	FUNCT7_FSIGN_INJECT= 7'b0010000,
	FUNCT7_MAX_MIN_S   = 7'b0010100,
	
	
/* Campo Funct3 */
	FUNCT3_LB			= 3'b000,
	FUNCT3_LH			= 3'b001,
	FUNCT3_LW			= 3'b010,
	FUNCT3_LBU			= 3'b100,
	FUNCT3_LHU			= 3'b101,

	FUNCT3_SB			= 3'b000,
	FUNCT3_SH			= 3'b001,
	FUNCT3_SW			= 3'b010,	
	
	FUNCT3_ADD			= 3'b000,
	FUNCT3_SUB			= 3'b000,
	FUNCT3_SLL			= 3'b001,
	FUNCT3_SLT			= 3'b010,
	FUNCT3_SLTU			= 3'b011,
	FUNCT3_XOR			= 3'b100,
	FUNCT3_SRL			= 3'b101,
	FUNCT3_SRA			= 3'b101,
	FUNCT3_OR			= 3'b110,
	FUNCT3_AND			= 3'b111,
	
	FUNCT3_BEQ			= 3'b000,
	FUNCT3_BNE			= 3'b001,
	FUNCT3_BLT			= 3'b100,
	FUNCT3_BGE			= 3'b101,
	FUNCT3_BLTU			= 3'b110,
	FUNCT3_BGEU			= 3'b111,
	
	FUNCT3_JALR			= 3'b000,

	FUNCT3_PRIV			= 3'b000,
	FUNCT3_CSRRW      = 3'b001,
	FUNCT3_CSRRS      = 3'b010,
	FUNCT3_CSRRC      = 3'b011,
	FUNCT3_CSRRWI     = 3'b101,
	FUNCT3_CSRRSI     = 3'b110,
	FUNCT3_CSRRCI     = 3'b111,

	FUNCT3_MUL			= 3'b000,
	FUNCT3_MULH			= 3'b001,
	FUNCT3_MULHSU		= 3'b010,
	FUNCT3_MULHU		= 3'b011,
	FUNCT3_DIV			= 3'b100,
	FUNCT3_DIVU			= 3'b101,
	FUNCT3_REM			= 3'b110,
	FUNCT3_REMU			= 3'b111,

	FUNCT3_FMV_S_X    = 3'b000,
	FUNCT3_FMV_X_S    = 3'b000,
	FUNCT3_FEQ_S      = 3'b010,
	FUNCT3_FLE_S      = 3'b000,
	FUNCT3_FLT_S      = 3'b001,
	FUNCT3_FSGNJ_S    = 3'b000,
	FUNCT3_FSGNJN_S   = 3'b001,
	FUNCT3_FSGNJX_S   = 3'b010,
	FUNCT3_FMAX_S     = 3'b001,
	FUNCT3_FMIN_S     = 3'b000,
	FUNCT3_FLW        = 3'b010,
	FUNCT3_FSW        = 3'b010,	
	
/* Campo Funct12 */

	FUNCT12_ECALL		= 12'b000000000000,
	FUNCT12_EBREAK    = 12'b000000000001,

	FUNCT12_URET		= 12'b000000000010,
	
/* Campo Rs2 */
	RS2_FCVT_S_W      = 5'b00000,
	RS2_FCVT_S_WU     = 5'b00001,
	RS2_FCVT_W_S      = 5'b00000,
	RS2_FCVT_WU_S     = 5'b00001,
	

	
/* ADDRESS  *****************************************************************************************************/

    BEGINNING_TEXT      = 32'h0040_0000,
	 TEXT_WIDTH				= 14+2,					// 16384 words = 16384x4 = 64ki bytes	 
    END_TEXT            = (BEGINNING_TEXT + 2**TEXT_WIDTH) - 1,	 

	 
    BEGINNING_DATA      = 32'h1001_0000,
	 DATA_WIDTH				= 15+2,					// 32768 words = 32768x4 = 128ki bytes
    END_DATA            = (BEGINNING_DATA + 2**DATA_WIDTH) - 1,	 


	 STACK_ADDRESS       = END_DATA-3,


//    BEGINNING_KTEXT     = 32'h8000_0000,
//	 KTEXT_WIDTH			= 13,					// 2048 words = 2048x4 = 8192 bytes
//    END_KTEXT           = (BEGINNING_KTEXT + 2**KTEXT_WIDTH) - 1,	 	 
//	 
//    BEGINNING_KDATA     = 32'h9000_0000,
//	 KDATA_WIDTH			= 12,					// 1024 words = 1024x4 = 4096 bytes
//    END_KDATA           = (BEGINNING_KDATA + 2**KDATA_WIDTH) - 1,	 	 

	 
    BEGINNING_IODEVICES         = 32'hFF00_0000,
	 
    BEGINNING_VGA0              = 32'hFF00_0000,
    END_VGA0                    = 32'hFF01_2C00,  // 320 x 240 = 76800 bytes

    BEGINNING_VGA1              = 32'hFF10_0000,
    END_VGA1                    = 32'hFF11_2C00,  // 320 x 240 = 76800 bytes	 
	 
	 FRAMESELECT					  = 32'hFF20_0604,  // Frame Select register 0 ou 1
	 
	 KDMMIO_CTRL_ADDRESS		     = 32'hFF20_0000,	// Para compatibilizar com o KDMMIO
	 KDMMIO_DATA_ADDRESS		  	  = 32'hFF20_0004,
	 
	 BUFFER0_TECLADO_ADDRESS     = 32'hFF20_0100,
    BUFFER1_TECLADO_ADDRESS     = 32'hFF20_0104,
	 
    TECLADOxMOUSE_ADDRESS       = 32'hFF20_0110,
    BUFFERMOUSE_ADDRESS         = 32'hFF20_0114,
	 
	 RS232_READ_ADDRESS          = 32'hFF20_0120,
    RS232_WRITE_ADDRESS         = 32'hFF20_0121,
    RS232_CONTROL_ADDRESS       = 32'hFF20_0122,
	  
	 AUDIO_INL_ADDRESS           = 32'hFF20_0160,
    AUDIO_INR_ADDRESS           = 32'hFF20_0164,
    AUDIO_OUTL_ADDRESS          = 32'hFF20_0168,
    AUDIO_OUTR_ADDRESS          = 32'hFF20_016C,
    AUDIO_CTRL1_ADDRESS         = 32'hFF20_0170,
    AUDIO_CRTL2_ADDRESS         = 32'hFF20_0174,

    NOTE_SYSCALL_ADDRESS        = 32'hFF20_0178,
    NOTE_CLOCK                  = 32'hFF20_017C,
    NOTE_MELODY                 = 32'hFF20_0180,
    MUSIC_TEMPO_ADDRESS         = 32'hFF20_0184,
    MUSIC_ADDRESS               = 32'hFF20_0188,      // Endereco para uso do Controlador do sintetizador
    PAUSE_ADDRESS               = 32'hFF20_018C,

	 ADC_CH0_ADDRESS				 = 32'hFF20_0200,
	 ADC_CH1_ADDRESS				 = 32'hFF20_0204,
	 ADC_CH2_ADDRESS				 = 32'hFF20_0208,
	 ADC_CH3_ADDRESS				 = 32'hFF20_020C,
	 ADC_CH4_ADDRESS				 = 32'hFF20_0210,
	 ADC_CH5_ADDRESS				 = 32'hFF20_0214,
	 ADC_CH6_ADDRESS				 = 32'hFF20_0218,
	 ADC_CH7_ADDRESS				 = 32'hFF20_021C,
	 
	 IRDA_DECODER_ADDRESS		 = 32'hFF20_0500,
	 IRDA_CONTROL_ADDRESS       = 32'hFF20_0504, 	 	// Relatorio questao B.10) - Grupo 2 - (2/2016)
	 IRDA_READ_ADDRESS          = 32'hFF20_0508,		 	// Relatorio questao B.10) - Grupo 2 - (2/2016)
    IRDA_WRITE_ADDRESS         = 32'hFF20_050C,		 	// Relatorio questao B.10) - Grupo 2 - (2/2016)
    
	 STOPWATCH_ADDRESS			 = 32'hFF20_0510,	 		//Feito em 2/2016 para servir de cronometro
	 
	 LFSR_ADDRESS					 = 32'hFF20_0514,			// Gerador de numeros aleatorios
	 
	 KEYMAP0_ADDRESS				 = 32'hFF20_0520,			// Mapa do teclado 2017/2
	 KEYMAP1_ADDRESS				 = 32'hFF20_0524,
	 KEYMAP2_ADDRESS				 = 32'hFF20_0528,
	 KEYMAP3_ADDRESS				 = 32'hFF20_052C,
	 
	 BREAK_ADDRESS					 = 32'hFF20_0600,  	  // Buffer do endereço do Break Point
	 
	 
/* STATES ************************************************************************************************************/
   ST_FETCH       	= 6'd00,
   ST_FETCH1      	= 6'd01,
   ST_DECODE      	= 6'd02,
	ST_LWSW				= 6'd03,
	ST_SW					= 6'd04,
	ST_SW1				= 6'd05,
	ST_LW					= 6'd06,
	ST_LW1				= 6'd07,
	ST_LW2				= 6'd08,
	ST_RTYPE				= 6'd09,
	ST_ULAREGWRITE		= 6'd10,
	ST_BRANCH			= 6'd11,
	ST_JAL				= 6'd12,
	ST_IMMTYPE			= 6'd13,
	ST_JALR				= 6'd14,
	ST_AUIPC				= 6'd15,
	ST_LUI				= 6'd16,
	//ST_SYS					= 6'd17, // nao implementado
	//ST_URET				= 6'd18,	// nao implementado
	ST_DIVREM			= 6'd19,

	// Estados FPULA
	ST_FRTYPE        	= 6'd20, // Estado para instrucoes do tipo R float
	ST_FLW           	= 6'd21, // Estado para computar o flw
	ST_FLW1          	= 6'd22,
	ST_FLW2          	= 6'd23,
	ST_FSW           	= 6'd24,
	ST_FSW1          	= 6'd25,
	ST_FPALUREGWRITE 	= 6'd26,
	ST_FPSTART       	= 6'd27, // Estado que inicializa a operacao na FPULA
	ST_FPWAIT		  	= 6'd28, 
	
	// Estadors Constrol Status
	
	ST_SYSTEM				= 6'd29,
	//ST_PRIV 				= 6'd30, // funct3 = 000	<- ST_SYSTEM
	
	ST_ECALL 			= 6'd31,	// funct12 = 0x000  <- ST_PRIV
	ST_EBREAK 			= 6'd32,	// funct12 = 0x001  <- ST_PRIV
	ST_URET 				= 6'd33,	// funct12 = 0x002  <- ST_PRIV
	
	
	ST_CSRREND 			= 6'd34,
	
	ST_ERRO        	= 6'd63, // Estado de Erro
	
	
/* Tamanho dos Registradores do Pipeline **************************************************************************************/	

`ifndef RV32IMF
	NIFID  = 96,
	NIDEX  = 282, // adicionardo 32 CSreg Write, 1 ecall , 1 invIntrc, 1 CSRegWrite , 2 expadir orig(a\b)ALU, 1 expandir men2reg
	NEXMEM = 232,
	NMEMWB = 287,
`else
	NIFID  = 96,
	NIDEX  = 360, 
	NEXMEM = 271, 
	NMEMWB = 326,
`endif
	
/* Tamanho em bits do Instruction Type */
`ifndef RV32IMF
	NTYPE = 8;
`else
	NTYPE = 14;
`endif

	
`endif