#!/usr/bin/bash
set -ux

### Generates output files, simulation and logs for the 9 combinations of
###   microarchitectures and processor extensions
# TODO: Change .mif testbenches for each extension
# TODO: Invoke modelsim after a successful compilation
# TODO: Parse errors from logs

# Comment out microarch & ISA defines in config.v
comment_out_arch_defines (){
    sed -i 's/^\s*`define UNICICLO$/\/\/ `define UNICICLO/' ../../core/config.v
    sed -i 's/^\s*`define MULTICICLO$/\/\/ `define MULTICICLO/' ../../core/config.v
    sed -i 's/^\s*`define PIPELINE$/\/\/ `define PIPELINE/' ../../core/config.v
    sed -i 's/^\s*`define RV32I$/\/\/ `define RV32I/' ../../core/config.v
    sed -i 's/^\s*`define RV32IM$/\/\/ `define RV32IM/' ../../core/config.v
    sed -i 's/^\s*`define RV32IMF$/\/\/ `define RV32IMF/' ../../core/config.v
}

# Compile project
invoke_quartus (){
    quartus_sh --flow compile fpga_top > output_files/rv"$1"_make.log \
        && cp output_files/fpga_top.sof ../../test/sof_library/rv"$1".sof
}

# Select all ISA variants for a given microarchitecture
compile_isa_variants (){
    ISA=('32i' '32im' '32imf')
    for i in "${ISA[@]}"; do
        if [[ $i == ${ISA[0]} ]]; then
            sed -i 's/^\/\/ `define RV32I$/`define RV32I/' ../../core/config.v
            invoke_quartus "$i_$1"

        elif [[ $i == ${ISA[1]} ]]; then
            sed -i 's/^`define RV32I$/\/\/ `define RV32I/' ../../core/config.v
            sed -i 's/^\/\/ `define RV32IM$/`define RV32IM/' ../../core/config.v
            invoke_quartus "$i_$1"

        elif [[ $i == ${ISA[2]} ]]; then
            sed -i 's/^`define RV32IM$/\/\/ `define RV32IM/' ../../core/config.v
            sed -i 's/^\/\/ `define RV32IMF$/`define RV32IMF/' ../../core/config.v
            invoke_quartus "$i_$1"

            sed -i 's/^`define RV32IMF$/\/\/ `define RV32IMF/' ../../core/config.v
        fi
    done
}

# Select all microarchitecture variants
compile_arch_variants (){
    ARCH=('uni' 'multi' 'pipe')
    for i in "${ARCH[@]}"; do
        if [[ $i == ${ARCH[0]} ]]; then
            sed -i 's/^\/\/ `define UNICICLO$/`define UNICICLO/' ../../core/config.v
            compile_isa_variants "$i"

        elif [[ $i == ${ARCH[1]} ]]; then
            sed -i 's/^`define UNICICLO$/\/\/ `define UNICICLO/' ../../core/config.v
            sed -i 's/^\/\/ `define MULTICICLO$/`define MULTICICLO/' ../../core/config.v
            compile_isa_variants "$i"

        elif [[ $i == ${ARCH[2]} ]]; then
            sed -i 's/^`define MULTICICLO$/\/\/ `define MULTICICLO/' ../../core/config.v
            sed -i 's/^\/\/ `define PIPELINE$/`define PIPELINE/' ../../core/config.v
            compile_isa_variants "$i"
            sed -i 's/^`define PIPELINE$/\/\/ `define PIPELINE/' ../../core/config.v
        fi
    done
}

cd ./project/de1_soc
[[ -d ./output_files ]] || mkdir output_files
comment_out_arch_defines
compile_arch_variants

