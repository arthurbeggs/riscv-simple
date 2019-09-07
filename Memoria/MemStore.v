`ifndef PARAM
	`include "../Parametros.v"
`endif

/* Controlador da memoria de escrita */
/* define a partir do funct3 qual a forma de acesso a memoria sb, sh, sw e ByteEnable */

module MemStore(
	input [1:0] 			iAlignment,
	input [2:0] 			iFunct3,
	input [31:0] 			iData,
	output logic [31:0]  oData,
	output logic [3:0]   oByteEnable

);



always @(*) begin
	case (iFunct3)
		FUNCT3_SW:   oData <= iData;
		FUNCT3_SH:   oData <= {iData[15:0], iData[15:0]};
		FUNCT3_SB:   oData <= {iData[7:0], iData[7:0], iData[7:0], iData[7:0]};
		default: oData <= iData;
	endcase
end


always @(*) begin
	case (iFunct3)
		FUNCT3_SW: // Word
			begin
				case (iAlignment)
					2'b00:   oByteEnable <= 4'b1111; // 4-aligned
					default: oByteEnable <= 4'b0000; // Not aligned
				endcase
			end
		FUNCT3_SH: // Halfword
			begin
				case (iAlignment)
					2'b00:   oByteEnable <= 4'b0011; // 2-aligned (lower)
					2'b10:   oByteEnable <= 4'b1100; // 2-aligned (upper)
					default: oByteEnable <= 4'b0000; // Not aligned
				endcase
			end
		FUNCT3_SB: // Byte
			begin
				case (iAlignment)
					2'b00: oByteEnable <= 4'b0001;
					2'b01: oByteEnable <= 4'b0010;
					2'b10: oByteEnable <= 4'b0100;
					2'b11: oByteEnable <= 4'b1000;
				endcase
			end
		default:
			oByteEnable = 4'b0000;
	endcase
end

endmodule
