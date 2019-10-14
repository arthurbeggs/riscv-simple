///////////////////////////////////////////////////////////////////////////////
//                       uCHARLES - Módulo Top Level                         //
//                                                                           //
//          Código fonte em https://github.com/arthurbeggs/uCHARLES          //
//                            BSD 3-Clause License                           //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module fpga_top(
`ifdef USE_ADC
    inout           ADC_CS_N,
    output          ADC_DIN,
    input           ADC_DOUT,
    output          ADC_SCLK,
`endif

`ifdef USE_AUDIO_CODEC
    input           AUD_ADCDAT,
    inout           AUD_ADCLRCK,
    inout           AUD_BCLK,
    output          AUD_DACDAT,
    inout           AUD_DACLRCK,
    output          AUD_XCK,
`endif

`ifdef USE_DRAM
    output  [12:0]  DRAM_ADDR,
    output  [1:0]   DRAM_BA,
    output          DRAM_CAS_N,
    output          DRAM_CKE,
    output          DRAM_CLK,
    output          DRAM_CS_N,
    inout   [15:0]  DRAM_DQ,
    output          DRAM_LDQM,
    output          DRAM_RAS_N,
    output          DRAM_UDQM,
    output          DRAM_WE_N,
`endif

`ifdef USE_GPIO_0
    inout   [35:0]  GPIO_0,
`endif

`ifdef USE_GPIO_1
    inout   [35:0]  GPIO_1,
`endif

`ifdef USE_I2C
    output          FPGA_I2C_SCLK,
    inout           FPGA_I2C_SDAT,
`endif

`ifdef USE_INFRARED
    input           IRDA_RXD,
    output          IRDA_TXD,
`endif

`ifdef USE_PS2
    inout           PS2_CLK,
    inout           PS2_CLK2,
    inout           PS2_DAT,
    inout           PS2_DAT2,
`endif

`ifdef USE_TV_DECODER
    input           TD_CLK27,
    input   [7:0]   TD_DATA,
    input           TD_HS,
    output          TD_RESET_N,
    input           TD_VS,
`endif

`ifdef USE_VIDEO
    output  [7:0]   VGA_B,
    output          VGA_BLANK_N,
    output          VGA_CLK,
    output  [7:0]   VGA_G,
    output          VGA_HS,
    output  [7:0]   VGA_R,
    output          VGA_SYNC_N,
    output          VGA_VS,
`endif

`ifdef USE_ARM_HPS
    inout           HPS_CONV_USB_N,
    output  [14:0]  HPS_DDR3_ADDR,
    output  [2:0]   HPS_DDR3_BA,
    output          HPS_DDR3_CAS_N,
    output          HPS_DDR3_CKE,
    output          HPS_DDR3_CK_N,
    output          HPS_DDR3_CK_P,
    output          HPS_DDR3_CS_N,
    output  [3:0]   HPS_DDR3_DM,
    inout   [31:0]  HPS_DDR3_DQ,
    inout   [3:0]   HPS_DDR3_DQS_N,
    inout   [3:0]   HPS_DDR3_DQS_P,
    output          HPS_DDR3_ODT,
    output          HPS_DDR3_RAS_N,
    output          HPS_DDR3_RESET_N,
    input           HPS_DDR3_RZQ,
    output          HPS_DDR3_WE_N,
    output          HPS_ENET_GTX_CLK,
    inout           HPS_ENET_INT_N,
    output          HPS_ENET_MDC,
    inout           HPS_ENET_MDIO,
    input           HPS_ENET_RX_CLK,
    input   [3:0]   HPS_ENET_RX_DATA,
    input           HPS_ENET_RX_DV,
    output  [3:0]   HPS_ENET_TX_DATA,
    output          HPS_ENET_TX_EN,
    inout   [3:0]   HPS_FLASH_DATA,
    output          HPS_FLASH_DCLK,
    output          HPS_FLASH_NCSO,
    inout           HPS_GSENSOR_INT,
    inout           HPS_I2C1_SCLK,
    inout           HPS_I2C1_SDAT,
    inout           HPS_I2C2_SCLK,
    inout           HPS_I2C2_SDAT,
    inout           HPS_I2C_CONTROL,
    inout           HPS_KEY,
    inout           HPS_LED,
    inout           HPS_LTC_GPIO,
    output          HPS_SD_CLK,
    inout           HPS_SD_CMD,
    inout   [3:0]   HPS_SD_DATA,
    output          HPS_SPIM_CLK,
    input           HPS_SPIM_MISO,
    output          HPS_SPIM_MOSI,
    inout           HPS_SPIM_SS,
    input           HPS_UART_RX,
    output          HPS_UART_TX,
    input           HPS_USB_CLKOUT,
    inout   [7:0]   HPS_USB_DATA,
    input           HPS_USB_DIR,
    input           HPS_USB_NXT,
`endif

    input           CLOCK_50,
    input   [3:0]   KEY,
    input   [9:0]   SW,
    output  [9:0]   LEDR
);

