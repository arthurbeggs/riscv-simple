#!/usr/bin/bash
set -ux

### Generates output files, simulation and logs for the 9 combinations of
###   microarchitectures and processor extensions
# TODO: Change .mif testbenches for each extension
# TODO: Invoke modelsim after a successful compilation
# TODO: Parse errors from logs

# Compile project
full_compilation (){
    [[ -f ../../test/sof_library/rv"$1".sof ]] && rm ../../test/sof_library/rv"$1".sof
    quartus_sh --flow compile fpga_top > output_files/rv"$1"_make_full.log \
        && cp output_files/fpga_top.sof ../../test/sof_library/rv"$1".sof
}

# Analysis and synthesis only
partial_compilation (){
    quartus_map fpga_top > output_files/rv"$1"_make_partial.log
}

select_uarch (){
    # Comment out all microarchitectures defines
    sed -i 's/^\s*`define UNICICLO$/\/\/ `define UNICICLO/' ../../core/config.v
    sed -i 's/^\s*`define MULTICICLO$/\/\/ `define MULTICICLO/' ../../core/config.v
    sed -i 's/^\s*`define PIPELINE$/\/\/ `define PIPELINE/' ../../core/config.v

    if [[ "$1" == "uni" ]]; then
        sed -i 's/^\/\/ `define UNICICLO$/`define UNICICLO/' ../../core/config.v

    elif [[ "$1" == "multi" ]]; then
        sed -i 's/^\/\/ `define MULTICICLO$/`define MULTICICLO/' ../../core/config.v

    elif [[ "$1" == "pipe" ]]; then
        sed -i 's/^\/\/ `define PIPELINE$/`define PIPELINE/' ../../core/config.v
    fi
}

select_extensions (){
    # Comment out all extensions defines
    sed -i 's/^\s*`define RV32I$/\/\/ `define RV32I/' ../../core/config.v
    sed -i 's/^\s*`define RV32IM$/\/\/ `define RV32IM/' ../../core/config.v
    sed -i 's/^\s*`define RV32IMF$/\/\/ `define RV32IMF/' ../../core/config.v

    if [[ "$1" == "32i" ]]; then
        sed -i 's/^\/\/ `define RV32I$/`define RV32I/' ../../core/config.v

    elif [[ "$1" == "32im" ]]; then
        sed -i 's/^\/\/ `define RV32IM$/`define RV32IM/' ../../core/config.v

    elif [[ "$1" == "32imf" ]]; then
        sed -i 's/^\/\/ `define RV32IMF$/`define RV32IMF/' ../../core/config.v
    fi
}

# Make a full compilation of all variants
compile_all_variants (){
    ARCH=('uni' 'multi' 'pipe')
    EXTENSION=('32i' '32im' '32imf')
    for i in "${ARCH[@]}"; do
        select_uarch "$i"
        for j in "${EXTENSION[@]}"; do
            select_extensions "$j"
            full_compilation "$j""_$i"
        done
    done
}

# Make a partial compilation of all variants
partial_compile_all_variants (){
    ARCH=('uni' 'multi' 'pipe')
    EXTENSION=('32i' '32im' '32imf')
    for i in "${ARCH[@]}"; do
        select_uarch "$i"
        for j in "${EXTENSION[@]}"; do
            select_extensions "$j"
            partial_compilation "$j""_$i"
        done
    done
}

#########################################################################
cd ./project/de1_soc
[[ -d ./output_files ]] || mkdir output_files

if [[ $# -ne 0 ]]; then
    case "$1" in
        --full )
            compile_all_variants
            ;;
        --partial )
            partial_compile_all_variants
            ;;
        * )
            echo "Choose --full or --partial\n"
    esac
else
    echo "Choose --full or --partial\n"
fi

