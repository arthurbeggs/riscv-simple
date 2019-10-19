`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

//
// Caminho de dados processador RISC-V Multiciclo
//
// 2018-2 Marcus Vinicius Lamar
//

module Datapath_MULTI (
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
    input  [63:0] instret_counter,

    // Sinais do Controle
    output [31:0] wInstr,
    input  wCEcall,             // ecall
    input  [ 5:0] wCState,
    input  wCInvInstruction,    // inv instruction
    input  wCEscreveIR,
    input  wCEscrevePC,
    input  wCEscrevePCCond,
    input  wCEscrevePCBack,
    input  [ 2:0] wCOrigAULA,
    input  [ 2:0] wCOrigBULA,
    input  [ 2:0] wCMem2Reg,
    input  [ 2:0] wCOrigPC,
    input  wCIouD,
    input  wCRegWrite,
    input  wCCSRegWrite, // habilita escrita no bando de registradores CSR pela codificação de 12 bits
    input  wCMemWrite,
    input  wCMemRead,
    input  [ 4:0] wCALUControl,
`ifdef RV32IMF
    output wFPALUReady,
    input  wCFRegWrite,
    input  [ 4:0] wCFPALUControl,
    input  wCOrigAFPALU,
    input  wCFPALUStart,
    input  wCFWriteData,
    input  wCWrite2Mem,
`endif

    //  Barramento
    output DwReadEnable,
    output DwWriteEnable,
    output [ 3:0] DwByteEnable,
    output [31:0] DwAddress,
    input  [31:0] DwReadData,
    output [31:0] DwWriteData
);

// Sinais de monitoramento e Debug
assign mPC                  = PC;
assign mInstr               = IR;

`ifndef RV32IMF
assign fp_reg_debug_data    = ZERO;
`endif

// ******************************************************
// Instanciação e Inicializacao dos registradores

reg  [31:0] PC, PCBack, IR, MDR, A, B, ALUOut , CSR; // adicionado registrados CSR na saida do banco
`ifdef RV32IMF
reg  [31:0] FA, FB, FPALUOut;
`endif

assign wInstr = IR;

initial begin
    PC          <= BEGINNING_TEXT;
    PCBack      <= BEGINNING_TEXT;
    IR          <= ZERO;
    ALUOut      <= ZERO;
    MDR         <= ZERO;
    A           <= ZERO;
    B           <= ZERO;
    CSR         <= ZERO;
`ifdef RV32IMF
    FA          <= ZERO;
    FB          <= ZERO;
    FPALUOut    <= ZERO;
`endif
end


// ******************************************************
// Instanciacao das estruturas

wire [11:0] wCSR    = IR[31:20]; // fio que codifica o registrador csr (12 bits)
wire [ 4:0] wRs1    = IR[19:15];
wire [ 4:0] wRs2    = IR[24:20];
wire [ 4:0] wRd     = IR[11:7];
wire [ 2:0] wFunct3 = IR[14:12];
// wire [ 6:0] wOpcode = IR[ 6:0 ];


// Unidade de controle de escrita
wire [31:0] wMemDataWrite;
wire [ 3:0] wMemEnable;

MemStore MEMSTORE0 (
    .iAlignment     (wMemAddress[1:0]),
    .iFunct3        (wFunct3),
`ifndef RV32IMF
    .iData          (B),                // Dado de escrita
`else
    .iData          (wWrite2Mem),
`endif
    .oData          (wMemDataWrite),
    .oByteEnable    (wMemEnable)
);


// Barramento da memoria
wire [31:0] wReadData;
assign DwReadEnable     = wCMemRead;
assign DwWriteEnable    = wCMemWrite;
assign DwByteEnable     = wMemEnable;
assign DwAddress        = wMemAddress;
assign DwWriteData      = wMemDataWrite;
assign wReadData        = DwReadData;

// Unidade de controle de leitura
wire [31:0] wMemLoad;

MemLoad MEMLOAD0 (
    .iAlignment     (wMemAddress[1:0]),
    .iFunct3        (wFunct3),
    .iData          (wReadData),
    .oData          (wMemLoad)
);


// Banco de Registradores
wire [31:0] wRead1, wRead2;

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

    .iVGASelect     (reg_debug_address),    // para mostrar Regs na tela
    .oVGARead       (reg_debug_data)        // para mostrar Regs na tela
);


