module encrypt_step(
    input          clk,
    input          rst_n,
    input          put,
    input  [127:0] in_data,
    input  [127:0] key,
    output [127:0] out_data,
    output         ready
);

    wire [127:0] xor_out;
    wire [127:0] s_out;
    
    funcX xor_stage (.a(in_data), .b(key), .res(xor_out));

    funcS s_stage (.s(xor_out), .res(s_out));

    funcL l_stage (
        .clk(clk),
        .rst_n(rst_n),
        .put(put),
        .data(s_out),
        .res(out_data),
        .ready(ready)
    );

endmodule

module kuznechik_encrypt (
    input              clk,
    input              rst_n,
    input              keyset,            // Режим записи ключей
    input              key_valid,
    input [127:0]      round_key,         // текущий раундовый ключ
    input              put,
    input [127:0]      in_data,
    output reg [127:0] out_data,
    output reg         ready              // сигнал завершения
);

    reg [3:0]    key_addr;
    reg [127:0]  memory [0:9];

    wire [9:0]   d_ready;
    wire [127:0] d_data [0:9];
    
    wire [127:0] xor_out;

    assign d_ready[0] = put;
    assign d_data[0] = in_data;

    genvar i;

    generate
        for (i = 0; i < 9; i = i + 1) begin: pipelined
            encrypt_step enc_inst(
                .clk(clk),
                .rst_n(rst_n),
                .put(d_ready[i]),
                .in_data(d_data[i]),
                .key(memory[i]),
                .out_data(d_data[i + 1]),
                .ready(d_ready[i + 1])
            );
        end
    endgenerate

    funcX xor_stage (.a(d_data[9]), .b(memory[9]), .res(xor_out));

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out_data <= 128'b0;
            ready <= 1'b0;
        end
        else begin
            out_data <= xor_out;
            ready <= d_ready[9];
        end
    end

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            key_addr <= 4'b0;
            for (j = 0; j < 10; j = j + 1) begin
                memory[j] <= 128'b0;
            end
        end
        else if (keyset && key_valid) begin
            memory[key_addr] <= round_key;
            key_addr <= key_addr + 4'b1;
        end
    end

    wire [127:0] mem = memory[0];
    wire [127:0] mem1 = memory[1];

endmodule
