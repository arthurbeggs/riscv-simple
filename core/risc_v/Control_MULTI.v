`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

// *
// * Bloco de Controle MULTICICLO
// *

module Control_MULTI (

    input            iCLK, iRST,
    input       [31:0] iInstr,
    output           oEcall,
    output           oEbreak,
    output           oInvInstruction,
    output           oEscreveIR,
    output           oEscrevePC,
    output           oEscrevePCCond,
    output           oEscrevePCBack,
   output   [ 2:0] oOrigAULA,
   output   [ 2:0] oOrigBULA,
   output   [ 2:0] oMem2Reg,
    output  [ 2:0] oOrigPC,
    output           oIouD,
   output            oRegWrite,
    output           oCSRegWrite, // habilita escrita no CSR
   output            oMemWrite,
    output           oMemRead,
    output  [ 4:0] oALUControl,
    output   [ 5:0] oState
`ifdef RV32IMF
    ,
    input           iFPALUReady,
    output          oFRegWrite,
    output   [ 4:0] oFPALUControl,
    output          oOrigAFPALU,
    output          oFPALUStart,
    output          oFWriteData,
    output          oWrite2Mem
`endif
    );


reg     [ 5:0]  pr_state;       // present state
wire  [ 5:0]  nx_state;     // next state

wire [6:0] Opcode = iInstr[ 6: 0];
wire [2:0] Funct3   = iInstr[14:12];
wire [6:0] Funct7   = iInstr[31:25];
wire [11:0] Funct12= iInstr[31:20];
`ifdef RV32IMF
wire [4:0] Rs2    = iInstr[24:20]; // Para os converts de ponto flutuante
`endif

assign  oState  = pr_state;

reg [4:0] contador;

initial
    begin
        pr_state    <= ST_FETCH;
        contador <= 5'd0;
    end



// a cada ciclo de Clock
always @(posedge iCLK or posedge iRST)
    begin
        if (iRST)
            begin
                pr_state    <= ST_FETCH;
                contador <= 5'd0;
            end
        else
            begin
                pr_state    <= nx_state;
                if (nx_state == ST_DIVREM)
                    contador <= contador + 5'd1;
                else
                    contador <= 5'd0;
            end
    end



always @(*)
    case (pr_state)
        ST_FETCH:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;
                oOrigBULA       <= 3'b000;
                oMem2Reg        <= 3'b000;
                oOrigPC             <= 3'b000;
                oIouD           <= 1'b0;
                oRegWrite       <= 1'b0;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b1;
                oALUControl     <= OPNULL;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif

                nx_state        <= ST_FETCH1;
            end

        ST_FETCH1:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b1;
                oEscrevePC      <= 1'b1;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b1;
                oOrigAULA       <= 3'b001;
                oOrigBULA       <= 3'b001;
                oMem2Reg        <= 3'b000;
                oOrigPC             <= 3'b000;
                oIouD           <= 1'b0;
                oRegWrite       <= 1'b0;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b1;
                oALUControl     <= OPADD;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif

                nx_state        <= ST_DECODE;
            end

        ST_DECODE:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b010;
                oOrigBULA       <= 3'b010;
                oMem2Reg        <= 3'b000;
                oOrigPC             <= 3'b000;
                oIouD           <= 1'b0;
                oRegWrite       <= 1'b0;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b0;
                oALUControl     <= OPADD;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif

                case (Opcode)
                    OPC_LOAD,
                    OPC_STORE:  nx_state        <= ST_LWSW;
                    OPC_RTYPE:  nx_state        <= ST_RTYPE;
                    OPC_OPIMM:  nx_state        <= ST_IMMTYPE;
                    OPC_LUI:        nx_state        <= ST_LUI;
                    OPC_AUIPC:  nx_state        <= ST_AUIPC;
                    OPC_BRANCH: nx_state        <= ST_BRANCH;
                    OPC_JALR:   nx_state        <= ST_JALR;
                    OPC_JAL:        nx_state        <= ST_JAL;
                    OPC_SYSTEM: nx_state        <= ST_SYSTEM;

`ifdef RV32IMF
                    OPC_FRTYPE: nx_state       <= ST_FRTYPE;
                    OPC_FLOAD:  nx_state       <= ST_LWSW;
                    OPC_FSTORE: nx_state       <= ST_LWSW;
`endif
                    default:        nx_state        <= ST_ERRO;
                endcase
            end

        ST_SYSTEM: // realiza logo os possíveis cálculos da ula utilizados pelas instruções csrrw, csrs, csrrc , etc...
            begin

                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oMem2Reg        <= 3'b000;
                oOrigPC             <= 3'b000;
                oOrigAULA       <= 3'b000;
                oOrigBULA       <= 3'b000;
                oALUControl     <= OPNULL;
                oIouD           <= 1'b0;
                oRegWrite       <= 1'b0;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b0;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif


                case(Funct3)
                    FUNCT3_PRIV: // NAO TEM ESTADO PRIV POIS N TERIA NADA PARA FAZER
                        begin
                            oOrigAULA       <= 3'b000;
                            oOrigBULA       <= 3'b000;
                            oALUControl     <= OPNULL;

                            case(Funct12)
                                FUNCT12_ECALL:      nx_state        <= ST_ECALL;
                                FUNCT12_EBREAK: nx_state        <= ST_EBREAK;
                                FUNCT12_URET:       nx_state        <= ST_URET;
                                default:                nx_state        <= ST_ERRO;
                            endcase
                        end
                    FUNCT3_CSRRW:
                        begin
                            oOrigAULA       <= 3'b000;
                            oOrigBULA       <= 3'b100;
                            oALUControl     <= OPADD;
                            nx_state        <= ST_CSRREND;
                        end
                    FUNCT3_CSRRS:
                        begin
                            oOrigAULA       <= 3'b000;
                            oOrigBULA       <= 3'b011;
                            oALUControl     <= OPOR;
                            nx_state        <= ST_CSRREND;
                        end
                    FUNCT3_CSRRC:
                        begin
                            oOrigAULA       <= 3'b100;
                            oOrigBULA       <= 3'b011;
                            oALUControl     <= OPAND;
                            nx_state        <= ST_CSRREND;
                        end
                    FUNCT3_CSRRWI:
                        begin
                            oOrigAULA       <= 3'b011;
                            oOrigBULA       <= 3'b100;
                            oALUControl     <= OPADD;
                            nx_state        <= ST_CSRREND;
                        end
                    FUNCT3_CSRRSI:
                        begin
                            oOrigAULA       <= 3'b011;
                            oOrigBULA       <= 3'b011;
                            oALUControl     <= OPOR;
                            nx_state        <= ST_CSRREND;
                        end
                    FUNCT3_CSRRCI:
                        begin
                            oOrigAULA       <= 3'b011;
                            oOrigBULA       <= 3'b011;
                            oALUControl     <= OPAND;
                            nx_state        <= ST_CSRREND;
                        end
                    default:
                        begin
                            oOrigAULA       <= 3'b000;
                            oOrigBULA       <= 3'b000;
                            oALUControl     <= OPNULL;
                            nx_state        <= ST_ERRO;
                        end

                endcase


            end

        ST_ECALL:
            begin
                oEcall          <= 1'b1; // ecall
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b1; // escreve pc
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;
                oOrigBULA       <= 3'b000;
                oMem2Reg        <= 3'b000;
                oOrigPC             <= 3'b011; // pc = utvec
                oIouD           <= 1'b0;
                oRegWrite       <= 1'b0;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b0;
                oALUControl     <= OPNULL;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif

                nx_state        <= ST_FETCH;
            end

        ST_EBREAK:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b1; // ebreak
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;
                oOrigBULA       <= 3'b000;
                oMem2Reg        <= 3'b000;
                oOrigPC             <= 3'b000;
                oIouD           <= 1'b0;
                oRegWrite       <= 1'b0;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b0;
                oALUControl     <= OPNULL;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif
                nx_state        <= ST_FETCH;
            end

        ST_URET:
            begin

                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b1; // escreve pc
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;
                oOrigBULA       <= 3'b000;
                oMem2Reg        <= 3'b000;
                oOrigPC             <= 3'b100; // pc = uepc
                oIouD           <= 1'b0;
                oRegWrite       <= 1'b0;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b0;
                oALUControl     <= OPNULL;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif

                nx_state        <= ST_FETCH;
            end



        ST_CSRREND: // estado escreve mudanças nos registraores csr = aluresult e rd = csr
            begin

                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;
                oOrigBULA       <= 3'b000;
                oMem2Reg        <= 3'b100; // csr to reg
                oOrigPC             <= 3'b000;
                oIouD           <= 1'b0;
                oRegWrite       <= 1'b1; // escreve csr em rd
                oCSRegWrite     <= 1'b1; // escreve aluout em csr
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b0;
                oALUControl     <= OPNULL;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif
                nx_state        <= ST_FETCH;
            end

        ST_LWSW:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;
                oOrigBULA       <= 3'b010;
                oMem2Reg        <= 3'b000;
                oOrigPC             <= 3'b000;
                oIouD           <= 1'b0;
                oRegWrite       <= 1'b0;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b0;
                oALUControl     <= OPADD;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif


                case (Opcode)
                    OPC_LOAD:   nx_state        <= ST_LW;
                    OPC_STORE:  nx_state        <= ST_SW;
`ifdef RV32IMF
                    OPC_FLOAD:  nx_state       <= ST_FLW;
                    OPC_FSTORE: nx_state       <= ST_FSW;
