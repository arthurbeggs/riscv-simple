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

-- VHDL created from div_s_0002
-- VHDL created on Fri Mar 08 18:12:35 2019


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

entity div_s_0002 is
    port (
        a : in std_logic_vector(31 downto 0);  -- float32_m23
        b : in std_logic_vector(31 downto 0);  -- float32_m23
        q : out std_logic_vector(31 downto 0);  -- float32_m23
        clk : in std_logic;
        areset : in std_logic
    );
end div_s_0002;

architecture normal of div_s_0002 is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cstBiasM1_uid6_fpDivTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal expX_uid9_fpDivTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal fracX_uid10_fpDivTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal signX_uid11_fpDivTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal expY_uid12_fpDivTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal fracY_uid13_fpDivTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal signY_uid14_fpDivTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal paddingY_uid15_fpDivTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal updatedY_uid16_fpDivTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal fracYZero_uid15_fpDivTest_a : STD_LOGIC_VECTOR (23 downto 0);
    signal fracYZero_uid15_fpDivTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracYZero_uid15_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cstAllOWE_uid18_fpDivTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal cstAllZWE_uid20_fpDivTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal excZ_x_uid23_fpDivTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excZ_x_uid23_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid24_fpDivTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid24_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid25_fpDivTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid25_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid26_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_x_uid27_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_x_uid28_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExpXIsMax_uid29_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal InvExpXIsZero_uid30_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_x_uid31_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excZ_y_uid37_fpDivTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excZ_y_uid37_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid38_fpDivTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid38_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid39_fpDivTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid39_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid40_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_y_uid41_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_y_uid42_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExpXIsMax_uid43_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal InvExpXIsZero_uid44_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_y_uid45_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signR_uid46_fpDivTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal signR_uid46_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXmY_uid47_fpDivTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal expXmY_uid47_fpDivTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal expXmY_uid47_fpDivTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal expXmY_uid47_fpDivTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal expR_uid48_fpDivTest_a : STD_LOGIC_VECTOR (10 downto 0);
    signal expR_uid48_fpDivTest_b : STD_LOGIC_VECTOR (10 downto 0);
    signal expR_uid48_fpDivTest_o : STD_LOGIC_VECTOR (10 downto 0);
    signal expR_uid48_fpDivTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal yAddr_uid51_fpDivTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal yPE_uid52_fpDivTest_b : STD_LOGIC_VECTOR (13 downto 0);
    signal fracYPostZ_uid56_fpDivTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracYPostZ_uid56_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal lOAdded_uid58_fpDivTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal oFracXSE_bottomExtension_uid61_fpDivTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal oFracXSE_mergedSignalTM_uid63_fpDivTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal divValPreNormTrunc_uid66_fpDivTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal divValPreNormTrunc_uid66_fpDivTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal norm_uid67_fpDivTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal divValPreNormHigh_uid68_fpDivTest_in : STD_LOGIC_VECTOR (24 downto 0);
    signal divValPreNormHigh_uid68_fpDivTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal divValPreNormLow_uid69_fpDivTest_in : STD_LOGIC_VECTOR (23 downto 0);
    signal divValPreNormLow_uid69_fpDivTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal normFracRnd_uid70_fpDivTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal normFracRnd_uid70_fpDivTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal expFracRnd_uid71_fpDivTest_q : STD_LOGIC_VECTOR (33 downto 0);
    signal rndOp_uid75_fpDivTest_q : STD_LOGIC_VECTOR (24 downto 0);
    signal expFracPostRnd_uid76_fpDivTest_a : STD_LOGIC_VECTOR (35 downto 0);
    signal expFracPostRnd_uid76_fpDivTest_b : STD_LOGIC_VECTOR (35 downto 0);
    signal expFracPostRnd_uid76_fpDivTest_o : STD_LOGIC_VECTOR (35 downto 0);
    signal expFracPostRnd_uid76_fpDivTest_q : STD_LOGIC_VECTOR (34 downto 0);
    signal fracRPreExc_uid78_fpDivTest_in : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPreExc_uid78_fpDivTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal excRPreExc_uid79_fpDivTest_in : STD_LOGIC_VECTOR (31 downto 0);
    signal excRPreExc_uid79_fpDivTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal expRExt_uid80_fpDivTest_b : STD_LOGIC_VECTOR (10 downto 0);
    signal expUdf_uid81_fpDivTest_a : STD_LOGIC_VECTOR (12 downto 0);
    signal expUdf_uid81_fpDivTest_b : STD_LOGIC_VECTOR (12 downto 0);
    signal expUdf_uid81_fpDivTest_o : STD_LOGIC_VECTOR (12 downto 0);
    signal expUdf_uid81_fpDivTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal expOvf_uid84_fpDivTest_a : STD_LOGIC_VECTOR (12 downto 0);
    signal expOvf_uid84_fpDivTest_b : STD_LOGIC_VECTOR (12 downto 0);
    signal expOvf_uid84_fpDivTest_o : STD_LOGIC_VECTOR (12 downto 0);
    signal expOvf_uid84_fpDivTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal zeroOverReg_uid85_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal regOverRegWithUf_uid86_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xRegOrZero_uid87_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal regOrZeroOverInf_uid88_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRZero_uid89_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXRYZ_uid90_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXRYROvf_uid91_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXIYZ_uid92_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXIYR_uid93_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRInf_uid94_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXZYZ_uid95_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXIYI_uid96_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRNaN_uid97_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal concExc_uid98_fpDivTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal excREnc_uid99_fpDivTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal oneFracRPostExc2_uid100_fpDivTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal fracRPostExc_uid103_fpDivTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal fracRPostExc_uid103_fpDivTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal expRPostExc_uid107_fpDivTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal expRPostExc_uid107_fpDivTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal invExcRNaN_uid108_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sRPostExc_uid109_fpDivTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal divR_uid110_fpDivTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal os_uid114_invTables_q : STD_LOGIC_VECTOR (30 downto 0);
    signal os_uid118_invTables_q : STD_LOGIC_VECTOR (20 downto 0);
    signal yT1_uid126_invPolyEval_b : STD_LOGIC_VECTOR (11 downto 0);
    signal lowRangeB_uid128_invPolyEval_in : STD_LOGIC_VECTOR (0 downto 0);
    signal lowRangeB_uid128_invPolyEval_b : STD_LOGIC_VECTOR (0 downto 0);
    signal highBBits_uid129_invPolyEval_b : STD_LOGIC_VECTOR (11 downto 0);
    signal s1sumAHighB_uid130_invPolyEval_a : STD_LOGIC_VECTOR (21 downto 0);
    signal s1sumAHighB_uid130_invPolyEval_b : STD_LOGIC_VECTOR (21 downto 0);
    signal s1sumAHighB_uid130_invPolyEval_o : STD_LOGIC_VECTOR (21 downto 0);
    signal s1sumAHighB_uid130_invPolyEval_q : STD_LOGIC_VECTOR (21 downto 0);
    signal s1_uid131_invPolyEval_q : STD_LOGIC_VECTOR (22 downto 0);
    signal lowRangeB_uid134_invPolyEval_in : STD_LOGIC_VECTOR (1 downto 0);
    signal lowRangeB_uid134_invPolyEval_b : STD_LOGIC_VECTOR (1 downto 0);
    signal highBBits_uid135_invPolyEval_b : STD_LOGIC_VECTOR (21 downto 0);
    signal s2sumAHighB_uid136_invPolyEval_a : STD_LOGIC_VECTOR (31 downto 0);
    signal s2sumAHighB_uid136_invPolyEval_b : STD_LOGIC_VECTOR (31 downto 0);
    signal s2sumAHighB_uid136_invPolyEval_o : STD_LOGIC_VECTOR (31 downto 0);
    signal s2sumAHighB_uid136_invPolyEval_q : STD_LOGIC_VECTOR (31 downto 0);
    signal s2_uid137_invPolyEval_q : STD_LOGIC_VECTOR (33 downto 0);
    signal osig_uid140_prodDivPreNormProd_uid60_fpDivTest_b : STD_LOGIC_VECTOR (25 downto 0);
    signal osig_uid143_pT1_uid127_invPolyEval_b : STD_LOGIC_VECTOR (12 downto 0);
    signal osig_uid146_pT2_uid133_invPolyEval_b : STD_LOGIC_VECTOR (23 downto 0);
    signal memoryC1_uid117_invTables_q_const_q : STD_LOGIC_VECTOR (0 downto 0);
    signal memoryC0_uid112_invTables_lutmem_reset0 : std_logic;
    signal memoryC0_uid112_invTables_lutmem_ia : STD_LOGIC_VECTOR (19 downto 0);
    signal memoryC0_uid112_invTables_lutmem_aa : STD_LOGIC_VECTOR (8 downto 0);
    signal memoryC0_uid112_invTables_lutmem_ab : STD_LOGIC_VECTOR (8 downto 0);
    signal memoryC0_uid112_invTables_lutmem_ir : STD_LOGIC_VECTOR (19 downto 0);
    signal memoryC0_uid112_invTables_lutmem_r : STD_LOGIC_VECTOR (19 downto 0);
    signal memoryC0_uid113_invTables_lutmem_reset0 : std_logic;
    signal memoryC0_uid113_invTables_lutmem_ia : STD_LOGIC_VECTOR (10 downto 0);
    signal memoryC0_uid113_invTables_lutmem_aa : STD_LOGIC_VECTOR (8 downto 0);
    signal memoryC0_uid113_invTables_lutmem_ab : STD_LOGIC_VECTOR (8 downto 0);
    signal memoryC0_uid113_invTables_lutmem_ir : STD_LOGIC_VECTOR (10 downto 0);
    signal memoryC0_uid113_invTables_lutmem_r : STD_LOGIC_VECTOR (10 downto 0);
    signal memoryC1_uid116_invTables_lutmem_reset0 : std_logic;
    signal memoryC1_uid116_invTables_lutmem_ia : STD_LOGIC_VECTOR (19 downto 0);
    signal memoryC1_uid116_invTables_lutmem_aa : STD_LOGIC_VECTOR (8 downto 0);
    signal memoryC1_uid116_invTables_lutmem_ab : STD_LOGIC_VECTOR (8 downto 0);
    signal memoryC1_uid116_invTables_lutmem_ir : STD_LOGIC_VECTOR (19 downto 0);
    signal memoryC1_uid116_invTables_lutmem_r : STD_LOGIC_VECTOR (19 downto 0);
    signal memoryC2_uid120_invTables_lutmem_reset0 : std_logic;
    signal memoryC2_uid120_invTables_lutmem_ia : STD_LOGIC_VECTOR (11 downto 0);
    signal memoryC2_uid120_invTables_lutmem_aa : STD_LOGIC_VECTOR (8 downto 0);
    signal memoryC2_uid120_invTables_lutmem_ab : STD_LOGIC_VECTOR (8 downto 0);
    signal memoryC2_uid120_invTables_lutmem_ir : STD_LOGIC_VECTOR (11 downto 0);
    signal memoryC2_uid120_invTables_lutmem_r : STD_LOGIC_VECTOR (11 downto 0);
    signal prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_reset : std_logic;
    type prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_a0type is array(NATURAL range <>) of UNSIGNED(25 downto 0);
    signal prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_a0 : prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_a0type(0 to 0);
    attribute preserve : boolean;
    attribute preserve of prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_a0 : signal is true;
    type prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_c0type is array(NATURAL range <>) of UNSIGNED(23 downto 0);
    signal prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_c0 : prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_c0type(0 to 0);
    attribute preserve of prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_c0 : signal is true;
    type prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_ptype is array(NATURAL range <>) of UNSIGNED(49 downto 0);
    signal prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_p : prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_ptype(0 to 0);
    signal prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_u : prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_ptype(0 to 0);
    signal prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_w : prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_ptype(0 to 0);
    signal prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_x : prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_ptype(0 to 0);
    signal prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_y : prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_ptype(0 to 0);
    signal prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_s : prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_ptype(0 to 0);
    signal prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_qq : STD_LOGIC_VECTOR (49 downto 0);
    signal prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_q : STD_LOGIC_VECTOR (49 downto 0);
    signal prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_ena0 : std_logic;
    signal prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_ena1 : std_logic;
    signal prodXY_uid142_pT1_uid127_invPolyEval_cma_reset : std_logic;
    type prodXY_uid142_pT1_uid127_invPolyEval_cma_a0type is array(NATURAL range <>) of UNSIGNED(11 downto 0);
    signal prodXY_uid142_pT1_uid127_invPolyEval_cma_a0 : prodXY_uid142_pT1_uid127_invPolyEval_cma_a0type(0 to 0);
    attribute preserve of prodXY_uid142_pT1_uid127_invPolyEval_cma_a0 : signal is true;
    type prodXY_uid142_pT1_uid127_invPolyEval_cma_c0type is array(NATURAL range <>) of SIGNED(11 downto 0);
    signal prodXY_uid142_pT1_uid127_invPolyEval_cma_c0 : prodXY_uid142_pT1_uid127_invPolyEval_cma_c0type(0 to 0);
    attribute preserve of prodXY_uid142_pT1_uid127_invPolyEval_cma_c0 : signal is true;
    type prodXY_uid142_pT1_uid127_invPolyEval_cma_ltype is array(NATURAL range <>) of SIGNED(12 downto 0);
    signal prodXY_uid142_pT1_uid127_invPolyEval_cma_l : prodXY_uid142_pT1_uid127_invPolyEval_cma_ltype(0 to 0);
    type prodXY_uid142_pT1_uid127_invPolyEval_cma_ptype is array(NATURAL range <>) of SIGNED(24 downto 0);
    signal prodXY_uid142_pT1_uid127_invPolyEval_cma_p : prodXY_uid142_pT1_uid127_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid142_pT1_uid127_invPolyEval_cma_u : prodXY_uid142_pT1_uid127_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid142_pT1_uid127_invPolyEval_cma_w : prodXY_uid142_pT1_uid127_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid142_pT1_uid127_invPolyEval_cma_x : prodXY_uid142_pT1_uid127_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid142_pT1_uid127_invPolyEval_cma_y : prodXY_uid142_pT1_uid127_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid142_pT1_uid127_invPolyEval_cma_s : prodXY_uid142_pT1_uid127_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid142_pT1_uid127_invPolyEval_cma_qq : STD_LOGIC_VECTOR (23 downto 0);
    signal prodXY_uid142_pT1_uid127_invPolyEval_cma_q : STD_LOGIC_VECTOR (23 downto 0);
    signal prodXY_uid142_pT1_uid127_invPolyEval_cma_ena0 : std_logic;
    signal prodXY_uid142_pT1_uid127_invPolyEval_cma_ena1 : std_logic;
	 signal prodXY_uid145_pT2_uid133_invPolyEval_cma_reset : std_logic;
    type prodXY_uid145_pT2_uid133_invPolyEval_cma_a0type is array(NATURAL range <>) of UNSIGNED(13 downto 0);
    signal prodXY_uid145_pT2_uid133_invPolyEval_cma_a0 : prodXY_uid145_pT2_uid133_invPolyEval_cma_a0type(0 to 0);
    attribute preserve of prodXY_uid145_pT2_uid133_invPolyEval_cma_a0 : signal is true;
    type prodXY_uid145_pT2_uid133_invPolyEval_cma_c0type is array(NATURAL range <>) of SIGNED(22 downto 0);
    signal prodXY_uid145_pT2_uid133_invPolyEval_cma_c0 : prodXY_uid145_pT2_uid133_invPolyEval_cma_c0type(0 to 0);
    attribute preserve of prodXY_uid145_pT2_uid133_invPolyEval_cma_c0 : signal is true;
    type prodXY_uid145_pT2_uid133_invPolyEval_cma_ltype is array(NATURAL range <>) of SIGNED(14 downto 0);
    signal prodXY_uid145_pT2_uid133_invPolyEval_cma_l : prodXY_uid145_pT2_uid133_invPolyEval_cma_ltype(0 to 0);
    type prodXY_uid145_pT2_uid133_invPolyEval_cma_ptype is array(NATURAL range <>) of SIGNED(37 downto 0);
    signal prodXY_uid145_pT2_uid133_invPolyEval_cma_p : prodXY_uid145_pT2_uid133_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid145_pT2_uid133_invPolyEval_cma_u : prodXY_uid145_pT2_uid133_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid145_pT2_uid133_invPolyEval_cma_w : prodXY_uid145_pT2_uid133_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid145_pT2_uid133_invPolyEval_cma_x : prodXY_uid145_pT2_uid133_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid145_pT2_uid133_invPolyEval_cma_y : prodXY_uid145_pT2_uid133_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid145_pT2_uid133_invPolyEval_cma_s : prodXY_uid145_pT2_uid133_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid145_pT2_uid133_invPolyEval_cma_qq : STD_LOGIC_VECTOR (36 downto 0);
    signal prodXY_uid145_pT2_uid133_invPolyEval_cma_q : STD_LOGIC_VECTOR (36 downto 0);
    signal prodXY_uid145_pT2_uid133_invPolyEval_cma_ena0 : std_logic;
    signal prodXY_uid145_pT2_uid133_invPolyEval_cma_ena1 : std_logic;
    signal invY_uid54_fpDivTest_merged_bit_select_in : STD_LOGIC_VECTOR (31 downto 0);
    signal invY_uid54_fpDivTest_merged_bit_select_b : STD_LOGIC_VECTOR (25 downto 0);
    signal invY_uid54_fpDivTest_merged_bit_select_c : STD_LOGIC_VECTOR (0 downto 0);
    signal redist0_excRPreExc_uid79_fpDivTest_b_1_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist1_fracRPreExc_uid78_fpDivTest_b_1_q : STD_LOGIC_VECTOR (22 downto 0);
    signal redist2_lOAdded_uid58_fpDivTest_q_2_q : STD_LOGIC_VECTOR (23 downto 0);
    signal redist3_fracYPostZ_uid56_fpDivTest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist4_yPE_uid52_fpDivTest_b_2_q : STD_LOGIC_VECTOR (13 downto 0);
    signal redist5_yPE_uid52_fpDivTest_b_4_q : STD_LOGIC_VECTOR (13 downto 0);
    signal redist6_yAddr_uid51_fpDivTest_b_2_q : STD_LOGIC_VECTOR (8 downto 0);
    signal redist7_yAddr_uid51_fpDivTest_b_4_q : STD_LOGIC_VECTOR (8 downto 0);
    signal redist9_signR_uid46_fpDivTest_q_9_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist10_fracXIsZero_uid39_fpDivTest_q_9_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist11_expXIsMax_uid38_fpDivTest_q_9_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist12_excZ_y_uid37_fpDivTest_q_9_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist13_fracXIsZero_uid25_fpDivTest_q_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist14_expXIsMax_uid24_fpDivTest_q_9_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist15_excZ_x_uid23_fpDivTest_q_9_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist16_fracYZero_uid15_fpDivTest_q_6_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist8_expXmY_uid47_fpDivTest_q_8_outputreg_q : STD_LOGIC_VECTOR (8 downto 0);
    signal redist8_expXmY_uid47_fpDivTest_q_8_mem_reset0 : std_logic;
    signal redist8_expXmY_uid47_fpDivTest_q_8_mem_ia : STD_LOGIC_VECTOR (8 downto 0);
    signal redist8_expXmY_uid47_fpDivTest_q_8_mem_aa : STD_LOGIC_VECTOR (2 downto 0);
    signal redist8_expXmY_uid47_fpDivTest_q_8_mem_ab : STD_LOGIC_VECTOR (2 downto 0);
    signal redist8_expXmY_uid47_fpDivTest_q_8_mem_iq : STD_LOGIC_VECTOR (8 downto 0);
    signal redist8_expXmY_uid47_fpDivTest_q_8_mem_q : STD_LOGIC_VECTOR (8 downto 0);
    signal redist8_expXmY_uid47_fpDivTest_q_8_rdcnt_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist8_expXmY_uid47_fpDivTest_q_8_rdcnt_i : UNSIGNED (2 downto 0);
    attribute preserve of redist8_expXmY_uid47_fpDivTest_q_8_rdcnt_i : signal is true;
    signal redist8_expXmY_uid47_fpDivTest_q_8_rdcnt_eq : std_logic;
    attribute preserve of redist8_expXmY_uid47_fpDivTest_q_8_rdcnt_eq : signal is true;
    signal redist8_expXmY_uid47_fpDivTest_q_8_wraddr_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist8_expXmY_uid47_fpDivTest_q_8_mem_last_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist8_expXmY_uid47_fpDivTest_q_8_cmp_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist8_expXmY_uid47_fpDivTest_q_8_cmpReg_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist8_expXmY_uid47_fpDivTest_q_8_notEnable_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist8_expXmY_uid47_fpDivTest_q_8_nor_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist8_expXmY_uid47_fpDivTest_q_8_sticky_ena_q : STD_LOGIC_VECTOR (0 downto 0);
    attribute dont_merge : boolean;
    attribute dont_merge of redist8_expXmY_uid47_fpDivTest_q_8_sticky_ena_q : signal is true;
    signal redist8_expXmY_uid47_fpDivTest_q_8_enaAnd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist17_fracX_uid10_fpDivTest_b_6_mem_reset0 : std_logic;
    signal redist17_fracX_uid10_fpDivTest_b_6_mem_ia : STD_LOGIC_VECTOR (22 downto 0);
    signal redist17_fracX_uid10_fpDivTest_b_6_mem_aa : STD_LOGIC_VECTOR (2 downto 0);
    signal redist17_fracX_uid10_fpDivTest_b_6_mem_ab : STD_LOGIC_VECTOR (2 downto 0);
    signal redist17_fracX_uid10_fpDivTest_b_6_mem_iq : STD_LOGIC_VECTOR (22 downto 0);
    signal redist17_fracX_uid10_fpDivTest_b_6_mem_q : STD_LOGIC_VECTOR (22 downto 0);
    signal redist17_fracX_uid10_fpDivTest_b_6_rdcnt_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist17_fracX_uid10_fpDivTest_b_6_rdcnt_i : UNSIGNED (2 downto 0);
    attribute preserve of redist17_fracX_uid10_fpDivTest_b_6_rdcnt_i : signal is true;
    signal redist17_fracX_uid10_fpDivTest_b_6_rdcnt_eq : std_logic;
    attribute preserve of redist17_fracX_uid10_fpDivTest_b_6_rdcnt_eq : signal is true;
    signal redist17_fracX_uid10_fpDivTest_b_6_wraddr_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist17_fracX_uid10_fpDivTest_b_6_mem_last_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist17_fracX_uid10_fpDivTest_b_6_cmp_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist17_fracX_uid10_fpDivTest_b_6_cmpReg_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist17_fracX_uid10_fpDivTest_b_6_notEnable_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist17_fracX_uid10_fpDivTest_b_6_nor_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist17_fracX_uid10_fpDivTest_b_6_sticky_ena_q : STD_LOGIC_VECTOR (0 downto 0);
    attribute dont_merge of redist17_fracX_uid10_fpDivTest_b_6_sticky_ena_q : signal is true;
    signal redist17_fracX_uid10_fpDivTest_b_6_enaAnd_q : STD_LOGIC_VECTOR (0 downto 0);

