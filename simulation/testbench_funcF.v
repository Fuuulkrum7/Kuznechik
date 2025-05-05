`timescale 1ns/1ps
module testbench_funcF;

    reg clk = 0;
    reg rst_n = 0;
    reg put = 0;
    reg [127:0] key1, key2, C;
    wire [127:0] newKey1, newKey2;
    wire ready;

    funcF uut (
        .clk(clk),
        .rst_n(rst_n),
        .put(put),
        .key1(key1),
        .key2(key2),
        .C(C),
        .newKey1(newKey1),
        .newKey2(newKey2),
        .ready(ready)
    );

    always #5 clk = ~clk;

    reg [127:0] test_key1   [0:9];
    reg [127:0] test_key2   [0:9];
    reg [127:0] test_const  [0:9];
    reg [127:0] expected_k1 [0:9];
    reg [127:0] expected_k2 [0:9];

    initial begin
        $dumpfile("funcF.vcd");
        $dumpvars(0, testbench_funcF);

        // Векторы (дополнены до 10)
        test_key1[0]  = 128'hd9e047256309578daadaae77d4970c87;
        test_key2[0]  = 128'h4dc1bfb4f5aca3125b999bd5c3b40eda;
        test_const[0] = 128'h760f7f90b7ced61a743f47ac356e4718;
        expected_k1[0] = 128'hb2bba2f7a1a7f6a7b6430b57f3b59702;
        expected_k2[0] = 128'hd9e047256309578daadaae77d4970c87;

        test_key1[1]  = 128'h571428a2cf12aa9d73e0a3bbb1095882;
        test_key2[1]  = 128'he99b9a0816f8c15e7fce5660356f27a7;
        test_const[1] = 128'he738238bc1d2a68d57e29d26bb88a5b8;
        expected_k1[1] = 128'h21bb3cf65131e1bd30141d7357ec6e87;
        expected_k2[1] = 128'h571428a2cf12aa9d73e0a3bbb1095882;

        test_key1[2]  = 128'hd4f3d5b2d482046386ee546cf81e5832;
        test_key2[2]  = 128'he6e869b2e142743523a7847b40a2b455;
        test_const[2] = 128'hd5052b85575d3de736e902037f47ed00;
        expected_k1[2] = 128'hb1cbe0b1e490936ca1ae0bec46afa966;
        expected_k2[2] = 128'hd4f3d5b2d482046386ee546cf81e5832;

        test_key1[3]  = 128'hd0aaa0dbb822f51b74457907e1d1f6ed;
        test_key2[3]  = 128'h63b7f9fc49f1875d53cf9994606dd068;
        test_const[3] = 128'hec722c649fa21b5307bf73f3d3d3e98f;
        expected_k1[3] = 128'h1dec941b43a761dbd31d6ddb62713e45;
        expected_k2[3] = 128'hd0aaa0dbb822f51b74457907e1d1f6ed;

        test_key1[4]  = 128'h4342d2e73553d037c8a06c27e523b33b;
        test_key2[4]  = 128'h34bbf4a0708ae111ead83ef995f25dd6;
        test_const[4] = 128'h3d53fa4703ab8fb74afde6330ca037db;
        expected_k1[4] = 128'h228cb220f6e66541fe75e894882878da;
        expected_k2[4] = 128'h4342d2e73553d037c8a06c27e523b33b;

        test_key1[5]  = 128'h10201674afdedc44dd62b6519fbccbe0;
        test_key2[5]  = 128'h44dc1aca009a47a8037443a954945959;
        test_const[5] = 128'hdd56dfcf441b5804d9ffa9643a7742b9;
        expected_k1[5] = 128'hdbc1597e5b63dcc9fa6a90904bc8d696;
        expected_k2[5] = 128'h10201674afdedc44dd62b6519fbccbe0;

        test_key1[6]  = 128'haf7e1b8eae365904b7e59eab5cfeb86c;
        test_key2[6]  = 128'haab24606970544eb686ac29a94e3d6fd;
        test_const[6] = 128'hea17018af2c93c75a57def89d0a88ce1;
        expected_k1[6] = 128'hc8f8ce65fe9a237a68a9e6c0173701ba;
        expected_k2[6] = 128'haf7e1b8eae365904b7e59eab5cfeb86c;

        test_key1[7]  = 128'h37e6d0e97d94d8ebffb4314608c1f457;
        test_key2[7]  = 128'h168ddb72e997a0f73be23f680bd7ba26;
        test_const[7] = 128'hf1af9f9e5b14c3eadfe9abbc2c82ff35;
        expected_k1[7] = 128'hb34e66bf61b76ffbba4a4078a5b4f6f5;
        expected_k2[7] = 128'h37e6d0e97d94d8ebffb4314608c1f457;

        test_key1[8]  = 128'hbdf9212b6014ad877af12f251b0a5f81;
        test_key2[8]  = 128'ha16ec27bb50ca7574780fe404941ef41;
        test_const[8] = 128'h329891693bdfd1ceffabc6e696f8a307;
        expected_k1[8] = 128'h063b168e02b21d2bde8ff2325a28e54f;
        expected_k2[8] = 128'hbdf9212b6014ad877af12f251b0a5f81;

        test_key1[9]  = 128'h1cab3ee7e559ac90480298031de88257;
        test_key2[9]  = 128'h2be066e12c379730b9a9e1532e809613;
        test_const[9] = 128'h6921aac09e7ddcfd6af42b7e429f27f5;
        expected_k1[9] = 128'hf8361a8676f827f749bdc95ff2cce903;
        expected_k2[9] = 128'h1cab3ee7e559ac90480298031de88257;

        rst_n = 0;
        #5 rst_n = 1;
    end

    integer in_step = 0;
    integer out_step = 0;

    always @(posedge clk) begin
        // Подаём новые входы каждый такт
        if (in_step < 10) begin
            key1 <= test_key1[in_step];
            key2 <= test_key2[in_step];
            C    <= test_const[in_step];
            put  <= 1;
            in_step <= in_step + 1;
        end else begin
            put <= 0;
        end

        // Проверка, как только ready
        if (ready) begin
            $display("Test %0d: newKey1 = %h, newKey2 = %h", out_step, newKey1, newKey2);
            if (newKey1 !== expected_k1[out_step] || newKey2 !== expected_k2[out_step]) begin
                $display("MISMATCH at test %0d!", out_step);
                $display("Expected newKey1 = %h", expected_k1[out_step]);
                $display("Got      newKey1 = %h", newKey1);
                $display("Expected newKey2 = %h", expected_k2[out_step]);
                $display("Got      newKey2 = %h", newKey2);
                $fatal;
            end
            out_step <= out_step + 1;
        end

        if (out_step == 10) begin
            $display("All funcF pipelined tests passed.");
            $finish;
        end
    end

endmodule
