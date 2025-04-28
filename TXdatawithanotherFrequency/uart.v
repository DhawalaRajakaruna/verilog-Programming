module uarttx(
    input wire clk,
    output reg txd
);
    initial begin
        txd = 1; // Idle state is high
    end
    reg [7:0] data = 8'h00;  // fixed data
    reg [3:0] count = 0;  

    always @(posedge clk) begin
        if (count < 8) begin
            txd <= data[count];  // Send out bits one by one
            count <= count + 1;
        end else begin
            txd <= 1;  // After 8 bits, keep pulse high
        end
    end
endmodule

module uartrx(
    input wire clk,
    input wire rxd
);
    // RX module (currently empty)
endmodule

module topModule(
    input wire clk,
    output wire rxclk,
    output wire txclk,
    output wire txd,
    input wire rxd
);

    // Instantiate receiver and transmitter
    uartrx rx (
        .clk(rxclk),
        .rxd(rxd)
    );

    uarttx tx (
        .clk(txclk),
        .txd(txd)
    ); 

    // Clock divider logic
    reg [5:0] rx_counter = 0;  // Only need small counters
    reg [5:0] tx_counter = 0;
    reg rxclk_reg = 0;
    reg txclk_reg = 0;

    assign rxclk = rxclk_reg;
    assign txclk = txclk_reg;

    always @(posedge clk) begin
        // Divide for rxclk (16.67 MHz) -- divide by 3
        if (rx_counter == 2) begin
            rx_counter <= 0;
            rxclk_reg <= ~rxclk_reg;
        end else begin
            rx_counter <= rx_counter + 1;
        end

        // Divide for txclk (1 MHz) -- divide by 25
        if (tx_counter == 24) begin
            tx_counter <= 0;
            txclk_reg <= ~txclk_reg;
        end else begin
            tx_counter <= tx_counter + 1;
        end
    end

endmodule
