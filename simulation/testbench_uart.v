`timescale 1ns / 1ps

//-----------------------------------------------------------------------------
// Тестбенч
//-----------------------------------------------------------------------------
module tb_crypto_uart;
    // Порты
    reg         clk_50m = 0;
    reg         rst_n   = 0;
    reg         uart_rxd= 1;   // idle = 1
    wire        uart_txd;

    // Инстанцируем UUT
    crypto UUT (
        .clk     (clk_50m),
        .rst_n   (rst_n),
        .uart_rxd(uart_rxd),
        .uart_txd(uart_txd)
    );

    // Параметры UART
    localparam integer BIT_PERIOD = 8_695; // ≈1e9/115000 ns

    // Массив для приёма
    reg [7:0] received [0:15];
    integer i;

    // Тактовый генератор 50 MHz
    always #10 clk_50m = ~clk_50m;

    // Задача для отправки одного байта в RX
    task uart_send_byte(input [7:0] b);
        integer j;
        begin
            // start bit
            uart_rxd <= 1'b0;
            #(BIT_PERIOD);
            // data bits LSB first
            for (j = 0; j < 8; j = j + 1) begin
                uart_rxd <= b[j];
                #(BIT_PERIOD);
            end
            // stop bit
            uart_rxd <= 1'b1;
            #(BIT_PERIOD);
            // небольшой интервал
            #(BIT_PERIOD);
        end
    endtask

    // Задача для приёма одного байта из TX
    task uart_receive_byte(output [7:0] b);
        integer j;
        begin
            // дождаться старт-бита
            wait (uart_txd == 1'b0);
            // перейти к середине первого бита
            #(BIT_PERIOD/2);
            // считываем 8 бит
            for (j = 0; j < 8; j = j + 1) begin
                #(BIT_PERIOD);
                b[j] = uart_txd;
            end
            // пропускаем стоп-бит
            #(BIT_PERIOD);
        end
    endtask

    initial begin
        $dumpfile("uart_tb.vcd");  // для GTKWave
        $dumpvars(0, tb_crypto_uart);    
        // сброс
        #50 rst_n = 1;

        // немного подождать, пока UUT инициализируется и сгенерирует ключи
        # (20 * BIT_PERIOD);

        // передаём в UUT 16 байт: 0x00..0x0F
        for (i = 0; i < 16; i = i + 1) begin
            uart_send_byte(i[7:0]);
        end

        // ждём обработки (ключи + шифр)
        # (30 * BIT_PERIOD);

        // читаем обратно 16 байт
        for (i = 0; i < 16; i = i + 1) begin
            uart_receive_byte(received[i]);
        end

        // выводим результат
        $display("Echoed bytes:");
        for (i = 0; i < 16; i = i + 1) $write("%02h ", received[i]);
        $display;

        $finish;
    end

endmodule
