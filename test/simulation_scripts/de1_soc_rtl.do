transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap real_work rtl_work

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

vlog -sv -work real_work +incdir+../../core/clock/cyclone_v          {../../core/clock/cyclone_v/pll_sim/pll.vo}
vlog -sv -work real_work +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/cvt_s_w_sim/cvt_s_w.vo}
vlog -sv -work real_work +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/add_sub_sim/add_sub.vo}
vlog -sv -work real_work +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/cvt_s_wu_sim/cvt_s_wu.vo}
vlog -sv -work real_work +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/cvt_w_s_sim/cvt_w_s.vo}
vlog -sv -work real_work +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/cvt_wu_s_sim/cvt_wu_s.vo}
vlog -sv -work real_work +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/div_s_sim/div_s.vo}
vlog -sv -work real_work +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/fmin_s_sim/fmin_s.vo}
vlog -sv -work real_work +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/fmax_s_sim/fmax_s.vo}
vlog -sv -work real_work +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/mul_s_sim/mul_s.vo}
vlog -sv -work real_work +incdir+../../core/risc_v/FPULA/cyclone_v   {../../core/risc_v/FPULA/cyclone_v/sqrt_s_sim/sqrt_s.vo}

vlog -sv -work real_work +define+SIMULATION +incdir+../../core {../../core/config.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core {../../core/fpga_top.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/clock {../../core/clock/breakpoint_interface.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/clock {../../core/clock/clock_control.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/clock {../../core/clock/clock_counters.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/clock {../../core/clock/clock_divider.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/clock {../../core/clock/clock_interface.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/clock {../../core/clock/rtc_interface.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/memory {../../core/memory/MemLoad.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/memory {../../core/memory/MemStore.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/memory {../../core/memory/Memory_Interface.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/memory {../../core/memory/CodeMemory_Interface.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/memory {../../core/memory/DataMemory_Interface.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/memory {../../core/memory/framebuffer_interface.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/memory/cyclone_v {../../core/memory/cyclone_v/breakpoint_memory.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/memory/cyclone_v {../../core/memory/cyclone_v/framebuffer_memory.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/memory/cyclone_v {../../core/memory/cyclone_v/data_memory.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/memory/cyclone_v {../../core/memory/cyclone_v/text_memory.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/lfsr {../../core/peripherals/lfsr/lfsr_interface.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/lfsr {../../core/peripherals/lfsr/LFSR_word.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/video {../../core/peripherals/video/video_interface.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/video {../../core/peripherals/video/video_compositor.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/video {../../core/peripherals/video/vga_driver.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/peripherals/video {../../core/peripherals/video/font.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/ALU.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/BranchControl.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/Control_MULTI.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/Control_PIPEM.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/Control_UNI.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/CPU.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/CSRegisters.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/Datapath_MULTI.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/Datapath_PIPEM.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/Datapath_UNI.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/ExceptionControl.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/FwdHazardUnitM.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/ImmGen.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/Registers.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v {../../core/risc_v/FRegisters.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v/FPULA {../../core/risc_v/FPULA/FPALU.v}
vlog -sv -work real_work +define+SIMULATION +incdir+../../core +incdir+../../core/risc_v/FPULA/cyclone_v {../../core/risc_v/FPULA/cyclone_v/comp_s.v}

vlog -sv -work work +incdir+../../core +incdir+../../test/verilog_testbench {../../test/verilog_testbench/fpga_top_tb.v}

vsim -t 1ns -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L real_work -voptargs="+acc"  -suppress 3016,3017,3722 fpga_top_tb

vcd file simulation_output.vcd
vcd add -r /fpga_top_tb/dut/*
run -all

exit -f

