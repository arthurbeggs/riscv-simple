/* Monoestável para ser usado com o congelamento do clock */
module mono(
    input clock50,
    input enable,
    output reg stop,
    input rst
);

integer contador;

initial
    begin
        stop      <= 1'b0;
        contador  <= 0;
    end

always @(posedge clock50)
	begin
		if(rst)
            begin
                stop     <= 1'b0;
                contador <= 0;
            end
		else
			if(enable)
				if(contador == 500000000)  //10 segundos
					begin
						stop		<= 1'b1;    // emite uma borda de subida
						contador	<= 0;
					end
				else
					begin
                 stop		<= 1'b0;
                 contador	<= contador+1;
					end
			else
				begin
			      stop			<= 1'b0;
					contador		<= 0;
				end
			
	end

endmodule
