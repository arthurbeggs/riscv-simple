`ifndef PARAM
	`include "../Parametros.v"
`endif

module DataMemory_Interface (
    input wire      			iCLK, iCLKMem,
    //  Barramento de IO
    input wire       	 	wReadEnable, wWriteEnable,
    input wire		[3:0]  	wByteEnable,
    input wire		[31:0] 	wAddress, wWriteData,
    output logic	[31:0] 	wReadData
);


    wire        wMemWriteMB0,wMemReadMB0;
    wire [31:0] wMemDataMB0;
    wire        is_usermem;
    wire [31:0] usermem_add;
	 
UserDataBlock MB0 (
    .address(usermem_add[DATA_WIDTH-1:2]), // Memoria em words
    .byteena(wByteEnable),
    .clock(iCLKMem),
    .data(wWriteData),
    .wren(wMemWriteMB0),
	 .rden(wMemReadMB0),
    .q(wMemDataMB0)
);


    reg MemWritten;
    initial MemWritten <= 1'b0;
    always @(iCLK) MemWritten <= iCLK;
					

    assign is_usermem 	= wAddress >= BEGINNING_DATA  &&  wAddress <= END_DATA;       // Memoria usuario  .data
	 
	 assign usermem_add 	= wAddress - BEGINNING_DATA;

	 assign wMemReadMB0  = wReadEnable  && is_usermem;
	 
   assign wMemWriteMB0 	= ~MemWritten && wWriteEnable && is_usermem;              // Controle de escrita no MB0
//	 assign wMemWriteMB0 = wWriteEnable && is_usermem;
 
    always @(*)
        if(wReadEnable)
            begin
                if(is_usermem)  wReadData <= wMemDataMB0; else
                wReadData <= 32'hzzzzzzzz;
            end
        else
            wReadData <= 32'hzzzzzzzz;

endmodule
