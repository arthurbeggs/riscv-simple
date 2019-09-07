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

-- VHDL created from cvt_wu_s_0002
-- VHDL created on Fri Mar 08 18:17:09 2019


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

entity cvt_wu_s_0002 is
    port (
        a : in std_logic_vector(31 downto 0);  -- float32_m23
        q : out std_logic_vector(31 downto 0);  -- ufix32
        clk : in std_logic;
        areset : in std_logic
    );
end cvt_wu_s_0002;

architecture normal of cvt_wu_s_0002 is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cstAllOWE_uid6_fpToFxPTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal cstZeroWF_uid7_fpToFxPTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal cstAllZWE_uid8_fpToFxPTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal exp_x_uid9_fpToFxPTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal frac_x_uid10_fpToFxPTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal excZ_x_uid11_fpToFxPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid12_fpToFxPTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid12_fpToFxPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid13_fpToFxPTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid13_fpToFxPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid14_fpToFxPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_x_uid15_fpToFxPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_x_uid16_fpToFxPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExcXZ_uid22_fpToFxPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal oFracX_uid23_fpToFxPTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal signX_uid25_fpToFxPTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal ovfExpVal_uid26_fpToFxPTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal ovf_uid27_fpToFxPTest_a : STD_LOGIC_VECTOR (10 downto 0);
    signal ovf_uid27_fpToFxPTest_b : STD_LOGIC_VECTOR (10 downto 0);
    signal ovf_uid27_fpToFxPTest_o : STD_LOGIC_VECTOR (10 downto 0);
    signal ovf_uid27_fpToFxPTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal negOrOvf_uid28_fpToFxPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal udfExpVal_uid29_fpToFxPTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal udf_uid30_fpToFxPTest_a : STD_LOGIC_VECTOR (10 downto 0);
    signal udf_uid30_fpToFxPTest_b : STD_LOGIC_VECTOR (10 downto 0);
    signal udf_uid30_fpToFxPTest_o : STD_LOGIC_VECTOR (10 downto 0);
    signal udf_uid30_fpToFxPTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal ovfExpVal_uid31_fpToFxPTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal shiftValE_uid32_fpToFxPTest_a : STD_LOGIC_VECTOR (10 downto 0);
    signal shiftValE_uid32_fpToFxPTest_b : STD_LOGIC_VECTOR (10 downto 0);
    signal shiftValE_uid32_fpToFxPTest_o : STD_LOGIC_VECTOR (10 downto 0);
    signal shiftValE_uid32_fpToFxPTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal shiftValRaw_uid33_fpToFxPTest_in : STD_LOGIC_VECTOR (5 downto 0);
    signal shiftValRaw_uid33_fpToFxPTest_b : STD_LOGIC_VECTOR (5 downto 0);
    signal maxShiftCst_uid34_fpToFxPTest_q : STD_LOGIC_VECTOR (5 downto 0);
    signal shiftOutOfRange_uid35_fpToFxPTest_a : STD_LOGIC_VECTOR (11 downto 0);
    signal shiftOutOfRange_uid35_fpToFxPTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal shiftOutOfRange_uid35_fpToFxPTest_o : STD_LOGIC_VECTOR (11 downto 0);
    signal shiftOutOfRange_uid35_fpToFxPTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal shiftVal_uid36_fpToFxPTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal shiftVal_uid36_fpToFxPTest_q : STD_LOGIC_VECTOR (5 downto 0);
    signal zPadd_uid37_fpToFxPTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal shifterIn_uid38_fpToFxPTest_q : STD_LOGIC_VECTOR (32 downto 0);
    signal maxPosValueU_uid40_fpToFxPTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal maxNegValueU_uid41_fpToFxPTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal zRightShiferNoStickyOut_uid43_fpToFxPTest_q : STD_LOGIC_VECTOR (33 downto 0);
    signal sPostRndFull_uid44_fpToFxPTest_a : STD_LOGIC_VECTOR (34 downto 0);
    signal sPostRndFull_uid44_fpToFxPTest_b : STD_LOGIC_VECTOR (34 downto 0);
    signal sPostRndFull_uid44_fpToFxPTest_o : STD_LOGIC_VECTOR (34 downto 0);
    signal sPostRndFull_uid44_fpToFxPTest_q : STD_LOGIC_VECTOR (34 downto 0);
    signal sPostRnd_uid45_fpToFxPTest_in : STD_LOGIC_VECTOR (32 downto 0);
    signal sPostRnd_uid45_fpToFxPTest_b : STD_LOGIC_VECTOR (31 downto 0);
    signal sPostRndFullMSBU_uid46_fpToFxPTest_in : STD_LOGIC_VECTOR (33 downto 0);
    signal sPostRndFullMSBU_uid46_fpToFxPTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal ovfPostRnd_uid47_fpToFxPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal muxSelConc_uid48_fpToFxPTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal muxSel_uid49_fpToFxPTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal finalOut_uid51_fpToFxPTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal finalOut_uid51_fpToFxPTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal rightShiftStage0Idx1Rng16_uid55_rightShiferNoStickyOut_uid39_fpToFxPTest_b : STD_LOGIC_VECTOR (16 downto 0);
    signal rightShiftStage0Idx1Pad16_uid56_rightShiferNoStickyOut_uid39_fpToFxPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal rightShiftStage0Idx1_uid57_rightShiferNoStickyOut_uid39_fpToFxPTest_q : STD_LOGIC_VECTOR (32 downto 0);
    signal rightShiftStage0Idx2Rng32_uid58_rightShiferNoStickyOut_uid39_fpToFxPTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal rightShiftStage0Idx2_uid60_rightShiferNoStickyOut_uid39_fpToFxPTest_q : STD_LOGIC_VECTOR (32 downto 0);
    signal rightShiftStage0Idx3_uid61_rightShiferNoStickyOut_uid39_fpToFxPTest_q : STD_LOGIC_VECTOR (32 downto 0);
    signal rightShiftStage0_uid63_rightShiferNoStickyOut_uid39_fpToFxPTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage0_uid63_rightShiferNoStickyOut_uid39_fpToFxPTest_q : STD_LOGIC_VECTOR (32 downto 0);
    signal rightShiftStage1Idx1Rng4_uid64_rightShiferNoStickyOut_uid39_fpToFxPTest_b : STD_LOGIC_VECTOR (28 downto 0);
    signal rightShiftStage1Idx1Pad4_uid65_rightShiferNoStickyOut_uid39_fpToFxPTest_q : STD_LOGIC_VECTOR (3 downto 0);
    signal rightShiftStage1Idx1_uid66_rightShiferNoStickyOut_uid39_fpToFxPTest_q : STD_LOGIC_VECTOR (32 downto 0);
    signal rightShiftStage1Idx2Rng8_uid67_rightShiferNoStickyOut_uid39_fpToFxPTest_b : STD_LOGIC_VECTOR (24 downto 0);
    signal rightShiftStage1Idx2_uid69_rightShiferNoStickyOut_uid39_fpToFxPTest_q : STD_LOGIC_VECTOR (32 downto 0);
    signal rightShiftStage1Idx3Rng12_uid70_rightShiferNoStickyOut_uid39_fpToFxPTest_b : STD_LOGIC_VECTOR (20 downto 0);
    signal rightShiftStage1Idx3Pad12_uid71_rightShiferNoStickyOut_uid39_fpToFxPTest_q : STD_LOGIC_VECTOR (11 downto 0);
    signal rightShiftStage1Idx3_uid72_rightShiferNoStickyOut_uid39_fpToFxPTest_q : STD_LOGIC_VECTOR (32 downto 0);
    signal rightShiftStage1_uid74_rightShiferNoStickyOut_uid39_fpToFxPTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage1_uid74_rightShiferNoStickyOut_uid39_fpToFxPTest_q : STD_LOGIC_VECTOR (32 downto 0);
    signal rightShiftStage2Idx1Rng1_uid75_rightShiferNoStickyOut_uid39_fpToFxPTest_b : STD_LOGIC_VECTOR (31 downto 0);
    signal rightShiftStage2Idx1_uid77_rightShiferNoStickyOut_uid39_fpToFxPTest_q : STD_LOGIC_VECTOR (32 downto 0);
    signal rightShiftStage2Idx2Rng2_uid78_rightShiferNoStickyOut_uid39_fpToFxPTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal rightShiftStage2Idx2Pad2_uid79_rightShiferNoStickyOut_uid39_fpToFxPTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage2Idx2_uid80_rightShiferNoStickyOut_uid39_fpToFxPTest_q : STD_LOGIC_VECTOR (32 downto 0);
    signal rightShiftStage2Idx3Rng3_uid81_rightShiferNoStickyOut_uid39_fpToFxPTest_b : STD_LOGIC_VECTOR (29 downto 0);
    signal rightShiftStage2Idx3Pad3_uid82_rightShiferNoStickyOut_uid39_fpToFxPTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal rightShiftStage2Idx3_uid83_rightShiferNoStickyOut_uid39_fpToFxPTest_q : STD_LOGIC_VECTOR (32 downto 0);
    signal rightShiftStage2_uid85_rightShiferNoStickyOut_uid39_fpToFxPTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage2_uid85_rightShiferNoStickyOut_uid39_fpToFxPTest_q : STD_LOGIC_VECTOR (32 downto 0);
    signal rightShiftStageSel5Dto4_uid62_rightShiferNoStickyOut_uid39_fpToFxPTest_merged_bit_select_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStageSel5Dto4_uid62_rightShiferNoStickyOut_uid39_fpToFxPTest_merged_bit_select_c : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStageSel5Dto4_uid62_rightShiferNoStickyOut_uid39_fpToFxPTest_merged_bit_select_d : STD_LOGIC_VECTOR (1 downto 0);
    signal redist0_rightShiftStageSel5Dto4_uid62_rightShiferNoStickyOut_uid39_fpToFxPTest_merged_bit_select_d_1_q : STD_LOGIC_VECTOR (1 downto 0);
    signal redist1_signX_uid25_fpToFxPTest_b_1_q : STD_LOGIC_VECTOR (0 downto 0);

