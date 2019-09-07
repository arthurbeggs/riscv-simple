module Stopwatch_divider_clk(
	clk,
	new_freq
);

input clk;
output new_freq;

reg [15:0] count;
reg new_freq;


always @(posedge clk )
begin
	if (count == 16'd25000)
		begin
			count <= 16'd0;
			new_freq <= !new_freq;
		end
	
	else
		begin
			count <= count + 1'b1;
		end
end




endmodule
			