`ifdef RV32IMF
wire [31:0] wFRead1;
wire [31:0] wFRead2;

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

    .iVGASelect     (reg_debug_address),    // para mostrar Regs na tela
    .oVGARead       (fp_reg_debug_data)     // para mostrar Regs na tela colocar wfvgaread
);
`endif

wire [31:0] wCSRegWriteUEPC;
wire [31:0] wCSRegWriteUCAUSE;
wire [31:0] wCSRegWriteUTVAL;
wire [31:0] wCSRegReadUSTATUS;
wire [31:0] wCSRegReadUTVEC;
wire [31:0] wCSRegReadUEPC;
wire [31:0] wCSRegReadUTVAL;
wire [31:0] wCSRead;

CSRegisters CSRegister2 (
    .core_clock             (iCLK),
    .reset                  (iRST),
    .iRegWrite              (wCCSRegWrite),         // escrita pelo codigo csr
    .iRegWriteSimu          (wExRegWrite),          // esctita simultanea em uepc ucause e utval
    .register_read_address  (wCSR),
    .register_write_address (wCSR),
    .iWriteData             (ALUOut),               // escreve no csr o valor que sai de rs1
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

    .csr_debug_address      (csr_debug_address),    // para mostrar Regs na tela
    .csr_debug_data         (csr_debug_data)        // para mostrar Regs na tela colocar wfvgaread
);

// unidade de controle de exceções
wire wExPcToUtvec;
wire wExRegWrite;

wire [31:0]ExcInstruction = IR;

ExceptionControl EXC0(
    .iExceptionEnabled  (wCSRegReadUSTATUS[0]),
    .iExInstrIllegal    (wCInvInstruction),
    .iExEnviromentCall  (wCEcall),
    .iRegReadUTVAL      (wCSRegReadUTVAL), // gravar nele proprio quando por um ecall
    .iCState            (wCState), // estado
    .iInstr             (ExcInstruction),
    .iPC                (PCBack),
    .iALUresult         (ALUOut),
    .oExRegWrite        (wExRegWrite),
    .oExSetPcToUtvec    (wExPcToUtvec), // seta o wipc para utvec independenete de instrução
    .oExUEPC            (wCSRegWriteUEPC),
    .oExUCAUSE          (wCSRegWriteUCAUSE),
    .oExUTVAL           (wCSRegWriteUTVAL)
);


// Unidade de controle de Branches
wire wBranch;

BranchControl BC0 (
    .iFunct3    (wFunct3),
    .iA         (A),
    .iB         (B),
    .oBranch    (wBranch)
);


// Unidade geradora do imediato
wire [31:0] wImmediate;

ImmGen IMMGEN0 (
    .iInstrucao (IR),
    .oImm       (wImmediate)
);


// ALU - Unidade Lógica Aritmética
wire [31:0] wALUresult;

ALU ALU0 (
    .iControl   (wCALUControl),
    .iA         (wOrigAULA),
    .iB         (wOrigBULA),
    .oResult    (wALUresult),
    .oZero      ()
);

`ifdef RV32IMF
//FPALU
//wire wFPALUReady;
wire [31:0] wFPALUResult;

FPALU FPALU0 (
    .iclock     (iCLK),
    .icontrol   (wCFPALUControl),
    .idataa     (wOrigAFPALU),
    .idatab     (FB),                    // Registrador B entra direto na FPULA
    .istart     (wCFPALUStart),            // Sinal de reset (start) que sera enviado pela controladora
    .oready     (wFPALUReady),           // Output que sinaliza a controladora que a FPULA terminou a operacao
    .oresult    (wFPALUResult)
);

`endif

// ******************************************************
// multiplexadores
wire [31:0] wOrigAULA;
always @(*) begin
    case(wCOrigAULA)
        3'b000:     wOrigAULA <= A;
        3'b001:     wOrigAULA <= PC;
        3'b010:     wOrigAULA <= PCBack;
        3'b011:     wOrigAULA <= wImmediate;
        3'b100:     wOrigAULA <= ~A; // valor de a negado para csrrc
        default:    wOrigAULA <= ZERO;
    endcase
end

