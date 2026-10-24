`timescale 1ns/1ps

module tb_smart_id_alert_controller;
    reg clk = 0;
    reg reset_n = 0;
    reg door_open = 0;
    reg card_present = 0;
    reg alert_enable = 1;
    wire alert, led, buzzer;

    smart_id_alert_controller #(
        .ALERT_DELAY_CYCLES(4),
        .COUNTER_WIDTH(3)
    ) dut (
        .clk(clk),
        .reset_n(reset_n),
        .door_open(door_open),
        .card_present(card_present),
        .alert_enable(alert_enable),
        .alert(alert),
        .led(led),
        .buzzer(buzzer)
    );

    always #5 clk = ~clk;

    task tick;
        begin
            @(posedge clk);
            #1;
        end
    endtask

    initial begin
        $dumpfile("build/sim/smart_id_alert.vcd");
        $dumpvars(0, tb_smart_id_alert_controller);

        $display("Starting Smart ID Card Alert Controller tests");
        #2; reset_n = 0;
        #10; reset_n = 1;
        tick();
        if (alert !== 0) $fatal(1, "FAIL: alert should be low after reset");

        // Card present: no alert even with door open.
        door_open = 1; card_present = 1;
        repeat (6) tick();
        if (alert !== 0) $fatal(1, "FAIL: alert while card is present");

        // Card absent: alert after four qualifying clock edges.
        card_present = 0;
        repeat (3) tick();
        if (alert !== 0) $fatal(1, "FAIL: alert asserted too early");
        tick();
        if (alert !== 1) $fatal(1, "FAIL: alert did not assert at threshold");
        if (led !== 1 || buzzer !== 1) $fatal(1, "FAIL: LED/buzzer outputs incorrect");

        // Returning the card clears the alert.
        card_present = 1; tick();
        if (alert !== 0) $fatal(1, "FAIL: card-present condition did not clear alert");

        // Disabled alert must stay low.
        card_present = 0; alert_enable = 0;
        repeat (5) tick();
        if (alert !== 0) $fatal(1, "FAIL: alert asserted while disabled");

        // Closing the door clears the counter/alert.
        alert_enable = 1; door_open = 1;
        repeat (4) tick();
        if (alert !== 1) $fatal(1, "FAIL: expected alert before door-close test");
        door_open = 0; tick();
        if (alert !== 0) $fatal(1, "FAIL: closing door did not clear alert");

        $display("PASS: all Smart ID Card Alert Controller tests passed");
        #10;
        $finish;
    end
endmodule
