///////////////////////////////////////////////////////////////////////////////
//                       uCHARLES - Interface de Clocks                      //
//                                                                           //
//          Código fonte em https://github.com/arthurbeggs/uCHARLES          //
//                           BSD 3-Clause License                            //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module clock_interface (
    input  clock_reference,
    input  [4:0] core_clock_divisor,
    input  reset_button,
    input  frequency_mode_button,
    input  clock_mode_button,
    input  manual_clock_button,
    input  stall_core,

    output clock_manual_mode,
    output clock_slow_mode,
    output [63:0] core_clock_ticks,
    output [63:0] miliseconds,

    output clock_100mhz,
    output clock_50mhz,
    output clock_25mhz,
    output clock_18mhz,
    output core_clock,
    output reset
);

wire clock_divided;
wire countdown_timed_up;
wire pll_locked;
wire countdown_reset;

clock_control clock_control (
    .clock_100mhz           (clock_100mhz),
    .pll_locked             (pll_locked),
    .clock_divided          (clock_divided),
    .reset_button           (reset_button),
    .frequency_mode_button  (frequency_mode_button),
    .clock_mode_button      (clock_mode_button),
    .manual_clock_button    (manual_clock_button),
    .stall_core             (stall_core),
    .manual_mode            (clock_manual_mode),
    .slow_mode              (clock_slow_mode),
    .core_clock             (core_clock),
    .reset                  (reset)
);

clock_divider clock_divider (
    .clock_100mhz           (clock_100mhz),
    .reset                  (reset),
    .clock_divisor          (core_clock_divisor),
    .slow_mode              (clock_slow_mode),
    .clock_divided          (clock_divided)
);

clock_counters clock_counters (
    .core_clock             (core_clock),
    .clock_50mhz            (clock_50mhz),
    .reset                  (reset),
    .core_clock_ticks       (core_clock_ticks),
    .miliseconds            (miliseconds)
);

`ifdef SIMULATION
    pll_sim pll_sim (
        .clock_reference(clock_reference),
        .clock_100mhz   (clock_100mhz),
        .clock_50mhz    (clock_50mhz),
        .clock_25mhz    (clock_25mhz),
        .clock_18mhz    (clock_18mhz),
        .locked         (pll_locked)
    );
`else
    `ifdef DE2_115
    pll pll (
        .inclk0         (clock_reference),
        .c0             (clock_100mhz),
        .c1             (clock_50mhz),
        .c2             (clock_25mhz),
        .c3             (clock_18mhz),
        .locked         (pll_locked)
    );
    `endif
    `ifdef DE1_SOC
    pll pll (
        .refclk         (clock_reference),
        .rst            (1'b0),
        .outclk_0       (clock_100mhz),
        .outclk_1       (clock_50mhz),
        .outclk_2       (clock_25mhz),
        .outclk_3       (clock_18mhz),
        .locked         (pll_locked)
    );
    `endif
`endif

endmodule

