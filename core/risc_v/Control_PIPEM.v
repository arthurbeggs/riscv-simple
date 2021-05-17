`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

// *
// * Bloco de Controle PIPELINE
// *

 module Control_PIPEM(
    input  [31:0] iInstr,
`ifdef RV32IMF
    input  iFPALUReady,
`endif

    output reg oEcall,
    output reg oEbreak,
    output reg oInvInstr,
    output reg [ 1:0] oOrigAULA,
    output reg [ 1:0] oOrigBULA,
    output reg oRegWrite,
    output reg oCSRegWrite,
    output reg oMemWrite,
    output reg oMemRead,
    output reg [ 2:0] oMem2Reg,
    output reg [ 2:0] oOrigPC,
    output reg [ 4:0] oALUControl,
 `ifdef RV32IMF
    output reg oFRegWrite,
    output reg [ 4:0] oFPALUControl,
    output reg oFPALUStart,
 `endif
    output reg [NTYPE-1:0] oInstrType  //{FPULA2Reg,FAIsInt,FAisFloat,FStore,FLoad,CSR,DivRem,Load,Store,TipoR,TipoI,Jal,Jalr,Branch} // Identifica o tipo da instrucao que esta sendo decodificada pelo controle
);


wire [ 6:0] Opcode  = iInstr[ 6: 0];
wire [ 2:0] Funct3  = iInstr[14:12];
wire [ 6:0] Funct7  = iInstr[31:25];
wire [11:0] Funct12 = iInstr[31:20];   // funct 7 + rs2 para instruções como ecall, uret e ebreak
`ifdef RV32IMF
wire [ 4:0] Rs2     = iInstr[24:20]; // Para os converts de ponto flutuante
`endif

always @(*) begin
    oInvInstr     <= 1'b0;
    oEbreak       <= 1'b0;
    oEcall        <= 1'b0;
    oOrigAULA     <= 2'b00;
    oOrigBULA     <= 2'b00;
    oRegWrite     <= 1'b0;
    oCSRegWrite   <= 1'b0;
    oMemWrite     <= 1'b0;
    oMemRead      <= 1'b0;
    oALUControl   <= OPNULL;
    oMem2Reg      <= 3'b000;
    oOrigPC       <= 3'b000;
`ifdef RV32IMF
    oFRegWrite    <= 1'b0;
    oFPALUControl <= FOPNULL;
    oFPALUStart   <= 1'b0;
    oInstrType    <= 14'b00000000000000;
