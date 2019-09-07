set_global_assignment -entity "add_sub" -library "lib_add_sub" -name IP_TOOL_NAME "altera_fp_functions"
set_global_assignment -entity "add_sub" -library "lib_add_sub" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "add_sub" -library "lib_add_sub" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_add_sub" -name SPD_FILE [file join $::quartus(sip_path) "add_sub.spd"]

set_global_assignment -library "lib_add_sub" -name MISC_FILE [file join $::quartus(sip_path) "add_sub_sim/add_sub.vo"]
