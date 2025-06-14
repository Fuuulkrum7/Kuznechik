module master_key_selector (
    input          sel,
    output [255:0] master_key
);

    wire [255:0] key0 = 256'h0123456789ABCDEF_0123456789ABCDEF_0123456789ABCDEF_0123456789ABCDEF;
    wire [255:0] key1 = 256'hDEADBEEFCAFEBABE_0011223344556677_8899AABBCCDDEEFF_1122334455667788;

    assign master_key = (sel == 1'b0) ? key0 : key1;

endmodule

module crypto_simle(
    input MAX10_CLK1_50,
    input [ 1:0 ] KEY,
    input [ 1:0 ] SW,
    input [127:0] GPIO,
    output [ 127:0 ] LEDR,
    output cipher_ready,
    output keys_ready
);
    wire clk = MAX10_CLK1_50;
    wire rst_n = KEY[0];

    wire [255:0] selected_key;
    reg en, sel;

    wire ready;

    wire [255:0] round_key;
    reg  [255:0] round_key_d;

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
        else if (keys_ready) en <= 1'b0;
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
        .full_ready (keys_ready)
    );

    /*-------------------------------------------------------------------------------*/

    wire keyset = !keys_ready || (|key_phase);

    wire [127:0] plain_text = GPIO;
    reg          cipher_en;

    always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        cipher_en <= 1'b0;
    else if (keys_ready)  // ключи сгенерированы
        cipher_en <= 1'b1;
    else if (en)
        cipher_en <= 1'b0;
    end

    kuznechik_encrypt main(
        .clk        (clk),
        .rst_n      (rst_n),
        .keyset     (keyset),
        .key_valid  (|key_phase),
        .round_key  (round_key_d[255:128]),           // текущий ключ
        .put        (cipher_en & SW[1]),
        .in_data    (plain_text),           // входной текст
        .out_data   (LEDR),
        .ready      (cipher_ready)          // готово
    );

endmodule