`endif
                    default:
                                    nx_state        <= ST_ERRO;
                endcase
            end


        ST_LW:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;
                oOrigBULA       <= 3'b010;
                oMem2Reg        <= 3'b000;
                oOrigPC             <= 3'b000;
                oIouD           <= 1'b1;
                oRegWrite       <= 1'b0;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b1;
                oALUControl     <= OPADD;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif


                nx_state        <= ST_LW1;
            end

        ST_LW1:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;
                oOrigBULA       <= 3'b000;
                oMem2Reg        <= 3'b000;
                oOrigPC             <= 3'b000;
                oIouD           <= 1'b1;
                oRegWrite       <= 1'b0;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b1;
                oALUControl     <= OPNULL;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif


                nx_state        <= ST_LW2;
            end

        ST_LW2:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;
                oOrigBULA       <= 3'b000;
                oMem2Reg        <= 3'b010;
                oOrigPC             <= 3'b000;
                oIouD           <= 1'b0;
                oRegWrite       <= 1'b1;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b0;
                oALUControl     <= OPNULL;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif


                nx_state        <= ST_FETCH;
            end

        ST_SW:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;
                oOrigBULA       <= 3'b000;
                oMem2Reg        <= 3'b000;
                oOrigPC             <= 3'b000;
                oIouD           <= 1'b1;
                oRegWrite       <= 1'b0;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b1;
                oMemRead        <= 1'b0;
                oALUControl     <= OPNULL;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif


                nx_state        <= ST_SW1;
            end

        ST_SW1:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;
                oOrigBULA       <= 3'b000;
                oMem2Reg        <= 3'b000;
                oOrigPC             <= 3'b000;
                oIouD           <= 1'b0;
                oRegWrite       <= 1'b0;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b0;
                oALUControl     <= OPNULL;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif


                nx_state        <= ST_FETCH;
            end

        ST_RTYPE:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;
                oOrigBULA       <= 3'b000;
                oMem2Reg        <= 3'b000;
                oOrigPC             <= 3'b000;
                oIouD           <= 1'b0;
                oRegWrite       <= 1'b0;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b0;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif


                nx_state        <= ST_ULAREGWRITE;

            case (Funct7)
                FUNCT7_ADD,  // ou qualquer outro 7'b0000000
                FUNCT7_SUB:  // SUB ou SRA
                    case (Funct3)
                        FUNCT3_ADD,
                        FUNCT3_SUB:
                            if(Funct7==FUNCT7_SUB)   oALUControl <= OPSUB;
                            else                             oALUControl <= OPADD;
                        FUNCT3_SLL:         oALUControl <= OPSLL;
                        FUNCT3_SLT:         oALUControl <= OPSLT;
                        FUNCT3_SLTU:        oALUControl <= OPSLTU;
                        FUNCT3_XOR:         oALUControl <= OPXOR;
                        FUNCT3_SRL,
                        FUNCT3_SRA:
                            if(Funct7==FUNCT7_SRA)  oALUControl <= OPSRA;
                            else                            oALUControl <= OPSRL;
                        FUNCT3_OR:          oALUControl <= OPOR;
                        FUNCT3_AND:         oALUControl <= OPAND;
                        default:// instrucao invalida
                            begin
                                oALUControl     <= OPNULL;
                                nx_state            <= ST_ERRO;
                            end
                    endcase
`ifndef RV32I
                FUNCT7_MULDIV:
                    case (Funct3)
                        FUNCT3_MUL:          oALUControl <= OPMUL;
                        FUNCT3_MULH:         oALUControl <= OPMULH;
                        FUNCT3_MULHSU:       oALUControl <= OPMULHSU;
                        FUNCT3_MULHU:        oALUControl <= OPMULHU;
                        FUNCT3_DIV:     begin    oALUControl <= OPDIV;  nx_state <= ST_DIVREM; end
                        FUNCT3_DIVU:    begin    oALUControl <= OPDIVU; nx_state <= ST_DIVREM; end
                        FUNCT3_REM:     begin    oALUControl <= OPREM;  nx_state <= ST_DIVREM; end
                        FUNCT3_REMU:    begin    oALUControl <= OPREMU; nx_state <= ST_DIVREM; end
                        default: // instrucao invalida
                            begin
                                oALUControl     <= OPNULL;
                                nx_state            <= ST_ERRO;
                            end
                    endcase
