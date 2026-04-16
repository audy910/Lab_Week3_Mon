`include "src/ledDuty.sv"
`include "src/decoder.sv"

module top (
    input  wire clk,
    input  wire green_btn,
    input  wire blue_btn,
    input  logic dip,
    output wire [6:0] seg7,
    output logic green,
    output logic blue,
    output logic dp
);

    wire [3:0] duty_cycle_green;
    wire [3:0] duty_cycle_blue;
    logic[3:0] pwm_green;
    logic[3:0] pwm_blue;
    logic [6:0] seg7_green;
    logic [6:0] seg7_blue;
    logic activeDutyCycle; // 1 if dip is high

    dutyCycleSM green_counter (
        .clk(clk),
        .in(green_btn),
        .duty_cycle(duty_cycle_green)
    );

    dutyCycleSM blue_counter (
        .clk(clk),
        .in(blue_btn),
        .duty_cycle(duty_cycle_blue)
    );

    decoder u_decoder (
        .bcd(duty_cycle_green),
        .seg7(seg7_green) // Unused
    );

    decoder u_decoder_blue (
        .bcd(duty_cycle_blue),
        .seg7(seg7_blue) // Unused
    );

    always_ff @(posedge clk) begin
        pwm_blue <= (pwm_blue >= 4'd10) ? 4'd0 : pwm_blue + 1;
    end
    always_ff @(posedge clk) begin
        pwm_green <= (pwm_green >= 4'd10) ? 4'd0 : pwm_green + 1;
    end

    assign   blue = (pwm_blue < duty_cycle_blue) ? 1'b1 : 1'b0;
    assign   green = (pwm_green < duty_cycle_green) ? 1'b1 : 1'b0;
    assign   activeDutyCycle = dip; // 1 if dip is high
    assign   dp = activeDutyCycle; // DP on when dip is high
    assign   seg7 = activeDutyCycle ? seg7_blue : seg7_green; // Show blue duty cycle when dip is high, else show green


endmodule