transcript on
if {[file exists cvt_s_w]} {
	vdel -lib cvt_s_w -all
}
vlib cvt_s_w
vmap cvt_s_w cvt_s_w
if {[file exists pll]} {
	vdel -lib pll -all
}
vlib pll
vmap pll pll
if {[file exists add_sub]} {
	vdel -lib add_sub -all
}
vlib add_sub
vmap add_sub add_sub
if {[file exists cvt_s_wu]} {
	vdel -lib cvt_s_wu -all
}
vlib cvt_s_wu
vmap cvt_s_wu cvt_s_wu
if {[file exists cvt_w_s]} {
	vdel -lib cvt_w_s -all
}
vlib cvt_w_s
vmap cvt_w_s cvt_w_s
if {[file exists cvt_wu_s]} {
	vdel -lib cvt_wu_s -all
}
vlib cvt_wu_s
vmap cvt_wu_s cvt_wu_s
if {[file exists div_s]} {
	vdel -lib div_s -all
}
vlib div_s
vmap div_s div_s
if {[file exists fmin_s]} {
	vdel -lib fmin_s -all
}
vlib fmin_s
vmap fmin_s fmin_s
if {[file exists fmax_s]} {
	vdel -lib fmax_s -all
}
vlib fmax_s
vmap fmax_s fmax_s
if {[file exists mul_s]} {
	vdel -lib mul_s -all
}
vlib mul_s
vmap mul_s mul_s
if {[file exists sqrt_s]} {
	vdel -lib sqrt_s -all
}
vlib sqrt_s
vmap sqrt_s sqrt_s
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

# Copia arquivos de inicialização de memória para a pasta de simulação
file copy -force -- ../../core/default_data.mif ./
file copy -force -- ../../core/default_framebuffer.mif ./
file copy -force -- ../../core/default_text.mif ./

# Copia tabelas de inicialização de memória para a pasta de simulação
file copy -force -- ../../core/risc_v/FPULA/cyclone_v/div_s_sim/div_s_memoryC0_uid112_invTables_lutmem.hex  ./
file copy -force -- ../../core/risc_v/FPULA/cyclone_v/div_s_sim/div_s_memoryC0_uid113_invTables_lutmem.hex  ./
file copy -force -- ../../core/risc_v/FPULA/cyclone_v/div_s_sim/div_s_memoryC1_uid116_invTables_lutmem.hex  ./
file copy -force -- ../../core/risc_v/FPULA/cyclone_v/div_s_sim/div_s_memoryC2_uid120_invTables_lutmem.hex  ./
file copy -force -- ../../core/risc_v/FPULA/cyclone_v/sqrt_s_sim/sqrt_s_memoryC0_uid62_sqrtTables_lutmem.hex  ./
file copy -force -- ../../core/risc_v/FPULA/cyclone_v/sqrt_s_sim/sqrt_s_memoryC1_uid65_sqrtTables_lutmem.hex  ./
file copy -force -- ../../core/risc_v/FPULA/cyclone_v/sqrt_s_sim/sqrt_s_memoryC2_uid68_sqrtTables_lutmem.hex  ./


