module RegDisplay (
	input wire [ 9:0] ixCounter,
	input wire [ 9:0] iyCounter,
	input wire [ 7:0] iPixel,
	input wire [31:0] iData,
	input wire        iEnable,
	output reg [29:0] oPixel,
	output reg [ 4:0] oSelect
);

	wire [5:0] xPos = ixCounter[9:4];
	wire [4:0] yPos = iyCounter[8:4];

	wire [4:0] xOffset = (xPos < 6'd20) ? 5'd0 : 5'd16;
	wire [4:0] yOffset = (yPos < 5'd14) ? 5'd6 : 5'd8;

	assign oSelect = yPos - yOffset + xOffset;

	// assign oSelect = (xPos < 6'd20) ? yPos - 5'd6 : yPos - 5'd6 + 5'd16;

	// Selects nibble from word
	wire [2:0] NibbleSelect = xPos[2:0];

	wire [2:0] wLineSelect = iyCounter[3:1];
	wire [2:0] wPixelSelect = ixCounter[3:1];

wire [31:0] ResultData = iData;

	wire [3:0] ResultNibble;
	assign ResultNibble = NibbleSelect==3'd0 ? ResultData[31:28] :
								 NibbleSelect==3'd1 ? ResultData[27:24] :
								 NibbleSelect==3'd2 ? ResultData[23:20] :
								 NibbleSelect==3'd3 ? ResultData[19:16] :
								 NibbleSelect==3'd4 ? ResultData[15:12] :
								 NibbleSelect==3'd5 ? ResultData[11: 8] :
								 NibbleSelect==3'd6 ? ResultData[7 : 4] :
								 NibbleSelect==3'd7 ? ResultData[3 : 0] : 4'd0;
	
	wire wBit;
/*
	always @(*) begin
		case (NibbleSelect)
			3'd0: ResultNibble = ResultData[31:28];
			3'd1: ResultNibble = ResultData[27:24];
			3'd2: ResultNibble = ResultData[23:20];
			3'd3: ResultNibble = ResultData[19:16];
			3'd4: ResultNibble = ResultData[15:12];
			3'd5: ResultNibble = ResultData[11: 8];
			3'd6: ResultNibble = ResultData[ 7: 4];
			3'd7: ResultNibble = ResultData[ 3: 0];
		endcase
	end*/

	wire [9:0] iR = {iPixel[2:0], iPixel[2:0], iPixel[2:0], iPixel[2]}; // 3 bits R
	wire [9:0] iG = {iPixel[5:3], iPixel[5:3], iPixel[5:3], iPixel[5]}; // 3 bits G
	wire [9:0] iB = {iPixel[7:6], iPixel[7:6], iPixel[7:6], iPixel[7:6], iPixel[7:6]}; // 2 bits B

	wire [29:0] ePixel = {iB, iG, iR};

	HexFont HexF0 (
		.iNibble(ResultNibble),
		.iLineSelect(wLineSelect),
		.iPixelSelect(wPixelSelect),
		.oPixel(wBit)
	);

	wire [29:0] wPixel = {30{wBit}};

	wire [29:0] mPixel = wBit ? wPixel : {wPixel[29:28], ePixel[27:20], wPixel[19:18], ePixel[17:10], wPixel[9:8], ePixel[7:0]};
	wire [29:0] bPixel = {2'b0, ePixel[27:20], 2'b0, ePixel[17:10], 2'b0, ePixel[7:0]};

	always @(*) begin
		if (iEnable) begin
			if (yPos == 5'd5 || yPos == 5'd14 || yPos == 5'd15 || yPos == 5'd24) begin
				if ((xPos >= 6'd7 && xPos <= 6'd16) || (xPos >= 6'd23 && xPos <= 6'd32)) begin
					oPixel = bPixel;
				end
				else begin
					oPixel = ePixel;
				end
			end
			else if ((yPos >= 5'd6 && yPos <= 5'd13) || (yPos >= 5'd16 && yPos <= 5'd23)) begin
				if (xPos == 6'd7 || xPos == 6'd16 || xPos == 6'd23 || xPos == 6'd32) begin
					oPixel = bPixel;
				end
				else if (xPos >= 6'd8 && xPos <= 6'd15) begin
					oPixel = mPixel;
				end
				else if (xPos >= 6'd24 && xPos <= 6'd31) begin
					oPixel = mPixel;
				end
				else begin
					oPixel = ePixel;
				end
			end
			else begin
				oPixel = ePixel;
			end
		end
		else begin
			oPixel = ePixel;
		end
	end

endmodule
