#!/usr/bin/bash
set -euo pipefail

cd "$( dirname "${BASH_SOURCE[0]}" )"
gtkwave  </dev/null &>/dev/null &

