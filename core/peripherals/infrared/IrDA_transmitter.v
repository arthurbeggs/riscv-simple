module IrDA_transmitter(
					iCLK,         //clk 50MHz
					SINAL,			//sinal irda
					iDATA,         //data input
					iTXD_READY,	  //start bit
					oTXD_BUSY,	  //transmitter sending
					oIRDA_TXD    //transmitter coded signal
);


//=======================================================
//  PARAMETER declarations
//=======================================================
parameter IDLE               = 3'b000;
parameter GUIDANCE_HIGH      = 3'b001;
parameter GUIDANCE_LOW       = 3'b011;
parameter DATA				 	  = 3'b111;
parameter GAP0           	  = 3'b110;
parameter GAP1           	  = 3'b100;
parameter END					  = 3'b101;

parameter GUIDE_HIGH_TIME		  = 450000;	  // 9ms low voltage
parameter GUIDE_LOW_TIME 		  = 225000;	  // 4.5ms high voltage

parameter GAP0_TIME				= 28125; // 562.5us gap para enviar um '0'
parameter GAP1_TIME 				= 84375; //1.6875ms gap para enviar um '1'

parameter PULSE_TIME				= 28125; //562.5us final

//=======================================================
//  PORT declarations
//=======================================================
input 		iCLK;         //clk 50MHz
input			[31:0] iDATA;        //data input
input 		iTXD_READY;	  //start bit
input			SINAL;
output 		oTXD_BUSY;	  //transmitter sending
output 		oIRDA_TXD;    //transmitter coded signal




//=======================================================
//  Signal Declarations
//=======================================================
reg guideH_count_flag;
reg [18:0] guideH_count;
reg guideL_count_flag;
reg [18:0] guideL_count;
reg data_cont_flag;
reg [18:0] data_count;
reg gap0_cont_flag;
reg [18:0] gap0_cont;
reg gap1_cont_flag;
reg [18:0] gap1_cont;

reg txd_busy;
reg txd_signal;
reg txd_ready;

reg [2:0] state;
reg [5:0] bitcount;

reg start_flag;
reg start_control_flag;
reg start;
//=======================================================;
//  Structural coding
//=======================================================
assign oTXD_BUSY = txd_busy;
assign oIRDA_TXD = txd_signal;

always @ ( posedge iCLK ) begin
	if (start_flag == start_control_flag) begin
		start_control_flag = ~ start_control_flag;
		start <=  1'b1;
	end else begin
		start <= 0;
	end
end

always @ ( posedge iTXD_READY ) begin
	start_flag = ~start_flag;
end

always @ (posedge iCLK ) begin
	if (guideH_count_flag) begin
		guideH_count <= guideH_count + 1'b1;
	end else begin
		guideH_count <= 0;
	end
end


always @ ( posedge iCLK ) begin
	if ((state == GUIDANCE_HIGH)) begin
		guideH_count_flag <= 1'b1;
	end
	else begin
		guideH_count_flag <= 1'b0;
	end
end

always @ (posedge iCLK ) begin
	if (guideL_count_flag) begin
		guideL_count <= guideL_count + 1'b1;
	end else begin
		guideL_count <= 0;
	end
end


always @ ( posedge iCLK ) begin
	if (state == GUIDANCE_LOW) begin
		guideL_count_flag <= 1'b1;
	end
	else begin
		guideL_count_flag <= 1'b0;
	end
end


always @ ( posedge iCLK) begin
	if (data_cont_flag) begin
		data_count <= data_count + 1'b1;
	end
	else begin
		data_count <= 0;
	end
end

always @ ( posedge iCLK ) begin
	 if (state == DATA) begin
	 	data_cont_flag <= 1'b1;
	 end
	 else begin
	 	data_cont_flag <= 1'b0;
	 end
end


always @ ( posedge iCLK) begin
	if (gap0_cont_flag) begin
		gap0_cont <= gap0_cont + 1'b1;
	end
	else begin
		gap0_cont <= 0;
	end
end

always @ ( posedge iCLK ) begin
	 if (state == GAP0) begin
	 	gap0_cont_flag <= 1'b1;
	 end
	 else begin
	 	gap0_cont_flag <= 1'b0;
	 end
end


always @ ( posedge iCLK) begin
	if (gap1_cont_flag) begin
		gap1_cont <= gap1_cont + 1'b1;
	end
	else begin
		gap1_cont <= 0;
	end
end

always @ ( posedge iCLK ) begin
	 if (state == GAP1) begin
	 	gap1_cont_flag <= 1'b1;
	 end
	 else begin
	 	gap1_cont_flag <= 1'b0;
	 end
end



always @ ( posedge iCLK ) begin
	case (state)
		IDLE: if (start) begin
			state <= GUIDANCE_HIGH;
			bitcount <= 0;
		end

		GUIDANCE_HIGH: if (guideH_count >  GUIDE_HIGH_TIME) begin
			state <= GUIDANCE_LOW;
		end

		GUIDANCE_LOW: if (guideL_count >  GUIDE_LOW_TIME) begin
			state <= DATA;
		end

		DATA: if (data_count > PULSE_TIME) begin
			if (bitcount > 31) begin
				state <= END;
			end else begin
				if (iDATA[bitcount] == 0) begin
					state <= GAP0;
				end else begin
					state <= GAP1;
				end
			end
			bitcount <= bitcount + 1'b1;
		end

		GAP0: if (gap0_cont > GAP0_TIME) begin
			state <= DATA;
		end

		GAP1: if (gap1_cont > GAP1_TIME) begin
			state <= DATA;
		end

		END:
			state <= IDLE;

		default:state <= IDLE ;
	endcase
end


always @ ( posedge iCLK ) begin
	case (state)
		IDLE:
			txd_busy <= 1'b0;

		GUIDANCE_HIGH:
		begin
			txd_signal <= SINAL;
			txd_busy <= 1'b1;
		end
		GUIDANCE_LOW:
			txd_signal <= 0;

		DATA:
			txd_signal <= SINAL;

		GAP0:
			txd_signal <= 0;

		GAP1:
			txd_signal <= 0;

		END:
			txd_busy <= 1'b0;

		default:
		begin
			txd_busy <= 1'b0;
			txd_signal <= 0;
		end
	endcase
end

endmodule
