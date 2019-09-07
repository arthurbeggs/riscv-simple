module tecladoPS2(
	iPS2clk,
	iPS2data,
	oReady,
	oScanCode
);

input iPS2clk;
input iPS2data;
output oReady;
output reg [7:0] oScanCode;

reg [3:0] counter;

assign oReady = counter == 4'd10;

initial
begin
	oScanCode <= 8'b0;
	counter <= 4'b0;
end

always @(negedge iPS2clk)
begin
	if (counter == 4'd0)
		counter <= 4'd1;
	else if (counter == 4'd9)
		counter <= counter + 4'd1;
	else if (counter == 4'd10)
		counter <= 4'd0;
	else
	begin
		counter <= counter + 4'd1;
		oScanCode <= {iPS2data, oScanCode[7:1]};
	end
end

endmodule
