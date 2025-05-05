`timescale 1ns/1ps
module testbench_cypher;

    reg clk = 0;
    reg rst_n;
    reg en;
    reg [127:0] in_data;
    reg [127:0] round_key;
    reg key_valid;

    wire key_next;
    wire [127:0] out_data;
    wire ready;

    reg [3:0] i;
    reg [127:0] keys [0:9];
    reg [127:0] expected_out;
    reg started;
    reg done;

    // DUT
    kuznechik_encrypt uut (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .in_data(in_data),
        .round_key(round_key),
        .key_valid(key_valid),
        .key_next(key_next),
        .out_data(out_data),
        .ready(ready)
    );

    initial begin
        $dumpfile("encrypt.vcd");
        $dumpvars(0, testbench_cypher);

        // Инициализация
        clk = 0;
        rst_n = 0;
        en = 0;
        key_valid = 0;
        round_key = 0;
        started = 0;
        done = 0;

        // Ключи
        keys[0] = 128'h8899aabbccddeeff0011223344556677;
        keys[1] = 128'hfedcba98765432100123456789abcdef;
        keys[2] = 128'h6695d4f92056eab6e71c12219c9d2985;
        keys[3] = 128'h7cba26054c626abc10694046b8c9c085;
        keys[4] = 128'h5ee744d7c59c793feef5678f0ed740b5;
        keys[5] = 128'ha719897cbc49f900aabd4c4d641c1114;
        keys[6] = 128'h6c1b10e4ef6fcd340e08b0799a350417;
        keys[7] = 128'h4c6ba756c0557fc347f34772b54ee010;
        keys[8] = 128'hc0499ca0375278e32a2b448cccd7b0e8;
        keys[9] = 128'h51af7cee105341709be49b5570871798;

        // Ожидаемый результат
        expected_out = 128'h8420b74e80d58e6c6dbac4ee0f1c408f;

        #12 rst_n = 1;
    end

    always #5 clk = ~clk;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 0;
            en <= 0;
            key_valid <= 0;
            in_data <= 0;
            round_key <= 0;
            started <= 0;
            done <= 0;
        end else begin
            // Старт шифрования
            key_valid <= 0;
            if (!started) begin
                in_data <= 128'h1122334455667700ffeeddccbbaa9988;
                en <= 1;
                started <= 1;
            end

            // Подать следующий ключ при key_next
            if (key_next && i < 10) begin
                round_key <= keys[i];
                key_valid <= 1;
                i <= i + 1;
            end

            // Проверка результата
            if (ready && !done) begin
                $display("Encrypted: %h", out_data);
                if (out_data === expected_out) begin
                    $display("Encryption result correct.");
                end else begin
                    $display("Encryption mismatch!");
                    $display("Expected: %h", expected_out);
                    $display("Got     : %h", out_data);
                    $fatal;
                end
                done <= 1;
                $finish;
            end
        end
    end

endmodule
