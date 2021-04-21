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
    output          TD_RESET_N,
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
wire core_clock;
wire clock_100mhz;
wire clock_50mhz;
wire clock_25mhz;
wire clock_18mhz;
wire reset;
wire clock_manual_mode;
wire clock_slow_mode;
wire stall_core;
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
    .clock_100mhz           (clock_100mhz),
    .clock_50mhz            (clock_50mhz),
    .clock_25mhz            (clock_25mhz),
    .clock_18mhz            (clock_18mhz),
    .core_clock             (core_clock),
    .reset                  (reset)
);


//************************************ CPU ***********************************//
wire [31:0] pc;
wire [31:0] inst;
wire [ 5:0] mControlState;
wire [ 4:0] reg_debug_address;
wire [11:0] csr_debug_address;
wire [31:0] reg_debug_data;
wire [31:0] fp_reg_debug_data;
wire [31:0] csr_debug_data;
wire ebreak_syscall;

CPU CPU (
    .iCLK                   (core_clock),      // Clock real do Processador
    .iCLK_50                (clock_50mhz),  // Clock 50MHz fixo, usado so na FPU Uniciclo
    .iRST                   (reset),
    .initial_pc             (BEGINNING_TEXT),

    // Sinais de debug
    .pc                     (pc),
    .inst                   (inst),
    .mControlState          (mControlState),
    .reg_debug_address      (reg_debug_address),
    .csr_debug_address      (csr_debug_address),
    .reg_debug_data         (reg_debug_data),
    .fp_reg_debug_data      (fp_reg_debug_data),
    .csr_debug_data         (csr_debug_data),
    .ebreak_syscall         (ebreak_syscall),

    // Contadores
    .core_clock_ticks       (core_clock_ticks),
    .miliseconds            (miliseconds),

    // Barramento Dados
    .DReadEnable            (DReadEnable),
    .DWriteEnable           (DWriteEnable),
    .DByteEnable            (DByteEnable),
    .DAddress               (DAddress),
    .DWriteData             (DWriteData),
    .DReadData              (DReadData)
);


//****************************** RTC Interface *******************************//
rtc_interface rtc_interface (
    .miliseconds            (miliseconds[31:0]),
    .wReadEnable            (DReadEnable),
    .wAddress               (DAddress),
    .wReadData              (DReadData)
);


//***************************** Break Interface ******************************//
breakpoint_interface breakpoint_interface (
    .core_clock             (core_clock),
    .clock_50mhz            (clock_50mhz),
    .reset                  (reset),
    .clock_mode_button      (KEY[2]),
    .countdown_enable       (SW[5]),
    .ebreak_syscall         (ebreak_syscall),
    .pc                     (pc),
    .miliseconds            (miliseconds),
    .wReadEnable            (DReadEnable),
    .wWriteEnable           (DWriteEnable),
    .wByteEnable            (DByteEnable),
    .wAddress               (DAddress),
    .wWriteData             (DWriteData),
    .wReadData              (DReadData),
    .stall_core             (stall_core)
);


//****************************** LEDR Interface ******************************//
assign LEDR[9:3]    = mControlState;
assign LEDR[2]      = ~clock_manual_mode;
assign LEDR[1]      = ~clock_slow_mode;
assign LEDR[0]      = core_clock;


//****************************** LFSR Interface ******************************//
LFSR_interface  lfsr0 (
    .iCLK                   (core_clock),
    .iCLK_50                (clock_50mhz),
    .wReadEnable            (DReadEnable),
    .wWriteEnable           (DWriteEnable),
    .wByteEnable            (DByteEnable),
    .wAddress               (DAddress),
    .wWriteData             (DWriteData),
    .wReadData              (DReadData)
);


//****************************** VGA Interface *******************************//
`ifdef USE_VIDEO
video_interface video_interface (
    .clock_core             (core_clock),
    .clock_memory           (clock_100mhz),
    .clock_video            (clock_25mhz),
    .reset                  (reset),
    .frame_select_switch    (SW[6]),
    .osd_enable             (SW[9]),
    .osd_select_regfile     (SW[7]),
    .reg_debug_address      (reg_debug_address),
    .csr_debug_address      (csr_debug_address),
    .reg_debug_data         (reg_debug_data),
    .fp_reg_debug_data      (fp_reg_debug_data),
    .csr_debug_data         (csr_debug_data),
    .pc                     (pc),
    .inst                   (inst),
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
    .iCLK                   (core_clock),
    .iCLK_50                (clock_50mhz),
    .Reset                  (reset),
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
    .iCLK                   (core_clock),
    .iCLK_50                (clock_50mhz),
    .iCLK_18                (clock_18mhz),
    .Reset                  (reset),
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
    .iCLK                   (core_clock),
    .iCLK_50                (clock_50mhz),
    .Reset                  (reset),
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
    .iCLK                   (core_clock),
    .iCLK_50                (clock_50mhz),
    .Reset                  (reset),
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
    .iCLK_50                (clock_50mhz),
    .iCLK                   (core_clock),
    .Reset                  (reset),
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
    .iCLK                   (core_clock),
    .iCLK_50                (clock_50mhz),
    .Reset                  (reset),
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
    .iCLK_50                (clock_50mhz),
    .iCLK                   (core_clock),
    .Reset                  (reset),
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
    .iCLK_50                (clock_50mhz),
    .iCLK                   (core_clock),
    .Reset                  (reset),
    .iIRDA_RXD              (IRDA_RXD),
    .wAddress               (DAddress),
    .oCode                  (DReadData),
    .wReadEnable            (DReadEnable),
    .iselect                (IRDAWORD)
);
`endif

endmodule