//**************************** Barramento de Dados ***************************//
wire [31:0] DAddress;
wire [31:0] DReadData;
wire [31:0] DWriteData;
wire        DReadEnable;
wire        DWriteEnable;
wire [ 3:0] DByteEnable;


//****************************** Clock Interface *****************************//
wire CLK, oCLK_100, oCLK_50, oCLK_25, oCLK_18;
wire Reset;
wire clock_manual_mode;
wire clock_slow_mode;
wire [63:0] miliseconds;
wire [63:0] core_clock_ticks;

clock_interface clock_interface (
    .clock_reference        (CLOCK_50),
    .core_clock_divisor     (SW[4:0]),
    .reset_button           (KEY[0]),
    .frequency_mode_button  (KEY[1]),
    .clock_mode_button      (KEY[2]),
    .manual_clock_button    (KEY[3]),
    .stall_core             (stall_core),
    .clock_manual_mode      (clock_manual_mode),
    .clock_slow_mode        (clock_slow_mode),
    .core_clock_ticks       (core_clock_ticks),
    .miliseconds            (miliseconds),
    .clock_100mhz           (oCLK_100),
    .clock_50mhz            (oCLK_50),
    .clock_25mhz            (oCLK_25),
    .clock_18mhz            (oCLK_18),
    .core_clock             (CLK),
    .reset                  (Reset)
);


//****************************** RTC Interface *******************************//
rtc_interface rtc_interface (
    .miliseconds            (miliseconds[31:0]),
    .wReadEnable            (DReadEnable),
    .wAddress               (DAddress),
    .wReadData              (DReadData)
);


//***************************** Break Interface ******************************//
wire stall_core;

breakpoint_interface breakpoint_interface (
    .core_clock             (CLK),
    .reset                  (Reset),
    .clock_mode_button      (KEY[2]),
    .countdown_enable       (SW[5]),
    .ebreak_syscall         (mEbreak),
    .pc                     (mPC),
    .miliseconds            (miliseconds),
    .wReadEnable            (DReadEnable),
    .wAddress               (DAddress),
    .wReadData              (DReadData),
    .stall_core             (stall_core)
);


//************************************ CPU ***********************************//
wire [31:0] mPC;
wire [31:0] mInstr;
wire [ 5:0] mControlState;
wire [ 4:0] mVGASelect;
wire [31:0] mVGARead;
wire [31:0] mFVGARead;
wire [31:0] mCSRVGARead;
wire        mEbreak;

CPU CPU0 (
    .iCLK                   (CLK),      // Clock real do Processador
    .iCLK_50                (oCLK_50),  // Clock 50MHz fixo, usado so na FPU Uniciclo
    .iRST                   (Reset),

    // Sinais de debug
    .mPC                    (mPC),
    .mInstr                 (mInstr),
    .mControlState          (mControlState),
    .mVGASelect             (mVGASelect),
    .mVGARead               (mVGARead),
    .mCSRVGARead            (mCSRVGARead),
    .mFVGARead              (mFVGARead),
    .mEbreak                (mEbreak),

    // Barramento Dados
    .DReadEnable            (DReadEnable),
    .DWriteEnable           (DWriteEnable),
    .DByteEnable            (DByteEnable),
    .DAddress               (DAddress),
    .DWriteData             (DWriteData),
    .DReadData              (DReadData)
);


//****************************** LEDR Interface ******************************//
assign LEDR[9:3]    = mControlState;
assign LEDR[2]      = ~clock_manual_mode;
assign LEDR[1]      = ~clock_slow_mode;
assign LEDR[0]      = CLK;


