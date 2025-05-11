// Fixed UART Transmitter
module uarttx(
    input wire clk,
    input wire rst,  // Added reset signal
    output reg txd
);
    // States
    localparam IDLE = 2'b00;
    localparam START = 2'b01;
    localparam DATA = 2'b10;
    localparam STOP = 2'b11;
    
    reg [1:0] state = IDLE;
    reg [7:0] data = 8'b00110011;  // Fixed data to transmit
    reg [2:0] bit_counter = 0;     // Counts 0-7 for data bits
    
    // Initialize output to idle state
    initial begin
        txd = 1;
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            txd <= 1;           // Idle state
            state <= IDLE;
            bit_counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    txd <= 1;           // Ensure line is high in idle
                    bit_counter <= 0;
                    state <= START;     // Immediately start transmission
                end
                
                START: begin
                    txd <= 0;           // Send start bit
                    state <= DATA;
                end
                
                DATA: begin
                    txd <= data[bit_counter]; // Send data bits
                    
                    if (bit_counter == 7) begin
                        bit_counter <= 0;
                        state <= STOP;
                    end else begin
                        bit_counter <= bit_counter + 1;
                    end
                end
                
                STOP: begin
                    txd <= 1;           // Send stop bit
                    state <= IDLE;      // Go back to idle/restart
                end
            endcase
        end
    end
endmodule

// Fixed UART Receiver
module uartrx(
    input wire clk,
    input wire rst,  // Added reset signal
    input wire rxd,
    output reg rxOut,
    output reg [7:0] datareg
);
    // States
    localparam IDLE = 2'b00;
    localparam START = 2'b01;
    localparam DATA = 2'b10;
    localparam STOP = 2'b11;
    
    reg [1:0] state = IDLE;
    reg [7:0] temp_data = 0;
    reg [2:0] bit_counter = 0;  // Counts 0-7 for data bits
    
    // Initialize output
    initial begin
        rxOut = 0;
        datareg = 8'h00;
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            bit_counter <= 0;
            temp_data <= 8'h00;
            rxOut <= 0;
        end else begin
            case (state)
                IDLE: begin
                    rxOut <= 0;
                    if (rxd == 0) begin     // Detect start bit
                        state <= START;
                    end
                end
                
                START: begin
                    // Validate start bit in the middle of bit time
                    // This would normally have a counter to sample at the center
                    // Here we're assuming the clock is already synchronized
                    if (rxd == 0) begin
                        state <= DATA;
                        bit_counter <= 0;
                    end else begin
                        state <= IDLE;      // False start, go back to idle
                    end
                end
                
                DATA: begin
                    // Sample data in the middle of the bit time
                    temp_data[bit_counter] <= rxd;
                    
                    if (bit_counter == 7) begin
                        bit_counter <= 0;
                        state <= STOP;
                    end else begin
                        bit_counter <= bit_counter + 1;
                    end
                end
                
                STOP: begin
                    if (rxd == 1) begin     // Validate stop bit
                        datareg <= temp_data;  // Output received data
                        rxOut <= 1;            // Indicate valid data
                        state <= IDLE;
                    end else begin
                        state <= IDLE;      // Error in stop bit, return to idle anyway
                    end
                end
            endcase
        end
    end
endmodule

// Fixed Top Module
module topModule(
    input wire clk,
    input wire rst,    // Added reset signal
    output wire rxclk,
    output wire txclk,
    output wire txd,
    input wire rxd,
    output wire rxOut,
    output wire [7:0] datareg
);

    // Instantiate receiver and transmitter with reset
    uartrx rx (
        .clk(rxclk),
        .rst(rst),
        .rxd(rxd),
        .rxOut(rxOut),
        .datareg(datareg)
    );

    uarttx tx (
        .clk(txclk),
        .rst(rst),
        .txd(txd)
    ); 

    // Clock divider logic
    reg [5:0] rx_counter = 0;
    reg [5:0] tx_counter = 0;
    reg rxclk_reg = 0;
    reg txclk_reg = 0;

    assign rxclk = rxclk_reg;
    assign txclk = txclk_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rx_counter <= 0;
            tx_counter <= 0;
            rxclk_reg <= 0;
            txclk_reg <= 0;
        end else begin
            // Generate rxclk: 115200 baud
            if (rx_counter == 2) begin
                rx_counter <= 0;
                rxclk_reg <= ~rxclk_reg;
            end else begin
                rx_counter <= rx_counter + 1;
            end

            // Generate txclk: 9600 baud
            if (tx_counter == 24) begin
                tx_counter <= 0;
                txclk_reg <= ~txclk_reg;
            end else begin
                tx_counter <= tx_counter + 1;
            end
        end
    end
endmodule