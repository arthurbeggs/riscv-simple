-- ------------------------------------------------------------------------- 
-- High Level Design Compiler for Intel(R) FPGAs Version 18.1 (Release Build #625)
-- Quartus Prime development tool and MATLAB/Simulink Interface
-- 
-- Legal Notice: Copyright 2018 Intel Corporation.  All rights reserved.
-- Your use of  Intel Corporation's design tools,  logic functions and other
-- software and  tools, and its AMPP partner logic functions, and any output
-- files any  of the foregoing (including  device programming  or simulation
-- files), and  any associated  documentation  or information  are expressly
-- subject  to the terms and  conditions of the  Intel FPGA Software License
-- Agreement, Intel MegaCore Function License Agreement, or other applicable
-- license agreement,  including,  without limitation,  that your use is for
-- the  sole  purpose of  programming  logic devices  manufactured by  Intel
-- and  sold by Intel  or its authorized  distributors. Please refer  to the
-- applicable agreement for further details.
-- ---------------------------------------------------------------------------

-- VHDL created from mul_s_0002
-- VHDL created on Fri Mar 08 18:11:41 2019


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.all;
use std.TextIO.all;
use work.dspba_library_package.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;
LIBRARY altera_lnsim;
USE altera_lnsim.altera_lnsim_components.altera_syncram;
LIBRARY lpm;
USE lpm.lpm_components.all;

entity mul_s_0002 is
    port (
        a : in std_logic_vector(31 downto 0);  -- float32_m23
        b : in std_logic_vector(31 downto 0);  -- float32_m23
        q : out std_logic_vector(31 downto 0);  -- float32_m23
        clk : in std_logic;
        areset : in std_logic
    );
end mul_s_0002;

architecture normal of mul_s_0002 is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expX_uid6_fpMulTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal expY_uid7_fpMulTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal signX_uid8_fpMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal signY_uid9_fpMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal cstAllOWE_uid10_fpMulTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal cstZeroWF_uid11_fpMulTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal cstAllZWE_uid12_fpMulTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal frac_x_uid14_fpMulTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal excZ_x_uid15_fpMulTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excZ_x_uid15_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid16_fpMulTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid16_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid17_fpMulTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid17_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid18_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_x_uid19_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_x_uid20_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExpXIsMax_uid21_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal InvExpXIsZero_uid22_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_x_uid23_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal frac_y_uid28_fpMulTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal excZ_y_uid29_fpMulTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excZ_y_uid29_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid30_fpMulTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid30_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid31_fpMulTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid31_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid32_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_y_uid33_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_y_uid34_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExpXIsMax_uid35_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal InvExpXIsZero_uid36_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_y_uid37_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal ofracX_uid40_fpMulTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal ofracY_uid43_fpMulTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal expSum_uid44_fpMulTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal expSum_uid44_fpMulTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal expSum_uid44_fpMulTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal expSum_uid44_fpMulTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal biasInc_uid45_fpMulTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal expSumMBias_uid46_fpMulTest_a : STD_LOGIC_VECTOR (11 downto 0);
    signal expSumMBias_uid46_fpMulTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal expSumMBias_uid46_fpMulTest_o : STD_LOGIC_VECTOR (11 downto 0);
    signal expSumMBias_uid46_fpMulTest_q : STD_LOGIC_VECTOR (10 downto 0);
    signal signR_uid48_fpMulTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal signR_uid48_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal normalizeBit_uid49_fpMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPostNormHigh_uid51_fpMulTest_in : STD_LOGIC_VECTOR (24 downto 0);
    signal fracRPostNormHigh_uid51_fpMulTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPostNormLow_uid52_fpMulTest_in : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPostNormLow_uid52_fpMulTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPostNorm_uid53_fpMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPostNorm_uid53_fpMulTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal expFracPreRound_uid55_fpMulTest_q : STD_LOGIC_VECTOR (34 downto 0);
    signal roundBitAndNormalizationOp_uid57_fpMulTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal expFracRPostRounding_uid58_fpMulTest_a : STD_LOGIC_VECTOR (36 downto 0);
    signal expFracRPostRounding_uid58_fpMulTest_b : STD_LOGIC_VECTOR (36 downto 0);
    signal expFracRPostRounding_uid58_fpMulTest_o : STD_LOGIC_VECTOR (36 downto 0);
    signal expFracRPostRounding_uid58_fpMulTest_q : STD_LOGIC_VECTOR (35 downto 0);
    signal fracRPreExc_uid59_fpMulTest_in : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPreExc_uid59_fpMulTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal expRPreExcExt_uid60_fpMulTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal expRPreExc_uid61_fpMulTest_in : STD_LOGIC_VECTOR (7 downto 0);
    signal expRPreExc_uid61_fpMulTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal expUdf_uid62_fpMulTest_a : STD_LOGIC_VECTOR (13 downto 0);
    signal expUdf_uid62_fpMulTest_b : STD_LOGIC_VECTOR (13 downto 0);
    signal expUdf_uid62_fpMulTest_o : STD_LOGIC_VECTOR (13 downto 0);
    signal expUdf_uid62_fpMulTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal expOvf_uid64_fpMulTest_a : STD_LOGIC_VECTOR (13 downto 0);
    signal expOvf_uid64_fpMulTest_b : STD_LOGIC_VECTOR (13 downto 0);
    signal expOvf_uid64_fpMulTest_o : STD_LOGIC_VECTOR (13 downto 0);
    signal expOvf_uid64_fpMulTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal excXZAndExcYZ_uid65_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXZAndExcYR_uid66_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excYZAndExcXR_uid67_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excZC3_uid68_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRZero_uid69_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXIAndExcYI_uid70_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXRAndExcYI_uid71_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excYRAndExcXI_uid72_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal ExcROvfAndInReg_uid73_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRInf_uid74_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excYZAndExcXI_uid75_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXZAndExcYI_uid76_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal ZeroTimesInf_uid77_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRNaN_uid78_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal concExc_uid79_fpMulTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal excREnc_uid80_fpMulTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal oneFracRPostExc2_uid81_fpMulTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal fracRPostExc_uid84_fpMulTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal fracRPostExc_uid84_fpMulTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal expRPostExc_uid89_fpMulTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal expRPostExc_uid89_fpMulTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal invExcRNaN_uid90_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRPostExc_uid91_fpMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal R_uid92_fpMulTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal osig_uid95_prod_uid47_fpMulTest_b : STD_LOGIC_VECTOR (25 downto 0);
    signal prodXY_uid94_prod_uid47_fpMulTest_cma_reset : std_logic;
    type prodXY_uid94_prod_uid47_fpMulTest_cma_a0type is array(NATURAL range <>) of UNSIGNED(23 downto 0);
    signal prodXY_uid94_prod_uid47_fpMulTest_cma_a0 : prodXY_uid94_prod_uid47_fpMulTest_cma_a0type(0 to 0);
    attribute preserve : boolean;
    attribute preserve of prodXY_uid94_prod_uid47_fpMulTest_cma_a0 : signal is true;
    signal prodXY_uid94_prod_uid47_fpMulTest_cma_c0 : prodXY_uid94_prod_uid47_fpMulTest_cma_a0type(0 to 0);
    attribute preserve of prodXY_uid94_prod_uid47_fpMulTest_cma_c0 : signal is true;
    type prodXY_uid94_prod_uid47_fpMulTest_cma_ptype is array(NATURAL range <>) of UNSIGNED(47 downto 0);
    signal prodXY_uid94_prod_uid47_fpMulTest_cma_p : prodXY_uid94_prod_uid47_fpMulTest_cma_ptype(0 to 0);
    signal prodXY_uid94_prod_uid47_fpMulTest_cma_u : prodXY_uid94_prod_uid47_fpMulTest_cma_ptype(0 to 0);
    signal prodXY_uid94_prod_uid47_fpMulTest_cma_w : prodXY_uid94_prod_uid47_fpMulTest_cma_ptype(0 to 0);
    signal prodXY_uid94_prod_uid47_fpMulTest_cma_x : prodXY_uid94_prod_uid47_fpMulTest_cma_ptype(0 to 0);
    signal prodXY_uid94_prod_uid47_fpMulTest_cma_y : prodXY_uid94_prod_uid47_fpMulTest_cma_ptype(0 to 0);
    signal prodXY_uid94_prod_uid47_fpMulTest_cma_s : prodXY_uid94_prod_uid47_fpMulTest_cma_ptype(0 to 0);
    signal prodXY_uid94_prod_uid47_fpMulTest_cma_qq : STD_LOGIC_VECTOR (47 downto 0);
    signal prodXY_uid94_prod_uid47_fpMulTest_cma_q : STD_LOGIC_VECTOR (47 downto 0);
    signal prodXY_uid94_prod_uid47_fpMulTest_cma_ena0 : std_logic;
    signal prodXY_uid94_prod_uid47_fpMulTest_cma_ena1 : std_logic;
    signal redist0_expRPreExc_uid61_fpMulTest_b_1_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist1_fracRPreExc_uid59_fpMulTest_b_1_q : STD_LOGIC_VECTOR (22 downto 0);
    signal redist2_signR_uid48_fpMulTest_q_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist3_expSum_uid44_fpMulTest_q_2_q : STD_LOGIC_VECTOR (8 downto 0);
    signal redist4_fracXIsZero_uid31_fpMulTest_q_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist5_expXIsMax_uid30_fpMulTest_q_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist6_excZ_y_uid29_fpMulTest_q_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist7_fracXIsZero_uid17_fpMulTest_q_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist8_expXIsMax_uid16_fpMulTest_q_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist9_excZ_x_uid15_fpMulTest_q_3_q : STD_LOGIC_VECTOR (0 downto 0);

begin


    -- frac_x_uid14_fpMulTest(BITSELECT,13)@0
    frac_x_uid14_fpMulTest_b <= a(22 downto 0);

    -- cstZeroWF_uid11_fpMulTest(CONSTANT,10)
    cstZeroWF_uid11_fpMulTest_q <= "00000000000000000000000";

    -- fracXIsZero_uid17_fpMulTest(LOGICAL,16)@0 + 1
    fracXIsZero_uid17_fpMulTest_qi <= "1" WHEN cstZeroWF_uid11_fpMulTest_q = frac_x_uid14_fpMulTest_b ELSE "0";
    fracXIsZero_uid17_fpMulTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid17_fpMulTest_qi, xout => fracXIsZero_uid17_fpMulTest_q, clk => clk, aclr => areset );

    -- redist7_fracXIsZero_uid17_fpMulTest_q_3(DELAY,104)
    redist7_fracXIsZero_uid17_fpMulTest_q_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid17_fpMulTest_q, xout => redist7_fracXIsZero_uid17_fpMulTest_q_3_q, clk => clk, aclr => areset );

    -- cstAllOWE_uid10_fpMulTest(CONSTANT,9)
    cstAllOWE_uid10_fpMulTest_q <= "11111111";

    -- expX_uid6_fpMulTest(BITSELECT,5)@0
    expX_uid6_fpMulTest_b <= a(30 downto 23);

    -- expXIsMax_uid16_fpMulTest(LOGICAL,15)@0 + 1
    expXIsMax_uid16_fpMulTest_qi <= "1" WHEN expX_uid6_fpMulTest_b = cstAllOWE_uid10_fpMulTest_q ELSE "0";
    expXIsMax_uid16_fpMulTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => expXIsMax_uid16_fpMulTest_qi, xout => expXIsMax_uid16_fpMulTest_q, clk => clk, aclr => areset );

    -- redist8_expXIsMax_uid16_fpMulTest_q_3(DELAY,105)
    redist8_expXIsMax_uid16_fpMulTest_q_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => expXIsMax_uid16_fpMulTest_q, xout => redist8_expXIsMax_uid16_fpMulTest_q_3_q, clk => clk, aclr => areset );

    -- excI_x_uid19_fpMulTest(LOGICAL,18)@3
    excI_x_uid19_fpMulTest_q <= redist8_expXIsMax_uid16_fpMulTest_q_3_q and redist7_fracXIsZero_uid17_fpMulTest_q_3_q;

    -- cstAllZWE_uid12_fpMulTest(CONSTANT,11)
    cstAllZWE_uid12_fpMulTest_q <= "00000000";

    -- expY_uid7_fpMulTest(BITSELECT,6)@0
    expY_uid7_fpMulTest_b <= b(30 downto 23);

    -- excZ_y_uid29_fpMulTest(LOGICAL,28)@0 + 1
    excZ_y_uid29_fpMulTest_qi <= "1" WHEN expY_uid7_fpMulTest_b = cstAllZWE_uid12_fpMulTest_q ELSE "0";
    excZ_y_uid29_fpMulTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excZ_y_uid29_fpMulTest_qi, xout => excZ_y_uid29_fpMulTest_q, clk => clk, aclr => areset );

    -- redist6_excZ_y_uid29_fpMulTest_q_3(DELAY,103)
    redist6_excZ_y_uid29_fpMulTest_q_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => excZ_y_uid29_fpMulTest_q, xout => redist6_excZ_y_uid29_fpMulTest_q_3_q, clk => clk, aclr => areset );

    -- excYZAndExcXI_uid75_fpMulTest(LOGICAL,74)@3
    excYZAndExcXI_uid75_fpMulTest_q <= redist6_excZ_y_uid29_fpMulTest_q_3_q and excI_x_uid19_fpMulTest_q;

    -- frac_y_uid28_fpMulTest(BITSELECT,27)@0
    frac_y_uid28_fpMulTest_b <= b(22 downto 0);

    -- fracXIsZero_uid31_fpMulTest(LOGICAL,30)@0 + 1
    fracXIsZero_uid31_fpMulTest_qi <= "1" WHEN cstZeroWF_uid11_fpMulTest_q = frac_y_uid28_fpMulTest_b ELSE "0";
    fracXIsZero_uid31_fpMulTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid31_fpMulTest_qi, xout => fracXIsZero_uid31_fpMulTest_q, clk => clk, aclr => areset );

    -- redist4_fracXIsZero_uid31_fpMulTest_q_3(DELAY,101)
    redist4_fracXIsZero_uid31_fpMulTest_q_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid31_fpMulTest_q, xout => redist4_fracXIsZero_uid31_fpMulTest_q_3_q, clk => clk, aclr => areset );

    -- expXIsMax_uid30_fpMulTest(LOGICAL,29)@0 + 1
    expXIsMax_uid30_fpMulTest_qi <= "1" WHEN expY_uid7_fpMulTest_b = cstAllOWE_uid10_fpMulTest_q ELSE "0";
    expXIsMax_uid30_fpMulTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => expXIsMax_uid30_fpMulTest_qi, xout => expXIsMax_uid30_fpMulTest_q, clk => clk, aclr => areset );

    -- redist5_expXIsMax_uid30_fpMulTest_q_3(DELAY,102)
    redist5_expXIsMax_uid30_fpMulTest_q_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => expXIsMax_uid30_fpMulTest_q, xout => redist5_expXIsMax_uid30_fpMulTest_q_3_q, clk => clk, aclr => areset );

    -- excI_y_uid33_fpMulTest(LOGICAL,32)@3
    excI_y_uid33_fpMulTest_q <= redist5_expXIsMax_uid30_fpMulTest_q_3_q and redist4_fracXIsZero_uid31_fpMulTest_q_3_q;

    -- excZ_x_uid15_fpMulTest(LOGICAL,14)@0 + 1
    excZ_x_uid15_fpMulTest_qi <= "1" WHEN expX_uid6_fpMulTest_b = cstAllZWE_uid12_fpMulTest_q ELSE "0";
    excZ_x_uid15_fpMulTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excZ_x_uid15_fpMulTest_qi, xout => excZ_x_uid15_fpMulTest_q, clk => clk, aclr => areset );

    -- redist9_excZ_x_uid15_fpMulTest_q_3(DELAY,106)
    redist9_excZ_x_uid15_fpMulTest_q_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => excZ_x_uid15_fpMulTest_q, xout => redist9_excZ_x_uid15_fpMulTest_q_3_q, clk => clk, aclr => areset );

    -- excXZAndExcYI_uid76_fpMulTest(LOGICAL,75)@3
    excXZAndExcYI_uid76_fpMulTest_q <= redist9_excZ_x_uid15_fpMulTest_q_3_q and excI_y_uid33_fpMulTest_q;

    -- ZeroTimesInf_uid77_fpMulTest(LOGICAL,76)@3
    ZeroTimesInf_uid77_fpMulTest_q <= excXZAndExcYI_uid76_fpMulTest_q or excYZAndExcXI_uid75_fpMulTest_q;

    -- fracXIsNotZero_uid32_fpMulTest(LOGICAL,31)@3
    fracXIsNotZero_uid32_fpMulTest_q <= not (redist4_fracXIsZero_uid31_fpMulTest_q_3_q);

    -- excN_y_uid34_fpMulTest(LOGICAL,33)@3
    excN_y_uid34_fpMulTest_q <= redist5_expXIsMax_uid30_fpMulTest_q_3_q and fracXIsNotZero_uid32_fpMulTest_q;

    -- fracXIsNotZero_uid18_fpMulTest(LOGICAL,17)@3
    fracXIsNotZero_uid18_fpMulTest_q <= not (redist7_fracXIsZero_uid17_fpMulTest_q_3_q);

    -- excN_x_uid20_fpMulTest(LOGICAL,19)@3
    excN_x_uid20_fpMulTest_q <= redist8_expXIsMax_uid16_fpMulTest_q_3_q and fracXIsNotZero_uid18_fpMulTest_q;

    -- excRNaN_uid78_fpMulTest(LOGICAL,77)@3
    excRNaN_uid78_fpMulTest_q <= excN_x_uid20_fpMulTest_q or excN_y_uid34_fpMulTest_q or ZeroTimesInf_uid77_fpMulTest_q;

    -- invExcRNaN_uid90_fpMulTest(LOGICAL,89)@3
    invExcRNaN_uid90_fpMulTest_q <= not (excRNaN_uid78_fpMulTest_q);

    -- signY_uid9_fpMulTest(BITSELECT,8)@0
    signY_uid9_fpMulTest_b <= STD_LOGIC_VECTOR(b(31 downto 31));

    -- signX_uid8_fpMulTest(BITSELECT,7)@0
    signX_uid8_fpMulTest_b <= STD_LOGIC_VECTOR(a(31 downto 31));

    -- signR_uid48_fpMulTest(LOGICAL,47)@0 + 1
    signR_uid48_fpMulTest_qi <= signX_uid8_fpMulTest_b xor signY_uid9_fpMulTest_b;
    signR_uid48_fpMulTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => signR_uid48_fpMulTest_qi, xout => signR_uid48_fpMulTest_q, clk => clk, aclr => areset );

    -- redist2_signR_uid48_fpMulTest_q_3(DELAY,99)
    redist2_signR_uid48_fpMulTest_q_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => signR_uid48_fpMulTest_q, xout => redist2_signR_uid48_fpMulTest_q_3_q, clk => clk, aclr => areset );

    -- VCC(CONSTANT,1)
    VCC_q <= "1";

    -- signRPostExc_uid91_fpMulTest(LOGICAL,90)@3
    signRPostExc_uid91_fpMulTest_q <= redist2_signR_uid48_fpMulTest_q_3_q and invExcRNaN_uid90_fpMulTest_q;

    -- GND(CONSTANT,0)
    GND_q <= "0";

    -- ofracY_uid43_fpMulTest(BITJOIN,42)@0
    ofracY_uid43_fpMulTest_q <= VCC_q & frac_y_uid28_fpMulTest_b;

    -- ofracX_uid40_fpMulTest(BITJOIN,39)@0
    ofracX_uid40_fpMulTest_q <= VCC_q & frac_x_uid14_fpMulTest_b;

    -- prodXY_uid94_prod_uid47_fpMulTest_cma(CHAINMULTADD,96)@0 + 2
    prodXY_uid94_prod_uid47_fpMulTest_cma_reset <= areset;
    prodXY_uid94_prod_uid47_fpMulTest_cma_ena0 <= '1';
    prodXY_uid94_prod_uid47_fpMulTest_cma_ena1 <= prodXY_uid94_prod_uid47_fpMulTest_cma_ena0;
    prodXY_uid94_prod_uid47_fpMulTest_cma_p(0) <= prodXY_uid94_prod_uid47_fpMulTest_cma_a0(0) * prodXY_uid94_prod_uid47_fpMulTest_cma_c0(0);
    prodXY_uid94_prod_uid47_fpMulTest_cma_u(0) <= RESIZE(prodXY_uid94_prod_uid47_fpMulTest_cma_p(0),48);
    prodXY_uid94_prod_uid47_fpMulTest_cma_w(0) <= prodXY_uid94_prod_uid47_fpMulTest_cma_u(0);
    prodXY_uid94_prod_uid47_fpMulTest_cma_x(0) <= prodXY_uid94_prod_uid47_fpMulTest_cma_w(0);
    prodXY_uid94_prod_uid47_fpMulTest_cma_y(0) <= prodXY_uid94_prod_uid47_fpMulTest_cma_x(0);
    prodXY_uid94_prod_uid47_fpMulTest_cma_chainmultadd_input: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid94_prod_uid47_fpMulTest_cma_a0 <= (others => (others => '0'));
            prodXY_uid94_prod_uid47_fpMulTest_cma_c0 <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (prodXY_uid94_prod_uid47_fpMulTest_cma_ena0 = '1') THEN
                prodXY_uid94_prod_uid47_fpMulTest_cma_a0(0) <= RESIZE(UNSIGNED(ofracX_uid40_fpMulTest_q),24);
                prodXY_uid94_prod_uid47_fpMulTest_cma_c0(0) <= RESIZE(UNSIGNED(ofracY_uid43_fpMulTest_q),24);
            END IF;
        END IF;
    END PROCESS;
    prodXY_uid94_prod_uid47_fpMulTest_cma_chainmultadd_output: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid94_prod_uid47_fpMulTest_cma_s <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (prodXY_uid94_prod_uid47_fpMulTest_cma_ena1 = '1') THEN
                prodXY_uid94_prod_uid47_fpMulTest_cma_s(0) <= prodXY_uid94_prod_uid47_fpMulTest_cma_y(0);
            END IF;
        END IF;
    END PROCESS;
    prodXY_uid94_prod_uid47_fpMulTest_cma_delay : dspba_delay
    GENERIC MAP ( width => 48, depth => 0, reset_kind => "ASYNC" )
    PORT MAP ( xin => STD_LOGIC_VECTOR(prodXY_uid94_prod_uid47_fpMulTest_cma_s(0)(47 downto 0)), xout => prodXY_uid94_prod_uid47_fpMulTest_cma_qq, clk => clk, aclr => areset );
    prodXY_uid94_prod_uid47_fpMulTest_cma_q <= STD_LOGIC_VECTOR(prodXY_uid94_prod_uid47_fpMulTest_cma_qq(47 downto 0));

    -- osig_uid95_prod_uid47_fpMulTest(BITSELECT,94)@2
    osig_uid95_prod_uid47_fpMulTest_b <= prodXY_uid94_prod_uid47_fpMulTest_cma_q(47 downto 22);

    -- normalizeBit_uid49_fpMulTest(BITSELECT,48)@2
    normalizeBit_uid49_fpMulTest_b <= STD_LOGIC_VECTOR(osig_uid95_prod_uid47_fpMulTest_b(25 downto 25));

    -- roundBitAndNormalizationOp_uid57_fpMulTest(BITJOIN,56)@2
    roundBitAndNormalizationOp_uid57_fpMulTest_q <= GND_q & normalizeBit_uid49_fpMulTest_b & cstZeroWF_uid11_fpMulTest_q & VCC_q;

    -- biasInc_uid45_fpMulTest(CONSTANT,44)
    biasInc_uid45_fpMulTest_q <= "0001111111";

    -- expSum_uid44_fpMulTest(ADD,43)@0 + 1
    expSum_uid44_fpMulTest_a <= STD_LOGIC_VECTOR("0" & expX_uid6_fpMulTest_b);
    expSum_uid44_fpMulTest_b <= STD_LOGIC_VECTOR("0" & expY_uid7_fpMulTest_b);
    expSum_uid44_fpMulTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            expSum_uid44_fpMulTest_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            expSum_uid44_fpMulTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expSum_uid44_fpMulTest_a) + UNSIGNED(expSum_uid44_fpMulTest_b));
        END IF;
    END PROCESS;
    expSum_uid44_fpMulTest_q <= expSum_uid44_fpMulTest_o(8 downto 0);

    -- redist3_expSum_uid44_fpMulTest_q_2(DELAY,100)
    redist3_expSum_uid44_fpMulTest_q_2 : dspba_delay
    GENERIC MAP ( width => 9, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => expSum_uid44_fpMulTest_q, xout => redist3_expSum_uid44_fpMulTest_q_2_q, clk => clk, aclr => areset );

    -- expSumMBias_uid46_fpMulTest(SUB,45)@2
    expSumMBias_uid46_fpMulTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000" & redist3_expSum_uid44_fpMulTest_q_2_q));
    expSumMBias_uid46_fpMulTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((11 downto 10 => biasInc_uid45_fpMulTest_q(9)) & biasInc_uid45_fpMulTest_q));
    expSumMBias_uid46_fpMulTest_o <= STD_LOGIC_VECTOR(SIGNED(expSumMBias_uid46_fpMulTest_a) - SIGNED(expSumMBias_uid46_fpMulTest_b));
    expSumMBias_uid46_fpMulTest_q <= expSumMBias_uid46_fpMulTest_o(10 downto 0);

    -- fracRPostNormHigh_uid51_fpMulTest(BITSELECT,50)@2
    fracRPostNormHigh_uid51_fpMulTest_in <= osig_uid95_prod_uid47_fpMulTest_b(24 downto 0);
    fracRPostNormHigh_uid51_fpMulTest_b <= fracRPostNormHigh_uid51_fpMulTest_in(24 downto 1);

    -- fracRPostNormLow_uid52_fpMulTest(BITSELECT,51)@2
    fracRPostNormLow_uid52_fpMulTest_in <= osig_uid95_prod_uid47_fpMulTest_b(23 downto 0);
    fracRPostNormLow_uid52_fpMulTest_b <= fracRPostNormLow_uid52_fpMulTest_in(23 downto 0);

    -- fracRPostNorm_uid53_fpMulTest(MUX,52)@2
    fracRPostNorm_uid53_fpMulTest_s <= normalizeBit_uid49_fpMulTest_b;
    fracRPostNorm_uid53_fpMulTest_combproc: PROCESS (fracRPostNorm_uid53_fpMulTest_s, fracRPostNormLow_uid52_fpMulTest_b, fracRPostNormHigh_uid51_fpMulTest_b)
    BEGIN
        CASE (fracRPostNorm_uid53_fpMulTest_s) IS
            WHEN "0" => fracRPostNorm_uid53_fpMulTest_q <= fracRPostNormLow_uid52_fpMulTest_b;
            WHEN "1" => fracRPostNorm_uid53_fpMulTest_q <= fracRPostNormHigh_uid51_fpMulTest_b;
            WHEN OTHERS => fracRPostNorm_uid53_fpMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- expFracPreRound_uid55_fpMulTest(BITJOIN,54)@2
    expFracPreRound_uid55_fpMulTest_q <= expSumMBias_uid46_fpMulTest_q & fracRPostNorm_uid53_fpMulTest_q;

    -- expFracRPostRounding_uid58_fpMulTest(ADD,57)@2
    expFracRPostRounding_uid58_fpMulTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((36 downto 35 => expFracPreRound_uid55_fpMulTest_q(34)) & expFracPreRound_uid55_fpMulTest_q));
    expFracRPostRounding_uid58_fpMulTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("00000000000" & roundBitAndNormalizationOp_uid57_fpMulTest_q));
    expFracRPostRounding_uid58_fpMulTest_o <= STD_LOGIC_VECTOR(SIGNED(expFracRPostRounding_uid58_fpMulTest_a) + SIGNED(expFracRPostRounding_uid58_fpMulTest_b));
    expFracRPostRounding_uid58_fpMulTest_q <= expFracRPostRounding_uid58_fpMulTest_o(35 downto 0);

    -- expRPreExcExt_uid60_fpMulTest(BITSELECT,59)@2
    expRPreExcExt_uid60_fpMulTest_b <= STD_LOGIC_VECTOR(expFracRPostRounding_uid58_fpMulTest_q(35 downto 24));

    -- expRPreExc_uid61_fpMulTest(BITSELECT,60)@2
    expRPreExc_uid61_fpMulTest_in <= expRPreExcExt_uid60_fpMulTest_b(7 downto 0);
    expRPreExc_uid61_fpMulTest_b <= expRPreExc_uid61_fpMulTest_in(7 downto 0);

    -- redist0_expRPreExc_uid61_fpMulTest_b_1(DELAY,97)
    redist0_expRPreExc_uid61_fpMulTest_b_1 : dspba_delay
    GENERIC MAP ( width => 8, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => expRPreExc_uid61_fpMulTest_b, xout => redist0_expRPreExc_uid61_fpMulTest_b_1_q, clk => clk, aclr => areset );

    -- expOvf_uid64_fpMulTest(COMPARE,63)@2 + 1
    expOvf_uid64_fpMulTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((13 downto 12 => expRPreExcExt_uid60_fpMulTest_b(11)) & expRPreExcExt_uid60_fpMulTest_b));
    expOvf_uid64_fpMulTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000000" & cstAllOWE_uid10_fpMulTest_q));
    expOvf_uid64_fpMulTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            expOvf_uid64_fpMulTest_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            expOvf_uid64_fpMulTest_o <= STD_LOGIC_VECTOR(SIGNED(expOvf_uid64_fpMulTest_a) - SIGNED(expOvf_uid64_fpMulTest_b));
        END IF;
    END PROCESS;
    expOvf_uid64_fpMulTest_n(0) <= not (expOvf_uid64_fpMulTest_o(13));

    -- invExpXIsMax_uid35_fpMulTest(LOGICAL,34)@3
    invExpXIsMax_uid35_fpMulTest_q <= not (redist5_expXIsMax_uid30_fpMulTest_q_3_q);

    -- InvExpXIsZero_uid36_fpMulTest(LOGICAL,35)@3
    InvExpXIsZero_uid36_fpMulTest_q <= not (redist6_excZ_y_uid29_fpMulTest_q_3_q);

    -- excR_y_uid37_fpMulTest(LOGICAL,36)@3
    excR_y_uid37_fpMulTest_q <= InvExpXIsZero_uid36_fpMulTest_q and invExpXIsMax_uid35_fpMulTest_q;

    -- invExpXIsMax_uid21_fpMulTest(LOGICAL,20)@3
    invExpXIsMax_uid21_fpMulTest_q <= not (redist8_expXIsMax_uid16_fpMulTest_q_3_q);

    -- InvExpXIsZero_uid22_fpMulTest(LOGICAL,21)@3
    InvExpXIsZero_uid22_fpMulTest_q <= not (redist9_excZ_x_uid15_fpMulTest_q_3_q);

    -- excR_x_uid23_fpMulTest(LOGICAL,22)@3
    excR_x_uid23_fpMulTest_q <= InvExpXIsZero_uid22_fpMulTest_q and invExpXIsMax_uid21_fpMulTest_q;

    -- ExcROvfAndInReg_uid73_fpMulTest(LOGICAL,72)@3
    ExcROvfAndInReg_uid73_fpMulTest_q <= excR_x_uid23_fpMulTest_q and excR_y_uid37_fpMulTest_q and expOvf_uid64_fpMulTest_n;

    -- excYRAndExcXI_uid72_fpMulTest(LOGICAL,71)@3
    excYRAndExcXI_uid72_fpMulTest_q <= excR_y_uid37_fpMulTest_q and excI_x_uid19_fpMulTest_q;

    -- excXRAndExcYI_uid71_fpMulTest(LOGICAL,70)@3
    excXRAndExcYI_uid71_fpMulTest_q <= excR_x_uid23_fpMulTest_q and excI_y_uid33_fpMulTest_q;

    -- excXIAndExcYI_uid70_fpMulTest(LOGICAL,69)@3
    excXIAndExcYI_uid70_fpMulTest_q <= excI_x_uid19_fpMulTest_q and excI_y_uid33_fpMulTest_q;

    -- excRInf_uid74_fpMulTest(LOGICAL,73)@3
    excRInf_uid74_fpMulTest_q <= excXIAndExcYI_uid70_fpMulTest_q or excXRAndExcYI_uid71_fpMulTest_q or excYRAndExcXI_uid72_fpMulTest_q or ExcROvfAndInReg_uid73_fpMulTest_q;

    -- expUdf_uid62_fpMulTest(COMPARE,61)@2 + 1
    expUdf_uid62_fpMulTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0000000000000" & GND_q));
    expUdf_uid62_fpMulTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((13 downto 12 => expRPreExcExt_uid60_fpMulTest_b(11)) & expRPreExcExt_uid60_fpMulTest_b));
    expUdf_uid62_fpMulTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            expUdf_uid62_fpMulTest_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            expUdf_uid62_fpMulTest_o <= STD_LOGIC_VECTOR(SIGNED(expUdf_uid62_fpMulTest_a) - SIGNED(expUdf_uid62_fpMulTest_b));
        END IF;
    END PROCESS;
    expUdf_uid62_fpMulTest_n(0) <= not (expUdf_uid62_fpMulTest_o(13));

    -- excZC3_uid68_fpMulTest(LOGICAL,67)@3
    excZC3_uid68_fpMulTest_q <= excR_x_uid23_fpMulTest_q and excR_y_uid37_fpMulTest_q and expUdf_uid62_fpMulTest_n;

    -- excYZAndExcXR_uid67_fpMulTest(LOGICAL,66)@3
    excYZAndExcXR_uid67_fpMulTest_q <= redist6_excZ_y_uid29_fpMulTest_q_3_q and excR_x_uid23_fpMulTest_q;

    -- excXZAndExcYR_uid66_fpMulTest(LOGICAL,65)@3
    excXZAndExcYR_uid66_fpMulTest_q <= redist9_excZ_x_uid15_fpMulTest_q_3_q and excR_y_uid37_fpMulTest_q;

    -- excXZAndExcYZ_uid65_fpMulTest(LOGICAL,64)@3
    excXZAndExcYZ_uid65_fpMulTest_q <= redist9_excZ_x_uid15_fpMulTest_q_3_q and redist6_excZ_y_uid29_fpMulTest_q_3_q;

    -- excRZero_uid69_fpMulTest(LOGICAL,68)@3
    excRZero_uid69_fpMulTest_q <= excXZAndExcYZ_uid65_fpMulTest_q or excXZAndExcYR_uid66_fpMulTest_q or excYZAndExcXR_uid67_fpMulTest_q or excZC3_uid68_fpMulTest_q;

    -- concExc_uid79_fpMulTest(BITJOIN,78)@3
    concExc_uid79_fpMulTest_q <= excRNaN_uid78_fpMulTest_q & excRInf_uid74_fpMulTest_q & excRZero_uid69_fpMulTest_q;

    -- excREnc_uid80_fpMulTest(LOOKUP,79)@3
    excREnc_uid80_fpMulTest_combproc: PROCESS (concExc_uid79_fpMulTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (concExc_uid79_fpMulTest_q) IS
            WHEN "000" => excREnc_uid80_fpMulTest_q <= "01";
            WHEN "001" => excREnc_uid80_fpMulTest_q <= "00";
            WHEN "010" => excREnc_uid80_fpMulTest_q <= "10";
            WHEN "011" => excREnc_uid80_fpMulTest_q <= "00";
            WHEN "100" => excREnc_uid80_fpMulTest_q <= "11";
            WHEN "101" => excREnc_uid80_fpMulTest_q <= "00";
            WHEN "110" => excREnc_uid80_fpMulTest_q <= "00";
            WHEN "111" => excREnc_uid80_fpMulTest_q <= "00";
            WHEN OTHERS => -- unreachable
                           excREnc_uid80_fpMulTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- expRPostExc_uid89_fpMulTest(MUX,88)@3
    expRPostExc_uid89_fpMulTest_s <= excREnc_uid80_fpMulTest_q;
    expRPostExc_uid89_fpMulTest_combproc: PROCESS (expRPostExc_uid89_fpMulTest_s, cstAllZWE_uid12_fpMulTest_q, redist0_expRPreExc_uid61_fpMulTest_b_1_q, cstAllOWE_uid10_fpMulTest_q)
    BEGIN
        CASE (expRPostExc_uid89_fpMulTest_s) IS
            WHEN "00" => expRPostExc_uid89_fpMulTest_q <= cstAllZWE_uid12_fpMulTest_q;
            WHEN "01" => expRPostExc_uid89_fpMulTest_q <= redist0_expRPreExc_uid61_fpMulTest_b_1_q;
            WHEN "10" => expRPostExc_uid89_fpMulTest_q <= cstAllOWE_uid10_fpMulTest_q;
            WHEN "11" => expRPostExc_uid89_fpMulTest_q <= cstAllOWE_uid10_fpMulTest_q;
            WHEN OTHERS => expRPostExc_uid89_fpMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- oneFracRPostExc2_uid81_fpMulTest(CONSTANT,80)
    oneFracRPostExc2_uid81_fpMulTest_q <= "00000000000000000000001";

    -- fracRPreExc_uid59_fpMulTest(BITSELECT,58)@2
    fracRPreExc_uid59_fpMulTest_in <= expFracRPostRounding_uid58_fpMulTest_q(23 downto 0);
    fracRPreExc_uid59_fpMulTest_b <= fracRPreExc_uid59_fpMulTest_in(23 downto 1);

    -- redist1_fracRPreExc_uid59_fpMulTest_b_1(DELAY,98)
    redist1_fracRPreExc_uid59_fpMulTest_b_1 : dspba_delay
    GENERIC MAP ( width => 23, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracRPreExc_uid59_fpMulTest_b, xout => redist1_fracRPreExc_uid59_fpMulTest_b_1_q, clk => clk, aclr => areset );

    -- fracRPostExc_uid84_fpMulTest(MUX,83)@3
    fracRPostExc_uid84_fpMulTest_s <= excREnc_uid80_fpMulTest_q;
    fracRPostExc_uid84_fpMulTest_combproc: PROCESS (fracRPostExc_uid84_fpMulTest_s, cstZeroWF_uid11_fpMulTest_q, redist1_fracRPreExc_uid59_fpMulTest_b_1_q, oneFracRPostExc2_uid81_fpMulTest_q)
    BEGIN
        CASE (fracRPostExc_uid84_fpMulTest_s) IS
            WHEN "00" => fracRPostExc_uid84_fpMulTest_q <= cstZeroWF_uid11_fpMulTest_q;
            WHEN "01" => fracRPostExc_uid84_fpMulTest_q <= redist1_fracRPreExc_uid59_fpMulTest_b_1_q;
            WHEN "10" => fracRPostExc_uid84_fpMulTest_q <= cstZeroWF_uid11_fpMulTest_q;
            WHEN "11" => fracRPostExc_uid84_fpMulTest_q <= oneFracRPostExc2_uid81_fpMulTest_q;
            WHEN OTHERS => fracRPostExc_uid84_fpMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- R_uid92_fpMulTest(BITJOIN,91)@3
    R_uid92_fpMulTest_q <= signRPostExc_uid91_fpMulTest_q & expRPostExc_uid89_fpMulTest_q & fracRPostExc_uid84_fpMulTest_q;

    -- xOut(GPOUT,4)@3
    q <= R_uid92_fpMulTest_q;

END normal;
