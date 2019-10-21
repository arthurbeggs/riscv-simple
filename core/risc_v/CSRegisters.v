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
reg  [31:0] registers[17:0];
integer i;

initial begin // zera o banco de registradores
    for (i = 0; i <= 17; i = i + 1) registers[i] = 32'b0;
end

// Mapeia endereço dos CSRs para os registradores reais
// registers[0]     = 32'b0
// registers[1]     = CSR[0]    = ustatus
// registers[2]     = CSR[1]    = fflags
// registers[3]     = CSR[2]    = frm
// registers[4]     = CSR[3]    = fcsr
// registers[5]     = CSR[4]    = uie
// registers[6]     = CSR[5]    = utvec
// registers[7]     = CSR[64]   = uscratch
// registers[8]     = CSR[65]   = uepc
// registers[9]     = CSR[66]   = ucause
// registers[10]    = CSR[67]   = utval
// registers[11]    = CSR[68]   = uip
// registers[12]    = CSR[3072] = cycle
// registers[13]    = CSR[3073] = time
// registers[14]    = CSR[3074] = instret
// registers[15]    = CSR[3200] = cycleh
// registers[16]    = CSR[3201] = timeh
// registers[17]    = CSR[3202] = instreth
always @(*) begin
    case(register_read_address)
        12'd0:      real_read_address <= 5'd1;
        12'd1:      real_read_address <= 5'd2;
        12'd2:      real_read_address <= 5'd3;
        12'd3:      real_read_address <= 5'd4;
        12'd4:      real_read_address <= 5'd5;
        12'd5:      real_read_address <= 5'd6;
        12'd64:     real_read_address <= 5'd7;
        12'd65:     real_read_address <= 5'd8;
        12'd66:     real_read_address <= 5'd9;
        12'd67:     real_read_address <= 5'd10;
        12'd68:     real_read_address <= 5'd11;
        12'd3072:   real_read_address <= 5'd12;
        12'd3073:   real_read_address <= 5'd13;
        12'd3074:   real_read_address <= 5'd14;
        12'd3200:   real_read_address <= 5'd15;
        12'd3201:   real_read_address <= 5'd16;
        12'd3202:   real_read_address <= 5'd17;
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
        12'd3072:   real_debug_address <= 5'd12;
        12'd3073:   real_debug_address <= 5'd13;
        12'd3074:   real_debug_address <= 5'd14;
        12'd3200:   real_debug_address <= 5'd15;
        12'd3201:   real_debug_address <= 5'd16;
        12'd3202:   real_debug_address <= 5'd17;
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
        for (i = 0; i <= 17; i = i + 1) registers[i] <= 32'h00000000;
    end
    else begin
        i <= 0; // para não dar warning
        registers[12]   <= cycles_counter[31:0];    // cycle
        registers[13]   <= time_counter[31:0];      // time
        registers[14]   <= instret_counter[31:0];   // time
        registers[15]   <= cycles_counter[63:32];   // cycleh
        registers[16]   <= time_counter[63:32];     // timeh
        registers[17]   <= instret_counter[63:32];  // timeh
        if(iRegWriteSimu) begin
            registers[7] <= iWriteDataUEPC;
            registers[8] <= iWriteDataUCAUSE;
            registers[9] <= iWriteDataUTVAL;
        end
        else if(iRegWrite && (real_write_address != 5'd0)) begin
            registers[real_write_address] <= iWriteData;
        end
    end
end

endmodule

