`timescale 1ns/1ps
module testbench_multPart;

reg  [7:0] a, c;
reg        b;
wire [7:0] a_res, c_res;

multPart uut (
    .a(a),
    .b(b),
    .c(c),
    .a_res(a_res),
    .c_res(c_res)
);

integer i;
reg [7:0] test_a     [0:19];
reg [7:0] test_c     [0:19];
reg [7:0] expected_a [0:19];
reg [7:0] expected_c [0:19];

initial begin
    // Входные данные
    test_a[0]  = 8'h00; test_c[0]  = 8'h00;
    test_a[1]  = 8'h01; test_c[1]  = 8'h01;
    test_a[2]  = 8'h02; test_c[2]  = 8'h03;
    test_a[3]  = 8'h03; test_c[3]  = 8'h07;
    test_a[4]  = 8'h10; test_c[4]  = 8'h20;
    test_a[5]  = 8'h20; test_c[5]  = 8'h30;
    test_a[6]  = 8'h40; test_c[6]  = 8'h50;
    test_a[7]  = 8'h80; test_c[7]  = 8'h81;
    test_a[8]  = 8'hC0; test_c[8]  = 8'hC3;
    test_a[9]  = 8'hFF; test_c[9]  = 8'h00;
    test_a[10] = 8'h57; test_c[10] = 8'h83;
    test_a[11] = 8'hAB; test_c[11] = 8'hC4;
    test_a[12] = 8'hE0; test_c[12] = 8'h0F;
    test_a[13] = 8'h01; test_c[13] = 8'hFF;
    test_a[14] = 8'h11; test_c[14] = 8'h22;
    test_a[15] = 8'h22; test_c[15] = 8'h44;
    test_a[16] = 8'h33; test_c[16] = 8'h66;
    test_a[17] = 8'h77; test_c[17] = 8'h88;
    test_a[18] = 8'hAA; test_c[18] = 8'h55;
    test_a[19] = 8'hBE; test_c[19] = 8'hEF;

    // Ожидаемые значения (пересчитанные корректно)
    expected_a[0]  = 8'h00; expected_c[0]  = 8'h00;
    expected_a[1]  = 8'h02; expected_c[1]  = 8'h00;
    expected_a[2]  = 8'h04; expected_c[2]  = 8'h01;
    expected_a[3]  = 8'h06; expected_c[3]  = 8'h04;
    expected_a[4]  = 8'h20; expected_c[4]  = 8'h30;
    expected_a[5]  = 8'h40; expected_c[5]  = 8'h10;
    expected_a[6]  = 8'h80; expected_c[6]  = 8'h10;
    expected_a[7]  = 8'hC3; expected_c[7]  = 8'h01;
    expected_a[8]  = 8'h43; expected_c[8]  = 8'h03;
    expected_a[9]  = 8'h3D; expected_c[9]  = 8'hFF;
    expected_a[10] = 8'hAE; expected_c[10] = 8'hD4;
    expected_a[11] = 8'h95; expected_c[11] = 8'h6F;
    expected_a[12] = 8'h03; expected_c[12] = 8'hEF;
    expected_a[13] = 8'h02; expected_c[13] = 8'hFE;
    expected_a[14] = 8'h22; expected_c[14] = 8'h33;
    expected_a[15] = 8'h44; expected_c[15] = 8'h66;
    expected_a[16] = 8'h66; expected_c[16] = 8'h55;
    expected_a[17] = 8'hEE; expected_c[17] = 8'hFF;
    expected_a[18] = 8'h97; expected_c[18] = 8'hFF;
    expected_a[19] = 8'hBF; expected_c[19] = 8'h51;

    b = 1'b1;

    for (i = 0; i < 20; i = i + 1) begin
        a = test_a[i];
        c = test_c[i];
        #10;
        $display("Test %0d: a = %h, c = %h => a_res = %h, c_res = %h", i, a, c, a_res, c_res);

        if (a_res !== expected_a[i] || c_res !== expected_c[i]) begin
            $display("MISMATCH at test %0d!", i);
            $display("Expected: a_res = %h, c_res = %h", expected_a[i], expected_c[i]);
            $display("Got:      a_res = %h, c_res = %h", a_res, c_res);
            $fatal;
        end
    end

    $display("All multPart tests passed.");
    $finish;
end

endmodule
