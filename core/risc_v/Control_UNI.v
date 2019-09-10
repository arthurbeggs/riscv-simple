`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

//*
// * Bloco de Controle UNICICLO
// *


 module Control_UNI(
    input  [31:0] iInstr,
    output [ 1:0]   oOrigAULA,
     output [ 1:0]  oOrigBULA,
     output         oRegWrite,
     output             oCSRegWrite,
     output         oMemWrite,
     output         oMemRead,
     output         oInvInstruction,
     output             oEcall,
     output         oEbreak,
     output [ 2:0]  oMem2Reg,
     output [ 2:0]  oOrigPC,
     output [ 4:0] oALUControl
`ifdef RV32IMF
     ,
     output       oFRegWrite,    // Controla a escrita no FReg
     output [4:0] oFPALUControl, // Controla a operacao a ser realizda pela FPULA
     output       oOrigAFPALU,   // Controla se a entrada A da FPULA  float ou int
     output       oFPALU2Reg,    // Controla a escrita no registrador de inteiros (origem FPULA ou nao?)
     output       oFWriteData,   // Controla a escrita nos FRegisters (origem FPALU(0) : origem memoria(1)?)
     output       oWrite2Mem,     // Controla a escrita na memoria (origem Register(0) : FRegister(1))
     output       oFPstart          // controla/liga a FPULA
`endif
);

wire            wEbreak;
wire [6:0]  Opcode  = iInstr[ 6: 0];
wire [2:0]  Funct3  = iInstr[14:12];
wire [6:0]  Funct7  = iInstr[31:25];
wire [11:0] Funct12 = iInstr[31:20]; // instruções de systema ecall e ebreak em que funct12 = funct7 + rs2
`ifdef RV32IMF
wire [4:0]  Rs2     = iInstr[24:20]; // Para os converts de ponto flutuante
`endif

assign oEbreak = wEbreak;


always @(*)

    case(Opcode)


        OPC_SYSTEM:
            begin


                oMemWrite               <= 1'b0;
                oMemRead                <= 1'b0;



`ifdef RV32IMF
                oFPALU2Reg              <= 1'b0;
                oFPALUControl           <= OPNULL;
                oFRegWrite              <= 1'b0;
                oOrigAFPALU             <= 1'b0;
                oFWriteData             <= 1'b0;
                oWrite2Mem              <= 1'b0;
                oFPstart                    <= 1'b0;
