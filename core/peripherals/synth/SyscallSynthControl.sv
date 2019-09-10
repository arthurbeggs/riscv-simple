module SyscallSynthControl(
	input MemWrite,
	input [31:0] wMemAddress,
	input [31:0] wMemWriteData,
	input CLK,
	input iSampleClock,
	output oSynthEnable,
	output oSynthMelody,
	output [7:0] oSynth,
	output [6:0] oSynthVolume,
	output [3:0] oSynthInst
);

wire [31:0] iData;						// Dados da word que contem a nota a ser tocada
reg [6:0] ConversionMilliseconds;	// Conversor de clock para milisegundos em funcao de AUD_DACLRCK
reg regPlay, regRead;					// Registradores para controle de Leitura e Sinteze da nota
reg Allocated;								// Registrador true para nota alocada, false para nota nao alocada


reg [31:0] counter [0:7];				// Contador para cada canal
reg occupied [0:7];						// Registrador true para canal ocupado e false para canal nao ocupado
reg [6:0] pitch [0:7];					// Registrador que guarda o pitch da nota alocada no canal
reg melody [0:7];							// Registrador que guarda se a nota = melodia (blocante)

initial
	begin
	iData <= 32'b0;
	oSynth <= 8'b0;
	oSynthVolume <= 7'b0;
	oSynthInst <= 4'b0;
	regPlay <= 1'b0;
	regRead <= 1'b0;
//	ConversionMilliseconds <= 6'd96;		//48  777777777777777777777????????????????????????
	ConversionMilliseconds <= 7'd48;		//48  777777777777777777777????????????????????????
	occupied[0]	<= 1'b0;
	occupied[1]	<= 1'b0;
	occupied[2]	<= 1'b0;
	occupied[3]	<= 1'b0;
	occupied[4]	<= 1'b0;
	occupied[5]	<= 1'b0;
	occupied[6]	<= 1'b0;
	occupied[7]	<= 1'b0;
	
	melody[0]	<= 1'b0;
	melody[1]	<= 1'b0;
	melody[2]	<= 1'b0;
	melody[3]	<= 1'b0;
	melody[4]	<= 1'b0;
	melody[5]	<= 1'b0;
	melody[6]	<= 1'b0;
	melody[7]	<= 1'b0;
	end

assign oSynthEnable = (regPlay == regRead);
assign oSynthMelody = (melody[0] || melody[1] || melody[2] || melody[3] || melody[4] || melody[5] || melody[6] || melody[7]);

always @(posedge CLK) begin
/*	if (MemWrite) begin
		case (wMemAddress)
			NOTE_SYSCALL_ADDRESS:
				begin
				iData <= wMemWriteData;
				regRead <= ~regRead;
				end
		endcase
	end */
if (MemWrite && (wMemAddress==NOTE_SYSCALL_ADDRESS))
			begin
				iData <= wMemWriteData;
				regRead <= ~regRead;
			end
	
end


