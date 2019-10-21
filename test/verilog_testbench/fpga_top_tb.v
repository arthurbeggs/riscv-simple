///////////////////////////////////////////////////////////////////////////////
//                uCHARLES - Testbench do Módulo Top Level                   //
//                                                                           //
//          Código fonte em https://github.com/arthurbeggs/uCHARLES          //
//                            BSD 3-Clause License                           //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

`timescale 10 ns / 10 ns

// Duração da simulação, em nanosegundos/10
`define SIMULATION_DURATION 1000000

module fpga_top_tb;

reg clock;
reg [3:0] key;
reg [9:0] switch;

fpga_top dut(
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

    .CLOCK_50           (clock),
    .KEY                (key),
    .SW                 (switch),
    .LEDR               ()
);

initial begin
    clock   <= 1'b0;
    key     <= 4'b1111;
    switch  <= 10'b0000000111;
    #4;
    key     <= 4'b1110;
    #8;
    key     <= 4'b1101;
    #4;
    key     <= 4'b1111;
    #4;
    key     <= 4'b1011;
    #4;
    key     <= 4'b1111;
end

always begin
    #1 clock <= ~clock;
end

always begin
    #`SIMULATION_DURATION;
    $finish;
end

endmodule