`endif


                case(Funct3)

                    FUNCT3_PRIV:
                        begin
                            case(Funct12)

                                FUNCT12_ECALL:
                                    begin
                                        oCSRegWrite             <= 1'b0;
                                        oInvInstruction     <= 1'b0;
                                        oOrigAULA               <= 2'b00;   // tanto faz ja que regwrite é 0
                                        oOrigBULA               <= 2'b00;   // tanto faz ja que regwrite é 0
                                        oALUControl             <= OPNULL;
                                        oEcall                  <= 1'b1;
                                        wEbreak                 <= 1'b0;
                                        oOrigPC                 <= 3'b100;
                                        oRegWrite               <= 1'b0;
                                        oMem2Reg                <= 3'b000;// tanto faz ja que regwrite é 0
                                    end
                                FUNCT12_EBREAK:
                                    begin

                                        oCSRegWrite             <= 1'b0;
                                        oInvInstruction     <= 1'b0;
                                        oOrigAULA               <= 2'b00;   // tanto faz ja que regwrite é 0
                                        oOrigBULA               <= 2'b00;   // tanto faz ja que regwrite é 0
                                        oALUControl             <= OPNULL;
                                        oEcall                  <= 1'b0;
                                        wEbreak                 <= 1'b1;
                                        oOrigPC                 <= 3'b000;
                                        oRegWrite               <= 1'b0;
                                        oMem2Reg                <= 3'b000;// tanto faz ja que regwrite é 0


                                    end
                                FUNCT12_URET:
                                    begin

                                        oCSRegWrite             <= 1'b0;
                                        oInvInstruction     <= 1'b0;
                                        oOrigAULA               <= 2'b00;   // tanto faz ja que regwrite é 0
                                        oOrigBULA               <= 2'b00;   // tanto faz ja que regwrite é 0
                                        oALUControl             <= OPNULL;
                                        oEcall                  <= 1'b0;
                                        wEbreak                 <= 1'b0;
                                        oOrigPC                 <= 3'b101;      // pc = uepc
                                        oRegWrite               <= 1'b0;
                                        oMem2Reg                <= 3'b000;// tanto faz ja que regwrite é 0

                                    end
                                default: // instrucao invalida
                                    begin

                                        oCSRegWrite             <= 1'b0;
                                        oInvInstruction     <= 1'b1;
                                        oOrigAULA               <= 2'b00;   // tanto faz ja que regwrite é 0
                                        oOrigBULA               <= 2'b00;   // tanto faz ja que regwrite é 0
                                        oALUControl             <= OPNULL;
                                        oEcall                  <= 1'b0;
                                        wEbreak                 <= 1'b0;
                                        oOrigPC                 <= 3'b000;
                                        oRegWrite               <= 1'b0;
                                        oMem2Reg                <= 3'b000;

                                    end
                            endcase
                        end
                    FUNCT3_CSRRW:
                        begin
                            oCSRegWrite             <= 1'b1;
                            oInvInstruction     <= 1'b0;
                            oOrigAULA               <= 2'b00; // conteudo de rs1
                            oOrigBULA               <= 2'b11; // zero
                            oALUControl             <= OPADD;
                            oEcall                  <= 1'b0;
                            wEbreak                 <= 1'b0;
                            oOrigPC                 <= 3'b000;
                            oRegWrite               <= 1'b1;
                            oMem2Reg                <= 3'b100;
                        end
                    FUNCT3_CSRRS:
                        begin
                            oCSRegWrite             <= 1'b1;
                            oInvInstruction     <= 1'b0;
                            oOrigAULA               <= 2'b00; // conteudo de rs1
                            oOrigBULA               <= 2'b10; // CSR
                            oALUControl             <= OPOR;
                            oEcall                  <= 1'b0;
                            wEbreak                 <= 1'b0;
                            oOrigPC                 <= 3'b000;
                            oRegWrite               <= 1'b1;
                            oMem2Reg                <= 3'b100;
                        end
                    FUNCT3_CSRRC:
                        begin
                            oCSRegWrite             <= 1'b1;
                            oInvInstruction     <= 1'b0;
                            oOrigAULA               <= 2'b11; // conteudo de rs1 negado
                            oOrigBULA               <= 2'b10; // CSR
                            oALUControl             <= OPAND; // CSR = CSR & !rs1
                            oEcall                  <= 1'b0;
                            wEbreak                 <= 1'b0;
                            oOrigPC                 <= 3'b000;
                            oRegWrite               <= 1'b1;
                            oMem2Reg                <= 3'b100;
                        end
                    FUNCT3_CSRRWI:
                        begin
                            oCSRegWrite             <= 1'b1;
                            oInvInstruction     <= 1'b0;
                            oOrigAULA               <= 2'b10; //imediato
                            oOrigBULA               <= 2'b11; // zero
                            oALUControl             <= OPADD;
                            oEcall                  <= 1'b0;
                            wEbreak                 <= 1'b0;
                            oOrigPC                 <= 3'b000;
                            oRegWrite               <= 1'b1;
                            oMem2Reg                <= 3'b100;
                        end
                    FUNCT3_CSRRSI:
                        begin
                            oCSRegWrite             <= 1'b1;
                            oInvInstruction     <= 1'b0;
                            oOrigAULA               <= 2'b10;   //imediato
                            oOrigBULA               <= 2'b10;   // CSR
                            oALUControl             <= OPOR;
                            oEcall                  <= 1'b0;
                            wEbreak                 <= 1'b0;
                            oOrigPC                 <= 3'b000;
                            oRegWrite               <= 1'b1;
                            oMem2Reg                <= 3'b100;
                        end
                    FUNCT3_CSRRCI:
                        begin
                            oCSRegWrite             <= 1'b1;
                            oInvInstruction     <= 1'b0;
                            oOrigAULA               <= 2'b10; //imediato
                            oOrigBULA               <= 2'b10; // CSR
                            oALUControl             <= OPAND; // CSR = CSR & ~imm)
                            oEcall                  <= 1'b0;
                            wEbreak                 <= 1'b0;
                            oOrigPC                 <= 3'b000;
                            oRegWrite               <= 1'b1;
                            oMem2Reg                <= 3'b100;
                        end
                    default: // instrucao invalida
                        begin

                            oCSRegWrite             <= 1'b0;
                            oInvInstruction     <= 1'b1;
                            oOrigAULA               <= 2'b00;   // tanto faz ja que regwrite é 0
                            oOrigBULA               <= 2'b00;   // tanto faz ja que regwrite é 0
                            oALUControl             <= OPNULL;
                            oEcall                  <= 1'b0;
                            wEbreak                 <= 1'b0;
                            oOrigPC                 <= 3'b000;
                            oRegWrite               <= 1'b0;
                            oMem2Reg                <= 3'b000;
                        end
                endcase

            end
        OPC_LOAD:
            begin
                wEbreak                 <= 1'b0;
                oCSRegWrite             <= 1'b0;
                oEcall                  <= 1'b0;
                oInvInstruction         <= 1'b0;
                oOrigAULA               <= 1'b0;
                oOrigBULA               <= 2'b01;
                oRegWrite               <= 1'b1;
                oMemWrite               <= 1'b0;
                oMemRead                <= 1'b1;
                oALUControl             <= OPADD;
                oMem2Reg                <= 3'b010;
                oOrigPC                 <= 3'b000;
`ifdef RV32IMF
                oFPALU2Reg              <= 1'b0;
                oFPALUControl           <= OPNULL;
                oFRegWrite              <= 1'b0;
                oOrigAFPALU             <= 1'b0;
                oFWriteData             <= 1'b0;
                oWrite2Mem              <= 1'b0;
                oFPstart                    <= 1'b0;
