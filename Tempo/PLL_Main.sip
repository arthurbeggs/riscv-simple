set_global_assignment -entity "PLL_Main" -library "lib_PLL_Main" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "PLL_Main" -library "lib_PLL_Main" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "PLL_Main" -library "lib_PLL_Main" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_PLL_Main" -name SPD_FILE [file join $::quartus(sip_path) "PLL_Main.spd"]

set_global_assignment -library "lib_PLL_Main" -name MISC_FILE [file join $::quartus(sip_path) "PLL_Main_sim/PLL_Main.vo"]
