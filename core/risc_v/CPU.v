///////////////////////////////////////////////////////////////////////////////
//                     uCHARLES - RISC-V - Módulo Top Level                  //
//                                                                           //
//          Código fonte em https://github.com/arthurbeggs/uCHARLES          //
//                            BSD 3-Clause License                           //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module CPU (
    input  wire         iCLK,
    input  wire         iCLK_50,
    input  wire         iRST,

    // Sinais de monitoramento
    output wire [31:0]  mPC,
    output wire [31:0]  mInstr,
    output wire [ 5:0]  mControlState,
    input  wire [ 4:0]  mVGASelect,
    output wire [31:0]  mVGARead,
    output wire [31:0]  mCSRVGARead,
    output wire [31:0]  mFVGARead,
    output wire         mEbreak,

    // Barramentos de dados
    output wire         DReadEnable,
    output wire         DWriteEnable,
    output wire [ 3:0]  DByteEnable,
    output wire [31:0]  DAddress,
    output wire [31:0]  DWriteData,
    input  wire [31:0]  DReadData

    // // Interrupções
    // input  wire [7:0]   iPendingInterrupt
);


assign mEbreak = wCEbreak; // saida do ebreak para a interface de clock

// ************************* Memoria RAM Interface **************************
wire         IReadEnable;
wire         IWriteEnable;
wire [ 3:0]  IByteEnable;
wire [31:0]  IAddress;
wire [31:0]  IWriteData;
wire [31:0]  IReadData;

`ifdef MULTICICLO
Memory_Interface MEMORY(
    .iCLK                   (iCLK),
    .iCLKMem                (iCLK_50),
    .wReadEnable            (DReadEnable),
    .wWriteEnable           (DWriteEnable),
    .wByteEnable            (DByteEnable),
    .wAddress               (DAddress),
    .wWriteData             (DWriteData),
    .wReadData              (DReadData)
);

`else       // Uniciclo e Pipeline
DataMemory_Interface MEMDATA(
    .iCLK                   (iCLK),
    .iCLKMem                (iCLK_50),
    .wReadEnable            (DReadEnable),
    .wWriteEnable           (DWriteEnable),
    .wByteEnable            (DByteEnable),
    .wAddress               (DAddress),
    .wWriteData             (DWriteData),
    .wReadData              (DReadData)
);

CodeMemory_Interface MEMCODE(
    .iCLK                   (iCLK),
    .iCLKMem                (iCLK_50),
    .wReadEnable            (IReadEnable),
    .wWriteEnable           (IWriteEnable),
    .wByteEnable            (IByteEnable),
    .wAddress               (IAddress),
    .wWriteData             (IWriteData),
    .wReadData              (IReadData)
);
`endif


//********************************** Uniciclo ********************************//
`ifdef UNICICLO

assign mControlState    = 6'b000000;

// Unidade de Controle
wire [ 1:0] wCOrigAULA;
wire [ 1:0] wCOrigBULA;
wire        wCRegWrite;
wire        wCCSRegWrite;
wire        wCMemWrite;
wire        wCMemRead;
wire        wCInvInstruction;
wire        wCEcall;
wire        wCEbreak;
wire [ 2:0] wCMem2Reg;
wire [ 2:0] wCOrigPC;
wire [ 4:0] wCALUControl;
`ifdef RV32IMF
wire        wCFRegWrite;
wire [ 4:0] wCFPALUControl;
wire        wCOrigAFPALU;
wire        wCFPALU2Reg;
wire        wCFWriteData;
wire        wCWrite2Mem;
wire        wCFPstart;
`endif

 Control_UNI CONTROL0 (
    .iInstr                 (wInstr),
    .oOrigAULA              (wCOrigAULA),
    .oOrigBULA              (wCOrigBULA),
    .oRegWrite              (wCRegWrite),
    .oCSRegWrite            (wCCSRegWrite),
    .oMemWrite              (wCMemWrite),
    .oMemRead               (wCMemRead),
    .oInvInstruction        (wCInvInstruction),
    .oEcall                 (wCEcall),
    .oEbreak                (wCEbreak),
    .oMem2Reg               (wCMem2Reg),
    .oOrigPC                (wCOrigPC),
    .oALUControl            (wCALUControl)
`ifdef RV32IMF
     ,
     .oFRegWrite            (wCFRegWrite),
     .oFPALUControl         (wCFPALUControl),
     .oOrigAFPALU           (wCOrigAFPALU),
     .oFPALU2Reg            (wCFPALU2Reg),
     .oFWriteData           (wCFWriteData),
     .oWrite2Mem            (wCWrite2Mem),
     .oFPstart              (wCFPstart)
`endif

);