`endif
            end
        OPC_OPIMM:
            begin
                wEbreak                 <= 1'b0;
                oCSRegWrite             <= 1'b0;
                oEcall                  <= 1'b0;
                oInvInstruction         <= 1'b0;
                oOrigAULA               <= 2'b00;
                oOrigBULA               <= 2'b01;
                oRegWrite               <= 1'b1;
                oMemWrite               <= 1'b0;
                oMemRead                <= 1'b0;
                oMem2Reg                <= 3'b000;
                oOrigPC                 <= 3'b000;
`ifdef RV32IMF
                oFPALU2Reg              <= 1'b0;
                oFPALUControl           <= OPNULL;
                oFRegWrite              <= 1'b0;
                oOrigAFPALU             <= 1'b0;
                oFWriteData             <= 1'b0;
                oWrite2Mem              <= 1'b0;
                oFPstart                    <= 1'b0;
`endif
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
                            oInvInstruction         <= 1'b1;
                            oOrigAULA               <= 2'b00;
                            oOrigBULA               <= 2'b00;
                            oRegWrite               <= 1'b0;
                            oMemWrite               <= 1'b0;
                            oMemRead                <= 1'b0;
                            oALUControl             <= OPNULL;
                            oMem2Reg                <= 3'b000;
                            oOrigPC                 <= 3'b000;
`ifdef RV32IMF
                            oFPALU2Reg              <= 1'b0;
                            oFPALUControl           <= OPNULL;
                            oFRegWrite              <= 1'b0;
                            oOrigAFPALU             <= 1'b0;
                            oFWriteData             <= 1'b0;
                            oWrite2Mem              <= 1'b0;
                            oFPstart                    <= 1'b0;
`endif
                        end
                endcase
            end

        OPC_AUIPC:
            begin
                wEbreak                 <= 1'b0;
                oCSRegWrite             <= 1'b0;
                oEcall                  <= 1'b0;
                oInvInstruction         <= 1'b0;
                oOrigAULA               <= 2'b01;
                oOrigBULA               <= 2'b01;
                oRegWrite               <= 1'b1;
                oMemWrite               <= 1'b0;
                oMemRead                <= 1'b0;
                oALUControl             <= OPADD;
                oMem2Reg                <= 3'b000;
                oOrigPC                 <= 3'b000;
`ifdef RV32IMF
                oFPALU2Reg              <= 1'b0;
                oFPALUControl           <= OPNULL;
                oFRegWrite              <= 1'b0;
                oOrigAFPALU             <= 1'b0;
                oFWriteData             <= 1'b0;
                oWrite2Mem              <= 1'b0;
                oFPstart                    <= 1'b0;
`endif
            end

        OPC_STORE:
            begin
                wEbreak                 <= 1'b0;
                oCSRegWrite             <= 1'b0;
                oEcall                  <= 1'b0;
                oInvInstruction         <= 1'b0;
                oOrigAULA               <= 2'b00;
                oOrigBULA               <= 2'b01;
                oRegWrite               <= 1'b0;
                oMemWrite               <= 1'b1;
                oMemRead                <= 1'b0;
                oALUControl             <= OPADD;
                oMem2Reg                <= 3'b000;
                oOrigPC                 <= 3'b000;
`ifdef RV32IMF
                oFPALU2Reg              <= 1'b0;
                oFPALUControl           <= OPNULL;
                oFRegWrite              <= 1'b0;
                oOrigAFPALU             <= 1'b0;
                oFWriteData             <= 1'b0;
                oWrite2Mem              <= 1'b0;
                oFPstart                    <= 1'b0;
