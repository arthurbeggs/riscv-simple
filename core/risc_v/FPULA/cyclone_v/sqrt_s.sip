set_global_assignment -entity "sqrt_s" -library "lib_sqrt_s" -name IP_TOOL_NAME "altera_fp_functions"
set_global_assignment -entity "sqrt_s" -library "lib_sqrt_s" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "sqrt_s" -library "lib_sqrt_s" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_sqrt_s" -name SPD_FILE [file join $::quartus(sip_path) "sqrt_s.spd"]

set_global_assignment -library "lib_sqrt_s" -name MISC_FILE [file join $::quartus(sip_path) "sqrt_s_sim/sqrt_s_memoryC0_uid62_sqrtTables_lutmem.hex"]
set_global_assignment -library "lib_sqrt_s" -name MISC_FILE [file join $::quartus(sip_path) "sqrt_s_sim/sqrt_s_memoryC1_uid65_sqrtTables_lutmem.hex"]
set_global_assignment -library "lib_sqrt_s" -name MISC_FILE [file join $::quartus(sip_path) "sqrt_s_sim/sqrt_s_memoryC2_uid68_sqrtTables_lutmem.hex"]
set_global_assignment -library "lib_sqrt_s" -name MISC_FILE [file join $::quartus(sip_path) "sqrt_s_sim/sqrt_s.vo"]
