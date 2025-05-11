module uarttx(
    input wire clk,
    output reg txd
);
    initial begin
        txd = 1; // Idle state is high
    end

    reg [7:0] data = 8'b10101000;  // fixed data
    reg [3:0] count = 0;  

    always @(posedge clk) begin

        if (count <= 8) begin
            if(count==0)begin
                txd <=0;  // Start bit
            end else if(count==9)begin
                txd <=1;  // Stop bit
            end else begin
                txd <= data[count-1];  // Send out bits one by one
            end
            count <= count + 1;
        end else begin
            txd <= 1;  // After 8 bits, keep pulse high
            //count <= 0;  // Reset count to send again
        end
    end
endmodule
    
module uartrx(
    input wire clk,
    input wire rxd,
    output reg  rxOut,
    output reg [7:0] datareg
);

    reg [7:0] tempData = 0;
    reg [3:0] count = 0;
    reg [6:0] tempCounter = 0; 
    reg [3:0] intCount = 0; 
    reg dataReady = 0;

    always @(posedge clk) begin
			rxOut <= rxd; 
        if (!dataReady && rxd == 0) begin
            if (tempCounter == 3) begin
					datareg<=0;
                dataReady <= 1;
                tempCounter <= 0;
                intCount <= 0;
            end else begin
                tempCounter <= tempCounter + 1;
            end

        end else if (dataReady) begin
                 // Reset tempCounter for next bit
                if (tempCounter == 7) begin
							datareg<=rxd;
                    tempData[count] <= rxd;
                    count <= count + 1;
                    tempCounter <= 0;
                    intCount <= 0;
                end else begin
                    tempCounter <= tempCounter + 1;
                end

                if (count == 8) begin
                    datareg <= tempData; // Output full byte
                    count <= 0;
                    dataReady <= 0;
                    tempCounter <= 0;
                end

        end
    end
endmodule



module topModule(
    input wire clk,
    output wire rxclk,
    output wire txclk,
    output wire txd,
    input wire rxd,
    output wire rxOut,
    output wire [7:0] datareg

);

    // Instantiate receiver and transmitter
    uartrx rx (
        .clk(rxclk),
        .rxd(rxd),
        .rxOut(rxOut),
        .datareg(datareg)
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
        // Generate rxclk: 115200 baud
        if (rx_counter == 1) begin
            rx_counter <= 0;
            rxclk_reg <= ~rxclk_reg;
        end else begin
            rx_counter <= rx_counter + 1;
        end

        // Generate txclk: 9600 baud
        if (tx_counter == 15) begin
            tx_counter <= 0;
            txclk_reg <= ~txclk_reg;
        end else begin
            tx_counter <= tx_counter + 1;
        end
    end
endmodule
