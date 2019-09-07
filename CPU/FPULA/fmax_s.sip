set_global_assignment -entity "fmax_s" -library "lib_fmax_s" -name IP_TOOL_NAME "altera_fp_functions"
set_global_assignment -entity "fmax_s" -library "lib_fmax_s" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "fmax_s" -library "lib_fmax_s" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_fmax_s" -name SPD_FILE [file join $::quartus(sip_path) "fmax_s.spd"]

set_global_assignment -library "lib_fmax_s" -name MISC_FILE [file join $::quartus(sip_path) "fmax_s_sim/fmax_s.vo"]
