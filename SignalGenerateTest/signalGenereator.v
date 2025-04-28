module signalGenerator(
    input wire clk,
    output reg signal
);
    reg [7:0] count = 0;
    reg p = 0;


    initial begin
        signal = 0; // Make sure signal starts at 0
    end

    always @(posedge clk) begin
        count <= count + 1;
        if (count == 8'h64) begin
            count <= 0;
            signal <= ~p;
            p <= ~p;
        end
    end

endmodule
