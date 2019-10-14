///////////////////////////////////////////////////////////////////////////////
//                       uCHARLES - Contadores de Clock                      //
//                                                                           //
//          Código fonte em https://github.com/arthurbeggs/uCHARLES          //
//                           BSD 3-Clause License                            //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module clock_counters (
    input  core_clock,
    input  clock_50mhz,
    input  reset,

    output reg [63:0] core_clock_ticks,
    output reg [63:0] miliseconds
);

integer milisecond_counter;

initial begin
    core_clock_ticks    <= 64'b0;
    miliseconds         <= 64'b0;
    milisecond_counter  <= 0;
end

always @ (posedge core_clock or posedge reset) begin
    if (reset)  core_clock_ticks    <= 64'b0;
    else        core_clock_ticks    <= core_clock_ticks + 64'd1;
end

always @ (posedge clock_50mhz or posedge reset) begin
    if (reset) begin
        miliseconds         <= 64'b0;
        milisecond_counter  <= 0;
    end
    else if (milisecond_counter >= 50000) begin
        miliseconds         <= miliseconds + 64'd1;
        milisecond_counter  <= 0;
    end
    else milisecond_counter <= milisecond_counter + 1;
end

endmodule