// Caminho de Dados
wire [31:0]  wInstr;

Datapath_UNI DATAPATH0 (
    .iCLK                   (iCLK),
    .iCLK50                 (iCLK_50),
    .iRST                   (iRST),
    .iInitialPC             (BEGINNING_TEXT),

     // Sinais de monitoramento
    .mPC                    (mPC),
    .mInstr                 (mInstr),
    .mDebug                 (mDebug),
    .mRegDispSelect         (mRegDispSelect),
    .mRegDisp               (mRegDisp),
    .mCSRegDisp             (mCSRegDisp),
    .mFRegDisp              (mFRegDisp),
    .mVGASelect             (mVGASelect),
    .mVGARead               (mVGARead),
    .mCSRVGARead            (mCSRVGARead),
    .mFVGARead              (mFVGARead),
    .mRead1                 (mRead1),
    .mRead2                 (mRead2),
    .mRegWrite              (mRegWrite),
    .mULA                   (mULA),
`ifdef RV32IMF
    .mFPALU                 (mFPALU),
    .mFRead1                (mFRead1),
    .mFRead2                (mFRead2),
    .mOrigAFPALU            (mOrigAFPALU),
    .mFWriteData            (mFWriteData),
    .mCFRegWrite            (mCFRegWrite),
`endif

    // Sinais do Controle
    .wInstr                 (wInstr),
    .wCOrigAULA             (wCOrigAULA),
    .wCOrigBULA             (wCOrigBULA),
    .wCRegWrite             (wCRegWrite),
    .wCCSRegWrite           (wCCSRegWrite),
    .wCMemWrite             (wCMemWrite),
    .wCMemRead              (wCMemRead),
    .wCInvInstruction       (wCInvInstruction),
    .wCEcall                (wCEcall),
    .wCMem2Reg              (wCMem2Reg),
    .wCOrigPC               (wCOrigPC),
    .wCALUControl           (wCALUControl),
`ifdef RV32IMF
    .wCFRegWrite            (wCFRegWrite),
    .wCFPALUControl         (wCFPALUControl),
    .wCOrigAFPALU           (wCOrigAFPALU),
    .wCFPALU2Reg            (wCFPALU2Reg),
    .wCFWriteData           (wCFWriteData),
    .wCWrite2Mem            (wCWrite2Mem),
    .wCFPstart              (wCFPstart),
`endif

    // Barramento de dados
    .DwReadEnable           (DReadEnable),
    .DwWriteEnable          (DWriteEnable),
    .DwByteEnable           (DByteEnable),
    .DwWriteData            (DWriteData),
    .DwReadData             (DReadData),
    .DwAddress              (DAddress),

    // Barramento de instrucoes
    .IwReadEnable           (IReadEnable),
    .IwWriteEnable          (IWriteEnable),
    .IwByteEnable           (IByteEnable),
    .IwWriteData            (IWriteData),
    .IwReadData             (IReadData),
    .IwAddress              (IAddress)
);
 `endif


//********************************* Multiciclo *******************************//
`ifdef MULTICICLO

assign IReadEnable     = OFF;
assign IWriteEnable    = OFF;
assign IByteEnable     = 4'b0000;
assign IWriteData      = ZERO;
assign IAddress        = ZERO;

assign mControlState    = wCState;


// Unidade de Controle

wire             oInvInstruction; // invalid instruction
wire             wCEcall;
wire             wCEbreak;
wire             wCInvInstruction;
wire             wCEscreveIR;
wire             wCEscrevePC;
wire             wCEscrevePCCond;
wire             wCEscrevePCBack;
wire    [ 2:0] wCOrigAULA;
wire    [ 2:0] wCOrigBULA;
wire    [ 2:0] wCMem2Reg;
wire    [ 2:0] wCOrigPC;
wire             wCIouD;
wire             wCRegWrite;
wire             wCCSRegWrite; // habilita escrita no bando de registradores CSR pela codificação de 12 bits
wire             wCMemWrite;
wire             wCMemRead;
wire    [ 4:0] wCALUControl;
wire    [ 5:0] wCState;
`ifdef RV32IMF
wire             wFPALUReady;
wire             wCFRegWrite;
wire  [ 4:0] wCFPALUControl;
wire             wCOrigAFPALU;
wire             wCFPALUStart;
wire             wCFWriteData;
wire             wCWrite2Mem;
`endif



