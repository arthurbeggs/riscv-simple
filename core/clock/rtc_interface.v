///////////////////////////////////////////////////////////////////////////////
//                    uCHARLES - Interface de RTC por MMIO                   //
//                                                                           //
//          Código fonte em https://github.com/arthurbeggs/uCHARLES          //
//                           BSD 3-Clause License                            //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module rtc_interface (
    input  [31:0] miliseconds,
    input  wReadEnable,
    input  [31:0] wAddress,
    output reg [31:0] wReadData
);

always @ (*) begin
    if (wAddress == RTC_ADDRESS) begin
        if (wReadEnable)    wReadData <= miliseconds;
        else                wReadData <= 32'b1;
    end
    else                    wReadData <= 32'hzzzzzzzz;
end

endmodule

