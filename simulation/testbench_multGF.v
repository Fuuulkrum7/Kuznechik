`timescale 1ns/1ps
module testbench_multGF;

reg  [7:0] a, b;
wire [7:0] c;

multGF uut (
    .a(a),
    .b(b),
    .c(c)
);

integer i;
reg [7:0] test_a   [0:19];
reg [7:0] test_b   [0:19];
reg [7:0] expected [0:19];

initial begin
    // Тестовые входные значения и эталонные выходы (c = a * b в GF(2^8))
    test_a[0]  = 8'h57; test_b[0]  = 8'h83; expected[0]  = 8'hF2;
    test_a[1]  = 8'hAB; test_b[1]  = 8'hC4; expected[1]  = 8'hB2;
    test_a[2]  = 8'h01; test_b[2]  = 8'h01; expected[2]  = 8'h01;
    test_a[3]  = 8'hFF; test_b[3]  = 8'hFF; expected[3]  = 8'h06;
    test_a[4]  = 8'h00; test_b[4]  = 8'h00; expected[4]  = 8'h00;
    test_a[5]  = 8'h80; test_b[5]  = 8'h80; expected[5]  = 8'h77;
    test_a[6]  = 8'h1D; test_b[6]  = 8'hE3; expected[6]  = 8'hD5;
    test_a[7]  = 8'hA5; test_b[7]  = 8'h5A; expected[7]  = 8'hA4;
    test_a[8]  = 8'hC3; test_b[8]  = 8'h7E; expected[8]  = 8'hD8;
    test_a[9]  = 8'hBE; test_b[9]  = 8'hEF; expected[9]  = 8'hE4;

    test_a[10] = 8'h10; test_b[10] = 8'h20; expected[10] = 8'h45;
    test_a[11] = 8'h22; test_b[11] = 8'h11; expected[11] = 8'h47;
    test_a[12] = 8'h33; test_b[12] = 8'h66; expected[12] = 8'h98;
    test_a[13] = 8'h77; test_b[13] = 8'h88; expected[13] = 8'h58;
    test_a[14] = 8'hAA; test_b[14] = 8'h55; expected[14] = 8'hBD;
    test_a[15] = 8'h39; test_b[15] = 8'hE7; expected[15] = 8'h6B;
    test_a[16] = 8'hA6; test_b[16] = 8'h74; expected[16] = 8'h46;
    test_a[17] = 8'hD2; test_b[17] = 8'hE6; expected[17] = 8'h12;
    test_a[18] = 8'hF4; test_b[18] = 8'hB4; expected[18] = 8'h6A;
    test_a[19] = 8'hC0; test_b[19] = 8'hD1; expected[19] = 8'h87;

    // Прогон тестов
    for (i = 0; i < 20; i = i + 1) begin
        a = test_a[i];
        b = test_b[i];
        #10;
        $display("Test %0d: a = %h, b = %h => c = %h", i, a, b, c);
        if (c !== expected[i]) begin
            $display("MISMATCH at test %0d!", i);
            $display("Expected: c = %h", expected[i]);
            $display("Got:      c = %h", c);
            $fatal;
        end
    end

    $display("All multGF tests passed.");
    $finish;
end

endmodule
