#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p build/synthesis
yosys -p "read_verilog -sv rtl/smart_id_alert_controller.v; hierarchy -check -top smart_id_alert_controller; proc; opt; check; synth -top smart_id_alert_controller; check; stat; write_verilog -noattr build/synthesis/smart_id_alert_synth.v" \
  2>&1 | tee build/synthesis/yosys.log
grep -A30 -E "=== smart_id_alert_controller ===|Number of cells:" build/synthesis/yosys.log \
  > build/synthesis/stat.txt || true
