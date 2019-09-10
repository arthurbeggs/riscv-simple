`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif


module FRegisters (
    input wire          iCLK, iRST, iRegWrite,
    input wire  [4:0]   iReadRegister1, iReadRegister2, iWriteRegister,
    input wire  [31:0]  iWriteData,
    output wire [31:0]  oReadData1, oReadData2,

    input wire  [4:0]   iVGASelect, iRegDispSelect,
    output reg  [31:0]  oVGARead, oRegDisp
    );

/* FRegister file */
reg [31:0] registers[31:0];


reg [5:0] i;

initial
    begin
        for (i = 0; i <= 31; i = i + 1'b1)
            registers[i] = 32'h00000000;
    end


assign oReadData1 = registers[iReadRegister1];
assign oReadData2 = registers[iReadRegister2];

assign oRegDisp     =   registers[iRegDispSelect];
assign oVGARead     =   registers[iVGASelect];


`ifdef PIPELINE
    always @(negedge iCLK or posedge iRST)
`else
    always @(posedge iCLK or posedge iRST)
`endif
begin
    if (iRST)
    begin // reseta o banco de registradores
        for (i = 0; i <= 31; i = i + 1'b1)
            registers[i] <= 32'b0;
    end
    else
     begin
        i<=6'bx; // para não dar warning
        if(iRegWrite)
                registers[iWriteRegister] <= iWriteData;
     end
end

endmodule