wire [31:0] wOrigBULA;
always @(*) begin
    case(wCOrigBULA)
        3'b000:     wOrigBULA <= B;
        3'b001:     wOrigBULA <= 32'h00000004;
        3'b010:     wOrigBULA <= wImmediate;
        3'b011:     wOrigBULA <= CSR;
        3'b100:     wOrigBULA <= ZERO; // padronizar instruções csr para todas utilizarem ula
        default:    wOrigBULA <= ZERO;
    endcase
end

wire [31:0] wRegWrite;
always @(*) begin
    case(wCMem2Reg)
        3'b000:     wRegWrite <= ALUOut;
        3'b001:     wRegWrite <= PC;
        3'b010:     wRegWrite <= MDR;
        3'b100:     wRegWrite <= CSR;
`ifdef RV32IMF                                        //RV32IMF
        3'b011:     wRegWrite <= FPALUOut; // Uma entrada a mais no multiplexador de escrita no registrador de inteiros
`endif
        default:    wRegWrite <= ZERO;
    endcase
end

wire [31:0] wiPC;
always @(*) begin
    if(wExPcToUtvec) // exception
        wiPC <= wCSRegReadUTVEC;
    else
        case(wCOrigPC)
            3'b000:     wiPC <= wALUresult;                 // PC+4
            3'b001:     wiPC <= ALUOut;                     // Branches e jal
            3'b010:     wiPC <= wALUresult & ~(32'h1);  // jalr
            3'b011:     wiPC <= wCSRegReadUTVEC;            // ecall
            3'b100:     wiPC <= wCSRegReadUEPC;             // uret
            default:    wiPC <= ZERO;
        endcase
end

wire [31:0] wMemAddress;
always @(*) begin
    case(wCIouD)
        1'b0:       wMemAddress <= PC;
        1'b1:       wMemAddress <= ALUOut;
        default:    wMemAddress <= ZERO;
    endcase
end

`ifdef RV32IMF
wire [31:0] wOrigAFPALU;
always @(*) begin
    case(wCOrigAFPALU) // Multiplexador que controla a origem A da FPULA
        1'b0:      wOrigAFPALU <= A;
        1'b1:      wOrigAFPALU <= FA;
        default:   wOrigAFPALU <= ZERO;
    endcase
end

wire [31:0] wFWriteData;
always @(*) begin
    case(wCFWriteData) // Multiplexador que controla o que vai ser escrito em um registrador de ponto flutuante (origem memoria ou FPALU?)
        1'b0:      wFWriteData <= MDR;      // Registrador de dado de memoria (para o flw)
        1'b1:      wFWriteData <= FPALUOut; // Registrador da saida da FPULA
        default:   wFWriteData <= ZERO;
    endcase
end


wire [31:0] wWrite2Mem;
always @(*)begin
    case(wCWrite2Mem) // Multiplexador que controla o que vai ser escrito na memoria (vem do Register(0) ou do FRegister(1)?)
        1'b0:      wWrite2Mem <= B;
        1'b1:      wWrite2Mem <= FB;
        default:   wWrite2Mem <= ZERO;
    endcase
end
`endif


// ******************************************************
// A cada ciclo de clock
always @(posedge iCLK or posedge iRST) begin
    if (iRST) begin
        PC          <= iInitialPC;
        PCBack      <= iInitialPC;
        IR          <= ZERO;
        ALUOut      <= ZERO;
        MDR         <= ZERO;
        A           <= ZERO;
        B           <= ZERO;
        CSR         <= ZERO;
`ifdef RV32IMF
        FA          <= ZERO;
        FB          <= ZERO;
        FPALUOut    <= ZERO;
`endif
    end
    else begin
        // Unconditional
        ALUOut      <= wALUresult;
        A           <= wRead1;
        B           <= wRead2;
        CSR         <= wCSRead; // registrador csr receve o valor lido
        MDR         <= wMemLoad;
`ifdef RV32IMF
        FPALUOut    <= wFPALUResult;
        FA          <= wFRead1;
        FB          <= wFRead2;
`endif
        // Conditional
        if (wCEscreveIR)
            IR  <= wReadData;
        if (wCEscrevePCBack)
            PCBack <= PC;
        if (wExPcToUtvec || wCEscrevePC || wBranch & wCEscrevePCCond)
            PC  <= wiPC;
    end
end

endmodule

