module AudioCODEC_Interface(
    input iCLK_50, iCLK_18, iCLK, Reset, // Clocks
    output oTD1_RESET_N,    // TV Decoder Reset
    // I2C
    inout  I2C_SDAT,        // I2C Data
    output oI2C_SCLK,       // I2C Clock
    // Audio CODEC
    inout  AUD_ADCLRCK,     // Audio CODEC ADC LR Clock
    input  iAUD_ADCDAT,     // Audio CODEC ADC Data
    output AUD_DACLRCK,     // Audio CODEC DAC LR Clock
    output oAUD_DACDAT,     // Audio CODEC DAC Data
    inout  AUD_BCLK,        // Audio CODEC Bit-Stream Clock
    output oAUD_XCK,        // Audio CODEC Chip Clock

    //Para o Sintetizador
    input  [15:0] wsaudio_outL,
    input  [15:0] wsaudio_outR,

    //  Barramento de IO
    input         wReadEnable, wWriteEnable,
    input  [3:0]  wByteEnable,
    input  [31:0] wAddress, wWriteData,
    output [31:0] wReadData,

    // Para o Coprocessador 0 - Interrupcao
    output reg audio_clock_flip_flop,
    output reg audio_proc_clock_flip_flop
);

// reset delay gives some time for peripherals to initialize
wire DLY_RST;
Reset_Delay r0(.iCLK(iCLK_50), .oRESET(DLY_RST) );

assign oTD1_RESET_N = 1'b1;  // Enable 27 MHz

wire AUD_CTRL_CLK;

/*
VGA_Audio_PLL     p1 (
    .areset(~DLY_RST),
    .inclk0(iCLK_28),
    .c0(),
    .c1(AUD_CTRL_CLK),
    .c2()
);*/

/*
AudioVideo_PLL av_pll(
    .refclk(iCLK_50_2),
	 .rst(1'b0),
    .outclk_0(AUD_CTRL_CLK),
    .outclk_1()
);*/

PLL_Audio pll1 (
		.refclk(iCLK_50),   //  refclk.clk
		.rst(Reset),      //   reset.reset
		.outclk_0(AUD_CTRL_CLK), // outclk0.clk
		.outclk_1(), // outclk1.clk
		.locked()    //  locked.export
	);


//assign AUD_CTRL_CLK = iCLK_18;

I2C_AV_Config u3(
//    Host Side
    .iCLK(iCLK_50),
    .iRST_N(~Reset),
//    I2C Side
    .I2C_SCLK(oI2C_SCLK),
    .I2C_SDAT(I2C_SDAT)
);

assign AUD_ADCLRCK  = AUD_DACLRCK;
assign oAUD_XCK     = AUD_CTRL_CLK;

audio_clock u4(
//    Audio Side
   .oAUD_BCK(AUD_BCLK),
   .oAUD_LRCK(AUD_DACLRCK),
//    Control Signals
   .iCLK_18_4(AUD_CTRL_CLK),
   .iRST_N(DLY_RST)
);


 /* CODEC AUDIO */

audio_converter u5(
    // Audio side
    .AUD_BCK(AUD_BCLK),       // Audio bit clock
    .AUD_LRCK(AUD_DACLRCK), // left-right clock
    .AUD_ADCDAT(iAUD_ADCDAT),
    .AUD_DATA(oAUD_DACDAT),
    // Controller side
    .iRST_N(DLY_RST),  // reset
    .AUD_outL(audio_outL),
    .AUD_outR(audio_outR),

    .AUD_inL(audio_inL),
    .AUD_inR(audio_inR)
);

wire [15:0] audio_inL, audio_inR;
wire [15:0] audio_outL,audio_outR;

reg  [31:0] waudio_inL ,waudio_inR;
reg  [31:0] waudio_outL, waudio_outR;
reg  [31:0] Ctrl1,Ctrl2;

wire [15:0] wcaudio_outL, wcaudio_outR;

assign audio_outL = (wcaudio_outL + wsaudio_outL); // canal L mixagem entre as amostras do CODEC e do Sintetizador
assign audio_outR = (wcaudio_outR + wsaudio_outR); // canal R mixagem entre as amostras do CODEC e do Sintetizador


initial
    begin
        waudio_inL  <= 32'b0;
        waudio_inR  <= 32'b0;
        waudio_outL <= 32'b0;
        waudio_outR <= 32'b0;
        Ctrl1       <= 32'b0;
        Ctrl2       <= 32'b0;
    end

// audio interruption
//reg audio_clock_flip_flop;
//reg audio_proc_clock_flip_flop;

initial
begin
    audio_clock_flip_flop       <= 1'b1;
    audio_proc_clock_flip_flop  <= 1'b0;
end
always @(negedge AUD_DACLRCK)
    audio_clock_flip_flop       <= ~audio_clock_flip_flop;
always @(posedge iCLK)
    audio_proc_clock_flip_flop  <= audio_clock_flip_flop;


always @(negedge AUD_DACLRCK)
    begin
        if(Ctrl2[0]==0)
            begin
                waudio_inR      <= {16'b0,audio_inR};
                wcaudio_outR    <= waudio_outR[15:0];
                Ctrl1[0]        <= 1'b1;
            end
        else
            Ctrl1[0]        <= 1'b0;
    end

always @(posedge AUD_DACLRCK)
    begin
        if(Ctrl2[1]==0)
            begin
                waudio_inL      <= {16'b0,audio_inL};
                wcaudio_outL    <= waudio_outL[15:0];
                Ctrl1[1]        <= 1'b1;
            end
        else
            Ctrl1[1]        <= 1'b0;
    end

always @(posedge iCLK)
        if(wWriteEnable) //Escrita no dispositivo de Audio
            begin
                if(wAddress == AUDIO_OUTR_ADDRESS)     waudio_outR  <= wWriteData[15:0]; else
                if(wAddress == AUDIO_OUTL_ADDRESS)     waudio_outL  <= wWriteData[15:0]; else
                if(wAddress == AUDIO_CRTL2_ADDRESS)    Ctrl2        <= wWriteData[7:0];
            end


always @(*)
        if(wReadEnable)  //Leitura do dispositivo de Audio
            begin
                if (wAddress == AUDIO_INR_ADDRESS)      wReadData = waudio_inR;     else
                if (wAddress == AUDIO_OUTR_ADDRESS)     wReadData = waudio_outR;    else
                if (wAddress == AUDIO_INL_ADDRESS)      wReadData = waudio_inL;     else
                if (wAddress == AUDIO_OUTL_ADDRESS)     wReadData = waudio_outL;    else
                if (wAddress == AUDIO_CTRL1_ADDRESS)    wReadData = Ctrl1;          else
                if (wAddress == AUDIO_CRTL2_ADDRESS)    wReadData = Ctrl2;          else
                wReadData   = 32'hzzzzzzzz;
            end
        else
            wReadData   = 32'hzzzzzzzz;

endmodule
