# Smart ID Card Forgetfulness Alert Controller
**RTL-to-GDS project starter | Verilog | Simulation | Synthesis | Physical-design flow**

## 1. Project overview
This project models a small controller that reminds a user when they are leaving while their ID card is not detected.

### Functional behavior
- `clk`: rising-edge clock.
- `reset_n`: active-low asynchronous reset.
- `door_open`: indicates the door/exit has been opened.
- `card_present`: ID card sensor input (`1` = card detected).
- `alert_enable`: enables the reminder.
- `alert`: asserted after the door is open and the card is absent for the configured number of clock cycles.
- `led`: follows `alert`.
- `buzzer`: follows `alert`.

The alert and counter clear when the card is detected, the door closes, or alerting is disabled. This is a digital demonstration model; real deployment requires a suitable card sensor, debounce/filtering, power driver, and safety review.

## 2. Block diagram
```text
 card_present ─┐
 door_open ────┼──> Condition logic + cycle counter ──> alert ──┬──> LED driver interface
 alert_enable ─┤                                                └──> Buzzer driver interface
 clk/reset_n ──┘
```

## 3. Repository structure
```text
Smart_ID_Card_Forgetfulness_Alert_Controller/
├── rtl/
│   └── smart_id_alert_controller.v
├── tb/
│   └── tb_smart_id_alert_controller.v
├── sim/
│   └── run_iverilog.sh
├── synthesis/
│   ├── run_yosys.sh
│   └── constraints.sdc
├── physical/
│   ├── openroad_config.mk.example
│   └── README.md
├── waveforms/
│   ├── illustrative_functional_trace.vcd
│   └── README.md
├── docs/
│   └── verification_plan.md
├── images/
│   └── README.md
└── README.md
```

## 4. RTL design
Main RTL: `rtl/smart_id_alert_controller.v`.
The delay is configurable using `ALERT_DELAY_CYCLES`; default is 4 cycles. For physical implementation, change this parameter only after checking the counter width and timing requirements.

## 5. Simulation (Icarus Verilog + GTKWave)
On Ubuntu/Linux, install the tools if needed:
```bash
sudo apt update
sudo apt install iverilog gtkwave
```
From the project root:
```bash
chmod +x sim/run_iverilog.sh
./sim/run_iverilog.sh
```
The script compiles the RTL and testbench, runs the testbench, and writes:
- `build/sim/smart_id_alert.vvp`
- `build/sim/smart_id_alert.vcd`
- `build/sim/simulation.log`

Open the VCD:
```bash
gtkwave build/sim/smart_id_alert.vcd
```
Add `clk`, `reset_n`, `door_open`, `card_present`, `alert_enable`, `alert`, `led`, `buzzer`, and `counter` to the GTKWave signal pane. The VCD bundled in `waveforms/illustrative_functional_trace.vcd` is an illustrative trace for familiarization; regenerate the authoritative trace by running the testbench.

## 6. Test scenarios
The testbench checks:
1. reset initializes alert low;
2. card present prevents alert;
3. open door + missing card causes alert after the threshold;
4. inserting the card clears alert;
5. closing the door clears alert;
6. disabling alert clears alert.

The testbench prints PASS/FAIL messages and ends with `$fatal` on a failed assertion.

## 7. Synthesis (Yosys)
Install Yosys if needed. Run:
```bash
chmod +x synthesis/run_yosys.sh
./synthesis/run_yosys.sh
```
Outputs:
- `build/synthesis/smart_id_alert_synth.v` — generic synthesized netlist (not SKY130-mapped unless a technology mapping flow is configured)
- `build/synthesis/yosys.log` — synthesis log
- `build/synthesis/stat.txt` — cell statistics

The script uses the actual top module `smart_id_alert_controller`. A technology-mapped netlist requires a compatible standard-cell library and mapping setup.

## 8. Timing constraints
`synthesis/constraints.sdc` is a starter SDC. The clock period and I/O delays are examples and must be adapted to the target clock, sensor interface, library, and implementation flow.

## 9. Physical design and GDS
The `physical/openroad_config.mk.example` file is a **configuration template**, not a completed run. A real GDS requires:
- a compatible OpenROAD-flow-scripts installation;
- a supported PDK/platform (for example SKY130 HD) and its timing/LEF/GDS libraries;
- successful synthesis, floorplan, placement, CTS, routing, timing checks, and stream-out.

Read `physical/README.md` before running a flow. The archive does **not** claim that a GDS or signoff result has been generated. No fabricated GDS, timing numbers, or DRC/LVS claims are included. The real GDS filename and location depend on the selected flow configuration.

## 10. Suggested RTL-to-GDS sequence
```text
RTL
  ↓
Icarus Verilog simulation + testbench
  ↓
Yosys synthesis
  ↓
Technology mapping with selected PDK
  ↓
Floorplan and power planning
  ↓
Placement
  ↓
Clock-tree synthesis (if required by the design/flow)
  ↓
Routing
  ↓
STA + DRC/LVS checks supported by the PDK flow
  ↓
GDSII stream-out
```

## 11. Limitations and honest reporting
This is a runnable RTL/simulation/synthesis starter package. Physical-design files are templates because a real PDK/OpenROAD run cannot be asserted without executing it in the target environment. In reports and resumes, label results as *not run* until you have logs and generated artifacts. Never describe the illustrative VCD as a measured silicon result.
