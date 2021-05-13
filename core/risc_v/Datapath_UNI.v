`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

//
// Caminho de dados processador RISC-V Uniciclo
//
//

module Datapath_UNI (
    // Inputs e clocks
    input  iCLK,
    input  iCLK50,
    input  iRST,
    input  [31:0] iInitialPC,

    // Para monitoramento
    output [31:0] mPC,
    output [31:0] mInstr,
    input  [ 4:0] reg_debug_address,
    input  [11:0] csr_debug_address,
    output [31:0] reg_debug_data,
    output [31:0] fp_reg_debug_data,
    output [31:0] csr_debug_data,

    // Contadores
    input  [63:0] cycles_counter,
    input  [63:0] time_counter,

     // Sinais do Controle
    output [31:0] wInstr,
    input  [ 1:0] wCOrigAULA,
    input  [ 1:0] wCOrigBULA,
    input  wCRegWrite,
    input  wCCSRegWrite,
    input  wCMemWrite,
    input  wCMemRead,
    input  wCInvInstruction,
    input  wCEcall,
    input  [ 2:0]  wCMem2Reg,
    input  [ 2:0]  wCOrigPC,
    input  [ 4:0] wCALUControl,
`ifdef RV32IMF
    input  wCFRegWrite,             // Controla a escrita no FReg
    input  [ 4:0] wCFPALUControl,   // Controla a operacao a ser realizda pela FPULA
    input  wCOrigAFPALU,            // Controla se a entrada A da FPULA  float ou int
    input  wCFPALU2Reg,             // Controla a escrita no registrador de inteiros (origem FPULA ou nao?)
    input  wCFWriteData,            // Controla a escrita nos FRegisters (origem FPALU(0) : origem memoria(1)?)
    input  wCWrite2Mem,             // Controla a escrita na memoria (origem Register(0) : FRegister(1))
    input  wCFPstart,               // controla a FPULA
`endif

    //  Barramento de Dados
    output DwReadEnable,
    output DwWriteEnable,
    output [ 3:0] DwByteEnable,
    output [31:0] DwAddress,
    input  [31:0] DwReadData,
    output [31:0] DwWriteData,

    // Barramento de Instrucoes
    output IwReadEnable,
    output IwWriteEnable,
    output [ 3:0] IwByteEnable,
    output [31:0] IwAddress,
    input  [31:0] IwReadData,
    output [31:0] IwWriteData
);


// ******************************************************
// Instanciação e Inicializacao do PC
reg  [31:0] PC;

initial begin
    PC         <= BEGINNING_TEXT;
end

// Banco de Registradores
wire [31:0] wRead1, wRead2;

// Banco de Registradores de ponto flutuante
`ifdef RV32IMF
wire [31:0] wFRead1, wFRead2;
`endif

// Baco de registradores CSR
wire [31:0] wCSRegWriteUEPC;
wire [31:0] wCSRegWriteUCAUSE;
wire [31:0] wCSRegWriteUTVAL;
wire [31:0] wCSRegReadUSTATUS;
wire [31:0] wCSRegReadUTVEC;
wire [31:0] wCSRegReadUEPC;
wire [31:0] wCSRegReadUTVAL;
wire [31:0] wCSRead;
reg  [63:0] instret_counter;

// Sinais de monitoramento e Debug
assign mPC                  = PC;
assign mInstr               = wInstr;

`ifndef RV32IMF
assign fp_reg_debug_data    = ZERO;
`endif

// Controle de Exceções
wire wExPcToUtvec;
wire wExRegWrite;
wire [31:0]ExcInstruction = IwReadData;

// Unidade geradora do imediato
wire [31:0] wImmediate;

// ALU - Unidade Lógica-Artimética
wire [31:0] wALUresult;

//FPALU
`ifdef RV32IMF
wire [31:0] wFPALUResult;
`endif

// Unidade de controle de escrita
wire [31:0] wMemDataWrite;
wire [ 3:0] wMemEnable;

// Unidade de controle de leitura
wire [31:0] wMemLoad;

// Barramento da memoria de dados
wire [31:0] wReadData   = DwReadData;
assign DwReadEnable     = wCMemRead;
assign DwWriteEnable    = wCMemWrite;
assign DwByteEnable     = wMemEnable;
assign DwWriteData      = wMemDataWrite;
assign DwAddress        = wALUresult;

// Unidade de controle de Branches
wire    wBranch;

reg  [31:0] wOrigAULA;
reg  [31:0] wOrigBULA;
reg  [31:0] wiPC;

reg  [31:0] wRegWrite;

`ifdef RV32IMF
reg  [31:0] wMem2Reg;
reg  [31:0] wOrigAFPALU;
reg  [31:0] wFWriteData;
reg  [31:0] wWrite2Mem;
`else
reg  [31:0] wWrite2Mem;
`endif


// ******************************************************
// Instanciacao das estruturas

wire [31:0] wPC4        = PC + 32'h00000004;
wire [31:0] wBranchPC   = PC + wImmediate;

