///////////////////////////////////////////////////////////////////////////////
//                uCHARLES - Testbench do Módulo Top Level                   //
//                                                                           //
//          Código fonte em https://github.com/arthurbeggs/uCHARLES          //
//                            BSD 3-Clause License                           //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

`timescale 1 ns / 1 ns

module fpga_top_tb;

reg clock;
reg [3:0] key;
reg [9:0] switch;

fpga_top dut(
`ifdef USE_ADC
    .ADC_CS_N           (),
    .ADC_DIN            (),
    .ADC_DOUT           (),
    .ADC_SCLK           (),
`endif

`ifdef USE_AUDIO_CODEC
    .AUD_ADCDAT         (),
    .AUD_ADCLRCK        (),
    .AUD_BCLK           (),
    .AUD_DACDAT         (),
    .AUD_DACLRCK        (),
    .AUD_XCK            (),
`endif

`ifdef USE_DRAM
    .DRAM_ADDR          (),
    .DRAM_BA            (),
    .DRAM_CAS_N         (),
    .DRAM_CKE           (),
    .DRAM_CLK           (),
    .DRAM_CS_N          (),
    .DRAM_DQ            (),
    .DRAM_LDQM          (),
    .DRAM_RAS_N         (),
    .DRAM_UDQM          (),
    .DRAM_WE_N          (),
`endif

`ifdef USE_GPIO_0
    .GPIO_0             (),
`endif

`ifdef USE_GPIO_1
    .GPIO_1             (),
`endif

`ifdef USE_I2C
    .FPGA_I2C_SCLK      (),
    .FPGA_I2C_SDAT      (),
`endif

`ifdef USE_INFRARED
    .IRDA_RXD           (),
    .IRDA_TXD           (),
`endif

`ifdef USE_PS2
    .PS2_CLK            (),
    .PS2_CLK2           (),
    .PS2_DAT            (),
    .PS2_DAT2           (),
`endif

`ifdef USE_TV_DECODER
    .TD_CLK27           (),
    .TD_DATA            (),
    .TD_HS              (),
    .TD_RESET_N         (),
    .TD_VS              (),
`endif

`ifdef USE_VIDEO
    .VGA_B              (),
    .VGA_BLANK_N        (),
    .VGA_CLK            (),
    .VGA_G              (),
    .VGA_HS             (),
    .VGA_R              (),
    .VGA_SYNC_N         (),
    .VGA_VS             (),
`endif

`ifdef USE_ARM_HPS
    .HPS_CONV_USB_N     (),
    .HPS_DDR3_ADDR      (),
    .HPS_DDR3_BA        (),
    .HPS_DDR3_CAS_N     (),
    .HPS_DDR3_CKE       (),
    .HPS_DDR3_CK_N      (),
    .HPS_DDR3_CK_P      (),
    .HPS_DDR3_CS_N      (),
    .HPS_DDR3_DM        (),
    .HPS_DDR3_DQ        (),
    .HPS_DDR3_DQS_N     (),
    .HPS_DDR3_DQS_P     (),
    .HPS_DDR3_ODT       (),
    .HPS_DDR3_RAS_N     (),
    .HPS_DDR3_RESET_N   (),
    .HPS_DDR3_RZQ       (),
    .HPS_DDR3_WE_N      (),
    .HPS_ENET_GTX_CLK   (),
    .HPS_ENET_INT_N     (),
    .HPS_ENET_MDC       (),
    .HPS_ENET_MDIO      (),
    .HPS_ENET_RX_CLK    (),
    .HPS_ENET_RX_DATA   (),
    .HPS_ENET_RX_DV     (),
    .HPS_ENET_TX_DATA   (),
    .HPS_ENET_TX_EN     (),
    .HPS_FLASH_DATA     (),
    .HPS_FLASH_DCLK     (),
    .HPS_FLASH_NCSO     (),
    .HPS_GSENSOR_INT    (),
    .HPS_I2C1_SCLK      (),
    .HPS_I2C1_SDAT      (),
    .HPS_I2C2_SCLK      (),
    .HPS_I2C2_SDAT      (),
    .HPS_I2C_CONTROL    (),
    .HPS_KEY            (),
    .HPS_LED            (),
    .HPS_LTC_GPIO       (),
    .HPS_SD_CLK         (),
    .HPS_SD_CMD         (),
    .HPS_SD_DATA        (),
    .HPS_SPIM_CLK       (),
    .HPS_SPIM_MISO      (),
    .HPS_SPIM_MOSI      (),
    .HPS_SPIM_SS        (),
    .HPS_UART_RX        (),
    .HPS_UART_TX        (),
    .HPS_USB_CLKOUT     (),
    .HPS_USB_DATA       (),
    .HPS_USB_DIR        (),
    .HPS_USB_NXT        (),
`endif

    .CLOCK_50           (clock),
    .KEY                (key),
    .SW                 (switch),
    .LEDR               ()
);


initial begin
    clock   <= 1'b0;
    key     <= 4'b1111;
    switch  <= 10'b0000000011;
    #40;
    key     <= 4'b1001;
    #40;
    key     <= 4'b1111;
    #40;
    key     <= 4'b1110;
    #200;
    key     <= 4'b1111;
    #40;
    key     <= 4'b1001;
    #40;
    key     <= 4'b1111;
end

always begin
    #10 clock <= ~clock;
end

always begin
    #2000000;
    $finish;
end

endmodule

