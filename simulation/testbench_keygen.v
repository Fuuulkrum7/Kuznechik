`timescale 1ns/1ps
module testbench_keygen;

    reg clk;
    reg rst_n;
    reg en;
    reg [255:0] master_key;
    wire [255:0] round_keys;
    wire ready;
    wire full_ready;

    // Генерация тактового сигнала
    initial clk = 0;
    always #5 clk = ~clk;

    // DUT
    kuznechik_keygen uut (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .master_key(master_key),
        .round_keys(round_keys),
        .ready(ready),
        .full_ready(full_ready)
    );

    // Эталонные ключи
    reg [127:0] golden_keys [0:9];
    integer i;

    initial begin
        $dumpfile("keygen.vcd");
        $dumpvars(0, testbench_keygen);

        golden_keys[0] = 128'h8899aabbccddeeff0011223344556677;
        golden_keys[1] = 128'hfedcba98765432100123456789abcdef;
        golden_keys[2] = 128'h3e109d47585364fe5d26cab3b2b7c914;
        golden_keys[3] = 128'h6a269b36f206f2aae1af098362c121f8;
        golden_keys[4] = 128'h9bcc1b5e61128843f36cd956080387c0;
        golden_keys[5] = 128'h74f8409d5a1736e7885379deac07865b;
        golden_keys[6] = 128'h9348c8db728afe972b34becd46ae51d4;
        golden_keys[7] = 128'h12dce103ff645afe9e57ca72caed3978;
        golden_keys[8] = 128'habaa773101ed4d4609385e4335905ba3;
        golden_keys[9] = 128'h4c9131379210cebe999193858d73b40e;

        i = 0;
        rst_n = 0;
        en = 0;
        master_key = {128'h8899aabbccddeeff0011223344556677, 128'hfedcba98765432100123456789abcdef};

        #20 rst_n = 1;
        #10 en = 1;
    end

    // Проверка ключей при full_ready
    always @(posedge clk) begin
        if (rst_n && ready) begin
            $display("Round %0d:", i/2);
            $display("  DUT key1 = %h", round_keys[255:128]);
            $display("  DUT key2 = %h", round_keys[127:0]);

            if (round_keys[255:128] !== golden_keys[i] || round_keys[127:0] !== golden_keys[i+1]) begin
                $display("MISMATCH!");
                $display("  Expected key1 = %h", golden_keys[i]);
                $display("  Expected key2 = %h", golden_keys[i+1]);
                $finish;
            end else begin
                $display("PASS");
            end

            i = i + 2;
            if (i >= 10) begin
                $display("All keygen tests passed.");
                $finish;
            end
        end
    end

endmodule
