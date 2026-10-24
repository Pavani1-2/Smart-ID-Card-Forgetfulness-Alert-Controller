#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p build/sim
iverilog -g2012 -Wall -s tb_smart_id_alert_controller \
  -o build/sim/smart_id_alert.vvp \
  rtl/smart_id_alert_controller.v tb/tb_smart_id_alert_controller.v
vvp build/sim/smart_id_alert.vvp | tee build/sim/simulation.log
