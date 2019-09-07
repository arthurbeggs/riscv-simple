set_global_assignment -entity "mul_s" -library "lib_mul_s" -name IP_TOOL_NAME "altera_fp_functions"
set_global_assignment -entity "mul_s" -library "lib_mul_s" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "mul_s" -library "lib_mul_s" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_mul_s" -name SPD_FILE [file join $::quartus(sip_path) "mul_s.spd"]

set_global_assignment -library "lib_mul_s" -name MISC_FILE [file join $::quartus(sip_path) "mul_s_sim/mul_s.vo"]