begin


    -- fracY_uid13_fpDivTest(BITSELECT,12)@0
    fracY_uid13_fpDivTest_b <= b(22 downto 0);

    -- paddingY_uid15_fpDivTest(CONSTANT,14)
    paddingY_uid15_fpDivTest_q <= "00000000000000000000000";

    -- fracXIsZero_uid39_fpDivTest(LOGICAL,38)@0 + 1
    fracXIsZero_uid39_fpDivTest_qi <= "1" WHEN paddingY_uid15_fpDivTest_q = fracY_uid13_fpDivTest_b ELSE "0";
    fracXIsZero_uid39_fpDivTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid39_fpDivTest_qi, xout => fracXIsZero_uid39_fpDivTest_q, clk => clk, aclr => areset );

    -- redist10_fracXIsZero_uid39_fpDivTest_q_9(DELAY,166)
    redist10_fracXIsZero_uid39_fpDivTest_q_9 : dspba_delay
    GENERIC MAP ( width => 1, depth => 8, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid39_fpDivTest_q, xout => redist10_fracXIsZero_uid39_fpDivTest_q_9_q, clk => clk, aclr => areset );

    -- cstAllOWE_uid18_fpDivTest(CONSTANT,17)
    cstAllOWE_uid18_fpDivTest_q <= "11111111";

    -- expY_uid12_fpDivTest(BITSELECT,11)@0
    expY_uid12_fpDivTest_b <= b(30 downto 23);

    -- expXIsMax_uid38_fpDivTest(LOGICAL,37)@0 + 1
    expXIsMax_uid38_fpDivTest_qi <= "1" WHEN expY_uid12_fpDivTest_b = cstAllOWE_uid18_fpDivTest_q ELSE "0";
    expXIsMax_uid38_fpDivTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => expXIsMax_uid38_fpDivTest_qi, xout => expXIsMax_uid38_fpDivTest_q, clk => clk, aclr => areset );

    -- redist11_expXIsMax_uid38_fpDivTest_q_9(DELAY,167)
    redist11_expXIsMax_uid38_fpDivTest_q_9 : dspba_delay
    GENERIC MAP ( width => 1, depth => 8, reset_kind => "ASYNC" )
    PORT MAP ( xin => expXIsMax_uid38_fpDivTest_q, xout => redist11_expXIsMax_uid38_fpDivTest_q_9_q, clk => clk, aclr => areset );

    -- excI_y_uid41_fpDivTest(LOGICAL,40)@9
    excI_y_uid41_fpDivTest_q <= redist11_expXIsMax_uid38_fpDivTest_q_9_q and redist10_fracXIsZero_uid39_fpDivTest_q_9_q;

    -- redist17_fracX_uid10_fpDivTest_b_6_notEnable(LOGICAL,191)
    redist17_fracX_uid10_fpDivTest_b_6_notEnable_q <= STD_LOGIC_VECTOR(not (VCC_q));

    -- redist17_fracX_uid10_fpDivTest_b_6_nor(LOGICAL,192)
    redist17_fracX_uid10_fpDivTest_b_6_nor_q <= not (redist17_fracX_uid10_fpDivTest_b_6_notEnable_q or redist17_fracX_uid10_fpDivTest_b_6_sticky_ena_q);

    -- redist17_fracX_uid10_fpDivTest_b_6_mem_last(CONSTANT,188)
    redist17_fracX_uid10_fpDivTest_b_6_mem_last_q <= "011";

    -- redist17_fracX_uid10_fpDivTest_b_6_cmp(LOGICAL,189)
    redist17_fracX_uid10_fpDivTest_b_6_cmp_q <= "1" WHEN redist17_fracX_uid10_fpDivTest_b_6_mem_last_q = redist17_fracX_uid10_fpDivTest_b_6_rdcnt_q ELSE "0";

    -- redist17_fracX_uid10_fpDivTest_b_6_cmpReg(REG,190)
    redist17_fracX_uid10_fpDivTest_b_6_cmpReg_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            redist17_fracX_uid10_fpDivTest_b_6_cmpReg_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            redist17_fracX_uid10_fpDivTest_b_6_cmpReg_q <= STD_LOGIC_VECTOR(redist17_fracX_uid10_fpDivTest_b_6_cmp_q);
        END IF;
    END PROCESS;

    -- redist17_fracX_uid10_fpDivTest_b_6_sticky_ena(REG,193)
    redist17_fracX_uid10_fpDivTest_b_6_sticky_ena_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            redist17_fracX_uid10_fpDivTest_b_6_sticky_ena_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (redist17_fracX_uid10_fpDivTest_b_6_nor_q = "1") THEN
                redist17_fracX_uid10_fpDivTest_b_6_sticky_ena_q <= STD_LOGIC_VECTOR(redist17_fracX_uid10_fpDivTest_b_6_cmpReg_q);
            END IF;
        END IF;
    END PROCESS;

    -- redist17_fracX_uid10_fpDivTest_b_6_enaAnd(LOGICAL,194)
    redist17_fracX_uid10_fpDivTest_b_6_enaAnd_q <= redist17_fracX_uid10_fpDivTest_b_6_sticky_ena_q and VCC_q;

    -- redist17_fracX_uid10_fpDivTest_b_6_rdcnt(COUNTER,186)
    -- low=0, high=4, step=1, init=0
    redist17_fracX_uid10_fpDivTest_b_6_rdcnt_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            redist17_fracX_uid10_fpDivTest_b_6_rdcnt_i <= TO_UNSIGNED(0, 3);
            redist17_fracX_uid10_fpDivTest_b_6_rdcnt_eq <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (redist17_fracX_uid10_fpDivTest_b_6_rdcnt_i = TO_UNSIGNED(3, 3)) THEN
                redist17_fracX_uid10_fpDivTest_b_6_rdcnt_eq <= '1';
            ELSE
                redist17_fracX_uid10_fpDivTest_b_6_rdcnt_eq <= '0';
            END IF;
            IF (redist17_fracX_uid10_fpDivTest_b_6_rdcnt_eq = '1') THEN
                redist17_fracX_uid10_fpDivTest_b_6_rdcnt_i <= redist17_fracX_uid10_fpDivTest_b_6_rdcnt_i + 4;
            ELSE
                redist17_fracX_uid10_fpDivTest_b_6_rdcnt_i <= redist17_fracX_uid10_fpDivTest_b_6_rdcnt_i + 1;
            END IF;
        END IF;
    END PROCESS;
    redist17_fracX_uid10_fpDivTest_b_6_rdcnt_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(redist17_fracX_uid10_fpDivTest_b_6_rdcnt_i, 3)));

    -- fracX_uid10_fpDivTest(BITSELECT,9)@0
    fracX_uid10_fpDivTest_b <= a(22 downto 0);

    -- redist17_fracX_uid10_fpDivTest_b_6_wraddr(REG,187)
    redist17_fracX_uid10_fpDivTest_b_6_wraddr_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            redist17_fracX_uid10_fpDivTest_b_6_wraddr_q <= "100";
        ELSIF (clk'EVENT AND clk = '1') THEN
            redist17_fracX_uid10_fpDivTest_b_6_wraddr_q <= STD_LOGIC_VECTOR(redist17_fracX_uid10_fpDivTest_b_6_rdcnt_q);
        END IF;
    END PROCESS;

    -- redist17_fracX_uid10_fpDivTest_b_6_mem(DUALMEM,185)
    redist17_fracX_uid10_fpDivTest_b_6_mem_ia <= STD_LOGIC_VECTOR(fracX_uid10_fpDivTest_b);
    redist17_fracX_uid10_fpDivTest_b_6_mem_aa <= redist17_fracX_uid10_fpDivTest_b_6_wraddr_q;
    redist17_fracX_uid10_fpDivTest_b_6_mem_ab <= redist17_fracX_uid10_fpDivTest_b_6_rdcnt_q;
    redist17_fracX_uid10_fpDivTest_b_6_mem_reset0 <= areset;
    redist17_fracX_uid10_fpDivTest_b_6_mem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "MLAB",
        operation_mode => "DUAL_PORT",
        width_a => 23,
        widthad_a => 3,
        numwords_a => 5,
        width_b => 23,
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
        clocken1 => redist17_fracX_uid10_fpDivTest_b_6_enaAnd_q(0),
        clocken0 => VCC_q(0),
        clock0 => clk,
        aclr1 => redist17_fracX_uid10_fpDivTest_b_6_mem_reset0,
        clock1 => clk,
        address_a => redist17_fracX_uid10_fpDivTest_b_6_mem_aa,
        data_a => redist17_fracX_uid10_fpDivTest_b_6_mem_ia,
        wren_a => VCC_q(0),
        address_b => redist17_fracX_uid10_fpDivTest_b_6_mem_ab,
        q_b => redist17_fracX_uid10_fpDivTest_b_6_mem_iq
    );
    redist17_fracX_uid10_fpDivTest_b_6_mem_q <= redist17_fracX_uid10_fpDivTest_b_6_mem_iq(22 downto 0);

    -- fracXIsZero_uid25_fpDivTest(LOGICAL,24)@6 + 1
    fracXIsZero_uid25_fpDivTest_qi <= "1" WHEN paddingY_uid15_fpDivTest_q = redist17_fracX_uid10_fpDivTest_b_6_mem_q ELSE "0";
    fracXIsZero_uid25_fpDivTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid25_fpDivTest_qi, xout => fracXIsZero_uid25_fpDivTest_q, clk => clk, aclr => areset );

    -- redist13_fracXIsZero_uid25_fpDivTest_q_3(DELAY,169)
    redist13_fracXIsZero_uid25_fpDivTest_q_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid25_fpDivTest_q, xout => redist13_fracXIsZero_uid25_fpDivTest_q_3_q, clk => clk, aclr => areset );

    -- expX_uid9_fpDivTest(BITSELECT,8)@0
    expX_uid9_fpDivTest_b <= a(30 downto 23);

    -- expXIsMax_uid24_fpDivTest(LOGICAL,23)@0 + 1
    expXIsMax_uid24_fpDivTest_qi <= "1" WHEN expX_uid9_fpDivTest_b = cstAllOWE_uid18_fpDivTest_q ELSE "0";
    expXIsMax_uid24_fpDivTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => expXIsMax_uid24_fpDivTest_qi, xout => expXIsMax_uid24_fpDivTest_q, clk => clk, aclr => areset );

    -- redist14_expXIsMax_uid24_fpDivTest_q_9(DELAY,170)
    redist14_expXIsMax_uid24_fpDivTest_q_9 : dspba_delay
    GENERIC MAP ( width => 1, depth => 8, reset_kind => "ASYNC" )
    PORT MAP ( xin => expXIsMax_uid24_fpDivTest_q, xout => redist14_expXIsMax_uid24_fpDivTest_q_9_q, clk => clk, aclr => areset );

    -- excI_x_uid27_fpDivTest(LOGICAL,26)@9
    excI_x_uid27_fpDivTest_q <= redist14_expXIsMax_uid24_fpDivTest_q_9_q and redist13_fracXIsZero_uid25_fpDivTest_q_3_q;

    -- excXIYI_uid96_fpDivTest(LOGICAL,95)@9
    excXIYI_uid96_fpDivTest_q <= excI_x_uid27_fpDivTest_q and excI_y_uid41_fpDivTest_q;

    -- fracXIsNotZero_uid40_fpDivTest(LOGICAL,39)@9
    fracXIsNotZero_uid40_fpDivTest_q <= not (redist10_fracXIsZero_uid39_fpDivTest_q_9_q);

    -- excN_y_uid42_fpDivTest(LOGICAL,41)@9
    excN_y_uid42_fpDivTest_q <= redist11_expXIsMax_uid38_fpDivTest_q_9_q and fracXIsNotZero_uid40_fpDivTest_q;

    -- fracXIsNotZero_uid26_fpDivTest(LOGICAL,25)@9
    fracXIsNotZero_uid26_fpDivTest_q <= not (redist13_fracXIsZero_uid25_fpDivTest_q_3_q);

    -- excN_x_uid28_fpDivTest(LOGICAL,27)@9
    excN_x_uid28_fpDivTest_q <= redist14_expXIsMax_uid24_fpDivTest_q_9_q and fracXIsNotZero_uid26_fpDivTest_q;

    -- cstAllZWE_uid20_fpDivTest(CONSTANT,19)
    cstAllZWE_uid20_fpDivTest_q <= "00000000";

    -- excZ_y_uid37_fpDivTest(LOGICAL,36)@0 + 1
    excZ_y_uid37_fpDivTest_qi <= "1" WHEN expY_uid12_fpDivTest_b = cstAllZWE_uid20_fpDivTest_q ELSE "0";
    excZ_y_uid37_fpDivTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excZ_y_uid37_fpDivTest_qi, xout => excZ_y_uid37_fpDivTest_q, clk => clk, aclr => areset );

    -- redist12_excZ_y_uid37_fpDivTest_q_9(DELAY,168)
    redist12_excZ_y_uid37_fpDivTest_q_9 : dspba_delay
    GENERIC MAP ( width => 1, depth => 8, reset_kind => "ASYNC" )
    PORT MAP ( xin => excZ_y_uid37_fpDivTest_q, xout => redist12_excZ_y_uid37_fpDivTest_q_9_q, clk => clk, aclr => areset );

    -- excZ_x_uid23_fpDivTest(LOGICAL,22)@0 + 1
    excZ_x_uid23_fpDivTest_qi <= "1" WHEN expX_uid9_fpDivTest_b = cstAllZWE_uid20_fpDivTest_q ELSE "0";
    excZ_x_uid23_fpDivTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excZ_x_uid23_fpDivTest_qi, xout => excZ_x_uid23_fpDivTest_q, clk => clk, aclr => areset );

    -- redist15_excZ_x_uid23_fpDivTest_q_9(DELAY,171)
    redist15_excZ_x_uid23_fpDivTest_q_9 : dspba_delay
    GENERIC MAP ( width => 1, depth => 8, reset_kind => "ASYNC" )
    PORT MAP ( xin => excZ_x_uid23_fpDivTest_q, xout => redist15_excZ_x_uid23_fpDivTest_q_9_q, clk => clk, aclr => areset );

    -- excXZYZ_uid95_fpDivTest(LOGICAL,94)@9
    excXZYZ_uid95_fpDivTest_q <= redist15_excZ_x_uid23_fpDivTest_q_9_q and redist12_excZ_y_uid37_fpDivTest_q_9_q;

    -- excRNaN_uid97_fpDivTest(LOGICAL,96)@9
    excRNaN_uid97_fpDivTest_q <= excXZYZ_uid95_fpDivTest_q or excN_x_uid28_fpDivTest_q or excN_y_uid42_fpDivTest_q or excXIYI_uid96_fpDivTest_q;

    -- invExcRNaN_uid108_fpDivTest(LOGICAL,107)@9
    invExcRNaN_uid108_fpDivTest_q <= not (excRNaN_uid97_fpDivTest_q);

    -- signY_uid14_fpDivTest(BITSELECT,13)@0
    signY_uid14_fpDivTest_b <= STD_LOGIC_VECTOR(b(31 downto 31));

    -- signX_uid11_fpDivTest(BITSELECT,10)@0
    signX_uid11_fpDivTest_b <= STD_LOGIC_VECTOR(a(31 downto 31));

    -- signR_uid46_fpDivTest(LOGICAL,45)@0 + 1
    signR_uid46_fpDivTest_qi <= signX_uid11_fpDivTest_b xor signY_uid14_fpDivTest_b;
    signR_uid46_fpDivTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => signR_uid46_fpDivTest_qi, xout => signR_uid46_fpDivTest_q, clk => clk, aclr => areset );

    -- redist9_signR_uid46_fpDivTest_q_9(DELAY,165)
    redist9_signR_uid46_fpDivTest_q_9 : dspba_delay
    GENERIC MAP ( width => 1, depth => 8, reset_kind => "ASYNC" )
    PORT MAP ( xin => signR_uid46_fpDivTest_q, xout => redist9_signR_uid46_fpDivTest_q_9_q, clk => clk, aclr => areset );

    -- VCC(CONSTANT,1)
    VCC_q <= "1";

    -- sRPostExc_uid109_fpDivTest(LOGICAL,108)@9
    sRPostExc_uid109_fpDivTest_q <= redist9_signR_uid46_fpDivTest_q_9_q and invExcRNaN_uid108_fpDivTest_q;

    -- lOAdded_uid58_fpDivTest(BITJOIN,57)@6
    lOAdded_uid58_fpDivTest_q <= VCC_q & redist17_fracX_uid10_fpDivTest_b_6_mem_q;

    -- redist2_lOAdded_uid58_fpDivTest_q_2(DELAY,158)
    redist2_lOAdded_uid58_fpDivTest_q_2 : dspba_delay
    GENERIC MAP ( width => 24, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => lOAdded_uid58_fpDivTest_q, xout => redist2_lOAdded_uid58_fpDivTest_q_2_q, clk => clk, aclr => areset );

    -- oFracXSE_bottomExtension_uid61_fpDivTest(CONSTANT,60)
    oFracXSE_bottomExtension_uid61_fpDivTest_q <= "00";

    -- oFracXSE_mergedSignalTM_uid63_fpDivTest(BITJOIN,62)@8
    oFracXSE_mergedSignalTM_uid63_fpDivTest_q <= redist2_lOAdded_uid58_fpDivTest_q_2_q & oFracXSE_bottomExtension_uid61_fpDivTest_q;

    -- yAddr_uid51_fpDivTest(BITSELECT,50)@0
    yAddr_uid51_fpDivTest_b <= fracY_uid13_fpDivTest_b(22 downto 14);

    -- memoryC2_uid120_invTables_lutmem(DUALMEM,151)@0 + 2
    -- in j@20000000
    memoryC2_uid120_invTables_lutmem_aa <= yAddr_uid51_fpDivTest_b;
    memoryC2_uid120_invTables_lutmem_reset0 <= areset;
    memoryC2_uid120_invTables_lutmem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M10K",
        operation_mode => "ROM",
        width_a => 12,
        widthad_a => 9,
        numwords_a => 512,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        outdata_reg_a => "CLOCK0",
        outdata_aclr_a => "CLEAR0",
        clock_enable_input_a => "NORMAL",
        power_up_uninitialized => "FALSE",
        init_file => "div_s_0002_memoryC2_uid120_invTables_lutmem.hex",
        init_file_layout => "PORT_A",
        intended_device_family => "Cyclone V"
    )
    PORT MAP (
        clocken0 => VCC_q(0),
        aclr0 => memoryC2_uid120_invTables_lutmem_reset0,
        clock0 => clk,
        address_a => memoryC2_uid120_invTables_lutmem_aa,
        q_a => memoryC2_uid120_invTables_lutmem_ir
    );
    memoryC2_uid120_invTables_lutmem_r <= memoryC2_uid120_invTables_lutmem_ir(11 downto 0);

    -- yPE_uid52_fpDivTest(BITSELECT,51)@0
    yPE_uid52_fpDivTest_b <= b(13 downto 0);

    -- redist4_yPE_uid52_fpDivTest_b_2(DELAY,160)
    redist4_yPE_uid52_fpDivTest_b_2 : dspba_delay
    GENERIC MAP ( width => 14, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => yPE_uid52_fpDivTest_b, xout => redist4_yPE_uid52_fpDivTest_b_2_q, clk => clk, aclr => areset );

    -- yT1_uid126_invPolyEval(BITSELECT,125)@2
    yT1_uid126_invPolyEval_b <= redist4_yPE_uid52_fpDivTest_b_2_q(13 downto 2);

    -- prodXY_uid142_pT1_uid127_invPolyEval_cma(CHAINMULTADD,153)@2 + 2
    prodXY_uid142_pT1_uid127_invPolyEval_cma_reset <= areset;
    prodXY_uid142_pT1_uid127_invPolyEval_cma_ena0 <= '1';
    prodXY_uid142_pT1_uid127_invPolyEval_cma_ena1 <= prodXY_uid142_pT1_uid127_invPolyEval_cma_ena0;
    prodXY_uid142_pT1_uid127_invPolyEval_cma_l(0) <= SIGNED(RESIZE(prodXY_uid142_pT1_uid127_invPolyEval_cma_a0(0),13));
    prodXY_uid142_pT1_uid127_invPolyEval_cma_p(0) <= prodXY_uid142_pT1_uid127_invPolyEval_cma_l(0) * prodXY_uid142_pT1_uid127_invPolyEval_cma_c0(0);
    prodXY_uid142_pT1_uid127_invPolyEval_cma_u(0) <= RESIZE(prodXY_uid142_pT1_uid127_invPolyEval_cma_p(0),25);
    prodXY_uid142_pT1_uid127_invPolyEval_cma_w(0) <= prodXY_uid142_pT1_uid127_invPolyEval_cma_u(0);
    prodXY_uid142_pT1_uid127_invPolyEval_cma_x(0) <= prodXY_uid142_pT1_uid127_invPolyEval_cma_w(0);
    prodXY_uid142_pT1_uid127_invPolyEval_cma_y(0) <= prodXY_uid142_pT1_uid127_invPolyEval_cma_x(0);
    prodXY_uid142_pT1_uid127_invPolyEval_cma_chainmultadd_input: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid142_pT1_uid127_invPolyEval_cma_a0 <= (others => (others => '0'));
            prodXY_uid142_pT1_uid127_invPolyEval_cma_c0 <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (prodXY_uid142_pT1_uid127_invPolyEval_cma_ena0 = '1') THEN
                prodXY_uid142_pT1_uid127_invPolyEval_cma_a0(0) <= RESIZE(UNSIGNED(yT1_uid126_invPolyEval_b),12);
                prodXY_uid142_pT1_uid127_invPolyEval_cma_c0(0) <= RESIZE(SIGNED(memoryC2_uid120_invTables_lutmem_r),12);
            END IF;
        END IF;
    END PROCESS;
    prodXY_uid142_pT1_uid127_invPolyEval_cma_chainmultadd_output: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid142_pT1_uid127_invPolyEval_cma_s <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (prodXY_uid142_pT1_uid127_invPolyEval_cma_ena1 = '1') THEN
                prodXY_uid142_pT1_uid127_invPolyEval_cma_s(0) <= prodXY_uid142_pT1_uid127_invPolyEval_cma_y(0);
            END IF;
        END IF;
    END PROCESS;
    prodXY_uid142_pT1_uid127_invPolyEval_cma_delay : dspba_delay
    GENERIC MAP ( width => 24, depth => 0, reset_kind => "ASYNC" )
    PORT MAP ( xin => STD_LOGIC_VECTOR(prodXY_uid142_pT1_uid127_invPolyEval_cma_s(0)(23 downto 0)), xout => prodXY_uid142_pT1_uid127_invPolyEval_cma_qq, clk => clk, aclr => areset );
    prodXY_uid142_pT1_uid127_invPolyEval_cma_q <= STD_LOGIC_VECTOR(prodXY_uid142_pT1_uid127_invPolyEval_cma_qq(23 downto 0));

    -- osig_uid143_pT1_uid127_invPolyEval(BITSELECT,142)@4
    osig_uid143_pT1_uid127_invPolyEval_b <= STD_LOGIC_VECTOR(prodXY_uid142_pT1_uid127_invPolyEval_cma_q(23 downto 11));

    -- highBBits_uid129_invPolyEval(BITSELECT,128)@4
    highBBits_uid129_invPolyEval_b <= STD_LOGIC_VECTOR(osig_uid143_pT1_uid127_invPolyEval_b(12 downto 1));

    -- memoryC1_uid117_invTables_q_const(CONSTANT,147)
    memoryC1_uid117_invTables_q_const_q <= "1";

    -- redist6_yAddr_uid51_fpDivTest_b_2(DELAY,162)
    redist6_yAddr_uid51_fpDivTest_b_2 : dspba_delay
    GENERIC MAP ( width => 9, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => yAddr_uid51_fpDivTest_b, xout => redist6_yAddr_uid51_fpDivTest_b_2_q, clk => clk, aclr => areset );

    -- memoryC1_uid116_invTables_lutmem(DUALMEM,150)@2 + 2
    -- in j@20000000
    memoryC1_uid116_invTables_lutmem_aa <= redist6_yAddr_uid51_fpDivTest_b_2_q;
    memoryC1_uid116_invTables_lutmem_reset0 <= areset;
    memoryC1_uid116_invTables_lutmem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M10K",
        operation_mode => "ROM",
        width_a => 20,
        widthad_a => 9,
        numwords_a => 512,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        outdata_reg_a => "CLOCK0",
        outdata_aclr_a => "CLEAR0",
        clock_enable_input_a => "NORMAL",
        power_up_uninitialized => "FALSE",
        init_file => "div_s_0002_memoryC1_uid116_invTables_lutmem.hex",
        init_file_layout => "PORT_A",
        intended_device_family => "Cyclone V"
    )
    PORT MAP (
        clocken0 => VCC_q(0),
        aclr0 => memoryC1_uid116_invTables_lutmem_reset0,
        clock0 => clk,
        address_a => memoryC1_uid116_invTables_lutmem_aa,
        q_a => memoryC1_uid116_invTables_lutmem_ir
    );
    memoryC1_uid116_invTables_lutmem_r <= memoryC1_uid116_invTables_lutmem_ir(19 downto 0);

    -- os_uid118_invTables(BITJOIN,117)@4
    os_uid118_invTables_q <= memoryC1_uid117_invTables_q_const_q & memoryC1_uid116_invTables_lutmem_r;

    -- s1sumAHighB_uid130_invPolyEval(ADD,129)@4
    s1sumAHighB_uid130_invPolyEval_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((21 downto 21 => os_uid118_invTables_q(20)) & os_uid118_invTables_q));
    s1sumAHighB_uid130_invPolyEval_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((21 downto 12 => highBBits_uid129_invPolyEval_b(11)) & highBBits_uid129_invPolyEval_b));
    s1sumAHighB_uid130_invPolyEval_o <= STD_LOGIC_VECTOR(SIGNED(s1sumAHighB_uid130_invPolyEval_a) + SIGNED(s1sumAHighB_uid130_invPolyEval_b));
    s1sumAHighB_uid130_invPolyEval_q <= s1sumAHighB_uid130_invPolyEval_o(21 downto 0);

    -- lowRangeB_uid128_invPolyEval(BITSELECT,127)@4
    lowRangeB_uid128_invPolyEval_in <= osig_uid143_pT1_uid127_invPolyEval_b(0 downto 0);
    lowRangeB_uid128_invPolyEval_b <= lowRangeB_uid128_invPolyEval_in(0 downto 0);

    -- s1_uid131_invPolyEval(BITJOIN,130)@4
    s1_uid131_invPolyEval_q <= s1sumAHighB_uid130_invPolyEval_q & lowRangeB_uid128_invPolyEval_b;

    -- redist5_yPE_uid52_fpDivTest_b_4(DELAY,161)
    redist5_yPE_uid52_fpDivTest_b_4 : dspba_delay
    GENERIC MAP ( width => 14, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist4_yPE_uid52_fpDivTest_b_2_q, xout => redist5_yPE_uid52_fpDivTest_b_4_q, clk => clk, aclr => areset );

    -- prodXY_uid145_pT2_uid133_invPolyEval_cma(CHAINMULTADD,154)@4 + 2
    prodXY_uid145_pT2_uid133_invPolyEval_cma_reset <= areset;
    prodXY_uid145_pT2_uid133_invPolyEval_cma_ena0 <= '1';
    prodXY_uid145_pT2_uid133_invPolyEval_cma_ena1 <= prodXY_uid145_pT2_uid133_invPolyEval_cma_ena0;
    prodXY_uid145_pT2_uid133_invPolyEval_cma_l(0) <= SIGNED(RESIZE(prodXY_uid145_pT2_uid133_invPolyEval_cma_a0(0),15));
    prodXY_uid145_pT2_uid133_invPolyEval_cma_p(0) <= prodXY_uid145_pT2_uid133_invPolyEval_cma_l(0) * prodXY_uid145_pT2_uid133_invPolyEval_cma_c0(0);
    prodXY_uid145_pT2_uid133_invPolyEval_cma_u(0) <= RESIZE(prodXY_uid145_pT2_uid133_invPolyEval_cma_p(0),38);
    prodXY_uid145_pT2_uid133_invPolyEval_cma_w(0) <= prodXY_uid145_pT2_uid133_invPolyEval_cma_u(0);
    prodXY_uid145_pT2_uid133_invPolyEval_cma_x(0) <= prodXY_uid145_pT2_uid133_invPolyEval_cma_w(0);
    prodXY_uid145_pT2_uid133_invPolyEval_cma_y(0) <= prodXY_uid145_pT2_uid133_invPolyEval_cma_x(0);
    prodXY_uid145_pT2_uid133_invPolyEval_cma_chainmultadd_input: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid145_pT2_uid133_invPolyEval_cma_a0 <= (others => (others => '0'));
            prodXY_uid145_pT2_uid133_invPolyEval_cma_c0 <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (prodXY_uid145_pT2_uid133_invPolyEval_cma_ena0 = '1') THEN
                prodXY_uid145_pT2_uid133_invPolyEval_cma_a0(0) <= RESIZE(UNSIGNED(redist5_yPE_uid52_fpDivTest_b_4_q),14);
                prodXY_uid145_pT2_uid133_invPolyEval_cma_c0(0) <= RESIZE(SIGNED(s1_uid131_invPolyEval_q),23);
            END IF;
        END IF;
    END PROCESS;
    prodXY_uid145_pT2_uid133_invPolyEval_cma_chainmultadd_output: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid145_pT2_uid133_invPolyEval_cma_s <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (prodXY_uid145_pT2_uid133_invPolyEval_cma_ena1 = '1') THEN
                prodXY_uid145_pT2_uid133_invPolyEval_cma_s(0) <= prodXY_uid145_pT2_uid133_invPolyEval_cma_y(0);
            END IF;
        END IF;
    END PROCESS;
    prodXY_uid145_pT2_uid133_invPolyEval_cma_delay : dspba_delay
    GENERIC MAP ( width => 37, depth => 0, reset_kind => "ASYNC" )
    PORT MAP ( xin => STD_LOGIC_VECTOR(prodXY_uid145_pT2_uid133_invPolyEval_cma_s(0)(36 downto 0)), xout => prodXY_uid145_pT2_uid133_invPolyEval_cma_qq, clk => clk, aclr => areset );
    prodXY_uid145_pT2_uid133_invPolyEval_cma_q <= STD_LOGIC_VECTOR(prodXY_uid145_pT2_uid133_invPolyEval_cma_qq(36 downto 0));

    -- osig_uid146_pT2_uid133_invPolyEval(BITSELECT,145)@6
    osig_uid146_pT2_uid133_invPolyEval_b <= STD_LOGIC_VECTOR(prodXY_uid145_pT2_uid133_invPolyEval_cma_q(36 downto 13));

    -- highBBits_uid135_invPolyEval(BITSELECT,134)@6
    highBBits_uid135_invPolyEval_b <= STD_LOGIC_VECTOR(osig_uid146_pT2_uid133_invPolyEval_b(23 downto 2));

    -- redist7_yAddr_uid51_fpDivTest_b_4(DELAY,163)
    redist7_yAddr_uid51_fpDivTest_b_4 : dspba_delay
    GENERIC MAP ( width => 9, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist6_yAddr_uid51_fpDivTest_b_2_q, xout => redist7_yAddr_uid51_fpDivTest_b_4_q, clk => clk, aclr => areset );

    -- memoryC0_uid113_invTables_lutmem(DUALMEM,149)@4 + 2
    -- in j@20000000
    memoryC0_uid113_invTables_lutmem_aa <= redist7_yAddr_uid51_fpDivTest_b_4_q;
    memoryC0_uid113_invTables_lutmem_reset0 <= areset;
    memoryC0_uid113_invTables_lutmem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M10K",
        operation_mode => "ROM",
        width_a => 11,
        widthad_a => 9,
        numwords_a => 512,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        outdata_reg_a => "CLOCK0",
        outdata_aclr_a => "CLEAR0",
        clock_enable_input_a => "NORMAL",
        power_up_uninitialized => "FALSE",
        init_file => "div_s_0002_memoryC0_uid113_invTables_lutmem.hex",
        init_file_layout => "PORT_A",
        intended_device_family => "Cyclone V"
    )
    PORT MAP (
        clocken0 => VCC_q(0),
        aclr0 => memoryC0_uid113_invTables_lutmem_reset0,
        clock0 => clk,
        address_a => memoryC0_uid113_invTables_lutmem_aa,
        q_a => memoryC0_uid113_invTables_lutmem_ir
    );
    memoryC0_uid113_invTables_lutmem_r <= memoryC0_uid113_invTables_lutmem_ir(10 downto 0);

    -- memoryC0_uid112_invTables_lutmem(DUALMEM,148)@4 + 2
    -- in j@20000000
    memoryC0_uid112_invTables_lutmem_aa <= redist7_yAddr_uid51_fpDivTest_b_4_q;
    memoryC0_uid112_invTables_lutmem_reset0 <= areset;
    memoryC0_uid112_invTables_lutmem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M10K",
        operation_mode => "ROM",
        width_a => 20,
        widthad_a => 9,
        numwords_a => 512,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        outdata_reg_a => "CLOCK0",
        outdata_aclr_a => "CLEAR0",
        clock_enable_input_a => "NORMAL",
        power_up_uninitialized => "FALSE",
        init_file => "div_s_0002_memoryC0_uid112_invTables_lutmem.hex",
        init_file_layout => "PORT_A",
        intended_device_family => "Cyclone V"
    )
    PORT MAP (
        clocken0 => VCC_q(0),
        aclr0 => memoryC0_uid112_invTables_lutmem_reset0,
        clock0 => clk,
        address_a => memoryC0_uid112_invTables_lutmem_aa,
        q_a => memoryC0_uid112_invTables_lutmem_ir
    );
    memoryC0_uid112_invTables_lutmem_r <= memoryC0_uid112_invTables_lutmem_ir(19 downto 0);

    -- os_uid114_invTables(BITJOIN,113)@6
    os_uid114_invTables_q <= memoryC0_uid113_invTables_lutmem_r & memoryC0_uid112_invTables_lutmem_r;

    -- s2sumAHighB_uid136_invPolyEval(ADD,135)@6
    s2sumAHighB_uid136_invPolyEval_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((31 downto 31 => os_uid114_invTables_q(30)) & os_uid114_invTables_q));
    s2sumAHighB_uid136_invPolyEval_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((31 downto 22 => highBBits_uid135_invPolyEval_b(21)) & highBBits_uid135_invPolyEval_b));
    s2sumAHighB_uid136_invPolyEval_o <= STD_LOGIC_VECTOR(SIGNED(s2sumAHighB_uid136_invPolyEval_a) + SIGNED(s2sumAHighB_uid136_invPolyEval_b));
    s2sumAHighB_uid136_invPolyEval_q <= s2sumAHighB_uid136_invPolyEval_o(31 downto 0);

    -- lowRangeB_uid134_invPolyEval(BITSELECT,133)@6
    lowRangeB_uid134_invPolyEval_in <= osig_uid146_pT2_uid133_invPolyEval_b(1 downto 0);
    lowRangeB_uid134_invPolyEval_b <= lowRangeB_uid134_invPolyEval_in(1 downto 0);

    -- s2_uid137_invPolyEval(BITJOIN,136)@6
    s2_uid137_invPolyEval_q <= s2sumAHighB_uid136_invPolyEval_q & lowRangeB_uid134_invPolyEval_b;

    -- invY_uid54_fpDivTest_merged_bit_select(BITSELECT,155)@6
    invY_uid54_fpDivTest_merged_bit_select_in <= s2_uid137_invPolyEval_q(31 downto 0);
    invY_uid54_fpDivTest_merged_bit_select_b <= invY_uid54_fpDivTest_merged_bit_select_in(30 downto 5);
    invY_uid54_fpDivTest_merged_bit_select_c <= invY_uid54_fpDivTest_merged_bit_select_in(31 downto 31);

    -- GND(CONSTANT,0)
    GND_q <= "0";

    -- prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma(CHAINMULTADD,152)@6 + 2
    prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_reset <= areset;
    prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_ena0 <= '1';
    prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_ena1 <= prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_ena0;
    prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_p(0) <= prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_a0(0) * prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_c0(0);
    prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_u(0) <= RESIZE(prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_p(0),50);
    prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_w(0) <= prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_u(0);
    prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_x(0) <= prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_w(0);
    prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_y(0) <= prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_x(0);
    prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_chainmultadd_input: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_a0 <= (others => (others => '0'));
            prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_c0 <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_ena0 = '1') THEN
                prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_a0(0) <= RESIZE(UNSIGNED(invY_uid54_fpDivTest_merged_bit_select_b),26);
                prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_c0(0) <= RESIZE(UNSIGNED(lOAdded_uid58_fpDivTest_q),24);
            END IF;
        END IF;
    END PROCESS;
    prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_chainmultadd_output: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_s <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_ena1 = '1') THEN
                prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_s(0) <= prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_y(0);
            END IF;
        END IF;
    END PROCESS;
    prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_delay : dspba_delay
    GENERIC MAP ( width => 50, depth => 0, reset_kind => "ASYNC" )
    PORT MAP ( xin => STD_LOGIC_VECTOR(prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_s(0)(49 downto 0)), xout => prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_qq, clk => clk, aclr => areset );
    prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_q <= STD_LOGIC_VECTOR(prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_qq(49 downto 0));

    -- osig_uid140_prodDivPreNormProd_uid60_fpDivTest(BITSELECT,139)@8
    osig_uid140_prodDivPreNormProd_uid60_fpDivTest_b <= prodXY_uid139_prodDivPreNormProd_uid60_fpDivTest_cma_q(49 downto 24);

    -- updatedY_uid16_fpDivTest(BITJOIN,15)@0
    updatedY_uid16_fpDivTest_q <= GND_q & paddingY_uid15_fpDivTest_q;

    -- fracYZero_uid15_fpDivTest(LOGICAL,16)@0 + 1
    fracYZero_uid15_fpDivTest_a <= STD_LOGIC_VECTOR("0" & fracY_uid13_fpDivTest_b);
    fracYZero_uid15_fpDivTest_qi <= "1" WHEN fracYZero_uid15_fpDivTest_a = updatedY_uid16_fpDivTest_q ELSE "0";
    fracYZero_uid15_fpDivTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracYZero_uid15_fpDivTest_qi, xout => fracYZero_uid15_fpDivTest_q, clk => clk, aclr => areset );

    -- redist16_fracYZero_uid15_fpDivTest_q_6(DELAY,172)
    redist16_fracYZero_uid15_fpDivTest_q_6 : dspba_delay
    GENERIC MAP ( width => 1, depth => 5, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracYZero_uid15_fpDivTest_q, xout => redist16_fracYZero_uid15_fpDivTest_q_6_q, clk => clk, aclr => areset );

    -- fracYPostZ_uid56_fpDivTest(LOGICAL,55)@6 + 1
    fracYPostZ_uid56_fpDivTest_qi <= redist16_fracYZero_uid15_fpDivTest_q_6_q or invY_uid54_fpDivTest_merged_bit_select_c;
    fracYPostZ_uid56_fpDivTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracYPostZ_uid56_fpDivTest_qi, xout => fracYPostZ_uid56_fpDivTest_q, clk => clk, aclr => areset );

    -- redist3_fracYPostZ_uid56_fpDivTest_q_2(DELAY,159)
    redist3_fracYPostZ_uid56_fpDivTest_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracYPostZ_uid56_fpDivTest_q, xout => redist3_fracYPostZ_uid56_fpDivTest_q_2_q, clk => clk, aclr => areset );

    -- divValPreNormTrunc_uid66_fpDivTest(MUX,65)@8
    divValPreNormTrunc_uid66_fpDivTest_s <= redist3_fracYPostZ_uid56_fpDivTest_q_2_q;
    divValPreNormTrunc_uid66_fpDivTest_combproc: PROCESS (divValPreNormTrunc_uid66_fpDivTest_s, osig_uid140_prodDivPreNormProd_uid60_fpDivTest_b, oFracXSE_mergedSignalTM_uid63_fpDivTest_q)
    BEGIN
        CASE (divValPreNormTrunc_uid66_fpDivTest_s) IS
            WHEN "0" => divValPreNormTrunc_uid66_fpDivTest_q <= osig_uid140_prodDivPreNormProd_uid60_fpDivTest_b;
            WHEN "1" => divValPreNormTrunc_uid66_fpDivTest_q <= oFracXSE_mergedSignalTM_uid63_fpDivTest_q;
            WHEN OTHERS => divValPreNormTrunc_uid66_fpDivTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- norm_uid67_fpDivTest(BITSELECT,66)@8
    norm_uid67_fpDivTest_b <= STD_LOGIC_VECTOR(divValPreNormTrunc_uid66_fpDivTest_q(25 downto 25));

    -- rndOp_uid75_fpDivTest(BITJOIN,74)@8
    rndOp_uid75_fpDivTest_q <= norm_uid67_fpDivTest_b & paddingY_uid15_fpDivTest_q & VCC_q;

    -- cstBiasM1_uid6_fpDivTest(CONSTANT,5)
    cstBiasM1_uid6_fpDivTest_q <= "01111110";

    -- redist8_expXmY_uid47_fpDivTest_q_8_notEnable(LOGICAL,181)
    redist8_expXmY_uid47_fpDivTest_q_8_notEnable_q <= STD_LOGIC_VECTOR(not (VCC_q));

    -- redist8_expXmY_uid47_fpDivTest_q_8_nor(LOGICAL,182)
    redist8_expXmY_uid47_fpDivTest_q_8_nor_q <= not (redist8_expXmY_uid47_fpDivTest_q_8_notEnable_q or redist8_expXmY_uid47_fpDivTest_q_8_sticky_ena_q);

    -- redist8_expXmY_uid47_fpDivTest_q_8_mem_last(CONSTANT,178)
    redist8_expXmY_uid47_fpDivTest_q_8_mem_last_q <= "011";

    -- redist8_expXmY_uid47_fpDivTest_q_8_cmp(LOGICAL,179)
    redist8_expXmY_uid47_fpDivTest_q_8_cmp_q <= "1" WHEN redist8_expXmY_uid47_fpDivTest_q_8_mem_last_q = redist8_expXmY_uid47_fpDivTest_q_8_rdcnt_q ELSE "0";

    -- redist8_expXmY_uid47_fpDivTest_q_8_cmpReg(REG,180)
    redist8_expXmY_uid47_fpDivTest_q_8_cmpReg_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            redist8_expXmY_uid47_fpDivTest_q_8_cmpReg_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            redist8_expXmY_uid47_fpDivTest_q_8_cmpReg_q <= STD_LOGIC_VECTOR(redist8_expXmY_uid47_fpDivTest_q_8_cmp_q);
        END IF;
    END PROCESS;

    -- redist8_expXmY_uid47_fpDivTest_q_8_sticky_ena(REG,183)
    redist8_expXmY_uid47_fpDivTest_q_8_sticky_ena_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            redist8_expXmY_uid47_fpDivTest_q_8_sticky_ena_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (redist8_expXmY_uid47_fpDivTest_q_8_nor_q = "1") THEN
                redist8_expXmY_uid47_fpDivTest_q_8_sticky_ena_q <= STD_LOGIC_VECTOR(redist8_expXmY_uid47_fpDivTest_q_8_cmpReg_q);
            END IF;
        END IF;
    END PROCESS;

    -- redist8_expXmY_uid47_fpDivTest_q_8_enaAnd(LOGICAL,184)
    redist8_expXmY_uid47_fpDivTest_q_8_enaAnd_q <= redist8_expXmY_uid47_fpDivTest_q_8_sticky_ena_q and VCC_q;

    -- redist8_expXmY_uid47_fpDivTest_q_8_rdcnt(COUNTER,176)
    -- low=0, high=4, step=1, init=0
    redist8_expXmY_uid47_fpDivTest_q_8_rdcnt_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            redist8_expXmY_uid47_fpDivTest_q_8_rdcnt_i <= TO_UNSIGNED(0, 3);
            redist8_expXmY_uid47_fpDivTest_q_8_rdcnt_eq <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (redist8_expXmY_uid47_fpDivTest_q_8_rdcnt_i = TO_UNSIGNED(3, 3)) THEN
                redist8_expXmY_uid47_fpDivTest_q_8_rdcnt_eq <= '1';
            ELSE
                redist8_expXmY_uid47_fpDivTest_q_8_rdcnt_eq <= '0';
            END IF;
            IF (redist8_expXmY_uid47_fpDivTest_q_8_rdcnt_eq = '1') THEN
                redist8_expXmY_uid47_fpDivTest_q_8_rdcnt_i <= redist8_expXmY_uid47_fpDivTest_q_8_rdcnt_i + 4;
            ELSE
                redist8_expXmY_uid47_fpDivTest_q_8_rdcnt_i <= redist8_expXmY_uid47_fpDivTest_q_8_rdcnt_i + 1;
            END IF;
        END IF;
    END PROCESS;
    redist8_expXmY_uid47_fpDivTest_q_8_rdcnt_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(redist8_expXmY_uid47_fpDivTest_q_8_rdcnt_i, 3)));

    -- expXmY_uid47_fpDivTest(SUB,46)@0 + 1
    expXmY_uid47_fpDivTest_a <= STD_LOGIC_VECTOR("0" & expX_uid9_fpDivTest_b);
    expXmY_uid47_fpDivTest_b <= STD_LOGIC_VECTOR("0" & expY_uid12_fpDivTest_b);
    expXmY_uid47_fpDivTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            expXmY_uid47_fpDivTest_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            expXmY_uid47_fpDivTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expXmY_uid47_fpDivTest_a) - UNSIGNED(expXmY_uid47_fpDivTest_b));
        END IF;
    END PROCESS;
    expXmY_uid47_fpDivTest_q <= expXmY_uid47_fpDivTest_o(8 downto 0);

    -- redist8_expXmY_uid47_fpDivTest_q_8_wraddr(REG,177)
    redist8_expXmY_uid47_fpDivTest_q_8_wraddr_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            redist8_expXmY_uid47_fpDivTest_q_8_wraddr_q <= "100";
        ELSIF (clk'EVENT AND clk = '1') THEN
            redist8_expXmY_uid47_fpDivTest_q_8_wraddr_q <= STD_LOGIC_VECTOR(redist8_expXmY_uid47_fpDivTest_q_8_rdcnt_q);
        END IF;
    END PROCESS;

    -- redist8_expXmY_uid47_fpDivTest_q_8_mem(DUALMEM,175)
    redist8_expXmY_uid47_fpDivTest_q_8_mem_ia <= STD_LOGIC_VECTOR(expXmY_uid47_fpDivTest_q);
    redist8_expXmY_uid47_fpDivTest_q_8_mem_aa <= redist8_expXmY_uid47_fpDivTest_q_8_wraddr_q;
    redist8_expXmY_uid47_fpDivTest_q_8_mem_ab <= redist8_expXmY_uid47_fpDivTest_q_8_rdcnt_q;
    redist8_expXmY_uid47_fpDivTest_q_8_mem_reset0 <= areset;
    redist8_expXmY_uid47_fpDivTest_q_8_mem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "MLAB",
        operation_mode => "DUAL_PORT",
        width_a => 9,
        widthad_a => 3,
        numwords_a => 5,
        width_b => 9,
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
        clocken1 => redist8_expXmY_uid47_fpDivTest_q_8_enaAnd_q(0),
        clocken0 => VCC_q(0),
        clock0 => clk,
        aclr1 => redist8_expXmY_uid47_fpDivTest_q_8_mem_reset0,
        clock1 => clk,
        address_a => redist8_expXmY_uid47_fpDivTest_q_8_mem_aa,
        data_a => redist8_expXmY_uid47_fpDivTest_q_8_mem_ia,
        wren_a => VCC_q(0),
        address_b => redist8_expXmY_uid47_fpDivTest_q_8_mem_ab,
        q_b => redist8_expXmY_uid47_fpDivTest_q_8_mem_iq
    );
    redist8_expXmY_uid47_fpDivTest_q_8_mem_q <= redist8_expXmY_uid47_fpDivTest_q_8_mem_iq(8 downto 0);

    -- redist8_expXmY_uid47_fpDivTest_q_8_outputreg(DELAY,174)
    redist8_expXmY_uid47_fpDivTest_q_8_outputreg : dspba_delay
    GENERIC MAP ( width => 9, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist8_expXmY_uid47_fpDivTest_q_8_mem_q, xout => redist8_expXmY_uid47_fpDivTest_q_8_outputreg_q, clk => clk, aclr => areset );

    -- expR_uid48_fpDivTest(ADD,47)@8
    expR_uid48_fpDivTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((10 downto 9 => redist8_expXmY_uid47_fpDivTest_q_8_outputreg_q(8)) & redist8_expXmY_uid47_fpDivTest_q_8_outputreg_q));
    expR_uid48_fpDivTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000" & cstBiasM1_uid6_fpDivTest_q));
    expR_uid48_fpDivTest_o <= STD_LOGIC_VECTOR(SIGNED(expR_uid48_fpDivTest_a) + SIGNED(expR_uid48_fpDivTest_b));
    expR_uid48_fpDivTest_q <= expR_uid48_fpDivTest_o(9 downto 0);

    -- divValPreNormHigh_uid68_fpDivTest(BITSELECT,67)@8
    divValPreNormHigh_uid68_fpDivTest_in <= divValPreNormTrunc_uid66_fpDivTest_q(24 downto 0);
    divValPreNormHigh_uid68_fpDivTest_b <= divValPreNormHigh_uid68_fpDivTest_in(24 downto 1);

    -- divValPreNormLow_uid69_fpDivTest(BITSELECT,68)@8
    divValPreNormLow_uid69_fpDivTest_in <= divValPreNormTrunc_uid66_fpDivTest_q(23 downto 0);
    divValPreNormLow_uid69_fpDivTest_b <= divValPreNormLow_uid69_fpDivTest_in(23 downto 0);

    -- normFracRnd_uid70_fpDivTest(MUX,69)@8
    normFracRnd_uid70_fpDivTest_s <= norm_uid67_fpDivTest_b;
    normFracRnd_uid70_fpDivTest_combproc: PROCESS (normFracRnd_uid70_fpDivTest_s, divValPreNormLow_uid69_fpDivTest_b, divValPreNormHigh_uid68_fpDivTest_b)
    BEGIN
        CASE (normFracRnd_uid70_fpDivTest_s) IS
            WHEN "0" => normFracRnd_uid70_fpDivTest_q <= divValPreNormLow_uid69_fpDivTest_b;
            WHEN "1" => normFracRnd_uid70_fpDivTest_q <= divValPreNormHigh_uid68_fpDivTest_b;
            WHEN OTHERS => normFracRnd_uid70_fpDivTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- expFracRnd_uid71_fpDivTest(BITJOIN,70)@8
    expFracRnd_uid71_fpDivTest_q <= expR_uid48_fpDivTest_q & normFracRnd_uid70_fpDivTest_q;

    -- expFracPostRnd_uid76_fpDivTest(ADD,75)@8
    expFracPostRnd_uid76_fpDivTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((35 downto 34 => expFracRnd_uid71_fpDivTest_q(33)) & expFracRnd_uid71_fpDivTest_q));
    expFracPostRnd_uid76_fpDivTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("00000000000" & rndOp_uid75_fpDivTest_q));
    expFracPostRnd_uid76_fpDivTest_o <= STD_LOGIC_VECTOR(SIGNED(expFracPostRnd_uid76_fpDivTest_a) + SIGNED(expFracPostRnd_uid76_fpDivTest_b));
    expFracPostRnd_uid76_fpDivTest_q <= expFracPostRnd_uid76_fpDivTest_o(34 downto 0);

    -- excRPreExc_uid79_fpDivTest(BITSELECT,78)@8
    excRPreExc_uid79_fpDivTest_in <= expFracPostRnd_uid76_fpDivTest_q(31 downto 0);
    excRPreExc_uid79_fpDivTest_b <= excRPreExc_uid79_fpDivTest_in(31 downto 24);

    -- redist0_excRPreExc_uid79_fpDivTest_b_1(DELAY,156)
    redist0_excRPreExc_uid79_fpDivTest_b_1 : dspba_delay
    GENERIC MAP ( width => 8, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excRPreExc_uid79_fpDivTest_b, xout => redist0_excRPreExc_uid79_fpDivTest_b_1_q, clk => clk, aclr => areset );

    -- invExpXIsMax_uid43_fpDivTest(LOGICAL,42)@9
    invExpXIsMax_uid43_fpDivTest_q <= not (redist11_expXIsMax_uid38_fpDivTest_q_9_q);

    -- InvExpXIsZero_uid44_fpDivTest(LOGICAL,43)@9
    InvExpXIsZero_uid44_fpDivTest_q <= not (redist12_excZ_y_uid37_fpDivTest_q_9_q);

    -- excR_y_uid45_fpDivTest(LOGICAL,44)@9
    excR_y_uid45_fpDivTest_q <= InvExpXIsZero_uid44_fpDivTest_q and invExpXIsMax_uid43_fpDivTest_q;

    -- excXIYR_uid93_fpDivTest(LOGICAL,92)@9
    excXIYR_uid93_fpDivTest_q <= excI_x_uid27_fpDivTest_q and excR_y_uid45_fpDivTest_q;

    -- excXIYZ_uid92_fpDivTest(LOGICAL,91)@9
    excXIYZ_uid92_fpDivTest_q <= excI_x_uid27_fpDivTest_q and redist12_excZ_y_uid37_fpDivTest_q_9_q;

    -- expRExt_uid80_fpDivTest(BITSELECT,79)@8
    expRExt_uid80_fpDivTest_b <= STD_LOGIC_VECTOR(expFracPostRnd_uid76_fpDivTest_q(34 downto 24));

    -- expOvf_uid84_fpDivTest(COMPARE,83)@8 + 1
    expOvf_uid84_fpDivTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((12 downto 11 => expRExt_uid80_fpDivTest_b(10)) & expRExt_uid80_fpDivTest_b));
    expOvf_uid84_fpDivTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("00000" & cstAllOWE_uid18_fpDivTest_q));
    expOvf_uid84_fpDivTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            expOvf_uid84_fpDivTest_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            expOvf_uid84_fpDivTest_o <= STD_LOGIC_VECTOR(SIGNED(expOvf_uid84_fpDivTest_a) - SIGNED(expOvf_uid84_fpDivTest_b));
        END IF;
    END PROCESS;
    expOvf_uid84_fpDivTest_n(0) <= not (expOvf_uid84_fpDivTest_o(12));

    -- invExpXIsMax_uid29_fpDivTest(LOGICAL,28)@9
    invExpXIsMax_uid29_fpDivTest_q <= not (redist14_expXIsMax_uid24_fpDivTest_q_9_q);

    -- InvExpXIsZero_uid30_fpDivTest(LOGICAL,29)@9
    InvExpXIsZero_uid30_fpDivTest_q <= not (redist15_excZ_x_uid23_fpDivTest_q_9_q);

    -- excR_x_uid31_fpDivTest(LOGICAL,30)@9
    excR_x_uid31_fpDivTest_q <= InvExpXIsZero_uid30_fpDivTest_q and invExpXIsMax_uid29_fpDivTest_q;

    -- excXRYROvf_uid91_fpDivTest(LOGICAL,90)@9
    excXRYROvf_uid91_fpDivTest_q <= excR_x_uid31_fpDivTest_q and excR_y_uid45_fpDivTest_q and expOvf_uid84_fpDivTest_n;

    -- excXRYZ_uid90_fpDivTest(LOGICAL,89)@9
    excXRYZ_uid90_fpDivTest_q <= excR_x_uid31_fpDivTest_q and redist12_excZ_y_uid37_fpDivTest_q_9_q;

    -- excRInf_uid94_fpDivTest(LOGICAL,93)@9
    excRInf_uid94_fpDivTest_q <= excXRYZ_uid90_fpDivTest_q or excXRYROvf_uid91_fpDivTest_q or excXIYZ_uid92_fpDivTest_q or excXIYR_uid93_fpDivTest_q;

    -- xRegOrZero_uid87_fpDivTest(LOGICAL,86)@9
    xRegOrZero_uid87_fpDivTest_q <= excR_x_uid31_fpDivTest_q or redist15_excZ_x_uid23_fpDivTest_q_9_q;

    -- regOrZeroOverInf_uid88_fpDivTest(LOGICAL,87)@9
    regOrZeroOverInf_uid88_fpDivTest_q <= xRegOrZero_uid87_fpDivTest_q and excI_y_uid41_fpDivTest_q;

    -- expUdf_uid81_fpDivTest(COMPARE,80)@8 + 1
    expUdf_uid81_fpDivTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000000000000" & GND_q));
    expUdf_uid81_fpDivTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((12 downto 11 => expRExt_uid80_fpDivTest_b(10)) & expRExt_uid80_fpDivTest_b));
    expUdf_uid81_fpDivTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            expUdf_uid81_fpDivTest_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            expUdf_uid81_fpDivTest_o <= STD_LOGIC_VECTOR(SIGNED(expUdf_uid81_fpDivTest_a) - SIGNED(expUdf_uid81_fpDivTest_b));
        END IF;
    END PROCESS;
    expUdf_uid81_fpDivTest_n(0) <= not (expUdf_uid81_fpDivTest_o(12));

    -- regOverRegWithUf_uid86_fpDivTest(LOGICAL,85)@9
    regOverRegWithUf_uid86_fpDivTest_q <= expUdf_uid81_fpDivTest_n and excR_x_uid31_fpDivTest_q and excR_y_uid45_fpDivTest_q;

    -- zeroOverReg_uid85_fpDivTest(LOGICAL,84)@9
    zeroOverReg_uid85_fpDivTest_q <= redist15_excZ_x_uid23_fpDivTest_q_9_q and excR_y_uid45_fpDivTest_q;

    -- excRZero_uid89_fpDivTest(LOGICAL,88)@9
    excRZero_uid89_fpDivTest_q <= zeroOverReg_uid85_fpDivTest_q or regOverRegWithUf_uid86_fpDivTest_q or regOrZeroOverInf_uid88_fpDivTest_q;

    -- concExc_uid98_fpDivTest(BITJOIN,97)@9
    concExc_uid98_fpDivTest_q <= excRNaN_uid97_fpDivTest_q & excRInf_uid94_fpDivTest_q & excRZero_uid89_fpDivTest_q;

    -- excREnc_uid99_fpDivTest(LOOKUP,98)@9
    excREnc_uid99_fpDivTest_combproc: PROCESS (concExc_uid98_fpDivTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (concExc_uid98_fpDivTest_q) IS
            WHEN "000" => excREnc_uid99_fpDivTest_q <= "01";
            WHEN "001" => excREnc_uid99_fpDivTest_q <= "00";
            WHEN "010" => excREnc_uid99_fpDivTest_q <= "10";
            WHEN "011" => excREnc_uid99_fpDivTest_q <= "00";
            WHEN "100" => excREnc_uid99_fpDivTest_q <= "11";
            WHEN "101" => excREnc_uid99_fpDivTest_q <= "00";
            WHEN "110" => excREnc_uid99_fpDivTest_q <= "00";
            WHEN "111" => excREnc_uid99_fpDivTest_q <= "00";
            WHEN OTHERS => -- unreachable
                           excREnc_uid99_fpDivTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- expRPostExc_uid107_fpDivTest(MUX,106)@9
    expRPostExc_uid107_fpDivTest_s <= excREnc_uid99_fpDivTest_q;
    expRPostExc_uid107_fpDivTest_combproc: PROCESS (expRPostExc_uid107_fpDivTest_s, cstAllZWE_uid20_fpDivTest_q, redist0_excRPreExc_uid79_fpDivTest_b_1_q, cstAllOWE_uid18_fpDivTest_q)
    BEGIN
        CASE (expRPostExc_uid107_fpDivTest_s) IS
            WHEN "00" => expRPostExc_uid107_fpDivTest_q <= cstAllZWE_uid20_fpDivTest_q;
            WHEN "01" => expRPostExc_uid107_fpDivTest_q <= redist0_excRPreExc_uid79_fpDivTest_b_1_q;
            WHEN "10" => expRPostExc_uid107_fpDivTest_q <= cstAllOWE_uid18_fpDivTest_q;
            WHEN "11" => expRPostExc_uid107_fpDivTest_q <= cstAllOWE_uid18_fpDivTest_q;
            WHEN OTHERS => expRPostExc_uid107_fpDivTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- oneFracRPostExc2_uid100_fpDivTest(CONSTANT,99)
    oneFracRPostExc2_uid100_fpDivTest_q <= "00000000000000000000001";

    -- fracRPreExc_uid78_fpDivTest(BITSELECT,77)@8
    fracRPreExc_uid78_fpDivTest_in <= expFracPostRnd_uid76_fpDivTest_q(23 downto 0);
    fracRPreExc_uid78_fpDivTest_b <= fracRPreExc_uid78_fpDivTest_in(23 downto 1);

    -- redist1_fracRPreExc_uid78_fpDivTest_b_1(DELAY,157)
    redist1_fracRPreExc_uid78_fpDivTest_b_1 : dspba_delay
    GENERIC MAP ( width => 23, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracRPreExc_uid78_fpDivTest_b, xout => redist1_fracRPreExc_uid78_fpDivTest_b_1_q, clk => clk, aclr => areset );

    -- fracRPostExc_uid103_fpDivTest(MUX,102)@9
    fracRPostExc_uid103_fpDivTest_s <= excREnc_uid99_fpDivTest_q;
    fracRPostExc_uid103_fpDivTest_combproc: PROCESS (fracRPostExc_uid103_fpDivTest_s, paddingY_uid15_fpDivTest_q, redist1_fracRPreExc_uid78_fpDivTest_b_1_q, oneFracRPostExc2_uid100_fpDivTest_q)
    BEGIN
        CASE (fracRPostExc_uid103_fpDivTest_s) IS
            WHEN "00" => fracRPostExc_uid103_fpDivTest_q <= paddingY_uid15_fpDivTest_q;
            WHEN "01" => fracRPostExc_uid103_fpDivTest_q <= redist1_fracRPreExc_uid78_fpDivTest_b_1_q;
            WHEN "10" => fracRPostExc_uid103_fpDivTest_q <= paddingY_uid15_fpDivTest_q;
            WHEN "11" => fracRPostExc_uid103_fpDivTest_q <= oneFracRPostExc2_uid100_fpDivTest_q;
            WHEN OTHERS => fracRPostExc_uid103_fpDivTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- divR_uid110_fpDivTest(BITJOIN,109)@9
    divR_uid110_fpDivTest_q <= sRPostExc_uid109_fpDivTest_q & expRPostExc_uid107_fpDivTest_q & fracRPostExc_uid103_fpDivTest_q;

    -- xOut(GPOUT,4)@9
    q <= divR_uid110_fpDivTest_q;

END normal;