wire [11:0] wCSR        = wInstr[31:20];
wire [ 4:0] wRs1        = wInstr[19:15];
wire [ 4:0] wRs2        = wInstr[24:20];
wire [ 4:0] wRd         = wInstr[11: 7];
wire [ 2:0] wFunct3     = wInstr[14:12];
// wire [ 6:0] wOpcode     = wInstr[ 6: 0];

// Barramento da Memoria de Instrucoes
assign IwReadEnable     = ON;
assign IwWriteEnable    = OFF;
assign IwByteEnable     = 4'b1111;
assign IwAddress        = PC;
assign IwWriteData      = ZERO;
assign wInstr           = IwReadData;


Registers REGISTERS0 (
    .iCLK           (iCLK),
    .iRST           (iRST),
    .iReadRegister1 (wRs1),
    .iReadRegister2 (wRs2),
    .iWriteRegister (wRd),
    .iWriteData     (wRegWrite),
    .iRegWrite      (wCRegWrite),
    .oReadData1     (wRead1),
    .oReadData2     (wRead2),

    .iVGASelect     (reg_debug_address),
    .oVGARead       (reg_debug_data)
);


// Banco de Registradores de ponto flutuante
`ifdef RV32IMF
FRegisters REGISTERS1 (
    .iCLK           (iCLK),
    .iRST           (iRST),
    .iReadRegister1 (wRs1),
    .iReadRegister2 (wRs2),
    .iWriteRegister (wRd),
    .iWriteData     (wFWriteData),
    .iRegWrite      (wCFRegWrite),
    .oReadData1     (wFRead1),
    .oReadData2     (wFRead2),

    .iVGASelect     (reg_debug_address),
    .oVGARead       (fp_reg_debug_data)
);
`endif


// Baco de registradores CSR
CSRegisters CSRegister2 (
    .core_clock             (iCLK),
    .reset                  (iRST),
    .iRegWrite              (wCCSRegWrite),         // escrita pelo codigo csr
    .iRegWriteSimu          (wExRegWrite),          // esctita simultanea em uepc ucause e utval
    .register_read_address  (wCSR),
    .register_write_address (wCSR),
    .iWriteData             (wALUresult),           // escreve no csr o valor que sai de rs1
    .oReadData              (wCSRead),              // le do csr o valor e escreve no rd
    .iWriteDataUEPC         (wCSRegWriteUEPC),
    .iWriteDataUCAUSE       (wCSRegWriteUCAUSE),
    .iWriteDataUTVAL        (wCSRegWriteUTVAL),     // escrita registradores especiais precisam de acesso simultaneo
    .oReadDataUTVEC         (wCSRegReadUTVEC),      // leitura registradores especiais precisam de acesso simultaneo
    .oReadDataUEPC          (wCSRegReadUEPC),
    .oReadDataUSTATUS       (wCSRegReadUSTATUS),
    .oReadDataUTVAL         (wCSRegReadUTVAL),
    .cycles_counter         (cycles_counter),
    .time_counter           (time_counter),
    .instret_counter        (instret_counter),

    .csr_debug_address      (csr_debug_address),
    .csr_debug_data         (csr_debug_data)
);


// Controle de Exceções
ExceptionControl EXC0(
    .iExceptionEnabled      (wCSRegReadUSTATUS[0]),
    .iExInstrIllegal        (wCInvInstruction),
    .iExEnviromentCall      (wCEcall),
    .iRegReadUTVAL          (wCSRegReadUTVAL), // gravar nele proprio quando por um ecall
    .iInstr                 (ExcInstruction),
    .iPC                    (PC),
    .iALUresult             (wALUresult),
    .oExRegWrite            (wExRegWrite),
    .oExSetPcToUtvec        (wExPcToUtvec), // seta o wipc para utvec independenete de instrução
    .oExUEPC                (wCSRegWriteUEPC),
    .oExUCAUSE              (wCSRegWriteUCAUSE),
    .oExUTVAL               (wCSRegWriteUTVAL)
);

// Unidade geradora do imediato
ImmGen IMMGEN0 (
    .iInstrucao             (wInstr),
    .oImm                   (wImmediate)
);


// ALU - Unidade Lógica-Artimética
ALU ALU0 (
    .iControl               (wCALUControl),
    .iA                     (wOrigAULA),
    .iB                     (wOrigBULA),
    .oResult                (wALUresult),
    .oZero                  ()
);


`ifdef RV32IMF
//FPALU
FPALU FPALU0 (
    .iclock                 (iCLK50),           // clock inserir clock_50
    .icontrol               (wCFPALUControl),   // 5 bits para saber qual eh a operacao a ser realizada (olhar parametros)
    .idataa                 (wOrigAFPALU),      // novo multiplexador, ja que a entrada a da ula pode conter inteiro ou float, a principio
    .idatab                 (wFRead2),          // liga a saida b do banco de registradores float diretamente na ULA
    .istart                 (wCFPstart),        // calcula só com instruções tipo-FR
    .oresult                (wFPALUResult),     // Saida da ULA
    .oready                 ()                  // não importa se está pronto ou não, a freq. de clock deve ser projetada para o pior caso
);
`endif


