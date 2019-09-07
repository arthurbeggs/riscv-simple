`ifndef PARAM
	`include "../Parametros.v"
`endif


module LFSR_interface(
	 input         iCLK_50,
	 input 			iCLK,
    //  Barramento de IO
    input         wReadEnable, wWriteEnable,
    input  			[3:0]  wByteEnable,
    input  			[31:0] wAddress, wWriteData,
    output logic 	[31:0] wReadData
);

wire [31:0] out;

LFSR_word lfsr(
	.out(out),
	.clk(iCLK_50)
);
	
always @(*)
	if(wReadEnable)
		if(wAddress == LFSR_ADDRESS)
			wReadData <= out;
		else	
			wReadData <= 32'hzzzzzzzz;
	else	
		wReadData <= 32'hzzzzzzzz;
		
endmodule
