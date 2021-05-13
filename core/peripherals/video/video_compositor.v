///////////////////////////////////////////////////////////////////////////////
//                      uCHARLES - Compositor de Vídeo                       //
//                                                                           //
//          Código fonte em https://github.com/arthurbeggs/uCHARLES          //
//                            BSD 3-Clause License                           //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module video_compositor (
    input  [9:0] pixel_x_pos,
    input  [9:0] pixel_y_pos,
    input  [7:0] pixel_frame0,
    input  [7:0] pixel_frame1,

    input  frame_select_memory,
    input  frame_select_switch,
    input  osd_enable,
    input  osd_select_regfile,
    output reg [ 4:0] reg_debug_address,
    output reg [11:0] csr_debug_address,
    input  [31:0] reg_debug_data,
    input  [31:0] fp_reg_debug_data,
    input  [31:0] csr_debug_data,
    input  [31:0] pc,
    input  [31:0] inst,

    output reg [7:0] pixel_red,
    output reg [7:0] pixel_green,
    output reg [7:0] pixel_blue
);

localparam OSD_LINE_START   = 10'd24;
localparam OSD_LINE_END     = 10'd455;
localparam OSD_COLUMN_START = 10'd60;
localparam OSD_COLUMN_END   = 10'd579;

reg  [7:0] mem_data_red;
reg  [7:0] mem_data_green;
reg  [7:0] mem_data_blue;
reg  draw_char_pixel;
reg  frame_selected;
reg  is_osd_area;

// XOR dos seletores de frame por memória e switch
assign frame_selected = frame_select_memory ^ frame_select_switch;

always @ (*) begin
    if (   (pixel_y_pos >= OSD_LINE_START)   && (pixel_y_pos <= OSD_LINE_END)
        && (pixel_x_pos >= OSD_COLUMN_START) && (pixel_x_pos <= OSD_COLUMN_END))
    begin
        is_osd_area = 1'b1;
    end
    else is_osd_area = 1'b0;
end

