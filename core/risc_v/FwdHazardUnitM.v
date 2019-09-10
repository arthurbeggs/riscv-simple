`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

// *
// * Unidade de Forwards e Hazards
// *

module FwdHazardUnitM (

    input [2:0] iID_OrigPC, // uret 100 ou ecall 101
    input       iCLK,
    input [4:0] iID_Rs1,
    input [4:0] iID_Rs2,
    input [4:0] iID_Rd,
    input [11:0]iID_CSR,

    input [4:0] iEX_Rs1,
    input [4:0] iEX_Rs2,
    input [4:0] iEX_Rd,
    input [11:0]iEX_CSR,

    input [4:0] iMEM_Rd,
    input [11:0]iMEM_CSR,
    input       iMEM_Exception,

    input [4:0] iWB_Rd,
    input [11:0]iWB_CSR,

    input [NTYPE-1:0] iID_InstrType, //{CSR,FPULA2Reg,FAIsInt,FAisFloat,FStore,FLoad,DivRem,Load,Store,TipoR,TipoI,Jal,Jalr,Branch} // Identifica o tipo da instrucao que esta sendo decodificada pelo controle
    input [NTYPE-1:0] iEX_InstrType,
    input [NTYPE-1:0] iMEM_InstrType,
    input [NTYPE-1:0] iWB_InstrType,

    input iBranch,              // resultado do branch em ID

`ifdef RV32IMF
    input iEX_FPALUStart,
   input iEX_FPALUReady,
