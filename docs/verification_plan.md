# Verification plan

| Test ID | Stimulus | Expected result |
|---|---|---|
| T01 | Assert reset | `alert=0`, counter clears |
| T02 | Door open, card present | No alert |
| T03 | Door open, card absent fewer than threshold cycles | No alert yet |
| T04 | Door open, card absent through threshold | `alert=1`, `led=1`, `buzzer=1` |
| T05 | Card becomes present | Alert clears |
| T06 | `alert_enable=0` | Alert clears and stays low |
| T07 | Door closes | Alert/counter clear |

The supplied testbench exercises the above scenarios. Add tests for reset during an alert, repeated exit attempts, boundary values of `ALERT_DELAY_CYCLES`, and sensor glitches before using this design in a larger system.