`else
    oInstrType    <= 9'b000000000;
`endif

    case(Opcode)
        OPC_SYSTEM: begin
            oMemWrite     <= 1'b0;
            oMemRead      <= 1'b0;
        `ifdef RV32IMF
            oFRegWrite    <= 1'b0;
            oFPALUControl <= FOPNULL;
            oFPALUStart   <= 1'b0;
        `endif
            case(Funct3)
                FUNCT3_PRIV: begin
                    case(Funct12)
                        FUNCT12_ECALL: begin
                            oInvInstr     <= 1'b0;
                            oEbreak       <= 1'b0;
                            oEcall        <= 1'b1;
                            oOrigAULA     <= 2'b00;
                            oOrigBULA     <= 2'b00;
                            oRegWrite     <= 1'b0;
                            oCSRegWrite   <= 1'b0;
                            oALUControl   <= OPNULL;
                            oMem2Reg      <= 3'b000;
                            oOrigPC       <= 3'b101; // pc = utvec
                        `ifdef RV32IMF
                            oInstrType    <= 14'b00000000000000;
                        `else
                            oInstrType    <= 9'b000000000;
                        `endif
                        end

                        FUNCT12_EBREAK: begin
                            oInvInstr     <= 1'b0;
                            oEbreak       <= 1'b1;
                            oEcall        <= 1'b0;
                            oOrigAULA     <= 2'b00;
                            oOrigBULA     <= 2'b00;
                            oRegWrite     <= 1'b0;
                            oCSRegWrite   <= 1'b0;
                            oALUControl   <= OPNULL;
                            oMem2Reg      <= 3'b000;
                            oOrigPC       <= 3'b000;
                        `ifdef RV32IMF
                            oInstrType    <= 14'b00000000000000;
                        `else
                            oInstrType    <= 9'b000000000;
                        `endif
                        end

                        FUNCT12_URET: begin
                            oInvInstr     <= 1'b0;
                            oEbreak       <= 1'b0;
                            oEcall        <= 1'b0;
                            oOrigAULA     <= 2'b00;
                            oOrigBULA     <= 2'b00;
                            oRegWrite     <= 1'b0;
                            oCSRegWrite   <= 1'b0;
                            oALUControl   <= OPNULL;
                            oMem2Reg      <= 3'b000;
                            oOrigPC       <= 3'b100; // pc = uepc
                        `ifdef RV32IMF
                            oInstrType    <= 14'b00000000000000;
                        `else
                            oInstrType    <= 9'b000000000;
                        `endif
                        end

                        default: begin
                            oInvInstr     <= 1'b1;
                            oEbreak       <= 1'b0;
                            oEcall        <= 1'b0;
                            oOrigAULA     <= 2'b00;
                            oOrigBULA     <= 2'b00;
                            oRegWrite     <= 1'b0;
                            oCSRegWrite   <= 1'b0;
                            oALUControl   <= OPNULL;
                            oMem2Reg      <= 3'b000;
                            oOrigPC       <= 3'b000;
                        `ifdef RV32IMF
                            oInstrType    <= 14'b00000000000000;
                        `else
                            oInstrType    <= 9'b000000000;
                        `endif
                        end
                    endcase
                end

                FUNCT3_CSRRW: begin
                    oInvInstr     <= 1'b0;
                    oEbreak       <= 1'b0;
                    oEcall        <= 1'b0;
                    oOrigAULA     <= 2'b00; // fwrd a
                    oOrigBULA     <= 2'b10; // zero
                    oRegWrite     <= 1'b1;
                    oCSRegWrite   <= 1'b1;
                    oALUControl   <= OPADD;
                    oMem2Reg      <= 3'b100;
                    oOrigPC       <= 3'b000;
                `ifdef RV32IMF
                    oInstrType    <= 14'b00000100000000;
                `else
                    oInstrType    <= 9'b100000000;
                `endif
                end

                FUNCT3_CSRRS: begin
                    oInvInstr     <= 1'b0;
                    oEbreak       <= 1'b0;
                    oEcall        <= 1'b0;
                    oOrigAULA     <= 2'b00; // fwrd a
                    oOrigBULA     <= 2'b00; // fwrd b
                    oRegWrite     <= 1'b1;
                    oCSRegWrite   <= 1'b1;
                    oALUControl   <= OPOR;
                    oMem2Reg      <= 3'b100;
                    oOrigPC       <= 3'b000;
                `ifdef RV32IMF
                    oInstrType    <= 14'b00000100000000;
                `else
                    oInstrType    <= 9'b100000000;
                `endif
                end

                FUNCT3_CSRRC: begin
                    oInvInstr     <= 1'b0;
                    oEbreak       <= 1'b0;
                    oEcall        <= 1'b0;
                    oOrigAULA     <= 2'b11;// fwrd ~a
                    oOrigBULA     <= 2'b00;// fwrd b
                    oRegWrite     <= 1'b1;
                    oCSRegWrite   <= 1'b1;
                    oALUControl   <= OPAND;
                    oMem2Reg      <= 3'b100;
                    oOrigPC       <= 3'b000;
                `ifdef RV32IMF
                    oInstrType    <= 14'b00000100000000;
                `else
                    oInstrType    <= 9'b100000000;
                `endif
                end

                FUNCT3_CSRRWI: begin
                    oInvInstr     <= 1'b0;
                    oEbreak       <= 1'b0;
                    oEcall        <= 1'b0;
                    oOrigAULA     <= 2'b10; // imm
                    oOrigBULA     <= 2'b10; // zero
                    oRegWrite     <= 1'b1;
                    oCSRegWrite   <= 1'b1;
                    oALUControl   <= OPADD;
                    oMem2Reg      <= 3'b100;
                    oOrigPC       <= 3'b000;
                `ifdef RV32IMF
                    oInstrType    <= 14'b00000100000000;
                `else
                    oInstrType    <= 9'b100000000;
                `endif
                end

                FUNCT3_CSRRSI: begin
                    oInvInstr     <= 1'b0;
                    oEbreak       <= 1'b0;
                    oEcall        <= 1'b0;
                    oOrigAULA     <= 2'b10; // imm
                    oOrigBULA     <= 2'b00; // fwrd b
                    oRegWrite     <= 1'b1;
                    oCSRegWrite   <= 1'b1;
                    oALUControl   <= OPOR;
                    oMem2Reg      <= 3'b100;
                    oOrigPC       <= 3'b000;
                `ifdef RV32IMF
                    oInstrType    <= 14'b00000100000000;
                `else
                    oInstrType    <= 9'b100000000;
                `endif
                end

                FUNCT3_CSRRCI: begin
                    oInvInstr     <= 1'b0;
                    oEbreak       <= 1'b0;
                    oEcall        <= 1'b0;
                    oOrigAULA     <= 2'b10; // ~imm
                    oOrigBULA     <= 2'b00; // fwrd b
                    oRegWrite     <= 1'b1;
                    oCSRegWrite   <= 1'b1;
                    oALUControl   <= OPAND;
                    oMem2Reg      <= 3'b100;
                    oOrigPC       <= 3'b000;
                `ifdef RV32IMF
                    oInstrType    <= 14'b00000100000000;
                `else
                    oInstrType    <= 9'b100000000;
                `endif
                end

                default: begin
                    oInvInstr     <= 1'b1;
                    oEbreak       <= 1'b0;
                    oEcall        <= 1'b0;
                    oOrigAULA     <= 2'b00;
                    oOrigBULA     <= 2'b00;
                    oRegWrite     <= 1'b0;
                    oCSRegWrite   <= 1'b0;
                    oALUControl   <= OPNULL;
                    oMem2Reg      <= 3'b000;
                    oOrigPC       <= 3'b000;
                `ifdef RV32IMF
                    oInstrType    <= 14'b00000000000000;
                `else
                    oInstrType    <= 9'b000000000;
                `endif
                end
            endcase
        end

        OPC_LOAD: begin
            oInvInstr     <= 1'b0;
            oEbreak       <= 1'b0;
            oEcall        <= 1'b0;
            oOrigAULA     <= 2'b00;
            oOrigBULA     <= 2'b01;
            oRegWrite     <= 1'b1;
            oCSRegWrite   <= 1'b0;
            oMemWrite     <= 1'b0;
            oMemRead      <= 1'b1;
            oALUControl   <= OPADD;
            oMem2Reg      <= 3'b010;
            oOrigPC       <= 3'b000;
        `ifdef RV32IMF
            oFRegWrite    <= 1'b0;
            oFPALUControl <= FOPNULL;
            oFPALUStart   <= 1'b0;
            oInstrType    <= 14'b00000001000000; // Load
        `else
            oInstrType    <= 9'b001000000; // Load
        `endif
        end

        OPC_OPIMM: begin
            oInvInstr     <= 1'b0;
            oEbreak       <= 1'b0;
            oEcall        <= 1'b0;
            oOrigAULA     <= 2'b00;
            oOrigBULA     <= 2'b01;
            oRegWrite     <= 1'b1;
            oCSRegWrite   <= 1'b0;
            oMemWrite     <= 1'b0;
            oMemRead      <= 1'b0;
            oMem2Reg      <= 3'b000;
            oOrigPC       <= 3'b000;
        `ifdef RV32IMF
            oFRegWrite    <= 1'b0;
            oFPALUControl <= FOPNULL;
            oFPALUStart   <= 1'b0;
            oInstrType    <= 14'b00000000001000; // TipoI
        `else
            oInstrType    <= 9'b000001000; // TipoI
        `endif
            case (Funct3)
                FUNCT3_ADD:
                    oALUControl <= OPADD;
                FUNCT3_SLL:
                    oALUControl <= OPSLL;
                FUNCT3_SLT:
                    oALUControl <= OPSLT;
                FUNCT3_SLTU:
                    oALUControl <= OPSLTU;
                FUNCT3_XOR:
                    oALUControl <= OPXOR;
                FUNCT3_SRL,
                FUNCT3_SRA:
                    if(Funct7==FUNCT7_SRA)
                        oALUControl <= OPSRA;
                    else
                        oALUControl <= OPSRL;
                FUNCT3_OR:
                    oALUControl <= OPOR;
                FUNCT3_AND:
                    oALUControl <= OPAND;
                default: begin
                    oInvInstr     <= 1'b1;
                    oEbreak       <= 1'b0;
                    oEcall        <= 1'b0;
                    oOrigAULA     <= 2'b00;
                    oOrigBULA     <= 2'b00;
                    oRegWrite     <= 1'b0;
                    oCSRegWrite   <= 1'b0;
                    oMemWrite     <= 1'b0;
                    oMemRead      <= 1'b0;
                    oALUControl   <= OPNULL;
                    oMem2Reg      <= 3'b000;
                    oOrigPC       <= 3'b000;
                `ifdef RV32IMF
                    oFRegWrite    <= 1'b0;
                    oFPALUControl <= FOPNULL;
                    oFPALUStart   <= 1'b0;
                    oInstrType    <= 14'b00000000000000; // Null
                `else
                    oInstrType    <= 9'b000000000; // Null
                `endif
                end
            endcase
        end

        OPC_AUIPC: begin
            oInvInstr     <= 1'b0;
            oEbreak       <= 1'b0;
            oEcall        <= 1'b0;
            oOrigAULA     <= 2'b01;
            oOrigBULA     <= 2'b01;
            oRegWrite     <= 1'b1;
            oCSRegWrite   <= 1'b0;
            oMemWrite     <= 1'b0;
            oMemRead      <= 1'b0;
            oALUControl   <= OPADD;
            oMem2Reg      <= 3'b000;
            oOrigPC       <= 3'b000;
        `ifdef RV32IMF
            oFRegWrite    <= 1'b0;
            oFPALUControl <= FOPNULL;
            oFPALUStart   <= 1'b0;
            oInstrType    <= 14'b00000000001000; // TipoI;
        `else
            oInstrType    <= 9'b000001000; // TipoI;
        `endif
        end

        OPC_STORE: begin
            oInvInstr     <= 1'b0;
            oEbreak       <= 1'b0;
            oEcall        <= 1'b0;
            oOrigAULA     <= 2'b00;
            oOrigBULA     <= 2'b01;
            oRegWrite     <= 1'b0;
            oCSRegWrite   <= 1'b0;
            oMemWrite     <= 1'b1;
            oMemRead      <= 1'b0;
            oALUControl   <= OPADD;
            oMem2Reg      <= 3'b000;
            oOrigPC       <= 3'b000;
        `ifdef RV32IMF
            oFRegWrite    <= 1'b0;
            oFPALUControl <= FOPNULL;
            oFPALUStart   <= 1'b0;
            oInstrType    <= 14'b00000000100000; // Store;
        `else
            oInstrType    <= 9'b000100000; // Store;
        `endif
        end

        OPC_RTYPE: begin
            oInvInstr     <= 1'b0;
            oEbreak       <= 1'b0;
            oEcall        <= 1'b0;
            oOrigAULA     <= 2'b00;
            oOrigBULA     <= 2'b00;
            oRegWrite     <= 1'b1;
            oCSRegWrite   <= 1'b0;
            oMemWrite     <= 1'b0;
            oMemRead      <= 1'b0;
            oMem2Reg      <= 3'b000;
            oOrigPC       <= 3'b000;
        `ifdef RV32IMF
            oFRegWrite    <= 1'b0;
            oFPALUControl <= FOPNULL;
            oFPALUStart   <= 1'b0;
            oInstrType    <= 14'b00000000010000; // TipoR;
        `else
            oInstrType    <= 9'b000010000; // TipoR;
        `endif

            case (Funct7)
                FUNCT7_ADD,  // ou qualquer outro 7'b0000000
                FUNCT7_SUB:  // SUB ou SRA
                    case (Funct3)
                        FUNCT3_ADD,
                        FUNCT3_SUB:
                            if(Funct7==FUNCT7_SUB)
                                oALUControl <= OPSUB;
                            else
                                oALUControl <= OPADD;
                        FUNCT3_SLL:
                            oALUControl <= OPSLL;
                        FUNCT3_SLT:
                            oALUControl <= OPSLT;
                        FUNCT3_SLTU:
                            oALUControl <= OPSLTU;
                        FUNCT3_XOR:
                            oALUControl <= OPXOR;
                        FUNCT3_SRL,
                        FUNCT3_SRA:
                            if(Funct7==FUNCT7_SRA)
                                oALUControl <= OPSRA;
                            else
                                oALUControl <= OPSRL;
                        FUNCT3_OR:
                            oALUControl <= OPOR;
                        FUNCT3_AND:
                            oALUControl <= OPAND;
                        default: begin
                            oInvInstr     <= 1'b1;
                            oEbreak       <= 1'b0;
                            oEcall        <= 1'b0;
                            oOrigAULA     <= 2'b00;
                            oOrigBULA     <= 2'b00;
                            oRegWrite     <= 1'b0;
                            oCSRegWrite   <= 1'b0;
                            oMemWrite     <= 1'b0;
                            oMemRead      <= 1'b0;
                            oALUControl   <= OPNULL;
                            oMem2Reg      <= 3'b000;
                            oOrigPC       <= 3'b000;
                        `ifdef RV32IMF
                            oFRegWrite    <= 1'b0;
                            oFPALUControl <= FOPNULL;
                            oFPALUStart   <= 1'b0;
                            oInstrType    <= 14'b00000000000000; // Null
                        `else
                            oInstrType    <= 9'b000000000; // Null
                        `endif
                        end
                    endcase

            `ifndef RV32I
                FUNCT7_MULDIV: begin
                `ifdef RV32IMF
                    oInstrType  <= 14'b00000010010000; // DivRem e TipoR
                `else
                    oInstrType  <= 9'b0010010000; // DivRem e TipoR
                `endif
                    case (Funct3)
                        FUNCT3_MUL:
                            oALUControl <= OPMUL;
                        FUNCT3_MULH:
                            oALUControl <= OPMULH;
                        FUNCT3_MULHSU:
                            oALUControl <= OPMULHSU;
                        FUNCT3_MULHU:
                            oALUControl <= OPMULHU;
                        FUNCT3_DIV:
                            oALUControl <= OPDIV;
                        FUNCT3_DIVU:
                            oALUControl <= OPDIVU;
                        FUNCT3_REM:
                            oALUControl <= OPREM;
                        FUNCT3_REMU:
                            oALUControl <= OPREMU;
                        default: begin
                            oInvInstr     <= 1'b1;
                            oEbreak       <= 1'b0;
                            oEcall        <= 1'b0;
                            oOrigAULA     <= 2'b00;
                            oOrigBULA     <= 2'b00;
                            oRegWrite     <= 1'b0;
                            oCSRegWrite   <= 1'b0;
                            oMemWrite     <= 1'b0;
                            oMemRead      <= 1'b0;
                            oALUControl   <= OPNULL;
                            oMem2Reg      <= 3'b000;
                            oOrigPC       <= 3'b000;
                        `ifdef RV32IMF
                            oFRegWrite    <= 1'b0;
                            oFPALUControl <= FOPNULL;
                            oFPALUStart   <= 1'b0;
                            oInstrType    <= 14'b00000000000000; // Null
                        `else
                            oInstrType    <= 9'b000000000; // Null
                        `endif
                        end
                    endcase
                end
            `endif
                default: begin
                    oInvInstr     <= 1'b1;
                    oEbreak       <= 1'b0;
                    oEcall        <= 1'b0;
                    oOrigAULA     <= 2'b00;
                    oOrigBULA     <= 2'b00;
                    oRegWrite     <= 1'b0;
                    oCSRegWrite   <= 1'b0;
                    oMemWrite     <= 1'b0;
                    oMemRead      <= 1'b0;
                    oALUControl   <= OPNULL;
                    oMem2Reg      <= 3'b000;
                    oOrigPC       <= 3'b000;
                `ifdef RV32IMF
                    oFRegWrite    <= 1'b0;
                    oFPALUControl <= FOPNULL;
                    oFPALUStart   <= 1'b0;
                    oInstrType    <= 14'b00000000000000; // Null
                `else
                    oInstrType    <= 9'b000000000; // Null
                `endif
                end
            endcase
        end

        OPC_LUI: begin
            oInvInstr     <= 1'b0;
            oEbreak       <= 1'b0;
            oEcall        <= 1'b0;
            oOrigAULA     <= 2'b00;
            oOrigBULA     <= 2'b01;
            oRegWrite     <= 1'b1;
            oCSRegWrite   <= 1'b0;
            oMemWrite     <= 1'b0;
            oMemRead      <= 1'b0;
            oALUControl   <= OPLUI;
            oMem2Reg      <= 3'b000;
            oOrigPC       <= 3'b000;
        `ifdef RV32IMF
            oFRegWrite    <= 1'b0;
            oFPALUControl <= FOPNULL;
            oFPALUStart   <= 1'b0;
            oInstrType    <= 14'b00000000001000; // TipoI
        `else
            oInstrType    <= 9'b000001000; // TipoI
        `endif
        end

        OPC_BRANCH: begin
            oInvInstr     <= 1'b0;
            oEbreak       <= 1'b0;
            oEcall        <= 1'b0;
            oOrigAULA     <= 2'b00;
            oOrigBULA     <= 2'b00;
            oRegWrite     <= 1'b0;
            oCSRegWrite   <= 1'b0;
            oMemWrite     <= 1'b0;
            oMemRead      <= 1'b0;
            oALUControl   <= OPADD;
            oMem2Reg      <= 3'b000;
            oOrigPC       <= 3'b001;
        `ifdef RV32IMF
            oFRegWrite    <= 1'b0;
            oFPALUControl <= FOPNULL;
            oFPALUStart   <= 1'b0;
            oInstrType    <= 14'b00000000000001; // Branch
        `else
            oInstrType    <= 9'b000000001; // Branch
        `endif
        end

        OPC_JALR: begin
            oInvInstr     <= 1'b0;
            oEbreak       <= 1'b0;
            oEcall        <= 1'b0;
            oOrigAULA     <= 2'b00;
            oOrigBULA     <= 2'b00;
            oRegWrite     <= 1'b1;
            oCSRegWrite   <= 1'b0;
            oMemWrite     <= 1'b0;
            oMemRead      <= 1'b0;
            oALUControl   <= OPADD;
            oMem2Reg      <= 3'b001;
            oOrigPC       <= 3'b011;
        `ifdef RV32IMF
            oFRegWrite    <= 1'b0;
            oFPALUControl <= FOPNULL;
            oFPALUStart   <= 1'b0;
            oInstrType    <= 14'b00000000000010; // Jalr
        `else
            oInstrType    <= 9'b000000010; // Jalr
        `endif
        end

        OPC_JAL: begin
            oInvInstr     <= 1'b0;
            oEbreak       <= 1'b0;
            oEcall        <= 1'b0;
            oOrigAULA     <= 2'b00;
            oOrigBULA     <= 2'b00;
            oRegWrite     <= 1'b1;
            oCSRegWrite   <= 1'b0;
            oMemWrite     <= 1'b0;
            oMemRead      <= 1'b0;
            oALUControl   <= OPADD;
            oMem2Reg      <= 3'b001;
            oOrigPC       <= 3'b010;
        `ifdef RV32IMF
            oFRegWrite    <= 1'b0;
            oFPALUControl <= FOPNULL;
            oFPALUStart   <= 1'b0;
            oInstrType    <= 14'b00000000000100; // Jal
        `else
            oInstrType    <= 9'b000000100; // Jal
        `endif
        end

    `ifdef RV32IMF
        OPC_FRTYPE: begin
            oInvInstr     <= 1'b0;
            oEbreak       <= 1'b0;
            oEcall        <= 1'b0;
            oOrigAULA     <= 2'b00;
            oOrigBULA     <= 2'b00;
            oCSRegWrite   <= 1'b0;
            oMemWrite     <= 1'b0;
            oMemRead      <= 1'b0;
            oALUControl   <= OPNULL;
            oMem2Reg      <= 3'b011;  // Resultado sempre vai partir da FPULA
            oOrigPC       <= 3'b000;
            oFPALUStart   <= 1'b1;

            case(Funct7)
                FUNCT7_FADD_S: begin
                    oInstrType    <= 14'b10100000000000; //FAIsFloat
                    oRegWrite     <= 1'b0;
                    oFRegWrite    <= 1'b1;
                    oFPALUControl <= FOPADD;
                end

                FUNCT7_FSUB_S: begin
                    oInstrType    <= 14'b10100000000000; //FAIsFloat
                    oRegWrite     <= 1'b0;
                    oFRegWrite    <= 1'b1;
                    oFPALUControl <= FOPSUB;
                end

                FUNCT7_FMUL_S: begin
                    oInstrType    <= 14'b10100000000000; //FAIsFloat
                    oRegWrite     <= 1'b0;
                    oFRegWrite    <= 1'b1;
                    oFPALUControl <= FOPMUL;
                end

                FUNCT7_FDIV_S: begin
                    oInstrType    <= 14'b10100000000000; //FAIsFloat
                    oRegWrite     <= 1'b0;
                    oFRegWrite    <= 1'b1;
                    oFPALUControl <= FOPDIV;
                end

                FUNCT7_FSQRT_S: begin
                    oInstrType    <= 14'b10100000000000; //FAIsFloat
                    oRegWrite     <= 1'b0;
                    oFRegWrite    <= 1'b1;
                    oFPALUControl <= FOPSQRT;
                end

                FUNCT7_FMV_S_X: begin
                    oInstrType    <= 14'b01000000000000; //FAIsInt
                    oRegWrite     <= 1'b0;
                    oFRegWrite    <= 1'b1;
                    oFPALUControl <= FOPMV;
                end

                FUNCT7_FMV_X_S: begin
                    oInstrType    <= 14'b00100000000000; //FPULA2Reg && FAIsFloat // NOTE: possivelmente errado;
                    oRegWrite     <= 1'b1;
                    oFRegWrite    <= 1'b0;
                    oFPALUControl <= FOPMV;
                end

                FUNCT7_FSIGN_INJECT: begin
                    oInstrType    <= 14'b10100000000000; //FAIsFloat
                    oRegWrite     <= 1'b0;
                    oFRegWrite    <= 1'b1;

                case (Funct3)
                    FUNCT3_FSGNJ_S:
                        oFPALUControl <= FOPSGNJ;
                    FUNCT3_FSGNJN_S:
                        oFPALUControl <= FOPSGNJN;
                    FUNCT3_FSGNJX_S:
                        oFPALUControl <= FOPSGNJX;
                        default: begin
                            oInvInstr     <= 1'b1;
                            oEbreak       <= 1'b0;
                            oEcall        <= 1'b0;
                            oOrigAULA     <= 2'b00;
                            oOrigBULA     <= 2'b00;
                            oRegWrite     <= 1'b0;
                            oCSRegWrite   <= 1'b0;
                            oMemWrite     <= 1'b0;
                            oMemRead      <= 1'b0;
                            oALUControl   <= OPNULL;
                            oMem2Reg      <= 3'b000;
                            oOrigPC       <= 3'b000;
                            oInstrType    <= 14'b00000000000000; // Null
                            oFRegWrite    <= 1'b0;
                            oFPALUControl <= FOPNULL;
                            oFPALUStart   <= 1'b0;
                        end
                    endcase
                end

                FUNCT7_MAX_MIN_S: begin
                    oInstrType <= 14'b10100000000000; //FAIsFloat
                    oRegWrite  <= 1'b0;
                    oFRegWrite <= 1'b1;

                    case (Funct3)
                        FUNCT3_FMAX_S: oFPALUControl <= FOPMAX;
                        FUNCT3_FMIN_S: oFPALUControl <= FOPMIN;
                        default: begin
                            oInvInstr     <= 1'b1;
                            oEbreak       <= 1'b0;
                            oEcall        <= 1'b0;
                            oOrigAULA     <= 2'b00;
                            oOrigBULA     <= 2'b00;
                            oRegWrite     <= 1'b0;
                            oCSRegWrite   <= 1'b0;
                            oMemWrite     <= 1'b0;
                            oMemRead      <= 1'b0;
                            oALUControl   <= OPNULL;
                            oMem2Reg      <= 3'b000;
                            oOrigPC       <= 3'b000;
                            oInstrType    <= 14'b00000000000000; // Null
                            oFRegWrite    <= 1'b0;
                            oFPALUControl <= FOPNULL;
                            oFPALUStart   <= 1'b0;
                        end
                    endcase
                end

                FUNCT7_FCOMPARE: begin
                    oInstrType <= 14'b10100000000000; //FPULA2Reg && FAIsFloat
                    oRegWrite  <= 1'b1;
                    oFRegWrite <= 1'b0;
                    case (Funct3)
                        FUNCT3_FEQ_S:
                            oFPALUControl <= FOPCEQ;
                        FUNCT3_FLE_S:
                            oFPALUControl <= FOPCLE;
                        FUNCT3_FLT_S:
                            oFPALUControl <= FOPCLT;
                        default: begin
                            oInvInstr     <= 1'b1;
                            oEbreak       <= 1'b0;
                            oEcall        <= 1'b0;
                            oOrigAULA     <= 2'b00;
                            oOrigBULA     <= 2'b00;
                            oRegWrite     <= 1'b0;
                            oCSRegWrite   <= 1'b0;
                            oMemWrite     <= 1'b0;
                            oMemRead      <= 1'b0;
                            oALUControl   <= OPNULL;
                            oMem2Reg      <= 3'b000;
                            oOrigPC       <= 3'b000;
                            oInstrType    <= 14'b00000000000000; // Null
                            oFRegWrite    <= 1'b0;
                            oFPALUControl <= FOPNULL;
                            oFPALUStart   <= 1'b0;
                            end
                    endcase
                end

                FUNCT7_FCVT_S_W_WU: begin
                    oInstrType <= 14'b11000000000000; //FAIsInt
                    oRegWrite  <= 1'b0;
                    oFRegWrite <= 1'b1;

                    case (Rs2)
                        RS2_FCVT_S_W:
                            oFPALUControl <= FOPCVTSW;
                        RS2_FCVT_S_WU:
                            oFPALUControl <= FOPCVTSWU;
                        default: begin
                            oInvInstr     <= 1'b1;
                            oEbreak       <= 1'b0;
                            oEcall        <= 1'b0;
                            oOrigAULA     <= 2'b00;
                            oOrigBULA     <= 2'b00;
                            oRegWrite     <= 1'b0;
                            oCSRegWrite   <= 1'b0;
                            oMemWrite     <= 1'b0;
                            oMemRead      <= 1'b0;
                            oALUControl   <= OPNULL;
                            oMem2Reg      <= 3'b000;
                            oOrigPC       <= 3'b000;
                            oInstrType    <= 14'b00000000000000; // Null
                            oFRegWrite    <= 1'b0;
                            oFPALUControl <= FOPNULL;
                            oFPALUStart   <= 1'b0;
                        end
                    endcase
                end

                FUNCT7_FCVT_W_WU_S: begin
                    oInstrType <= 14'b10100000000000; //FPULA2Reg && FAIsFloat
                    oRegWrite  <= 1'b1;
                    oFRegWrite <= 1'b0;

                    case (Rs2)
                        RS2_FCVT_W_S:
                            oFPALUControl <= FOPCVTWS;
                        RS2_FCVT_WU_S:
                            oFPALUControl <= FOPCVTWUS;
                        default: begin
                            oInvInstr     <= 1'b1;
                            oEbreak       <= 1'b0;
                            oEcall        <= 1'b0;
                            oOrigAULA     <= 2'b00;
                            oOrigBULA     <= 2'b00;
                            oRegWrite     <= 1'b0;
                            oCSRegWrite   <= 1'b0;
                            oMemWrite     <= 1'b0;
                            oMemRead      <= 1'b0;
                            oALUControl   <= OPNULL;
                            oMem2Reg      <= 3'b000;
                            oOrigPC       <= 3'b000;
                            oInstrType    <= 14'b00000000000000; // Null
                            oFRegWrite    <= 1'b0;
                            oFPALUControl <= FOPNULL;
                            oFPALUStart   <= 1'b0;
                        end
                    endcase
                end

                default: begin
                    oInvInstr     <= 1'b1;
                    oEbreak       <= 1'b0;
                    oEcall        <= 1'b0;
                    oOrigAULA     <= 2'b00;
                    oOrigBULA     <= 2'b00;
                    oRegWrite     <= 1'b0;
                    oCSRegWrite   <= 1'b0;
                    oMemWrite     <= 1'b0;
                    oMemRead      <= 1'b0;
                    oALUControl   <= OPNULL;
                    oMem2Reg      <= 3'b000;
                    oOrigPC       <= 3'b000;
                    oInstrType    <= 14'b00000000000000; // Null
                    oFRegWrite    <= 1'b0;
                    oFPALUControl <= FOPNULL;
                    oFPALUStart   <= 1'b0;
                end
            endcase
        end

        OPC_FLOAD: begin
            oInvInstr     <= 1'b0;
            oEbreak       <= 1'b0;
            oEcall        <= 1'b0;
            oOrigAULA     <= 2'b00;
            oOrigBULA     <= 2'b01;
            oRegWrite     <= 1'b0;
            oCSRegWrite   <= 1'b0;
            oMemWrite     <= 1'b0;
            oMemRead      <= 1'b1;
            oALUControl   <= OPADD;
            oMem2Reg      <= 3'b010;
            oOrigPC       <= 3'b000;
            oInstrType    <= 14'b00001000000000; // FLoad

            oFRegWrite    <= 1'b1;
            oFPALUControl <= FOPNULL;
            oFPALUStart   <= 1'b0;
        end

        OPC_FSTORE: begin
            oInvInstr     <= 1'b0;
            oEbreak       <= 1'b0;
            oEcall        <= 1'b0;
            oOrigAULA     <= 2'b00;
            oOrigBULA     <= 2'b01;
            oRegWrite     <= 1'b0;
            oCSRegWrite   <= 1'b0;
            oMemWrite     <= 1'b1;
            oMemRead      <= 1'b0;
            oALUControl   <= OPADD;
            oMem2Reg      <= 3'b000;
            oOrigPC       <= 3'b000;
            oInstrType    <= 14'b00010000000000; // FStore

            oFRegWrite    <= 1'b0;
            oFPALUControl <= FOPNULL;
            oFPALUStart   <= 1'b0;
        end
    `endif

        default: begin
            oInvInstr     <= 1'b1;
            oEbreak       <= 1'b0;
            oEcall        <= 1'b0;
            oOrigAULA     <= 2'b00;
            oOrigBULA     <= 2'b00;
            oRegWrite     <= 1'b0;
            oCSRegWrite   <= 1'b0;
            oMemWrite     <= 1'b0;
            oMemRead      <= 1'b0;
            oALUControl   <= OPNULL;
            oMem2Reg      <= 3'b000;
            oOrigPC       <= 3'b000;
        `ifdef RV32IMF
            oFRegWrite    <= 1'b0;
            oFPALUControl <= FOPNULL;
            oFPALUStart   <= 1'b0;
            oInstrType    <= 14'b00000000000000; // Null
        `else
            oInstrType    <= 9'b000000000; // Null
        `endif
        end
    endcase
end

endmodule

