`timescale 1ns/1ps

module smart_id_alert_controller #(
    parameter DELAY_COUNT = 5
)(
    input  wire clk,
    input  wire reset_n,
    input  wire door_open,
    input  wire id_card_detect,
    input  wire alert_enable,

    output reg  alert,
    output reg  led,
    output reg  buzzer
);

    reg [7:0] counter;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 0;
            alert   <= 0;
            led     <= 0;
            buzzer  <= 0;
        end
        else begin

            if (!door_open || id_card_detect || !alert_enable) begin
                counter <= 0;
                alert   <= 0;
                led     <= 0;
                buzzer  <= 0;
            end

            else if (counter < DELAY_COUNT) begin
                counter <= counter + 1'b1;
                alert   <= 0;
                led     <= 0;
                buzzer  <= 0;
            end

            else begin
                alert  <= 1;
                led    <= 1;
                buzzer <= 1;
            end

        end
    end

endmodule

##TestBench
`timescale 1ns/1ps

module tb_smart_id_alert_controller;

    reg clk;
    reg reset_n;
    reg door_open;
    reg id_card_detect;
    reg alert_enable;

    wire alert;
    wire led;
    wire buzzer;

    smart_id_alert_controller #(
        .DELAY_COUNT(5)
    ) dut (
        .clk(clk),
        .reset_n(reset_n),
        .door_open(door_open),
        .id_card_detect(id_card_detect),
        .alert_enable(alert_enable),
        .alert(alert),
        .led(led),
        .buzzer(buzzer)
    );

    // 10 ns clock period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin

        $dumpfile("waveforms/rtl_waveform.vcd");
        $dumpvars(0, tb_smart_id_alert_controller);

        // Initial conditions
        reset_n       = 0;
        door_open     = 0;
        id_card_detect = 0;
        alert_enable  = 1;

        #20;
        reset_n = 1;

        // Open door without card
        #20;
        door_open = 1;

        // Wait for the alert
        #100;

        // Card is detected
        id_card_detect = 1;

        #30;

        // Door closes
        door_open = 0;
        id_card_detect = 0;

        #30;

        $finish;

    end

    initial begin
        $monitor(
            "Time=%0t door=%b card=%b counter=%d alert=%b led=%b buzzer=%b",
            $time,
            door_open,
            id_card_detect,
            dut.counter,
            alert,
            led,
            buzzer
        );
    end

endmodule
