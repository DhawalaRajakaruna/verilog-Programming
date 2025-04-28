`include "main.v"
`timescale 1ns/1ns

module SignalGenerator_tb;
    reg clk;

    // Instantiate the unit under test (UUT)
    SignalGenerator uut(
        .clk(clk)
    );

    initial begin
        $dumpfile("SignalGenerator_tb.vcd");
        $dumpvars(0, SignalGenerator_tb);    

        clk = 0;
        // Let the simulation run for some time before finishing
        #1000; // Wait for 1000 ns
        $finish; // Finish the simulation
    end

    // Generate clock signal: toggles every 50 ns (period 100 ns)
    always #50 clk = ~clk;
endmodule