// Unidade de controle de escrita
MemStore MEMSTORE0 (
    .iAlignment             (wALUresult[1:0]),
    .iFunct3                (wFunct3),
    .iData                  (wWrite2Mem),
    .oData                  (wMemDataWrite),
    .oByteEnable            (wMemEnable)
);


// Unidade de controle de leitura
MemLoad MEMLOAD0 (
    .iAlignment             (wALUresult[1:0]),
    .iFunct3                (wFunct3),
    .iData                  (wReadData),
    .oData                  (wMemLoad)
);


// Unidade de controle de Branches
BranchControl BC0 (
    .iFunct3                (wFunct3),
    .iA                     (wRead1),
    .iB                     (wRead2),
    .oBranch                (wBranch)
);


// ******************************************************
// multiplexadores
always @(*) begin
    case(wCOrigAULA)
        2'b00:      wOrigAULA = wRead1;
        2'b01:      wOrigAULA = PC;
        2'b10:      wOrigAULA = wImmediate;
        2'b11:      wOrigAULA = ~wRead1; // valor do conteudo de rs1 negado para csrrc
        default:    wOrigAULA = ZERO;
    endcase
end

always @(*) begin
    case(wCOrigBULA)
        2'b00:      wOrigBULA = wRead2;
        2'b01:      wOrigBULA = wImmediate;
        2'b10:      wOrigBULA = wCSRead;
        2'b11:      wOrigBULA = ZERO;
        default:    wOrigBULA = ZERO;
    endcase
end

// NOTE: Seletor de 3 bits para 4 entradas???
`ifdef RV32IMF
always @(*) begin   // Novo fio de saida para fazer os multiplexadores em cascata
    case(wCMem2Reg)
        3'b000:     wMem2Reg = wALUresult;     // Tipo-R e Tipo-I
        3'b001:     wMem2Reg = wPC4;               // jalr e jal
        3'b010:     wMem2Reg = wMemLoad;           // Loads
        3'b100:     wMem2Reg = wCSRead;            // Load from CSR
      default:      wMem2Reg = ZERO;
    endcase
end
`else
always @(*) begin
    case(wCMem2Reg)
        3'b000:     wRegWrite = wALUresult;        // Tipo-R e Tipo-I
        3'b001:     wRegWrite = wPC4;              // jalr e jal
        3'b010:     wRegWrite = wMemLoad;          // Loads
        3'b100:     wRegWrite = wCSRead;           // Load from CSR
        default:    wRegWrite = ZERO;
    endcase
end
`endif

always @(*) begin
    if(wExPcToUtvec) // exception
        wiPC <= wCSRegReadUTVEC;
    else begin
        case(wCOrigPC)
            3'b000:     wiPC = wPC4;                                   // PC+4
            3'b001:     wiPC = wBranch ? wBranchPC: wPC4;              // Branches
            3'b010:     wiPC = wBranchPC;                              // jal
            3'b011:     wiPC = (wRead1+wImmediate) & ~(32'h00000001);  // jalr
            3'b100:     wiPC = wCSRegReadUTVEC;                        // UTVEC
            3'b101:     wiPC = wCSRegReadUEPC;                         // UEPC (para o uret)
            default:    wiPC = ZERO;
        endcase
    end
end

`ifdef RV32IMF
always @(*) begin
    case(wCOrigAFPALU) //
        1'b0:      wOrigAFPALU = wRead1;
        1'b1:      wOrigAFPALU = wFRead1;
        default:   wOrigAFPALU = ZERO;
    endcase
end

always @(*) begin
    case(wCFPALU2Reg) // Multiplexador intermediario para definir se o que entra no RegWrite do banco de registradores vem da FPULA ou do mux original implementado na ISA RV32I
        1'b0:      wRegWrite = wMem2Reg;
        1'b1:      wRegWrite = wFPALUResult;
        default:   wRegWrite = ZERO;
    endcase
end

always @(*) begin
    case(wCFWriteData) // Multiplexador que controla o que vai ser escrito em um registrador de ponto flutuante (origem memoria ou FPALU?)
        1'b0:      wFWriteData = wFPALUResult;
        1'b1:      wFWriteData = wMemLoad;
        default:   wFWriteData = ZERO;
    endcase
end

always @(*) begin
    case(wCWrite2Mem) // Multiplexador que controla o que vai ser escrito na memoria (vem do Register(0) ou do FRegister(1)?)
        1'b0:      wWrite2Mem = wRead2;
        1'b1:      wWrite2Mem = wFRead2;
        default:   wWrite2Mem = ZERO;
    endcase
end
`else
always @(*) begin
    wWrite2Mem = wRead2;
end
`endif


// ******************************************************
// A cada ciclo de clock
always @(posedge iCLK or posedge iRST) begin
    if(iRST) begin
        PC              <= iInitialPC;
        instret_counter <= 64'b0;
    end
    else begin
        PC              <= wiPC;
        instret_counter <= instret_counter + 64'd1;
    end
end

endmodule