`endif
            end

        OPC_RTYPE:
            begin
                wEbreak                 <= 1'b0;
                oCSRegWrite             <= 1'b0;
                oEcall                  <= 1'b0;
                oInvInstruction         <= 1'b0;
                oOrigAULA               <= 2'b00;
                oOrigBULA               <= 2'b00;
                oRegWrite               <= 1'b1;
                oMemWrite               <= 1'b0;
                oMemRead                <= 1'b0;
                oMem2Reg                <= 3'b000;
                oOrigPC                 <= 3'b000;
`ifdef RV32IMF
                oFPALU2Reg              <= 1'b0;
                oFPALUControl           <= OPNULL;
                oFRegWrite              <= 1'b0;
                oOrigAFPALU             <= 1'b0;
                oFWriteData             <= 1'b0;
                oWrite2Mem              <= 1'b0;
                oFPstart                    <= 1'b0;
`endif
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
                        default: // instrucao invalida
                            begin
                                oInvInstruction         <= 1'b1;
                                oOrigAULA               <= 2'b00;
                                oOrigBULA               <= 2'b00;
                                oRegWrite               <= 1'b0;
                                oMemWrite               <= 1'b0;
                                oMemRead                <= 1'b0;
                                oALUControl             <= OPNULL;
                                oMem2Reg                <= 3'b000;
                                oOrigPC                 <= 3'b000;
`ifdef RV32IMF
                                oFPALU2Reg              <= 1'b0;
                                oFPALUControl           <= OPNULL;
                                oFRegWrite              <= 1'b0;
                                oOrigAFPALU             <= 1'b0;
                                oFWriteData             <= 1'b0;
                                oWrite2Mem              <= 1'b0;
                                oFPstart                    <= 1'b0;
`endif
                            end
                    endcase

`ifndef RV32I
                FUNCT7_MULDIV:
                    case (Funct3)
                        FUNCT3_MUL:         oALUControl <= OPMUL;
                        FUNCT3_MULH:        oALUControl <= OPMULH;
                        FUNCT3_MULHSU:      oALUControl <= OPMULHSU;
                        FUNCT3_MULHU:       oALUControl <= OPMULHU;
                        FUNCT3_DIV:         oALUControl <= OPDIV;
                        FUNCT3_DIVU:        oALUControl <= OPDIVU;
                        FUNCT3_REM:         oALUControl <= OPREM;
                        FUNCT3_REMU:        oALUControl <= OPREMU;
                        default: // instrucao invalida
                            begin
                                oInvInstruction         <= 1'b1;
                                oOrigAULA               <= 2'b00;
                                oOrigBULA               <= 2'b00;
                                oRegWrite               <= 1'b0;
                                oMemWrite               <= 1'b0;
                                oMemRead                <= 1'b0;
                                oALUControl             <= OPNULL;
                                oMem2Reg                <= 3'b000;
                                oOrigPC                 <= 3'b000;
`ifdef RV32IMF
                                oFPALU2Reg              <= 1'b0;
                                oFPALUControl           <= OPNULL;
                                oFRegWrite              <= 1'b0;
                                oOrigAFPALU             <= 1'b0;
                                oFWriteData             <= 1'b0;
                                oWrite2Mem              <= 1'b0;
                                oFPstart                    <= 1'b0;
`endif
                            end
                    endcase
`endif
                default: // instrucao invalida
                    begin
                        oInvInstruction         <= 1'b1;
                        oOrigAULA               <= 2'b00;
                        oOrigBULA               <= 2'b00;
                        oRegWrite               <= 1'b0;
                        oMemWrite               <= 1'b0;
                        oMemRead                <= 1'b0;
                        oALUControl             <= OPNULL;
                        oMem2Reg                <= 3'b000;
                        oOrigPC                 <= 3'b000;
`ifdef RV32IMF
                        oFPALU2Reg              <= 1'b0;
                        oFPALUControl           <= OPNULL;
                        oFRegWrite              <= 1'b0;
                        oOrigAFPALU             <= 1'b0;
                        oFWriteData             <= 1'b0;
                        oWrite2Mem              <= 1'b0;
                        oFPstart                    <= 1'b0;
`endif
                    end
            endcase
        end

        OPC_LUI:
            begin
                wEbreak                 <= 1'b0;
                oCSRegWrite             <= 1'b0;
                oEcall                  <= 1'b0;
                oInvInstruction         <= 1'b0;
                oOrigAULA               <= 2'b00;
                oOrigBULA               <= 2'b01;
                oRegWrite               <= 1'b1;
                oMemWrite               <= 1'b0;
                oMemRead                <= 1'b0;
                oALUControl             <= OPLUI;
                oMem2Reg                <= 3'b000;
                oOrigPC                 <= 3'b000;
`ifdef RV32IMF
                oFPALU2Reg              <= 1'b0;
                oFPALUControl           <= OPNULL;
                oFRegWrite              <= 1'b0;
                oOrigAFPALU             <= 1'b0;
                oFWriteData             <= 1'b0;
                oWrite2Mem              <= 1'b0;
                oFPstart                    <= 1'b0;
