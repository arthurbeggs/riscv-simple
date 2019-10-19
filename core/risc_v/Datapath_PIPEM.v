`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

//
// Caminho de dados processador RISC-V Pipeline
//
// 2019-1 Marcus Vinicius Lamar
//


module Datapath_PIPEM (
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
    output [31:0] wID_Instr,
    input  wID_CRegWrite,
    input  wID_CSRegWrite,
    input  wID_CInvInstr,
    input  wID_CEcall,
    input  [ 1:0] wID_COrigAULA,
    input  [ 1:0] wID_COrigBULA,
    input  [ 2:0] wID_COrigPC,
    input  [ 2:0] wID_CMem2Reg,
    input  wID_CMemRead,
    input  wID_CMemWrite,
    input  [ 4:0] wID_CALUControl,
    input  [NTYPE-1:0] wID_InstrType,
`ifdef RV32IMF
    input  wID_CFRegWrite, // Fio que vem da controladora e habilita escrita no FReg
    input  [ 4:0] wID_CFPALUControl,
    input  wID_CFPALUStart,
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

// Sinais de monitoramento e Debug
assign mPC                  = PC;
assign mInstr               = wIF_Instr;

// Registradores do Pipeline

// Quando fizer alguma modificação basta modificar esses parâmetros no Parametros.v
//parameter NIFID  = 96,
//          NIDEX  = 198,
//          NEXMEM = 149,
//          NMEMWB = 144;

reg  [ NIFID-1:0] RegIFID;
reg  [ NIDEX-1:0] RegIDEX;
reg  [NEXMEM-1:0] RegEXMEM;
reg  [NMEMWB-1:0] RegMEMWB;
reg  [63:0] instret_counter;

