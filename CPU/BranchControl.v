`ifndef PARAM
	`include "../Parametros.v"
`endif

/* Avaliador dos Branches */

module BranchControl (
    input  		  [ 2:0]	iFunct3,
    input signed [31:0] iA,
    input signed [31:0] iB,
    output 					oBranch
);


always @(*)
	case (iFunct3)
		FUNCT3_BEQ: 
				oBranch <= iA == iB ? ON : OFF;

		FUNCT3_BNE: 
				oBranch <= iA != iB ? ON : OFF;				

		FUNCT3_BLT: 
				oBranch <= iA < iB ? ON : OFF;

		FUNCT3_BGE: 
				oBranch <= iA >= iB ? ON : OFF;
				
		FUNCT3_BLTU: 
				oBranch <= $unsigned(iA) < $unsigned(iB) ? ON : OFF;

		FUNCT3_BGEU: 
				oBranch <= $unsigned(iA) >= $unsigned(iB) ? ON : OFF;

	   default: 
				oBranch <= OFF;							
	endcase

endmodule
