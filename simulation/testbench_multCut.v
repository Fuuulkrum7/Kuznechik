`timescale 1ns/1ps
module testbench_multCut;

reg  [7:0] a, c;
reg        b;
wire [7:0] c_res;

multCut uut (
    .a(a),
    .b(b),
    .c(c),
    .c_res(c_res)
);

initial begin
    a = 8'hAB;
    b = 1'b1;
    c = 8'hC4;
    #10;
    $display("c_res = %h", c_res);
    $finish;
end

endmodule