`endif

    output oIF_Stall,
    output oID_Stall,
    output oEX_Stall,
    output oMEM_Stall,
    output oWB_Stall,
    output oIFID_Flush,
    output oIDEX_Flush,
    output oEXMEM_Flush,
    output oMEMWB_Flush,

    output [2:0] oFwdRs1,
    output [2:0] oFwdRs2,
    output [2:0] oFwdA,
    output [2:0] oFwdB,
    output [1:0] oFwdCSR,
    output [1:0] oFwdUEPC,
    output [1:0] oFwdUTVEC

);

// Aqui deve ter todos os sinais possíveis para detectar qualquer hazard
// Nem todos estão sendo usados, logo gera warnings


wire wID_TipoCSR         = iID_InstrType[13]; // É uma intrução do tipo I, mas é melhor tartar como um tipo a parte, para evitar modificar muito o FWdHazardUnit
`ifdef RV32IMF
wire wID_FPULA2Reg = iID_InstrType[12];
wire wID_FAIsInt   = iID_InstrType[11];
wire wID_FAIsFloat = iID_InstrType[10];
wire wID_FStore    = iID_InstrType[ 9];
wire wID_FLoad     = iID_InstrType[ 8];
wire wID_FPULA     = wID_FAIsInt || wID_FAIsFloat;// || wID_FLoad; // Tipos de instrucao que utilizam a FPULA e escrevem em registrador de ponto flutuante
`endif
wire wID_DivRem = iID_InstrType[7];
wire wID_Load       = iID_InstrType[6];
wire wID_Store      = iID_InstrType[5];
wire wID_TipoR      = iID_InstrType[4];
wire wID_TipoI      = iID_InstrType[3];
wire wID_Jal        = iID_InstrType[2];
wire wID_Jalr       = iID_InstrType[1];
wire wID_Branch     = iID_InstrType[0];
wire wID_ULA        = wID_TipoR || wID_TipoI || wID_DivRem; // forward do ULAresult
wire wID_PC4        = wID_Jal   || wID_Jalr;  // forward do PC+4



wire wEX_TipoCSR         = iEX_InstrType[13];
`ifdef RV32IMF
wire wEX_FPULA2Reg = iEX_InstrType[12];
wire wEX_FAIsInt   = iEX_InstrType[11];
wire wEX_FAIsFloat = iEX_InstrType[10];
wire wEX_FStore    = iEX_InstrType[ 9];
wire wEX_FLoad     = iEX_InstrType[ 8];
wire wEX_FPULA     = wEX_FAIsInt || wEX_FAIsFloat;// || wEX_FLoad; // || wEX_FStore; // Tipos de instrucao que utilizam a FPULA e escrevem em registrador de ponto flutuante
`endif
wire wEX_DivRem     = iEX_InstrType[7];
wire wEX_Load       = iEX_InstrType[6];
wire wEX_Store      = iEX_InstrType[5];
wire wEX_TipoR      = iEX_InstrType[4];
wire wEX_TipoI      = iEX_InstrType[3];
wire wEX_Jal        = iEX_InstrType[2];
wire wEX_Jalr       = iEX_InstrType[1];
wire wEX_Branch     = iEX_InstrType[0];
wire wEX_ULA        = wEX_TipoR || wEX_TipoI || wEX_DivRem;
wire wEX_PC4        = wEX_Jal   || wEX_Jalr;



wire wMEM_TipoCSR         = iMEM_InstrType[13];
`ifdef RV32IMF
wire wMEM_FPULA2Reg = iMEM_InstrType[12];
wire wMEM_FAIsInt   = iMEM_InstrType[11];
wire wMEM_FAIsFloat = iMEM_InstrType[10];
wire wMEM_FStore    = iMEM_InstrType[ 9];
wire wMEM_FLoad     = iMEM_InstrType[ 8];
wire wMEM_FPULA     = wMEM_FAIsInt || wMEM_FAIsFloat;// || wMEM_FLoad; // Tipos de instrucao que utilizam a FPULA e escrevem em registrador de ponto flutuante
`endif
wire wMEM_DivRem    = iMEM_InstrType[7];
wire wMEM_Load  = iMEM_InstrType[6];
wire wMEM_Store     = iMEM_InstrType[5];
wire wMEM_TipoR     = iMEM_InstrType[4];
wire wMEM_TipoI     = iMEM_InstrType[3];
wire wMEM_Jal       = iMEM_InstrType[2];
wire wMEM_Jalr  = iMEM_InstrType[1];
wire wMEM_Branch    = iMEM_InstrType[0];
wire wMEM_ULA       = wMEM_TipoR || wMEM_TipoI || wMEM_DivRem;
wire wMEM_PC4       = wMEM_Jal   || wMEM_Jalr;



wire wWB_TipoCSR         = iWB_InstrType[13];
`ifdef RV32IMF
wire wWB_FPULA2Reg = iWB_InstrType[12];
wire wWB_FAIsInt   = iWB_InstrType[11];
wire wWB_FAIsFloat = iWB_InstrType[10];
wire wWB_FStore    = iWB_InstrType[ 9];
wire wWB_FLoad     = iWB_InstrType[ 8];
wire wWB_FPULA     = wWB_FAIsInt || wWB_FAIsFloat;// || wWB_FLoad; // Tipos de instrucao que utilizam a FPULA e escrevem em registrador de ponto flutuante
`endif
wire wWB_DivRem = iWB_InstrType[7];
wire wWB_Load       = iWB_InstrType[6];
wire wWB_Store      = iWB_InstrType[5];
wire wWB_TipoR      = iWB_InstrType[4];
wire wWB_TipoI      = iWB_InstrType[3];
wire wWB_Jal        = iWB_InstrType[2];
wire wWB_Jalr       = iWB_InstrType[1];
wire wWB_Branch     = iWB_InstrType[0];
wire wWB_ULA        = wWB_TipoR || wWB_TipoI || wWB_DivRem;
wire wWB_PC4        = wWB_Jal   || wWB_Jalr;


// Contador de clocks para o DIVREM
reg [4:0] cont;

initial cont <= 5'b0;

always @(posedge iCLK)
    begin
        if(wEX_DivRem)
            cont    <= cont + 5'b1;
        else
            cont  <= 5'b0;
    end



always @(*) // Análise de Stalls e Flushes
    begin
        oIF_Stall       <= 1'b0;
        oID_Stall       <= 1'b0;
        oEX_Stall       <= 1'b0;
        oMEM_Stall      <= 1'b0;
        oWB_Stall       <= 1'b0;
        oIFID_Flush     <= 1'b0;
        oIDEX_Flush     <= 1'b0;
        oEXMEM_Flush    <= 1'b0;
        oMEMWB_Flush    <= 1'b0;

        if(iMEM_Exception)
            begin

                oIFID_Flush     <= 1'b1;
                oIDEX_Flush     <= 1'b1;
                oEXMEM_Flush    <= 1'b1;

            end
        else
        if(iID_OrigPC == 3'b100 || iID_OrigPC == 3'b101)
            oIFID_Flush     <= 1'b1;

        else
        if ( (wEX_DivRem && (cont < 5'd7))
`ifdef RV32IMF
        || (iEX_FPALUStart && !iEX_FPALUReady)
