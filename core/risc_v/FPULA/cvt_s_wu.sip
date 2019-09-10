set_global_assignment -entity "cvt_s_wu" -library "lib_cvt_s_wu" -name IP_TOOL_NAME "altera_fp_functions"
set_global_assignment -entity "cvt_s_wu" -library "lib_cvt_s_wu" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "cvt_s_wu" -library "lib_cvt_s_wu" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_cvt_s_wu" -name SPD_FILE [file join $::quartus(sip_path) "cvt_s_wu.spd"]

set_global_assignment -library "lib_cvt_s_wu" -name MISC_FILE [file join $::quartus(sip_path) "cvt_s_wu_sim/cvt_s_wu.vo"]