// Seleção do frame
always @ (*) begin
    if (frame_selected == 1'b0) begin
        mem_data_red    = (pixel_frame0 & 8'b00000111) << 3'd5;
        mem_data_green  = (pixel_frame0 & 8'b00111000) << 3'd2;
        mem_data_blue   = (pixel_frame0 & 8'b11000000);
    end
    else begin
        mem_data_red    = (pixel_frame1 & 8'b00000111) << 3'd5;
        mem_data_green  = (pixel_frame1 & 8'b00111000) << 3'd2;
        mem_data_blue   = (pixel_frame1 & 8'b11000000);
    end
end


`ifdef SIMULATION
    initial begin
        reg_debug_address   <= 5'b0;
        csr_debug_address   <= 12'b0;
    end

    always @ (*) begin
        pixel_red   = mem_data_red;
        pixel_green = mem_data_green;
        pixel_blue  = mem_data_blue;
    end

`else
// OSD de depuração
always @ (*) begin
    if (~osd_enable) begin
        pixel_red   = mem_data_red;
        pixel_green = mem_data_green;
        pixel_blue  = mem_data_blue;
    end
    else begin
        if (~is_osd_area) begin
            pixel_red   = mem_data_red;
            pixel_green = mem_data_green;
            pixel_blue  = mem_data_blue;
        end
        else begin
            if (draw_char_pixel) begin
                pixel_red   = 8'hD5;
                pixel_green = 8'hC4;
                pixel_blue  = 8'hA1;
            end
            else begin
                pixel_red   = mem_data_red   >> 3;
                pixel_green = mem_data_green >> 3;
                pixel_blue  = mem_data_blue  >> 3;
            end
        end
    end
end

///////////////////////////////////////////////////////////////////////////////
//                Mapeamento do On Screen Display de depuração               //
///////////////////////////////////////////////////////////////////////////////

// O OSD tem 24 linhas e 52 colunas de caracteres.
// Cada caracter possui 8px de largura e 16 de altura, além de 1px de borda nos
//    quatro lados. Então cada célula efetivamente tem 10x18px.
localparam CELL_WIDTH  = 4'd10;
localparam CELL_HEIGHT = 5'd18;

localparam C_0 = 6'h00; // 0
localparam C_1 = 6'h01; // 1
localparam C_2 = 6'h02; // 2
localparam C_3 = 6'h03; // 3
localparam C_4 = 6'h04; // 4
localparam C_5 = 6'h05; // 5
localparam C_6 = 6'h06; // 6
localparam C_7 = 6'h07; // 7
localparam C_8 = 6'h08; // 8
localparam C_9 = 6'h09; // 9
localparam C_A = 6'h10; // a
localparam C_B = 6'h11; // b
localparam C_C = 6'h12; // c
localparam C_D = 6'h13; // d
localparam C_E = 6'h14; // e
localparam C_F = 6'h15; // f
localparam C_G = 6'h16; // g
localparam C_H = 6'h17; // h
localparam C_I = 6'h18; // i
localparam C_J = 6'h19; // j
localparam C_K = 6'h1A; // k
localparam C_L = 6'h1B; // l
localparam C_M = 6'h1C; // m
localparam C_N = 6'h1D; // n
localparam C_O = 6'h1E; // o
localparam C_P = 6'h1F; // p
localparam C_Q = 6'h20; // q
localparam C_R = 6'h21; // r
localparam C_S = 6'h22; // s
localparam C_T = 6'h23; // t
localparam C_U = 6'h24; // u
localparam C_V = 6'h25; // v
localparam C_W = 6'h26; // w
localparam C_X = 6'h27; // x
localparam C_Y = 6'h28; // y
localparam C_Z = 6'h29; // z
localparam SPC = 6'h2A; // Espaço
localparam C__ = 6'h2B; // Indica que o dado deve ser recuperado de outra tabela

reg  [4:0] osd_line;
reg  [5:0] osd_column;
reg  [5:0] osd_character;
reg  [4:0] osd_cell_line;
reg  [3:0] osd_cell_column;
reg  [4:0] osd_cell_line_without_border;
reg  [3:0] osd_cell_column_without_border;
reg  [5:0] osd_cell_matrix [0:23] [0:51];
reg  [5:0] selected_character;

font font(
    .character  (osd_character),
    .line       (osd_cell_line_without_border[3:0]),
    .column     (osd_cell_column_without_border[2:0]),
    .draw_pixel (draw_char_pixel)
);

// Contador de linhas e colunas do OSD
always @ (*) begin
    if (is_osd_area) begin
        osd_line    = 5'((pixel_y_pos - OSD_LINE_START)   / CELL_HEIGHT);
        osd_column  = 6'((pixel_x_pos - OSD_COLUMN_START) / CELL_WIDTH);
    end
    else begin
        osd_line    = 5'b0;
        osd_column  = 6'b0;
    end
end

// Contador de linhas e colunas das células do OSD
always @ (*) begin
    if (is_osd_area) begin
        osd_cell_column  = 4'((pixel_x_pos - OSD_COLUMN_START) % CELL_WIDTH);
        osd_cell_line    = 5'((pixel_y_pos - OSD_LINE_START)   % CELL_HEIGHT);
    end
    else begin
        osd_cell_column  = 4'b0;
        osd_cell_line    = 5'b0;
    end
end

// Trata a borda de 1px dos caracteres
always @ (*) begin
    if (   (osd_cell_line > 4'd0)   && (osd_cell_line < (CELL_HEIGHT - 1'b1))
        && (osd_cell_column > 5'd0) && (osd_cell_column < (CELL_WIDTH - 1'b1)))
    begin
        osd_cell_column_without_border  = osd_cell_column - 1'b1;
        osd_cell_line_without_border    = osd_cell_line - 1'b1;
        osd_character                   = selected_character;
    end
    else begin
        osd_cell_column_without_border  = 4'b0;
        osd_cell_line_without_border    = 5'b0;
        osd_character                   = SPC;
    end
end

// Escolhe qual registrador será lido
always @ (*) begin
    if (osd_column < 6'd16) reg_debug_address[4] = 1'b0;
    else                    reg_debug_address[4] = 1'b1;
    case (osd_line)
        5'h02: reg_debug_address[3:0] = 4'h0;
        5'h03: reg_debug_address[3:0] = 4'h1;
        5'h04: reg_debug_address[3:0] = 4'h2;
        5'h05: reg_debug_address[3:0] = 4'h3;
        5'h06: reg_debug_address[3:0] = 4'h4;
        5'h07: reg_debug_address[3:0] = 4'h5;
        5'h08: reg_debug_address[3:0] = 4'h6;
        5'h09: reg_debug_address[3:0] = 4'h7;
        5'h0B: reg_debug_address[3:0] = 4'h8;
        5'h0C: reg_debug_address[3:0] = 4'h9;
        5'h0D: reg_debug_address[3:0] = 4'hA;
        5'h0E: reg_debug_address[3:0] = 4'hB;
        5'h0F: reg_debug_address[3:0] = 4'hC;
        5'h10: reg_debug_address[3:0] = 4'hD;
        5'h11: reg_debug_address[3:0] = 4'hE;
        5'h12: reg_debug_address[3:0] = 4'hF;
        default: reg_debug_address[3:0] = 4'b0;
    endcase
end

// Escolhe qual CSR será lido
always @ (*) begin
    case (osd_line)
        5'h02: csr_debug_address = 12'd0;
        5'h03: csr_debug_address = 12'd1;
        5'h04: csr_debug_address = 12'd2;
        5'h05: csr_debug_address = 12'd3;
        5'h06: csr_debug_address = 12'd4;
        5'h07: csr_debug_address = 12'd5;
        5'h08: csr_debug_address = 12'd64;
        5'h09: csr_debug_address = 12'd65;
        5'h0A: csr_debug_address = 12'd66;
        5'h0B: csr_debug_address = 12'd67;
        5'h0C: csr_debug_address = 12'd68;
        5'h0D: csr_debug_address = 12'd769;
        5'h0E: csr_debug_address = 12'd3072;
        5'h0F: csr_debug_address = 12'd3073;
        5'h10: csr_debug_address = 12'd3074;
        5'h11: csr_debug_address = 12'd3200;
        5'h12: csr_debug_address = 12'd3201;
        5'h13: csr_debug_address = 12'd3202;
        default: csr_debug_address = 12'b0;
    endcase
end

// Seleciona caracteres dos registradores
always @ (*) begin
    if (osd_cell_matrix[osd_line][osd_column] == C__) begin
        if (osd_line < 5'h14) begin
            if (~osd_select_regfile) begin
                case (osd_column)
                    6'h07: selected_character = {2'b0, reg_debug_data[31:28]};
                    6'h08: selected_character = {2'b0, reg_debug_data[27:24]};
                    6'h09: selected_character = {2'b0, reg_debug_data[23:20]};
                    6'h0A: selected_character = {2'b0, reg_debug_data[19:16]};
                    6'h0B: selected_character = {2'b0, reg_debug_data[15:12]};
                    6'h0C: selected_character = {2'b0, reg_debug_data[11:8]};
                    6'h0D: selected_character = {2'b0, reg_debug_data[7:4]};
                    6'h0E: selected_character = {2'b0, reg_debug_data[3:0]};
                    6'h16: selected_character = {2'b0, reg_debug_data[31:28]};
                    6'h17: selected_character = {2'b0, reg_debug_data[27:24]};
                    6'h18: selected_character = {2'b0, reg_debug_data[23:20]};
                    6'h19: selected_character = {2'b0, reg_debug_data[19:16]};
                    6'h1A: selected_character = {2'b0, reg_debug_data[15:12]};
                    6'h1B: selected_character = {2'b0, reg_debug_data[11:8]};
                    6'h1C: selected_character = {2'b0, reg_debug_data[7:4]};
                    6'h1D: selected_character = {2'b0, reg_debug_data[3:0]};
                    6'h2A: selected_character = {2'b0, csr_debug_data[31:28]};
                    6'h2B: selected_character = {2'b0, csr_debug_data[27:24]};
                    6'h2C: selected_character = {2'b0, csr_debug_data[23:20]};
                    6'h2D: selected_character = {2'b0, csr_debug_data[19:16]};
                    6'h2E: selected_character = {2'b0, csr_debug_data[15:12]};
                    6'h2F: selected_character = {2'b0, csr_debug_data[11:8]};
                    6'h30: selected_character = {2'b0, csr_debug_data[7:4]};
                    6'h31: selected_character = {2'b0, csr_debug_data[3:0]};
                    default: selected_character = SPC;
                endcase
            end
            else begin
                case (osd_column)
                    6'h07: selected_character = {2'b0, fp_reg_debug_data[31:28]};
                    6'h08: selected_character = {2'b0, fp_reg_debug_data[27:24]};
                    6'h09: selected_character = {2'b0, fp_reg_debug_data[23:20]};
                    6'h0A: selected_character = {2'b0, fp_reg_debug_data[19:16]};
                    6'h0B: selected_character = {2'b0, fp_reg_debug_data[15:12]};
                    6'h0C: selected_character = {2'b0, fp_reg_debug_data[11:8]};
                    6'h0D: selected_character = {2'b0, fp_reg_debug_data[7:4]};
                    6'h0E: selected_character = {2'b0, fp_reg_debug_data[3:0]};
                    6'h16: selected_character = {2'b0, fp_reg_debug_data[31:28]};
                    6'h17: selected_character = {2'b0, fp_reg_debug_data[27:24]};
                    6'h18: selected_character = {2'b0, fp_reg_debug_data[23:20]};
                    6'h19: selected_character = {2'b0, fp_reg_debug_data[19:16]};
                    6'h1A: selected_character = {2'b0, fp_reg_debug_data[15:12]};
                    6'h1B: selected_character = {2'b0, fp_reg_debug_data[11:8]};
                    6'h1C: selected_character = {2'b0, fp_reg_debug_data[7:4]};
                    6'h1D: selected_character = {2'b0, fp_reg_debug_data[3:0]};
                    6'h2A: selected_character = {2'b0, csr_debug_data[31:28]};
                    6'h2B: selected_character = {2'b0, csr_debug_data[27:24]};
                    6'h2C: selected_character = {2'b0, csr_debug_data[23:20]};
                    6'h2D: selected_character = {2'b0, csr_debug_data[19:16]};
                    6'h2E: selected_character = {2'b0, csr_debug_data[15:12]};
                    6'h2F: selected_character = {2'b0, csr_debug_data[11:8]};
                    6'h30: selected_character = {2'b0, csr_debug_data[7:4]};
                    6'h31: selected_character = {2'b0, csr_debug_data[3:0]};
                    default: selected_character = SPC;
                endcase
            end
        end
        else if (osd_line == 5'h14) begin
            case (osd_column)
                6'h07: selected_character = {2'b0, pc[31:28]};
                6'h08: selected_character = {2'b0, pc[27:24]};
                6'h09: selected_character = {2'b0, pc[23:20]};
                6'h0A: selected_character = {2'b0, pc[19:16]};
                6'h0B: selected_character = {2'b0, pc[15:12]};
                6'h0C: selected_character = {2'b0, pc[11:8]};
                6'h0D: selected_character = {2'b0, pc[7:4]};
                6'h0E: selected_character = {2'b0, pc[3:0]};
                default: selected_character = SPC;
            endcase
        end
        else if (osd_line == 5'h15) begin
            case (osd_column)
                5'h07: selected_character = {2'b0, inst[31:28]};
                5'h08: selected_character = {2'b0, inst[27:24]};
                5'h09: selected_character = {2'b0, inst[23:20]};
                5'h0A: selected_character = {2'b0, inst[19:16]};
                5'h0B: selected_character = {2'b0, inst[15:12]};
                5'h0C: selected_character = {2'b0, inst[11:8]};
                5'h0D: selected_character = {2'b0, inst[7:4]};
                5'h0E: selected_character = {2'b0, inst[3:0]};
                default: selected_character = SPC;
            endcase
        end
        else selected_character = SPC;
    end
    else begin
        selected_character = osd_cell_matrix[osd_line][osd_column];
    end
