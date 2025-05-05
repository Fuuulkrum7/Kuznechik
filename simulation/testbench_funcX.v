`timescale 1ns/1ps
module testbench_funcX;

reg  [127:0] a, b;
wire [127:0] res;

funcX uut (
    .a(a),
    .b(b),
    .res(res)
);

initial begin
    a = 128'hFF00FF00FF00FF00FF00FF00FF00FF00;
    b = 128'h00FF00FF00FF00FF00FF00FF00FF00FF;
    #10;
    $display("res = %h", res);
    $finish;
end

endmodule
