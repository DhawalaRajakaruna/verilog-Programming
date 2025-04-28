`include "signalGenereator.v"
`timescale 1ns/1ns

module signalGenerator_tb;

    reg clk;
    wire signal;

    // Instantiate the module under test (MUT)
    signalGenerator uut (
        .clk(clk),
        .signal(signal)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 50MHz clock -> period 20ns (toggle every 10ns)
    end

    // Simulation control
    initial begin
        $dumpfile("signalGenerator_tb.vcd");
        $dumpvars(0, signalGenerator_tb);

        #100000000; // Run for 100ms
        $finish;
    end

endmodule
