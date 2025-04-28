module and_gate(
    input a,
    input b,
    output out
);
    assign out = a & b;
endmodule

module not_gate(
    input a,
    output out
);
    assign out = ~a;
endmodule

module or_gate(
    input a,
    input b,
    output out
);
    assign out = a | b;
endmodule

module top_module(
    input a, 
    input b, 
    output and_out, 
    output not_out, 
    output or_out
);
    and_gate and1(a, b, and_out);
    not_gate not1(a, not_out);
    or_gate or1(a, b, or_out);
endmodule
