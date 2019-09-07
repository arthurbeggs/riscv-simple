module ADC_Interface(
    input         iCLK_50,
    input         iCLK,
    input         Reset,
    inout         ADC_CS_N,
    output        ADC_DIN,
    input         ADC_DOUT,
    output        ADC_SCLK,
    //  Barramento de IO
    input         wReadEnable, wWriteEnable,
    input  [3:0]  wByteEnable,
    input  [31:0] wAddress, wWriteData,
    output [31:0] wReadData
);

wire [11:0] CH0, CH1, CH2, CH3, CH4, CH5, CH6, CH7;

ADC_Controller ADC0(
		.CLOCK(iCLK_50),   		//                clk.clk
		.ADC_SCLK(ADC_SCLK), // external_interface.SCLK
		.ADC_CS_N(ADC_CS_N), //                   .CS_N
		.ADC_DOUT(ADC_DOUT), //                   .DOUT
		.ADC_DIN(ADC_DIN),  	//                   .DIN
		.CH0(CH0),      		//           readings.CH0
		.CH1(CH1),      		//                   .CH1
		.CH2(CH2),     		//                   .CH2
		.CH3(CH3),     		//                   .CH3
		.CH4(CH4),      		//                   .CH4
		.CH5(CH5),      		//                   .CH5
		.CH6(CH6),      		//                   .CH6
		.CH7(CH7),      		//                    .CH7
		.RESET(Reset)    	 	//              reset.reset
	);

	
		
always @(*)
	begin
        if(wReadEnable)
            begin

					 if(wAddress==ADC_CH0_ADDRESS)	wReadData <= {20'b0,CH0[11:0]}; else
					 if(wAddress==ADC_CH1_ADDRESS)	wReadData <= {20'b0,CH1[11:0]}; else
                if(wAddress==ADC_CH2_ADDRESS)  	wReadData <= {20'b0,CH2[11:0]}; else
                if(wAddress==ADC_CH3_ADDRESS)  	wReadData <= {20'b0,CH3[11:0]}; else
					 if(wAddress==ADC_CH4_ADDRESS)  	wReadData <= {20'b0,CH4[11:0]}; else
					 if(wAddress==ADC_CH5_ADDRESS)  	wReadData <= {20'b0,CH5[11:0]}; else
					 if(wAddress==ADC_CH6_ADDRESS)  	wReadData <= {20'b0,CH6[11:0]}; else
					 if(wAddress==ADC_CH7_ADDRESS)  	wReadData <= {20'b0,CH7[11:0]}; else
							wReadData <= 32'hzzzzzzzz;
						
            end
			else
				begin
				
					wReadData <= 32'hzzzzzzzz;
				
				
				end
				
	end			

endmodule



