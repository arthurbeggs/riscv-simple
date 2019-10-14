///////////////////////////////////////////////////////////////////////////////
//                       uCHARLES - Controle de Clocks                       //
//                                                                           //
//          Código fonte em https://github.com/arthurbeggs/uCHARLES          //
//                           BSD 3-Clause License                            //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module clock_control (
    input  clock_100mhz,
    input  pll_locked,
    input  clock_divided,
    input  reset_button,
    input  frequency_mode_button,
    input  clock_mode_button,
    input  manual_clock_button,
    input  stall_core,

    output reg manual_mode,
    output reg slow_mode,
    output reg core_clock,
    output reg reset
);

reg  manual_clock;

initial begin
    slow_mode       <= 1'b1;
    core_clock      <= 1'b0;
    reset           <= 1'b1;
    manual_mode     <= 1'b1;
    manual_clock    <= 1'b0;
end

always @ (posedge clock_100mhz) begin
    if (~manual_clock_button)       manual_clock <= 1'b1;
    else                            manual_clock <= 1'b0;
end

always @ (posedge clock_100mhz or negedge reset_button) begin
    if (~reset_button)              reset <= 1'b1;
    else                            reset <= 1'b0;
end

always @ (negedge frequency_mode_button) begin
    slow_mode <= ~slow_mode;
end

always @ (posedge stall_core or negedge clock_mode_button) begin
    if (stall_core)                 manual_mode <= 1'b1;
    else if (~clock_mode_button)    manual_mode <= ~manual_mode;
end

always @ (posedge clock_100mhz or posedge reset) begin
    case (manual_mode)
        1'b0:                       core_clock <= clock_divided;
        1'b1:                       core_clock <= manual_clock;
        default:                    core_clock <= manual_clock;
    endcase
end

endmodule

