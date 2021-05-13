`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module CSRegisters (
    input  core_clock,
    input  reset,
    input  iRegWrite,
    input  iRegWriteSimu,
    input  [11:0] register_read_address,
    input  [11:0] register_write_address,
    input  [31:0] iWriteData,
    input  [31:0] iWriteDataUEPC,   // registradores especiais precisam de acesso simultaneo
    input  [31:0] iWriteDataUCAUSE, // registradores especiais precisam de acesso simultaneo
    input  [31:0] iWriteDataUTVAL,  // registradores especiais precisam de acesso simultaneo
    output [31:0] oReadData,
    output [31:0] oReadDataUTVEC,   // registradores especiais precisam de acesso simultaneo
    output [31:0] oReadDataUEPC,    // registradores especiais precisam de acesso simultaneo
    output [31:0] oReadDataUSTATUS, // registradores especiais precisam de acesso simultaneo
    output [31:0] oReadDataUTVAL,   // registradores especiais precisam de acesso simultaneo
    input  [63:0] cycles_counter,
    input  [63:0] time_counter,
    input  [63:0] instret_counter,

    input  [11:0] csr_debug_address,
    output reg [31:0] csr_debug_data
);

reg  [ 4:0] real_read_address;
reg  [ 4:0] real_write_address;
reg  [ 4:0] real_debug_address;
reg  [31:0] registers[18:0];
integer i;

initial begin // zera o banco de registradores
    for (i = 0; i <= 18; i = i + 1) registers[i] = 32'b0;
`ifdef RV32IM
    registers[12] = 32'h40001100; // misa
`elsif RV32IMF
    registers[12] = 32'h40001120; // misa
`else
    registers[12] = 32'h40000100; // misa
`endif
end

always @(*) begin
    case(register_read_address)
        12'd0:      real_read_address <= 5'd1;  // ustatus
        12'd1:      real_read_address <= 5'd2;  // fflags
        12'd2:      real_read_address <= 5'd3;  // frm
        12'd3:      real_read_address <= 5'd4;  // fcsr
        12'd4:      real_read_address <= 5'd5;  // uie
        12'd5:      real_read_address <= 5'd6;  // utvec
        12'd64:     real_read_address <= 5'd7;  // uscratch
        12'd65:     real_read_address <= 5'd8;  // uepc
        12'd66:     real_read_address <= 5'd9;  // ucause
        12'd67:     real_read_address <= 5'd10; // utval
        12'd68:     real_read_address <= 5'd11; // uip
        12'd769:    real_read_address <= 5'd12; // misa
        12'd3072:   real_read_address <= 5'd13; // cycle
        12'd3073:   real_read_address <= 5'd14; // time
        12'd3074:   real_read_address <= 5'd15; // instret
        12'd3200:   real_read_address <= 5'd16; // cycleh
        12'd3201:   real_read_address <= 5'd17; // timeh
        12'd3202:   real_read_address <= 5'd18; // instreth
        default:    real_read_address <= 5'd0;
    endcase

    case(register_write_address)
        12'd0:      real_write_address <= 5'd1;
        12'd1:      real_write_address <= 5'd2;
        12'd2:      real_write_address <= 5'd3;
        12'd3:      real_write_address <= 5'd4;
        12'd4:      real_write_address <= 5'd5;
        12'd5:      real_write_address <= 5'd6;
        12'd64:     real_write_address <= 5'd7;
        12'd65:     real_write_address <= 5'd8;
        12'd66:     real_write_address <= 5'd9;
        12'd67:     real_write_address <= 5'd10;
        12'd68:     real_write_address <= 5'd11;
        12'd769:    real_write_address <= 5'd12;
        12'd3072:   real_write_address <= 5'd0;     // Read Only
        12'd3073:   real_write_address <= 5'd0;     // Read Only
        12'd3074:   real_write_address <= 5'd0;     // Read Only
        12'd3200:   real_write_address <= 5'd0;     // Read Only
        12'd3201:   real_write_address <= 5'd0;     // Read Only
        12'd3202:   real_write_address <= 5'd0;     // Read Only
        default:    real_write_address <= 5'd0;
    endcase

    case(csr_debug_address)
        12'd0:      real_debug_address <= 5'd1;
        12'd1:      real_debug_address <= 5'd2;
        12'd2:      real_debug_address <= 5'd3;
        12'd3:      real_debug_address <= 5'd4;
        12'd4:      real_debug_address <= 5'd5;
        12'd5:      real_debug_address <= 5'd6;
        12'd64:     real_debug_address <= 5'd7;
        12'd65:     real_debug_address <= 5'd8;
        12'd66:     real_debug_address <= 5'd9;
        12'd67:     real_debug_address <= 5'd10;
        12'd68:     real_debug_address <= 5'd11;
        12'd769:    real_debug_address <= 5'd12;
        12'd3072:   real_debug_address <= 5'd13;
        12'd3073:   real_debug_address <= 5'd14;
        12'd3074:   real_debug_address <= 5'd15;
        12'd3200:   real_debug_address <= 5'd16;
        12'd3201:   real_debug_address <= 5'd17;
        12'd3202:   real_debug_address <= 5'd18;
        default:    real_debug_address <= 5'd0;
    endcase
end

assign oReadDataUSTATUS = registers[1];   // leitura simultanea em ustatus, utvec, uepc
assign oReadDataUTVEC   = registers[6];
assign oReadDataUEPC    = registers[8];
assign oReadDataUTVAL   = registers[10];
assign oReadData        = registers[real_read_address];
assign csr_debug_data   = registers[real_debug_address];

`ifdef PIPELINE
always @(negedge core_clock or posedge reset) begin
`else
always @(posedge core_clock or posedge reset) begin
`endif
    if (reset) begin // reseta o banco de registradores e pilha
        for (i = 0; i <= 18; i = i + 1) registers[i] <= 32'h00000000;
    `ifdef RV32IM
        registers[12] = 32'h40001100; // misa
    `elsif RV32IMF
        registers[12] = 32'h40001120; // misa
    `else
        registers[12] = 32'h40000100; // misa
    `endif
    end
    else begin
        i <= 0; // para não dar warning
        registers[13]   <= cycles_counter[31:0];    // cycle
        registers[14]   <= time_counter[31:0];      // time
        registers[15]   <= instret_counter[31:0];   // instret
        registers[16]   <= cycles_counter[63:32];   // cycleh
        registers[17]   <= time_counter[63:32];     // timeh
        registers[18]   <= instret_counter[63:32];  // instreth
        if(iRegWriteSimu) begin
            registers[8] <= iWriteDataUEPC;
            registers[9] <= iWriteDataUCAUSE;
            registers[10] <= iWriteDataUTVAL;
        end
        else if(iRegWrite && (real_write_address != 5'd0)) begin
            registers[real_write_address] <= iWriteData;
        end
    end
end

endmodule