initial begin
    RegIFID         <= {NIFID {1'b0}};
    RegIDEX         <= {NIDEX {1'b0}};
    RegEXMEM        <= {NEXMEM{1'b0}};
    RegMEMWB        <= {NMEMWB{1'b0}};
    instret_counter <= 64'b0;
end


//=====================================================================//
//======================== Estagio IF =================================//
//=====================================================================//

// Definicao dos registradores
reg  [31:0] PC;        // registrador PC

initial PC <= BEGINNING_TEXT;

// ******************************************************
// Instanciacao das estruturas
wire [31:0] wIF_PC4 = PC + 32'h00000004;        // Calculo PC+4 // PC+4 do estagio IF

// Barramento da Memoria de Instrucoes          // Aqui eh so o barramento porque a memoria esta fora do datapath
wire [31:0] wIF_Instr         = IwReadData;     // Dado lido da memoria de instrucoes IF na variavel significa que o sinal esta sendo gerado na etapa IF
assign      IwReadEnable      = ON;
assign      IwWriteEnable     = OFF;
assign      IwByteEnable      = 4'b1111;
assign      IwAddress         = PC;
assign      IwWriteData       = ZERO;


// ******************************************************
// multiplexadores
wire [31:0] wIF_iPC;

always @(*) begin
    if(!wMEM_ExceptionPcToUTVEC)
        case(wID_COrigPC)
            3'b000:     wIF_iPC <= wIF_PC4;                                     // PC+4
            3'b001:     wIF_iPC <= wID_BranchResult ? wID_BranchPC: wID_PC4;    // Branches
            3'b010:     wIF_iPC <= wID_BranchPC;                                // jal
            3'b011:     wIF_iPC <= wID_JalrPC;                                  // jalr
            3'b100:     wIF_iPC <= wID_ForwardUEPC;                             // uret
            3'b101:     wIF_iPC <= wID_ForwardUTVEC;                            // ecall
            default:    wIF_iPC <= ZERO;
        endcase
    else
        wIF_iPC <= wID_CSRegReadUTVEC;                                          // exception
end
// ******************************************************
// A cada ciclo de clock

always @(posedge iCLK or posedge iRST) begin
    if(iRST) begin
        PC          <= iInitialPC;
        RegIFID  <= {NIFID{1'b0}};
    end
    else begin
        if (!wIF_Stall) // Verifica se o estagio IF nao esta em stall (se estiver, desabilita escrita em PC)
            PC <= wIF_iPC;
        if (wIFID_Flush) begin  // "Zera" o registrador IFID, zerar eh colocar um NOP
            RegIFID[31: 0] <= PC;
            RegIFID[63:32]  <= 32'h00000013;  // NOP = addi x0,x0,0
            RegIFID[95:64] <= wIF_PC4;
        end
        else if (!wIF_Stall) begin // Se o stall estiver ativado o RegIFID tambem nao pode ser alterado
            RegIFID[31: 0] <= PC;
            RegIFID[63:32] <= wIF_Instr;
            RegIFID[95:64] <= wIF_PC4; // PC+4 tambem esta sendo passado adiante no laboratorio por causa do jal e jalr
        end
    end
end


//=====================================================================//
//======================== Estagio ID =================================//
//=====================================================================//


// ******************************************************
// Definicao dos fios e registradores

// IF/ID register wires
wire [31:0] wID_PC      = RegIFID[31: 0]; // ID_PC eh o PC que esta no estagio ID
assign      wID_Instr   = RegIFID[63:32]; // Instrucao que estiver no estagio ID
wire [31:0] wID_PC4     = RegIFID[95:64];

// Instruction decode wires
wire [ 2:0] wID_Funct3  = wID_Instr[14:12]; // Decomposicao da instrucao
wire [ 4:0] wID_Rs1     = wID_Instr[19:15];
wire [ 4:0] wID_Rs2     = wID_Instr[24:20];
wire [ 4:0] wID_Rd      = wID_Instr[11: 7];
wire [11:0] wID_CSR     = wID_Instr[31:20];

// ******************************************************
// Instanciacao das estruturas
wire [31:0] wID_BranchPC    = wID_PC + wID_Immediate;                             // Somador para calcular o branch
wire [31:0] wID_JalrPC      = (wID_ForwardRs1 + wID_Immediate) & ~(32'h00000001); // Somador para calcular jalr

// Banco de Registradores
wire [31:0] wID_Read1;    // Fios de saida do banco de registradores
wire [31:0] wID_Read2;

Registers REGISTERS0 (
    .iCLK           (iCLK),
    .iRST           (iRST),
    .iReadRegister1 (wID_Rs1),
    .iReadRegister2 (wID_Rs2),
    .iWriteRegister (wWB_Rd),
    .iWriteData     (wWB_RegWrite),
    .iRegWrite      (wWB_CRegWrite),
    .oReadData1     (wID_Read1),
    .oReadData2     (wID_Read2),

    .iVGASelect     (reg_debug_address),
    .oVGARead       (reg_debug_data)
);


`ifdef RV32IMF
wire [31:0] wID_FRead1;    // Fios de saida do banco de registradores de ponto flutuante
wire [31:0] wID_FRead2;

FRegisters REGISTERS1 (
    .iCLK           (iCLK),
    .iRST           (iRST),
    .iReadRegister1 (wID_Rs1),
    .iReadRegister2 (wID_Rs2),
    .iWriteRegister (wWB_Rd),
    .iWriteData     (wWB_RegWrite),
    .iRegWrite      (wWB_CFRegWrite),
    .oReadData1     (wID_FRead1),
    .oReadData2     (wID_FRead2),

    .iVGASelect     (reg_debug_address),
    .oVGARead       (fp_reg_debug_data)
);
`endif

wire [31:0] wID_CSRegReadUTVEC;
wire [31:0] wID_CSRegReadUEPC;
wire [31:0] wID_CSRegReadUSTATUS;
wire [31:0] wID_CSRegReadUTVAL;
wire [31:0] wID_CSRead;

CSRegisters REGISTERS2 (
    .core_clock             (iCLK),
    .reset                  (iRST),
    .iRegWrite              (wWB_CSRegWrite),           // escrita pelo codigo csr
    .iRegWriteSimu          (wWB_ExceptionRegWrite),    // esctita simultanea em uepc ucause e utval usado pelo exception control
    .register_read_address  (wID_CSR),
    .register_write_address (wID_CSR),
    .iWriteData             (wWB_ALUresult),            // escreve no csr o valor que sai de da ula
    .oReadData              (wID_CSRead),               // le do csr o valor e escreve no rd
    .iWriteDataUEPC         (wWB_CSRegWriteUEPC),
    .iWriteDataUCAUSE       (wWB_CSRegWriteUCAUSE),
    .iWriteDataUTVAL        (wWB_CSRegWriteUTVAL),      // escrita registradores especiais precisam de acesso simultaneo
    .oReadDataUTVEC         (wID_CSRegReadUTVEC),       // leitura registradores especiais precisam de acesso simultaneo
    .oReadDataUEPC          (wID_CSRegReadUEPC),
    .oReadDataUSTATUS       (wID_CSRegReadUSTATUS),
    .oReadDataUTVAL         (wID_CSRegReadUTVAL),
    .cycles_counter         (cycles_counter),
    .time_counter           (time_counter),
    .instret_counter        (instret_counter),

    .csr_debug_address      (csr_debug_address),
    .csr_debug_data         (csr_debug_data)
);


// Unidade geradora do imediato
wire [31:0] wID_Immediate;

ImmGen IMMGEN0 (
    .iInstrucao     (wID_Instr),
    .oImm           (wID_Immediate)
);

// Unidade de controle de Branches
wire wID_BranchResult;

BranchControl BC0 (
    .iFunct3        (wID_Funct3),
    .iA             (wID_ForwardRs1), // Esta sendo feito o forward aqui!
    .iB             (wID_ForwardRs2),
    .oBranch        (wID_BranchResult)
);


// Unidade de Forward e Harzard
wire wIF_Stall, wID_Stall, wEX_Stall, wMEM_Stall, wWB_Stall;
wire wIFID_Flush, wIDEX_Flush, wEXMEM_Flush, wMEMWB_Flush;
wire [ 2:0] wFwdA;
wire [ 2:0] wFwdB;
wire [ 2:0] wFwdRs1;
wire [ 2:0] wFwdRs2;
wire [ 1:0] wFwdCSR;
wire [ 1:0] wFwdUEPC;
wire [ 1:0] wFwdUTVEC;

FwdHazardUnitM FHU0 (
    .iCLK                   (iCLK),
    .iID_Rs1                (wID_Rs1),
    .iID_Rs2                (wID_Rs2),
    .iID_Rd                 (wID_Rd),
    .iID_CSR                (wID_CSR),
    .iID_OrigPC             (wID_COrigPC),

    .iEX_Rs1                (wEX_Rs1),
    .iEX_Rs2                (wEX_Rs2),
    .iEX_Rd                 (wEX_Rd),
    .iEX_CSR                (wEX_CSR),

    .iMEM_Rd                (wMEM_Rd),
    .iMEM_CSR               (wMEM_CSR),
    .iMEM_Exception         (wMEM_ExceptionPcToUTVEC),

    .iWB_Rd                 (wWB_Rd),
    .iWB_CSR                (wWB_CSR),

    .iID_InstrType          (wID_InstrType),
    .iEX_InstrType          (wEX_InstrType),
    .iMEM_InstrType         (wMEM_InstrType),
    .iWB_InstrType          (wWB_InstrType),

    .iBranch                (wID_BranchResult),             // resultado do branch em ID
`ifdef RV32IMF
    .iEX_FPALUStart         (wEX_CFPALUStart),
    .iEX_FPALUReady         (wEX_FPALUReady),
`endif

    .oIF_Stall              (wIF_Stall),
    .oID_Stall              (wID_Stall),
    .oEX_Stall              (wEX_Stall),
    .oMEM_Stall             (wMEM_Stall),
    .oWB_Stall              (wWB_Stall),
    .oIFID_Flush            (wIFID_Flush),
    .oIDEX_Flush            (wIDEX_Flush),
    .oEXMEM_Flush           (wEXMEM_Flush),
    .oMEMWB_Flush           (wMEMWB_Flush),

    .oFwdRs1                (wFwdRs1),
    .oFwdRs2                (wFwdRs2),
    .oFwdA                  (wFwdA),
    .oFwdB                  (wFwdB),
    .oFwdCSR                (wFwdCSR),

    .oFwdUEPC               (wFwdUEPC),
    .oFwdUTVEC              (wFwdUTVEC)
);


// ******************************************************
// multiplexadores
wire [31:0] wID_ForwardUEPC;
wire [31:0] wID_ForwardUTVEC;

always @(*) begin
    case(wFwdUEPC)
        2'b00:      wID_ForwardUEPC <= wID_CSRegReadUEPC;
        2'b01:      wID_ForwardUEPC <= wEX_ALUresult;
        2'b10:      wID_ForwardUEPC <= wMEM_ALUresult;
        default:    wID_ForwardUEPC <= 2'b00;
    endcase

    case(wFwdUTVEC)
        2'b00:      wID_ForwardUTVEC <= wID_CSRegReadUTVEC;
        2'b01:      wID_ForwardUTVEC <= wEX_ALUresult;
        2'b10:      wID_ForwardUTVEC <= wMEM_ALUresult;
        default:    wID_ForwardUTVEC <= 2'b00;
    endcase
end

wire [31:0] wID_ForwardRs1;

always @(*) begin
    case(wFwdRs1)
        3'b000:   wID_ForwardRs1 <= wID_Read1;
        3'b001:   wID_ForwardRs1 <= wEX_ALUresult;
        3'b010:   wID_ForwardRs1 <= wMEM_ALUresult;
        3'b011:   wID_ForwardRs1 <= wWB_RegWrite;
//      3'b100:   wID_ForwardRs1 <= wID_PC4;
`ifdef RV32IMF
        3'b100:   wID_ForwardRs1 <= wEX_FPALUResult; // Nao sei se vai ser necessario ainda
`endif
        3'b101:   wID_ForwardRs1 <= wEX_PC4;
        3'b110:   wID_ForwardRs1 <= wMEM_PC4;
//      3'b111:   wID_ForwardRs1 <= wWB_PC4;
`ifdef RV32IMF
        3'b111:   wID_ForwardRs1 <= wMEM_FPALUResult; // Nao sei se vai ser necessario ainda
`endif
        default:  wID_ForwardRs1 <= ZERO;
    endcase
end


wire [31:0] wID_ForwardRs2;

always @(*) begin
    case(wFwdRs2)
        3'b000:   wID_ForwardRs2 <= wID_Read2;
        3'b001:   wID_ForwardRs2 <= wEX_ALUresult;
        3'b010:   wID_ForwardRs2 <= wMEM_ALUresult;
        3'b011:   wID_ForwardRs2 <= wWB_RegWrite;
//      3'b100:   wID_ForwardRs2 <= wID_PC4;
`ifdef RV32IMF
        3'b100:   wID_ForwardRs2 <= wEX_FPALUResult; // Nao sei se vai ser necessario ainda
`endif
        3'b101:   wID_ForwardRs2 <= wEX_PC4;
        3'b110:   wID_ForwardRs2 <= wMEM_PC4;
//      3'b111:   wID_ForwardRs2 <= wWB_PC4;
`ifdef RV32IMF
        3'b111:   wID_ForwardRs2 <= wMEM_FPALUResult; // Nao sei se vai ser necessario ainda
`endif
        default:  wID_ForwardRs2 <= ZERO;
    endcase
end


// ******************************************************
// A cada ciclo de clock

always @(posedge iCLK or posedge iRST) begin
    if (iRST)
        RegIDEX <= {NIDEX{1'b0}};
    else begin
        if (wIDEX_Flush)
            RegIDEX[NIDEX-1:32] <= {(NIDEX-32){1'b0}};
        else if (!wID_Stall) begin // Necessita de stall qnd eh um load seguido de uma instrucao do tipo R
            RegIDEX[ 31:  0] <= wID_PC;             // 32
            RegIDEX[ 63: 32] <= wID_Read1;          // 32
            RegIDEX[ 95: 64] <= wID_Read2;          // 32
            RegIDEX[100: 96] <= wID_Rs1;            // 5
            RegIDEX[105:101] <= wID_Rs2;            // 5
            RegIDEX[110:106] <= wID_Rd;             // 5
            RegIDEX[113:111] <= wID_Funct3;         // 3
            RegIDEX[118:114] <= wID_CALUControl;    // 5
            RegIDEX[120:119] <= wID_COrigAULA;      // 2
            RegIDEX[122:121] <= wID_COrigBULA;      // 2
            RegIDEX[    123] <= wID_CMemRead;       // 1
            RegIDEX[    124] <= wID_CMemWrite;      // 1
            RegIDEX[    125] <= wID_CRegWrite;      // 1
            RegIDEX[128:126] <= wID_CMem2Reg;       // 3
            RegIDEX[160:129] <= wID_Immediate;      // 32
            RegIDEX[192:161] <= wID_PC4;            // 32
            RegIDEX[224:193] <= wID_CSRead;         // 32
            RegIDEX[    225] <= wID_CEcall;         // 1
            RegIDEX[    226] <= wID_CInvInstr;      // 1
            RegIDEX[    227] <= wID_CSRegWrite;     // 1
            RegIDEX[239:228] <= wID_CSR;            // 12
            RegIDEX[271:240] <= wID_Instr;          // 32
            // RegIDEX[274:272] <= wID_COrigPC;        // 3
            RegIDEX[NTYPE+275-1:275] <= wID_InstrType;  // 8 ou 14

`ifdef RV32IMF
            RegIDEX[    289] <= wID_CFRegWrite;     // 1
            RegIDEX[321:290] <= wID_FRead1;         // 32
            RegIDEX[353:322] <= wID_FRead2;         // 32
            RegIDEX[358:354] <= wID_CFPALUControl;  // 5
            RegIDEX[    359] <= wID_CFPALUStart;    // 1
`endif
        end
    end
end


//=====================================================================//
//======================== Estagio EX =================================//
//=====================================================================//


// ******************************************************
// Definicao dos fios e registradores

// ID/EX register wires
wire [31:0] wEX_PC              = RegIDEX[ 31:  0];
wire [31:0] wEX_Read1           = RegIDEX[ 63: 32];
wire [31:0] wEX_Read2           = RegIDEX[ 95: 64];
wire [ 4:0] wEX_Rs1             = RegIDEX[100: 96];
wire [ 4:0] wEX_Rs2             = RegIDEX[105:101];
wire [ 4:0] wEX_Rd              = RegIDEX[110:106];
wire [ 2:0] wEX_Funct3          = RegIDEX[113:111];
wire [ 4:0] wEX_CALUControl     = RegIDEX[118:114];
wire [ 1:0] wEX_COrigAULA       = RegIDEX[120:119];
wire [ 1:0] wEX_COrigBULA       = RegIDEX[122:121];
wire wEX_CMemRead               = RegIDEX[123];
wire wEX_CMemWrite              = RegIDEX[124];
wire wEX_CRegWrite              = RegIDEX[125];
wire [ 2:0] wEX_CMem2Reg        = RegIDEX[128:126];
wire [31:0] wEX_Immediate       = RegIDEX[160:129];
wire [31:0] wEX_PC4             = RegIDEX[192:161];
wire [31:0] wEX_CSRead          = RegIDEX[224:193];
wire wEX_CEcall                 = RegIDEX[225];
wire wEX_CInvInstr              = RegIDEX[226];
wire wEX_CSRegWrite             = RegIDEX[227];
wire [11:0] wEX_CSR             = RegIDEX[239:228];
wire [31:0] wEX_Instr           = RegIDEX[271:240];
// wire [ 2:0] wEX_COrigPC         = RegIDEX[274:272];
wire [NTYPE-1:0] wEX_InstrType  = RegIDEX[NTYPE+275-1:275];
`ifdef RV32IMF
wire wEX_CFRegWrite             = RegIDEX[289];
wire [31:0] wEX_FRead1          = RegIDEX[321:290];
wire [31:0] wEX_FRead2          = RegIDEX[353:322];
wire [ 4:0] wEX_CFPALUControl   = RegIDEX[358:354];
wire wEX_CFPALUStart            = RegIDEX[359];
`endif


// ******************************************************
// Instanciacao das estruturas
// ALU
wire [31:0] wEX_ALUresult;

ALU ALU0 (
    .iControl       (wEX_CALUControl),
    .iA             (wEX_OrigAULA),
    .iB             (wEX_OrigBULA),
    .oResult        (wEX_ALUresult),
    .oZero          ()
);

`ifdef RV32IMF
//FPALU
wire wEX_FPALUReady;
wire [31:0] wEX_FPALUResult;

FPALU FPALU0 (
    .iclock         (iCLK),
    .icontrol       (wEX_CFPALUControl),
    .idataa         (wEX_ForwardA),     // Esse mux ja seleciona entre Reg e FReg (adicao minha)
    .idatab         (wEX_ForwardB),     // Esse mux ja seleciona entre Reg e FReg (adicao minha)
    .istart         (wEX_CFPALUStart),  // Sinal de reset (start) que sera enviado pela controladora
    .oready         (wEX_FPALUReady),   // Output que sinaliza a controladora que a FPULA terminou a operacao
    .oresult        (wEX_FPALUResult)
);
`endif


// ******************************************************
// multiplexadores
wire [31:0] wEX_CSRForward;

always @(*) begin
    case(wFwdCSR[0])
        1'b0:       wEX_CSRForward <= wEX_CSRead;
        2'b1:       wEX_CSRForward <= wWB_ALUresult;
        default     wEX_CSRForward <= ZERO;
    endcase
end


wire [31:0] wEX_ForwardA;

always @(*) begin
    case(wFwdA)
        3'b000:   wEX_ForwardA <= wEX_Read1;        // sem forward
        // 3'b001:   wEX_ForwardA <= wEX_ALUresult;
`ifdef RV32IMF
        3'b001:   wEX_ForwardA <= wEX_FRead1;     // Seleciona read1 do FReg
`endif
        3'b010:   wEX_ForwardA <= wMEM_ALUresult;
        3'b011:   wEX_ForwardA <= wWB_RegWrite;
`ifdef RV32IMF
        3'b100:   wEX_ForwardA <= wMEM_FPALUResult;
`endif
        // 3'b101:   wEX_ForwardB <= wWB_ALUresult;
        3'b110:   wEX_ForwardA <= wMEM_PC4;
        // 3'b111:   wEX_ForwardA <= wWB_PC4;
        default:  wEX_ForwardA <= ZERO;
    endcase
end


wire [31:0] wEX_ForwardB;

always @(*) begin
    case(wFwdB)
        3'b000:   wEX_ForwardB <= wEX_Read2;        // sem forward
        // 3'b001:   wEX_ForwardB <= wEX_ALUresult;
`ifdef RV32IMF
        3'b001:   wEX_ForwardB <= wEX_FRead2;
`endif
        3'b010:   wEX_ForwardB <= wMEM_ALUresult;
        3'b011:   wEX_ForwardB <= wWB_RegWrite;
        // 3'b100:   wEX_ForwardB <= wID_PC4;
`ifdef RV32IMF
        3'b100:   wEX_ForwardB <= wMEM_FPALUResult;
`endif
        3'b101:   wEX_ForwardB <= wWB_ALUresult;
        3'b110:   wEX_ForwardB <= wMEM_PC4;
        3'b111:   wEX_ForwardB <= wEX_CSRead; // CSR sem forward
        default:  wEX_ForwardB <= ZERO;
    endcase
end


wire [31:0] wEX_OrigAULA;

always @(*) begin
    case(wEX_COrigAULA)
        2'b00:      wEX_OrigAULA <= wEX_ForwardA;
        2'b01:      wEX_OrigAULA <= wEX_PC;
        2'b10:      wEX_OrigAULA <= wEX_Immediate; // imediato n precisa de forward
        2'b11:      wEX_OrigAULA <= ~wEX_ForwardA; // negated fwrd a for the csrrc intruction that needs ~rs1
        default:    wEX_OrigAULA <= ZERO;
    endcase
end


wire [31:0] wEX_OrigBULA;

always @(*) begin
    case(wEX_COrigBULA)
        2'b00:      wEX_OrigBULA <= wEX_ForwardB;
        2'b01:      wEX_OrigBULA <= wEX_Immediate;
        2'b10:      wEX_OrigBULA <= ZERO;             // zero não precisa de forward
        default:    wEX_OrigBULA <= ZERO;
    endcase
end


// ******************************************************
// A cada ciclo de clock
always @(posedge iCLK or posedge iRST) begin
    if (iRST)
        RegEXMEM <= {NEXMEM{1'b0}};
    else begin
        if (wEXMEM_Flush)
            RegEXMEM[NEXMEM-1:32] <= {(NEXMEM-32){1'b0}};
        else if (!wEX_Stall) begin
            RegEXMEM[ 31:  0] <= wEX_PC;            //32
            RegEXMEM[ 63: 32] <= wEX_ALUresult;     //32
            RegEXMEM[ 95: 64] <= wEX_ForwardB;      //32
            RegEXMEM[     96] <= wEX_CMemRead;      //1
            RegEXMEM[     97] <= wEX_CMemWrite;     //1
            RegEXMEM[     98] <= wEX_CRegWrite;     //1
            RegEXMEM[103: 99] <= wEX_Rd;            //5
            RegEXMEM[106:104] <= wEX_Funct3;        //3
            RegEXMEM[109:107] <= wEX_CMem2Reg;      //3
            RegEXMEM[141:110] <= wEX_PC4;           //32
            RegEXMEM[    142] <= wEX_CSRegWrite;    //1
            RegEXMEM[154:143] <= wEX_CSR;           //12
            RegEXMEM[186:155] <= wEX_CSRForward;    //32
            RegEXMEM[218:187] <= wEX_Instr;
            RegEXMEM[    219] <= wEX_CInvInstr;
            RegEXMEM[    220] <= wEX_CEcall;
            // RegEXMEM[223:221] <= wEX_COrigPC;
            RegEXMEM[NTYPE+224-1:224] <= wEX_InstrType;
`ifdef RV32IMF
            RegEXMEM[    238] <= wEX_CFRegWrite;    // 1
            RegEXMEM[270:239] <= wEX_FPALUResult;   //32
`endif
        end
    end
end


//=====================================================================//
//======================== Estagio MEM ================================//
//=====================================================================//
// EX/MEM register wires
wire [31:0] wMEM_PC             = RegEXMEM[ 31:  0];
wire [31:0] wMEM_ALUresult      = RegEXMEM[ 63: 32];
wire [31:0] wMEM_ForwardB       = RegEXMEM[ 95: 64];
wire wMEM_CMemRead              = RegEXMEM[     96];
wire wMEM_CMemWrite             = RegEXMEM[     97];
wire wMEM_CRegWrite             = RegEXMEM[     98];
wire [ 4:0] wMEM_Rd             = RegEXMEM[103: 99];
wire [ 2:0] wMEM_Funct3         = RegEXMEM[106:104];
wire [ 2:0] wMEM_CMem2Reg       = RegEXMEM[109:107];
wire [31:0] wMEM_PC4            = RegEXMEM[141:110];
wire wMEM_CSRegWrite            = RegEXMEM[    142];
wire [11:0] wMEM_CSR            = RegEXMEM[154:143];
wire [31:0] wMEM_CSRead         = RegEXMEM[186:155];
wire [31:0] wMEM_Instr          = RegEXMEM[218:187];
wire wMEM_CInvInstr             = RegEXMEM[    219];
wire wMEM_CEcall                = RegEXMEM[    220];
// wire [ 2:0] wMEM_COrigPC        = RegEXMEM[223:221];
wire [NTYPE-1:0] wMEM_InstrType = RegEXMEM[NTYPE+224-1:224];
`ifdef RV32IMF
wire wMEM_CFRegWrite            = RegEXMEM[    238];
wire [31:0] wMEM_FPALUResult    = RegEXMEM[270:239];
`endif

// ******************************************************
// Instanciacao das estruturas

// Exception Controler

wire wMEM_ExceptionRegWrite;
wire wMEM_ExceptionPcToUTVEC;

wire [31:0] wMEM_CSRegWriteUEPC;
wire [31:0] wMEM_CSRegWriteUCAUSE;
wire [31:0] wMEM_CSRegWriteUTVAL;

ExceptionControl EXC0(
    .iExceptionEnabled      (wID_CSRegReadUSTATUS[0]),
    .iExInstrIllegal        (wMEM_CInvInstr),
    .iExEnviromentCall      (wMEM_CEcall),
    .iRegReadUTVAL          (wID_CSRegReadUTVAL), // gravar nele proprio quando por um ecall
    .iInstr                 (wMEM_Instr),
    .iPC                    (wMEM_PC),
    .iALUresult             (wMEM_ALUresult),
    .oExRegWrite            (wMEM_ExceptionRegWrite),
    .oExSetPcToUtvec        (wMEM_ExceptionPcToUTVEC), // seta o wipc para utvec independenete de instrução
    .oExUEPC                (wMEM_CSRegWriteUEPC),
    .oExUCAUSE              (wMEM_CSRegWriteUCAUSE),
    .oExUTVAL               (wMEM_CSRegWriteUTVAL)
);


// Unidade de controle de escrita
wire [31:0] wMEM_MemDataWrite;
wire [ 3:0] wMEM_MemEnable;

MemStore MEMSTORE0 (
    .iAlignment     (wMEM_ALUresult[1:0]),
    .iFunct3        (wMEM_Funct3),
    .iData          (wMEM_ForwardB),
    .oData          (wMEM_MemDataWrite),
    .oByteEnable    (wMEM_MemEnable)
);


// Barramento da memoria de dados
wire [31:0] wMEM_ReadData   = DwReadData;
assign DwReadEnable         = wMEM_CMemRead;
assign DwWriteEnable        = wMEM_CMemWrite;
assign DwByteEnable         = wMEM_MemEnable;
assign DwWriteData          = wMEM_MemDataWrite;
assign DwAddress            = wMEM_ALUresult;

// Unidade de controle de leitura
wire [31:0] wMEM_MemLoad;

MemLoad MEMLOAD0 (
    .iAlignment     (wMEM_ALUresult[1:0]),
    .iFunct3        (wMEM_Funct3),
    .iData          (wMEM_ReadData),
    .oData          (wMEM_MemLoad)
);


// ******************************************************
// multiplexadores
wire [31:0] wMEM_CSRForward;

always @(*)begin
    case(wFwdCSR[1])
        1'b0:       wMEM_CSRForward <= wMEM_CSRead;
        2'b1:       wMEM_CSRForward <= wWB_ALUresult;
        default     wMEM_CSRForward <= ZERO;
    endcase
end


// ******************************************************
// A cada ciclo de clock
always @(posedge iCLK or posedge iRST) begin
    if (iRST)
        RegMEMWB <= {NMEMWB{1'b0}};
    else begin
        if (wMEMWB_Flush)
            RegMEMWB[NMEMWB-1:32] <= {(NMEMWB-32){1'b0}};
        else if (!wMEM_Stall) begin
            RegMEMWB[ 31:  0]       <= wMEM_PC;                 //32
            RegMEMWB[ 63: 32]       <= wMEM_MemLoad;            //32
            RegMEMWB[ 95: 64]       <= wMEM_ALUresult;          //32
            RegMEMWB[100: 96]       <= wMEM_Rd;                 //5
            RegMEMWB[    101]       <= wMEM_CRegWrite;          //1
            RegMEMWB[104:102]       <= wMEM_CMem2Reg;           //3
            RegMEMWB[136:105]       <= wMEM_PC4;                //32
            RegMEMWB[    137]       <= wMEM_CSRegWrite;         //1
            RegMEMWB[149:138]       <= wMEM_CSR;                //12
            RegMEMWB[181:150]       <= wMEM_CSRForward;         //32
            RegMEMWB[213:182]       <= wMEM_CSRegWriteUEPC;     //32
            RegMEMWB[245:214]       <= wMEM_CSRegWriteUCAUSE;   //32
            RegMEMWB[277:246]       <= wMEM_CSRegWriteUTVAL;    //32
            RegMEMWB[    278]       <= wMEM_ExceptionRegWrite;  //1
            RegMEMWB[NTYPE+279-1:279]   <= wMEM_InstrType;
`ifdef RV32IMF
            RegMEMWB[    293]       <= wMEM_CFRegWrite;
            RegMEMWB[325:294]       <= wMEM_FPALUResult;
`endif
        end
    end
end


//=====================================================================//
//======================== Estagio WB =================================//
//=====================================================================//
// ******************************************************
// Definicao dos fios e registradores
// wire [31:0] wWB_PC                  = RegMEMWB[ 31:  0];
wire [31:0] wWB_MemLoad             = RegMEMWB[ 63: 32];
wire [31:0] wWB_ALUresult           = RegMEMWB[ 95: 64];
wire [ 4:0] wWB_Rd                  = RegMEMWB[100: 96];
wire wWB_CRegWrite                  = !wWB_Stall && RegMEMWB[101];  // Stall em WB
wire [ 2:0] wWB_CMem2Reg            = RegMEMWB[104:102];
wire [31:0] wWB_PC4                 = RegMEMWB[136:105];
wire wWB_CSRegWrite                 = !wWB_Stall && RegMEMWB[137];
wire [11:0] wWB_CSR                 = RegMEMWB[149:138];
wire [31:0] wWB_CSRead              = RegMEMWB[181:150];
wire [31:0] wWB_CSRegWriteUEPC      = RegMEMWB[213:182];    //32
wire [31:0] wWB_CSRegWriteUCAUSE    = RegMEMWB[245:214];    //32
wire [31:0] wWB_CSRegWriteUTVAL     = RegMEMWB[277:246];    //32
wire wWB_ExceptionRegWrite          = RegMEMWB[    278];    //1

wire [NTYPE-1:0] wWB_InstrType      = RegMEMWB[NTYPE+279-1:279];
`ifdef RV32IMF
wire wWB_CFRegWrite                 = !wWB_Stall && RegMEMWB[    293];
wire [31:0] wWB_FPALUResult         = RegMEMWB[325:294];
`endif


// ******************************************************
// multiplexadores
wire [31:0] wWB_RegWrite;

always @(*) begin
    case(wWB_CMem2Reg)
        3'b000:     wWB_RegWrite <= wWB_ALUresult;      // Tipo-R e Tipo-I
        3'b001:     wWB_RegWrite <= wWB_PC4;            // jalr e jal
        3'b010:     wWB_RegWrite <= wWB_MemLoad;        // Loads
`ifdef RV32IMF
        3'b011:     wWB_RegWrite <= wWB_FPALUResult;    // Tipo-FR
`endif
        3'b100:     wWB_RegWrite <= wWB_CSRead;         // CSR
        default:    wWB_RegWrite <= ZERO;
    endcase
end


// ******************************************************
// A cada ciclo de clock
reg  [63:0] instret_delay;

always @ (posedge iCLK or posedge iRST) begin
    if (iRST) begin
        instret_counter     <= 64'b0;
        instret_delay       <= 64'b0;
    end
    else if (!wWB_Stall && RegMEMWB) begin
        instret_delay       <= instret_delay + 64'd1;
        instret_counter     <= instret_delay;
    end
end


endmodule