`endif
                default: // instrucao invalida
                    begin
                        oALUControl     <= OPNULL;
                        nx_state            <= ST_ERRO;
                    end
            endcase
        end


        ST_DIVREM:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;
                oOrigBULA       <= 3'b000;
                oMem2Reg        <= 3'b000;
                oOrigPC             <= 3'b000;
                oIouD           <= 1'b0;
                oRegWrite       <= 1'b0;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b0;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif

                case (Funct3)
                        FUNCT3_DIV:     oALUControl <= OPDIV;
                        FUNCT3_DIVU:    oALUControl <= OPDIVU;
                        FUNCT3_REM:     oALUControl <= OPREM;
                        FUNCT3_REMU:    oALUControl <= OPREMU;
                        default: // instrucao invalida
                            begin
                                oALUControl     <= OPNULL;
                                nx_state            <= ST_ERRO;
                            end
                endcase
                if(contador == 5'd6)
                        nx_state    <= ST_ULAREGWRITE;
                else
                        nx_state    <= ST_DIVREM;

            end

        ST_IMMTYPE:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;
                oOrigBULA       <= 3'b010;
                oMem2Reg        <= 3'b000;
                oOrigPC             <= 3'b000;
                oIouD           <= 1'b0;
                oRegWrite       <= 1'b0;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b0;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif


                nx_state        <= ST_ULAREGWRITE;

                case (Funct3)
                    FUNCT3_ADD:         oALUControl <= OPADD;
                    FUNCT3_SLL:         oALUControl <= OPSLL;
                    FUNCT3_SLT:         oALUControl <= OPSLT;
                    FUNCT3_SLTU:        oALUControl <= OPSLTU;
                    FUNCT3_XOR:         oALUControl <= OPXOR;
                    FUNCT3_SRL,
                    FUNCT3_SRA:
                        if(Funct7==FUNCT7_SRA)  oALUControl <= OPSRA;
                        else                            oALUControl <= OPSRL;
                    FUNCT3_OR:          oALUControl <= OPOR;
                    FUNCT3_AND:         oALUControl <= OPAND;
                    default: // instrucao invalida
                        begin
                            oALUControl     <= OPNULL;
                            nx_state            <= ST_ERRO;
                        end
                endcase
            end



        ST_ULAREGWRITE:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;
                oOrigBULA       <= 3'b000;
                oMem2Reg        <= 3'b000;
                oOrigPC             <= 3'b000;
                oIouD           <= 1'b0;
                oRegWrite       <= 1'b1;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b0;
                oALUControl     <= OPNULL;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif


                nx_state        <= ST_FETCH;
            end

        ST_LUI:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;
                oOrigBULA       <= 3'b010;
                oMem2Reg        <= 3'b000;
                oOrigPC             <= 3'b000;
                oIouD           <= 1'b0;
                oRegWrite       <= 1'b0;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b0;
                oALUControl     <= OPLUI;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif


                nx_state        <= ST_ULAREGWRITE;
            end

        ST_AUIPC:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b010;
                oOrigBULA       <= 3'b010;
                oMem2Reg        <= 3'b000;
                oOrigPC             <= 3'b000;
                oIouD           <= 1'b0;
                oRegWrite       <= 1'b0;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b0;
                oALUControl     <= OPADD;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif


                nx_state        <= ST_ULAREGWRITE;
            end

        ST_BRANCH:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b1;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;
                oOrigBULA       <= 3'b000;
                oMem2Reg        <= 3'b000;
                oOrigPC             <= 3'b001;
                oIouD           <= 1'b0;
                oRegWrite       <= 1'b0;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b0;
                oALUControl     <= OPNULL;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif


                nx_state        <= ST_FETCH;
            end

        ST_JAL:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b1;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;
                oOrigBULA       <= 3'b000;
                oMem2Reg        <= 3'b001;
                oOrigPC             <= 3'b001;
                oIouD           <= 1'b0;
                oRegWrite       <= 1'b1;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b0;
                oALUControl     <= OPNULL;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif


                nx_state        <= ST_FETCH;
            end


        ST_JALR:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b1;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;
                oOrigBULA       <= 3'b010;
                oMem2Reg        <= 3'b001;
                oOrigPC             <= 3'b010;
                oIouD           <= 1'b0;
                oRegWrite       <= 1'b1;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b0;
                oALUControl     <= OPADD;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif


                nx_state        <= ST_FETCH;
            end



        ST_ERRO:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b1; // INVALID INSTRUCTION
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;
                oOrigBULA       <= 3'b000;
                oMem2Reg        <= 3'b000;
                oOrigPC             <= 3'b000;
                oIouD           <= 1'b0;
                oRegWrite       <= 1'b0;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b0;
                oALUControl     <= OPNULL;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif


                nx_state            <= ST_FETCH;    // Descarta instrucoes invalidas
            end
`ifdef RV32IMF
        ST_FLW:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;     // Desabilita escrita no IR
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;     // Desabilita escrita no PCBack
                oOrigAULA       <= 3'b000;    // OrigAULA = A (para addi)
                oOrigBULA       <= 3'b010;   // OrigBULA = imediato
                oMem2Reg        <= 3'b000;    // Mem2Reg = don't care, ja que nada vai ser escrito no registrador de inteiros
                oOrigPC             <= 3'b000;    // PC + 4
                oIouD           <= 1'b1;     // Endereco que entra na memoria vem da ULA, nao de PC
                oRegWrite       <= 1'b0;     // Escrita no registrador de inteiros desabilitada nesse estado, pois esse ainda eh o estado de calculo de endereco
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;     // Load nao escreve na memoria
                oMemRead        <= 1'b1;     // Habilita leitura da memoria
                oALUControl     <= OPADD;    // Mantem o endereco
                // Sinais float
                oFRegWrite     <= 1'b0;     // Nao escreve ainda no registrador, pois ainda eh a etapa de leitura da memoria
                oFPALUControl  <= OPNULL;   // FPULA nao executa operacao no FLW
                oOrigAFPALU    <= 1'b0;     // Origem A da FPULA nao importa
                oFPALUStart    <= 1'b0;     // FPALU nao realiza operacao
                oFWriteData    <= 1'b1;     // Nessa fase ainda nao eh escrito nada no FReg
                oWrite2Mem     <= 1'b0;     // Nao importa o que sera escrito na memoria

                nx_state        <= ST_FLW1;
            end
        ST_FLW1:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;     // Desabilita escrita no IR
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;    // Eh um don't care(?)
                oOrigBULA       <= 3'b000;   // Eh um don't care(?)
                oMem2Reg        <= 3'b000;    // Eh um don't care(?)
                oOrigPC             <= 3'b000;    // PC+4
                oIouD           <= 1'b1;     // Endereco que entra na memoria vem da ULA, nao de PC
                oRegWrite       <= 1'b0;     // Nao escreve em registrador de inteiro
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;     // Nao escreve na memoria
                oMemRead        <= 1'b1;     // Habilita leitura da memoria
                oALUControl     <= OPNULL;   // Ja terminou de calcular o endereco
                // ControleFPULA
                oFRegWrite     <= 1'b0;     // Nessa etapa ainda nao estamos escrevendo no FReg
                oFPALUControl  <= OPNULL;   // FPULA nao realiza operacao
                oOrigAFPALU    <= 1'b0;     // Don't care
                oFPALUStart    <= 1'b0;     // FPULA nao faz nada
                oFWriteData    <= 1'b0;     // Don't care
                oWrite2Mem     <= 1'b0;     // Don't care


                nx_state        <= ST_FLW2;
            end

        ST_FLW2:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;   // Desabilita escrita no registrador de instrucoes
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;  // Don't care
                oOrigBULA       <= 3'b000;  // Don't care
                oMem2Reg        <= 3'b010;  // Don't care
                oOrigPC             <= 3'b000;  // PC+4
                oIouD           <= 1'b0;   // Volta a ler o endereco de PC
                oRegWrite       <= 1'b0;   // Nao escreve no registrador de inteiros
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;   // Nao escreve na memoria
                oMemRead        <= 1'b0;   // Ja leu da memoria
                oALUControl     <= OPNULL; // Nao realiza operacao na ULA
            // Controle Float
                oFRegWrite     <= 1'b1;   // Escreve no banco de registradores de ponto flutuante
                oFPALUControl  <= OPNULL; // Nao realiza opercao
                oOrigAFPALU    <= 1'b0;   // Don't care
                oFPALUStart    <= 1'b0;   // FPULA nao realiza operacao
                oFWriteData    <= 1'b0;   // Dados vem da memoria, entao eh selecionado MDR(0)
                oWrite2Mem     <= 1'b0;   // Don't care (nao escreve na memoria)

                nx_state        <= ST_FETCH;
            end

        ST_FSW:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;   // Nao habilita escrita no registrador de instrucao
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;  // Don't care
                oOrigBULA       <= 3'b000;  // Don't care
                oMem2Reg        <= 3'b000;  // Don't care
                oOrigPC             <= 3'b000;  // PC+4
                oIouD           <= 1'b1;   // Endereco de escrita vem de ALUOut
                oRegWrite       <= 1'b0;   // Desabilita escrita em registrador de inteiro
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b1;   // Habilita escrcita na memoria
                oMemRead        <= 1'b0;   // Desabilita leitura da memoria
                oALUControl     <= OPNULL; // Endereco ja foi calculado
            //Sinais float
                oFRegWrite     <= 1'b0;   // Nao escreve em registrador de ponto flutuante
                oFPALUControl  <= OPNULL; // FPULA nao realiza operacao
                oOrigAFPALU    <= 1'b0;   // don't care
                oFPALUStart    <= 1'b0;   // FPULA nao realiza operacao
                oFWriteData    <= 1'b0;   // don't care
                oWrite2Mem     <= 1'b1;   // Conteudo de escrita da memoria vem do FB(1)

                nx_state        <= ST_FSW1;
            end

        ST_FSW1:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;   // Nao habilita escrita no registrador de instrucao
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;  // Don't care
                oOrigBULA       <= 3'b000;  // Don't care
                oMem2Reg        <= 3'b000;  // Don't care
                oOrigPC             <= 3'b000;  // PC+4
                oIouD           <= 1'b0;   // Endereco vem de PC
                oRegWrite       <= 1'b0;   // Nao escreve em banco de registrador de inteiros
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;   // Ja escreveu na memoria no estado anterior
                oMemRead        <= 1'b0;   // Nao le da memoria
                oALUControl     <= OPNULL; // ULA nao realiza operaco
                // Sinais FPALU
                oFRegWrite     <= 1'b0;   // Nao escreve em registrador de ponto flutuante
                oFPALUControl  <= OPNULL; // Nao realiza operacao
                oOrigAFPALU    <= 1'b0;   // Don't care
                oFPALUStart    <= 1'b0;   // Nao reseta FPULA
                oFWriteData    <= 1'b0;   // Don't care
                oWrite2Mem     <= 1'b1;   // Don't care

                nx_state        <= ST_FETCH;
            end

        ST_FRTYPE:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;    // Nao habilita escrita em Registrador de instrucao
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;   // Don't care
                oOrigBULA       <= 3'b000;   // Don't care
                oMem2Reg        <= 3'b011;   // Se escrever em registrador de inteiro, eh pra escrever a saida da FPULA(11)
                oOrigPC             <= 3'b000;   // PC+4
                oIouD           <= 1'b0;    // O endereco de entrada na memoria sempre vai vir de PC
                oRegWrite       <= 1'b0;    // Nao escreve em registrador de inteiro (nesse estado, mas depois pode escrever)
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;    // Nao habilita escrita na memoria
                oMemRead        <= 1'b0;    // Nao habilita leitura da memoria
                oALUControl     <= OPNULL;  // ULA nao realiza nenhuma operacao
                // Sinais FPALU
                oFRegWrite     <= 1'b0;    // Nao escreve no banco de registradores (nessa etapa, mas depois pode escrever)
                //oOrigAFPALU definidos nos cases abaixo
                //oFPALUControl definido nos cases abaixo
                oFPALUStart    <= 1'b0;    // Start so sera dado no proximo estado
                oFWriteData    <= 1'b1;    // Escrita em registrador de ponto flutuante ainda nao habilitada
                oWrite2Mem     <= 1'b0;    // Nao vai escrever na memoria

                nx_state        <= ST_FPSTART;

                case (Funct7)
                    FUNCT7_FADD_S:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA
                            oFPALUControl <= FOPADD;
                        end
                    FUNCT7_FSUB_S:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA
                            oFPALUControl <= FOPSUB;
                        end
                    FUNCT7_FMUL_S:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA
                            oFPALUControl <= FOPMUL;
                        end
                    FUNCT7_FDIV_S:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA
                            oFPALUControl <= FOPDIV;
                        end
                    FUNCT7_FSQRT_S:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA
                            oFPALUControl <= FOPSQRT;
                        end
                    FUNCT7_FMV_S_X:
                        begin
                            oOrigAFPALU    <= 1'b0; //A
                            oFPALUControl <= FOPMV;
                        end
                    FUNCT7_FMV_X_S:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA
                            oFPALUControl <= FOPMV;
                        end

                    FUNCT7_FSIGN_INJECT:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA

                            case(Funct3)
                                FUNCT3_FSGNJ_S:  oFPALUControl <= FOPSGNJ;
                                FUNCT3_FSGNJN_S: oFPALUControl <= FOPSGNJN;
                                FUNCT3_FSGNJX_S: oFPALUControl <= FOPSGNJX;
                                default:
                                    begin
                                        oEcall          <= 1'b0;
                                        oEbreak         <= 1'b0;
                                        oInvInstruction<= 1'b0;
                                        oEscreveIR      <= 1'b0;
                                        oEscrevePC      <= 1'b0;
                                        oEscrevePCCond <= 1'b0;
                                        oEscrevePCBack <= 1'b0;
                                        oOrigAULA       <= 3'b000;
                                        oOrigBULA       <= 3'b000;
                                        oMem2Reg        <= 3'b000;
                                        oOrigPC             <= 3'b000;
                                        oIouD           <= 1'b0;
                                        oRegWrite       <= 1'b0;
                                        oCSRegWrite     <= 1'b0;
                                        oMemWrite       <= 1'b0;
                                        oMemRead        <= 1'b0;
                                        oALUControl     <= OPNULL;
                                        oFRegWrite     <= 1'b0;
                                        oFPALUControl  <= OPNULL;
                                        oOrigAFPALU    <= 1'b0;
                                        oFPALUStart    <= 1'b0;
                                        oFWriteData    <= 1'b0;
                                        oWrite2Mem     <= 1'b0;

                                        nx_state        <= ST_ERRO;
                                    end
                            endcase
                        end

                    FUNCT7_MAX_MIN_S:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA

                            case(Funct3)
                                FUNCT3_FMAX_S: oFPALUControl <= FOPMAX;
                                FUNCT3_FMIN_S: oFPALUControl <= FOPMIN;
                                default:
                                    begin
                                        oEcall          <= 1'b0;
                                        oEbreak         <= 1'b0;
                                        oInvInstruction<= 1'b0;
                                        oEscreveIR      <= 1'b0;
                                        oEscrevePC      <= 1'b0;
                                        oEscrevePCCond <= 1'b0;
                                        oEscrevePCBack <= 1'b0;
                                        oOrigAULA       <= 3'b000;
                                        oOrigBULA       <= 3'b000;
                                        oMem2Reg        <= 3'b000;
                                        oOrigPC             <= 3'b000;
                                        oIouD           <= 1'b0;
                                        oRegWrite       <= 1'b0;
                                        oCSRegWrite     <= 1'b0;
                                        oMemWrite       <= 1'b0;
                                        oMemRead        <= 1'b0;
                                        oALUControl     <= OPNULL;
                                        oFRegWrite     <= 1'b0;
                                        oFPALUControl  <= OPNULL;
                                        oOrigAFPALU    <= 1'b0;
                                        oFPALUStart    <= 1'b0;
                                        oFWriteData    <= 1'b0;
                                        oWrite2Mem     <= 1'b0;

                                        nx_state        <= ST_ERRO;
                                    end
                            endcase
                        end

                    FUNCT7_FCOMPARE:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA

                            case(Funct3)
                                FUNCT3_FEQ_S: oFPALUControl <= FOPCEQ;
                                FUNCT3_FLE_S: oFPALUControl <= FOPCLE;
                                FUNCT3_FLT_S: oFPALUControl <= FOPCLT;
                                default:
                                    begin
                                        oEcall          <= 1'b0;
                                        oEbreak         <= 1'b0;
                                        oInvInstruction<= 1'b0;
                                        oEscreveIR      <= 1'b0;
                                        oEscrevePC      <= 1'b0;
                                        oEscrevePCCond <= 1'b0;
                                        oEscrevePCBack <= 1'b0;
                                        oOrigAULA       <= 3'b000;
                                        oOrigBULA       <= 3'b000;
                                        oMem2Reg        <= 3'b000;
                                        oOrigPC             <= 3'b000;
                                        oIouD           <= 1'b0;
                                        oRegWrite       <= 1'b0;
                                        oCSRegWrite     <= 1'b0;
                                        oMemWrite       <= 1'b0;
                                        oMemRead        <= 1'b0;
                                        oALUControl     <= OPNULL;
                                        oFRegWrite     <= 1'b0;
                                        oFPALUControl  <= OPNULL;
                                        oOrigAFPALU    <= 1'b0;
                                        oFPALUStart    <= 1'b0;
                                        oFWriteData    <= 1'b0;
                                        oWrite2Mem     <= 1'b0;

                                        nx_state        <= ST_ERRO;
                                    end
                            endcase
                        end

                    FUNCT7_FCVT_S_W_WU:
                        begin
                            oOrigAFPALU    <= 1'b0; //A

                            case(Rs2)
                                RS2_FCVT_S_W:  oFPALUControl <= FOPCVTSW;
                                RS2_FCVT_S_WU: oFPALUControl <= FOPCVTSWU;
                                default:
                                    begin
                                        oEcall          <= 1'b0;
                                        oEbreak         <= 1'b0;
                                        oInvInstruction<= 1'b0;
                                        oEscreveIR      <= 1'b0;
                                        oEscrevePC      <= 1'b0;
                                        oEscrevePCCond <= 1'b0;
                                        oEscrevePCBack <= 1'b0;
                                        oOrigAULA       <= 3'b000;
                                        oOrigBULA       <= 3'b000;
                                        oMem2Reg        <= 3'b000;
                                        oOrigPC             <= 3'b000;
                                        oIouD           <= 1'b0;
                                        oRegWrite       <= 1'b0;
                                        oCSRegWrite     <= 1'b0;
                                        oMemWrite       <= 1'b0;
                                        oMemRead        <= 1'b0;
                                        oALUControl     <= OPNULL;
                                        oFRegWrite     <= 1'b0;
                                        oFPALUControl  <= OPNULL;
                                        oOrigAFPALU    <= 1'b0;
                                        oFPALUStart    <= 1'b0;
                                        oFWriteData    <= 1'b0;
                                        oWrite2Mem     <= 1'b0;

                                        nx_state        <= ST_ERRO;
                                    end
                            endcase
                        end

                    FUNCT7_FCVT_W_WU_S:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA

                            case(Rs2)
                                RS2_FCVT_W_S:  oFPALUControl <= FOPCVTWS;
                                RS2_FCVT_WU_S: oFPALUControl <= FOPCVTWUS;
                                default:
                                    begin
                                        oEcall          <= 1'b0;
                                        oEbreak         <= 1'b0;
                                        oInvInstruction<= 1'b0;
                                        oEscreveIR      <= 1'b0;
                                        oEscrevePC      <= 1'b0;
                                        oEscrevePCCond <= 1'b0;
                                        oEscrevePCBack <= 1'b0;
                                        oOrigAULA       <= 3'b000;
                                        oOrigBULA       <= 3'b000;
                                        oMem2Reg        <= 3'b000;
                                        oOrigPC             <= 3'b000;
                                        oIouD           <= 1'b0;
                                        oRegWrite       <= 1'b0;
                                        oCSRegWrite     <= 1'b0;
                                        oMemWrite       <= 1'b0;
                                        oMemRead        <= 1'b0;
                                        oALUControl     <= OPNULL;
                                        oFRegWrite     <= 1'b0;
                                        oFPALUControl  <= OPNULL;
                                        oOrigAFPALU    <= 1'b0;
                                        oFPALUStart    <= 1'b0;
                                        oFWriteData    <= 1'b0;
                                        oWrite2Mem     <= 1'b0;

                                        nx_state        <= ST_ERRO;
                                    end
                            endcase
                        end

                    default:
                        begin
                            oEcall          <= 1'b0;
                            oEbreak         <= 1'b0;
                            oInvInstruction<= 1'b0;
                            oEscreveIR      <= 1'b0;
                            oEscrevePC      <= 1'b0;
                            oEscrevePCCond <= 1'b0;
                            oEscrevePCBack <= 1'b0;
                            oOrigAULA       <= 3'b000;
                            oOrigBULA       <= 3'b000;
                            oMem2Reg        <= 3'b000;
                            oOrigPC             <= 3'b000;
                            oIouD           <= 1'b0;
                            oRegWrite       <= 1'b0;
                            oCSRegWrite     <= 1'b0;
                            oMemWrite       <= 1'b0;
                            oMemRead        <= 1'b0;
                            oALUControl     <= OPNULL;
                            oFRegWrite     <= 1'b0;
                            oFPALUControl  <= OPNULL;
                            oOrigAFPALU    <= 1'b0;
                            oFPALUStart    <= 1'b0;
                            oFWriteData    <= 1'b0;
                            oWrite2Mem     <= 1'b0;

                            nx_state        <= ST_ERRO;
                        end
                endcase
            end

        ST_FPSTART:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000; // Don't care
                oOrigBULA       <= 3'b000; // Don't care
                oMem2Reg        <= 3'b011;
                oOrigPC             <= 3'b000; // PC+4
                oIouD           <= 1'b0;
                oRegWrite       <= 1'b0;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b0;
                oALUControl     <= OPNULL;
                oFRegWrite     <= 1'b0;
                //oFPALUControl  <= OPNULL;
                //oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b1;
                oFWriteData    <= 1'b1;
                oWrite2Mem     <= 1'b0;

                nx_state        <= ST_FPWAIT;

                case (Funct7)
                    FUNCT7_FADD_S:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA
                            oFPALUControl <= FOPADD;
                        end
                    FUNCT7_FSUB_S:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA
                            oFPALUControl <= FOPSUB;
                        end
                    FUNCT7_FMUL_S:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA
                            oFPALUControl <= FOPMUL;
                        end
                    FUNCT7_FDIV_S:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA
                            oFPALUControl <= FOPDIV;
                        end
                    FUNCT7_FSQRT_S:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA
                            oFPALUControl <= FOPSQRT;
                        end
                    FUNCT7_FMV_S_X:
                        begin
                            oOrigAFPALU    <= 1'b0; //A
                            oFPALUControl <= FOPMV;
                        end
                    FUNCT7_FMV_X_S:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA
                            oFPALUControl <= FOPMV;
                        end

                    FUNCT7_FSIGN_INJECT:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA

                            case(Funct3)
                                FUNCT3_FSGNJ_S:  oFPALUControl <= FOPSGNJ;
                                FUNCT3_FSGNJN_S: oFPALUControl <= FOPSGNJN;
                                FUNCT3_FSGNJX_S: oFPALUControl <= FOPSGNJX;
                                default:
                                    begin
                                        oEcall          <= 1'b0;
                                        oEbreak         <= 1'b0;
                                        oInvInstruction<= 1'b0;
                                        oEscreveIR      <= 1'b0;
                                        oEscrevePC      <= 1'b0;
                                        oEscrevePCCond <= 1'b0;
                                        oEscrevePCBack <= 1'b0;
                                        oOrigAULA       <= 3'b000;
                                        oOrigBULA       <= 3'b000;
                                        oMem2Reg        <= 3'b000;
                                        oOrigPC             <= 3'b000;
                                        oIouD           <= 1'b0;
                                        oRegWrite       <= 1'b0;
                                        oCSRegWrite     <= 1'b0;
                                        oMemWrite       <= 1'b0;
                                        oMemRead        <= 1'b0;
                                        oALUControl     <= OPNULL;
                                        oFRegWrite     <= 1'b0;
                                        oFPALUControl  <= OPNULL;
                                        oOrigAFPALU    <= 1'b0;
                                        oFPALUStart    <= 1'b0;
                                        oFWriteData    <= 1'b0;
                                        oWrite2Mem     <= 1'b0;

                                        nx_state        <= ST_ERRO;
                                    end
                            endcase
                        end

                    FUNCT7_MAX_MIN_S:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA

                            case(Funct3)
                                FUNCT3_FMAX_S: oFPALUControl <= FOPMAX;
                                FUNCT3_FMIN_S: oFPALUControl <= FOPMIN;
                                default:
                                    begin
                                        oEcall          <= 1'b0;
                                        oEbreak         <= 1'b0;
                                        oInvInstruction<= 1'b0;
                                        oEscreveIR      <= 1'b0;
                                        oEscrevePC      <= 1'b0;
                                        oEscrevePCCond <= 1'b0;
                                        oEscrevePCBack <= 1'b0;
                                        oOrigAULA       <= 3'b000;
                                        oOrigBULA       <= 3'b000;
                                        oMem2Reg        <= 3'b000;
                                        oOrigPC             <= 3'b000;
                                        oIouD           <= 1'b0;
                                        oRegWrite       <= 1'b0;
                                        oCSRegWrite     <= 1'b0;
                                        oMemWrite       <= 1'b0;
                                        oMemRead        <= 1'b0;
                                        oALUControl     <= OPNULL;
                                        oFRegWrite     <= 1'b0;
                                        oFPALUControl  <= OPNULL;
                                        oOrigAFPALU    <= 1'b0;
                                        oFPALUStart    <= 1'b0;
                                        oFWriteData    <= 1'b0;
                                        oWrite2Mem     <= 1'b0;

                                        nx_state        <= ST_ERRO;
                                    end
                            endcase
                        end

                    FUNCT7_FCOMPARE:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA

                            case(Funct3)
                                FUNCT3_FEQ_S: oFPALUControl <= FOPCEQ;
                                FUNCT3_FLE_S: oFPALUControl <= FOPCLE;
                                FUNCT3_FLT_S: oFPALUControl <= FOPCLT;
                                default:
                                    begin
                                        oEcall          <= 1'b0;
                                        oEbreak         <= 1'b0;
                                        oInvInstruction<= 1'b0;
                                        oEscreveIR      <= 1'b0;
                                        oEscrevePC      <= 1'b0;
                                        oEscrevePCCond <= 1'b0;
                                        oEscrevePCBack <= 1'b0;
                                        oOrigAULA       <= 3'b000;
                                        oOrigBULA       <= 3'b000;
                                        oMem2Reg        <= 3'b000;
                                        oOrigPC             <= 3'b000;
                                        oIouD           <= 1'b0;
                                        oRegWrite       <= 1'b0;
                                        oCSRegWrite     <= 1'b0;
                                        oMemWrite       <= 1'b0;
                                        oMemRead        <= 1'b0;
                                        oALUControl     <= OPNULL;
                                        oFRegWrite     <= 1'b0;
                                        oFPALUControl  <= OPNULL;
                                        oOrigAFPALU    <= 1'b0;
                                        oFPALUStart    <= 1'b0;
                                        oFWriteData    <= 1'b0;
                                        oWrite2Mem     <= 1'b0;

                                        nx_state        <= ST_ERRO;
                                    end
                            endcase
                        end

                    FUNCT7_FCVT_S_W_WU:
                        begin
                            oOrigAFPALU    <= 1'b0; //A

                            case(Rs2)
                                RS2_FCVT_S_W:  oFPALUControl <= FOPCVTSW;
                                RS2_FCVT_S_WU: oFPALUControl <= FOPCVTSWU;
                                default:
                                    begin
                                        oEcall          <= 1'b0;
                                        oEbreak         <= 1'b0;
                                        oInvInstruction<= 1'b0;
                                        oEscreveIR      <= 1'b0;
                                        oEscrevePC      <= 1'b0;
                                        oEscrevePCCond <= 1'b0;
                                        oEscrevePCBack <= 1'b0;
                                        oOrigAULA       <= 3'b000;
                                        oOrigBULA       <= 3'b000;
                                        oMem2Reg        <= 3'b000;
                                        oOrigPC             <= 3'b000;
                                        oIouD           <= 1'b0;
                                        oRegWrite       <= 1'b0;
                                        oCSRegWrite     <= 1'b0;
                                        oMemWrite       <= 1'b0;
                                        oMemRead        <= 1'b0;
                                        oALUControl     <= OPNULL;
                                        oFRegWrite     <= 1'b0;
                                        oFPALUControl  <= OPNULL;
                                        oOrigAFPALU    <= 1'b0;
                                        oFPALUStart    <= 1'b0;
                                        oFWriteData    <= 1'b0;
                                        oWrite2Mem     <= 1'b0;

                                        nx_state        <= ST_ERRO;
                                    end
                            endcase
                        end

                    FUNCT7_FCVT_W_WU_S:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA

                            case(Rs2)
                                RS2_FCVT_W_S:  oFPALUControl <= FOPCVTWS;
                                RS2_FCVT_WU_S: oFPALUControl <= FOPCVTWUS;
                                default:
                                    begin
                                        oEcall          <= 1'b0;
                                        oEbreak         <= 1'b0;
                                        oInvInstruction<= 1'b0;
                                        oEscreveIR      <= 1'b0;
                                        oEscrevePC      <= 1'b0;
                                        oEscrevePCCond <= 1'b0;
                                        oEscrevePCBack <= 1'b0;
                                        oOrigAULA       <= 3'b000;
                                        oOrigBULA       <= 3'b000;
                                        oMem2Reg        <= 3'b000;
                                        oOrigPC             <= 3'b000;
                                        oIouD           <= 1'b0;
                                        oRegWrite       <= 1'b0;
                                        oCSRegWrite     <= 1'b0;
                                        oMemWrite       <= 1'b0;
                                        oMemRead        <= 1'b0;
                                        oALUControl     <= OPNULL;
                                        oFRegWrite     <= 1'b0;
                                        oFPALUControl  <= OPNULL;
                                        oOrigAFPALU    <= 1'b0;
                                        oFPALUStart    <= 1'b0;
                                        oFWriteData    <= 1'b0;
                                        oWrite2Mem     <= 1'b0;

                                        nx_state        <= ST_ERRO;
                                    end
                            endcase
                        end

                    default:
                        begin
                            oEcall          <= 1'b0;
                            oEbreak         <= 1'b0;
                            oInvInstruction<= 1'b0;
                            oEscreveIR      <= 1'b0;
                            oEscrevePC      <= 1'b0;
                            oEscrevePCCond <= 1'b0;
                            oEscrevePCBack <= 1'b0;
                            oOrigAULA       <= 3'b000;
                            oOrigBULA       <= 3'b000;
                            oMem2Reg        <= 3'b000;
                            oOrigPC             <= 3'b000;
                            oIouD           <= 1'b0;
                            oRegWrite       <= 1'b0;
                            oCSRegWrite     <= 1'b0;
                            oMemWrite       <= 1'b0;
                            oMemRead        <= 1'b0;
                            oALUControl     <= OPNULL;
                            oFRegWrite     <= 1'b0;
                            oFPALUControl  <= OPNULL;
                            oOrigAFPALU    <= 1'b0;
                            oFPALUStart    <= 1'b0;
                            oFWriteData    <= 1'b0;
                            oWrite2Mem     <= 1'b0;

                            nx_state        <= ST_ERRO;
                        end
                endcase
            end

        ST_FPWAIT:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000; // Don't care
                oOrigBULA       <= 3'b000; // Don't care
                oMem2Reg        <= 3'b011;
                oOrigPC             <= 3'b000; // PC+4
                oIouD           <= 1'b0;
                oRegWrite       <= 1'b0;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b0;
                oALUControl     <= OPNULL;
                oFRegWrite     <= 1'b0;
                //oFPALUControl  definido nos cases abaixo;
                //oOrigAFPALU    definido nos cases abaixo;
                oFPALUStart    <= 1'b1; // fica start durante o tempo todo (como no uniciclo)
                oFWriteData    <= 1'b1;
                oWrite2Mem     <= 1'b0;

                if (iFPALUReady)
                    nx_state <= ST_FPALUREGWRITE;
                else
                    nx_state <= ST_FPWAIT;

                case (Funct7)
                    FUNCT7_FADD_S:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA
                            oFPALUControl <= FOPADD;
                        end
                    FUNCT7_FSUB_S:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA
                            oFPALUControl <= FOPSUB;
                        end
                    FUNCT7_FMUL_S:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA
                            oFPALUControl <= FOPMUL;
                        end
                    FUNCT7_FDIV_S:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA
                            oFPALUControl <= FOPDIV;
                        end
                    FUNCT7_FSQRT_S:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA
                            oFPALUControl <= FOPSQRT;
                        end
                    FUNCT7_FMV_S_X:
                        begin
                            oOrigAFPALU    <= 1'b0; //A
                            oFPALUControl <= FOPMV;
                        end
                    FUNCT7_FMV_X_S:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA
                            oFPALUControl <= FOPMV;
                        end

                    FUNCT7_FSIGN_INJECT:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA

                            case(Funct3)
                                FUNCT3_FSGNJ_S:  oFPALUControl <= FOPSGNJ;
                                FUNCT3_FSGNJN_S: oFPALUControl <= FOPSGNJN;
                                FUNCT3_FSGNJX_S: oFPALUControl <= FOPSGNJX;
                                default:
                                    begin
                                        oEcall          <= 1'b0;
                                        oEbreak         <= 1'b0;
                                        oInvInstruction<= 1'b0;
                                        oEscreveIR      <= 1'b0;
                                        oEscrevePC      <= 1'b0;
                                        oEscrevePCCond <= 1'b0;
                                        oEscrevePCBack <= 1'b0;
                                        oOrigAULA       <= 3'b000;
                                        oOrigBULA       <= 3'b000;
                                        oMem2Reg        <= 3'b000;
                                        oOrigPC             <= 3'b000;
                                        oIouD           <= 1'b0;
                                        oRegWrite       <= 1'b0;
                                        oCSRegWrite     <= 1'b0;
                                        oMemWrite       <= 1'b0;
                                        oMemRead        <= 1'b0;
                                        oALUControl     <= OPNULL;
                                        oFRegWrite     <= 1'b0;
                                        oFPALUControl  <= OPNULL;
                                        oOrigAFPALU    <= 1'b0;
                                        oFPALUStart    <= 1'b0;
                                        oFWriteData    <= 1'b0;
                                        oWrite2Mem     <= 1'b0;

                                        nx_state        <= ST_ERRO;
                                    end
                            endcase
                        end

                    FUNCT7_MAX_MIN_S:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA

                            case(Funct3)
                                FUNCT3_FMAX_S: oFPALUControl <= FOPMAX;
                                FUNCT3_FMIN_S: oFPALUControl <= FOPMIN;
                                default:
                                    begin
                                        oEcall          <= 1'b0;
                                        oEbreak         <= 1'b0;
                                        oInvInstruction<= 1'b0;
                                        oEscreveIR      <= 1'b0;
                                        oEscrevePC      <= 1'b0;
                                        oEscrevePCCond <= 1'b0;
                                        oEscrevePCBack <= 1'b0;
                                        oOrigAULA       <= 3'b000;
                                        oOrigBULA       <= 3'b000;
                                        oMem2Reg        <= 3'b000;
                                        oOrigPC             <= 3'b000;
                                        oIouD           <= 1'b0;
                                        oRegWrite       <= 1'b0;
                                        oCSRegWrite     <= 1'b0;
                                        oMemWrite       <= 1'b0;
                                        oMemRead        <= 1'b0;
                                        oALUControl     <= OPNULL;
                                        oFRegWrite     <= 1'b0;
                                        oFPALUControl  <= OPNULL;
                                        oOrigAFPALU    <= 1'b0;
                                        oFPALUStart    <= 1'b0;
                                        oFWriteData    <= 1'b0;
                                        oWrite2Mem     <= 1'b0;

                                        nx_state        <= ST_ERRO;
                                    end
                            endcase
                        end

                    FUNCT7_FCOMPARE:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA

                            case(Funct3)
                                FUNCT3_FEQ_S: oFPALUControl <= FOPCEQ;
                                FUNCT3_FLE_S: oFPALUControl <= FOPCLE;
                                FUNCT3_FLT_S: oFPALUControl <= FOPCLT;
                                default:
                                    begin
                                        oEcall          <= 1'b0;
                                        oEbreak         <= 1'b0;
                                        oInvInstruction<= 1'b0;
                                        oEscreveIR      <= 1'b0;
                                        oEscrevePC      <= 1'b0;
                                        oEscrevePCCond <= 1'b0;
                                        oEscrevePCBack <= 1'b0;
                                        oOrigAULA       <= 3'b000;
                                        oOrigBULA       <= 3'b000;
                                        oMem2Reg        <= 3'b000;
                                        oOrigPC             <= 3'b000;
                                        oIouD           <= 1'b0;
                                        oRegWrite       <= 1'b0;
                                        oCSRegWrite     <= 1'b0;
                                        oMemWrite       <= 1'b0;
                                        oMemRead        <= 1'b0;
                                        oALUControl     <= OPNULL;
                                        oFRegWrite     <= 1'b0;
                                        oFPALUControl  <= OPNULL;
                                        oOrigAFPALU    <= 1'b0;
                                        oFPALUStart    <= 1'b0;
                                        oFWriteData    <= 1'b0;
                                        oWrite2Mem     <= 1'b0;

                                        nx_state        <= ST_ERRO;
                                    end
                            endcase
                        end

                    FUNCT7_FCVT_S_W_WU:
                        begin
                            oOrigAFPALU    <= 1'b0; //A

                            case(Rs2)
                                RS2_FCVT_S_W:  oFPALUControl <= FOPCVTSW;
                                RS2_FCVT_S_WU: oFPALUControl <= FOPCVTSWU;
                                default:
                                    begin
                                        oEcall          <= 1'b0;
                                        oEbreak         <= 1'b0;
                                        oInvInstruction<= 1'b0;
                                        oEscreveIR      <= 1'b0;
                                        oEscrevePC      <= 1'b0;
                                        oEscrevePCCond <= 1'b0;
                                        oEscrevePCBack <= 1'b0;
                                        oOrigAULA       <= 3'b000;
                                        oOrigBULA       <= 3'b000;
                                        oMem2Reg        <= 3'b000;
                                        oOrigPC             <= 3'b000;
                                        oIouD           <= 1'b0;
                                        oRegWrite       <= 1'b0;
                                        oCSRegWrite     <= 1'b0;
                                        oMemWrite       <= 1'b0;
                                        oMemRead        <= 1'b0;
                                        oALUControl     <= OPNULL;
                                        oFRegWrite     <= 1'b0;
                                        oFPALUControl  <= OPNULL;
                                        oOrigAFPALU    <= 1'b0;
                                        oFPALUStart    <= 1'b0;
                                        oFWriteData    <= 1'b0;
                                        oWrite2Mem     <= 1'b0;

                                        nx_state        <= ST_ERRO;
                                    end
                            endcase
                        end

                    FUNCT7_FCVT_W_WU_S:
                        begin
                            oOrigAFPALU    <= 1'b1; //FA

                            case(Rs2)
                                RS2_FCVT_W_S:  oFPALUControl <= FOPCVTWS;
                                RS2_FCVT_WU_S: oFPALUControl <= FOPCVTWUS;
                                default:
                                    begin
                                        oEcall          <= 1'b0;
                                        oEbreak         <= 1'b0;
                                        oInvInstruction<= 1'b0;
                                        oEscreveIR      <= 1'b0;
                                        oEscrevePC      <= 1'b0;
                                        oEscrevePCCond <= 1'b0;
                                        oEscrevePCBack <= 1'b0;
                                        oOrigAULA       <= 3'b000;
                                        oOrigBULA       <= 3'b000;
                                        oMem2Reg        <= 3'b000;
                                        oOrigPC             <= 3'b000;
                                        oIouD           <= 1'b0;
                                        oRegWrite       <= 1'b0;
                                        oCSRegWrite     <= 1'b0;
                                        oMemWrite       <= 1'b0;
                                        oMemRead        <= 1'b0;
                                        oALUControl     <= OPNULL;
                                        oFRegWrite     <= 1'b0;
                                        oFPALUControl  <= OPNULL;
                                        oOrigAFPALU    <= 1'b0;
                                        oFPALUStart    <= 1'b0;
                                        oFWriteData    <= 1'b0;
                                        oWrite2Mem     <= 1'b0;

                                        nx_state        <= ST_ERRO;
                                    end
                            endcase
                        end

                    default:
                        begin
                            oEcall          <= 1'b0;
                            oEbreak         <= 1'b0;
                            oInvInstruction<= 1'b0;
                            oEscreveIR      <= 1'b0;
                            oEscrevePC      <= 1'b0;
                            oEscrevePCCond <= 1'b0;
                            oEscrevePCBack <= 1'b0;
                            oOrigAULA       <= 3'b000;
                            oOrigBULA       <= 3'b000;
                            oMem2Reg        <= 3'b000;
                            oOrigPC             <= 3'b000;
                            oIouD           <= 1'b0;
                            oRegWrite       <= 1'b0;
                            oCSRegWrite     <= 1'b0;
                            oMemWrite       <= 1'b0;
                            oMemRead        <= 1'b0;
                            oALUControl     <= OPNULL;
                            oFRegWrite     <= 1'b0;
                            oFPALUControl  <= OPNULL;
                            oOrigAFPALU    <= 1'b0;
                            oFPALUStart    <= 1'b0;
                            oFWriteData    <= 1'b0;
                            oWrite2Mem     <= 1'b0;

                            nx_state        <= ST_ERRO;
                        end
                endcase
            end

        ST_FPALUREGWRITE:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;  // Don't care
                oOrigBULA       <= 3'b000;  // Don't care
                oMem2Reg        <= 3'b011;  // Se for escrever nos registradores de inteiro, a selecao eh da saida da FPULA
                oOrigPC             <= 3'b000;  // PC+4
                oIouD           <= 1'b0;
                //oRegWrite definido abaixo
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;   // Nao escreve na memoria
                oMemRead        <= 1'b0;   // Nao le da memoria
                oALUControl     <= OPNULL; // ULA nao realiza nenhuma operacao
                //oFRegWrite definido abaixo
                //oFPALUControl definido abaixo
                oFPALUStart    <= 1'b1;  // fica em start ainda (pra não perder o valor?)
                oFWriteData    <= 1'b1; // Dado de escrita vem da FPALU
                oWrite2Mem     <= 1'b0; // Nao habilita escrita na memoria

                nx_state <=  ST_FETCH;


                case (Funct7)
                    FUNCT7_FADD_S:
                        begin
                            oFRegWrite     <= 1'b1;
                            oRegWrite       <= 1'b0;
                            oOrigAFPALU    <= 1'b1; //FA
                            oFPALUControl <= FOPADD;
                        end
                    FUNCT7_FSUB_S:
                        begin
                            oFRegWrite     <= 1'b1;
                            oRegWrite       <= 1'b0;
                            oOrigAFPALU    <= 1'b1; //FA
                            oFPALUControl <= FOPSUB;
                        end
                    FUNCT7_FMUL_S:
                        begin
                            oFRegWrite     <= 1'b1;
                            oRegWrite       <= 1'b0;
                            oOrigAFPALU    <= 1'b1; //FA
                            oFPALUControl <= FOPMUL;
                        end
                    FUNCT7_FDIV_S:
                        begin
                            oFRegWrite     <= 1'b1;
                            oRegWrite       <= 1'b0;
                            oOrigAFPALU    <= 1'b1; //FA
                            oFPALUControl <= FOPDIV;
                        end
                    FUNCT7_FSQRT_S:
                        begin
                            oFRegWrite     <= 1'b1;
                            oRegWrite       <= 1'b0;
                            oOrigAFPALU    <= 1'b1; //FA
                            oFPALUControl <= FOPSQRT;
                        end
                    FUNCT7_FMV_S_X:
                        begin
                            oFRegWrite     <= 1'b1;
                            oRegWrite       <= 1'b0;
                            oOrigAFPALU    <= 1'b0; //A
                            oFPALUControl <= FOPMV;
                        end
                    FUNCT7_FMV_X_S:
                        begin
                            oFRegWrite     <= 1'b0;
                            oRegWrite       <= 1'b1;
                            oOrigAFPALU    <= 1'b1; //FA
                            oFPALUControl <= FOPMV;
                        end

                    FUNCT7_FSIGN_INJECT:
                        begin
                            oFRegWrite     <= 1'b1;
                            oRegWrite       <= 1'b0;
                            oOrigAFPALU    <= 1'b1; //FA

                            case(Funct3)
                                FUNCT3_FSGNJ_S:  oFPALUControl <= FOPSGNJ;
                                FUNCT3_FSGNJN_S: oFPALUControl <= FOPSGNJN;
                                FUNCT3_FSGNJX_S: oFPALUControl <= FOPSGNJX;
                                default:
                                    begin
                                        oEcall          <= 1'b0;
                                        oEbreak         <= 1'b0;
                                        oInvInstruction<= 1'b0;
                                        oEscreveIR      <= 1'b0;
                                        oEscrevePC      <= 1'b0;
                                        oEscrevePCCond <= 1'b0;
                                        oEscrevePCBack <= 1'b0;
                                        oOrigAULA       <= 3'b000;
                                        oOrigBULA       <= 3'b000;
                                        oMem2Reg        <= 3'b000;
                                        oOrigPC             <= 3'b000;
                                        oIouD           <= 1'b0;
                                        oRegWrite       <= 1'b0;
                                        oCSRegWrite     <= 1'b0;
                                        oMemWrite       <= 1'b0;
                                        oMemRead        <= 1'b0;
                                        oALUControl     <= OPNULL;
                                        oFRegWrite     <= 1'b0;
                                        oFPALUControl  <= OPNULL;
                                        oOrigAFPALU    <= 1'b0;
                                        oFPALUStart    <= 1'b0;
                                        oFWriteData    <= 1'b0;
                                        oWrite2Mem     <= 1'b0;

                                        nx_state        <= ST_ERRO;
                                    end
                            endcase
                        end

                    FUNCT7_MAX_MIN_S:
                        begin
                            oFRegWrite     <= 1'b1;
                            oRegWrite       <= 1'b0;
                            oOrigAFPALU    <= 1'b1; //FA

                            case(Funct3)
                                FUNCT3_FMAX_S: oFPALUControl <= FOPMAX;
                                FUNCT3_FMIN_S: oFPALUControl <= FOPMIN;
                                default:
                                    begin
                                        oEcall          <= 1'b0;
                                        oEbreak         <= 1'b0;
                                        oInvInstruction<= 1'b0;
                                        oEscreveIR      <= 1'b0;
                                        oEscrevePC      <= 1'b0;
                                        oEscrevePCCond <= 1'b0;
                                        oEscrevePCBack <= 1'b0;
                                        oOrigAULA       <= 3'b000;
                                        oOrigBULA       <= 3'b000;
                                        oMem2Reg        <= 3'b000;
                                        oOrigPC             <= 3'b000;
                                        oIouD           <= 1'b0;
                                        oRegWrite       <= 1'b0;
                                        oCSRegWrite     <= 1'b0;
                                        oMemWrite       <= 1'b0;
                                        oMemRead        <= 1'b0;
                                        oALUControl     <= OPNULL;
                                        oFRegWrite     <= 1'b0;
                                        oFPALUControl  <= OPNULL;
                                        oOrigAFPALU    <= 1'b0;
                                        oFPALUStart    <= 1'b0;
                                        oFWriteData    <= 1'b0;
                                        oWrite2Mem     <= 1'b0;

                                        nx_state        <= ST_ERRO;
                                    end
                            endcase
                        end

                    FUNCT7_FCOMPARE:
                        begin
                            oFRegWrite     <= 1'b0;
                            oRegWrite       <= 1'b1;
                            oOrigAFPALU    <= 1'b1; //FA

                            case(Funct3)
                                FUNCT3_FEQ_S: oFPALUControl <= FOPCEQ;
                                FUNCT3_FLE_S: oFPALUControl <= FOPCLE;
                                FUNCT3_FLT_S: oFPALUControl <= FOPCLT;
                                default:
                                    begin
                                        oEcall          <= 1'b0;
                                        oEbreak         <= 1'b0;
                                        oInvInstruction<= 1'b0;
                                        oEscreveIR      <= 1'b0;
                                        oEscrevePC      <= 1'b0;
                                        oEscrevePCCond <= 1'b0;
                                        oEscrevePCBack <= 1'b0;
                                        oOrigAULA       <= 3'b000;
                                        oOrigBULA       <= 3'b000;
                                        oMem2Reg        <= 3'b000;
                                        oOrigPC             <= 3'b000;
                                        oIouD           <= 1'b0;
                                        oRegWrite       <= 1'b0;
                                        oCSRegWrite     <= 1'b0;
                                        oMemWrite       <= 1'b0;
                                        oMemRead        <= 1'b0;
                                        oALUControl     <= OPNULL;
                                        oFRegWrite     <= 1'b0;
                                        oFPALUControl  <= OPNULL;
                                        oOrigAFPALU    <= 1'b0;
                                        oFPALUStart    <= 1'b0;
                                        oFWriteData    <= 1'b0;
                                        oWrite2Mem     <= 1'b0;

                                        nx_state        <= ST_ERRO;
                                    end
                            endcase
                        end

                    FUNCT7_FCVT_S_W_WU:
                        begin
                            oFRegWrite     <= 1'b1;
                            oRegWrite       <= 1'b0;
                            oOrigAFPALU    <= 1'b0; //A

                            case(Rs2)
                                RS2_FCVT_S_W:  oFPALUControl <= FOPCVTSW;
                                RS2_FCVT_S_WU: oFPALUControl <= FOPCVTSWU;
                                default:
                                    begin
                                        oEcall          <= 1'b0;
                                        oEbreak         <= 1'b0;
                                        oInvInstruction<= 1'b0;
                                        oEscreveIR      <= 1'b0;
                                        oEscrevePC      <= 1'b0;
                                        oEscrevePCCond <= 1'b0;
                                        oEscrevePCBack <= 1'b0;
                                        oOrigAULA       <= 3'b000;
                                        oOrigBULA       <= 3'b000;
                                        oMem2Reg        <= 3'b000;
                                        oOrigPC             <= 3'b000;
                                        oIouD           <= 1'b0;
                                        oRegWrite       <= 1'b0;
                                        oCSRegWrite     <= 1'b0;
                                        oMemWrite       <= 1'b0;
                                        oMemRead        <= 1'b0;
                                        oALUControl     <= OPNULL;
                                        oFRegWrite     <= 1'b0;
                                        oFPALUControl  <= OPNULL;
                                        oOrigAFPALU    <= 1'b0;
                                        oFPALUStart    <= 1'b0;
                                        oFWriteData    <= 1'b0;
                                        oWrite2Mem     <= 1'b0;

                                        nx_state        <= ST_ERRO;
                                    end
                            endcase
                        end

                    FUNCT7_FCVT_W_WU_S:
                        begin
                            oFRegWrite     <= 1'b0;
                            oRegWrite       <= 1'b1;
                            oOrigAFPALU    <= 1'b1; //FA

                            case(Rs2)
                                RS2_FCVT_W_S:  oFPALUControl <= FOPCVTWS;
                                RS2_FCVT_WU_S: oFPALUControl <= FOPCVTWUS;
                                default:
                                    begin
                                        oEcall          <= 1'b0;
                                        oEbreak         <= 1'b0;
                                        oInvInstruction<= 1'b0;
                                        oEscreveIR      <= 1'b0;
                                        oEscrevePC      <= 1'b0;
                                        oEscrevePCCond <= 1'b0;
                                        oEscrevePCBack <= 1'b0;
                                        oOrigAULA       <= 3'b000;
                                        oOrigBULA       <= 3'b000;
                                        oMem2Reg        <= 3'b000;
                                        oOrigPC             <= 3'b000;
                                        oIouD           <= 1'b0;
                                        oRegWrite       <= 1'b0;
                                        oCSRegWrite     <= 1'b0;
                                        oMemWrite       <= 1'b0;
                                        oMemRead        <= 1'b0;
                                        oALUControl     <= OPNULL;
                                        oFRegWrite     <= 1'b0;
                                        oFPALUControl  <= OPNULL;
                                        oOrigAFPALU    <= 1'b0;
                                        oFPALUStart    <= 1'b0;
                                        oFWriteData    <= 1'b0;
                                        oWrite2Mem     <= 1'b0;

                                        nx_state        <= ST_ERRO;
                                    end
                            endcase
                        end
                    default:
                        begin
                            oEcall          <= 1'b0;
                            oEbreak         <= 1'b0;
                            oInvInstruction<= 1'b0;
                            oEscreveIR      <= 1'b0;
                            oEscrevePC      <= 1'b0;
                            oEscrevePCCond <= 1'b0;
                            oEscrevePCBack <= 1'b0;
                            oOrigAULA       <= 3'b000;
                            oOrigBULA       <= 3'b000;
                            oMem2Reg        <= 3'b000;
                            oOrigPC             <= 3'b000;
                            oIouD           <= 1'b0;
                            oRegWrite       <= 1'b0;
                            oCSRegWrite     <= 1'b0;
                            oMemWrite       <= 1'b0;
                            oMemRead        <= 1'b0;
                            oALUControl     <= OPNULL;
                            oFRegWrite     <= 1'b0;
                            oFPALUControl  <= OPNULL;
                            oOrigAFPALU    <= 1'b0;
                            oFPALUStart    <= 1'b0;
                            oFWriteData    <= 1'b0;
                            oWrite2Mem     <= 1'b0;

                            nx_state        <= ST_ERRO;
                        end
                endcase
            end
`endif

        // Instrucao invalida
        default:
            begin
                oEcall          <= 1'b0;
                oEbreak         <= 1'b0;
                oInvInstruction<= 1'b0;
                oEscreveIR      <= 1'b0;
                oEscrevePC      <= 1'b0;
                oEscrevePCCond <= 1'b0;
                oEscrevePCBack <= 1'b0;
                oOrigAULA       <= 3'b000;
                oOrigBULA       <= 3'b000;
                oMem2Reg        <= 3'b000;
                oOrigPC             <= 3'b000;
                oIouD           <= 1'b0;
                oRegWrite       <= 1'b0;
                oCSRegWrite     <= 1'b0;
                oMemWrite       <= 1'b0;
                oMemRead        <= 1'b0;
                oALUControl     <= OPNULL;
`ifdef RV32IMF                                                 //RV32IMF
                oFRegWrite     <= 1'b0;
                oFPALUControl  <= OPNULL;
                oOrigAFPALU    <= 1'b0;
                oFPALUStart    <= 1'b0;
                oFWriteData    <= 1'b0;
                oWrite2Mem     <= 1'b0;
`endif


                nx_state        <= ST_ERRO;
            end

    endcase


endmodule
