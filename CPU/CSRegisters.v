`ifndef PARAM
	`include "Parametros.v"
`endif


module CSRegisters (
    input wire 			iCLK, iRST, iRegWrite,iRegWriteSimu,
    input wire  [11:0] 	iReadRegister, iWriteRegister,
    input wire  [31:0] 	iWriteData, 
	 input wire  [31:0]  iWriteDataUEPC, iWriteDataUCAUSE, iWriteDataUTVAL,// registradores especiais precisam de acesso simultaneo
    output wire [31:0] 	oReadData,	
	 output wire [31:0]  oReadDataUTVEC, oReadDataUEPC, oReadDataUSTATUS,oReadDataUTVAL,// registradores especiais precisam de acesso simultaneo

    input wire  [4:0] 	iVGASelect, iRegDispSelect,
    output reg  [31:0] 	oVGARead, oRegDisp
    );
	 
	 
//  ustatus(0), fflags(1), frm(2), fcsr(3), uie(4), utvect(5), uscratch(64), uepc(65), ucause(66), utval(67), uip(68).
reg [31:0] registers[10:0]; // Registradores CRS de 0 até 10, seguindo a ordem acima

wire[3:0] realReadRegister, realWriteRegister;
reg [5:0] i;
 
initial
	begin // zera o banco de registradores
		for (i = 0; i <= 10; i = i + 1'b1)
			registers[i] = 32'b0;
		
	end

// corrige os umeros dos registradores de 64 até 68
// CASES DEVEM SER MODIFICADOS CASO NOVOS CRS SEJAM ADICIONADOS 


always @(*)
begin
	case(iReadRegister) 
		
		11'd64:
			begin
				realReadRegister <= 4'd6;
			end
		11'd65:
			begin
				realReadRegister <= 4'd7;
			end
		11'd66:
			begin
				realReadRegister <= 4'd8;
			end
		11'd67:
			begin
				realReadRegister <= 4'd9;
			end
		11'd68:
			begin
				realReadRegister <= 4'd10;
			end
		default:
			begin
				realReadRegister <= iReadRegister[3:0];
			end
	endcase

	////////////////////////////////////////////////////////////

	case(iWriteRegister)
		
		11'd64:
			begin
				realWriteRegister <= 4'd6;
			end
		11'd65:
			begin
				realWriteRegister <= 4'd7;
			end
		11'd66:
			begin
				realWriteRegister <= 4'd8;
			end
		11'd67:
			begin
				realWriteRegister <= 4'd9;
			end
		11'd68:
			begin
				realWriteRegister <= 4'd10;
			end
		default:
			begin
				realWriteRegister <= iWriteRegister[3:0];
			end
	endcase



end

///////////////////////////////////////////////////////////////////
// CASES DEVEM SER MODIFICADOS CASO NOVOS CRS SEJAM ADICIONADOS 
	
assign oReadDataUSTATUS =	registers[0];	// leitura simultanea em ustatus, utvec, uepc
assign oReadDataUTVEC  	=	registers[5]; 
assign oReadDataUEPC   	=	registers[7];
assign oReadDataUTVAL   =  registers[9];
	
assign oReadData =	registers[realReadRegister];

assign oRegDisp 	=	registers[iRegDispSelect];
assign oVGARead 	=	registers[iVGASelect];


`ifdef PIPELINE
    always @(negedge iCLK or posedge iRST)
`else
    always @(posedge iCLK or posedge iRST)
`endif
begin
    if (iRST)
    begin // reseta o banco de registradores e pilha
        for (i = 0; i <= 10; i = i + 1'b1)
            registers[i] <= 32'h00000000;
    end
    else
		 begin
			i<=6'bx; // para não dar warning
			
					
			if(iRegWriteSimu != 1'b0)
				begin
					
						registers[7] <= iWriteDataUEPC;
					
						registers[8] <= iWriteDataUCAUSE;
					
						registers[9] <= iWriteDataUTVAL;
				end		
			else if(iRegWrite != 1'b0)
				begin
					registers[realWriteRegister] <= iWriteData;
				end
		 end
end


endmodule

