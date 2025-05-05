module master_key_selector (
    input          sel,
    output [255:0] master_key
);

    wire [255:0] key0 = 256'h0123456789ABCDEF_0123456789ABCDEF_0123456789ABCDEF_0123456789ABCDEF;
    wire [255:0] key1 = 256'hDEADBEEFCAFEBABE_0011223344556677_8899AABBCCDDEEFF_1122334455667788;

    assign master_key = (sel == 1'b0) ? key0 : key1;

endmodule

module crypto(
    input ADC_CLK_10,
    input MAX10_CLK1_50,
    input MAX10_CLK2_50,
    input [ 1:0 ] KEY,
    input [ 9:0 ] SW,
    input [127:0] GPIO,
    output [ 127:0 ] LEDR
);
    wire clk = MAX10_CLK1_50;
    wire rst_n = KEY[0];

    wire [255:0] selected_key;
    reg en, sel;

    wire ready, full_ready;
    reg [3:0] key_addr;
    reg [3:0] read_addr;

    wire [255:0] round_key;
    reg  [255:0] round_key_d;
    wire [127:0] curent_key;

    reg [1:0] key_phase; // 0: ожидаем пару, 1: отдали key1, 2: отдали key2

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin 
            en <= 1'b0;
            sel <= 1'b0;
        end
        else if (sel != SW[0] || (KEY[1] && !en)) begin
            en <= 1'b1;
            sel <= SW[0];
        end
        else if (full_ready) en <= 1'b0;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            key_addr <= 3'b0;
        end
        else if (sel != SW[0]) key_addr <= 3'b0;
        else if (|key_phase) begin
            key_addr <= key_addr + 1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            round_key_d <= 256'b0;
            key_phase <= 0;
        end
        else if (ready) begin
            round_key_d <= round_key;   // получили новую пару
            key_phase <= 1;
        end
        else if (key_phase == 1) begin
            round_key_d <= { round_key_d[127:0], 128'b0 };
            key_phase <= 2;
        end
        else if (key_phase == 2) begin
            round_key_d <= 256'b0;
            key_phase <= 0;
        end
    end

    master_key_selector key_sel (
        .sel(SW[0]),
        .master_key(selected_key)
    );

    kuznechik_keygen keygen_inst (
        .clk        (clk),
        .rst_n      (rst_n),
        .en         (en),
        .master_key (selected_key),
        .round_keys (round_key),
        .ready      (ready),
        .full_ready (full_ready)
    );

    key_storage storage_round (
        clk,
        round_key_d[255:128],
        key_addr,
        read_addr + (cipher_key_next & start_rounds),
        (|key_phase),
        curent_key
    );

    /*-------------------------------------------------------------------------------*/

    wire [127:0] plain_text = GPIO;
    reg          cipher_en;
    reg          start_rounds;

    wire         cipher_ready;
    wire         cipher_key_next;
    reg          key_valid;

    always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        cipher_en <= 1'b0;
    else if (full_ready)  // ключи сгенерированы
        cipher_en <= 1'b1;
    else if (en)
        cipher_en <= 1'b0;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)               start_rounds <= 1'b0;
        else if (en)              start_rounds <= 1'b0;
        else if (cipher_key_next) start_rounds <= 1'b1;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)                                read_addr <= 3'b0;
        else if (en)                               read_addr <= 3'b0;
        else read_addr <= read_addr + (start_rounds && cipher_key_next);
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)               key_valid <= 1'b0;
        else if (cipher_key_next) key_valid <= 1'b1;
        else                      key_valid <= 1'b0;
    end

    kuznechik_encrypt main(
        .clk        (clk),
        .rst_n      (rst_n),
        .en         (cipher_en),            // запуск
        .in_data    (plain_text),           // входной текст
        .round_key  (curent_key),   // текущий ключ
        .key_valid  (key_valid),
        .key_next   (cipher_key_next),
        .out_data   (LEDR),
        .ready      (cipher_ready)          // готово
    );

endmodule
