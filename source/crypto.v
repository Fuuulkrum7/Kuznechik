module crypto (
    input  wire        clk,        // 50 MHz system clock
    input  wire        rst_n,      // active-low reset
    input  wire        uart_rxd,   // UART RX
    output wire        uart_txd    // UART TX
);

    //-------------------------------------------------------------------------
    // UART parameters
    //-------------------------------------------------------------------------
    localparam BIT_RATE     = 115000;
    localparam CLK_HZ       = 50_000_000;
    localparam PAYLOAD_BITS = 8;
    localparam STOP_BITS    = 1;

    //-------------------------------------------------------------------------
    // UART RX interface
    //-------------------------------------------------------------------------
    wire                       rx_valid;
    wire                       rx_break;
    wire [PAYLOAD_BITS - 1:0]  rx_data_bus;
    wire [7:0]                 rx_data = rx_data_bus[7:0];

    //-------------------------------------------------------------------------
    // UART TX interface
    //-------------------------------------------------------------------------
    reg   [7:0]            tx_data;
    reg                    tx_en;
    wire                   tx_busy;

    //-------------------------------------------------------------------------
    // Crypto interface signals
    //-------------------------------------------------------------------------
    reg    start_key;       // KEY[1] — первичный запуск вычисления ключей
    reg    put;             // SW[1] — put в конвейер
    reg    selector_key;    // SW[0] — выбор ключа (0 или 1)

    wire [1:0] KEY = { start_key, rst_n };                // {KEY[1], KEY[0]}
    wire [1:0] SW  = { put, selector_key };               // SW[1]=put, SW[0]=sel

    reg  [127:0] block_in;
    reg  [127:0] block_out;
    wire [127:0] LEDR;
    wire         cipher_ready;
    wire         keys_ready;

    //-------------------------------------------------------------------------
    // Instantiate UART receiver
    //-------------------------------------------------------------------------
    uart_rx #(
        .BIT_RATE     (BIT_RATE),
        .CLK_HZ       (CLK_HZ),
        .PAYLOAD_BITS (PAYLOAD_BITS),
        .STOP_BITS    (STOP_BITS)
    ) uart_rx_inst (
        .clk           (clk),
        .resetn        (rst_n),
        .uart_rxd      (uart_rxd),
        .uart_rx_en    (1'b1),
        .uart_rx_break (rx_break),
        .uart_rx_valid (rx_valid),
        .uart_rx_data  (rx_data_bus)
    );

    //-------------------------------------------------------------------------
    // Instantiate UART transmitter
    //-------------------------------------------------------------------------
    uart_tx #(
        .BIT_RATE     (BIT_RATE),
        .CLK_HZ       (CLK_HZ),
        .PAYLOAD_BITS (PAYLOAD_BITS),
        .STOP_BITS    (STOP_BITS)
    ) uart_tx_inst (
        .clk          (clk),
        .resetn       (rst_n),
        .uart_txd     (uart_txd),
        .uart_tx_busy (tx_busy),
        .uart_tx_en   (tx_en),
        .uart_tx_data (tx_data)
    );

    //-------------------------------------------------------------------------
    // Instantiate crypto_simle
    //-------------------------------------------------------------------------
    crypto_simle dut (
        .MAX10_CLK1_50 (clk),
        .KEY           (KEY),
        .SW            (SW),
        .GPIO          (block_in),
        .LEDR          (LEDR),
        .cipher_ready  (cipher_ready),
        .keys_ready    (keys_ready)
    );

    //-------------------------------------------------------------------------
    // FSM states
    //-------------------------------------------------------------------------
    localparam
        S_INIT_KEY    = 3'd0,
        S_WAIT_KEYS   = 3'd1,
        S_RECEIVE     = 3'd2,
        S_PUT         = 3'd3,

        S_WAIT_CIPHER = 3'd1,
        S_SEND        = 3'd2;

    reg [1:0] state, state_send;
    reg [3:0] in_cnt, send_cnt;

    //-------------------------------------------------------------------------
    // Control FSM
    //-------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // async reset
            state         <= S_INIT_KEY;
            in_cnt        <= 4'd0;
            block_in      <= 128'd0;
            start_key     <= 1'b0;
            put           <= 1'b0;
            selector_key  <= 1'b0;  // по умолчанию ключ 0
        end else begin
            // default: однократные импульсы сбрасываем
            start_key <= 1'b0;
            put       <= 1'b0;

            case (state)
                S_INIT_KEY: begin
                    start_key <= 1'b1;      // один такт запускаем генерацию ключей
                    state     <= S_WAIT_KEYS;
                end

                S_WAIT_KEYS: begin
                    if (keys_ready) begin
                        in_cnt <= 4'd0;
                        state  <= S_RECEIVE;
                    end
                end

                S_RECEIVE: begin
                    if (rx_valid) begin
                        // сдвигаем в буфер
                        block_in <= { block_in[119:0], rx_data };
                        in_cnt   <= in_cnt + 1;
                        if (in_cnt == 4'd15) begin
                            put    <= 1'b1;      // SW[1] = 1
                            in_cnt <= 4'h0;
                            // we stay in this state
                        end
                    end
                end

                default: state <= S_INIT_KEY;
            endcase
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_send    <= S_WAIT_CIPHER;
            block_out     <= 128'b0;
            send_cnt      <= 4'd0;
            tx_data       <= 8'd0;
            tx_en         <= 1'b0;
        end else begin
            // default: однократные импульсы сбрасываем
            tx_en     <= 1'b0;

            case (state_send)
                S_WAIT_CIPHER: begin
                    if (cipher_ready) begin
                        send_cnt       <= 4'd0;
                        state_send     <= S_SEND;
                        block_out      <= LEDR;
                    end
                end

                S_SEND: begin
                    if (!tx_busy) begin
                        tx_data  <= block_out[127 - send_cnt*8 -: 8];
                        tx_en    <= 1'b1;
                        send_cnt <= send_cnt + 1;
                        if (send_cnt == 4'd15) begin
                            state_send <= S_WAIT_CIPHER;
                        end
                    end
                end

                default: state_send <= S_WAIT_CIPHER;
            endcase
        end
    end

endmodule
