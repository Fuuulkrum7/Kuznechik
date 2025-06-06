module kuznechik_encrypt (
    input              clk,
    input              rst_n,
    input              en,
    input [127:0]      in_data,
    input [127:0]      round_key,         // текущий раундовый ключ
    input              key_valid,
    output reg         key_next,
    output reg [127:0] out_data,
    output reg         ready              // сигнал завершения
);

    reg [3:0] round;
    reg [127:0] state;

    wire [127:0] xor_out;
    wire [127:0] s_out;
    wire [127:0] l_out;
    wire l_ready;

    funcX xor_stage (.a(state), .b(round_key), .res(xor_out));

    funcS s_stage (.s(xor_out), .res(s_out));

    funcL l_stage (
        .clk(clk),
        .rst_n(rst_n),
        .put(key_valid),
        .data(s_out),
        .res(l_out),
        .ready(l_ready)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            round     <= 4'b0;
            state     <= 128'b0;
            key_next  <= 1'b0;
            ready     <= 1'b0;
            out_data  <= 0;
        end else begin
            key_next <= 1'b0;
            ready    <= 1'b0;

            // запуск
            if (en && round == 0) begin
                state <= in_data;
                key_next <= 1'b1;
                round <= 1'b1;
            end

            // 16 тактов
            else if (l_ready && round != 10) begin
                state <= l_out;
                round <= round + 1'b1;
                key_next <= 1'b1;
            end

            // последний раунд — XOR
            else if (key_valid && round == 10) begin
                out_data <= xor_out;
                round <= 0;
                ready <= 1;
            end
        end
    end

endmodule
