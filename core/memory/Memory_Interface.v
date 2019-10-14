`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module Memory_Interface (
    input  iCLK,
    input  iCLKMem,
    input  wReadEnable,
    input  wWriteEnable,
    input  [3:0]  wByteEnable,
    input  [31:0] wAddress,
    input  [31:0] wWriteData,
    output reg [31:0] wReadData
);

wire [31:0] wMemData_UserCode, wMemData_UserData;
wire [31:0] usercode_addr, userdata_addr;
wire wMemWrite_UserCode, wMemWrite_UserData;
wire is_usercode, is_userdata;
reg MemWritten;

assign is_usercode          = (wAddress >= BEGINNING_TEXT) && (wAddress <= END_TEXT);
assign is_userdata          = (wAddress >= BEGINNING_DATA) && (wAddress <= END_DATA);
assign usercode_addr        = wAddress - BEGINNING_TEXT;
assign userdata_addr        = wAddress - BEGINNING_DATA;
assign wMemWrite_UserCode   = ~MemWritten && wWriteEnable && is_usercode;
assign wMemWrite_UserData   = ~MemWritten && wWriteEnable && is_userdata;

text_memory text_memory(
    .address    (usercode_addr[TEXT_WIDTH-1:2]),
    .byteena    (wByteEnable),
    .clock      (iCLKMem),
    .data       (wWriteData),
    .wren       (wMemWrite_UserCode),
    .q          (wMemData_UserCode)
);

data_memory data_memory(
    .address    (userdata_addr[DATA_WIDTH-1:2]),
    .byteena    (wByteEnable),
    .clock      (iCLKMem),
    .data       (wWriteData),
    .wren       (wMemWrite_UserData),
    .q          (wMemData_UserData)
);

initial MemWritten <= 1'b0;
always @(iCLK) MemWritten <= iCLK;

always @(*) begin
    if(is_usercode) begin
        if(wReadEnable)     wReadData <= wMemData_UserCode;
        else                wReadData <= 32'b1;
    end
    else if(is_userdata) begin
        if(wReadEnable)     wReadData <= wMemData_UserData;
        else                wReadData <= 32'b1;
    end
    else                    wReadData <= 32'hzzzzzzzz;
end

endmodule

