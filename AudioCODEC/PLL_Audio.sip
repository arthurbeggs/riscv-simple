set_global_assignment -entity "PLL_Audio" -library "lib_PLL_Audio" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "PLL_Audio" -library "lib_PLL_Audio" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "PLL_Audio" -library "lib_PLL_Audio" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_PLL_Audio" -name SPD_FILE [file join $::quartus(sip_path) "PLL_Audio.spd"]

set_global_assignment -library "lib_PLL_Audio" -name MISC_FILE [file join $::quartus(sip_path) "PLL_Audio_sim/PLL_Audio.vo"]
