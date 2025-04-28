module uarttx(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] data_in,
    output reg txd,
    output reg busy
);
endmodule

module uartrx(
    input wire clk,
    input wire rst,
    input wire rxd,
    output reg [7:0] data_out,
    output reg data_ready
);
endmodule

module topModule(

);
endmodule