set_global_assignment -entity "div_s" -library "lib_div_s" -name IP_TOOL_NAME "altera_fp_functions"
set_global_assignment -entity "div_s" -library "lib_div_s" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "div_s" -library "lib_div_s" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_div_s" -name SPD_FILE [file join $::quartus(sip_path) "div_s.spd"]

set_global_assignment -library "lib_div_s" -name MISC_FILE [file join $::quartus(sip_path) "div_s_sim/div_s_memoryC0_uid112_invTables_lutmem.hex"]
set_global_assignment -library "lib_div_s" -name MISC_FILE [file join $::quartus(sip_path) "div_s_sim/div_s_memoryC0_uid113_invTables_lutmem.hex"]
set_global_assignment -library "lib_div_s" -name MISC_FILE [file join $::quartus(sip_path) "div_s_sim/div_s_memoryC1_uid116_invTables_lutmem.hex"]
set_global_assignment -library "lib_div_s" -name MISC_FILE [file join $::quartus(sip_path) "div_s_sim/div_s_memoryC2_uid120_invTables_lutmem.hex"]
set_global_assignment -library "lib_div_s" -name MISC_FILE [file join $::quartus(sip_path) "div_s_sim/div_s.vo"]
