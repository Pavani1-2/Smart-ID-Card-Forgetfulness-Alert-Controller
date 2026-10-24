# STARTER CONSTRAINTS ONLY — adapt for your chosen target and PDK.
create_clock -name core_clk -period 10.000 [get_ports clk]
set_clock_uncertainty 0.100 [get_clocks core_clk]
set_input_delay  1.000 -clock core_clk [get_ports {door_open card_present alert_enable reset_n}]
set_output_delay 1.000 -clock core_clk [get_ports {alert led buzzer}]
