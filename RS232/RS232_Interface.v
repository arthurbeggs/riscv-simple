module RS232_Interface(
    input         iCLK_50,
    input         iCLK,
    input         Reset,
    output        oUART_TXD,    //    UART Transmitter
    input         iUART_RXD,    //    UART Receiver
//    output        oUART_CTS,    //    UART Clear To Send
//    input         iUART_RTS,    //    UART Request To Send
    //  Barramento de IO
    input         wReadEnable, wWriteEnable,
    input  [3:0]  wByteEnable,
    input  [31:0] wAddress, wWriteData,
    output [31:0] wReadData
);


reg  [7:0]  RxData, RxDataAux;
wire [7:0]  wTxData;
reg         wPulsoRxSin;        // fio de pulso
reg  [7:0]  RsControl;          // 5 bits inuteis, 1 bit ready, 1 bit busy e 1 bit start
reg         TxStart;
wire        oRxReady, oTxBusy;

//assign oUART_CTS    = 1'b0;
assign RsControl    = {5'b0, wPulsoRxSin, oTxBusy, TxStart};
//assign wDebug = RsControl;
// ___________________________________________
// | 0 | 0 | 0 | 0 | 0 | ready | busy | start|
// ___________________________________________
//

rs232tx rs232transmitter(       // Da fpga para computador
    .clk(iCLK_50),
    .TxD_start(TxStart),        // Indica quando dado está pronto pra escrita
    .TxD_data(wTxData),         // Byte a ser enviado para placa
    .TxD(oUART_TXD),            // Indica se ainda byte está no estado de start ou stop
    .TxD_busy(oTxBusy)          // Avisa quando dado terminou de lido, 0: acabou de transmitir, 1: enquanto está vendo
);

rs232rx rs232receiver(          // Do computador para fpga
    .clk(iCLK_50)
    ,.RxD(iUART_RXD)            // Bit atual recebido
    ,.RxD_data_ready(oRxReady)  // bit que avisa quando dado está pronto pra leitura
    ,.RxD_data(RxDataAux)       // byte lido
    ,.RxD_idle()                // Indica quando n byte para ser lido
    ,.RxD_endofpacket()         // Indica quando há byte para ser Rodoulido (idle ir voltar a ser 1)
    ,.Data_Ready_Pulse(wPulsoRxSin)
);

always @(posedge wPulsoRxSin)
    begin
        RxData <= RxDataAux;
    end

always @(posedge iCLK)
        if(wWriteEnable)
            if (wAddress == RS232_WRITE_ADDRESS)   wTxData  <= wWriteData[7:0];  else
            if (wAddress == RS232_CONTROL_ADDRESS) TxStart  <= wWriteData[0];


always @(*)
        if(wReadEnable)
            if(wAddress == RS232_READ_ADDRESS || wAddress == RS232_WRITE_ADDRESS || wAddress == RS232_CONTROL_ADDRESS)
                    wReadData = {8'b0,RsControl,wTxData,RxData};
            else    wReadData = 32'hzzzzzzzz;
        else wReadData = 32'hzzzzzzzz;


endmodule
