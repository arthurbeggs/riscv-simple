`ifndef PARAM
	`include "../Parametros.v"
`endif

module STOPWATCH_Interface(
    input         iCLK_50, iCLK,
    //  Barramento de IO
    input         wReadEnable, wWriteEnable,
    input  			[3:0]  wByteEnable,
    input  			[31:0] wAddress, wWriteData,
    output logic 	[31:0] wReadData
);

reg [31:0] time_count;

wire clk;
logic reset_flag;

Stopwatch_divider_clk divider(
	.clk(iCLK_50),
	.new_freq(clk)
);


always @(posedge clk or posedge reset_flag) begin
	if (reset_flag)
			time_count <= 32'b0;
	else
		time_count <= time_count + 1'b1;
end


always @ ( posedge iCLK ) begin
	if (wWriteEnable)
		if (wAddress == STOPWATCH_ADDRESS)
			reset_flag <= 1'b1;
		else
			reset_flag <= 1'b0;
	else	
		reset_flag <= 1'b0;
end


always @(*) begin
	if(wReadEnable)
			if (wAddress == STOPWATCH_ADDRESS)
				wReadData <= time_count;
			else 
				wReadData <= 32'hzzzzzzzz;	
	else 
		wReadData <= 32'hzzzzzzzz;
end

endmodule
