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

-- VHDL created from sqrt_s_0002
-- VHDL created on Fri Mar 08 18:13:39 2019


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

entity sqrt_s_0002 is
    port (
        a : in std_logic_vector(31 downto 0);  -- float32_m23
        q : out std_logic_vector(31 downto 0);  -- float32_m23
        clk : in std_logic;
        areset : in std_logic
    );
end sqrt_s_0002;

architecture normal of sqrt_s_0002 is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expX_uid6_fpSqrtTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal signX_uid7_fpSqrtTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal cstAllOWE_uid8_fpSqrtTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal cstZeroWF_uid9_fpSqrtTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal cstAllZWE_uid10_fpSqrtTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal frac_x_uid12_fpSqrtTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal excZ_x_uid13_fpSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid14_fpSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid15_fpSqrtTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid15_fpSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid16_fpSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_x_uid17_fpSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_x_uid18_fpSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExpXIsMax_uid19_fpSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal InvExpXIsZero_uid20_fpSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_x_uid21_fpSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sBias_uid22_fpSqrtTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal expEvenSig_uid24_fpSqrtTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal expEvenSig_uid24_fpSqrtTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal expEvenSig_uid24_fpSqrtTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal expEvenSig_uid24_fpSqrtTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal expREven_uid25_fpSqrtTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal sBiasM1_uid26_fpSqrtTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal expOddSig_uid27_fpSqrtTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal expOddSig_uid27_fpSqrtTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal expOddSig_uid27_fpSqrtTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal expOddSig_uid27_fpSqrtTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal expROdd_uid28_fpSqrtTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal expX0PS_uid29_fpSqrtTest_in : STD_LOGIC_VECTOR (0 downto 0);
    signal expX0PS_uid29_fpSqrtTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal expOddSelect_uid30_fpSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expRMux_uid31_fpSqrtTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal expRMux_uid31_fpSqrtTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal addrFull_uid33_fpSqrtTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal yAddr_uid35_fpSqrtTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal yForPe_uid36_fpSqrtTest_in : STD_LOGIC_VECTOR (15 downto 0);
    signal yForPe_uid36_fpSqrtTest_b : STD_LOGIC_VECTOR (15 downto 0);
    signal expInc_uid38_fpSqrtTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal expInc_uid38_fpSqrtTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPostProcessings_uid39_fpSqrtTest_in : STD_LOGIC_VECTOR (28 downto 0);
    signal fracRPostProcessings_uid39_fpSqrtTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal expR_uid40_fpSqrtTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal expR_uid40_fpSqrtTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal expR_uid40_fpSqrtTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal expR_uid40_fpSqrtTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal invSignX_uid41_fpSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal inInfAndNotNeg_uid42_fpSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal minReg_uid43_fpSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal minInf_uid44_fpSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRNaN_uid45_fpSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excConc_uid46_fpSqrtTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal fracSelIn_uid47_fpSqrtTest_q : STD_LOGIC_VECTOR (3 downto 0);
    signal fracSel_uid48_fpSqrtTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal expRR_uid51_fpSqrtTest_in : STD_LOGIC_VECTOR (7 downto 0);
    signal expRR_uid51_fpSqrtTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal expRPostExc_uid53_fpSqrtTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal expRPostExc_uid53_fpSqrtTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal fracNaN_uid54_fpSqrtTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal fracRPostExc_uid58_fpSqrtTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal fracRPostExc_uid58_fpSqrtTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal negZero_uid59_fpSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal RSqrt_uid60_fpSqrtTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal yT1_uid74_invPolyEval_b : STD_LOGIC_VECTOR (11 downto 0);
    signal lowRangeB_uid76_invPolyEval_in : STD_LOGIC_VECTOR (0 downto 0);
    signal lowRangeB_uid76_invPolyEval_b : STD_LOGIC_VECTOR (0 downto 0);
    signal highBBits_uid77_invPolyEval_b : STD_LOGIC_VECTOR (11 downto 0);
    signal s1sumAHighB_uid78_invPolyEval_a : STD_LOGIC_VECTOR (21 downto 0);
    signal s1sumAHighB_uid78_invPolyEval_b : STD_LOGIC_VECTOR (21 downto 0);
    signal s1sumAHighB_uid78_invPolyEval_o : STD_LOGIC_VECTOR (21 downto 0);
    signal s1sumAHighB_uid78_invPolyEval_q : STD_LOGIC_VECTOR (21 downto 0);
    signal s1_uid79_invPolyEval_q : STD_LOGIC_VECTOR (22 downto 0);
    signal lowRangeB_uid82_invPolyEval_in : STD_LOGIC_VECTOR (1 downto 0);
    signal lowRangeB_uid82_invPolyEval_b : STD_LOGIC_VECTOR (1 downto 0);
    signal highBBits_uid83_invPolyEval_b : STD_LOGIC_VECTOR (21 downto 0);
    signal s2sumAHighB_uid84_invPolyEval_a : STD_LOGIC_VECTOR (29 downto 0);
    signal s2sumAHighB_uid84_invPolyEval_b : STD_LOGIC_VECTOR (29 downto 0);
    signal s2sumAHighB_uid84_invPolyEval_o : STD_LOGIC_VECTOR (29 downto 0);
    signal s2sumAHighB_uid84_invPolyEval_q : STD_LOGIC_VECTOR (29 downto 0);
    signal s2_uid85_invPolyEval_q : STD_LOGIC_VECTOR (31 downto 0);
    signal osig_uid88_pT1_uid75_invPolyEval_b : STD_LOGIC_VECTOR (12 downto 0);
    signal osig_uid91_pT2_uid81_invPolyEval_b : STD_LOGIC_VECTOR (23 downto 0);
    signal memoryC0_uid62_sqrtTables_lutmem_reset0 : std_logic;
    signal memoryC0_uid62_sqrtTables_lutmem_ia : STD_LOGIC_VECTOR (28 downto 0);
    signal memoryC0_uid62_sqrtTables_lutmem_aa : STD_LOGIC_VECTOR (7 downto 0);
    signal memoryC0_uid62_sqrtTables_lutmem_ab : STD_LOGIC_VECTOR (7 downto 0);
    signal memoryC0_uid62_sqrtTables_lutmem_ir : STD_LOGIC_VECTOR (28 downto 0);
    signal memoryC0_uid62_sqrtTables_lutmem_r : STD_LOGIC_VECTOR (28 downto 0);
    signal memoryC1_uid65_sqrtTables_lutmem_reset0 : std_logic;
    signal memoryC1_uid65_sqrtTables_lutmem_ia : STD_LOGIC_VECTOR (20 downto 0);
    signal memoryC1_uid65_sqrtTables_lutmem_aa : STD_LOGIC_VECTOR (7 downto 0);
    signal memoryC1_uid65_sqrtTables_lutmem_ab : STD_LOGIC_VECTOR (7 downto 0);
    signal memoryC1_uid65_sqrtTables_lutmem_ir : STD_LOGIC_VECTOR (20 downto 0);
    signal memoryC1_uid65_sqrtTables_lutmem_r : STD_LOGIC_VECTOR (20 downto 0);
    signal memoryC2_uid68_sqrtTables_lutmem_reset0 : std_logic;
    signal memoryC2_uid68_sqrtTables_lutmem_ia : STD_LOGIC_VECTOR (11 downto 0);
    signal memoryC2_uid68_sqrtTables_lutmem_aa : STD_LOGIC_VECTOR (7 downto 0);
    signal memoryC2_uid68_sqrtTables_lutmem_ab : STD_LOGIC_VECTOR (7 downto 0);
    signal memoryC2_uid68_sqrtTables_lutmem_ir : STD_LOGIC_VECTOR (11 downto 0);
    signal memoryC2_uid68_sqrtTables_lutmem_r : STD_LOGIC_VECTOR (11 downto 0);
    signal prodXY_uid87_pT1_uid75_invPolyEval_cma_reset : std_logic;
    type prodXY_uid87_pT1_uid75_invPolyEval_cma_a0type is array(NATURAL range <>) of UNSIGNED(11 downto 0);
    signal prodXY_uid87_pT1_uid75_invPolyEval_cma_a0 : prodXY_uid87_pT1_uid75_invPolyEval_cma_a0type(0 to 0);
    attribute preserve : boolean;
    attribute preserve of prodXY_uid87_pT1_uid75_invPolyEval_cma_a0 : signal is true;
    type prodXY_uid87_pT1_uid75_invPolyEval_cma_c0type is array(NATURAL range <>) of SIGNED(11 downto 0);
    signal prodXY_uid87_pT1_uid75_invPolyEval_cma_c0 : prodXY_uid87_pT1_uid75_invPolyEval_cma_c0type(0 to 0);
    attribute preserve of prodXY_uid87_pT1_uid75_invPolyEval_cma_c0 : signal is true;
    type prodXY_uid87_pT1_uid75_invPolyEval_cma_ltype is array(NATURAL range <>) of SIGNED(12 downto 0);
    signal prodXY_uid87_pT1_uid75_invPolyEval_cma_l : prodXY_uid87_pT1_uid75_invPolyEval_cma_ltype(0 to 0);
    type prodXY_uid87_pT1_uid75_invPolyEval_cma_ptype is array(NATURAL range <>) of SIGNED(24 downto 0);
    signal prodXY_uid87_pT1_uid75_invPolyEval_cma_p : prodXY_uid87_pT1_uid75_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid87_pT1_uid75_invPolyEval_cma_u : prodXY_uid87_pT1_uid75_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid87_pT1_uid75_invPolyEval_cma_w : prodXY_uid87_pT1_uid75_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid87_pT1_uid75_invPolyEval_cma_x : prodXY_uid87_pT1_uid75_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid87_pT1_uid75_invPolyEval_cma_y : prodXY_uid87_pT1_uid75_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid87_pT1_uid75_invPolyEval_cma_s : prodXY_uid87_pT1_uid75_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid87_pT1_uid75_invPolyEval_cma_qq : STD_LOGIC_VECTOR (23 downto 0);
    signal prodXY_uid87_pT1_uid75_invPolyEval_cma_q : STD_LOGIC_VECTOR (23 downto 0);
    signal prodXY_uid87_pT1_uid75_invPolyEval_cma_ena0 : std_logic;
    signal prodXY_uid87_pT1_uid75_invPolyEval_cma_ena1 : std_logic;
    signal prodXY_uid90_pT2_uid81_invPolyEval_cma_reset : std_logic;
    type prodXY_uid90_pT2_uid81_invPolyEval_cma_a0type is array(NATURAL range <>) of UNSIGNED(15 downto 0);
    signal prodXY_uid90_pT2_uid81_invPolyEval_cma_a0 : prodXY_uid90_pT2_uid81_invPolyEval_cma_a0type(0 to 0);
    attribute preserve of prodXY_uid90_pT2_uid81_invPolyEval_cma_a0 : signal is true;
    type prodXY_uid90_pT2_uid81_invPolyEval_cma_c0type is array(NATURAL range <>) of SIGNED(22 downto 0);
    signal prodXY_uid90_pT2_uid81_invPolyEval_cma_c0 : prodXY_uid90_pT2_uid81_invPolyEval_cma_c0type(0 to 0);
    attribute preserve of prodXY_uid90_pT2_uid81_invPolyEval_cma_c0 : signal is true;
    type prodXY_uid90_pT2_uid81_invPolyEval_cma_ltype is array(NATURAL range <>) of SIGNED(16 downto 0);
    signal prodXY_uid90_pT2_uid81_invPolyEval_cma_l : prodXY_uid90_pT2_uid81_invPolyEval_cma_ltype(0 to 0);
    type prodXY_uid90_pT2_uid81_invPolyEval_cma_ptype is array(NATURAL range <>) of SIGNED(39 downto 0);
    signal prodXY_uid90_pT2_uid81_invPolyEval_cma_p : prodXY_uid90_pT2_uid81_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid90_pT2_uid81_invPolyEval_cma_u : prodXY_uid90_pT2_uid81_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid90_pT2_uid81_invPolyEval_cma_w : prodXY_uid90_pT2_uid81_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid90_pT2_uid81_invPolyEval_cma_x : prodXY_uid90_pT2_uid81_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid90_pT2_uid81_invPolyEval_cma_y : prodXY_uid90_pT2_uid81_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid90_pT2_uid81_invPolyEval_cma_s : prodXY_uid90_pT2_uid81_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid90_pT2_uid81_invPolyEval_cma_qq : STD_LOGIC_VECTOR (38 downto 0);
    signal prodXY_uid90_pT2_uid81_invPolyEval_cma_q : STD_LOGIC_VECTOR (38 downto 0);
    signal prodXY_uid90_pT2_uid81_invPolyEval_cma_ena0 : std_logic;
    signal prodXY_uid90_pT2_uid81_invPolyEval_cma_ena1 : std_logic;
    signal redist0_yForPe_uid36_fpSqrtTest_b_2_q : STD_LOGIC_VECTOR (15 downto 0);
    signal redist1_yForPe_uid36_fpSqrtTest_b_4_q : STD_LOGIC_VECTOR (15 downto 0);
    signal redist2_yAddr_uid35_fpSqrtTest_b_2_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist3_yAddr_uid35_fpSqrtTest_b_4_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist4_expOddSelect_uid30_fpSqrtTest_q_6_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist5_fracXIsZero_uid15_fpSqrtTest_q_6_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist6_signX_uid7_fpSqrtTest_b_6_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist7_expX_uid6_fpSqrtTest_b_6_mem_reset0 : std_logic;
    signal redist7_expX_uid6_fpSqrtTest_b_6_mem_ia : STD_LOGIC_VECTOR (7 downto 0);
    signal redist7_expX_uid6_fpSqrtTest_b_6_mem_aa : STD_LOGIC_VECTOR (2 downto 0);
    signal redist7_expX_uid6_fpSqrtTest_b_6_mem_ab : STD_LOGIC_VECTOR (2 downto 0);
    signal redist7_expX_uid6_fpSqrtTest_b_6_mem_iq : STD_LOGIC_VECTOR (7 downto 0);
    signal redist7_expX_uid6_fpSqrtTest_b_6_mem_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist7_expX_uid6_fpSqrtTest_b_6_rdcnt_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist7_expX_uid6_fpSqrtTest_b_6_rdcnt_i : UNSIGNED (2 downto 0);
    attribute preserve of redist7_expX_uid6_fpSqrtTest_b_6_rdcnt_i : signal is true;
    signal redist7_expX_uid6_fpSqrtTest_b_6_rdcnt_eq : std_logic;
    attribute preserve of redist7_expX_uid6_fpSqrtTest_b_6_rdcnt_eq : signal is true;
    signal redist7_expX_uid6_fpSqrtTest_b_6_wraddr_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist7_expX_uid6_fpSqrtTest_b_6_mem_last_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist7_expX_uid6_fpSqrtTest_b_6_cmp_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist7_expX_uid6_fpSqrtTest_b_6_cmpReg_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist7_expX_uid6_fpSqrtTest_b_6_notEnable_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist7_expX_uid6_fpSqrtTest_b_6_nor_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist7_expX_uid6_fpSqrtTest_b_6_sticky_ena_q : STD_LOGIC_VECTOR (0 downto 0);
    attribute dont_merge : boolean;
    attribute dont_merge of redist7_expX_uid6_fpSqrtTest_b_6_sticky_ena_q : signal is true;
    signal redist7_expX_uid6_fpSqrtTest_b_6_enaAnd_q : STD_LOGIC_VECTOR (0 downto 0);

