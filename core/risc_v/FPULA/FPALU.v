/*
 * FPALU
 *
 */

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module FPALU (
    input  iclock,
    input  [31:0] idataa,
    input  [31:0] idatab,
    input  [ 4:0] icontrol,
    input  istart,
    output reg [31:0] oresult,
    output reg oready
);

//wire [4:0] icontrol = FOPADD;   // Para análise individual

reg  [ 4:0] ciclos;
wire [31:0] resultadd;
wire [31:0] resultmul;
wire [31:0] resultdiv;
wire [31:0] resultsqrt;
wire resultc_eq;
wire resultc_lt;
wire resultc_le;
wire [31:0] resultcvt_s_w;
wire [31:0] resultcvt_w_s;
wire [31:0] resultcvt_swu;
wire [31:0] resultcvt_wus;
wire [31:0] resultmax;
wire [31:0] resultmin;

always @(*) begin
    case (icontrol)
        FOPADD,
        FOPSUB:
        begin
            oresult <= resultadd;
            ciclos  <= 5'd6;
        end

        FOPMUL:
        begin
            oresult <= resultmul;
            ciclos  <= 5'd3;
        end

        FOPDIV:
        begin
            oresult <= resultdiv;
            ciclos  <= 5'd9;
        end

        FOPSQRT:
        begin
            oresult <= resultsqrt;
            ciclos  <= 5'd6;
        end

        FOPABS:
        begin
            oresult <= {1'b0,idataa[30:0]};
            ciclos  <= 5'd1;
        end

        FOPCEQ:
        begin
            oresult <=  {30'b0,resultc_eq};
            ciclos  <= 5'd3;
        end

        FOPCLT:
        begin
            oresult <=  {30'b0,resultc_lt};
            ciclos  <= 5'd3;
        end

        FOPCLE:
        begin
            oresult <=  {30'b0,resultc_le};
            ciclos  <= 5'd3;
        end

        FOPCVTSW:
        begin
            oresult <= resultcvt_s_w;
            ciclos  <= 5'd4;
        end

        FOPCVTWS:
        begin
            oresult <= resultcvt_w_s;
            ciclos  <= 5'd2;
        end

        FOPCVTSWU:
        begin
            oresult <= resultcvt_swu;
            ciclos  <= 5'd4;
        end

        FOPCVTWUS:
        begin
            oresult <= resultcvt_wus;
            ciclos  <= 5'd2;
        end

        FOPMV:
        begin
            oresult <= idataa;
            ciclos  <= 5'd1;
        end

        FOPSGNJ:
        begin
            oresult <= {idatab[31], idataa[30:0]};
            ciclos  <= 5'd1;
        end

        FOPSGNJN:
        begin
            oresult <= {~idatab[31], idataa[30:0]};
            ciclos  <= 5'd1;
        end

        FOPSGNJX:
        begin
            oresult <= {(idatab[31] ^ idataa[31]), idataa[30:0]};
            ciclos  <= 5'd1;
        end

        FOPMAX:
        begin
            oresult <= resultmax;
            ciclos  <= 5'd1;
        end

        FOPMIN:
        begin
            oresult <= resultmin;
            ciclos  <= 5'd1;
        end

        FOPNULL:
        begin
            oresult <= 32'hEEEEEEEE;
            ciclos  <= 5'd1;
        end

        default:
        begin
            oresult <= 32'hEEEEEEEE;
            ciclos  <= 5'd1;
        end

    endcase
end


reg  [ 4:0] contador;
reg  reset;

initial begin
    contador    <= 5'b0;
    reset       <= 1'b1;
    oready      <= 1'b0;
end

always @(posedge iclock) begin
    if(~istart) begin
        contador    <= 5'b0;
        oready      <= 1'b0;
        reset       <= 1'b1;
    end
    else begin
        if(contador >= ciclos) begin
            contador    <= 5'b0;
            oready      <= 1'b1;
            reset       <= 1'b0;
        end
        else begin
            contador    <= contador + 1'b1;
            oready      <= 1'b0;
            reset       <= 1'b0;
        end
    end
end

add_sub add1 (
    .clk        (iclock),
    .areset     (reset),
    .a          (idataa),
    .b          (idatab),
    .q          (resultadd),
    .opSel      (icontrol == FOPADD)
);


mul_s mul1 (
    .clk        (iclock),
    .areset     (reset),
    .a          (idataa),
    .b          (idatab),
    .q          (resultmul)
);


div_s div1 (
    .clk        (iclock),
    .areset     (reset),
    .a          (idataa),
    .b          (idatab),
    .q          (resultdiv)
);


sqrt_s sqrt1 (
    .clk        (iclock),
    .areset     (reset),
    .a          (idataa),
    .q          (resultsqrt)
);


comp_s comp_s1 (
    .clock      (iclock),
    .aclr       (reset),
    .dataa      (idataa),
    .datab      (idatab),
    .aeb        (resultc_eq),
    .alb        (resultc_lt),
    .aleb       (resultc_le)
);


cvt_s_w cvt_s_w1 (
    .clk        (iclock),
    .areset     (reset),
    .a          (idataa),
    .q          (resultcvt_s_w)
);


cvt_w_s cvt_w_s1 (
    .clk        (iclock),
    .areset     (reset),
    .a          (idataa),
    .q          (resultcvt_w_s)
);


cvt_s_wu cvt_s_wu1 (
    .clk        (iclock),
    .areset     (reset),
    .a          (idataa),
    .q          (resultcvt_swu)
);


cvt_wu_s cvt_wu_s1 (
    .clk        (iclock),
    .areset     (reset),
    .a          (idataa),
    .q          (resultcvt_wus)
);


fmax_s fmax_s1 (
    .clk        (iclock),
    .areset     (reset),
    .a          (idataa),
    .b          (idatab),
    .q          (resultmax)
);


fmin_s fmin_s1 (
    .clk        (iclock),
    .areset     (reset),
    .a          (idataa),
    .b          (idatab),
    .q          (resultmin)
);


endmodule

