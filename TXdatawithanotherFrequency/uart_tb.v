`include "uart.v"
`timescale 1ns / 1ns

module topModule_tb;

    reg clk;    // System clock
    reg rxd;    // Receive Data (make it reg)
    wire txd;   // Transmit Data
    wire rxclk;
    wire txclk;

    // Instantiate the topModule
    topModule uut (
        .clk(clk),
        .rxclk(rxclk),
        .txclk(txclk),
        .txd(txd),
        .rxd(rxd)
    );

    // Clock generation for system clock (clk)
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 50 MHz clock --> 20ns period
    end

    // Simulate RX line (idle high)
    initial begin
        rxd = 1; // set RXD high at the beginning
    end

    initial begin
        // Simulation control
        $dumpfile("topModule_tb.vcd"); // (Optional) For waveform viewing
        $dumpvars(0, topModule_tb);

        // Simulation time
        #1000000000; // Run for 100,000 ns
        $finish;
    end

endmodule