begin


    -- maxNegValueU_uid41_fpToFxPTest(CONSTANT,40)
    maxNegValueU_uid41_fpToFxPTest_q <= "00000000000000000000000000000000";

    -- maxPosValueU_uid40_fpToFxPTest(CONSTANT,39)
    maxPosValueU_uid40_fpToFxPTest_q <= "11111111111111111111111111111111";

    -- GND(CONSTANT,0)
    GND_q <= "0";

    -- rightShiftStage2Idx3Pad3_uid82_rightShiferNoStickyOut_uid39_fpToFxPTest(CONSTANT,81)
    rightShiftStage2Idx3Pad3_uid82_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= "000";

    -- rightShiftStage2Idx3Rng3_uid81_rightShiferNoStickyOut_uid39_fpToFxPTest(BITSELECT,80)@1
    rightShiftStage2Idx3Rng3_uid81_rightShiferNoStickyOut_uid39_fpToFxPTest_b <= rightShiftStage1_uid74_rightShiferNoStickyOut_uid39_fpToFxPTest_q(32 downto 3);

    -- rightShiftStage2Idx3_uid83_rightShiferNoStickyOut_uid39_fpToFxPTest(BITJOIN,82)@1
    rightShiftStage2Idx3_uid83_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= rightShiftStage2Idx3Pad3_uid82_rightShiferNoStickyOut_uid39_fpToFxPTest_q & rightShiftStage2Idx3Rng3_uid81_rightShiferNoStickyOut_uid39_fpToFxPTest_b;

    -- rightShiftStage2Idx2Pad2_uid79_rightShiferNoStickyOut_uid39_fpToFxPTest(CONSTANT,78)
    rightShiftStage2Idx2Pad2_uid79_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= "00";

    -- rightShiftStage2Idx2Rng2_uid78_rightShiferNoStickyOut_uid39_fpToFxPTest(BITSELECT,77)@1
    rightShiftStage2Idx2Rng2_uid78_rightShiferNoStickyOut_uid39_fpToFxPTest_b <= rightShiftStage1_uid74_rightShiferNoStickyOut_uid39_fpToFxPTest_q(32 downto 2);

    -- rightShiftStage2Idx2_uid80_rightShiferNoStickyOut_uid39_fpToFxPTest(BITJOIN,79)@1
    rightShiftStage2Idx2_uid80_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= rightShiftStage2Idx2Pad2_uid79_rightShiferNoStickyOut_uid39_fpToFxPTest_q & rightShiftStage2Idx2Rng2_uid78_rightShiferNoStickyOut_uid39_fpToFxPTest_b;

    -- rightShiftStage2Idx1Rng1_uid75_rightShiferNoStickyOut_uid39_fpToFxPTest(BITSELECT,74)@1
    rightShiftStage2Idx1Rng1_uid75_rightShiferNoStickyOut_uid39_fpToFxPTest_b <= rightShiftStage1_uid74_rightShiferNoStickyOut_uid39_fpToFxPTest_q(32 downto 1);

    -- rightShiftStage2Idx1_uid77_rightShiferNoStickyOut_uid39_fpToFxPTest(BITJOIN,76)@1
    rightShiftStage2Idx1_uid77_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= GND_q & rightShiftStage2Idx1Rng1_uid75_rightShiferNoStickyOut_uid39_fpToFxPTest_b;

    -- rightShiftStage1Idx3Pad12_uid71_rightShiferNoStickyOut_uid39_fpToFxPTest(CONSTANT,70)
    rightShiftStage1Idx3Pad12_uid71_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= "000000000000";

    -- rightShiftStage1Idx3Rng12_uid70_rightShiferNoStickyOut_uid39_fpToFxPTest(BITSELECT,69)@0
    rightShiftStage1Idx3Rng12_uid70_rightShiferNoStickyOut_uid39_fpToFxPTest_b <= rightShiftStage0_uid63_rightShiferNoStickyOut_uid39_fpToFxPTest_q(32 downto 12);

    -- rightShiftStage1Idx3_uid72_rightShiferNoStickyOut_uid39_fpToFxPTest(BITJOIN,71)@0
    rightShiftStage1Idx3_uid72_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= rightShiftStage1Idx3Pad12_uid71_rightShiferNoStickyOut_uid39_fpToFxPTest_q & rightShiftStage1Idx3Rng12_uid70_rightShiferNoStickyOut_uid39_fpToFxPTest_b;

    -- cstAllZWE_uid8_fpToFxPTest(CONSTANT,7)
    cstAllZWE_uid8_fpToFxPTest_q <= "00000000";

    -- rightShiftStage1Idx2Rng8_uid67_rightShiferNoStickyOut_uid39_fpToFxPTest(BITSELECT,66)@0
    rightShiftStage1Idx2Rng8_uid67_rightShiferNoStickyOut_uid39_fpToFxPTest_b <= rightShiftStage0_uid63_rightShiferNoStickyOut_uid39_fpToFxPTest_q(32 downto 8);

    -- rightShiftStage1Idx2_uid69_rightShiferNoStickyOut_uid39_fpToFxPTest(BITJOIN,68)@0
    rightShiftStage1Idx2_uid69_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= cstAllZWE_uid8_fpToFxPTest_q & rightShiftStage1Idx2Rng8_uid67_rightShiferNoStickyOut_uid39_fpToFxPTest_b;

    -- rightShiftStage1Idx1Pad4_uid65_rightShiferNoStickyOut_uid39_fpToFxPTest(CONSTANT,64)
    rightShiftStage1Idx1Pad4_uid65_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= "0000";

    -- rightShiftStage1Idx1Rng4_uid64_rightShiferNoStickyOut_uid39_fpToFxPTest(BITSELECT,63)@0
    rightShiftStage1Idx1Rng4_uid64_rightShiferNoStickyOut_uid39_fpToFxPTest_b <= rightShiftStage0_uid63_rightShiferNoStickyOut_uid39_fpToFxPTest_q(32 downto 4);

    -- rightShiftStage1Idx1_uid66_rightShiferNoStickyOut_uid39_fpToFxPTest(BITJOIN,65)@0
    rightShiftStage1Idx1_uid66_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= rightShiftStage1Idx1Pad4_uid65_rightShiferNoStickyOut_uid39_fpToFxPTest_q & rightShiftStage1Idx1Rng4_uid64_rightShiferNoStickyOut_uid39_fpToFxPTest_b;

    -- rightShiftStage0Idx3_uid61_rightShiferNoStickyOut_uid39_fpToFxPTest(CONSTANT,60)
    rightShiftStage0Idx3_uid61_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= "000000000000000000000000000000000";

    -- rightShiftStage0Idx2Rng32_uid58_rightShiferNoStickyOut_uid39_fpToFxPTest(BITSELECT,57)@0
    rightShiftStage0Idx2Rng32_uid58_rightShiferNoStickyOut_uid39_fpToFxPTest_b <= shifterIn_uid38_fpToFxPTest_q(32 downto 32);

    -- rightShiftStage0Idx2_uid60_rightShiferNoStickyOut_uid39_fpToFxPTest(BITJOIN,59)@0
    rightShiftStage0Idx2_uid60_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= maxNegValueU_uid41_fpToFxPTest_q & rightShiftStage0Idx2Rng32_uid58_rightShiferNoStickyOut_uid39_fpToFxPTest_b;

    -- rightShiftStage0Idx1Pad16_uid56_rightShiferNoStickyOut_uid39_fpToFxPTest(CONSTANT,55)
    rightShiftStage0Idx1Pad16_uid56_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= "0000000000000000";

    -- rightShiftStage0Idx1Rng16_uid55_rightShiferNoStickyOut_uid39_fpToFxPTest(BITSELECT,54)@0
    rightShiftStage0Idx1Rng16_uid55_rightShiferNoStickyOut_uid39_fpToFxPTest_b <= shifterIn_uid38_fpToFxPTest_q(32 downto 16);

    -- rightShiftStage0Idx1_uid57_rightShiferNoStickyOut_uid39_fpToFxPTest(BITJOIN,56)@0
    rightShiftStage0Idx1_uid57_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= rightShiftStage0Idx1Pad16_uid56_rightShiferNoStickyOut_uid39_fpToFxPTest_q & rightShiftStage0Idx1Rng16_uid55_rightShiferNoStickyOut_uid39_fpToFxPTest_b;

    -- exp_x_uid9_fpToFxPTest(BITSELECT,8)@0
    exp_x_uid9_fpToFxPTest_b <= a(30 downto 23);

    -- excZ_x_uid11_fpToFxPTest(LOGICAL,10)@0
    excZ_x_uid11_fpToFxPTest_q <= "1" WHEN exp_x_uid9_fpToFxPTest_b = cstAllZWE_uid8_fpToFxPTest_q ELSE "0";

    -- invExcXZ_uid22_fpToFxPTest(LOGICAL,21)@0
    invExcXZ_uid22_fpToFxPTest_q <= not (excZ_x_uid11_fpToFxPTest_q);

    -- frac_x_uid10_fpToFxPTest(BITSELECT,9)@0
    frac_x_uid10_fpToFxPTest_b <= a(22 downto 0);

    -- oFracX_uid23_fpToFxPTest(BITJOIN,22)@0
    oFracX_uid23_fpToFxPTest_q <= invExcXZ_uid22_fpToFxPTest_q & frac_x_uid10_fpToFxPTest_b;

    -- zPadd_uid37_fpToFxPTest(CONSTANT,36)
    zPadd_uid37_fpToFxPTest_q <= "000000000";

    -- shifterIn_uid38_fpToFxPTest(BITJOIN,37)@0
    shifterIn_uid38_fpToFxPTest_q <= oFracX_uid23_fpToFxPTest_q & zPadd_uid37_fpToFxPTest_q;

    -- rightShiftStage0_uid63_rightShiferNoStickyOut_uid39_fpToFxPTest(MUX,62)@0
    rightShiftStage0_uid63_rightShiferNoStickyOut_uid39_fpToFxPTest_s <= rightShiftStageSel5Dto4_uid62_rightShiferNoStickyOut_uid39_fpToFxPTest_merged_bit_select_b;
    rightShiftStage0_uid63_rightShiferNoStickyOut_uid39_fpToFxPTest_combproc: PROCESS (rightShiftStage0_uid63_rightShiferNoStickyOut_uid39_fpToFxPTest_s, shifterIn_uid38_fpToFxPTest_q, rightShiftStage0Idx1_uid57_rightShiferNoStickyOut_uid39_fpToFxPTest_q, rightShiftStage0Idx2_uid60_rightShiferNoStickyOut_uid39_fpToFxPTest_q, rightShiftStage0Idx3_uid61_rightShiferNoStickyOut_uid39_fpToFxPTest_q)
    BEGIN
        CASE (rightShiftStage0_uid63_rightShiferNoStickyOut_uid39_fpToFxPTest_s) IS
            WHEN "00" => rightShiftStage0_uid63_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= shifterIn_uid38_fpToFxPTest_q;
            WHEN "01" => rightShiftStage0_uid63_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= rightShiftStage0Idx1_uid57_rightShiferNoStickyOut_uid39_fpToFxPTest_q;
            WHEN "10" => rightShiftStage0_uid63_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= rightShiftStage0Idx2_uid60_rightShiferNoStickyOut_uid39_fpToFxPTest_q;
            WHEN "11" => rightShiftStage0_uid63_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= rightShiftStage0Idx3_uid61_rightShiferNoStickyOut_uid39_fpToFxPTest_q;
            WHEN OTHERS => rightShiftStage0_uid63_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- maxShiftCst_uid34_fpToFxPTest(CONSTANT,33)
    maxShiftCst_uid34_fpToFxPTest_q <= "100001";

    -- ovfExpVal_uid31_fpToFxPTest(CONSTANT,30)
    ovfExpVal_uid31_fpToFxPTest_q <= "010011110";

    -- shiftValE_uid32_fpToFxPTest(SUB,31)@0
    shiftValE_uid32_fpToFxPTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((10 downto 9 => ovfExpVal_uid31_fpToFxPTest_q(8)) & ovfExpVal_uid31_fpToFxPTest_q));
    shiftValE_uid32_fpToFxPTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000" & exp_x_uid9_fpToFxPTest_b));
    shiftValE_uid32_fpToFxPTest_o <= STD_LOGIC_VECTOR(SIGNED(shiftValE_uid32_fpToFxPTest_a) - SIGNED(shiftValE_uid32_fpToFxPTest_b));
    shiftValE_uid32_fpToFxPTest_q <= shiftValE_uid32_fpToFxPTest_o(9 downto 0);

    -- shiftValRaw_uid33_fpToFxPTest(BITSELECT,32)@0
    shiftValRaw_uid33_fpToFxPTest_in <= shiftValE_uid32_fpToFxPTest_q(5 downto 0);
    shiftValRaw_uid33_fpToFxPTest_b <= shiftValRaw_uid33_fpToFxPTest_in(5 downto 0);

    -- shiftOutOfRange_uid35_fpToFxPTest(COMPARE,34)@0
    shiftOutOfRange_uid35_fpToFxPTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((11 downto 10 => shiftValE_uid32_fpToFxPTest_q(9)) & shiftValE_uid32_fpToFxPTest_q));
    shiftOutOfRange_uid35_fpToFxPTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000000" & maxShiftCst_uid34_fpToFxPTest_q));
    shiftOutOfRange_uid35_fpToFxPTest_o <= STD_LOGIC_VECTOR(SIGNED(shiftOutOfRange_uid35_fpToFxPTest_a) - SIGNED(shiftOutOfRange_uid35_fpToFxPTest_b));
    shiftOutOfRange_uid35_fpToFxPTest_n(0) <= not (shiftOutOfRange_uid35_fpToFxPTest_o(11));

    -- shiftVal_uid36_fpToFxPTest(MUX,35)@0
    shiftVal_uid36_fpToFxPTest_s <= shiftOutOfRange_uid35_fpToFxPTest_n;
    shiftVal_uid36_fpToFxPTest_combproc: PROCESS (shiftVal_uid36_fpToFxPTest_s, shiftValRaw_uid33_fpToFxPTest_b, maxShiftCst_uid34_fpToFxPTest_q)
    BEGIN
        CASE (shiftVal_uid36_fpToFxPTest_s) IS
            WHEN "0" => shiftVal_uid36_fpToFxPTest_q <= shiftValRaw_uid33_fpToFxPTest_b;
            WHEN "1" => shiftVal_uid36_fpToFxPTest_q <= maxShiftCst_uid34_fpToFxPTest_q;
            WHEN OTHERS => shiftVal_uid36_fpToFxPTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rightShiftStageSel5Dto4_uid62_rightShiferNoStickyOut_uid39_fpToFxPTest_merged_bit_select(BITSELECT,86)@0
    rightShiftStageSel5Dto4_uid62_rightShiferNoStickyOut_uid39_fpToFxPTest_merged_bit_select_b <= shiftVal_uid36_fpToFxPTest_q(5 downto 4);
    rightShiftStageSel5Dto4_uid62_rightShiferNoStickyOut_uid39_fpToFxPTest_merged_bit_select_c <= shiftVal_uid36_fpToFxPTest_q(3 downto 2);
    rightShiftStageSel5Dto4_uid62_rightShiferNoStickyOut_uid39_fpToFxPTest_merged_bit_select_d <= shiftVal_uid36_fpToFxPTest_q(1 downto 0);

    -- rightShiftStage1_uid74_rightShiferNoStickyOut_uid39_fpToFxPTest(MUX,73)@0 + 1
    rightShiftStage1_uid74_rightShiferNoStickyOut_uid39_fpToFxPTest_s <= rightShiftStageSel5Dto4_uid62_rightShiferNoStickyOut_uid39_fpToFxPTest_merged_bit_select_c;
    rightShiftStage1_uid74_rightShiferNoStickyOut_uid39_fpToFxPTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            rightShiftStage1_uid74_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (rightShiftStage1_uid74_rightShiferNoStickyOut_uid39_fpToFxPTest_s) IS
                WHEN "00" => rightShiftStage1_uid74_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= rightShiftStage0_uid63_rightShiferNoStickyOut_uid39_fpToFxPTest_q;
                WHEN "01" => rightShiftStage1_uid74_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= rightShiftStage1Idx1_uid66_rightShiferNoStickyOut_uid39_fpToFxPTest_q;
                WHEN "10" => rightShiftStage1_uid74_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= rightShiftStage1Idx2_uid69_rightShiferNoStickyOut_uid39_fpToFxPTest_q;
                WHEN "11" => rightShiftStage1_uid74_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= rightShiftStage1Idx3_uid72_rightShiferNoStickyOut_uid39_fpToFxPTest_q;
                WHEN OTHERS => rightShiftStage1_uid74_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- redist0_rightShiftStageSel5Dto4_uid62_rightShiferNoStickyOut_uid39_fpToFxPTest_merged_bit_select_d_1(DELAY,87)
    redist0_rightShiftStageSel5Dto4_uid62_rightShiferNoStickyOut_uid39_fpToFxPTest_merged_bit_select_d_1 : dspba_delay
    GENERIC MAP ( width => 2, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => rightShiftStageSel5Dto4_uid62_rightShiferNoStickyOut_uid39_fpToFxPTest_merged_bit_select_d, xout => redist0_rightShiftStageSel5Dto4_uid62_rightShiferNoStickyOut_uid39_fpToFxPTest_merged_bit_select_d_1_q, clk => clk, aclr => areset );

    -- rightShiftStage2_uid85_rightShiferNoStickyOut_uid39_fpToFxPTest(MUX,84)@1
    rightShiftStage2_uid85_rightShiferNoStickyOut_uid39_fpToFxPTest_s <= redist0_rightShiftStageSel5Dto4_uid62_rightShiferNoStickyOut_uid39_fpToFxPTest_merged_bit_select_d_1_q;
    rightShiftStage2_uid85_rightShiferNoStickyOut_uid39_fpToFxPTest_combproc: PROCESS (rightShiftStage2_uid85_rightShiferNoStickyOut_uid39_fpToFxPTest_s, rightShiftStage1_uid74_rightShiferNoStickyOut_uid39_fpToFxPTest_q, rightShiftStage2Idx1_uid77_rightShiferNoStickyOut_uid39_fpToFxPTest_q, rightShiftStage2Idx2_uid80_rightShiferNoStickyOut_uid39_fpToFxPTest_q, rightShiftStage2Idx3_uid83_rightShiferNoStickyOut_uid39_fpToFxPTest_q)
    BEGIN
        CASE (rightShiftStage2_uid85_rightShiferNoStickyOut_uid39_fpToFxPTest_s) IS
            WHEN "00" => rightShiftStage2_uid85_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= rightShiftStage1_uid74_rightShiferNoStickyOut_uid39_fpToFxPTest_q;
            WHEN "01" => rightShiftStage2_uid85_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= rightShiftStage2Idx1_uid77_rightShiferNoStickyOut_uid39_fpToFxPTest_q;
            WHEN "10" => rightShiftStage2_uid85_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= rightShiftStage2Idx2_uid80_rightShiferNoStickyOut_uid39_fpToFxPTest_q;
            WHEN "11" => rightShiftStage2_uid85_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= rightShiftStage2Idx3_uid83_rightShiferNoStickyOut_uid39_fpToFxPTest_q;
            WHEN OTHERS => rightShiftStage2_uid85_rightShiferNoStickyOut_uid39_fpToFxPTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- zRightShiferNoStickyOut_uid43_fpToFxPTest(BITJOIN,42)@1
    zRightShiferNoStickyOut_uid43_fpToFxPTest_q <= GND_q & rightShiftStage2_uid85_rightShiferNoStickyOut_uid39_fpToFxPTest_q;

    -- sPostRndFull_uid44_fpToFxPTest(ADD,43)@1
    sPostRndFull_uid44_fpToFxPTest_a <= STD_LOGIC_VECTOR("0" & zRightShiferNoStickyOut_uid43_fpToFxPTest_q);
    sPostRndFull_uid44_fpToFxPTest_b <= STD_LOGIC_VECTOR("0000000000000000000000000000000000" & VCC_q);
    sPostRndFull_uid44_fpToFxPTest_o <= STD_LOGIC_VECTOR(UNSIGNED(sPostRndFull_uid44_fpToFxPTest_a) + UNSIGNED(sPostRndFull_uid44_fpToFxPTest_b));
    sPostRndFull_uid44_fpToFxPTest_q <= sPostRndFull_uid44_fpToFxPTest_o(34 downto 0);

    -- sPostRnd_uid45_fpToFxPTest(BITSELECT,44)@1
    sPostRnd_uid45_fpToFxPTest_in <= sPostRndFull_uid44_fpToFxPTest_q(32 downto 0);
    sPostRnd_uid45_fpToFxPTest_b <= sPostRnd_uid45_fpToFxPTest_in(32 downto 1);

    -- signX_uid25_fpToFxPTest(BITSELECT,24)@0
    signX_uid25_fpToFxPTest_b <= STD_LOGIC_VECTOR(a(31 downto 31));

    -- redist1_signX_uid25_fpToFxPTest_b_1(DELAY,88)
    redist1_signX_uid25_fpToFxPTest_b_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => signX_uid25_fpToFxPTest_b, xout => redist1_signX_uid25_fpToFxPTest_b_1_q, clk => clk, aclr => areset );

    -- udfExpVal_uid29_fpToFxPTest(CONSTANT,28)
    udfExpVal_uid29_fpToFxPTest_q <= "01111101";

    -- udf_uid30_fpToFxPTest(COMPARE,29)@0 + 1
    udf_uid30_fpToFxPTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((10 downto 8 => udfExpVal_uid29_fpToFxPTest_q(7)) & udfExpVal_uid29_fpToFxPTest_q));
    udf_uid30_fpToFxPTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000" & exp_x_uid9_fpToFxPTest_b));
    udf_uid30_fpToFxPTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            udf_uid30_fpToFxPTest_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            udf_uid30_fpToFxPTest_o <= STD_LOGIC_VECTOR(SIGNED(udf_uid30_fpToFxPTest_a) - SIGNED(udf_uid30_fpToFxPTest_b));
        END IF;
    END PROCESS;
    udf_uid30_fpToFxPTest_n(0) <= not (udf_uid30_fpToFxPTest_o(10));

    -- sPostRndFullMSBU_uid46_fpToFxPTest(BITSELECT,45)@1
    sPostRndFullMSBU_uid46_fpToFxPTest_in <= STD_LOGIC_VECTOR(sPostRndFull_uid44_fpToFxPTest_q(33 downto 0));
    sPostRndFullMSBU_uid46_fpToFxPTest_b <= STD_LOGIC_VECTOR(sPostRndFullMSBU_uid46_fpToFxPTest_in(33 downto 33));

    -- ovfExpVal_uid26_fpToFxPTest(CONSTANT,25)
    ovfExpVal_uid26_fpToFxPTest_q <= "010011111";

    -- ovf_uid27_fpToFxPTest(COMPARE,26)@0 + 1
    ovf_uid27_fpToFxPTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000" & exp_x_uid9_fpToFxPTest_b));
    ovf_uid27_fpToFxPTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((10 downto 9 => ovfExpVal_uid26_fpToFxPTest_q(8)) & ovfExpVal_uid26_fpToFxPTest_q));
    ovf_uid27_fpToFxPTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            ovf_uid27_fpToFxPTest_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            ovf_uid27_fpToFxPTest_o <= STD_LOGIC_VECTOR(SIGNED(ovf_uid27_fpToFxPTest_a) - SIGNED(ovf_uid27_fpToFxPTest_b));
        END IF;
    END PROCESS;
    ovf_uid27_fpToFxPTest_n(0) <= not (ovf_uid27_fpToFxPTest_o(10));

    -- negOrOvf_uid28_fpToFxPTest(LOGICAL,27)@1
    negOrOvf_uid28_fpToFxPTest_q <= redist1_signX_uid25_fpToFxPTest_b_1_q or ovf_uid27_fpToFxPTest_n;

    -- cstZeroWF_uid7_fpToFxPTest(CONSTANT,6)
    cstZeroWF_uid7_fpToFxPTest_q <= "00000000000000000000000";

    -- fracXIsZero_uid13_fpToFxPTest(LOGICAL,12)@0 + 1
    fracXIsZero_uid13_fpToFxPTest_qi <= "1" WHEN cstZeroWF_uid7_fpToFxPTest_q = frac_x_uid10_fpToFxPTest_b ELSE "0";
    fracXIsZero_uid13_fpToFxPTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid13_fpToFxPTest_qi, xout => fracXIsZero_uid13_fpToFxPTest_q, clk => clk, aclr => areset );

    -- cstAllOWE_uid6_fpToFxPTest(CONSTANT,5)
    cstAllOWE_uid6_fpToFxPTest_q <= "11111111";

    -- expXIsMax_uid12_fpToFxPTest(LOGICAL,11)@0 + 1
    expXIsMax_uid12_fpToFxPTest_qi <= "1" WHEN exp_x_uid9_fpToFxPTest_b = cstAllOWE_uid6_fpToFxPTest_q ELSE "0";
    expXIsMax_uid12_fpToFxPTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => expXIsMax_uid12_fpToFxPTest_qi, xout => expXIsMax_uid12_fpToFxPTest_q, clk => clk, aclr => areset );

    -- excI_x_uid15_fpToFxPTest(LOGICAL,14)@1
    excI_x_uid15_fpToFxPTest_q <= expXIsMax_uid12_fpToFxPTest_q and fracXIsZero_uid13_fpToFxPTest_q;

    -- fracXIsNotZero_uid14_fpToFxPTest(LOGICAL,13)@1
    fracXIsNotZero_uid14_fpToFxPTest_q <= not (fracXIsZero_uid13_fpToFxPTest_q);

    -- excN_x_uid16_fpToFxPTest(LOGICAL,15)@1
    excN_x_uid16_fpToFxPTest_q <= expXIsMax_uid12_fpToFxPTest_q and fracXIsNotZero_uid14_fpToFxPTest_q;

    -- ovfPostRnd_uid47_fpToFxPTest(LOGICAL,46)@1
    ovfPostRnd_uid47_fpToFxPTest_q <= excN_x_uid16_fpToFxPTest_q or excI_x_uid15_fpToFxPTest_q or negOrOvf_uid28_fpToFxPTest_q or sPostRndFullMSBU_uid46_fpToFxPTest_b;

    -- muxSelConc_uid48_fpToFxPTest(BITJOIN,47)@1
    muxSelConc_uid48_fpToFxPTest_q <= redist1_signX_uid25_fpToFxPTest_b_1_q & udf_uid30_fpToFxPTest_n & ovfPostRnd_uid47_fpToFxPTest_q;

    -- muxSel_uid49_fpToFxPTest(LOOKUP,48)@1
    muxSel_uid49_fpToFxPTest_combproc: PROCESS (muxSelConc_uid48_fpToFxPTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (muxSelConc_uid48_fpToFxPTest_q) IS
            WHEN "000" => muxSel_uid49_fpToFxPTest_q <= "00";
            WHEN "001" => muxSel_uid49_fpToFxPTest_q <= "01";
            WHEN "010" => muxSel_uid49_fpToFxPTest_q <= "11";
            WHEN "011" => muxSel_uid49_fpToFxPTest_q <= "00";
            WHEN "100" => muxSel_uid49_fpToFxPTest_q <= "10";
            WHEN "101" => muxSel_uid49_fpToFxPTest_q <= "10";
            WHEN "110" => muxSel_uid49_fpToFxPTest_q <= "10";
            WHEN "111" => muxSel_uid49_fpToFxPTest_q <= "10";
            WHEN OTHERS => -- unreachable
                           muxSel_uid49_fpToFxPTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- VCC(CONSTANT,1)
    VCC_q <= "1";

    -- finalOut_uid51_fpToFxPTest(MUX,50)@1
    finalOut_uid51_fpToFxPTest_s <= muxSel_uid49_fpToFxPTest_q;
    finalOut_uid51_fpToFxPTest_combproc: PROCESS (finalOut_uid51_fpToFxPTest_s, sPostRnd_uid45_fpToFxPTest_b, maxPosValueU_uid40_fpToFxPTest_q, maxNegValueU_uid41_fpToFxPTest_q)
    BEGIN
        CASE (finalOut_uid51_fpToFxPTest_s) IS
            WHEN "00" => finalOut_uid51_fpToFxPTest_q <= sPostRnd_uid45_fpToFxPTest_b;
            WHEN "01" => finalOut_uid51_fpToFxPTest_q <= maxPosValueU_uid40_fpToFxPTest_q;
            WHEN "10" => finalOut_uid51_fpToFxPTest_q <= maxNegValueU_uid41_fpToFxPTest_q;
            WHEN "11" => finalOut_uid51_fpToFxPTest_q <= maxNegValueU_uid41_fpToFxPTest_q;
            WHEN OTHERS => finalOut_uid51_fpToFxPTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- xOut(GPOUT,4)@1
    q <= finalOut_uid51_fpToFxPTest_q;

END normal;
