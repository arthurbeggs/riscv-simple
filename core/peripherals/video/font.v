///////////////////////////////////////////////////////////////////////////////
//          Fonte Spleen 8x16 parcialmente convertida para Verilog           //
//                                                                           //
//      https://github.com/fcambus/spleen/blob/master/spleen-5x16.bdf        //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module font(
    input  [4:0] character,
    input  [3:0] line,
    input  [2:0] column,
    output reg draw_pixel
);

reg  [127:0] selected_char;
reg  [7:0]   char_line;

// Fonte Spleen 8x16
always @ (*) begin
    case (character)
        5'h00: selected_char = 128'h00007CC6C6CEDEF6E6C6C67C00000000; // 0
        5'h01: selected_char = 128'h00001838785818181818187E00000000; // 1
        5'h02: selected_char = 128'h00007CC606060C183060C6FE00000000; // 2
        5'h03: selected_char = 128'h00007CC606063C060606C67C00000000; // 3
        5'h04: selected_char = 128'h0000C0C0CCCCCCCCFE0C0C0C00000000; // 4
        5'h05: selected_char = 128'h0000FEC6C0C0FC060606C67C00000000; // 5
        5'h06: selected_char = 128'h00007CC6C0C0FCC6C6C6C67C00000000; // 6
        5'h07: selected_char = 128'h0000FEC606060C183030303000000000; // 7
        5'h08: selected_char = 128'h00007CC6C6C67CC6C6C6C67C00000000; // 8
        5'h09: selected_char = 128'h00007CC6C6C6C67E0606C67C00000000; // 9
        5'h0A: selected_char = 128'h00007CC6C6C6FEC6C6C6C6C600000000; // A
        5'h0B: selected_char = 128'h0000FCC6C6C6FCC6C6C6C6FC00000000; // B
        5'h0C: selected_char = 128'h00007EC0C0C0C0C0C0C0C07E00000000; // C
        5'h0D: selected_char = 128'h0000FCC6C6C6C6C6C6C6C6FC00000000; // D
        5'h0E: selected_char = 128'h00007EC0C0C0F8C0C0C0C07E00000000; // E
        5'h0F: selected_char = 128'h00007EC0C0C0F8C0C0C0C0C000000000; // F
        5'h10: selected_char = 128'h00000000007C067EC6C6C67E00000000; // a
        5'h11: selected_char = 128'h00000000007EC0C0C0C0C07E00000000; // c
        5'h12: selected_char = 128'h00000000007EC6C6FEC0C07E00000000; // e
        5'h13: selected_char = 128'h00001E3030307C303030303000000000; // f
        5'h14: selected_char = 128'h00000000007EC6C6C6C6C67C0606FC00; // g
        5'h15: selected_char = 128'h00001818001818181818181800000000; // i
        5'h16: selected_char = 128'h0000000000FCC6C6C6C6C6C600000000; // n
        5'h17: selected_char = 128'h00000000007CC6C6C6C6C67C00000000; // o
        5'h18: selected_char = 128'h0000000000FCC6C6C6C6C6FCC0C0C000; // p
        5'h19: selected_char = 128'h00000000007EC6C0C0C0C0C000000000; // r
        5'h1A: selected_char = 128'h00000000007EC0C07C0606FC00000000; // s
        5'h1B: selected_char = 128'h00003030307C30303030301E00000000; // t
        5'h1C: selected_char = 128'h0000000000C6C6C6C6C6C67E00000000; // u
        5'h1D: selected_char = 128'h0000000000C66C38386CC6C600000000; // x
        5'h1E: selected_char = 128'h00000000000000000000000000000000; // Espaço
        // 5'h1F: selected_char = 128'h0000000000FE060C183060FE00000000; // z
        default: selected_char = 128'b0;
    endcase
end

// Seleção da linha do caracter
always @ (*) begin
    case (line)
        4'h0: char_line = selected_char[127:120];
        4'h1: char_line = selected_char[119:112];
        4'h2: char_line = selected_char[111:104];
        4'h3: char_line = selected_char[103:96];
        4'h4: char_line = selected_char[95:88];
        4'h5: char_line = selected_char[87:80];
        4'h6: char_line = selected_char[79:72];
        4'h7: char_line = selected_char[71:64];
        4'h8: char_line = selected_char[63:56];
        4'h9: char_line = selected_char[55:48];
        4'hA: char_line = selected_char[47:40];
        4'hB: char_line = selected_char[39:32];
        4'hC: char_line = selected_char[31:24];
        4'hD: char_line = selected_char[23:16];
        4'hE: char_line = selected_char[15:8];
        4'hF: char_line = selected_char[7:0];
        default: char_line = 8'b0;
    endcase
end

// Seleção do pixel
// Os bytes precisam ser lidos na ordem reversa, pois o .bdf descreve o caracter
//    da direita para a esquerda
always @ (*) begin
    case (column)
        3'h0: draw_pixel = char_line[7];
        3'h1: draw_pixel = char_line[6];
        3'h2: draw_pixel = char_line[5];
        3'h3: draw_pixel = char_line[4];
        3'h4: draw_pixel = char_line[3];
        3'h5: draw_pixel = char_line[2];
        3'h6: draw_pixel = char_line[1];
        3'h7: draw_pixel = char_line[0];
        default: draw_pixel = 1'b0;
    endcase
end

endmodule

