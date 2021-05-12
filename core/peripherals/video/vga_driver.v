///////////////////////////////////////////////////////////////////////////////
//                       uCHARLES - Driver de Vídeo VGA                      //
//                                                                           //
//          Código fonte em https://github.com/arthurbeggs/uCHARLES          //
//                            BSD 3-Clause License                           //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module vga_driver (
    input  clock,
    input  reset,

    input  [7:0] pixel_red,
    input  [7:0] pixel_green,
    input  [7:0] pixel_blue,

    output reg [9:0] pixel_x_pos,
    output reg [9:0] pixel_y_pos,

    output reg [7:0] vga_red,
    output reg [7:0] vga_green,
    output reg [7:0] vga_blue,
    output reg vga_clock,
    output reg vga_horizontal_sync,
    output reg vga_vertical_sync,
    output reg vga_blank,
    output reg vga_sync
);

// Parâmetros para resolução de 640x480@60Hz
// http://tinyvga.com/vga-timing/640x480@60Hz
// http://www.epanorama.net/documents/pc/vga_timing.html
// https://www.analog.com/media/en/technical-documentation/data-sheets/ADV7123.pdf
localparam X_ACTIVE_AREA        = 10'd640;
localparam X_FRONT_PORCH        = 10'd16;
localparam X_SYNC_PULSE         = 10'd96;
localparam X_BACK_PORCH         = 10'd48;
localparam X_START_SYNC_PULSE   = X_ACTIVE_AREA      + X_FRONT_PORCH;
localparam X_START_BACK_PORCH   = X_START_SYNC_PULSE + X_SYNC_PULSE;
localparam X_END_LINE           = X_START_BACK_PORCH + X_BACK_PORCH - 1'b1;

localparam Y_ACTIVE_AREA        = 10'd480;
localparam Y_FRONT_PORCH        = 10'd10;
localparam Y_SYNC_PULSE         = 10'd2;
localparam Y_BACK_PORCH         = 10'd33;
localparam Y_START_SYNC_PULSE   = Y_ACTIVE_AREA      + Y_FRONT_PORCH;
localparam Y_START_BACK_PORCH   = Y_START_SYNC_PULSE + Y_SYNC_PULSE;
localparam Y_END_FRAME          = Y_START_BACK_PORCH + Y_BACK_PORCH - 1'b1;

reg  [9:0] x_counter;
reg  [9:0] y_counter;
reg  is_x_active_area;
reg  is_y_active_area;
reg  is_x_sync;
reg  is_y_sync;

assign vga_clock        = clock;

assign is_x_active_area = (x_counter  <  X_ACTIVE_AREA);
assign is_y_active_area = (y_counter  <  Y_ACTIVE_AREA);
assign is_x_sync        = ((x_counter >= X_START_SYNC_PULSE) &&
                           (x_counter <  X_START_BACK_PORCH));
assign is_y_sync        = ((y_counter >= Y_START_SYNC_PULSE) &&
                           (y_counter <  Y_START_BACK_PORCH));

assign pixel_x_pos      = is_x_active_area ? x_counter : 10'b0;
assign pixel_y_pos      = is_y_active_area ? y_counter : 10'b0;

always @ (posedge clock) begin
    if (x_counter == X_END_LINE) begin
        x_counter   <= 10'b0;
    end
    else begin
        x_counter   <= x_counter + 1'b1;
    end
end

always @ (posedge clock) begin
    if (x_counter == X_END_LINE && y_counter == Y_END_FRAME) begin
        y_counter   <= 10'b0;
    end
    else if (x_counter == X_END_LINE) begin
        y_counter   <= y_counter + 1'b1;
    end
end

always @ (posedge clock) begin
    vga_horizontal_sync <= ~(is_x_sync);
    vga_vertical_sync   <= ~(is_y_sync);
    vga_blank           <= (is_x_active_area && is_y_active_area);
    vga_sync            <= (is_x_sync || is_y_sync);
end

always @ (*) begin
    vga_red     = pixel_red;
    vga_green   = pixel_green;
    vga_blue    = pixel_blue;
end

endmodule