//****************************** LFSR Interface ******************************//
LFSR_interface  lfsr0 (
    .iCLK                   (CLK),
    .iCLK_50                (oCLK_50),
    .wReadEnable            (DReadEnable),
    .wWriteEnable           (DWriteEnable),
    .wByteEnable            (DByteEnable),
    .wAddress               (DAddress),
    .wWriteData             (DWriteData),
    .wReadData              (DReadData)
);


//****************************** VGA Interface *******************************//
`ifdef USE_VIDEO
wire [4:0]  wVGASelectIn;
wire [31:0] wVGAReadIn;
assign wVGAReadIn       = (~SW[7] ? mVGARead : mFVGARead); // POR FALTA DE SW ALTEREI O mFVGARead(Float) para mCSRVGARead(Control Status)
assign mVGASelect       = wVGASelectIn;

video_interface video_interface (
    .clock_core             (CLK),
    .clock_memory           (oCLK_100),
    .clock_video            (oCLK_25),
    .reset                  (Reset),
    .frame_select_switch    (SW[6]),
    .osd_display            (SW[9]),
    .reg_debug_data         (wVGAReadIn),
    .reg_debug_address      (wVGASelectIn),
    .pc                     (mPC),
    .inst                   (mInstr),
    .epc                    (32'b0),
    .ecause                 (4'b0),
    .bus_data_fetched       (DReadData),
    .bus_address            (DAddress),
    .bus_write_data         (DWriteData),
    .bus_byte_enable        (DByteEnable),
    .bus_read_enable        (DReadEnable),
    .bus_write_enable       (DWriteEnable),
    .vga_red                (VGA_R),
    .vga_green              (VGA_G),
    .vga_blue               (VGA_B),
    .vga_clock              (VGA_CLK),
    .vga_horizontal_sync    (VGA_HS),
    .vga_vertical_sync      (VGA_VS),
    .vga_blank              (VGA_BLANK_N),
    .vga_sync               (VGA_SYNC_N)
);
`endif


//************************** PS2 Keyboard Interface **************************//
`ifdef USE_KEYBOARD
wire ps2_scan_ready_clock, keyboard_interrupt;

TecladoPS2_Interface TecladoPS20 (
    .iCLK                   (CLK),
    .iCLK_50                (oCLK_50),
    .Reset                  (Reset),
    .PS2_KBCLK              (PS2_CLK),
    .PS2_KBDAT              (PS2_DAT),
    .wReadEnable            (DReadEnable),
    .wWriteEnable           (DWriteEnable),
    .wByteEnable            (DByteEnable),
    .wAddress               (DAddress),
    .wWriteData             (DWriteData),
    .wReadData              (DReadData)

    // // Interrupcao
    // .ps2_scan_ready_clock    (ps2_scan_ready_clock),
    // .keyboard_interrupt      (keyboard_interrupt)
);
`endif


//************************** Audio CODEC Interface ***************************//
`ifdef USE_AUDIO_CODEC
wire [15:0] wsaudio_outL, wsaudio_outR;
// wire audio_clock_flip_flop, audio_proc_clock_flip_flop;

AudioCODEC_Interface Audio0 (
    .iCLK                   (CLK),
    .iCLK_50                (oCLK_50),
    .iCLK_18                (oCLK_18),
    .Reset                  (Reset),
    .oTD1_RESET_N           (TD_RESET_N),
    .I2C_SDAT               (FPGA_I2C_SDAT),
    .oI2C_SCLK              (FPGA_I2C_SCLK),
    .AUD_ADCLRCK            (AUD_ADCLRCK),
    .iAUD_ADCDAT            (AUD_ADCDAT),
    .AUD_DACLRCK            (AUD_DACLRCK),
    .oAUD_DACDAT            (AUD_DACDAT),
    .AUD_BCLK               (AUD_BCLK),
    .oAUD_XCK               (AUD_XCK),
    .wReadEnable            (DReadEnable),
    .wWriteEnable           (DWriteEnable),
    .wByteEnable            (DByteEnable),
    .wAddress               (DAddress),
    .wWriteData             (DWriteData),
    .wReadData              (DReadData),

    // Para o sintetizador
    .wsaudio_outL           (wsaudio_outL),
    .wsaudio_outR           (wsaudio_outR)

    // // Interrupcao
    // .audio_clock_flip_flop  (audio_clock_flip_flop),
    // .audio_proc_clock_flip_flop (audio_proc_clock_flip_flop)
);
`endif


