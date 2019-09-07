set_global_assignment -entity "cvt_w_s" -library "lib_cvt_w_s" -name IP_TOOL_NAME "altera_fp_functions"
set_global_assignment -entity "cvt_w_s" -library "lib_cvt_w_s" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "cvt_w_s" -library "lib_cvt_w_s" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_cvt_w_s" -name SPD_FILE [file join $::quartus(sip_path) "cvt_w_s.spd"]

set_global_assignment -library "lib_cvt_w_s" -name MISC_FILE [file join $::quartus(sip_path) "cvt_w_s_sim/cvt_w_s.vo"]
