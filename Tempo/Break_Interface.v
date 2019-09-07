`ifndef PARAM
	`include "../Parametros.v"
`endif

module Break_Interface(
    input         iCLK_50,
    input         iCLK,
	 input 			iEbreak,
	 input	[3:0]	iKEY,
    input         Reset,
    output logic  oBreak,
	 input  [31:0]	iPC,
    //  Barramento de IO
    input         wReadEnable, wWriteEnable,
    input  [3:0]  wByteEnable,
    input  [31:0] wAddress, wWriteData,
    output logic [31:0] wReadData
);


wire [31:0] Break_Point0;  // Poderia usar um vetor

breaker brk0 (.result(Break_Point0));

		
always @(*) begin		// Leitura para conferir Break Point. A escrita no Break Point é só pelo In-System
	if (wReadEnable)
		if(wAddress == BREAK_ADDRESS)
			wReadData <= Break_Point0; 
		else
			wReadData <= 32'bzzzzzzzz;
	else
		wReadData <= 32'bzzzzzzzz;
end

// Precisa ser no negedge quando o PC já estiver estável e a instrução não executada
always @ ( negedge iCLK or posedge Reset or negedge iKEY[2] ) begin		// Acionamento dos break points	
	if (Reset || ~iKEY[2])
		oBreak <= 1'b0;
	else
		if ( iPC == Break_Point0 || iEbreak)
			oBreak <= 1'b1;
		else
			oBreak <= 1'b0;
end


endmodule
