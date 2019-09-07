module ExceptionControl (
    
	 
	 input wire iExceptionEnabled,
	 input wire iExInstrIllegal,
	 input wire iExEnviromentCall,
	 
	 input wire [31:0] iRegReadUTVAL,
	 
	 `ifdef MULTICICLO
		input 	wire [5: 0] iCState,
	 `endif
	 input wire [31:0] iInstr,
	 input wire [31:0] iPC,
	 input wire [31:0] iALUresult,
	 
	 
	 output wire oExRegWrite,
	 output wire oExSetPcToUtvec,

	 
	 
	 output wire [31:0] oExUEPC,
	 output wire [31:0] oExUCAUSE,
	 output wire [31:0] oExUTVAL
	 
	 
    );

wire [ 2:0] Funct3		= iInstr[14:12];
wire [ 6:0] Opcode     = iInstr[ 6: 0];

	 
always @(*)
begin



if(iExceptionEnabled)
	begin
	
	// instrução desalinhada 

		if((iPC[1:0] != 2'b00)
		`ifdef MULTICICLO
		
		&& iCState == ST_DECODE // é o estado que vai determinar o pc mais 4 para poder dar reset na maquina de estados
		
		
		`endif
		)
			begin
		
				oExSetPcToUtvec <= 1'b1;
				oExRegWrite <= 1'b1;
				oExUEPC <= iPC;
				oExUCAUSE <= 32'd0;
				oExUTVAL <= iPC;
				

		
				
			end
			
		// instrução fora do .text	
			
		else if((iPC<BEGINNING_TEXT || iPC>END_TEXT)
		`ifdef MULTICICLO
		
		&& iCState == ST_DECODE
		
		`endif
		)
			begin
		
				oExSetPcToUtvec <= 1'b1;
				oExRegWrite <= 1'b1;
				oExUEPC <= iPC;
				oExUCAUSE <= 32'd1;
				oExUTVAL <= iPC;
				

		
		
			end
			
			
		// instrução inválida	
		else if((iExInstrIllegal && iPC[1:0] == 2'b00 && (iPC>=BEGINNING_TEXT && iPC<=END_TEXT))
		`ifdef MULTICICLO
		
		`endif
		)
			begin
		
				oExSetPcToUtvec <= 1'b1;
				oExRegWrite <= 1'b1;
				oExUEPC <= iPC;
				oExUCAUSE <= 32'd2;
				oExUTVAL <= iInstr;
				

		
		
			end
			
		// LOAD desalinhado	
			
		else if(((Opcode == OPC_LOAD) && ((Funct3 == FUNCT3_LW  && iALUresult[1:0]   != 2'b00)
                  || (Funct3 == FUNCT3_LH  && iALUresult[0] != 1'b0) 
                  || (Funct3 == FUNCT3_LHU && iALUresult[0] != 1'b0)))
		`ifdef MULTICICLO
		
		&& (iCState == ST_LW || iCState == ST_SW || iCState == ST_FLW || iCState == ST_FSW) // estados após calculo de imediato da ula
		
		
		`endif
		)
			begin
		
				oExSetPcToUtvec <= 1'b1;
				oExRegWrite <= 1'b1;
				oExUEPC <= iPC;
				oExUCAUSE <= 32'd4;
				oExUTVAL <= iALUresult;
				

		
		
			end
			
		// load fora do mmio ou .data	
		else if( ((Opcode == OPC_LOAD) && ~((iALUresult >= BEGINNING_DATA && iALUresult <= END_DATA) || (iALUresult >= BEGINNING_IODEVICES)))
		`ifdef MULTICICLO
		
		&& (iCState == ST_LW || iCState == ST_SW || iCState == ST_FLW || iCState == ST_FSW)
		
		
		`endif
		)
			begin
		
				oExSetPcToUtvec <= 1'b1;
				oExRegWrite <= 1'b1;
				oExUEPC <= iPC;
				oExUCAUSE <= 32'd5;
				oExUTVAL <= iALUresult;
				

		
		
			end
			
			// store desalinhado
		else if(((Opcode == OPC_STORE) && ((Funct3 == FUNCT3_SW && iALUresult[1:0]   != 2'b00)
                 || (Funct3 == FUNCT3_SH && iALUresult[0] != 1'b0)))
					  
		`ifdef MULTICICLO
		
		
		&& (iCState == ST_LW || iCState == ST_SW || iCState == ST_FLW || iCState == ST_FSW)
		
		
		`endif
		)
			begin
		
				oExSetPcToUtvec <= 1'b1;
				oExRegWrite <= 1'b1;
				oExUEPC <= iPC;
				oExUCAUSE <= 32'd6;
				oExUTVAL <= iALUresult;
				

		
		
			end
			
			// store fora de mmio ou .data
		else if(((Opcode == OPC_STORE) && ~((iALUresult >= BEGINNING_DATA && iALUresult <= END_DATA) || (iALUresult >= BEGINNING_IODEVICES)))
		`ifdef MULTICICLO
		
		
		&& (iCState == ST_LW || iCState == ST_SW || iCState == ST_FLW || iCState == ST_FSW)
		
		`endif
		)
			begin
		
				oExSetPcToUtvec <= 1'b1;
				oExRegWrite <= 1'b1;
				oExUEPC <= iPC;
				oExUCAUSE <= 32'd7;
				oExUTVAL <= iALUresult;
				

		
		
			end
		else if(iExEnviromentCall)
			begin
		
			
		
			oExSetPcToUtvec <= 1'b0;
			oExRegWrite <= 1'b1;
			oExUEPC <= iPC;
			oExUCAUSE <= 32'd8;
			oExUTVAL <= iRegReadUTVAL;
			

		
			end
		else
			begin 
			
			oExSetPcToUtvec <= 1'b0;
			oExRegWrite <= 1'b0;
			oExUEPC <= ZERO;
			oExUCAUSE <= ZERO;
			oExUTVAL <= ZERO;
			

		
			end
	end
	
else if(iExEnviromentCall)
		begin
			oExSetPcToUtvec <= 1'b0; // ecall já é setado no OrigPC
			oExRegWrite <= 1'b1;
			oExUEPC <= iPC;
			oExUCAUSE <= 32'd8;
			oExUTVAL <= iRegReadUTVAL;
			
			
		end
else
	begin
		
		oExSetPcToUtvec <= 1'b0;
		oExRegWrite <= 1'b0;
		oExUEPC <= ZERO;
		oExUCAUSE <= ZERO;
		oExUTVAL <= ZERO;
		

		
	end

end
	 
	 
endmodule

