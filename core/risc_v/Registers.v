`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module Registers (
    input  iCLK,
    input  iRST,
    input  iRegWrite,
    input  [ 4:0] iReadRegister1,
    input  [ 4:0] iReadRegister2,
    input  [ 4:0] iWriteRegister,
    input  [31:0] iWriteData,
    output [31:0] oReadData1,
    output [31:0] oReadData2,

    input  [ 4:0] iVGASelect,
    output reg [31:0] oVGARead
);

/* Register file */
localparam SPR=5'd2;                    // SP

reg  [31:0] registers[31:0];
reg  [ 5:0] i;

initial begin
    for (i = 0; i <= 31; i = i + 1'b1) registers[i] = 32'd0;
    registers[SPR] = STACK_ADDRESS;
end

assign oReadData1   = registers[iReadRegister1];
assign oReadData2   = registers[iReadRegister2];
assign oVGARead     = registers[iVGASelect];

`ifdef PIPELINE
always @(negedge iCLK or posedge iRST) begin
`else
always @(posedge iCLK or posedge iRST) begin
`endif
    if (iRST) begin // reseta o banco de registradores e pilha
        for (i = 0; i <= 31; i = i + 1'b1) registers[i] <= 32'b0;
        registers[SPR]   <= STACK_ADDRESS;  // SP
    end
    else begin
        i <= 6'bxxxxxx; // para não dar warning
        if (iRegWrite && iWriteRegister != 5'b0)
            registers[iWriteRegister] <= iWriteData;
    end
end

endmodule

