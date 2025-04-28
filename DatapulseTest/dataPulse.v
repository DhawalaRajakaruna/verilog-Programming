module dataPulse(
    input wire clk,
    output reg pulse_out
);

    reg [7:0] data = 8'b01000110;  // fixed data
    reg [3:0] count = 0;           // enough to count 0 to 8

    //initial pulse_out = 1;         // Set pulse_out = 1 initially

    always @(posedge clk) begin
        if (count < 8) begin
            pulse_out <= data[count];  // Send out bits one by one
            count <= count + 1;
        end
        else begin
            pulse_out <= 1;  // After 8 bits, keep pulse high
        end
    end

endmodule