`endif
        )  // Trava todo Pipeline
        begin
            oIF_Stall       <= 1'b1;
            oID_Stall       <= 1'b1;
            oEX_Stall       <= 1'b1;
            oMEM_Stall      <= 1'b1;
            oWB_Stall       <= 1'b1;
        end
        else
        if ( (iEX_Rd !=5'b0 && (wEX_Load || wEX_TipoCSR)  && (
            (wID_TipoR   && (iEX_Rd == iID_Rs1 || iEX_Rd==iID_Rs2))||
            (wID_TipoI   && (iEX_Rd == iID_Rs1                       )) ||  // Na verdade AUIPC e LUI não entrariam aqui
            (wID_Jalr    && (iEX_Rd == iID_Rs1                       )) ||
            (wID_Store   && (iEX_Rd == iID_Rs1 || iEX_Rd==iID_Rs2))||
            (wID_Load    && (iEX_Rd == iID_Rs1                       )) ||
            (wID_TipoCSR && (iEX_Rd == iID_Rs1                       )) ||
            (wID_Branch  && (iEX_Rd == iID_Rs1 || iEX_Rd==iID_Rs2))


`ifdef RV32IMF
                                                             ||
            (wID_FAIsInt && (iEX_Rd == iID_Rs1)) || // Caso em que eh feito um load mas eh necessario carregar um int na instrucao float
            (wID_FStore  && (iEX_Rd == iID_Rs1)) || // Caso em que esta sendo feito um FStore e o endereco esta sendo carregado no estagio EX
            (wID_FLoad   && (iEX_Rd == iID_Rs1))    // Load seguido de um FLoad (que necessita do endereco int)
`endif
                                                         )) ||
            (iMEM_Rd !=5'b0 &&( wMEM_Load || wMEM_TipoCSR)&& (
            (wID_Jalr   && (iMEM_Rd == iID_Rs1                         ))  ||
            (wID_Branch && (iMEM_Rd == iID_Rs1 || iMEM_Rd==iID_Rs2))  ))  )
            begin
                oIF_Stall       <= 1'b1;
                oIDEX_Flush     <= 1'b1;
            end


        else
        if (wID_Jal || wID_Jalr || (wID_Branch))
                oIFID_Flush  <= 1'b1;



`ifdef RV32IMF // Lembrar do caso do FDIV SE SOBRAR TEMPO!
        else
        if (wEX_FLoad && (
             (wID_FAIsFloat && (iEX_Rd == iID_Rs1 || iEX_Rd == iID_Rs2)) ||
             (wID_FPULA2Reg && (iEX_Rd == iID_Rs1))                      ||
             (wID_FAIsInt   && (iEX_Rd == iID_Rs1))                      ||
             (wID_FStore    && (iEX_Rd == iID_Rs2))                      ))
             begin
                oIF_Stall       <= 1'b1;
                oIDEX_Flush     <= 1'b1;
             end
