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

-- VHDL created from fmax_s_0002
-- VHDL created on Fri Mar 08 18:17:43 2019


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

entity fmax_s_0002 is
    port (
        a : in std_logic_vector(31 downto 0);  -- float32_m23
        b : in std_logic_vector(31 downto 0);  -- float32_m23
        q : out std_logic_vector(31 downto 0);  -- float32_m23
        clk : in std_logic;
        areset : in std_logic
    );
end fmax_s_0002;

architecture normal of fmax_s_0002 is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cstAllOWE_uid6_fpMaxTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal cstZeroWF_uid7_fpMaxTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal exp_x_uid9_fpMaxTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal frac_x_uid10_fpMaxTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal expXIsMax_uid12_fpMaxTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid13_fpMaxTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid14_fpMaxTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_x_uid16_fpMaxTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal exp_y_uid23_fpMaxTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal frac_y_uid24_fpMaxTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal expXIsMax_uid26_fpMaxTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid27_fpMaxTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid28_fpMaxTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_y_uid30_fpMaxTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal nanOut_uid34_fpMaxTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal oneIsNaN_uid35_fpMaxTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExcYN_uid37_fpMaxTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal yNotNaN_uid39_fpMaxTest_a : STD_LOGIC_VECTOR (31 downto 0);
    signal yNotNaN_uid39_fpMaxTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal invExcXN_uid41_fpMaxTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xNotNaN_uid43_fpMaxTest_a : STD_LOGIC_VECTOR (31 downto 0);
    signal xNotNaN_uid43_fpMaxTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal oneNaNOutput_uid44_fpMaxTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal expFracX_uid47_fpMaxTest_q : STD_LOGIC_VECTOR (30 downto 0);
    signal expFracY_uid51_fpMaxTest_q : STD_LOGIC_VECTOR (30 downto 0);
    signal signX_uid53_fpMaxTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal signY_uid54_fpMaxTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal efxGTefy_uid55_fpMaxTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal efxGTefy_uid55_fpMaxTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal efxGTefy_uid55_fpMaxTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal efxGTefy_uid55_fpMaxTest_c : STD_LOGIC_VECTOR (0 downto 0);
    signal invSX_uid56_fpMaxTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invEfxGTefy_uid58_fpMaxTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xNegyNegYGTX_uid59_fpMaxTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xPosyPosXGtY_uid60_fpMaxTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xPosYNeg_uid61_fpMaxTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal selX_uid62_fpMaxTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal r_uid63_fpMaxTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal r_uid63_fpMaxTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal concOneIsNaNNaNOut_uid64_fpMaxTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal fracNaN_uid65_fpMaxTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal rPostNaNP_r3_uid67_fpMaxTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal rPostNaN_uid72_fpMaxTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rPostNaN_uid72_fpMaxTest_q : STD_LOGIC_VECTOR (31 downto 0);

