`timescale 1ns/1ps
module testbench_funcS;

reg  [127:0] s;
wire [127:0] res;

funcS uut (
    .s(s),
    .res(res)
);

initial begin
    s = 128'h0123456789abcdef0011223344556677;
    #10;
    $display("res = %h", res);
    $finish;
end

endmodule
