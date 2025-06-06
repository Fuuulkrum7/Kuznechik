// `include "Lut.v"
// `define BIG_ENDIAN


module funcX # (
    parameter WIDTH = 128
) (
    input  [WIDTH - 1 : 0] a,
    input  [WIDTH - 1 : 0] b,
    output [WIDTH - 1 : 0] res
);

    assign res = a ^ b;

endmodule

module funcS(
    input [127:0] s,
    output [127:0] res
);

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin: inst_s
            kuznechik_s inst_s (
                .code ( s  [(i + 1) * 8 - 1 : i * 8] ),
                .res  ( res[(i + 1) * 8 - 1 : i * 8] )
            );
        end
    endgenerate

endmodule

module funcReverseS(
    input [127:0] s,
    output [127:0] res
);

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin: inst_s
            kuznechik_reverse_s inst_s (
                .code ( s  [(i + 1) * 8 - 1 : i * 8] ),
                .res  ( res[(i + 1) * 8 - 1 : i * 8] )
            );
        end
    endgenerate

endmodule

module multPart(
    input  [7:0] a,
    input        b,
    input  [7:0] c,
    output [7:0] a_res,
    output [7:0] c_res
);

    wire [8:0] a_shift = { a, 1'b0 };
    assign c_res = c ^ (a & { 8{b} });
    assign a_res = a_shift[7:0] ^ ( { 8{ a[7] } } & 8'hc3);

endmodule

module multCut(
    input  [7:0] a,
    input        b,
    input  [7:0] c,
    output [7:0] c_res
);

    assign c_res = c ^ (a & { 8{b} });

endmodule

module multGF(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] c
);
    wire [7:0] buf_a [0:7];
    wire [7:0] buf_c [0:8];

    assign buf_a[0] = a;
    assign buf_c[0] = 8'b0;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin: instPart
            if (i < 7) begin
                multPart inst(
                    buf_a[i],
                    b[i],
                    buf_c[i],
                    buf_a[i + 1],
                    buf_c[i + 1]
                );
            end
            else begin
                multCut inst(
                    buf_a[i],
                    b[i],
                    buf_c[i],
                    buf_c[i + 1]
                );
            end
        end
    endgenerate

    assign c = buf_c[8];

endmodule

module funcR(
    input  logic        clk,
    input  logic        rst_n,
    input  logic [127:0] state,
    output logic [127:0] res
);

    // Константы для L-функции (ГОСТ)
    logic [7:0] l_vec [0:15];

    assign l_vec[ 0] = 8'h01;
    assign l_vec[ 1] = 8'h94;
    assign l_vec[ 2] = 8'h20;
    assign l_vec[ 3] = 8'h85;
    assign l_vec[ 4] = 8'h10;
    assign l_vec[ 5] = 8'hC2;
    assign l_vec[ 6] = 8'hC0;
    assign l_vec[ 7] = 8'h01;
    assign l_vec[ 8] = 8'hFB;
    assign l_vec[ 9] = 8'h01;
    assign l_vec[10] = 8'hC0;
    assign l_vec[11] = 8'hC2;
    assign l_vec[12] = 8'h10;
    assign l_vec[13] = 8'h85;
    assign l_vec[14] = 8'h20;
    assign l_vec[15] = 8'h94;

    logic [7:0] a_15   [0:15];
    logic [7:0] a_xor  [0:16];

    assign a_xor[0] = 8'b0;

    genvar i;
    generate
        for (i = 0; i < 16; i++) begin: gen_block_R

            `ifdef BIG_ENDIAN
                multGF mul (
                    .a(state[(i + 1) * 8 - 1 : i * 8]),
                    .b(l_vec[i]),
                    .c(a_15[i])
                );
            `else
                multGF mul (
                    .a(state[(i + 1) * 8 - 1 : i * 8]),
                    .b(l_vec[15 - i]),
                    .c(a_15[i])
                );
            `endif

            funcX #(8) instXor (
                .a(a_xor[i]),
                .b(a_15[i]),
                .res(a_xor[i + 1])
            );
        end
    endgenerate

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) res <= 128'b0;
        else        res <= { state[119:0], a_xor[16] };
    end

endmodule

module funcL(
    input clk,
    input rst_n,
    input put,
    input [127:0] data,
    output [127:0] res,
    output reg ready
);

    wire [127:0] buffer [0:16];
    assign buffer[0] = data;

    reg [14:0] counter;

    genvar i;

    generate
        for (i = 0; i < 16; i = i + 1) begin: instR
            funcR instR (
                .clk   (clk),
                .rst_n (rst_n),
                .state (buffer[i]),
                .res   (buffer[i + 1])
            );
        end
    endgenerate

    assign res = buffer[16];

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            counter <= 15'b0;
            ready <= 1'b0;
        end
        else begin
            counter <= { counter[13:0], put };
            ready <= counter[14];
        end
    end

endmodule
