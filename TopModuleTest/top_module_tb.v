`include "top_module.v"
`timescale 1ns/1ns

module top_module_tb;
    reg a, b;
    wire and_out, not_out, or_out;

    // Instantiate the top-level module
    top_module uut(
        .a(a),
        .b(b),
        .and_out(and_out),
        .not_out(not_out),
        .or_out(or_out)

    );

    initial begin
        // Test all possible combinations of a and b
        $dumpfile("top_module_tb.vcd");
        $dumpvars(0, top_module_tb);
        a = 0; b = 0; #1;
        a = 0; b = 1; #1;
        a = 1; b = 0; #1;
        a = 1; b = 1; #1;
        $finish;
    end
endmodule