Control_MULTI CONTROL0 (
    .iCLK(iCLK),
    .iRST(iRST), // reseta a máquina de estados quando ocorrer exceção
    .iInstr(wInstr),
    .oEcall(wCEcall),
    .oEbreak(wCEbreak),
    .oInvInstruction(wCInvInstruction),
    .oEscreveIR(wCEscreveIR),
    .oEscrevePC(wCEscrevePC),
    .oEscrevePCCond(wCEscrevePCCond),
    .oEscrevePCBack(wCEscrevePCBack),
   .oOrigAULA(wCOrigAULA),
   .oOrigBULA(wCOrigBULA),
   .oMem2Reg(wCMem2Reg),
    .oOrigPC(wCOrigPC),
    .oIouD(wCIouD),
   .oRegWrite(wCRegWrite),
    .oCSRegWrite(wCCSRegWrite),
   .oMemWrite(wCMemWrite),
    .oMemRead(wCMemRead),
    .oALUControl(wCALUControl),
    .oState(wCState)
`ifdef RV32IMF
    ,
    .iFPALUReady(wFPALUReady),
    .oFRegWrite(wCFRegWrite),
    .oFPALUControl(wCFPALUControl),
    .oOrigAFPALU(wCOrigAFPALU),
    .oFPALUStart(wCFPALUStart),
    .oFWriteData(wCFWriteData),
    .oWrite2Mem(wCWrite2Mem)
`endif
    );




// Caminho de Dados
wire    [31:0] wInstr;


Datapath_MULTI DATAPATH0 (
    .iCLK(iCLK),
    .iCLK50(iCLK_50),
    .iRST(iRST),
    .iInitialPC(BEGINNING_TEXT),


     // Sinais de monitoramento
    .mPC(mPC),
    .mInstr(mInstr),
    .mDebug(mDebug),
    .mRegDispSelect(mRegDispSelect),
    .mRegDisp(mRegDisp),
     .mCSRegDisp(mCSRegDisp),
     .mFRegDisp(mFRegDisp),
    .mVGASelect(mVGASelect),
    .mVGARead(mVGARead),
     .mCSRVGARead(mCSRVGARead),
     .mFVGARead(mFVGARead),
     .mRead1(mRead1),
     .mRead2(mRead2),
     .mRegWrite(mRegWrite),
     .mULA(mULA),
`ifdef RV32IMF
     .mFPALU(mFPALU),
     .mFRead1(mFRead1),
     .mFRead2(mFRead2),
     .mOrigAFPALU(mOrigAFPALU),
     .mFWriteData(mFWriteData),
     .mCFRegWrite(mCFRegWrite),
`endif
    // Sinais do Controle
    .wInstr(wInstr),
    .wCEcall(wCEcall),
    .wCState(wCState),
    .wCInvInstruction(wCInvInstruction),
    .wCEscreveIR(wCEscreveIR),
    .wCEscrevePC(wCEscrevePC),
    .wCEscrevePCCond(wCEscrevePCCond),
    .wCEscrevePCBack(wCEscrevePCBack),
   .wCOrigAULA(wCOrigAULA),
   .wCOrigBULA(wCOrigBULA),
   .wCMem2Reg(wCMem2Reg),
    .wCOrigPC(wCOrigPC),
    .wCIouD(wCIouD),
   .wCCSRegWrite(wCCSRegWrite), // habilita escrita no bando de registradores CSR pela codificação de 12 bits
    .wCRegWrite(wCRegWrite),
   .wCMemWrite(wCMemWrite),
    .wCMemRead(wCMemRead),
    .wCALUControl(wCALUControl),
`ifdef RV32IMF
    .wFPALUReady(wFPALUReady),
    .wCFRegWrite(wCFRegWrite),
    .wCFPALUControl(wCFPALUControl),
    .wCOrigAFPALU(wCOrigAFPALU),
    .wCFPALUStart(wCFPALUStart),
    .wCFWriteData(wCFWriteData),
    .wCWrite2Mem(wCWrite2Mem),
`endif

    // Barramento
    .DwWriteEnable(DWriteEnable), .DwReadEnable(DReadEnable),
    .DwByteEnable(DByteEnable),
    .DwWriteData(DWriteData),
    .DwAddress(DAddress),
    .DwReadData(DReadData)
);
`endif







/*************  PIPELINE **********************************/

`ifdef PIPELINE

assign mControlState    = 6'b111111;



// Unidade de Controle
wire            wCEbreak;
wire        wID_CRegWrite;
wire        wID_CSRegWrite;
wire        wID_CEcall;
wire            wID_CInvInstr;
wire [ 1:0] wID_COrigAULA;
wire [ 1:0] wID_COrigBULA;
wire [ 2:0] wID_COrigPC;
wire [ 2:0] wID_CMem2Reg;
wire            wID_CMemRead;
wire            wID_CMemWrite;
wire [ 4:0] wID_CALUControl;
wire [NTYPE-1:0] wID_InstrType;
`ifdef RV32IMF
wire        wID_CFRegWrite;
wire [ 4:0] wID_CFPALUControl;
wire        wID_CFPALUStart;
`endif