begin


    -- signX_uid7_fpSqrtTest(BITSELECT,6)@0
    signX_uid7_fpSqrtTest_b <= STD_LOGIC_VECTOR(a(31 downto 31));

    -- redist6_signX_uid7_fpSqrtTest_b_6(DELAY,103)
    redist6_signX_uid7_fpSqrtTest_b_6 : dspba_delay
    GENERIC MAP ( width => 1, depth => 6, reset_kind => "ASYNC" )
    PORT MAP ( xin => signX_uid7_fpSqrtTest_b, xout => redist6_signX_uid7_fpSqrtTest_b_6_q, clk => clk, aclr => areset );

    -- cstAllZWE_uid10_fpSqrtTest(CONSTANT,9)
    cstAllZWE_uid10_fpSqrtTest_q <= "00000000";

    -- redist7_expX_uid6_fpSqrtTest_b_6_notEnable(LOGICAL,111)
    redist7_expX_uid6_fpSqrtTest_b_6_notEnable_q <= STD_LOGIC_VECTOR(not (VCC_q));

    -- redist7_expX_uid6_fpSqrtTest_b_6_nor(LOGICAL,112)
    redist7_expX_uid6_fpSqrtTest_b_6_nor_q <= not (redist7_expX_uid6_fpSqrtTest_b_6_notEnable_q or redist7_expX_uid6_fpSqrtTest_b_6_sticky_ena_q);

    -- redist7_expX_uid6_fpSqrtTest_b_6_mem_last(CONSTANT,108)
    redist7_expX_uid6_fpSqrtTest_b_6_mem_last_q <= "011";

    -- redist7_expX_uid6_fpSqrtTest_b_6_cmp(LOGICAL,109)
    redist7_expX_uid6_fpSqrtTest_b_6_cmp_q <= "1" WHEN redist7_expX_uid6_fpSqrtTest_b_6_mem_last_q = redist7_expX_uid6_fpSqrtTest_b_6_rdcnt_q ELSE "0";

    -- redist7_expX_uid6_fpSqrtTest_b_6_cmpReg(REG,110)
    redist7_expX_uid6_fpSqrtTest_b_6_cmpReg_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            redist7_expX_uid6_fpSqrtTest_b_6_cmpReg_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            redist7_expX_uid6_fpSqrtTest_b_6_cmpReg_q <= STD_LOGIC_VECTOR(redist7_expX_uid6_fpSqrtTest_b_6_cmp_q);
        END IF;
    END PROCESS;

    -- redist7_expX_uid6_fpSqrtTest_b_6_sticky_ena(REG,113)
    redist7_expX_uid6_fpSqrtTest_b_6_sticky_ena_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            redist7_expX_uid6_fpSqrtTest_b_6_sticky_ena_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (redist7_expX_uid6_fpSqrtTest_b_6_nor_q = "1") THEN
                redist7_expX_uid6_fpSqrtTest_b_6_sticky_ena_q <= STD_LOGIC_VECTOR(redist7_expX_uid6_fpSqrtTest_b_6_cmpReg_q);
            END IF;
        END IF;
    END PROCESS;

    -- redist7_expX_uid6_fpSqrtTest_b_6_enaAnd(LOGICAL,114)
    redist7_expX_uid6_fpSqrtTest_b_6_enaAnd_q <= redist7_expX_uid6_fpSqrtTest_b_6_sticky_ena_q and VCC_q;

    -- redist7_expX_uid6_fpSqrtTest_b_6_rdcnt(COUNTER,106)
    -- low=0, high=4, step=1, init=0
    redist7_expX_uid6_fpSqrtTest_b_6_rdcnt_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            redist7_expX_uid6_fpSqrtTest_b_6_rdcnt_i <= TO_UNSIGNED(0, 3);
            redist7_expX_uid6_fpSqrtTest_b_6_rdcnt_eq <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (redist7_expX_uid6_fpSqrtTest_b_6_rdcnt_i = TO_UNSIGNED(3, 3)) THEN
                redist7_expX_uid6_fpSqrtTest_b_6_rdcnt_eq <= '1';
            ELSE
                redist7_expX_uid6_fpSqrtTest_b_6_rdcnt_eq <= '0';
            END IF;
            IF (redist7_expX_uid6_fpSqrtTest_b_6_rdcnt_eq = '1') THEN
                redist7_expX_uid6_fpSqrtTest_b_6_rdcnt_i <= redist7_expX_uid6_fpSqrtTest_b_6_rdcnt_i + 4;
            ELSE
                redist7_expX_uid6_fpSqrtTest_b_6_rdcnt_i <= redist7_expX_uid6_fpSqrtTest_b_6_rdcnt_i + 1;
            END IF;
        END IF;
    END PROCESS;
    redist7_expX_uid6_fpSqrtTest_b_6_rdcnt_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(redist7_expX_uid6_fpSqrtTest_b_6_rdcnt_i, 3)));

    -- expX_uid6_fpSqrtTest(BITSELECT,5)@0
    expX_uid6_fpSqrtTest_b <= a(30 downto 23);

    -- redist7_expX_uid6_fpSqrtTest_b_6_wraddr(REG,107)
    redist7_expX_uid6_fpSqrtTest_b_6_wraddr_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            redist7_expX_uid6_fpSqrtTest_b_6_wraddr_q <= "100";
        ELSIF (clk'EVENT AND clk = '1') THEN
            redist7_expX_uid6_fpSqrtTest_b_6_wraddr_q <= STD_LOGIC_VECTOR(redist7_expX_uid6_fpSqrtTest_b_6_rdcnt_q);
        END IF;
    END PROCESS;

    -- redist7_expX_uid6_fpSqrtTest_b_6_mem(DUALMEM,105)
    redist7_expX_uid6_fpSqrtTest_b_6_mem_ia <= STD_LOGIC_VECTOR(expX_uid6_fpSqrtTest_b);
    redist7_expX_uid6_fpSqrtTest_b_6_mem_aa <= redist7_expX_uid6_fpSqrtTest_b_6_wraddr_q;
    redist7_expX_uid6_fpSqrtTest_b_6_mem_ab <= redist7_expX_uid6_fpSqrtTest_b_6_rdcnt_q;
    redist7_expX_uid6_fpSqrtTest_b_6_mem_reset0 <= areset;
    redist7_expX_uid6_fpSqrtTest_b_6_mem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "MLAB",
        operation_mode => "DUAL_PORT",
        width_a => 8,
        widthad_a => 3,
        numwords_a => 5,
        width_b => 8,
        widthad_b => 3,
        numwords_b => 5,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        address_reg_b => "CLOCK0",
        indata_reg_b => "CLOCK0",
        rdcontrol_reg_b => "CLOCK0",
        byteena_reg_b => "CLOCK0",
        outdata_reg_b => "CLOCK1",
        outdata_aclr_b => "CLEAR1",
        clock_enable_input_a => "NORMAL",
        clock_enable_input_b => "NORMAL",
        clock_enable_output_b => "NORMAL",
        read_during_write_mode_mixed_ports => "DONT_CARE",
        power_up_uninitialized => "TRUE",
        intended_device_family => "Cyclone V"
    )
    PORT MAP (
        clocken1 => redist7_expX_uid6_fpSqrtTest_b_6_enaAnd_q(0),
        clocken0 => VCC_q(0),
        clock0 => clk,
        aclr1 => redist7_expX_uid6_fpSqrtTest_b_6_mem_reset0,
        clock1 => clk,
        address_a => redist7_expX_uid6_fpSqrtTest_b_6_mem_aa,
        data_a => redist7_expX_uid6_fpSqrtTest_b_6_mem_ia,
        wren_a => VCC_q(0),
        address_b => redist7_expX_uid6_fpSqrtTest_b_6_mem_ab,
        q_b => redist7_expX_uid6_fpSqrtTest_b_6_mem_iq
    );
    redist7_expX_uid6_fpSqrtTest_b_6_mem_q <= redist7_expX_uid6_fpSqrtTest_b_6_mem_iq(7 downto 0);

    -- excZ_x_uid13_fpSqrtTest(LOGICAL,12)@6
    excZ_x_uid13_fpSqrtTest_q <= "1" WHEN redist7_expX_uid6_fpSqrtTest_b_6_mem_q = cstAllZWE_uid10_fpSqrtTest_q ELSE "0";

    -- VCC(CONSTANT,1)
    VCC_q <= "1";

    -- negZero_uid59_fpSqrtTest(LOGICAL,58)@6
    negZero_uid59_fpSqrtTest_q <= excZ_x_uid13_fpSqrtTest_q and redist6_signX_uid7_fpSqrtTest_b_6_q;

    -- cstAllOWE_uid8_fpSqrtTest(CONSTANT,7)
    cstAllOWE_uid8_fpSqrtTest_q <= "11111111";

    -- expX0PS_uid29_fpSqrtTest(BITSELECT,28)@0
    expX0PS_uid29_fpSqrtTest_in <= STD_LOGIC_VECTOR(expX_uid6_fpSqrtTest_b(0 downto 0));
    expX0PS_uid29_fpSqrtTest_b <= STD_LOGIC_VECTOR(expX0PS_uid29_fpSqrtTest_in(0 downto 0));

    -- expOddSelect_uid30_fpSqrtTest(LOGICAL,29)@0
    expOddSelect_uid30_fpSqrtTest_q <= not (expX0PS_uid29_fpSqrtTest_b);

    -- frac_x_uid12_fpSqrtTest(BITSELECT,11)@0
    frac_x_uid12_fpSqrtTest_b <= a(22 downto 0);

    -- addrFull_uid33_fpSqrtTest(BITJOIN,32)@0
    addrFull_uid33_fpSqrtTest_q <= expOddSelect_uid30_fpSqrtTest_q & frac_x_uid12_fpSqrtTest_b;

    -- yAddr_uid35_fpSqrtTest(BITSELECT,34)@0
    yAddr_uid35_fpSqrtTest_b <= addrFull_uid33_fpSqrtTest_q(23 downto 16);

    -- memoryC2_uid68_sqrtTables_lutmem(DUALMEM,94)@0 + 2
    -- in j@20000000
    memoryC2_uid68_sqrtTables_lutmem_aa <= yAddr_uid35_fpSqrtTest_b;
    memoryC2_uid68_sqrtTables_lutmem_reset0 <= areset;
    memoryC2_uid68_sqrtTables_lutmem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M10K",
        operation_mode => "ROM",
        width_a => 12,
        widthad_a => 8,
        numwords_a => 256,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        outdata_reg_a => "CLOCK0",
        outdata_aclr_a => "CLEAR0",
        clock_enable_input_a => "NORMAL",
        power_up_uninitialized => "FALSE",
        init_file => "sqrt_s_0002_memoryC2_uid68_sqrtTables_lutmem.hex",
        init_file_layout => "PORT_A",
        intended_device_family => "Cyclone V"
    )
    PORT MAP (
        clocken0 => VCC_q(0),
        aclr0 => memoryC2_uid68_sqrtTables_lutmem_reset0,
        clock0 => clk,
        address_a => memoryC2_uid68_sqrtTables_lutmem_aa,
        q_a => memoryC2_uid68_sqrtTables_lutmem_ir
    );
    memoryC2_uid68_sqrtTables_lutmem_r <= memoryC2_uid68_sqrtTables_lutmem_ir(11 downto 0);

    -- yForPe_uid36_fpSqrtTest(BITSELECT,35)@0
    yForPe_uid36_fpSqrtTest_in <= frac_x_uid12_fpSqrtTest_b(15 downto 0);
    yForPe_uid36_fpSqrtTest_b <= yForPe_uid36_fpSqrtTest_in(15 downto 0);

    -- redist0_yForPe_uid36_fpSqrtTest_b_2(DELAY,97)
    redist0_yForPe_uid36_fpSqrtTest_b_2 : dspba_delay
    GENERIC MAP ( width => 16, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => yForPe_uid36_fpSqrtTest_b, xout => redist0_yForPe_uid36_fpSqrtTest_b_2_q, clk => clk, aclr => areset );

    -- yT1_uid74_invPolyEval(BITSELECT,73)@2
    yT1_uid74_invPolyEval_b <= redist0_yForPe_uid36_fpSqrtTest_b_2_q(15 downto 4);

    -- prodXY_uid87_pT1_uid75_invPolyEval_cma(CHAINMULTADD,95)@2 + 2
    prodXY_uid87_pT1_uid75_invPolyEval_cma_reset <= areset;
    prodXY_uid87_pT1_uid75_invPolyEval_cma_ena0 <= '1';
    prodXY_uid87_pT1_uid75_invPolyEval_cma_ena1 <= prodXY_uid87_pT1_uid75_invPolyEval_cma_ena0;
    prodXY_uid87_pT1_uid75_invPolyEval_cma_l(0) <= SIGNED(RESIZE(prodXY_uid87_pT1_uid75_invPolyEval_cma_a0(0),13));
    prodXY_uid87_pT1_uid75_invPolyEval_cma_p(0) <= prodXY_uid87_pT1_uid75_invPolyEval_cma_l(0) * prodXY_uid87_pT1_uid75_invPolyEval_cma_c0(0);
    prodXY_uid87_pT1_uid75_invPolyEval_cma_u(0) <= RESIZE(prodXY_uid87_pT1_uid75_invPolyEval_cma_p(0),25);
    prodXY_uid87_pT1_uid75_invPolyEval_cma_w(0) <= prodXY_uid87_pT1_uid75_invPolyEval_cma_u(0);
    prodXY_uid87_pT1_uid75_invPolyEval_cma_x(0) <= prodXY_uid87_pT1_uid75_invPolyEval_cma_w(0);
    prodXY_uid87_pT1_uid75_invPolyEval_cma_y(0) <= prodXY_uid87_pT1_uid75_invPolyEval_cma_x(0);
    prodXY_uid87_pT1_uid75_invPolyEval_cma_chainmultadd_input: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid87_pT1_uid75_invPolyEval_cma_a0 <= (others => (others => '0'));
            prodXY_uid87_pT1_uid75_invPolyEval_cma_c0 <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (prodXY_uid87_pT1_uid75_invPolyEval_cma_ena0 = '1') THEN
                prodXY_uid87_pT1_uid75_invPolyEval_cma_a0(0) <= RESIZE(UNSIGNED(yT1_uid74_invPolyEval_b),12);
                prodXY_uid87_pT1_uid75_invPolyEval_cma_c0(0) <= RESIZE(SIGNED(memoryC2_uid68_sqrtTables_lutmem_r),12);
            END IF;
        END IF;
    END PROCESS;
    prodXY_uid87_pT1_uid75_invPolyEval_cma_chainmultadd_output: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid87_pT1_uid75_invPolyEval_cma_s <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (prodXY_uid87_pT1_uid75_invPolyEval_cma_ena1 = '1') THEN
                prodXY_uid87_pT1_uid75_invPolyEval_cma_s(0) <= prodXY_uid87_pT1_uid75_invPolyEval_cma_y(0);
            END IF;
        END IF;
    END PROCESS;
    prodXY_uid87_pT1_uid75_invPolyEval_cma_delay : dspba_delay
    GENERIC MAP ( width => 24, depth => 0, reset_kind => "ASYNC" )
    PORT MAP ( xin => STD_LOGIC_VECTOR(prodXY_uid87_pT1_uid75_invPolyEval_cma_s(0)(23 downto 0)), xout => prodXY_uid87_pT1_uid75_invPolyEval_cma_qq, clk => clk, aclr => areset );
    prodXY_uid87_pT1_uid75_invPolyEval_cma_q <= STD_LOGIC_VECTOR(prodXY_uid87_pT1_uid75_invPolyEval_cma_qq(23 downto 0));

    -- osig_uid88_pT1_uid75_invPolyEval(BITSELECT,87)@4
    osig_uid88_pT1_uid75_invPolyEval_b <= STD_LOGIC_VECTOR(prodXY_uid87_pT1_uid75_invPolyEval_cma_q(23 downto 11));

    -- highBBits_uid77_invPolyEval(BITSELECT,76)@4
    highBBits_uid77_invPolyEval_b <= STD_LOGIC_VECTOR(osig_uid88_pT1_uid75_invPolyEval_b(12 downto 1));

    -- redist2_yAddr_uid35_fpSqrtTest_b_2(DELAY,99)
    redist2_yAddr_uid35_fpSqrtTest_b_2 : dspba_delay
    GENERIC MAP ( width => 8, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => yAddr_uid35_fpSqrtTest_b, xout => redist2_yAddr_uid35_fpSqrtTest_b_2_q, clk => clk, aclr => areset );

    -- memoryC1_uid65_sqrtTables_lutmem(DUALMEM,93)@2 + 2
    -- in j@20000000
    memoryC1_uid65_sqrtTables_lutmem_aa <= redist2_yAddr_uid35_fpSqrtTest_b_2_q;
    memoryC1_uid65_sqrtTables_lutmem_reset0 <= areset;
    memoryC1_uid65_sqrtTables_lutmem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M10K",
        operation_mode => "ROM",
        width_a => 21,
        widthad_a => 8,
        numwords_a => 256,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        outdata_reg_a => "CLOCK0",
        outdata_aclr_a => "CLEAR0",
        clock_enable_input_a => "NORMAL",
        power_up_uninitialized => "FALSE",
        init_file => "sqrt_s_0002_memoryC1_uid65_sqrtTables_lutmem.hex",
        init_file_layout => "PORT_A",
        intended_device_family => "Cyclone V"
    )
    PORT MAP (
        clocken0 => VCC_q(0),
        aclr0 => memoryC1_uid65_sqrtTables_lutmem_reset0,
        clock0 => clk,
        address_a => memoryC1_uid65_sqrtTables_lutmem_aa,
        q_a => memoryC1_uid65_sqrtTables_lutmem_ir
    );
    memoryC1_uid65_sqrtTables_lutmem_r <= memoryC1_uid65_sqrtTables_lutmem_ir(20 downto 0);

    -- s1sumAHighB_uid78_invPolyEval(ADD,77)@4
    s1sumAHighB_uid78_invPolyEval_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((21 downto 21 => memoryC1_uid65_sqrtTables_lutmem_r(20)) & memoryC1_uid65_sqrtTables_lutmem_r));
    s1sumAHighB_uid78_invPolyEval_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((21 downto 12 => highBBits_uid77_invPolyEval_b(11)) & highBBits_uid77_invPolyEval_b));
    s1sumAHighB_uid78_invPolyEval_o <= STD_LOGIC_VECTOR(SIGNED(s1sumAHighB_uid78_invPolyEval_a) + SIGNED(s1sumAHighB_uid78_invPolyEval_b));
    s1sumAHighB_uid78_invPolyEval_q <= s1sumAHighB_uid78_invPolyEval_o(21 downto 0);

    -- lowRangeB_uid76_invPolyEval(BITSELECT,75)@4
    lowRangeB_uid76_invPolyEval_in <= osig_uid88_pT1_uid75_invPolyEval_b(0 downto 0);
    lowRangeB_uid76_invPolyEval_b <= lowRangeB_uid76_invPolyEval_in(0 downto 0);

    -- s1_uid79_invPolyEval(BITJOIN,78)@4
    s1_uid79_invPolyEval_q <= s1sumAHighB_uid78_invPolyEval_q & lowRangeB_uid76_invPolyEval_b;

    -- redist1_yForPe_uid36_fpSqrtTest_b_4(DELAY,98)
    redist1_yForPe_uid36_fpSqrtTest_b_4 : dspba_delay
    GENERIC MAP ( width => 16, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist0_yForPe_uid36_fpSqrtTest_b_2_q, xout => redist1_yForPe_uid36_fpSqrtTest_b_4_q, clk => clk, aclr => areset );

    -- GND(CONSTANT,0)
    GND_q <= "0";

    -- prodXY_uid90_pT2_uid81_invPolyEval_cma(CHAINMULTADD,96)@4 + 2
    prodXY_uid90_pT2_uid81_invPolyEval_cma_reset <= areset;
    prodXY_uid90_pT2_uid81_invPolyEval_cma_ena0 <= '1';
    prodXY_uid90_pT2_uid81_invPolyEval_cma_ena1 <= prodXY_uid90_pT2_uid81_invPolyEval_cma_ena0;
    prodXY_uid90_pT2_uid81_invPolyEval_cma_l(0) <= SIGNED(RESIZE(prodXY_uid90_pT2_uid81_invPolyEval_cma_a0(0),17));
    prodXY_uid90_pT2_uid81_invPolyEval_cma_p(0) <= prodXY_uid90_pT2_uid81_invPolyEval_cma_l(0) * prodXY_uid90_pT2_uid81_invPolyEval_cma_c0(0);
    prodXY_uid90_pT2_uid81_invPolyEval_cma_u(0) <= RESIZE(prodXY_uid90_pT2_uid81_invPolyEval_cma_p(0),40);
    prodXY_uid90_pT2_uid81_invPolyEval_cma_w(0) <= prodXY_uid90_pT2_uid81_invPolyEval_cma_u(0);
    prodXY_uid90_pT2_uid81_invPolyEval_cma_x(0) <= prodXY_uid90_pT2_uid81_invPolyEval_cma_w(0);
    prodXY_uid90_pT2_uid81_invPolyEval_cma_y(0) <= prodXY_uid90_pT2_uid81_invPolyEval_cma_x(0);
    prodXY_uid90_pT2_uid81_invPolyEval_cma_chainmultadd_input: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid90_pT2_uid81_invPolyEval_cma_a0 <= (others => (others => '0'));
            prodXY_uid90_pT2_uid81_invPolyEval_cma_c0 <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (prodXY_uid90_pT2_uid81_invPolyEval_cma_ena0 = '1') THEN
                prodXY_uid90_pT2_uid81_invPolyEval_cma_a0(0) <= RESIZE(UNSIGNED(redist1_yForPe_uid36_fpSqrtTest_b_4_q),16);
                prodXY_uid90_pT2_uid81_invPolyEval_cma_c0(0) <= RESIZE(SIGNED(s1_uid79_invPolyEval_q),23);
            END IF;
        END IF;
    END PROCESS;
    prodXY_uid90_pT2_uid81_invPolyEval_cma_chainmultadd_output: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid90_pT2_uid81_invPolyEval_cma_s <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (prodXY_uid90_pT2_uid81_invPolyEval_cma_ena1 = '1') THEN
                prodXY_uid90_pT2_uid81_invPolyEval_cma_s(0) <= prodXY_uid90_pT2_uid81_invPolyEval_cma_y(0);
            END IF;
        END IF;
    END PROCESS;
    prodXY_uid90_pT2_uid81_invPolyEval_cma_delay : dspba_delay
    GENERIC MAP ( width => 39, depth => 0, reset_kind => "ASYNC" )
    PORT MAP ( xin => STD_LOGIC_VECTOR(prodXY_uid90_pT2_uid81_invPolyEval_cma_s(0)(38 downto 0)), xout => prodXY_uid90_pT2_uid81_invPolyEval_cma_qq, clk => clk, aclr => areset );
    prodXY_uid90_pT2_uid81_invPolyEval_cma_q <= STD_LOGIC_VECTOR(prodXY_uid90_pT2_uid81_invPolyEval_cma_qq(38 downto 0));

    -- osig_uid91_pT2_uid81_invPolyEval(BITSELECT,90)@6
    osig_uid91_pT2_uid81_invPolyEval_b <= STD_LOGIC_VECTOR(prodXY_uid90_pT2_uid81_invPolyEval_cma_q(38 downto 15));

    -- highBBits_uid83_invPolyEval(BITSELECT,82)@6
    highBBits_uid83_invPolyEval_b <= STD_LOGIC_VECTOR(osig_uid91_pT2_uid81_invPolyEval_b(23 downto 2));

    -- redist3_yAddr_uid35_fpSqrtTest_b_4(DELAY,100)
    redist3_yAddr_uid35_fpSqrtTest_b_4 : dspba_delay
    GENERIC MAP ( width => 8, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist2_yAddr_uid35_fpSqrtTest_b_2_q, xout => redist3_yAddr_uid35_fpSqrtTest_b_4_q, clk => clk, aclr => areset );

    -- memoryC0_uid62_sqrtTables_lutmem(DUALMEM,92)@4 + 2
    -- in j@20000000
    memoryC0_uid62_sqrtTables_lutmem_aa <= redist3_yAddr_uid35_fpSqrtTest_b_4_q;
    memoryC0_uid62_sqrtTables_lutmem_reset0 <= areset;
    memoryC0_uid62_sqrtTables_lutmem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M10K",
        operation_mode => "ROM",
        width_a => 29,
        widthad_a => 8,
        numwords_a => 256,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        outdata_reg_a => "CLOCK0",
        outdata_aclr_a => "CLEAR0",
        clock_enable_input_a => "NORMAL",
        power_up_uninitialized => "FALSE",
        init_file => "sqrt_s_0002_memoryC0_uid62_sqrtTables_lutmem.hex",
        init_file_layout => "PORT_A",
        intended_device_family => "Cyclone V"
    )
    PORT MAP (
        clocken0 => VCC_q(0),
        aclr0 => memoryC0_uid62_sqrtTables_lutmem_reset0,
        clock0 => clk,
        address_a => memoryC0_uid62_sqrtTables_lutmem_aa,
        q_a => memoryC0_uid62_sqrtTables_lutmem_ir
    );
    memoryC0_uid62_sqrtTables_lutmem_r <= memoryC0_uid62_sqrtTables_lutmem_ir(28 downto 0);

    -- s2sumAHighB_uid84_invPolyEval(ADD,83)@6
    s2sumAHighB_uid84_invPolyEval_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((29 downto 29 => memoryC0_uid62_sqrtTables_lutmem_r(28)) & memoryC0_uid62_sqrtTables_lutmem_r));
    s2sumAHighB_uid84_invPolyEval_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((29 downto 22 => highBBits_uid83_invPolyEval_b(21)) & highBBits_uid83_invPolyEval_b));
    s2sumAHighB_uid84_invPolyEval_o <= STD_LOGIC_VECTOR(SIGNED(s2sumAHighB_uid84_invPolyEval_a) + SIGNED(s2sumAHighB_uid84_invPolyEval_b));
    s2sumAHighB_uid84_invPolyEval_q <= s2sumAHighB_uid84_invPolyEval_o(29 downto 0);

    -- lowRangeB_uid82_invPolyEval(BITSELECT,81)@6
    lowRangeB_uid82_invPolyEval_in <= osig_uid91_pT2_uid81_invPolyEval_b(1 downto 0);
    lowRangeB_uid82_invPolyEval_b <= lowRangeB_uid82_invPolyEval_in(1 downto 0);

    -- s2_uid85_invPolyEval(BITJOIN,84)@6
    s2_uid85_invPolyEval_q <= s2sumAHighB_uid84_invPolyEval_q & lowRangeB_uid82_invPolyEval_b;

    -- expInc_uid38_fpSqrtTest(BITSELECT,37)@6
    expInc_uid38_fpSqrtTest_in <= STD_LOGIC_VECTOR(s2_uid85_invPolyEval_q(30 downto 0));
    expInc_uid38_fpSqrtTest_b <= STD_LOGIC_VECTOR(expInc_uid38_fpSqrtTest_in(30 downto 30));

    -- sBiasM1_uid26_fpSqrtTest(CONSTANT,25)
    sBiasM1_uid26_fpSqrtTest_q <= "01111110";

    -- expOddSig_uid27_fpSqrtTest(ADD,26)@6
    expOddSig_uid27_fpSqrtTest_a <= STD_LOGIC_VECTOR("0" & redist7_expX_uid6_fpSqrtTest_b_6_mem_q);
    expOddSig_uid27_fpSqrtTest_b <= STD_LOGIC_VECTOR("0" & sBiasM1_uid26_fpSqrtTest_q);
    expOddSig_uid27_fpSqrtTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expOddSig_uid27_fpSqrtTest_a) + UNSIGNED(expOddSig_uid27_fpSqrtTest_b));
    expOddSig_uid27_fpSqrtTest_q <= expOddSig_uid27_fpSqrtTest_o(8 downto 0);

    -- expROdd_uid28_fpSqrtTest(BITSELECT,27)@6
    expROdd_uid28_fpSqrtTest_b <= expOddSig_uid27_fpSqrtTest_q(8 downto 1);

    -- sBias_uid22_fpSqrtTest(CONSTANT,21)
    sBias_uid22_fpSqrtTest_q <= "01111111";

    -- expEvenSig_uid24_fpSqrtTest(ADD,23)@6
    expEvenSig_uid24_fpSqrtTest_a <= STD_LOGIC_VECTOR("0" & redist7_expX_uid6_fpSqrtTest_b_6_mem_q);
    expEvenSig_uid24_fpSqrtTest_b <= STD_LOGIC_VECTOR("0" & sBias_uid22_fpSqrtTest_q);
    expEvenSig_uid24_fpSqrtTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expEvenSig_uid24_fpSqrtTest_a) + UNSIGNED(expEvenSig_uid24_fpSqrtTest_b));
    expEvenSig_uid24_fpSqrtTest_q <= expEvenSig_uid24_fpSqrtTest_o(8 downto 0);

    -- expREven_uid25_fpSqrtTest(BITSELECT,24)@6
    expREven_uid25_fpSqrtTest_b <= expEvenSig_uid24_fpSqrtTest_q(8 downto 1);

    -- redist4_expOddSelect_uid30_fpSqrtTest_q_6(DELAY,101)
    redist4_expOddSelect_uid30_fpSqrtTest_q_6 : dspba_delay
    GENERIC MAP ( width => 1, depth => 6, reset_kind => "ASYNC" )
    PORT MAP ( xin => expOddSelect_uid30_fpSqrtTest_q, xout => redist4_expOddSelect_uid30_fpSqrtTest_q_6_q, clk => clk, aclr => areset );

    -- expRMux_uid31_fpSqrtTest(MUX,30)@6
    expRMux_uid31_fpSqrtTest_s <= redist4_expOddSelect_uid30_fpSqrtTest_q_6_q;
    expRMux_uid31_fpSqrtTest_combproc: PROCESS (expRMux_uid31_fpSqrtTest_s, expREven_uid25_fpSqrtTest_b, expROdd_uid28_fpSqrtTest_b)
    BEGIN
        CASE (expRMux_uid31_fpSqrtTest_s) IS
            WHEN "0" => expRMux_uid31_fpSqrtTest_q <= expREven_uid25_fpSqrtTest_b;
            WHEN "1" => expRMux_uid31_fpSqrtTest_q <= expROdd_uid28_fpSqrtTest_b;
            WHEN OTHERS => expRMux_uid31_fpSqrtTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- expR_uid40_fpSqrtTest(ADD,39)@6
    expR_uid40_fpSqrtTest_a <= STD_LOGIC_VECTOR("0" & expRMux_uid31_fpSqrtTest_q);
    expR_uid40_fpSqrtTest_b <= STD_LOGIC_VECTOR("00000000" & expInc_uid38_fpSqrtTest_b);
    expR_uid40_fpSqrtTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expR_uid40_fpSqrtTest_a) + UNSIGNED(expR_uid40_fpSqrtTest_b));
    expR_uid40_fpSqrtTest_q <= expR_uid40_fpSqrtTest_o(8 downto 0);

    -- expRR_uid51_fpSqrtTest(BITSELECT,50)@6
    expRR_uid51_fpSqrtTest_in <= expR_uid40_fpSqrtTest_q(7 downto 0);
    expRR_uid51_fpSqrtTest_b <= expRR_uid51_fpSqrtTest_in(7 downto 0);

    -- expXIsMax_uid14_fpSqrtTest(LOGICAL,13)@6
    expXIsMax_uid14_fpSqrtTest_q <= "1" WHEN redist7_expX_uid6_fpSqrtTest_b_6_mem_q = cstAllOWE_uid8_fpSqrtTest_q ELSE "0";

    -- invExpXIsMax_uid19_fpSqrtTest(LOGICAL,18)@6
    invExpXIsMax_uid19_fpSqrtTest_q <= not (expXIsMax_uid14_fpSqrtTest_q);

    -- InvExpXIsZero_uid20_fpSqrtTest(LOGICAL,19)@6
    InvExpXIsZero_uid20_fpSqrtTest_q <= not (excZ_x_uid13_fpSqrtTest_q);

    -- excR_x_uid21_fpSqrtTest(LOGICAL,20)@6
    excR_x_uid21_fpSqrtTest_q <= InvExpXIsZero_uid20_fpSqrtTest_q and invExpXIsMax_uid19_fpSqrtTest_q;

    -- minReg_uid43_fpSqrtTest(LOGICAL,42)@6
    minReg_uid43_fpSqrtTest_q <= excR_x_uid21_fpSqrtTest_q and redist6_signX_uid7_fpSqrtTest_b_6_q;

    -- cstZeroWF_uid9_fpSqrtTest(CONSTANT,8)
    cstZeroWF_uid9_fpSqrtTest_q <= "00000000000000000000000";

    -- fracXIsZero_uid15_fpSqrtTest(LOGICAL,14)@0 + 1
    fracXIsZero_uid15_fpSqrtTest_qi <= "1" WHEN cstZeroWF_uid9_fpSqrtTest_q = frac_x_uid12_fpSqrtTest_b ELSE "0";
    fracXIsZero_uid15_fpSqrtTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid15_fpSqrtTest_qi, xout => fracXIsZero_uid15_fpSqrtTest_q, clk => clk, aclr => areset );

    -- redist5_fracXIsZero_uid15_fpSqrtTest_q_6(DELAY,102)
    redist5_fracXIsZero_uid15_fpSqrtTest_q_6 : dspba_delay
    GENERIC MAP ( width => 1, depth => 5, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid15_fpSqrtTest_q, xout => redist5_fracXIsZero_uid15_fpSqrtTest_q_6_q, clk => clk, aclr => areset );

    -- excI_x_uid17_fpSqrtTest(LOGICAL,16)@6
    excI_x_uid17_fpSqrtTest_q <= expXIsMax_uid14_fpSqrtTest_q and redist5_fracXIsZero_uid15_fpSqrtTest_q_6_q;

    -- minInf_uid44_fpSqrtTest(LOGICAL,43)@6
    minInf_uid44_fpSqrtTest_q <= excI_x_uid17_fpSqrtTest_q and redist6_signX_uid7_fpSqrtTest_b_6_q;

    -- fracXIsNotZero_uid16_fpSqrtTest(LOGICAL,15)@6
    fracXIsNotZero_uid16_fpSqrtTest_q <= not (redist5_fracXIsZero_uid15_fpSqrtTest_q_6_q);

    -- excN_x_uid18_fpSqrtTest(LOGICAL,17)@6
    excN_x_uid18_fpSqrtTest_q <= expXIsMax_uid14_fpSqrtTest_q and fracXIsNotZero_uid16_fpSqrtTest_q;

    -- excRNaN_uid45_fpSqrtTest(LOGICAL,44)@6
    excRNaN_uid45_fpSqrtTest_q <= excN_x_uid18_fpSqrtTest_q or minInf_uid44_fpSqrtTest_q or minReg_uid43_fpSqrtTest_q;

    -- invSignX_uid41_fpSqrtTest(LOGICAL,40)@6
    invSignX_uid41_fpSqrtTest_q <= not (redist6_signX_uid7_fpSqrtTest_b_6_q);

    -- inInfAndNotNeg_uid42_fpSqrtTest(LOGICAL,41)@6
    inInfAndNotNeg_uid42_fpSqrtTest_q <= excI_x_uid17_fpSqrtTest_q and invSignX_uid41_fpSqrtTest_q;

    -- excConc_uid46_fpSqrtTest(BITJOIN,45)@6
    excConc_uid46_fpSqrtTest_q <= excRNaN_uid45_fpSqrtTest_q & inInfAndNotNeg_uid42_fpSqrtTest_q & excZ_x_uid13_fpSqrtTest_q;

    -- fracSelIn_uid47_fpSqrtTest(BITJOIN,46)@6
    fracSelIn_uid47_fpSqrtTest_q <= redist6_signX_uid7_fpSqrtTest_b_6_q & excConc_uid46_fpSqrtTest_q;

    -- fracSel_uid48_fpSqrtTest(LOOKUP,47)@6
    fracSel_uid48_fpSqrtTest_combproc: PROCESS (fracSelIn_uid47_fpSqrtTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (fracSelIn_uid47_fpSqrtTest_q) IS
            WHEN "0000" => fracSel_uid48_fpSqrtTest_q <= "01";
            WHEN "0001" => fracSel_uid48_fpSqrtTest_q <= "00";
            WHEN "0010" => fracSel_uid48_fpSqrtTest_q <= "10";
            WHEN "0011" => fracSel_uid48_fpSqrtTest_q <= "00";
            WHEN "0100" => fracSel_uid48_fpSqrtTest_q <= "11";
            WHEN "0101" => fracSel_uid48_fpSqrtTest_q <= "00";
            WHEN "0110" => fracSel_uid48_fpSqrtTest_q <= "10";
            WHEN "0111" => fracSel_uid48_fpSqrtTest_q <= "00";
            WHEN "1000" => fracSel_uid48_fpSqrtTest_q <= "11";
            WHEN "1001" => fracSel_uid48_fpSqrtTest_q <= "00";
            WHEN "1010" => fracSel_uid48_fpSqrtTest_q <= "11";
            WHEN "1011" => fracSel_uid48_fpSqrtTest_q <= "11";
            WHEN "1100" => fracSel_uid48_fpSqrtTest_q <= "11";
            WHEN "1101" => fracSel_uid48_fpSqrtTest_q <= "11";
            WHEN "1110" => fracSel_uid48_fpSqrtTest_q <= "11";
            WHEN "1111" => fracSel_uid48_fpSqrtTest_q <= "11";
            WHEN OTHERS => -- unreachable
                           fracSel_uid48_fpSqrtTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- expRPostExc_uid53_fpSqrtTest(MUX,52)@6
    expRPostExc_uid53_fpSqrtTest_s <= fracSel_uid48_fpSqrtTest_q;
    expRPostExc_uid53_fpSqrtTest_combproc: PROCESS (expRPostExc_uid53_fpSqrtTest_s, cstAllZWE_uid10_fpSqrtTest_q, expRR_uid51_fpSqrtTest_b, cstAllOWE_uid8_fpSqrtTest_q)
    BEGIN
        CASE (expRPostExc_uid53_fpSqrtTest_s) IS
            WHEN "00" => expRPostExc_uid53_fpSqrtTest_q <= cstAllZWE_uid10_fpSqrtTest_q;
            WHEN "01" => expRPostExc_uid53_fpSqrtTest_q <= expRR_uid51_fpSqrtTest_b;
            WHEN "10" => expRPostExc_uid53_fpSqrtTest_q <= cstAllOWE_uid8_fpSqrtTest_q;
            WHEN "11" => expRPostExc_uid53_fpSqrtTest_q <= cstAllOWE_uid8_fpSqrtTest_q;
            WHEN OTHERS => expRPostExc_uid53_fpSqrtTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- fracNaN_uid54_fpSqrtTest(CONSTANT,53)
    fracNaN_uid54_fpSqrtTest_q <= "00000000000000000000001";

    -- fracRPostProcessings_uid39_fpSqrtTest(BITSELECT,38)@6
    fracRPostProcessings_uid39_fpSqrtTest_in <= s2_uid85_invPolyEval_q(28 downto 0);
    fracRPostProcessings_uid39_fpSqrtTest_b <= fracRPostProcessings_uid39_fpSqrtTest_in(28 downto 6);

    -- fracRPostExc_uid58_fpSqrtTest(MUX,57)@6
    fracRPostExc_uid58_fpSqrtTest_s <= fracSel_uid48_fpSqrtTest_q;
    fracRPostExc_uid58_fpSqrtTest_combproc: PROCESS (fracRPostExc_uid58_fpSqrtTest_s, cstZeroWF_uid9_fpSqrtTest_q, fracRPostProcessings_uid39_fpSqrtTest_b, fracNaN_uid54_fpSqrtTest_q)
    BEGIN
        CASE (fracRPostExc_uid58_fpSqrtTest_s) IS
            WHEN "00" => fracRPostExc_uid58_fpSqrtTest_q <= cstZeroWF_uid9_fpSqrtTest_q;
            WHEN "01" => fracRPostExc_uid58_fpSqrtTest_q <= fracRPostProcessings_uid39_fpSqrtTest_b;
            WHEN "10" => fracRPostExc_uid58_fpSqrtTest_q <= cstZeroWF_uid9_fpSqrtTest_q;
            WHEN "11" => fracRPostExc_uid58_fpSqrtTest_q <= fracNaN_uid54_fpSqrtTest_q;
            WHEN OTHERS => fracRPostExc_uid58_fpSqrtTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- RSqrt_uid60_fpSqrtTest(BITJOIN,59)@6
    RSqrt_uid60_fpSqrtTest_q <= negZero_uid59_fpSqrtTest_q & expRPostExc_uid53_fpSqrtTest_q & fracRPostExc_uid58_fpSqrtTest_q;

    -- xOut(GPOUT,4)@6
    q <= RSqrt_uid60_fpSqrtTest_q;

END normal;