end

// Bloco de memória
// always @ (posedge clock) begin
always @ (*) begin
    if (~osd_select_regfile) begin
        osd_cell_matrix = '{
            '{SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC},
            '{SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC},
            '{SPC, SPC, C_Z, C_E, C_R, C_O, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, C_A, C_6, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_U, C_S, C_T, C_A, C_T, C_U, C_S, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_R, C_A, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, C_A, C_7, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_F, C_F, C_L, C_A, C_G, C_S, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_S, C_P, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, C_S, C_2, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_F, C_R, C_M, SPC, SPC, SPC, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_G, C_P, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, C_S, C_3, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_F, C_C, C_S, C_R, SPC, SPC, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_T, C_P, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, C_S, C_4, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_U, C_I, C_E, SPC, SPC, SPC, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_T, C_0, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, C_S, C_5, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_U, C_T, C_V, C_E, C_C, SPC, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_T, C_1, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, C_S, C_6, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_U, C_S, C_C, C_R, C_A, C_T, C_C, C_H, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_T, C_2, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, C_S, C_7, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_U, C_E, C_P, C_C, SPC, SPC, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, C_U, C_C, C_A, C_U, C_S, C_E, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_S, C_0, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, C_S, C_8, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_U, C_T, C_V, C_A, C_L, SPC, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_S, C_1, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, C_S, C_9, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_U, C_I, C_P, SPC, SPC, SPC, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_A, C_0, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, C_S, C_1, C_0, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_M, C_I, C_S, C_A, SPC, SPC, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_A, C_1, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, C_S, C_1, C_1, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_C, C_Y, C_C, C_L, C_E, SPC, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_A, C_2, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, C_T, C_3, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_T, C_I, C_M, C_E, SPC, SPC, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_A, C_3, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, C_T, C_4, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_I, C_N, C_S, C_T, C_R, C_E, C_T, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_A, C_4, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, C_T, C_5, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_C, C_Y, C_C, C_L, C_E, C_H, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_A, C_5, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, C_T, C_6, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_T, C_I, C_M, C_E, C_H, SPC, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, C_I, C_N, C_S, C_T, C_R, C_E, C_T, C_H, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_P, C_C, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC},
            '{SPC, SPC, C_I, C_N, C_S, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC},
            '{SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC},
            '{SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC}
        };
    end
    else begin
        osd_cell_matrix = '{
            '{SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC},
            '{SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC},
            '{SPC, SPC, C_F, C_T, C_0, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_F, C_A, C_6, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_U, C_S, C_T, C_A, C_T, C_U, C_S, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_F, C_T, C_1, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_F, C_A, C_7, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_F, C_F, C_L, C_A, C_G, C_S, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_F, C_T, C_2, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_F, C_S, C_2, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_F, C_R, C_M, SPC, SPC, SPC, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_F, C_T, C_3, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_F, C_S, C_3, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_F, C_C, C_S, C_R, SPC, SPC, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_F, C_T, C_4, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_F, C_S, C_4, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_U, C_I, C_E, SPC, SPC, SPC, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_F, C_T, C_5, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_F, C_S, C_5, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_U, C_T, C_V, C_E, C_C, SPC, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_F, C_T, C_6, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_F, C_S, C_6, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_U, C_S, C_C, C_R, C_A, C_T, C_C, C_H, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_F, C_T, C_7, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_F, C_S, C_7, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_U, C_E, C_P, C_C, SPC, SPC, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, C_U, C_C, C_A, C_U, C_S, C_E, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_F, C_S, C_0, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_F, C_S, C_8, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_U, C_T, C_V, C_A, C_L, SPC, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_F, C_S, C_1, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_F, C_S, C_9, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_U, C_I, C_P, SPC, SPC, SPC, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_F, C_A, C_0, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_F, C_S, C_1, C_0, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_M, C_I, C_S, C_A, SPC, SPC, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_F, C_A, C_1, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_F, C_S, C_1, C_1, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_C, C_Y, C_C, C_L, C_E, SPC, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_F, C_A, C_2, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_F, C_T, C_8, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_T, C_I, C_M, C_E, SPC, SPC, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_F, C_A, C_3, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_F, C_T, C_9, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_I, C_N, C_S, C_T, C_R, C_E, C_T, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_F, C_A, C_4, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_F, C_T, C_1, C_0, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_C, C_Y, C_C, C_L, C_E, C_H, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_F, C_A, C_5, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_F, C_T, C_1, C_1, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, C_T, C_I, C_M, C_E, C_H, SPC, SPC, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, C_I, C_N, C_S, C_T, C_R, C_E, C_T, C_H, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
            '{SPC, SPC, C_P, C_C, SPC, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC},
            '{SPC, SPC, C_I, C_N, C_S, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC},
            '{SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC},
            '{SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC}
        };
    end
end
`endif

endmodule

