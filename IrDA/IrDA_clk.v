module IrDA_clk(
	clk,
	new_freq
);

input clk;
output new_freq;

reg [9:0] count;
reg new_freq;


always @(posedge clk )
begin
	if (new_freq && count == 10'd760)
		begin
			count <= 10'd0;
			new_freq <= !new_freq;
		end
		
	else if(!new_freq && count == 10'd760) 
		begin
			count <= 10'd0;
			new_freq <= !new_freq;
		end
	else
		begin
			count <= count + 1;
		end
end




endmodule
			
