
`ifndef PARAM
	`include "Parametros.v"
`endif

`timescale 1 ns / 10 ps

module FPALU_tb;

reg ICLOCK;
reg [31:0] IA, IB;
reg [4:0] ICONTROL;
reg ISTART;
wire [31:0] ORESULT;
wire OREADY;


always
	#10 ICLOCK = ~ICLOCK;	// T=10+10 Clock de 50MHz

FPALU fpalu0 (
	.iclock(ICLOCK),
	.idataa(IA),
	.idatab(IB),
	.icontrol(ICONTROL),
	.istart(ISTART),
	.oresult(ORESULT),
	.oready(OREADY)
	);

	
initial
	begin
	
		$display($time, " << Início da Simulação >> ");
		ICLOCK=1'b0;
		ISTART=1'b1;

		IA = 32'h3F800000; // 1.0
		IB = 32'h40000000; // 2.0
		ICONTROL = FOPADD;
	
		#20 
		IA = 32'h40000000;  //2.0 
		IB = 32'h40800000;  // 4.0
		ICONTROL = FOPSUB;
		
		#20
		IA = 32'h40400000;  //3.0
		IB = 32'h3FC00000;  // 1.5
		ICONTROL = FOPMUL;
		
		#20
		IA = 32'h40000000; // 3.0
		IB = 32'h40400000; // 2.0
		ICONTROL = FOPDIV;

		#20
		IA = 32'h41500000; // 13.0
		IB = 32'h0;
		ICONTROL = FOPSQRT;

		#20
		IA = 32'hBF800000;  //-1.0
		IB = 32'h0;
		ICONTROL = FOPABS;
		
		#20
		IA = 32'h3F800000;  //1.0
		IB = 32'h3F800000;  //1.0
		ICONTROL = FOPCEQ;
		
		#20
		IA = 32'h3F800000;  // 1.0
		IB = 32'h40000000;  //2.0
		ICONTROL = FOPCLT;
		
		#20
		IA = 32'hBF800000;  // -1.0
		IB = 32'h3F800000;  // 1.0
		ICONTROL = FOPCLE;
		
		#20
		IA = 32'h4;			// 4
		IB = 32'h0;
		ICONTROL = FOPCVTSW;

		#20
		IA = 32'h40800000; // 4.0
		IB = 32'h0;
		ICONTROL = FOPCVTWS;
		
		#20
		$display($time, "<< Final da Simulação >>");
		$stop;
	end

	
initial
	begin
	
		$display("                 time, iA,       iB,       iControl, oResult,      oready"); 
		$monitor("%d,  %h, %h, %d,       %h,           %b",$time, IA, IB, ICONTROL, ORESULT, OREADY);
	
	end


endmodule
