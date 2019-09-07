module SynthControl(
	input CLK,
	input iSampleClock,
	input MemWrite,
	input [31:0] wMemAddress,
	input [31:0] wMemWriteData,
	input [31:0] iCurrentNoteData,
	output [31:0] oCurrentNoteAddress,
	output [7:0] oSynth,
	output [6:0] oSynthVolume,
	output [3:0] oSynthInst
);

reg [31:0] currentAddress;
wire [31:0] iData;						// Dados da word que contem a nota a ser tocada
reg [6:0] ConversionMilliseconds;	// Conversor de clock para milisegundos em funcao de AUD_DACLRCK
reg Allocated;								// Registrador true para nota alocada, false para nota nao alocada
reg [31:0] MusicAddress;
reg [31:0] MusicTempo;


reg [31:0] counter [0:7];				// Contador para cada canal
reg occupied [0:7];						// Registrador true para canal ocupado e false para canal nao ocupado
reg [6:0] pitch [0:7];					// Registrador que guarda o pitch da nota alocada no canal
reg melody [0:7];
reg Play, Stop, regBegin, regDacapo;							// Registrador que guarda se a nota = melodia (blocante)
reg SynthMelody;

initial
	begin
	iData <= 32'b0;
	oSynth <= 8'b0;
	oSynthVolume <= 7'b0;
	oSynthInst <= 4'b0;
	regBegin <= 1'b0;
	regDacapo <= 1'b0;
	MusicTempo <= 32'b0;
	currentAddress <= 32'b0;
	Play <= 1'b0;
	Stop <= 1'b0;
//	ConversionMilliseconds <= 6'd96;		//48  7777??????
	ConversionMilliseconds <= 7'd48;		//48  7777??????
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

assign iData = iCurrentNoteData;
assign oCurrentNoteAddress = currentAddress;
assign SynthMelody = (melody[0] || melody[1] || melody[2] || melody[3] || melody[4] || melody[5] || melody[6] || melody[7]);


always @(posedge CLK) begin	
	if(MemWrite) begin
		case (wMemAddress)
			MUSIC_ADDRESS: begin
				MusicAddress <= wMemWriteData;
				Play <= ~Play;
				regBegin <= ~regBegin;
			end
			MUSIC_TEMPO_ADDRESS: begin
				MusicTempo <= wMemWriteData;
			end
		endcase
	end
end
	

