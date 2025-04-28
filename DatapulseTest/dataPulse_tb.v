`include "dataPulse.v"
`timescale 1ns/1ns

module dataPulse_tb;
    reg clk;
    wire pulse_out;

    // Instantiate the module under test (UUT)
    dataPulse uut (
        .clk(clk),
        .pulse_out(pulse_out)
    );
    
    // Clock generation: toggle every 5 time units (period = 10)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // 50MHz clock if 1 time unit = 1ns
    end

    // Simulation control
    initial begin
        // Optionally dump waves if your simulator supports it
        $dumpfile("dataPulse_tb.vcd");
        $dumpvars(0, dataPulse_tb);

        // Let the simulation run for some time
        #2000; // Run simulation for 200 time units
        $finish;
    end
endmodule
