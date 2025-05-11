`include "uart.v"
// UART Testbench with improved timing
`timescale 1ns/1ps

module uart_tb();
    reg clk = 0;
    reg rst = 0;
    wire rxclk, txclk;
    wire txd;
    wire rxOut;
    wire [7:0] datareg;
    
    // Create internal RX wire to monitor the data
    wire rx_data;
    
    // Add a small delay to the loopback to avoid metastability
    reg txd_delayed;
    
    always @(posedge clk) begin
        txd_delayed <= txd;
    end
    
    assign rx_data = txd_delayed;
    
    // Instantiate the top module with our delayed loopback
    topModule uut (
        .clk(clk),
        .rst(rst),
        .rxclk(rxclk),
        .txclk(txclk),
        .txd(txd),
        .rxd(rx_data),    // Use delayed loopback
        .rxOut(rxOut),
        .datareg(datareg)
    );
    
    // Clock generation - fast clock for simulation
    always #5 clk = ~clk;  // 100MHz
    
    // Test procedure
    initial begin
        // Dump waveforms to view in simulator
        $dumpfile("uart_sim.vcd");
        $dumpvars(0, uart_tb);
        
        // Apply reset
        #10 rst = 1;
        #50 rst = 0;
        
        // Wait for transmission to complete and allow checking
        // We'll check multiple times to see progress
        
        // First check early
        #5000;
        $display("Intermediate check - Data: %b (0x%h), RxOut: %b", datareg, datareg, rxOut);
        
        // Mid check
        #5000;
        $display("Halfway check - Data: %b (0x%h), RxOut: %b", datareg, datareg, rxOut);
        
        // Allow more time for complete transmission and reception
        #10000;
        $display("Final check - Data: %b (0x%h), RxOut: %b", datareg, datareg, rxOut);
        
        // Extended time for final verification
        #30000;
        $display("UART Test Results:");
        $display("Data transmitted: 8'b00110011 (0x33)");
        $display("Data received: %b (0x%h)", datareg, datareg);
        $display("RxOut signal: %b", rxOut);
        
        $finish;
    end
    
    // Add debugging for state transitions
    always @(posedge rxclk) begin
        if (uut.rx.state == 0)
            $display("RX: IDLE state at time %t", $time);
        else if (uut.rx.state == 1)
            $display("RX: START state at time %t", $time);
        else if (uut.rx.state == 2)
            $display("RX: DATA state with bit %d = %b at time %t", 
                    uut.rx.bit_counter, rx_data, $time);
        else if (uut.rx.state == 3)
            $display("RX: STOP state at time %t", $time);
    end
    
    always @(posedge txclk) begin
        if (uut.tx.state == 0)
            $display("TX: IDLE state at time %t", $time);
        else if (uut.tx.state == 1)
            $display("TX: START state at time %t", $time);
        else if (uut.tx.state == 2)
            $display("TX: DATA state sending bit %d = %b at time %t", 
                    uut.tx.bit_counter, txd, $time);
        else if (uut.tx.state == 3)
            $display("TX: STOP state at time %t", $time);
    end
endmodule