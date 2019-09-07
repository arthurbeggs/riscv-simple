set_global_assignment -entity "cvt_wu_s" -library "lib_cvt_wu_s" -name IP_TOOL_NAME "altera_fp_functions"
set_global_assignment -entity "cvt_wu_s" -library "lib_cvt_wu_s" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "cvt_wu_s" -library "lib_cvt_wu_s" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_cvt_wu_s" -name SPD_FILE [file join $::quartus(sip_path) "cvt_wu_s.spd"]

set_global_assignment -library "lib_cvt_wu_s" -name MISC_FILE [file join $::quartus(sip_path) "cvt_wu_s_sim/cvt_wu_s.vo"]
