`timescale 1ns/1ps
`include "src/ledBlink.sv"

module ledBlink_tb;

    logic clk = 0;
    logic in  = 0;
    logic out;

    // DUT
    ledBlink dut (.clk(clk), .in(in), .out(out));

    // Clock: 10ns period
    always #5 clk = ~clk;

    // Waveform dump
    initial begin
        $dumpfile("build/ledBlink.vcd");
        $dumpvars(0, ledBlink_tb);
    end

    // Stimulus
    initial begin
        // Stay OFF
        repeat(4) @(posedge clk);

        // Turn ON
        in = 1; @(posedge clk);
        in = 0;

        // Stay ON
        repeat(4) @(posedge clk);

        // Turn OFF
        in = 1; @(posedge clk);
        in = 0;

        // Stay OFF
        repeat(4) @(posedge clk);

        // Toggle rapidly
        repeat(6) begin
            in = 1; @(posedge clk);
            in = 0; @(posedge clk);
        end

        repeat(4) @(posedge clk);
        $finish;
    end

endmodule