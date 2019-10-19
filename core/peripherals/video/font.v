///////////////////////////////////////////////////////////////////////////////
//          Fonte Spleen 8x16 parcialmente convertida para Verilog           //
//                                                                           //
//      https://github.com/fcambus/spleen/blob/master/spleen-5x16.bdf        //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module font(
    input  [5:0] character,
    input  [3:0] line,
    input  [2:0] column,
    output reg draw_pixel
);

reg  [127:0] selected_char;
reg  [7:0]   char_line;

// Fonte Spleen 8x16
always @ (*) begin
    case (character)
        6'h00: selected_char = 128'h00007CC6C6CEDEF6E6C6C67C00000000; // 0
        6'h01: selected_char = 128'h00001838785818181818187E00000000; // 1
        6'h02: selected_char = 128'h00007CC606060C183060C6FE00000000; // 2
        6'h03: selected_char = 128'h00007CC606063C060606C67C00000000; // 3
        6'h04: selected_char = 128'h0000C0C0CCCCCCCCFE0C0C0C00000000; // 4
        6'h05: selected_char = 128'h0000FEC6C0C0FC060606C67C00000000; // 5
        6'h06: selected_char = 128'h00007CC6C0C0FCC6C6C6C67C00000000; // 6
        6'h07: selected_char = 128'h0000FEC606060C183030303000000000; // 7
        6'h08: selected_char = 128'h00007CC6C6C67CC6C6C6C67C00000000; // 8
        6'h09: selected_char = 128'h00007CC6C6C6C67E0606C67C00000000; // 9
        6'h0A: selected_char = 128'h00007CC6C6C6FEC6C6C6C6C600000000; // A
        6'h0B: selected_char = 128'h0000FCC6C6C6FCC6C6C6C6FC00000000; // B
        6'h0C: selected_char = 128'h00007EC0C0C0C0C0C0C0C07E00000000; // C
        6'h0D: selected_char = 128'h0000FCC6C6C6C6C6C6C6C6FC00000000; // D
        6'h0E: selected_char = 128'h00007EC0C0C0F8C0C0C0C07E00000000; // E
        6'h0F: selected_char = 128'h00007EC0C0C0F8C0C0C0C0C000000000; // F
        6'h10: selected_char = 128'h00000000007C067EC6C6C67E00000000; // a
        6'h11: selected_char = 128'h0000C0C0C0FCC6C6C6C6C6FC00000000; // b
        6'h12: selected_char = 128'h00000000007EC0C0C0C0C07E00000000; // c
        6'h13: selected_char = 128'h00000606067EC6C6C6C6C67E00000000; // d
        6'h14: selected_char = 128'h00000000007EC6C6FEC0C07E00000000; // e
        6'h15: selected_char = 128'h00001E3030307C303030303000000000; // f
        6'h16: selected_char = 128'h00000000007EC6C6C6C6C67C0606FC00; // g
        6'h17: selected_char = 128'h0000C0C0C0FCC6C6C6C6C6C600000000; // h
        6'h18: selected_char = 128'h00001818001818181818181800000000; // i
        6'h19: selected_char = 128'h00001818001818181818181818187000; // j
        6'h1A: selected_char = 128'h0000C0C0C0CCD8F0F0D8CCC600000000; // k
        6'h1B: selected_char = 128'h00003030303030303030301C00000000; // l
        6'h1C: selected_char = 128'h0000000000ECD6D6D6D6C6C600000000; // m
        6'h1D: selected_char = 128'h0000000000FCC6C6C6C6C6C600000000; // n
        6'h1E: selected_char = 128'h00000000007CC6C6C6C6C67C00000000; // o
        6'h1F: selected_char = 128'h0000000000FCC6C6C6C6C6FCC0C0C000; // p
        6'h20: selected_char = 128'h00000000007EC6C6C6C6C67E06060600; // q
        6'h21: selected_char = 128'h00000000007EC6C0C0C0C0C000000000; // r
        6'h22: selected_char = 128'h00000000007EC0C07C0606FC00000000; // s
        6'h23: selected_char = 128'h00003030307C30303030301E00000000; // t
        6'h24: selected_char = 128'h0000000000C6C6C6C6C6C67E00000000; // u
        6'h25: selected_char = 128'h0000000000C6C6C6C66C381000000000; // v
        6'h26: selected_char = 128'h0000000000C6C6D6D6D6D66E00000000; // w
        6'h27: selected_char = 128'h0000000000C66C38386CC6C600000000; // x
        6'h28: selected_char = 128'h0000000000C6C6C6C6C6C67E0606FC00; // y
        6'h29: selected_char = 128'h0000000000FE060C183060FE00000000; // z
        6'h2A: selected_char = 128'h00000000000000000000000000000000; // Espaço
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

