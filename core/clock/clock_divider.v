///////////////////////////////////////////////////////////////////////////////
//                        uCHARLES - Divisor de Clock                        //
//                                                                           //
//          Código fonte em https://github.com/arthurbeggs/uCHARLES          //
//                           BSD 3-Clause License                            //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module clock_divider (
    input clock_100mhz,
    input reset,
    input [4:0] clock_divisor,
    input slow_mode,
    output reg clock_divided
);

reg  [5:0]  fast_counter;
wire [5:0]  fast_divisor;
reg  [22:0] slow_counter;
wire [22:0] slow_divisor;
reg  fast_clock;
reg  slow_clock;

assign slow_divisor = {clock_divisor, 18'h20000};
assign fast_divisor = {1'b0, clock_divisor} - 6'd1;

initial begin
    fast_counter    <= 6'b0;
    fast_clock      <= 1'b0;
    slow_counter    <= 23'b0;
    slow_clock      <= 1'b0;
    clock_divided   <= 1'b0;
end

always @ (posedge clock_100mhz) begin
    if (slow_mode == 1) clock_divided <= slow_clock;
    else                clock_divided <= fast_clock;
end

always @ (posedge clock_100mhz or posedge reset) begin
    if (reset) slow_counter <= 23'b0;
    else if (slow_counter == slow_divisor) begin
        slow_counter    <= 23'b0;
        slow_clock      <= ~slow_clock;
    end
    else slow_counter   <= slow_counter + 23'd1;
end

always @ (posedge clock_100mhz or posedge reset) begin
    if (reset) fast_counter <= 6'b0;
    else if (fast_counter == fast_divisor) begin
        fast_counter    <= 6'b0;
        fast_clock      <= ~fast_clock;
    end
    else fast_counter   <= fast_counter + 6'd1;
end

endmodule