`endif
            end

        OPC_BRANCH:
            begin
                wEbreak                 <= 1'b0;
                oCSRegWrite             <= 1'b0;
                oEcall                  <= 1'b0;
                oInvInstruction         <= 1'b0;
                oOrigAULA               <= 2'b00;
                oOrigBULA               <= 2'b00;
                oRegWrite               <= 1'b0;
                oMemWrite               <= 1'b0;
                oMemRead                <= 1'b0;
                oALUControl             <= OPADD;
                oMem2Reg                <= 3'b000;
                oOrigPC                 <= 3'b001;
`ifdef RV32IMF
                oFPALU2Reg              <= 1'b0;
                oFPALUControl           <= OPNULL;
                oFRegWrite              <= 1'b0;
                oOrigAFPALU             <= 1'b0;
                oFWriteData             <= 1'b0;
                oWrite2Mem              <= 1'b0;
                oFPstart                    <= 1'b0;
`endif
            end

        OPC_JALR:
            begin
                wEbreak                 <= 1'b0;
                oCSRegWrite             <= 1'b0;
                oEcall                  <= 1'b0;
                oInvInstruction         <= 1'b0;
                oOrigAULA               <= 2'b00;
                oOrigBULA               <= 2'b00;
                oRegWrite               <= 1'b1;
                oMemWrite               <= 1'b0;
                oMemRead                <= 1'b0;
                oALUControl             <= OPADD;
                oMem2Reg                <= 3'b001;
                oOrigPC                 <= 3'b011;
`ifdef RV32IMF
                oFPALU2Reg              <= 1'b0;
                oFPALUControl           <= OPNULL;
                oFRegWrite              <= 1'b0;
                oOrigAFPALU             <= 1'b0;
                oFWriteData             <= 1'b0;
                oWrite2Mem              <= 1'b0;
                oFPstart                    <= 1'b0;
`endif
            end

        OPC_JAL:
            begin
                wEbreak                 <= 1'b0;
                oCSRegWrite             <= 1'b0;
                oEcall                  <= 1'b0;
                oInvInstruction         <= 1'b0;
                oOrigAULA               <= 2'b00;
                oOrigBULA               <= 2'b00;
                oRegWrite               <= 1'b1;
                oMemWrite               <= 1'b0;
                oMemRead                <= 1'b0;
                oALUControl             <= OPADD;
                oMem2Reg                <= 3'b001;
                oOrigPC                 <= 3'b010;
`ifdef RV32IMF
                oFPALU2Reg              <= 1'b0;
                oFPALUControl           <= OPNULL;
                oFRegWrite              <= 1'b0;
                oOrigAFPALU             <= 1'b0;
                oFWriteData             <= 1'b0;
                oWrite2Mem              <= 1'b0;
                oFPstart                    <= 1'b0;
