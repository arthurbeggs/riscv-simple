///////////////////////////////////////////////////////////////////////////////
//               RISC-V SiMPLE - Interface da Memória de Vídeo               //
//                                                                           //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple        //
//                            BSD 3-Clause License                           //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module framebuffer_interface (
    input  clock_core,
    input  clock_memory,
    input  clock_video,
    input  reset,

    output reg [31:0] bus_data_fetched,
    input  [31:0] bus_address,
    input  [31:0] bus_write_data,
    input  [3:0]  bus_byte_enable,
    input  bus_read_enable,
    input  bus_write_enable,

    input  [9:0]  pixel_x_pos,
    input  [9:0]  pixel_y_pos,
    output reg [7:0]  pixel_frame0,
    output reg [7:0]  pixel_frame1,
    output reg frame_select
);

wire [31:0] frame0_bus_data_fetched;
wire [31:0] frame0_vga_data_fetched;
reg  [31:0] frame0_vga_shifted;
wire [31:0] frame1_bus_data_fetched;
wire [31:0] frame1_vga_data_fetched;
reg  [31:0] frame1_vga_shifted;
reg  [31:0] fetched;
reg  [31:0] read_pos_fix;
reg  [31:0] sign_fix;
wire [16:0] pixel_address;
reg  [3:0]  translated_byte_enable;
reg  [3:0]  byte_enable;
reg  frame0_write_enable;
reg  frame1_write_enable;
wire is_frame_0;
wire is_frame_1;
wire is_frame_select;

// A resolução da memória de vídeo é de 320x240, mas a saída VGA é de 640x480,
// então o LSB da posição do pixel é ignorado para desenhá-lo 4 vezes.
assign pixel_address = (10'd320 * pixel_y_pos[9:1]) + pixel_x_pos[9:1];

assign is_frame_0 = (bus_address >= BEGINNING_VGA0) && (bus_address <= END_VGA0);
assign is_frame_1 = (bus_address >= BEGINNING_VGA1) && (bus_address <= END_VGA1);
assign is_frame_select = (bus_address == FRAMESELECT);

framebuffer_memory frame0 (
    .address_a      (bus_address[16:2]),
    .address_b      (pixel_address[16:2]),
    .byteena_a      (byte_enable),
    .clock_a        (clock_memory),
    .clock_b        (clock_video),
    .data_a         (bus_write_data),
    .data_b         (32'b0),
    .wren_a         (frame0_write_enable),
    .wren_b         (1'b0),
    .q_a            (frame0_bus_data_fetched),
    .q_b            (frame0_vga_data_fetched)
);

framebuffer_memory frame1 (
    .address_a      (bus_address[16:2]),
    .address_b      (pixel_address[16:2]),
    .byteena_a      (byte_enable),
    .clock_a        (clock_memory),
    .clock_b        (clock_video),
    .data_a         (bus_write_data),
    .data_b         (32'b0),
    .wren_a         (frame1_write_enable),
    .wren_b         (1'b0),
    .q_a            (frame1_bus_data_fetched),
    .q_b            (frame1_vga_data_fetched)
);

///////////////////////////////////////////////////////////////////////////////
//                            Leitura dos pixels                             //
///////////////////////////////////////////////////////////////////////////////
// TODO: Entender a black magic do desalinhamento dos pixels
always @ (*) begin
    case (pixel_address[1:0])
        2'b00: pixel_frame0 = frame0_vga_data_fetched[31:24];
        2'b01: pixel_frame0 = frame0_vga_data_fetched[7:0];
        2'b10: pixel_frame0 = frame0_vga_data_fetched[15:8];
        2'b11: pixel_frame0 = frame0_vga_data_fetched[23:16];

    endcase
end

always @ (*) begin
    case (pixel_address[1:0])
        2'b00: pixel_frame1 = frame1_vga_data_fetched[31:24];
        2'b01: pixel_frame1 = frame1_vga_data_fetched[7:0];
        2'b10: pixel_frame1 = frame1_vga_data_fetched[15:8];
        2'b11: pixel_frame1 = frame1_vga_data_fetched[23:16];
    endcase
end

///////////////////////////////////////////////////////////////////////////////
//           Escrita dos buffers de vídeo via barramento de dados            //
///////////////////////////////////////////////////////////////////////////////

// Ignora a cor magenta (8'hC7)
always @ (*) begin
    byte_enable[0] = (bus_write_data[7:0]   == 8'hC7) ? 1'b0 : bus_byte_enable[0];
    byte_enable[1] = (bus_write_data[15:8]  == 8'hC7) ? 1'b0 : bus_byte_enable[1];
    byte_enable[2] = (bus_write_data[23:16] == 8'hC7) ? 1'b0 : bus_byte_enable[2];
    byte_enable[3] = (bus_write_data[31:24] == 8'hC7) ? 1'b0 : bus_byte_enable[3];
end

// Habilita escrita do buffer 0 na borda inferior do clock do processador
always @ (*) begin
    if (bus_write_enable && ~clock_core) begin
        if (is_frame_0) frame0_write_enable = 1'b1;
        else            frame0_write_enable = 1'b0;
    end
    else                frame0_write_enable = 1'b0;
end

// Habilita escrita do buffer 1 na borda inferior do clock do processador
always @ (*) begin
    if (bus_write_enable && ~clock_core) begin
        if (is_frame_1) frame1_write_enable = 1'b1;
        else            frame1_write_enable = 1'b0;
    end
    else                frame1_write_enable = 1'b0;
end

always @ (posedge clock_memory) begin
    if (bus_write_enable) begin
        if (is_frame_select)    frame_select <= (bus_write_data && 32'd1);
    end
end

///////////////////////////////////////////////////////////////////////////////
//           Leitura dos buffers de vídeo via barramento de dados            //
///////////////////////////////////////////////////////////////////////////////

// Seleciona o dado a ser passado para o barramento
always @ (*) begin
    if (is_frame_0)             fetched = frame0_bus_data_fetched;
    else if (is_frame_1)        fetched = frame1_bus_data_fetched;
    else if (is_frame_select)   fetched = {31'b0, frame_select};
    else                        fetched = 32'b1;
end

always @ (*) begin
    if (is_frame_0 || is_frame_1 || is_frame_select) begin
        if (bus_read_enable) bus_data_fetched = fetched;
        else                 bus_data_fetched = 32'b1;
    end
    else                     bus_data_fetched = 32'hzzzzzzzz;
end

endmodule

