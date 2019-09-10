/* Definicao do processador */
`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif


module CPU (
    input  wire        iCLK, iCLK50, iRST,
    input  wire [31:0] iInitialPC,

    //sinais de monitoramento
     output wire [31:0] mPC,
     output wire [31:0] mInstr,
     output wire [31:0] mDebug,
     output wire [ 5:0] mControlState,
    input  wire [ 4:0] mRegDispSelect,
    output wire [31:0] mRegDisp,
     output wire [31:0] mCSRegDisp,
     output wire [31:0] mFRegDisp,
    input  wire [ 4:0] mVGASelect,
    output wire [31:0] mVGARead,
     output wire [31:0] mCSRVGARead,
     output wire [31:0] mFVGARead,
     output wire [31:0] mRead1,
     output wire [31:0] mRead2,
     output wire [31:0] mRegWrite,
     output wire [31:0] mULA,
     output wire          mEbreak,
`ifdef RV32IMF
     output wire [31:0] mFPALU,       // Fio de monitoramento da FPALU
     output wire [31:0] mFRead1,      // Monitoramento Rs1 FRegister
     output wire [31:0] mFRead2,      // Monitoramento Rs2 FRegister
     output wire [31:0] mOrigAFPALU,  // Monitoramento entrada A da FPULA
     output wire [31:0] mFWriteData,  // Monitaramento dados que entram no FRegister
     output wire        mCFRegWrite,  // Monitoramento enable FRegister
`endif

    //barramentos de dados
    output wire        DwReadEnable, DwWriteEnable,
    output wire [ 3:0] DwByteEnable,
    output wire [31:0] DwAddress,
    output wire [31:0] DwWriteData,
    input  wire [31:0] DwReadData,

    // barramentos de instrucoes
    output wire        IwReadEnable, IwWriteEnable,
    output wire [ 3:0] IwByteEnable,
     output wire [31:0] IwAddress,
    output wire [31:0] IwWriteData,
    input  wire [31:0] IwReadData

`ifdef PIPELINE
     ,
     output wire [      31:0] oiIF_PC,
     output wire [      31:0] oiIF_Instr,
     output wire [      31:0] oiIF_PC4,
     output wire [ NIFID-1:0] oRegIFID,
     output wire [ NIDEX-1:0] oRegIDEX,
     output wire [NEXMEM-1:0] oRegEXMEM,
     output wire [NMEMWB-1:0] oRegMEMWB,
     output wire [      31:0] oWB_RegWrite
`endif

    //interrupcoes
//    input wire [7:0]       iPendingInterrupt
);


assign mEbreak = wCEbreak; // saida do ebreak para a interface de clock

/*************  UNICICLO *********************************/
`ifdef UNICICLO

assign mControlState    = 6'b000000;


// Unidade de Controle
wire [ 1:0]  wCOrigAULA;
wire [ 1:0]  wCOrigBULA;
wire             wCRegWrite;
wire         wCCSRegWrite;
wire             wCMemWrite;
wire             wCMemRead;
wire             wCInvInstruction;
wire             wCEcall;
wire             wCEbreak;
wire [ 2:0]  wCMem2Reg;
wire [ 2:0]  wCOrigPC;
wire [ 4:0]  wCALUControl;
`ifdef RV32IMF
wire             wCFRegWrite;
wire [ 4:0]  wCFPALUControl;
wire             wCOrigAFPALU;
wire             wCFPALU2Reg;
wire             wCFWriteData;
wire             wCWrite2Mem;
wire             wCFPstart;
`endif


 Control_UNI CONTROL0 (
    .iInstr(wInstr),
   .oOrigAULA(wCOrigAULA),
    .oOrigBULA(wCOrigBULA),
    .oRegWrite(wCRegWrite),
    .oCSRegWrite(wCCSRegWrite),
    .oMemWrite(wCMemWrite),
    .oMemRead(wCMemRead),
    .oInvInstruction(wCInvInstruction),
    .oEcall(wCEcall),
    .oEbreak(wCEbreak),
    .oMem2Reg(wCMem2Reg),
    .oOrigPC(wCOrigPC),
    .oALUControl(wCALUControl)
`ifdef RV32IMF
     ,
     .oFRegWrite(wCFRegWrite),
     .oFPALUControl(wCFPALUControl),
     .oOrigAFPALU(wCOrigAFPALU),
     .oFPALU2Reg(wCFPALU2Reg),
     .oFWriteData(wCFWriteData),
     .oWrite2Mem(wCWrite2Mem),
     .oFPstart(wCFPstart)
`endif

);




// Caminho de Dados
wire [31:0]  wInstr;

Datapath_UNI DATAPATH0 (
    .iCLK(iCLK),
    .iCLK50(iCLK50),
    .iRST(iRST),
    .iInitialPC(iInitialPC),

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
    .wCOrigAULA(wCOrigAULA),
     .wCOrigBULA(wCOrigBULA),
     .wCRegWrite(wCRegWrite),
     .wCCSRegWrite(wCCSRegWrite),
     .wCMemWrite(wCMemWrite),
     .wCMemRead(wCMemRead),
     .wCInvInstruction(wCInvInstruction),
     .wCEcall(wCEcall),
     .wCMem2Reg(wCMem2Reg),
     .wCOrigPC(wCOrigPC),
     .wCALUControl(wCALUControl),
`ifdef RV32IMF
     .wCFRegWrite(wCFRegWrite),
     .wCFPALUControl(wCFPALUControl),
     .wCOrigAFPALU(wCOrigAFPALU),
     .wCFPALU2Reg(wCFPALU2Reg),
     .wCFWriteData(wCFWriteData),
     .wCWrite2Mem(wCWrite2Mem),
     .wCFPstart(wCFPstart),
`endif


    // Barramento de dados
    .DwReadEnable(DwReadEnable), .DwWriteEnable(DwWriteEnable),
    .DwByteEnable(DwByteEnable),
    .DwWriteData(DwWriteData),
    .DwReadData(DwReadData),
    .DwAddress(DwAddress),

    // Barramento de instrucoes
    .IwReadEnable(IwReadEnable), .IwWriteEnable(IwWriteEnable),
    .IwByteEnable(IwByteEnable),
    .IwWriteData(IwWriteData),
    .IwReadData(IwReadData),
    .IwAddress(IwAddress)
);
 `endif



/*************  MULTICICLO **********************************/

`ifdef MULTICICLO

assign IwReadEnable     = OFF;
assign IwWriteEnable    = OFF;
assign IwByteEnable     = 4'b0000;
assign IwWriteData      = ZERO;
assign IwAddress        = ZERO;

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
    .iCLK50(iCLK50),
    .iRST(iRST),
    .iInitialPC(iInitialPC),


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
    .DwWriteEnable(DwWriteEnable), .DwReadEnable(DwReadEnable),
    .DwByteEnable(DwByteEnable),
    .DwWriteData(DwWriteData),
    .DwAddress(DwAddress),
    .DwReadData(DwReadData)
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
    .iCLK50(iCLK50),
    .iRST(iRST),
    .iInitialPC(iInitialPC),

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
    .DwReadEnable(DwReadEnable), .DwWriteEnable(DwWriteEnable),
    .DwByteEnable(DwByteEnable),
    .DwWriteData(DwWriteData),
    .DwReadData(DwReadData),
    .DwAddress(DwAddress),

    // Barramento de instrucoes
    .IwReadEnable(IwReadEnable), .IwWriteEnable(IwWriteEnable),
    .IwByteEnable(IwByteEnable),
    .IwWriteData(IwWriteData),
    .IwReadData(IwReadData),
    .IwAddress(IwAddress),

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