Control_PIPEM CONTROL0 (
    .iInstr(wID_Instr),
`ifdef RV32IMF
     .iFPALUReady(wEX_FPALUReady),
`endif
     .oInvInstr(wID_CInvInstr),
     .oEbreak(wCEbreak),
     .oEcall(wID_CEcall),
    .oOrigAULA(wID_COrigAULA),
    .oOrigBULA(wID_COrigBULA),
    .oMem2Reg(wID_CMem2Reg),
    .oRegWrite(wID_CRegWrite),
     .oCSRegWrite(wID_CSRegWrite),
    .oMemWrite(wID_CMemWrite),
     .oMemRead(wID_CMemRead),
    .oALUControl(wID_CALUControl),
    .oOrigPC(wID_COrigPC),
     .oInstrType(wID_InstrType)
`ifdef RV32IMF
     ,
     .oFRegWrite(wID_CFRegWrite),
     .oFPALUControl(wID_CFPALUControl),
     .oFPALUStart(wID_CFPALUStart)
`endif
);


// Caminho de Dados
wire    [31:0] wID_Instr;
`ifdef RV32IMF
wire         wEX_FPALUReady;
`endif

Datapath_PIPEM DATAPATH0 (
    .iCLK(iCLK),
    .iCLK50(iCLK_50),
    .iRST(iRST),
    .iInitialPC(BEGINNING_TEXT),

      // Sinais de monitoramento
    .mPC(mPC),
    .mInstr(mInstr),
    .mDebug(mDebug),
    .mRegDispSelect(mRegDispSelect),
    .mRegDisp(mRegDisp),
     .mCSRegDisp(mCSRegDisp),
     .mFRegDisp(mFRegDisp),
    .mVGASelect(mVGASelect),
    .mVGARead(mVGARead),
     .mFVGARead(mFVGARead),
     .mCSRVGARead(mCSRVGARead),
     .mRead1(mRead1),
     .mRead2(mRead2),
     .mRegWrite(mRegWrite),
     .mULA(mULA),
`ifdef RV32IMF
     .mFPALU(mFPALU),
     .mFRead1(mFRead1),
     .mFRead2(mFRead2),
     .mOrigAFPALU(mOrigAFPALU),
     .mFWriteData(mFWriteData),
     .mCFRegWrite(mCFRegWrite),
     .oEX_FPALUReady(wEX_FPALUReady),
`endif


    // Sinais do Controle
    .wID_Instr(wID_Instr),
     .wID_CInvInstr(wID_CInvInstr),
     .wID_CEcall(wID_CEcall),
    .wID_COrigAULA(wID_COrigAULA),
    .wID_COrigBULA(wID_COrigBULA),
    .wID_CMem2Reg(wID_CMem2Reg),
    .wID_CRegWrite(wID_CRegWrite),
     .wID_CSRegWrite(wID_CSRegWrite),
    .wID_CMemWrite(wID_CMemWrite),
     .wID_CMemRead(wID_CMemRead),
    .wID_CALUControl(wID_CALUControl),
    .wID_COrigPC(wID_COrigPC),
     .wID_InstrType(wID_InstrType),
`ifdef RV32IMF
     .wID_CFRegWrite(wID_CFRegWrite),
     .wID_CFPALUControl(wID_CFPALUControl),
     .wID_CFPALUStart(wID_CFPALUStart),
`endif


    // Barramento de dados
    .DwReadEnable(DReadEnable), .DwWriteEnable(DWriteEnable),
    .DwByteEnable(DByteEnable),
    .DwWriteData(DWriteData),
    .DwReadData(DReadData),
    .DwAddress(DAddress),

    // Barramento de instrucoes
    .IwReadEnable(IReadEnable), .IwWriteEnable(IWriteEnable),
    .IwByteEnable(IByteEnable),
    .IwWriteData(IWriteData),
    .IwReadData(IReadData),
    .IwAddress(IAddress),

     // Para Debug
     .oiIF_PC(oiIF_PC),
     .oiIF_Instr(oiIF_Instr),
     .oiIF_PC4(oiIF_PC4),
     .oRegIFID(oRegIFID),
     .oRegIDEX(oRegIDEX),
     .oRegEXMEM(oRegEXMEM),
     .oRegMEMWB(oRegMEMWB),
     .oWB_RegWrite(oWB_RegWrite)

);

`endif


endmodule
