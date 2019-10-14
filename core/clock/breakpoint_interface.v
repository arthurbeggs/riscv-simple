///////////////////////////////////////////////////////////////////////////////
//                     uCHARLES - Interface de Breakpoint                    //
//                                                                           //
//          Código fonte em https://github.com/arthurbeggs/uCHARLES          //
//                           BSD 3-Clause License                            //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module breakpoint_interface (
    input  core_clock,
    input  reset,
    input  clock_mode_button,
    input  countdown_enable,
    input  ebreak_syscall,
    input  [31:0] pc,
    input  [63:0] miliseconds,

    input  wReadEnable,
    input  [31:0] wAddress,
    output reg [31:0] wReadData,

    output stall_core
);

localparam TIMEUP_MILISECONDS = 10000;

integer counter;
wire [31:0] in_system_breakpoint_address;
reg  countdown_timed_up;

breakpoint_address breakpoint_address (
    .result     (in_system_breakpoint_address)
);

initial begin
    counter             <= 0;
    countdown_timed_up  <= 1'b0;
    stall_core          <= 1'b0;
end

//*********************** Contador de tempo de execução *********************//
always @ (posedge miliseconds[0] or posedge reset
            or negedge clock_mode_button) begin
    if (reset || ~clock_mode_button) begin
        counter             <= 0;
        countdown_timed_up  <= 1'b0;
    end
    else if (countdown_enable) begin
        if (counter >= TIMEUP_MILISECONDS) begin
            counter             <= 0;
            countdown_timed_up  <= 1'b1;
        end
        else begin
            counter             <= counter + 2;
            countdown_timed_up  <= 1'b0;
        end
    end
    else begin
        counter             <= 0;
        countdown_timed_up  <= 1'b0;
    end
end
///////////////////////////////////////////////////////////////////////////////

always @ (*) begin
    if (wAddress == BREAK_ADDRESS) begin
        if (wReadEnable)    wReadData <= in_system_breakpoint_address;
        else                wReadData <= 32'b1;
    end
    else                    wReadData <= 32'hzzzzzzzz;
end

always @ (negedge core_clock or posedge reset or negedge clock_mode_button) begin
    if (reset)                                      stall_core  <= 1'b0;
    else if (~clock_mode_button)                    stall_core  <= 1'b0;
    else if (countdown_timed_up)                    stall_core  <= 1'b1;
    else if (pc == in_system_breakpoint_address)    stall_core  <= 1'b1;
    else if (ebreak_syscall)                        stall_core  <= 1'b1;
    else                                            stall_core  <= 1'b0;
end

endmodule

