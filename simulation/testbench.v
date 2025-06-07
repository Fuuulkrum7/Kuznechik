`timescale 1ns / 1ps

module key_storage (
    input             clk,
    input      [127:0] data,      // записываемое значение (один ключ)
    input      [3:0]   wr_addr,   // адрес для записи
    input      [3:0]   rd_addr,   // адрес для чтения
    input              we,        // разрешение на запись
    output reg [127:0] q          // текущий ключ
);

    // Память на 16 строк по 128 бит
    reg [127:0] mem [0:15];

    initial begin
        mem[0] = 128'b0;
        mem[1] = 128'b0;
        mem[2] = 128'b0;
        mem[3] = 128'b0;
        mem[4] = 128'b0;
        mem[5] = 128'b0;
        mem[6] = 128'b0;
        mem[7] = 128'b0;
        mem[8] = 128'b0;
        mem[9] = 128'b0;
        mem[10] = 128'b0;
        mem[11] = 128'b0;
        mem[12] = 128'b0;
        mem[13] = 128'b0;
        mem[14] = 128'b0;
        mem[15] = 128'b0;
    end

    always @(posedge clk) begin
        if (we)
            mem[wr_addr] <= data;

        q <= mem[rd_addr];
    end

endmodule

module testbench;

    reg         ADC_CLK_10 = 0;
    reg         MAX10_CLK1_50 = 0;
    reg         MAX10_CLK2_50 = 0;
    reg  [1:0]  KEY = 2'b11;
    reg  [9:0]  SW = 10'b0;
    reg  [127:0] GPIO = 128'h000102030405060708090A0B0C0D0E0F;

    wire [127:0] LEDR;

    // Подключаем DUT (Device Under Test)
    crypto dut (
        .ADC_CLK_10      (ADC_CLK_10),
        .MAX10_CLK1_50   (MAX10_CLK1_50),
        .MAX10_CLK2_50   (MAX10_CLK2_50),
        .KEY             (KEY),
        .SW              (SW),
        .GPIO            (GPIO),
        .LEDR            (LEDR)
    );

    // Генерация тактового сигнала
    always #10 MAX10_CLK1_50 = ~MAX10_CLK1_50;  // 50 MHz
    always #50 ADC_CLK_10 = ~ADC_CLK_10;       // 10 MHz

    initial begin
        $display("==== Simulation run ====");
        $dumpfile("crypto_tb.vcd");  // для GTKWave
        $dumpvars(0, testbench);    

        // Сброс
        KEY = 2'b0;
        #100;
        KEY = 2'b11;

        // Инициализация ключа: выбор key0
        SW[0] = 0;
        #100;
        KEY = 2'b01;
        // Ждём пока сгенерируются ключи, заодно наблюдаем LEDR
        wait (dut.keyset == 0);
        #40;
        wait (dut.keyset == 0);
        SW[1] = 1;
        #20;
        SW[1] = 0;
        wait (dut.cipher_ready == 1);
        $display("=== Ready ===");
        $display("Result: %h", LEDR);

        #100;
        $finish;
    end

endmodule