vlog -sv -work work         +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/cvt_s_w_sim/cvt_s_w.vo}
vlog -sv -work cvt_s_w      +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/cvt_s_w.v}
vlog -sv -work work         +incdir+../../core/clock/cyclone_v          {../../core/clock/cyclone_v/pll_sim/pll.vo}
vlog -sv -work pll          +incdir+../../core/clock/cyclone_v          {../../core/clock/cyclone_v/pll.v}
vlog -sv -work work         +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/add_sub_sim/add_sub.vo}
vlog -sv -work add_sub      +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/add_sub.v}
vlog -sv -work work         +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/cvt_s_wu_sim/cvt_s_wu.vo}
vlog -sv -work cvt_s_wu     +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/cvt_s_wu.v}
vlog -sv -work work         +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/cvt_w_s_sim/cvt_w_s.vo}
vlog -sv -work cvt_w_s      +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/cvt_w_s.v}
vlog -sv -work work         +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/cvt_wu_s_sim/cvt_wu_s.vo}
vlog -sv -work cvt_wu_s     +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/cvt_wu_s.v}
vlog -sv -work work         +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/div_s_sim/div_s.vo}
vlog -sv -work div_s        +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/div_s.v}
vlog -sv -work work         +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/fmin_s_sim/fmin_s.vo}
vlog -sv -work fmin_s       +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/fmin_s.v}
vlog -sv -work work         +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/fmax_s_sim/fmax_s.vo}
vlog -sv -work fmax_s       +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/fmax_s.v}
vlog -sv -work work         +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/mul_s_sim/mul_s.vo}
vlog -sv -work mul_s        +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/mul_s.v}
vlog -sv -work work         +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/sqrt_s_sim/sqrt_s.vo}
vlog -sv -work sqrt_s       +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/sqrt_s.v}