`endif
            end

`ifdef RV32IMF
        OPC_FRTYPE: // OPCODE de todas as intruções tipo R ponto flutuante
            begin
                wEbreak                 <= 1'b0;
                oCSRegWrite             <= 1'b0;
                oEcall                  <= 1'b0;
                oInvInstruction         <= 1'b0;
                oOrigAULA               <= 1'b0;   // Importam as entradas da ULA?
                oOrigBULA               <= 1'b0;      // Importam as entradas da ULA?
                oMemWrite               <= 1'b0;   // Nao escreve na memoria
                oMemRead                <= 1'b0;   // Nao le da memoria
                oALUControl             <= OPNULL; // Nao realiza operacoes na ULA
                oMem2Reg                <= 3'b000;  // Nao importa o que sera escrito do mux mem2reg?
                oOrigPC                 <= 3'b000;  // PC+4
                oFWriteData             <= 1'b0;   // Instrucoes do tipo R sempre escrevem no banco de registradores a partir do resultado da FPALU
                oWrite2Mem              <= 1'b0;   // Instrucoes do tipo R nao escrevem na memoria
                oFPstart                    <= 1'b1;        // habilita a FPULA

                case(Funct7)
                    FUNCT7_FADD_S:
                        begin
                            oRegWrite               <= 1'b0;   // Nao habilita escrita em registrador de inteiros
                            oFPALU2Reg              <= 1'b0;   // Nao importa o que escreve em registrador de inteiros
                            oFPALUControl           <= FOPADD; // Realiza um fadd
                            oFRegWrite              <= 1'b1;   // Habilita escrita no registrador de float
                            oOrigAFPALU             <= 1'b1;   // Rs1 eh um float
                        end

                    FUNCT7_FSUB_S:
                        begin
                            oRegWrite               <= 1'b0;   // Nao habilita escrita em registrador de inteiros
                            oFPALU2Reg              <= 1'b0;   // Nao importa o que escreve em registrador de inteiros
                            oFPALUControl           <= FOPSUB; // Realiza um fsub
                            oFRegWrite              <= 1'b1;   // Habilita escrita no registrador de float
                            oOrigAFPALU             <= 1'b1;   // Rs1 eh um float
                        end

                    FUNCT7_FMUL_S:
                        begin
                            oRegWrite               <= 1'b0;   // Nao habilita escrita em registrador de inteiros
                            oFPALU2Reg              <= 1'b0;   // Nao importa o que escreve em registrador de inteiros
                            oFPALUControl           <= FOPMUL; // Realiza um fmul
                            oFRegWrite              <= 1'b1;   // Habilita escrita no registrador de float
                            oOrigAFPALU             <= 1'b1;   // Rs1 eh um float
                        end

                    FUNCT7_FDIV_S:
                        begin
                            oRegWrite               <= 1'b0;   // Nao habilita escrita em registrador de inteiros
                            oFPALU2Reg              <= 1'b0;   // Nao importa o que escreve em registrador de inteiros
                            oFPALUControl           <= FOPDIV; // Realiza um fdiv
                            oFRegWrite              <= 1'b1;   // Habilita escrita no registrador de float
                            oOrigAFPALU             <= 1'b1;   // Rs1 eh um float
                        end

                    FUNCT7_FSQRT_S: // OBS.: Rs2 nao importa?
                        begin
                            oRegWrite               <= 1'b0;   // Nao habilita escrita em registrador de inteiros
                            oFPALU2Reg              <= 1'b0;   // Nao importa o que escreve em registrador de inteiros
                            oFPALUControl           <= FOPSQRT; // Realiza um fsqrt
                            oFRegWrite              <= 1'b1;   // Habilita escrita no registrador de float
                            oOrigAFPALU             <= 1'b1;   // Rs1 eh um float
                        end

                    FUNCT7_FMV_S_X:
                        begin
                            oRegWrite               <= 1'b0;      // Nao habilita escrita em registrador de inteiros
                            oFPALU2Reg              <= 1'b0;      // Nao importa o que escreve em registrador de inteiros
                            oFPALUControl           <= FOPMV;     // Realiza um fmv.s.x
                            oFRegWrite              <= 1'b1;      // Habilita escrita no registrador de float
                            oOrigAFPALU             <= 1'b0;      // Rs1 eh um int
                        end

                    FUNCT7_FMV_X_S:
                        begin
                            oRegWrite               <= 1'b1;      // Habilita escrita em registrador de inteiros
                            oFPALU2Reg              <= 1'b1;      // Nao importa o que escreve em registrador de inteiros
                            oFPALUControl           <= FOPMV;     // Realiza um fmv.x.s
                            oFRegWrite              <= 1'b0;      // Desabilita escrita no registrador de float
                            oOrigAFPALU             <= 1'b1;      // Rs1 eh um float
                        end

                    FUNCT7_FSIGN_INJECT:
                        begin
                            oRegWrite               <= 1'b0;
                            oFPALU2Reg              <= 1'b0;
                            oFRegWrite              <= 1'b1;
                            oOrigAFPALU             <= 1'b1;
                            case (Funct3)
                                FUNCT3_FSGNJ_S:  oFPALUControl <= FOPSGNJ;
                                FUNCT3_FSGNJN_S: oFPALUControl <= FOPSGNJN;
                                FUNCT3_FSGNJX_S: oFPALUControl <= FOPSGNJX;
                                default: // instrucao invalida
                                    begin
                                        oInvInstruction         <= 1'b1;
                                        oOrigAULA               <= 1'b0;
                                        oOrigBULA               <= 1'b0;
                                        oRegWrite               <= 1'b0;
                                        oMemWrite               <= 1'b0;
                                        oMemRead                <= 1'b0;
                                        oALUControl             <= OPNULL;
                                        oMem2Reg                <= 3'b000;
                                        oOrigPC                 <= 3'b000;
                                        oFPALU2Reg              <= 1'b0;
                                        oFPALUControl           <= OPNULL;
                                        oFRegWrite              <= 1'b0;
                                        oOrigAFPALU             <= 1'b0;
                                        oFWriteData             <= 1'b0;
                                        oWrite2Mem              <= 1'b0;
                                    end
                            endcase
                        end

                    FUNCT7_MAX_MIN_S:
                        begin
                            oRegWrite               <= 1'b0;
                            oFPALU2Reg              <= 1'b0;
                            oFRegWrite              <= 1'b1;
                            oOrigAFPALU             <= 1'b1;
                            case (Funct3)
                                FUNCT3_FMAX_S: oFPALUControl <= FOPMAX;
                                FUNCT3_FMIN_S: oFPALUControl <= FOPMIN;
                                default: // instrucao invalida
                                    begin
                                        oInvInstruction         <= 1'b1;
                                        oOrigAULA               <= 1'b0;
                                        oOrigBULA               <= 1'b0;
                                        oRegWrite               <= 1'b0;
                                        oMemWrite               <= 1'b0;
                                        oMemRead                <= 1'b0;
                                        oALUControl             <= OPNULL;
                                        oMem2Reg                <= 3'b000;
                                        oOrigPC                 <= 3'b000;
                                        oFPALU2Reg              <= 1'b0;
                                        oFPALUControl           <= OPNULL;
                                        oFRegWrite              <= 1'b0;
                                        oOrigAFPALU             <= 1'b0;
                                        oFWriteData             <= 1'b0;
                                        oWrite2Mem              <= 1'b0;
                                    end
                            endcase
                        end

                    FUNCT7_FCOMPARE:
                        begin
                            oRegWrite               <= 1'b1;
                            oFPALU2Reg              <= 1'b1;
                            oFRegWrite              <= 1'b0;
                            oOrigAFPALU             <= 1'b1;
                            case (Funct3)
                                FUNCT3_FEQ_S: oFPALUControl <= FOPCEQ;
                                FUNCT3_FLE_S: oFPALUControl <= FOPCLE;
                                FUNCT3_FLT_S: oFPALUControl <= FOPCLT;
                                default: // instrucao invalida
                                    begin
                                        oInvInstruction         <= 1'b1;
                                        oOrigAULA               <= 1'b0;
                                        oOrigBULA               <= 1'b0;
                                        oRegWrite               <= 1'b0;
                                        oMemWrite               <= 1'b0;
                                        oMemRead                <= 1'b0;
                                        oALUControl             <= OPNULL;
                                        oMem2Reg                <= 3'b000;
                                        oOrigPC                 <= 3'b000;
                                        oFPALU2Reg              <= 1'b0;
                                        oFPALUControl           <= OPNULL;
                                        oFRegWrite              <= 1'b0;
                                        oOrigAFPALU             <= 1'b0;
                                        oFWriteData             <= 1'b0;
                                        oWrite2Mem              <= 1'b0;
                                    end
                            endcase
                        end

                    FUNCT7_FCVT_S_W_WU:
                        begin
                            oRegWrite               <= 1'b0;
                            oFPALU2Reg              <= 1'b0;
                            oFRegWrite              <= 1'b1;
                            oOrigAFPALU             <= 1'b0;
                            case (Rs2)
                                RS2_FCVT_S_W:  oFPALUControl <= FOPCVTSW;
                                RS2_FCVT_S_WU: oFPALUControl <= FOPCVTSWU;
                                default: // instrucao invalida
                                    begin
                                        oInvInstruction         <= 1'b1;
                                        oOrigAULA               <= 1'b0;
                                        oOrigBULA               <= 1'b0;
                                        oRegWrite               <= 1'b0;
                                        oMemWrite               <= 1'b0;
                                        oMemRead                <= 1'b0;
                                        oALUControl             <= OPNULL;
                                        oMem2Reg                <= 3'b000;
                                        oOrigPC                 <= 3'b000;
                                        oFPALU2Reg              <= 1'b0;
                                        oFPALUControl           <= OPNULL;
                                        oFRegWrite              <= 1'b0;
                                        oOrigAFPALU             <= 1'b0;
                                        oFWriteData             <= 1'b0;
                                        oWrite2Mem              <= 1'b0;
                                    end
                            endcase
                        end

                    FUNCT7_FCVT_W_WU_S:
                        begin
                            oRegWrite               <= 1'b1;
                            oFPALU2Reg              <= 1'b1;
                            oFRegWrite              <= 1'b0;
                            oOrigAFPALU             <= 1'b1;
                            case (Rs2)
                                RS2_FCVT_W_S:  oFPALUControl <= FOPCVTWS;
                                RS2_FCVT_WU_S: oFPALUControl <= FOPCVTWUS;
                                default: // instrucao invalida
                                    begin
                                        oInvInstruction         <= 1'b1;
                                        oOrigAULA               <= 1'b0;
                                        oOrigBULA               <= 1'b0;
                                        oRegWrite               <= 1'b0;
                                        oMemWrite               <= 1'b0;
                                        oMemRead                <= 1'b0;
                                        oALUControl             <= OPNULL;
                                        oMem2Reg                <= 3'b000;
                                        oOrigPC                 <= 3'b000;
                                        oFPALU2Reg              <= 1'b0;
                                        oFPALUControl           <= OPNULL;
                                        oFRegWrite              <= 1'b0;
                                        oOrigAFPALU             <= 1'b0;
                                        oFWriteData             <= 1'b0;
                                        oWrite2Mem              <= 1'b0;
                                    end
                            endcase
                        end

                    default: // instrucao invalida
                      begin
                            oInvInstruction         <= 1'b1;
                            oOrigAULA               <= 1'b0;
                            oOrigBULA               <= 1'b0;
                            oRegWrite               <= 1'b0;
                            oMemWrite               <= 1'b0;
                            oMemRead                <= 1'b0;
                            oALUControl             <= OPNULL;
                            oMem2Reg                <= 3'b000;
                            oOrigPC                 <= 3'b000;
                            oFPALU2Reg              <= 1'b0;
                            oFPALUControl           <= OPNULL;
                            oFRegWrite              <= 1'b0;
                            oOrigAFPALU             <= 1'b0;
                            oFWriteData             <= 1'b0;
                            oWrite2Mem              <= 1'b0;
                            oFPstart                    <= 1'b0;
                      end

                endcase
            end

        OPC_FLOAD: //OPCODE do FLW
            begin
                // Sinais int
                wEbreak                 <= 1'b0;
                oCSRegWrite             <= 1'b0;
                oEcall                  <= 1'b0;
                oInvInstruction         <= 1'b0;
                oOrigAULA               <= 1'b0;
                oOrigBULA               <= 1'b1;
                oRegWrite               <= 1'b0;
                oMemWrite               <= 1'b0;
                oMemRead                <= 1'b1;
                oALUControl             <= OPADD;
                oMem2Reg                <= 3'b010;
                oOrigPC                 <= 3'b000;
                // Sinais float
                oFPALU2Reg              <= 1'b0;
                oFPALUControl           <= OPNULL;
                oFRegWrite              <= 1'b1;
                oOrigAFPALU             <= 1'b0;
                oFWriteData             <= 1'b1;
                oWrite2Mem              <= 1'b0;
                oFPstart                    <= 1'b0;
            end

        OPC_FSTORE:
            begin
                // Sinais int
                wEbreak                 <= 1'b0;
                oCSRegWrite             <= 1'b0;
                oEcall                  <= 1'b0;
                oInvInstruction         <= 1'b0;
                oOrigAULA               <= 1'b0;
                oOrigBULA               <= 1'b1;
                oRegWrite               <= 1'b0;
                oMemWrite               <= 1'b1;
                oMemRead                <= 1'b0;
                oALUControl             <= OPADD;
                oMem2Reg                <= 3'b000;
                oOrigPC                 <= 3'b000;
                // Sinais float
                oFPALU2Reg              <= 1'b0;
                oFPALUControl           <= OPNULL;
                oFRegWrite              <= 1'b0;
                oOrigAFPALU             <= 1'b0;
                oFWriteData             <= 1'b0;
                oWrite2Mem              <= 1'b1;
                oFPstart                    <= 1'b0;
            end

`endif

        default: // instrucao invalida
        begin
                wEbreak                 <= 1'b0;
                oCSRegWrite             <= 1'b0;
                oInvInstruction         <= 1'b1;
                oEcall                  <= 1'b0;
                oOrigAULA               <= 2'b00;
                oOrigBULA               <= 2'b00;
                oRegWrite               <= 1'b0;
                oMemWrite               <= 1'b0;
                oMemRead                <= 1'b0;
                oALUControl             <= OPNULL;
                oMem2Reg                <= 3'b000;
                oOrigPC                 <= 3'b000;
`ifdef RV32IMF
                oFPALU2Reg              <= 1'b0;
                oFPALUControl           <= OPNULL;
                oFRegWrite              <= 1'b0;
                oOrigAFPALU             <= 1'b0;
                oFWriteData             <= 1'b0;
                oWrite2Mem              <= 1'b0;
                oFPstart                    <= 1'b0;
`endif
        end

    endcase

endmodule
