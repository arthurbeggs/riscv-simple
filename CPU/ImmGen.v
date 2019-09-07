`ifndef PARAM
	`include "../Parametros.v"
`endif

/* Unidade de geração do imediato */

module ImmGen (
    input  		  [31:0] iInstrucao,
    output logic [31:0] oImm
);


always @ (*)
    case (iInstrucao[6:0])
        OPC_LOAD,
`ifdef RV32IMF
		  OPC_FLOAD,
`endif
        OPC_OPIMM,
        OPC_JALR:
            oImm <= {{20{iInstrucao[31]}}, iInstrucao[31:20]};

`ifdef RV32IMF
		 OPC_FSTORE,
`endif
        OPC_STORE:
            oImm <= {{20{iInstrucao[31]}}, iInstrucao[31:25], iInstrucao[11:7]};

        OPC_BRANCH:
            oImm <= {{20{iInstrucao[31]}}, iInstrucao[7], iInstrucao[30:25], iInstrucao[11:8], 1'b0};

        OPC_AUIPC,
        OPC_LUI:
            oImm <= {iInstrucao[31:12], 12'b0};

        OPC_JAL:
            oImm <= {{12{iInstrucao[31]}}, iInstrucao[19:12], iInstrucao[20], iInstrucao[30:21], 1'b0};
				
		  OPC_SYSTEM:
				begin
					case(iInstrucao[14:12]) // funct 3
						FUNCT3_CSRRWI:
							oImm <= {27'b0, iInstrucao[19:15]};
						FUNCT3_CSRRSI:
							oImm <= {27'b0, iInstrucao[19:15]};
						FUNCT3_CSRRCI:
							oImm <= ~{27'b0, iInstrucao[19:15]};
						default:
							oImm <= ZERO;	
					endcase
				end
				
        default:
            oImm <= ZERO;
    endcase


endmodule
