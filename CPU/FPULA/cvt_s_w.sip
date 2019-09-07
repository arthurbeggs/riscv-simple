set_global_assignment -entity "cvt_s_w" -library "lib_cvt_s_w" -name IP_TOOL_NAME "altera_fp_functions"
set_global_assignment -entity "cvt_s_w" -library "lib_cvt_s_w" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "cvt_s_w" -library "lib_cvt_s_w" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_cvt_s_w" -name SPD_FILE [file join $::quartus(sip_path) "cvt_s_w.spd"]

set_global_assignment -library "lib_cvt_s_w" -name MISC_FILE [file join $::quartus(sip_path) "cvt_s_w_sim/cvt_s_w.vo"]