`endif

    end


always @(*)  // Forwards do Controle de Branches
    begin
        oFwdRs1     <= 3'b000;
        oFwdRs2     <= 3'b000;

        // fWD Rs1
        if ((iEX_Rd!=5'b0)  && wEX_ULA  && (iEX_Rd==iID_Rs1))                                       // EX -> ID
            oFwdRs1 <= 3'b001;
        else
        if ((iEX_Rd!=5'b0)  && wEX_PC4  && (iEX_Rd==iID_Rs1))                                       // EX -> ID
            oFwdRs1 <= 3'b101;
        else
        if ((iMEM_Rd!=5'b0) && wMEM_ULA && (iMEM_Rd==iID_Rs1))                                  // MEM -> ID
            oFwdRs1 <= 3'b010;
        else
        if ((iMEM_Rd!=5'b0) && wMEM_PC4 && (iMEM_Rd==iID_Rs1))                                  // MEM -> ID
            oFwdRs1 <= 3'b110;
        else
        if ((iWB_Rd!=5'b0)  && (wWB_ULA || wWB_PC4 || wWB_Load || wWB_TipoCSR)  && (iWB_Rd==iID_Rs1))   // WB -> ID
            oFwdRs1 <= 3'b011;
`ifdef RV32IMF
        else
        if ((iEX_Rd!=5'b0)  && wEX_FPULA2Reg  && (iEX_Rd==iID_Rs1))                             // EX -> ID
            oFwdRs1 <= 3'b100;
        else
        if ((iMEM_Rd!=5'b0) && wMEM_FPULA2Reg && (iMEM_Rd==iID_Rs1))                            // MEM -> ID
            oFwdRs1 <= 3'b111;
        else
        if ((iWB_Rd!=5'b0)  && wWB_FPULA2Reg  && (iWB_Rd==iID_Rs1))                       // WB -> ID
            oFwdRs1 <= 3'b011;
`endif
        else
            oFwdRs1 <= 3'b000;



        // fWD Rs2
        if ((iEX_Rd!=5'b0)  && wEX_ULA  && (iEX_Rd==iID_Rs2))
            oFwdRs2 <= 3'b001;
        else
        if ((iEX_Rd!=5'b0)  && wEX_PC4  && (iEX_Rd==iID_Rs2))
            oFwdRs2 <= 3'b101;
        else
        if ((iMEM_Rd!=5'b0) && wMEM_ULA && (iMEM_Rd==iID_Rs2))
            oFwdRs2 <= 3'b010;
        else
        if ((iMEM_Rd!=5'b0) && wMEM_PC4 && (iMEM_Rd==iID_Rs2))
            oFwdRs2 <= 3'b110;
        else
        if ((iWB_Rd!=5'b0)  && (wWB_ULA || wWB_PC4 || wWB_Load || wWB_TipoCSR)  && (iWB_Rd==iID_Rs2))
            oFwdRs2 <= 3'b011;
`ifdef RV32IMF
        else
        if ((iEX_Rd!=5'b0)  && wEX_FPULA2Reg  && (iEX_Rd==iID_Rs2))                             // EX -> ID
            oFwdRs2 <= 3'b100;
        else
        if ((iMEM_Rd!=5'b0) && wMEM_FPULA2Reg && (iMEM_Rd==iID_Rs2))                            // MEM -> ID
            oFwdRs2 <= 3'b111;
        else
        if ((iWB_Rd!=5'b0)  && wWB_FPULA2Reg  && (iWB_Rd==iID_Rs2))                       // WB -> ID
            oFwdRs2 <= 3'b011;
`endif
        else
            oFwdRs2 <= 3'b000;

    end



always @(*)  // Forward da ULA
    begin


`ifdef RV32IMF
    if (wEX_FPULA)     // Quando EX utilizar a FPULA
        begin

            oFwdA   <= 3'b001; // PARA NAO DAR WARNING, MAS FICAR DE OLHO!!!!
            oFwdB   <= 3'b001; // Sem forward


            // fwd FB
            if (wMEM_FPULA && (iMEM_Rd==iEX_Rs2))              // Faz o forward do resultado da FPULA no estagio MEM para o Rs1 do EX
                    oFwdB <= 3'b100;
                else
                if ((wWB_FPULA || wWB_FLoad) && (iWB_Rd==iEX_Rs2)) // Faz o forward do ultimo multiplexador do datapath para o FA nos casos de FLOAD e operacoes que usam a FPULA e escrevem no FReg
                    oFwdB <= 3'b011;
                else
                    oFwdB <= 3'b001; // Sem forward

            // fwd FA
            if (wEX_FAIsFloat) // Quando FRs1 for FLOAT
                    if (wMEM_FPULA && (iMEM_Rd==iEX_Rs1))              // Faz o forward do resultado da FPULA no estagio MEM para o Rs1 do EX
                        oFwdA <= 3'b100;
                    else
                    if ((wWB_FPULA || wWB_FLoad) && (iWB_Rd==iEX_Rs1)) // Faz o forward do ultimo multiplexador do datapath para o FA nos casos de FLOAD e operacoes que usam a FPULA e escrevem no FReg
                        oFwdA <= 3'b011;
                    else
                        oFwdA <= 3'b001; // Sem forward
            else   // Quando FRs1 for INT
                begin
                    oFwdA <= 3'b000; // Sem forward - recebe Read1

                    if ((iMEM_Rd!=5'b0) && wMEM_ULA && (iMEM_Rd==iEX_Rs1))                                                     // MEM -> EX
                        oFwdA <= 3'b010;
                    else
                    if ((iMEM_Rd!=5'b0) && wMEM_PC4 && (iMEM_Rd==iEX_Rs1))                                                     // MEM -> EX
                        oFwdA <= 3'b110;
                    else
                    if ((iWB_Rd!=5'b0)  && (wWB_ULA || wWB_PC4 || wWB_Load || wWB_FPULA2Reg)  && (iWB_Rd==iEX_Rs1))     // WB -> EX
                        oFwdA <= 3'b011;
                    else
                    if ((iMEM_Rd!=5'b0) && wMEM_FPULA2Reg && (iMEM_Rd==iEX_Rs1)) // Caso a FPULA tenha como Rd o mesmo int necessario no estagio EX
                        oFwdA <= 3'b100;
                    else
                        oFwdA <= 3'b000;
                end
        end
    else  // Quando EX nao utiliza a FPULA
        begin
`endif


            oFwdA       <= 3'b000;
            oFwdB       <= 3'b000;

            // fWD A
            if ((iMEM_Rd!=5'b0) && wMEM_ULA && (iMEM_Rd==iEX_Rs1))                                                          // MEM -> EX
                oFwdA <= 3'b010;
            else
            if ((iMEM_Rd!=5'b0) && wMEM_PC4 && (iMEM_Rd==iEX_Rs1))                                                          // MEM -> EX
                oFwdA <= 3'b110;
            else
            if ((iWB_Rd!=5'b0)  && (wWB_ULA || wWB_PC4 || wWB_Load ||  wWB_TipoCSR)  && (iWB_Rd==iEX_Rs1))      // WB -> EX
                oFwdA <= 3'b011;


`ifdef RV32IMF
            else
            if ((iMEM_Rd!=5'b0) && wMEM_FPULA2Reg && (iMEM_Rd==iEX_Rs1)) // Caso a FPULA tenha como Rd o mesmo int necessario no estagio EX
                oFwdA <= 3'b100;
            else
            if ((iWB_Rd!=5'b0)  && wWB_FPULA2Reg && (iWB_Rd==iEX_Rs1)) // Caso a FPULA tenha como Rd o mesmo int necessario no estagio EX
                oFwdA <= 3'b011;
`endif

            else
                oFwdA <= 3'b000;



            // fWD B
            if ((iMEM_Rd!=5'b0) && wMEM_ULA && (iMEM_Rd==iEX_Rs2))
                oFwdB <= 3'b010;
            else
            if ((iMEM_Rd!=5'b0) && wMEM_PC4 && (iMEM_Rd==iEX_Rs2))
                oFwdB <= 3'b110;
            else
            if ((iWB_Rd!=5'b0)  && (wWB_ULA || wWB_PC4 || wWB_Load || wWB_TipoCSR) && (iWB_Rd==iEX_Rs2))
                oFwdB <= 3'b011;


`ifdef RV32IMF
            else
            if ((iMEM_Rd!=5'b0) && wMEM_FPULA2Reg && (iMEM_Rd==iEX_Rs2)) // Caso a FPULA tenha como Rd o mesmo int necessario no estagio EX
                oFwdB <= 3'b100;
            else
            if ((iWB_Rd!=5'b0)  && wWB_FPULA2Reg && (iWB_Rd==iEX_Rs2)) // Caso a FPULA tenha como Rd o mesmo int necessario no estagio EX
                oFwdA <= 3'b011;
`endif

            // forward csr em csr <= opalu (csr), csr = csr
            else
            if (wMEM_TipoCSR && wEX_TipoCSR) // MEM -> EX
                begin

                    if(iMEM_CSR==iEX_CSR)
                        oFwdB <= 3'b010;
                    else
                        oFwdB <= 3'b111;
                end

            else
            if (wWB_TipoCSR && wEX_TipoCSR) // WB -> EX
                begin
                    if(iWB_CSR==iEX_CSR)
                        oFwdB <= 3'b101;
                    else
                        oFwdB <= 3'b111;
                end

            else
                begin
                    if(wEX_TipoCSR)
                        oFwdB <= 3'b111;    // sem forward para csr
                    else
                        oFwdB <= 3'b000; // sem forward para demais
                end

    end

`ifdef RV32IMF
    end
`endif

always @(*)         // csr forward em rd <= CSR (csr = csr)
    begin



            if(wWB_TipoCSR && wEX_TipoCSR && (iEX_CSR == iWB_CSR))
                oFwdCSR <= 2'b01;
            else
            if(wWB_TipoCSR && wMEM_TipoCSR && (iMEM_CSR == iWB_CSR))
                oFwdCSR <= 2'b10;

            else
                oFwdCSR <= 2'b00;



    end


always @(*)         // forward do utvec e uepc nas chamadas de ecall e uret
    begin

        // uret
        if(iID_OrigPC == 3'b100)
            begin
                if(wEX_TipoCSR && iEX_CSR == 12'h041)
                    oFwdUEPC     <= 2'b01;

                else
                if(wMEM_TipoCSR && iMEM_CSR == 12'h041)
                    oFwdUEPC     <= 2'b10;

                else
                    oFwdUEPC     <= 2'b00;

            end
        else
            oFwdUEPC     <= 2'b00;

        // ecall
        if(iID_OrigPC == 3'b101)
            begin
                if(wEX_TipoCSR && iEX_CSR == 12'h041)
                    oFwdUTVEC <= 2'b01;

                else
                if(wMEM_TipoCSR && iMEM_CSR == 12'h05)
                    oFwdUTVEC <= 2'b10;

                else
                    oFwdUTVEC <= 2'b00;

            end


        else
            oFwdUTVEC <= 2'b00;


    end




endmodule
