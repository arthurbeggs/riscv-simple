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

-- VHDL created from fmin_s_0002
-- VHDL created on Fri Mar 08 18:18:18 2019


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

entity fmin_s_0002 is
    port (
        a : in std_logic_vector(31 downto 0);  -- float32_m23
        b : in std_logic_vector(31 downto 0);  -- float32_m23
        q : out std_logic_vector(31 downto 0);  -- float32_m23
        clk : in std_logic;
        areset : in std_logic
    );
end fmin_s_0002;

architecture normal of fmin_s_0002 is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cstAllOWE_uid6_fpMinTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal cstZeroWF_uid7_fpMinTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal exp_x_uid9_fpMinTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal frac_x_uid10_fpMinTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal expXIsMax_uid12_fpMinTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid13_fpMinTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid14_fpMinTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_x_uid16_fpMinTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal exp_y_uid23_fpMinTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal frac_y_uid24_fpMinTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal expXIsMax_uid26_fpMinTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid27_fpMinTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid28_fpMinTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_y_uid30_fpMinTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal nanOut_uid34_fpMinTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal oneIsNaN_uid35_fpMinTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExcYN_uid37_fpMinTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal yNotNaN_uid39_fpMinTest_a : STD_LOGIC_VECTOR (31 downto 0);
    signal yNotNaN_uid39_fpMinTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal invExcXN_uid41_fpMinTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xNotNaN_uid43_fpMinTest_a : STD_LOGIC_VECTOR (31 downto 0);
    signal xNotNaN_uid43_fpMinTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal oneNaNOutput_uid44_fpMinTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal expFracX_uid47_fpMinTest_q : STD_LOGIC_VECTOR (30 downto 0);
    signal expFracY_uid51_fpMinTest_q : STD_LOGIC_VECTOR (30 downto 0);
    signal signX_uid53_fpMinTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal signY_uid54_fpMinTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal efxGTefy_uid55_fpMinTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal efxGTefy_uid55_fpMinTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal efxGTefy_uid55_fpMinTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal efxGTefy_uid55_fpMinTest_c : STD_LOGIC_VECTOR (0 downto 0);
    signal invSX_uid56_fpMinTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invEfxGTefy_uid58_fpMinTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xNegyNegYGTX_uid59_fpMinTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xPosyPosXGtY_uid60_fpMinTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xPosYNeg_uid61_fpMinTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal selX_uid62_fpMinTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal r_uid63_fpMinTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal r_uid63_fpMinTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal concOneIsNaNNaNOut_uid64_fpMinTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal fracNaN_uid65_fpMinTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal rPostNaNP_r3_uid67_fpMinTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal rPostNaN_uid72_fpMinTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rPostNaN_uid72_fpMinTest_q : STD_LOGIC_VECTOR (31 downto 0);