//************************** Audio Synth Interface ***************************//
`ifdef USE_SYNTH

Sintetizador_Interface Sintetizador0 (
    .iCLK                   (CLK),
    .iCLK_50                (oCLK_50),
    .Reset                  (Reset),
    .AUD_DACLRCK            (AUD_DACLRCK),
    .AUD_BCLK               (AUD_BCLK),
    .wsaudio_outL           (wsaudio_outL),
    .wsaudio_outR           (wsaudio_outR),
    .wReadEnable            (DReadEnable),
    .wWriteEnable           (DWriteEnable),
    .wByteEnable            (DByteEnable),
    .wAddress               (DAddress),
    .wWriteData             (DWriteData),
    .wReadData              (DReadData)
);
`endif


//***************************** RS232 Interface ******************************//
`ifdef USE_RS232
RS232_Interface Serial0 (
    .iCLK                   (CLK),
    .iCLK_50                (oCLK_50),
    .Reset                  (Reset),
    .iUART_RXD              (GPIO_0[27]),
    .oUART_TXD              (GPIO_0[26]),
    .wReadEnable            (DReadEnable),
    .wWriteEnable           (DWriteEnable),
    .wByteEnable            (DByteEnable),
    .wAddress               (DAddress),
    .wWriteData             (DWriteData),
    .wReadData              (DReadData)
);
`endif


//****************************** ADC Interface *******************************//
`ifdef USE_ADC
ADC_Interface ADCI0 (
    .iCLK_50                (oCLK_50),
    .iCLK                   (CLK),
    .Reset                  (Reset),
    .ADC_CS_N               (ADC_CS_N),
    .ADC_DIN                (ADC_DIN),
    .ADC_DOUT               (ADC_DOUT),
    .ADC_SCLK               (ADC_SCLK),
    .wReadEnable            (DReadEnable),
    .wWriteEnable           (DWriteEnable),
    .wByteEnable            (DByteEnable),
    .wAddress               (DAddress),
    .wWriteData             (DWriteData),
    .wReadData              (DReadData)
);
`endif


//***************************** Mouse Interface ******************************//
`ifdef USE_MOUSE
wire reg_mouse_keyboard, received_data_en_contador_enable;

MousePS2_Interface Mouse0 (
    .iCLK                   (CLK),
    .iCLK_50                (oCLK_50),
    .Reset                  (Reset),
    .PS2_KBCLK              (PS2_CLK),
    .PS2_KBDAT              (PS2_DAT),
    .wReadEnable            (DReadEnable),
    .wWriteEnable           (DWriteEnable),
    .wByteEnable            (DByteEnable),
    .wAddress               (DAddress),
    .wWriteData             (DWriteData),
    .wReadData              (DReadData)

    // // Interrupcao
    // .reg_mouse_keyboard     (reg_mouse_keyboard),
    // .received_data_en_contador_enable   (received_data_en_contador_enable)
);
`endif


//****************************** IrDA Interface ******************************//
`ifdef USE_INFRARED
IrDA_Interface  IrDA0 (
    .iCLK_50                (oCLK_50),
    .iCLK                   (CLK),
    .Reset                  (Reset),
    .oIRDA_TXD              (IRDA_TXD),
    .iIRDA_RXD              (IRDA_RXD),
    .wReadEnable            (DReadEnable),
    .wWriteEnable           (DWriteEnable),
    .wByteEnable            (DByteEnable),
    .wAddress               (DAddress),
    .wWriteData             (DWriteData),
    .wReadData              (DReadData)
);

IrDA_decoder  IrDA_decoder0 (
    .iCLK_50                (oCLK_50),
    .iCLK                   (CLK),
    .Reset                  (Reset),
    .iIRDA_RXD              (IRDA_RXD),
    .wAddress               (DAddress),
    .oCode                  (DReadData),
    .wReadEnable            (DReadEnable),
    .iselect                (IRDAWORD)
);
`endif

endmodule