always @(posedge iSampleClock) begin
	if (Play ^ Stop) begin
		if (regBegin ^ regDacapo) begin
			regDacapo <= ~regDacapo;
			currentAddress <= MusicAddress;
		end
		
		if (SynthMelody == 1'b0) begin
			Allocated <= 1'b0;
			if (occupied[0] == 1'b0 && Allocated == 1'b0) begin
				occupied[0] <= 1'b1;
				pitch[0] <= iData[16:10];
				counter[0] <= (((iData[7:4]) + (iData[3] * 1/2) + (iData[2] * 1/4) + (iData[1] * 1/8) + (iData[0] * 1/16)) * MusicTempo * ConversionMilliseconds);
				melody[0] <= iData[28];
				if (iData[23:17] == 7'b0) begin
					oSynth <= {iData[16:10], 1'b0};
				end
				else begin
					oSynth <= {iData[16:10], 1'b1};
				end
				oSynthVolume <= iData[23:17];
				oSynthInst <= iData[27:24];
				Allocated <= 1'b1;
				if (iData[8] == 1'b1) begin
					regDacapo <= ~regDacapo;
				end
				else begin
					if (iData[9] == 1'b1) begin
					Stop <= ~Stop;
					end
					else currentAddress <= currentAddress + 32'd4; 
				end	
			end
			else begin
				if (occupied[1] == 1'b0 && Allocated == 1'b0) begin
					occupied[1] <= 1'b1;
					pitch[1] <= iData[16:10];
					counter[1] <=  (((iData[7:4]) + (iData[3] * 1/2) + (iData[2] * 1/4) + (iData[1] * 1/8) + (iData[0] * 1/16)) * MusicTempo * ConversionMilliseconds);
					melody[1] <= iData[28];
					if (iData[23:17] == 7'b0) begin
						oSynth <= {iData[16:10], 1'b0};
					end
					else begin
						oSynth <= {iData[16:10], 1'b1};
					end
					oSynthVolume <= iData[23:17];
					oSynthInst <= iData[27:24];
					Allocated <= 1'b1;
					if (iData[8] == 1'b1) begin
						regDacapo <= ~regDacapo;
					end
					else begin
						if (iData[9] == 1'b1) begin
						Stop <= ~Stop;
						end
						else currentAddress <= currentAddress + 32'd4; 
					end	
				end
				else begin
					if (occupied[2] == 1'b0 && Allocated == 1'b0) begin
						occupied[2] <= 1'b1;
						pitch[2] <= iData[16:10];
						counter[2] <=  (((iData[7:4]) + (iData[3] * 1/2) + (iData[2] * 1/4) + (iData[1] * 1/8) + (iData[0] * 1/16)) * MusicTempo * ConversionMilliseconds);
						melody[2] <= iData[28];
						if (iData[23:17] == 7'b0) begin
							oSynth <= {iData[16:10], 1'b0};
						end
						else begin
							oSynth <= {iData[16:10], 1'b1};
						end
						oSynthVolume <= iData[23:17];
						oSynthInst <= iData[27:24];
						Allocated <= 1'b1;
						if (iData[8] == 1'b1) begin
							regDacapo <= ~regDacapo;
						end
						else begin
							if (iData[9] == 1'b1) begin
							Stop <= ~Stop;
							end
							else currentAddress <= currentAddress + 32'd4; 
						end	
					end
					else begin
						if (occupied[3] == 1'b0 && Allocated == 1'b0) begin
							occupied[3] <= 1'b1;
							pitch[3] <= iData[16:10];
							counter[3] <=  (((iData[7:4]) + (iData[3] * 1/2) + (iData[2] * 1/4) + (iData[1] * 1/8) + (iData[0] * 1/16)) * MusicTempo * ConversionMilliseconds);
							melody[3] <= iData[28];
							if (iData[23:17] == 7'b0) begin
								oSynth <= {iData[16:10], 1'b0};
							end
							else begin
								oSynth <= {iData[16:10], 1'b1};
							end
							oSynthVolume <= iData[23:17];
							oSynthInst <= iData[27:24];
							Allocated <= 1'b1;
							if (iData[8] == 1'b1) begin
								regDacapo <= ~regDacapo;
							end
							else begin
								if (iData[9] == 1'b1) begin
								Stop <= ~Stop;
								end
								else currentAddress <= currentAddress + 32'd4; 
							end	
						end
						else begin
							if (occupied[4] == 1'b0 && Allocated == 1'b0) begin
								occupied[4] <= 1'b1;
								pitch[4] <= iData[16:10];
								counter[4] <=  (((iData[7:4]) + (iData[3] * 1/2) + (iData[2] * 1/4) + (iData[1] * 1/8) + (iData[0] * 1/16)) * MusicTempo * ConversionMilliseconds);
								melody[4] <= iData[28];
								if (iData[23:17] == 7'b0) begin
									oSynth <= {iData[16:10], 1'b0};
								end
								else begin
									oSynth <= {iData[16:10], 1'b1};
								end
								oSynthVolume <= iData[23:17];
								oSynthInst <= iData[27:24];
								Allocated <= 1'b1;
								if (iData[8] == 1'b1) begin
									regDacapo <= ~regDacapo;
								end
								else begin
									if (iData[9] == 1'b1) begin
									Stop <= ~Stop;
									end
									else currentAddress <= currentAddress + 32'd4; 
								end	
							end
							else begin
								if (occupied[5] == 1'b0 && Allocated == 1'b0) begin
									occupied[5] <= 1'b1;
									pitch[5] <= iData[16:10];
									counter[5] <=  (((iData[7:4]) + (iData[3] * 1/2) + (iData[2] * 1/4) + (iData[1] * 1/8) + (iData[0] * 1/16)) * MusicTempo * ConversionMilliseconds);
									melody[5] <= iData[28];
									if (iData[23:17] == 7'b0) begin
										oSynth <= {iData[16:10], 1'b0};
									end
									else begin
										oSynth <= {iData[16:10], 1'b1};
									end
									oSynthVolume <= iData[23:17];
									oSynthInst <= iData[27:24];
									Allocated <= 1'b1;
									if (iData[8] == 1'b1) begin
										regDacapo <= ~regDacapo;
									end
									else begin
										if (iData[9] == 1'b1) begin
										Stop <= ~Stop;
										end
										else currentAddress <= currentAddress + 32'd4; 
									end	
								end
								else begin
									if (occupied[6] == 1'b0 && Allocated == 1'b0) begin
										occupied[6] <= 1'b1;
										pitch[6] <= iData[16:10];
										counter[6] <=  (((iData[7:4]) + (iData[3] * 1/2) + (iData[2] * 1/4) + (iData[1] * 1/8) + (iData[0] * 1/16)) * MusicTempo * ConversionMilliseconds);
										melody[6] <= iData[28];
										if (iData[23:17] == 7'b0) begin
											oSynth <= {iData[16:10], 1'b0};
										end
										else begin
											oSynth <= {iData[16:10], 1'b1};
										end
										oSynthVolume <= iData[23:17];
										oSynthInst <= iData[27:24];
										Allocated <= 1'b1;
										if (iData[8] == 1'b1) begin
											regDacapo <= ~regDacapo;
										end
										else begin
											if (iData[9] == 1'b1) begin
											Stop <= ~Stop;
											end
											else currentAddress <= currentAddress + 32'd4; 
										end	
									end
									else begin
										if (occupied[7] == 1'b0 && Allocated == 1'b0) begin
											occupied[7] <= 1'b1;
											pitch[7] <= iData[16:10];
											counter[7] <=  (((iData[7:4]) + (iData[3] * 1/2) + (iData[2] * 1/4) + (iData[1] * 1/8) + (iData[0] * 1/16)) * MusicTempo * ConversionMilliseconds);
											melody[7] <= iData[28];
											if (iData[23:17] == 7'b0) begin
												oSynth <= {iData[16:10], 1'b0};
											end
											else begin
												oSynth <= {iData[16:10], 1'b1};
											end
											oSynthVolume <= iData[23:17];
											oSynthInst <= iData[27:24];
											Allocated <= 1'b1;
											if (iData[8] == 1'b1) begin
												regDacapo <= ~regDacapo;
											end
											else begin
												if (iData[9] == 1'b1) begin
												Stop <= ~Stop;
												end
												else currentAddress <= currentAddress + 32'd4; 
											end	
										end
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
