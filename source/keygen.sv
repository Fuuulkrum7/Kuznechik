// `define PIPELINED

`ifdef PIPELINED
module shift # (
    parameter WIDTH = 128,
    parameter DEPTH = 16
) (
    input clk,
    input rst_n,
    input  [WIDTH - 1 : 0] data,
    output [WIDTH - 1 : 0] res
);

    logic [WIDTH - 1 : 0] arr [0 : DEPTH - 1];
    integer i;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i++) arr[i] <= { WIDTH{1'b0} };
        end
        else begin
            arr[0] <= data;
            for (i = 1; i < DEPTH; i++) arr[i] <= arr[i - 1];
        end
    end

    assign res = arr[DEPTH - 1];

endmodule
`endif

module funcF (
    input  logic         clk,
    input  logic         rst_n,
    input  logic         put,
    input  logic [127:0] key1,
    input  logic [127:0] key2,
    input  logic [127:0] C,
    output logic [127:0] newKey1,
    output logic [127:0] newKey2,
    output logic         ready
);
    logic [4:0] counter;
    logic [127:0] resXor, resS, resL, resShift;

    `ifdef PIPELINED
    shift shiftKey1(
        .clk(clk),
        .rst_n(rst_n),
        .data(key1),
        .res(newKey2)
    );

    shift shiftKey2(
        .clk(clk),
        .rst_n(rst_n),
        .data(key2),
        .res(resShift)
    );
    `else
    assign newKey2 = key1;
    assign resShift = key2;
    `endif

    funcX inst_x (key1, C, resXor);
    funcS inst_s (resXor, resS);
    funcL inst_l (
        .clk(clk),
        .rst_n(rst_n),
        .put(put),
        .data(resS),
        .res(resL),
        .ready(ready)
    );
    funcX outXor (resL, resShift, newKey1);

endmodule

module kuznechik_keygen (
    input  logic          clk,
    input  logic          rst_n,
    input  logic          en,
    input  logic  [255:0] master_key,
    output logic  [255:0] round_keys,
    output logic          ready,
    output logic          full_ready
);
    // внутренние ключи
    logic [127:0] key1, key2;
    logic put;
    logic [127:0] new_key1, new_key2;
    logic f_ready;

    // счётчик итераций от 0 до 31
    logic [4:0] round_counter;

    // подключаем константу C[i] через готовый модуль
    logic [127:0] C;
    kuznechik_constants const_rom (
        .code(round_counter),
        .res(C)
    );

    // модуль одной итерации
    funcF f_round (
        .clk     (clk),
        .rst_n   (rst_n),
        .put     (put),
        .key1    (key1),
        .key2    (key2),
        .C       (C),
        .newKey1 (new_key1),
        .newKey2 (new_key2),
        .ready   (f_ready)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            round_counter <= 5'b0;
            key1 <= master_key[255:128];
            key2 <= master_key[127:0];
            ready <= 1'b0;
            put <= 1'b1;
            full_ready <= 1'b0;
        end
        else if (en && f_ready) begin
            key1 <= new_key1;
            key2 <= new_key2;
            put <= 1'b1;
            
            round_counter <= round_counter + 1;
            if (round_counter == 5'b0) begin
                ready <= 1'b1;
                round_keys[255:128] <= key1;
                round_keys[127:0]   <= key2;
            end
            else if (round_counter[2:0] == 3'b111) begin
                ready <= 1'b1;
                round_keys[255:128] <= new_key1;
                round_keys[127:0]   <= new_key2;
            end
            full_ready <= round_counter == 5'd31;
        end
        else begin
            put <= 1'b0;
            ready <= 1'b0;
        end
    end

endmodule
