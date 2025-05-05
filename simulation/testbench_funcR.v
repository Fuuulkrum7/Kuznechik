`timescale 1ns/1ps
module testbench_funcR;

reg clk, rst_n;
reg [127:0] state;
wire [127:0] res;

funcR uut (
    .clk(clk),
    .rst_n(rst_n),
    .state(state),
    .res(res)
);

always #5 clk = ~clk;

integer i;
reg [127:0] test_states   [0:19];
reg [127:0] expected_res  [0:19];

initial begin
    // Тестовые входы
    test_states[0]  = 128'hA041ABB1A445B706C6D90D0DB0F33A7A;
    test_states[1]  = 128'h6A5784285CF6F3BDF82A0715729A8AA0;
    test_states[2]  = 128'hB6149A8502DA3D43F8C7AFEB0155C6CF;
    test_states[3]  = 128'hBDED4C5D0AC4162CB941A480F3363FD2;
    test_states[4]  = 128'hBBB270B854ECEFBD665443CDC59DFDF8;
    test_states[5]  = 128'h271970B406793AC74F6419939028C94F;
    test_states[6]  = 128'hF4BC189881E21F082ED0541575CD7994;
    test_states[7]  = 128'h3F4367605FFAE16C08623D50DE6511DC;
    test_states[8]  = 128'h8E5394B74335DDD84B573D920C3311E3;
    test_states[9]  = 128'h8321EBD273552C769584D22D7E0ACE64;
    test_states[10] = 128'hF568709391A9BE8AECE905C377586FAE;
    test_states[11] = 128'h7EE4160A1984D3CC01DFA3D6E9E77B21;
    test_states[12] = 128'hE1C905970DB085F741F92B708DFC380B;
    test_states[13] = 128'hBFE5EC283001F1D74532835EAF621291;
    test_states[14] = 128'h24BF58CF79E34A100EBD102126D75409;
    test_states[15] = 128'hC5D346A7EBF7F8070AA21B00F6A7FB29;
    test_states[16] = 128'hFC64ECFAF264DAF33ACBE313E7DE6C8A;
    test_states[17] = 128'hE20F1E51EC941F451E37360CBEE1F82C;
    test_states[18] = 128'h22A0B0B6EBC8C53136E72BE78D68E310;
    test_states[19] = 128'h837DCD1CBC6CE61108FFF234CAE654ED;

    // Эталонные выходы
    expected_res[0]  = 128'h41ABB1A445B706C6D90D0DB0F33A7A0D;
    expected_res[1]  = 128'h5784285CF6F3BDF82A0715729A8AA00F;
    expected_res[2]  = 128'h149A8502DA3D43F8C7AFEB0155C6CFE6;
    expected_res[3]  = 128'hED4C5D0AC4162CB941A480F3363FD2D9;
    expected_res[4]  = 128'hB270B854ECEFBD665443CDC59DFDF893;
    expected_res[5]  = 128'h1970B406793AC74F6419939028C94F53;
    expected_res[6]  = 128'hBC189881E21F082ED0541575CD799431;
    expected_res[7]  = 128'h4367605FFAE16C08623D50DE6511DCDD;
    expected_res[8]  = 128'h5394B74335DDD84B573D920C3311E306;
    expected_res[9]  = 128'h21EBD273552C769584D22D7E0ACE64EB;
    expected_res[10] = 128'h68709391A9BE8AECE905C377586FAE8F;
    expected_res[11] = 128'hE4160A1984D3CC01DFA3D6E9E77B2189;
    expected_res[12] = 128'hC905970DB085F741F92B708DFC380BA3;
    expected_res[13] = 128'hE5EC283001F1D74532835EAF621291F3;
    expected_res[14] = 128'hBF58CF79E34A100EBD102126D7540942;
    expected_res[15] = 128'hD346A7EBF7F8070AA21B00F6A7FB29EE;
    expected_res[16] = 128'h64ECFAF264DAF33ACBE313E7DE6C8AA3;
    expected_res[17] = 128'h0F1E51EC941F451E37360CBEE1F82CBF;
    expected_res[18] = 128'hA0B0B6EBC8C53136E72BE78D68E31080;
    expected_res[19] = 128'h7DCD1CBC6CE61108FFF234CAE654ED2B;

    clk = 0;
    rst_n = 0;

    $dumpfile("func_r.vcd");
    $dumpvars(0, testbench_funcR);

    for (i = 0; i < 20; i = i + 1) begin
        state = test_states[i];
        #5 rst_n = 1;
        #10;
        $display("Test %0d: state = %h => res = %h", i, state, res);
        if (res !== expected_res[i]) begin
            $display("MISMATCH at test %0d!", i);
            $display("Expected: %h", expected_res[i]);
            $display("Got:      %h", res);
            $fatal;
        end
        rst_n = 0;
        #5;
    end

    $display("All funcR tests passed.");
    $finish;
end

endmodule