vlog -sv -work work +define+SIMULATION +incdir+../../core {../../core/config.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/memory/cyclone_v {../../core/memory/cyclone_v/breakpoint_memory.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/memory/cyclone_v {../../core/memory/cyclone_v/framebuffer_memory.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/memory/cyclone_v {../../core/memory/cyclone_v/data_memory.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/memory/cyclone_v {../../core/memory/cyclone_v/text_memory.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v/FPULA/cyclone_v {../../core/risc_v/FPULA/cyclone_v/comp_s.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/audio_codec {../../core/peripherals/audio_codec/I2C_Controller.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/audio_codec {../../core/peripherals/audio_codec/I2C_AV_Config.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/audio_codec {../../core/peripherals/audio_codec/audio_converter.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/audio_codec {../../core/peripherals/audio_codec/audio_clock.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/audio_codec {../../core/peripherals/audio_codec/reset_delay.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/lfsr {../../core/peripherals/lfsr/LFSR_word.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/ps2 {../../core/peripherals/ps2/scan2ascii.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/ps2 {../../core/peripherals/ps2/keyscan.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/ps2 {../../core/peripherals/ps2/keyboard.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/rs232 {../../core/peripherals/rs232/async.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core {../../core/fpga_top.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/clock {../../core/clock/clock_interface.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/clock {../../core/clock/clock_divider.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/clock {../../core/clock/clock_counters.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/clock {../../core/clock/clock_control.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/clock {../../core/clock/breakpoint_interface.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/clock {../../core/clock/rtc_interface.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/memory {../../core/memory/MemStore.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/memory {../../core/memory/Memory_Interface.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/memory {../../core/memory/MemLoad.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/memory {../../core/memory/framebuffer_interface.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/Registers.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/ImmGen.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/FRegisters.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/ExceptionControl.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/Datapath_MULTI.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/CSRegisters.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/CPU.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/Control_MULTI.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/BranchControl.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/ALU.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v/FPULA {../../core/risc_v/FPULA/FPALU.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/audio_codec {../../core/peripherals/audio_codec/AudioCODEC_Interface.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/lfsr {../../core/peripherals/lfsr/lfsr_interface.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/ps2 {../../core/peripherals/ps2/TecladoPS2_Interface.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/ps2 {../../core/peripherals/ps2/oneshot.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/rs232 {../../core/peripherals/rs232/RS232_Interface.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/video {../../core/peripherals/video/video_interface.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/video {../../core/peripherals/video/video_compositor.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/video {../../core/peripherals/video/vga_driver.v}
vlog -sv -work work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/video {../../core/peripherals/video/font.v}

vlog -sv -work pll  +incdir+../../core/clock/cyclone_v/pll {../../core/clock/cyclone_v/pll/pll_0002.v}
vcom -93 -work add_sub {../../core/risc_v/FPULA/cyclone_v/add_sub/dspba_library_package.vhd}
vcom -93 -work cvt_s_w {../../core/risc_v/FPULA/cyclone_v/cvt_s_w/dspba_library_package.vhd}
vcom -93 -work cvt_s_wu {../../core/risc_v/FPULA/cyclone_v/cvt_s_wu/dspba_library_package.vhd}
vcom -93 -work cvt_w_s {../../core/risc_v/FPULA/cyclone_v/cvt_w_s/dspba_library_package.vhd}
vcom -93 -work cvt_wu_s {../../core/risc_v/FPULA/cyclone_v/cvt_wu_s/dspba_library_package.vhd}
vcom -93 -work div_s {../../core/risc_v/FPULA/cyclone_v/div_s/dspba_library_package.vhd}
vcom -93 -work fmin_s {../../core/risc_v/FPULA/cyclone_v/fmin_s/dspba_library_package.vhd}
vcom -93 -work fmax_s {../../core/risc_v/FPULA/cyclone_v/fmax_s/dspba_library_package.vhd}
vcom -93 -work mul_s {../../core/risc_v/FPULA/cyclone_v/mul_s/dspba_library_package.vhd}
vcom -93 -work sqrt_s {../../core/risc_v/FPULA/cyclone_v/sqrt_s/dspba_library_package.vhd}
vcom -93 -work add_sub {../../core/risc_v/FPULA/cyclone_v/add_sub/dspba_library.vhd}
vcom -93 -work add_sub {../../core/risc_v/FPULA/cyclone_v/add_sub/add_sub_0002.vhd}
vcom -93 -work cvt_s_w {../../core/risc_v/FPULA/cyclone_v/cvt_s_w/dspba_library.vhd}
vcom -93 -work cvt_s_w {../../core/risc_v/FPULA/cyclone_v/cvt_s_w/cvt_s_w_0002.vhd}
vcom -93 -work cvt_s_wu {../../core/risc_v/FPULA/cyclone_v/cvt_s_wu/dspba_library.vhd}
vcom -93 -work cvt_s_wu {../../core/risc_v/FPULA/cyclone_v/cvt_s_wu/cvt_s_wu_0002.vhd}
vcom -93 -work cvt_w_s {../../core/risc_v/FPULA/cyclone_v/cvt_w_s/dspba_library.vhd}
vcom -93 -work cvt_w_s {../../core/risc_v/FPULA/cyclone_v/cvt_w_s/cvt_w_s_0002.vhd}
vcom -93 -work cvt_wu_s {../../core/risc_v/FPULA/cyclone_v/cvt_wu_s/dspba_library.vhd}
vcom -93 -work cvt_wu_s {../../core/risc_v/FPULA/cyclone_v/cvt_wu_s/cvt_wu_s_0002.vhd}
vcom -93 -work div_s {../../core/risc_v/FPULA/cyclone_v/div_s/dspba_library.vhd}
vcom -93 -work div_s {../../core/risc_v/FPULA/cyclone_v/div_s/div_s_0002.vhd}
vcom -93 -work fmin_s {../../core/risc_v/FPULA/cyclone_v/fmin_s/fmin_s_0002.vhd}
vcom -93 -work fmax_s {../../core/risc_v/FPULA/cyclone_v/fmax_s/fmax_s_0002.vhd}
vcom -93 -work mul_s {../../core/risc_v/FPULA/cyclone_v/mul_s/dspba_library.vhd}
vcom -93 -work mul_s {../../core/risc_v/FPULA/cyclone_v/mul_s/mul_s_0002.vhd}
vcom -93 -work sqrt_s {../../core/risc_v/FPULA/cyclone_v/sqrt_s/dspba_library.vhd}
vcom -93 -work sqrt_s {../../core/risc_v/FPULA/cyclone_v/sqrt_s/sqrt_s_0002.vhd}

vlog -sv -work work +incdir+../../core +incdir+../../test/verilog_testbench {../../test/verilog_testbench/fpga_top_tb.v}

vsim -t 10ns -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  fpga_top_tb

vcd file simulation_output.vcd
vcd add -r /*
run -all

exit -f