begin


    -- frac_y_uid24_fpMinTest(BITSELECT,23)@0
    frac_y_uid24_fpMinTest_b <= b(22 downto 0);

    -- cstZeroWF_uid7_fpMinTest(CONSTANT,6)
    cstZeroWF_uid7_fpMinTest_q <= "00000000000000000000000";

    -- fracXIsZero_uid27_fpMinTest(LOGICAL,26)@0
    fracXIsZero_uid27_fpMinTest_q <= "1" WHEN cstZeroWF_uid7_fpMinTest_q = frac_y_uid24_fpMinTest_b ELSE "0";

    -- fracXIsNotZero_uid28_fpMinTest(LOGICAL,27)@0
    fracXIsNotZero_uid28_fpMinTest_q <= not (fracXIsZero_uid27_fpMinTest_q);

    -- cstAllOWE_uid6_fpMinTest(CONSTANT,5)
    cstAllOWE_uid6_fpMinTest_q <= "11111111";

    -- exp_y_uid23_fpMinTest(BITSELECT,22)@0
    exp_y_uid23_fpMinTest_b <= b(30 downto 23);

    -- expXIsMax_uid26_fpMinTest(LOGICAL,25)@0
    expXIsMax_uid26_fpMinTest_q <= "1" WHEN exp_y_uid23_fpMinTest_b = cstAllOWE_uid6_fpMinTest_q ELSE "0";

    -- excN_y_uid30_fpMinTest(LOGICAL,29)@0
    excN_y_uid30_fpMinTest_q <= expXIsMax_uid26_fpMinTest_q and fracXIsNotZero_uid28_fpMinTest_q;

    -- invExcYN_uid37_fpMinTest(LOGICAL,36)@0
    invExcYN_uid37_fpMinTest_q <= not (excN_y_uid30_fpMinTest_q);

    -- yNotNaN_uid39_fpMinTest(LOGICAL,38)@0
    yNotNaN_uid39_fpMinTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((31 downto 1 => invExcYN_uid37_fpMinTest_q(0)) & invExcYN_uid37_fpMinTest_q));
    yNotNaN_uid39_fpMinTest_q <= yNotNaN_uid39_fpMinTest_a and b;

    -- frac_x_uid10_fpMinTest(BITSELECT,9)@0
    frac_x_uid10_fpMinTest_b <= a(22 downto 0);

    -- fracXIsZero_uid13_fpMinTest(LOGICAL,12)@0
    fracXIsZero_uid13_fpMinTest_q <= "1" WHEN cstZeroWF_uid7_fpMinTest_q = frac_x_uid10_fpMinTest_b ELSE "0";

    -- fracXIsNotZero_uid14_fpMinTest(LOGICAL,13)@0
    fracXIsNotZero_uid14_fpMinTest_q <= not (fracXIsZero_uid13_fpMinTest_q);

    -- exp_x_uid9_fpMinTest(BITSELECT,8)@0
    exp_x_uid9_fpMinTest_b <= a(30 downto 23);

    -- expXIsMax_uid12_fpMinTest(LOGICAL,11)@0
    expXIsMax_uid12_fpMinTest_q <= "1" WHEN exp_x_uid9_fpMinTest_b = cstAllOWE_uid6_fpMinTest_q ELSE "0";

    -- excN_x_uid16_fpMinTest(LOGICAL,15)@0
    excN_x_uid16_fpMinTest_q <= expXIsMax_uid12_fpMinTest_q and fracXIsNotZero_uid14_fpMinTest_q;

    -- invExcXN_uid41_fpMinTest(LOGICAL,40)@0
    invExcXN_uid41_fpMinTest_q <= not (excN_x_uid16_fpMinTest_q);

    -- xNotNaN_uid43_fpMinTest(LOGICAL,42)@0
    xNotNaN_uid43_fpMinTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((31 downto 1 => invExcXN_uid41_fpMinTest_q(0)) & invExcXN_uid41_fpMinTest_q));
    xNotNaN_uid43_fpMinTest_q <= xNotNaN_uid43_fpMinTest_a and a;

    -- oneNaNOutput_uid44_fpMinTest(LOGICAL,43)@0
    oneNaNOutput_uid44_fpMinTest_q <= xNotNaN_uid43_fpMinTest_q or yNotNaN_uid39_fpMinTest_q;

    -- GND(CONSTANT,0)
    GND_q <= "0";

    -- fracNaN_uid65_fpMinTest(CONSTANT,64)
    fracNaN_uid65_fpMinTest_q <= "00000000000000000000001";

    -- rPostNaNP_r3_uid67_fpMinTest(BITJOIN,66)@0
    rPostNaNP_r3_uid67_fpMinTest_q <= GND_q & cstAllOWE_uid6_fpMinTest_q & fracNaN_uid65_fpMinTest_q;

    -- expFracX_uid47_fpMinTest(BITJOIN,46)@0
    expFracX_uid47_fpMinTest_q <= exp_x_uid9_fpMinTest_b & frac_x_uid10_fpMinTest_b;

    -- expFracY_uid51_fpMinTest(BITJOIN,50)@0
    expFracY_uid51_fpMinTest_q <= exp_y_uid23_fpMinTest_b & frac_y_uid24_fpMinTest_b;

    -- efxGTefy_uid55_fpMinTest(COMPARE,54)@0
    efxGTefy_uid55_fpMinTest_a <= STD_LOGIC_VECTOR("00" & expFracY_uid51_fpMinTest_q);
    efxGTefy_uid55_fpMinTest_b <= STD_LOGIC_VECTOR("00" & expFracX_uid47_fpMinTest_q);
    efxGTefy_uid55_fpMinTest_o <= STD_LOGIC_VECTOR(UNSIGNED(efxGTefy_uid55_fpMinTest_a) - UNSIGNED(efxGTefy_uid55_fpMinTest_b));
    efxGTefy_uid55_fpMinTest_c(0) <= efxGTefy_uid55_fpMinTest_o(32);

    -- invEfxGTefy_uid58_fpMinTest(LOGICAL,57)@0
    invEfxGTefy_uid58_fpMinTest_q <= not (efxGTefy_uid55_fpMinTest_c);

    -- signY_uid54_fpMinTest(BITSELECT,53)@0
    signY_uid54_fpMinTest_b <= STD_LOGIC_VECTOR(b(31 downto 31));

    -- signX_uid53_fpMinTest(BITSELECT,52)@0
    signX_uid53_fpMinTest_b <= STD_LOGIC_VECTOR(a(31 downto 31));

    -- xNegyNegYGTX_uid59_fpMinTest(LOGICAL,58)@0
    xNegyNegYGTX_uid59_fpMinTest_q <= signX_uid53_fpMinTest_b and signY_uid54_fpMinTest_b and invEfxGTefy_uid58_fpMinTest_q;

    -- invSX_uid56_fpMinTest(LOGICAL,55)@0
    invSX_uid56_fpMinTest_q <= not (signX_uid53_fpMinTest_b);

    -- xPosyPosXGtY_uid60_fpMinTest(LOGICAL,59)@0
    xPosyPosXGtY_uid60_fpMinTest_q <= invSX_uid56_fpMinTest_q and invSX_uid56_fpMinTest_q and efxGTefy_uid55_fpMinTest_c;

    -- xPosYNeg_uid61_fpMinTest(LOGICAL,60)@0
    xPosYNeg_uid61_fpMinTest_q <= invSX_uid56_fpMinTest_q and signY_uid54_fpMinTest_b;

    -- selX_uid62_fpMinTest(LOGICAL,61)@0
    selX_uid62_fpMinTest_q <= xPosYNeg_uid61_fpMinTest_q or xPosyPosXGtY_uid60_fpMinTest_q or xNegyNegYGTX_uid59_fpMinTest_q;

    -- r_uid63_fpMinTest(MUX,62)@0
    r_uid63_fpMinTest_s <= selX_uid62_fpMinTest_q;
    r_uid63_fpMinTest_combproc: PROCESS (r_uid63_fpMinTest_s, a, b)
    BEGIN
        CASE (r_uid63_fpMinTest_s) IS
            WHEN "0" => r_uid63_fpMinTest_q <= a;
            WHEN "1" => r_uid63_fpMinTest_q <= b;
            WHEN OTHERS => r_uid63_fpMinTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- oneIsNaN_uid35_fpMinTest(LOGICAL,34)@0
    oneIsNaN_uid35_fpMinTest_q <= excN_x_uid16_fpMinTest_q xor excN_y_uid30_fpMinTest_q;

    -- nanOut_uid34_fpMinTest(LOGICAL,33)@0
    nanOut_uid34_fpMinTest_q <= excN_x_uid16_fpMinTest_q and excN_y_uid30_fpMinTest_q;

    -- concOneIsNaNNaNOut_uid64_fpMinTest(BITJOIN,63)@0
    concOneIsNaNNaNOut_uid64_fpMinTest_q <= oneIsNaN_uid35_fpMinTest_q & nanOut_uid34_fpMinTest_q;

    -- VCC(CONSTANT,1)
    VCC_q <= "1";

    -- rPostNaN_uid72_fpMinTest(MUX,71)@0
    rPostNaN_uid72_fpMinTest_s <= concOneIsNaNNaNOut_uid64_fpMinTest_q;
    rPostNaN_uid72_fpMinTest_combproc: PROCESS (rPostNaN_uid72_fpMinTest_s, r_uid63_fpMinTest_q, rPostNaNP_r3_uid67_fpMinTest_q, oneNaNOutput_uid44_fpMinTest_q)
    BEGIN
        CASE (rPostNaN_uid72_fpMinTest_s) IS
            WHEN "00" => rPostNaN_uid72_fpMinTest_q <= r_uid63_fpMinTest_q;
            WHEN "01" => rPostNaN_uid72_fpMinTest_q <= rPostNaNP_r3_uid67_fpMinTest_q;
            WHEN "10" => rPostNaN_uid72_fpMinTest_q <= oneNaNOutput_uid44_fpMinTest_q;
            WHEN "11" => rPostNaN_uid72_fpMinTest_q <= rPostNaNP_r3_uid67_fpMinTest_q;
            WHEN OTHERS => rPostNaN_uid72_fpMinTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- xOut(GPOUT,4)@0
    q <= rPostNaN_uid72_fpMinTest_q;

END normal;
