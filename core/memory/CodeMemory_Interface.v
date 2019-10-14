`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module CodeMemory_Interface (
    input  iCLK,
    input  iCLKMem,
    input  wReadEnable,
    input  wWriteEnable,
    input  [3:0]  wByteEnable,
    input  [31:0] wAddress,
    input  [31:0] wWriteData,
    output reg [31:0] wReadData
);

wire [31:0] wMemDataMB0;
wire [31:0] usermem_addr;
wire wMemWriteMB0;
wire is_usermem;
reg  MemWritten;

assign is_usermem   = (wAddress >= BEGINNING_TEXT) && (wAddress <= END_TEXT);
assign usermem_addr = wAddress - BEGINNING_TEXT;
assign wMemWriteMB0 = ~MemWritten && wWriteEnable && is_usermem;

text_memory text_memory(
    .address    (usermem_addr[TEXT_WIDTH-1:2]),
    .byteena    (wByteEnable),
    .clock      (iCLKMem),
    .data       (wWriteData),
    .wren       (wMemWriteMB0),
    .q          (wMemDataMB0)
);

initial MemWritten <= 1'b0;
always @(iCLK) MemWritten <= iCLK;

always @(*) begin
    if(is_usermem) begin
        if(wReadEnable) wReadData <= wMemDataMB0;
        else            wReadData <= 32'b1;
    end
    else                wReadData <= 32'hzzzzzzzz;
end

endmodule

