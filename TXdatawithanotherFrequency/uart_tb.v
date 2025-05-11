`timescale 10ns / 1ns

module topModule_tb;

    reg clk;
    wire rxclk;
    wire txclk;
    wire txd;
    wire rxOut;
    wire [7:0] datareg;

    // Instantiate the topModule
    topModule uut (
        .clk(clk),
        .rxclk(rxclk),
        .txclk(txclk),
        .txd(txd),
        .rxd(txd),        // Loopback: connect TX to RX
        .rxOut(rxOut),
        .datareg(datareg)      // Output data from the receiver

    );
	  initial begin
		 clk = 0;
	  end
	  always begin 
		 #1 clk = ~clk;
	  end 
	  initial begin
		 #1000000;
	  end


endmodule