always @(posedge iSampleClock) begin
	if (regPlay ^ regRead) begin
		Allocated <= 1'b0;
		if (occupied[0] == 1'b0 && Allocated == 1'b0) begin
			occupied[0] <= 1'b1;
			pitch[0] <= iData[19:13];
			counter[0] <= (iData[12:0] * ConversionMilliseconds);
			melody[0] <= iData[31];
			if (iData[26:20] == 7'b0) begin
				oSynth <= {iData[19:13], 1'b0};
			end
			else begin
				oSynth <= {iData[19:13], 1'b1};
			end
			oSynthVolume <= iData[26:20];
			oSynthInst <= iData[30:27];
			Allocated <= 1'b1;
			regPlay <= ~regPlay;
		end
		else begin
			if (occupied[1] == 1'b0 && Allocated == 1'b0) begin
				occupied[1] <= 1'b1;
				pitch[1] <= iData[19:13];
				counter[1] <= (iData[12:0] * ConversionMilliseconds);
				melody[1] <= iData[31];
				if (iData[26:20] == 7'b0) begin
					oSynth <= {iData[19:13], 1'b0};
				end
				else begin
					oSynth <= {iData[19:13], 1'b1};
				end
				oSynthVolume <= iData[26:20];
				oSynthInst <= iData[30:27];
				Allocated <= 1'b1;
				regPlay <= ~regPlay;
			end
			else begin
				if (occupied[2] == 1'b0 && Allocated == 1'b0) begin
					occupied[2] <= 1'b1;
					pitch[2] <= iData[19:13];
					counter[2] <= (iData[12:0] * ConversionMilliseconds);
					melody[2] <= iData[31];
					if (iData[26:20] == 7'b0) begin
						oSynth <= {iData[19:13], 1'b0};
					end
					else begin
						oSynth <= {iData[19:13], 1'b1};
					end
					oSynthVolume <= iData[26:20];
					oSynthInst <= iData[30:27];
					Allocated <= 1'b1;
					regPlay <= ~regPlay;
				end
				else begin
					if (occupied[3] == 1'b0 && Allocated == 1'b0) begin
						occupied[3] <= 1'b1;
						pitch[3] <= iData[19:13];
						counter[3] <= (iData[12:0] * ConversionMilliseconds);
						melody[3] <= iData[31];
						if (iData[26:20] == 7'b0) begin
							oSynth <= {iData[19:13], 1'b0};
						end
						else begin
							oSynth <= {iData[19:13], 1'b1};
						end
						oSynthVolume <= iData[26:20];
						oSynthInst <= iData[30:27];
						Allocated <= 1'b1;
						regPlay <= ~regPlay;
					end
					else begin
						if (occupied[4] == 1'b0 && Allocated == 1'b0) begin
							occupied[4] <= 1'b1;
							pitch[4] <= iData[19:13];
							counter[4] <= (iData[12:0] * ConversionMilliseconds);
							melody[4] <= iData[31];
							if (iData[26:20] == 7'b0) begin
								oSynth <= {iData[19:13], 1'b0};
							end
							else begin
								oSynth <= {iData[19:13], 1'b1};
							end
							oSynthVolume <= iData[26:20];
							oSynthInst <= iData[30:27];
							Allocated <= 1'b1;
							regPlay <= ~regPlay;
						end
						else begin
							if (occupied[5] == 1'b0 && Allocated == 1'b0) begin
								occupied[5] <= 1'b1;
								pitch[5] <= iData[19:13];
								counter[5] <= (iData[12:0] * ConversionMilliseconds);
								melody[5] <= iData[31];
								if (iData[26:20] == 7'b0) begin
									oSynth <= {iData[19:13], 1'b0};
								end
								else begin
									oSynth <= {iData[19:13], 1'b1};
								end
								oSynthVolume <= iData[26:20];
								oSynthInst <= iData[30:27];
								Allocated <= 1'b1;
								regPlay <= ~regPlay;
							end
							else begin
								if (occupied[6] == 1'b0 && Allocated == 1'b0) begin
									occupied[6] <= 1'b1;
									pitch[6] <= iData[19:13];
									counter[6] <= (iData[12:0] * ConversionMilliseconds);
									melody[6] <= iData[31];
									if (iData[26:20] == 7'b0) begin
										oSynth <= {iData[19:13], 1'b0};
									end
									else begin
										oSynth <= {iData[19:13], 1'b1};
									end
									oSynthVolume <= iData[26:20];
									oSynthInst <= iData[30:27];
									Allocated <= 1'b1;
									regPlay <= ~regPlay;
								end
								else begin
									if (occupied[7] == 1'b0 && Allocated == 1'b0) begin
										occupied[7] <= 1'b1;
										pitch[7] <= iData[19:13];
										counter[7] <= (iData[12:0] * ConversionMilliseconds);
										melody[7] <= iData[31];
										if (iData[26:20] == 7'b0) begin
											oSynth <= {iData[19:13], 1'b0};
										end
										else begin
											oSynth <= {iData[19:13], 1'b1};
										end
										oSynthVolume <= iData[26:20];
										oSynthInst <= iData[30:27];
										Allocated <= 1'b1;
										regPlay <= ~regPlay;
									end
								end
							end
						end
					end
				end
			end
		end
	end
			
	if (occupied[0] == 1'b1) begin
		if (counter[0] == 32'd96) begin
			oSynth 		<= {pitch[0], 1'b0};
		end
		if (counter[0] == 32'b0) begin
			occupied[0] <= 1'b0;
			if (melody[0] == 1'b1) begin
				melody[0] <= 1'b0;
			end
		end
		counter[0] <= counter[0] - 1'b1;
	end
	if (occupied[1] == 1'b1) begin
		if (counter[1] == 32'd96) begin
			oSynth 		<= {pitch[1], 1'b0};
		end
		if (counter[1] == 32'b0) begin
			occupied[1] <= 1'b0;
			if (melody[1] == 1'b1) begin
				melody[1] <= 1'b0;
			end
		end
		counter[1] <= counter[1] - 1'b1;
	end
	if (occupied[2] == 1'b1) begin
		if (counter[2] == 32'd96) begin
			oSynth 		<= {pitch[2], 1'b0};
		end
		if (counter[2] == 32'b0) begin
			occupied[2] <= 1'b0;
			if (melody[2] == 1'b1) begin
				melody[2] <= 1'b0;
			end
		end
		counter[2] <= counter[2] - 1'b1;
	end
	if (occupied[3] == 1'b1) begin
		if (counter[3] == 32'd96) begin
			oSynth 		<= {pitch[3], 1'b0};
		end
		if (counter[3] == 32'b0) begin
			occupied[3] <= 1'b0;
			if (melody[3] == 1'b1) begin
				melody[3] <= 1'b0;
			end
		end
		counter[3] <= counter[3] - 1'b1;
	end
	if (occupied[4] == 1'b1) begin
		if (counter[4] == 32'd96) begin
			oSynth 		<= {pitch[4], 1'b0};
		end
		if (counter[4] == 32'b0) begin
			occupied[4] <= 1'b0;
			if (melody[4] == 1'b1) begin
				melody[4] <= 1'b0;
			end
		end
		counter[4] <= counter[4] - 1'b1;
	end
	if (occupied[5] == 1'b1) begin
		if (counter[5] == 32'd96) begin
			oSynth 		<= {pitch[5], 1'b0};
		end
		if (counter[5] == 32'b0) begin
			occupied[5] <= 1'b0;
			if (melody[5] == 1'b1) begin
				melody[5] <= 1'b0;
			end
		end
		counter[5] <= counter[5] - 1'b1;
	end
	if (occupied[6] == 1'b1) begin
		if (counter[6] == 32'd96) begin
			oSynth 		<= {pitch[6], 1'b0};
		end
		if (counter[6] == 32'b0) begin
			occupied[6] <= 1'b0;
			if (melody[6] == 1'b1) begin
				melody[6] <= 1'b0;
			end
		end
		counter[6] <= counter[6] - 1'b1;
	end
	if (occupied[7] == 1'b1) begin
		if (counter[7] == 32'd96) begin
			oSynth 		<= {pitch[7], 1'b0};
		end
		if (counter[7] == 32'b0) begin
			occupied[7] <= 1'b0;
			if (melody[7] == 1'b1) begin
				melody[7] <= 1'b0;
			end
		end
		counter[7] <= counter[7] - 1'b1;
	end			
end
	
endmodule
