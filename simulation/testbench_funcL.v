`timescale 1ns/1ps
module testbench_funcL;

    reg clk = 0;
    reg rst_n;
    reg put;
    reg [127:0] data;
    wire [127:0] res;
    wire ready;

    funcL uut (
        .clk(clk),
        .rst_n(rst_n),
        .put(put),
        .data(data),
        .res(res),
        .ready(ready)
    );

    always #5 clk = ~clk;

    // Входные и ожидаемые значения
    reg [127:0] test_data    [0:19];
    reg [127:0] expected_res [0:19];


    initial begin
        // init
        $dumpfile("funcL.vcd");
        $dumpvars(0, testbench_funcL);
        rst_n = 0;

        // Инициализация тестов
        test_data[0]  = 128'ha8a6e3278a34e73b05a5a265c33d7c87;
        expected_res[0]  = 128'h1ff7b2622da0f36f2226f858d281cfd7;
        test_data[1]  = 128'hbcaa2eaf3fcf77d25cfe190985445843;
        expected_res[1]  = 128'h3cd89e9b959cfa52ebf2a020d01875ba;
        test_data[2]  = 128'h38ad759a5261bf51f9f1b23a2009489c;
        expected_res[2]  = 128'hb37c79e8281937517309b4fe6dfa1146;
        test_data[3]  = 128'hcaab27886549b449a24a871e8e2e3921;
        expected_res[3]  = 128'hfc11c934bd22a5804a017130433e3df3;
        test_data[4]  = 128'hbbf8580f41d12614e39f9269ef598d5a;
        expected_res[4]  = 128'haed8e65eb9a14937f3d4f7082f24dfe6;
        test_data[5]  = 128'hbc8abb1fa53b8451d3c92cef764b1b91;
        expected_res[5]  = 128'h85baf783514c99e54bb32dfb70df0e0d;
        test_data[6]  = 128'h1e9bedb5e3c908e10cdac0be72b07877;
        expected_res[6]  = 128'h4c00789154160c5909e350f1ead0fcb9;
        test_data[7]  = 128'h59349f6f855ff6cea702af24e0d93f47;
        expected_res[7]  = 128'h3e25be671a5adc1160cec4b30076e037;
        test_data[8]  = 128'h0ad780c8161c78d52b8a7f6643580bfd;
        expected_res[8]  = 128'h3fa5975d606193d87c9f0ae5163a2b12;
        test_data[9]  = 128'h63b40fe0c6b3ee476c1f990f392a13c5;
        expected_res[9]  = 128'h87d4e9e4703a1ba637a9628fbe479d96;
        test_data[10] = 128'h3a25d75eb3a66766074d1c10ec413639;
        expected_res[10] = 128'h735e2b8b008bf6c0978367279b08e142;
        test_data[11] = 128'h7bc3af32170cefa3443770d8952281c2;
        expected_res[11] = 128'h1794f44196170dac78a04f8215a96405;
        test_data[12] = 128'h60408c3e0649a16aeda504210aea289b;
        expected_res[12] = 128'h231adcd481bd64eea4675ba2a7c9040c;
        test_data[13] = 128'h28e1d453e7d772923c2c49acc344cc36;
        expected_res[13] = 128'h8593b78d26e0ade7ffb7880bd71ff43c;
        test_data[14] = 128'h24be9e7dbd254470123a3b60816d5a5b;
        expected_res[14] = 128'h757359da487e18d51c7cb1f259e440e4;
        test_data[15] = 128'ha0bca5f922df3b4e664d5268d0786749;
        expected_res[15] = 128'h98be8cd2b4bd3c09ffefb4dd15a3f0d9;
        test_data[16] = 128'h81d05fa80c422d88e959e5383b815d14;
        expected_res[16] = 128'hdaba1b1025206b843e3906c0585f2cb7;
        test_data[17] = 128'h24e726a8ac44cf9ab0ced880798984cb;
        expected_res[17] = 128'h2aa42ef9d1f7254a39b89b72ba7dde0b;
        test_data[18] = 128'hf76597495958e1c39ff0bb24a4ad41b6;
        expected_res[18] = 128'h982b8ee3fb0f9de59725c26e4208f9bc;
        test_data[19] = 128'ha2aa393e80ae7f1251b6195f617805ca;
        expected_res[19] = 128'h531c930fa081793d35c3bf11df7941e8;
        
        #15; rst_n = 1;
    end

    integer step = 0;
    integer total_tests = 20;  

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            step = 0;
            data = 128'h0;
            put <= 1'b0;
        end
        else begin
            step <= step + 1;
            // Подача входов каждый такт
            if (step < total_tests) begin
                put <= 1'b1;
                data <= test_data[step];
            end else begin
                data <= 128'h0;
                put <= 1'b0;
            end
        end

        // Проверка результата с задержкой в 16 тактов
        if (step >= 17 && step - 17 < total_tests) begin
            $display("Test %0d: res = %h", step - 17, res);
            if (res !== expected_res[step - 17]) begin
                $display("MISMATCH at test %0d!", step - 17);
                $display("Expected: %h", expected_res[step - 17]);
                $display("Got     : %h", res);
                $fatal;
            end
        end

        if (step == total_tests + 17) begin
            $display("All funcL pipeline tests passed.");
            $finish;
        end
    end 

endmodule
