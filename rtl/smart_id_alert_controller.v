`timescale 1ns/1ps

module smart_id_alert_controller #(
    parameter integer ALERT_DELAY_CYCLES = 4,
    parameter integer COUNTER_WIDTH = 3
) (
    input  wire clk,
    input  wire reset_n,
    input  wire door_open,
    input  wire card_present,
    input  wire alert_enable,
    output reg  alert,
    output wire led,
    output wire buzzer
);

    reg [COUNTER_WIDTH-1:0] counter;

    assign led = alert;
    assign buzzer = alert;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            counter <= {COUNTER_WIDTH{1'b0}};
            alert   <= 1'b0;
        end else if (!alert_enable || !door_open || card_present) begin
            counter <= {COUNTER_WIDTH{1'b0}};
            alert   <= 1'b0;
        end else if (!alert) begin
            if (counter >= ALERT_DELAY_CYCLES - 1) begin
                alert <= 1'b1;
            end else begin
                counter <= counter + 1'b1;
            end
        end
    end

endmodule
