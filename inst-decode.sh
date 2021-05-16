#!/usr/bin/bash
set -euo pipefail

echo "$1" | tools/riscv-disassembler/build/riscv-decode