begin


    -- frac_y_uid24_fpMaxTest(BITSELECT,23)@0
    frac_y_uid24_fpMaxTest_b <= b(22 downto 0);

    -- cstZeroWF_uid7_fpMaxTest(CONSTANT,6)
    cstZeroWF_uid7_fpMaxTest_q <= "00000000000000000000000";

    -- fracXIsZero_uid27_fpMaxTest(LOGICAL,26)@0
    fracXIsZero_uid27_fpMaxTest_q <= "1" WHEN cstZeroWF_uid7_fpMaxTest_q = frac_y_uid24_fpMaxTest_b ELSE "0";

    -- fracXIsNotZero_uid28_fpMaxTest(LOGICAL,27)@0
    fracXIsNotZero_uid28_fpMaxTest_q <= not (fracXIsZero_uid27_fpMaxTest_q);

    -- cstAllOWE_uid6_fpMaxTest(CONSTANT,5)
    cstAllOWE_uid6_fpMaxTest_q <= "11111111";

    -- exp_y_uid23_fpMaxTest(BITSELECT,22)@0
    exp_y_uid23_fpMaxTest_b <= b(30 downto 23);

    -- expXIsMax_uid26_fpMaxTest(LOGICAL,25)@0
    expXIsMax_uid26_fpMaxTest_q <= "1" WHEN exp_y_uid23_fpMaxTest_b = cstAllOWE_uid6_fpMaxTest_q ELSE "0";

    -- excN_y_uid30_fpMaxTest(LOGICAL,29)@0
    excN_y_uid30_fpMaxTest_q <= expXIsMax_uid26_fpMaxTest_q and fracXIsNotZero_uid28_fpMaxTest_q;

    -- invExcYN_uid37_fpMaxTest(LOGICAL,36)@0
    invExcYN_uid37_fpMaxTest_q <= not (excN_y_uid30_fpMaxTest_q);

    -- yNotNaN_uid39_fpMaxTest(LOGICAL,38)@0
    yNotNaN_uid39_fpMaxTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((31 downto 1 => invExcYN_uid37_fpMaxTest_q(0)) & invExcYN_uid37_fpMaxTest_q));
    yNotNaN_uid39_fpMaxTest_q <= yNotNaN_uid39_fpMaxTest_a and b;

    -- frac_x_uid10_fpMaxTest(BITSELECT,9)@0
    frac_x_uid10_fpMaxTest_b <= a(22 downto 0);

    -- fracXIsZero_uid13_fpMaxTest(LOGICAL,12)@0
    fracXIsZero_uid13_fpMaxTest_q <= "1" WHEN cstZeroWF_uid7_fpMaxTest_q = frac_x_uid10_fpMaxTest_b ELSE "0";

    -- fracXIsNotZero_uid14_fpMaxTest(LOGICAL,13)@0
    fracXIsNotZero_uid14_fpMaxTest_q <= not (fracXIsZero_uid13_fpMaxTest_q);

    -- exp_x_uid9_fpMaxTest(BITSELECT,8)@0
    exp_x_uid9_fpMaxTest_b <= a(30 downto 23);

    -- expXIsMax_uid12_fpMaxTest(LOGICAL,11)@0
    expXIsMax_uid12_fpMaxTest_q <= "1" WHEN exp_x_uid9_fpMaxTest_b = cstAllOWE_uid6_fpMaxTest_q ELSE "0";

    -- excN_x_uid16_fpMaxTest(LOGICAL,15)@0
    excN_x_uid16_fpMaxTest_q <= expXIsMax_uid12_fpMaxTest_q and fracXIsNotZero_uid14_fpMaxTest_q;

    -- invExcXN_uid41_fpMaxTest(LOGICAL,40)@0
    invExcXN_uid41_fpMaxTest_q <= not (excN_x_uid16_fpMaxTest_q);

    -- xNotNaN_uid43_fpMaxTest(LOGICAL,42)@0
    xNotNaN_uid43_fpMaxTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((31 downto 1 => invExcXN_uid41_fpMaxTest_q(0)) & invExcXN_uid41_fpMaxTest_q));
    xNotNaN_uid43_fpMaxTest_q <= xNotNaN_uid43_fpMaxTest_a and a;

    -- oneNaNOutput_uid44_fpMaxTest(LOGICAL,43)@0
    oneNaNOutput_uid44_fpMaxTest_q <= xNotNaN_uid43_fpMaxTest_q or yNotNaN_uid39_fpMaxTest_q;

    -- GND(CONSTANT,0)
    GND_q <= "0";

    -- fracNaN_uid65_fpMaxTest(CONSTANT,64)
    fracNaN_uid65_fpMaxTest_q <= "00000000000000000000001";

    -- rPostNaNP_r3_uid67_fpMaxTest(BITJOIN,66)@0
    rPostNaNP_r3_uid67_fpMaxTest_q <= GND_q & cstAllOWE_uid6_fpMaxTest_q & fracNaN_uid65_fpMaxTest_q;

    -- expFracX_uid47_fpMaxTest(BITJOIN,46)@0
    expFracX_uid47_fpMaxTest_q <= exp_x_uid9_fpMaxTest_b & frac_x_uid10_fpMaxTest_b;

    -- expFracY_uid51_fpMaxTest(BITJOIN,50)@0
    expFracY_uid51_fpMaxTest_q <= exp_y_uid23_fpMaxTest_b & frac_y_uid24_fpMaxTest_b;

    -- efxGTefy_uid55_fpMaxTest(COMPARE,54)@0
    efxGTefy_uid55_fpMaxTest_a <= STD_LOGIC_VECTOR("00" & expFracY_uid51_fpMaxTest_q);
    efxGTefy_uid55_fpMaxTest_b <= STD_LOGIC_VECTOR("00" & expFracX_uid47_fpMaxTest_q);
    efxGTefy_uid55_fpMaxTest_o <= STD_LOGIC_VECTOR(UNSIGNED(efxGTefy_uid55_fpMaxTest_a) - UNSIGNED(efxGTefy_uid55_fpMaxTest_b));
    efxGTefy_uid55_fpMaxTest_c(0) <= efxGTefy_uid55_fpMaxTest_o(32);

    -- invEfxGTefy_uid58_fpMaxTest(LOGICAL,57)@0
    invEfxGTefy_uid58_fpMaxTest_q <= not (efxGTefy_uid55_fpMaxTest_c);

    -- signY_uid54_fpMaxTest(BITSELECT,53)@0
    signY_uid54_fpMaxTest_b <= STD_LOGIC_VECTOR(b(31 downto 31));

    -- signX_uid53_fpMaxTest(BITSELECT,52)@0
    signX_uid53_fpMaxTest_b <= STD_LOGIC_VECTOR(a(31 downto 31));

    -- xNegyNegYGTX_uid59_fpMaxTest(LOGICAL,58)@0
    xNegyNegYGTX_uid59_fpMaxTest_q <= signX_uid53_fpMaxTest_b and signY_uid54_fpMaxTest_b and invEfxGTefy_uid58_fpMaxTest_q;

    -- invSX_uid56_fpMaxTest(LOGICAL,55)@0
    invSX_uid56_fpMaxTest_q <= not (signX_uid53_fpMaxTest_b);

    -- xPosyPosXGtY_uid60_fpMaxTest(LOGICAL,59)@0
    xPosyPosXGtY_uid60_fpMaxTest_q <= invSX_uid56_fpMaxTest_q and invSX_uid56_fpMaxTest_q and efxGTefy_uid55_fpMaxTest_c;

    -- xPosYNeg_uid61_fpMaxTest(LOGICAL,60)@0
    xPosYNeg_uid61_fpMaxTest_q <= invSX_uid56_fpMaxTest_q and signY_uid54_fpMaxTest_b;

    -- selX_uid62_fpMaxTest(LOGICAL,61)@0
    selX_uid62_fpMaxTest_q <= xPosYNeg_uid61_fpMaxTest_q or xPosyPosXGtY_uid60_fpMaxTest_q or xNegyNegYGTX_uid59_fpMaxTest_q;

    -- r_uid63_fpMaxTest(MUX,62)@0
    r_uid63_fpMaxTest_s <= selX_uid62_fpMaxTest_q;
    r_uid63_fpMaxTest_combproc: PROCESS (r_uid63_fpMaxTest_s, b, a)
    BEGIN
        CASE (r_uid63_fpMaxTest_s) IS
            WHEN "0" => r_uid63_fpMaxTest_q <= b;
            WHEN "1" => r_uid63_fpMaxTest_q <= a;
            WHEN OTHERS => r_uid63_fpMaxTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- oneIsNaN_uid35_fpMaxTest(LOGICAL,34)@0
    oneIsNaN_uid35_fpMaxTest_q <= excN_x_uid16_fpMaxTest_q xor excN_y_uid30_fpMaxTest_q;

    -- nanOut_uid34_fpMaxTest(LOGICAL,33)@0
    nanOut_uid34_fpMaxTest_q <= excN_x_uid16_fpMaxTest_q and excN_y_uid30_fpMaxTest_q;

    -- concOneIsNaNNaNOut_uid64_fpMaxTest(BITJOIN,63)@0
    concOneIsNaNNaNOut_uid64_fpMaxTest_q <= oneIsNaN_uid35_fpMaxTest_q & nanOut_uid34_fpMaxTest_q;

    -- VCC(CONSTANT,1)
    VCC_q <= "1";

    -- rPostNaN_uid72_fpMaxTest(MUX,71)@0
    rPostNaN_uid72_fpMaxTest_s <= concOneIsNaNNaNOut_uid64_fpMaxTest_q;
    rPostNaN_uid72_fpMaxTest_combproc: PROCESS (rPostNaN_uid72_fpMaxTest_s, r_uid63_fpMaxTest_q, rPostNaNP_r3_uid67_fpMaxTest_q, oneNaNOutput_uid44_fpMaxTest_q)
    BEGIN
        CASE (rPostNaN_uid72_fpMaxTest_s) IS
            WHEN "00" => rPostNaN_uid72_fpMaxTest_q <= r_uid63_fpMaxTest_q;
            WHEN "01" => rPostNaN_uid72_fpMaxTest_q <= rPostNaNP_r3_uid67_fpMaxTest_q;
            WHEN "10" => rPostNaN_uid72_fpMaxTest_q <= oneNaNOutput_uid44_fpMaxTest_q;
            WHEN "11" => rPostNaN_uid72_fpMaxTest_q <= rPostNaNP_r3_uid67_fpMaxTest_q;
            WHEN OTHERS => rPostNaN_uid72_fpMaxTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- xOut(GPOUT,4)@0
    q <= rPostNaN_uid72_fpMaxTest_q;

END normal;
