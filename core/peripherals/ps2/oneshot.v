`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module oneshot(
    input clk,
    input trigger_in,
    output reg pulse_out
);

reg delay;

always @ (posedge clk) begin
    if (trigger_in && !delay)
            pulse_out <= 1'b1;
    else
            pulse_out <= 1'b0;

    delay <= trigger_in;
end

endmodule

