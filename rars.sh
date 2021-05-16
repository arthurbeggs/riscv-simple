#!/usr/bin/bash
set -euo pipefail

cd "$( dirname "${BASH_SOURCE[0]}" )"
java -jar ./tools/rars/Rars15_Custom1.jar  </dev/null &>/dev/null &

