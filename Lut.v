// Таблица констант C1–C32 (32 × 128 бит)
module kuznechik_constants(
    input [4:0] code,
    output [127:0] res
);

    // Каждая константа — 128 бит (16 байт), little-endian
    reg [127:0] C [0:31];

    initial begin
        C[0]  = 128'h019484dd10bd275db87a486c7276a26e;
        C[1]  = 128'h02ebcb7920b94ebab3f490d8e4ec87dc;
        C[2]  = 128'h037f4fa4300469e70b8ed8b4969a25b2;
        C[3]  = 128'h041555f240b19cb7a52be3730b1bcd7b;
        C[4]  = 128'h0581d12f500cbbea1d51ab1f796d6f15;
        C[5]  = 128'h06fe9e8b6008d20d16df73abeff74aa7;
        C[6]  = 128'h076a1a5670b5f550aea53bc79d81e8c9;
        C[7]  = 128'h082aaa2780a1fbad895605e6163659f6;
        C[8]  = 128'h09be2efa901cdcf0312c4d8a6440fb98;
        C[9]  = 128'h0ac1615ea018b5173aa2953ef2dade2a;
        C[10] = 128'h0b55e583b0a5924a82d8dd5280ac7c44;
        C[11] = 128'h0c3fffd5c010671a2c7de6951d2d948d;
        C[12] = 128'h0dab7b08d0ad40479407aef96f5b36e3;
        C[13] = 128'h0ed434ace0a929a09f89764df9c11351;
        C[14] = 128'h0f40b071f0140efd27f33e218bb7b13f;
        C[15] = 128'h1054974ec3813599d1ac0a0f2c6cb22f;
        C[16] = 128'h11c01393d33c12c469d642635e1a1041;
        C[17] = 128'h12bf5c37e3387b2362589ad7c88035f3;
        C[18] = 128'h132bd8eaf3855c7eda22d2bbbaf6979d;
        C[19] = 128'h1441c2bc8330a92e7487e97c27777f54;
        C[20] = 128'h15d54661938d8e73ccfda1105501dd3a;
        C[21] = 128'h16aa09c5a389e794c77379a4c39bf888;
        C[22] = 128'h173e8d18b334c0c97f0931c8b1ed5ae6;
        C[23] = 128'h187e3d694320ce3458fa0fe93a5aebd9;
        C[24] = 128'h19eab9b4539de969e0804785482c49b7;
        C[25] = 128'h1a95f6106399808eeb0e9f31deb66c05;
        C[26] = 128'h1b0172cd7324a7d35374d75dacc0ce6b;
        C[27] = 128'h1c6b689b03915283fdd1ec9a314126a2;
        C[28] = 128'h1dffec46132c75de45aba4f6433784cc;
        C[29] = 128'h1e80a3e223281c394e257c42d5ada17e;
        C[30] = 128'h1f14273f33953b64f65f342ea7db0310;
        C[31] = 128'h20a8ed9c45c16af1619b141e58d8a75e;
    end

    assign res = C[code];

endmodule

// S-блок алгоритма Кузнечик
module kuznechik_s(
    input [7:0] code,
    output [7:0] res
);

    reg [7:0] Pi [0:255];

    initial begin
        Pi[0]   = 8'd252; Pi[1]   = 8'd238; Pi[2]   = 8'd221; Pi[3]   = 8'd17;
        Pi[4]   = 8'd207; Pi[5]   = 8'd110; Pi[6]   = 8'd49;  Pi[7]   = 8'd22;
        Pi[8]   = 8'd251; Pi[9]   = 8'd196; Pi[10]  = 8'd250; Pi[11]  = 8'd218;
        Pi[12]  = 8'd35;  Pi[13]  = 8'd197; Pi[14]  = 8'd4;   Pi[15]  = 8'd77;
        Pi[16]  = 8'd233; Pi[17]  = 8'd119; Pi[18]  = 8'd240; Pi[19]  = 8'd219;
        Pi[20]  = 8'd147; Pi[21]  = 8'd46;  Pi[22]  = 8'd153; Pi[23]  = 8'd186;
        Pi[24]  = 8'd23;  Pi[25]  = 8'd54;  Pi[26]  = 8'd241; Pi[27]  = 8'd187;
        Pi[28]  = 8'd20;  Pi[29]  = 8'd205; Pi[30]  = 8'd95;  Pi[31]  = 8'd193;
        Pi[32]  = 8'd249; Pi[33]  = 8'd24;  Pi[34]  = 8'd101; Pi[35]  = 8'd90;
        Pi[36]  = 8'd226; Pi[37]  = 8'd92;  Pi[38]  = 8'd239; Pi[39]  = 8'd33;
        Pi[40]  = 8'd129; Pi[41]  = 8'd28;  Pi[42]  = 8'd60;  Pi[43]  = 8'd66;
        Pi[44]  = 8'd139; Pi[45]  = 8'd1;   Pi[46]  = 8'd142; Pi[47]  = 8'd79;
        Pi[48]  = 8'd5;   Pi[49]  = 8'd132; Pi[50]  = 8'd2;   Pi[51]  = 8'd174;
        Pi[52]  = 8'd227; Pi[53]  = 8'd106; Pi[54]  = 8'd143; Pi[55]  = 8'd160;
        Pi[56]  = 8'd6;   Pi[57]  = 8'd11;  Pi[58]  = 8'd237; Pi[59]  = 8'd152;
        Pi[60]  = 8'd127; Pi[61]  = 8'd212; Pi[62]  = 8'd211; Pi[63]  = 8'd31;
        Pi[64]  = 8'd235; Pi[65]  = 8'd52;  Pi[66]  = 8'd44;  Pi[67]  = 8'd81;
        Pi[68]  = 8'd234; Pi[69]  = 8'd200; Pi[70]  = 8'd72;  Pi[71]  = 8'd171;
        Pi[72]  = 8'd242; Pi[73]  = 8'd42;  Pi[74]  = 8'd104; Pi[75]  = 8'd162;
        Pi[76]  = 8'd253; Pi[77]  = 8'd58;  Pi[78]  = 8'd206; Pi[79]  = 8'd204;
        Pi[80]  = 8'd181; Pi[81]  = 8'd112; Pi[82]  = 8'd14;  Pi[83]  = 8'd86;
        Pi[84]  = 8'd8;   Pi[85]  = 8'd12;  Pi[86]  = 8'd118; Pi[87]  = 8'd18;
        Pi[88]  = 8'd191; Pi[89]  = 8'd114; Pi[90]  = 8'd19;  Pi[91]  = 8'd71;
        Pi[92]  = 8'd156; Pi[93]  = 8'd183; Pi[94]  = 8'd93;  Pi[95]  = 8'd135;
        Pi[96]  = 8'd21;  Pi[97]  = 8'd161; Pi[98]  = 8'd150; Pi[99]  = 8'd41;
        Pi[100] = 8'd16;  Pi[101] = 8'd123; Pi[102] = 8'd154; Pi[103] = 8'd199;
        Pi[104] = 8'd243; Pi[105] = 8'd145; Pi[106] = 8'd120; Pi[107] = 8'd111;
        Pi[108] = 8'd157; Pi[109] = 8'd158; Pi[110] = 8'd178; Pi[111] = 8'd177;
        Pi[112] = 8'd50;  Pi[113] = 8'd117; Pi[114] = 8'd25;  Pi[115] = 8'd61;
        Pi[116] = 8'd255; Pi[117] = 8'd53;  Pi[118] = 8'd138; Pi[119] = 8'd126;
        Pi[120] = 8'd109; Pi[121] = 8'd84;  Pi[122] = 8'd198; Pi[123] = 8'd128;
        Pi[124] = 8'd195; Pi[125] = 8'd189; Pi[126] = 8'd13;  Pi[127] = 8'd87;
        Pi[128] = 8'd223; Pi[129] = 8'd245; Pi[130] = 8'd36;  Pi[131] = 8'd169;
        Pi[132] = 8'd62;  Pi[133] = 8'd168; Pi[134] = 8'd67;  Pi[135] = 8'd201;
        Pi[136] = 8'd215; Pi[137] = 8'd121; Pi[138] = 8'd214; Pi[139] = 8'd246;
        Pi[140] = 8'd124; Pi[141] = 8'd34;  Pi[142] = 8'd185; Pi[143] = 8'd3;
        Pi[144] = 8'd224; Pi[145] = 8'd15;  Pi[146] = 8'd236; Pi[147] = 8'd222;
        Pi[148] = 8'd122; Pi[149] = 8'd148; Pi[150] = 8'd176; Pi[151] = 8'd188;
        Pi[152] = 8'd220; Pi[153] = 8'd232; Pi[154] = 8'd40;  Pi[155] = 8'd80;
        Pi[156] = 8'd78;  Pi[157] = 8'd51;  Pi[158] = 8'd10;  Pi[159] = 8'd74;
        Pi[160] = 8'd167; Pi[161] = 8'd151; Pi[162] = 8'd96;  Pi[163] = 8'd115;
        Pi[164] = 8'd30;  Pi[165] = 8'd0;   Pi[166] = 8'd98;  Pi[167] = 8'd68;
        Pi[168] = 8'd26;  Pi[169] = 8'd184; Pi[170] = 8'd56;  Pi[171] = 8'd130;
        Pi[172] = 8'd100; Pi[173] = 8'd159; Pi[174] = 8'd38;  Pi[175] = 8'd65;
        Pi[176] = 8'd173; Pi[177] = 8'd69;  Pi[178] = 8'd70;  Pi[179] = 8'd146;
        Pi[180] = 8'd39;  Pi[181] = 8'd94;  Pi[182] = 8'd85;  Pi[183] = 8'd47;
        Pi[184] = 8'd140; Pi[185] = 8'd163; Pi[186] = 8'd165; Pi[187] = 8'd125;
        Pi[188] = 8'd105; Pi[189] = 8'd213; Pi[190] = 8'd149; Pi[191] = 8'd59;
        Pi[192] = 8'd7;   Pi[193] = 8'd88;  Pi[194] = 8'd179; Pi[195] = 8'd64;
        Pi[196] = 8'd134; Pi[197] = 8'd172; Pi[198] = 8'd29;  Pi[199] = 8'd247;
        Pi[200] = 8'd48;  Pi[201] = 8'd55;  Pi[202] = 8'd107; Pi[203] = 8'd228;
        Pi[204] = 8'd136; Pi[205] = 8'd217; Pi[206] = 8'd231; Pi[207] = 8'd137;
        Pi[208] = 8'd225; Pi[209] = 8'd27;  Pi[210] = 8'd131; Pi[211] = 8'd73;
        Pi[212] = 8'd76;  Pi[213] = 8'd63;  Pi[214] = 8'd248; Pi[215] = 8'd254;
        Pi[216] = 8'd141; Pi[217] = 8'd83;  Pi[218] = 8'd170; Pi[219] = 8'd144;
        Pi[220] = 8'd202; Pi[221] = 8'd216; Pi[222] = 8'd133; Pi[223] = 8'd97;
        Pi[224] = 8'd32;  Pi[225] = 8'd113; Pi[226] = 8'd103; Pi[227] = 8'd164;
        Pi[228] = 8'd45;  Pi[229] = 8'd43;  Pi[230] = 8'd9;   Pi[231] = 8'd91;
        Pi[232] = 8'd203; Pi[233] = 8'd155; Pi[234] = 8'd37;  Pi[235] = 8'd208;
        Pi[236] = 8'd190; Pi[237] = 8'd229; Pi[238] = 8'd108; Pi[239] = 8'd82;
        Pi[240] = 8'd89;  Pi[241] = 8'd166; Pi[242] = 8'd116; Pi[243] = 8'd210;
        Pi[244] = 8'd230; Pi[245] = 8'd244; Pi[246] = 8'd180; Pi[247] = 8'd192;
        Pi[248] = 8'd209; Pi[249] = 8'd102; Pi[250] = 8'd175; Pi[251] = 8'd194;
        Pi[252] = 8'd57;  Pi[253] = 8'd75;  Pi[254] = 8'd99;  Pi[255] = 8'd182;
    end

    assign res = Pi[code];

endmodule

module kuznechik_reverse_s(
    input [7:0] code,
    output [7:0] res
);

    reg [7:0] reverse_Pi [0:255];

    initial begin
        reverse_Pi[0]   = 8'd165; reverse_Pi[1]   = 8'd45;  reverse_Pi[2]   = 8'd50;  reverse_Pi[3]   = 8'd143;
        reverse_Pi[4]   = 8'd14;  reverse_Pi[5]   = 8'd48;  reverse_Pi[6]   = 8'd56;  reverse_Pi[7]   = 8'd192;
        reverse_Pi[8]   = 8'd84;  reverse_Pi[9]   = 8'd230; reverse_Pi[10]  = 8'd158; reverse_Pi[11]  = 8'd57;
        reverse_Pi[12]  = 8'd85;  reverse_Pi[13]  = 8'd126; reverse_Pi[14]  = 8'd82;  reverse_Pi[15]  = 8'd145;
        reverse_Pi[16]  = 8'd100; reverse_Pi[17]  = 8'd3;   reverse_Pi[18]  = 8'd87;  reverse_Pi[19]  = 8'd90;
        reverse_Pi[20]  = 8'd28;  reverse_Pi[21]  = 8'd96;  reverse_Pi[22]  = 8'd7;   reverse_Pi[23]  = 8'd24;
        reverse_Pi[24]  = 8'd33;  reverse_Pi[25]  = 8'd114; reverse_Pi[26]  = 8'd168; reverse_Pi[27]  = 8'd209;
        reverse_Pi[28]  = 8'd41;  reverse_Pi[29]  = 8'd198; reverse_Pi[30]  = 8'd164; reverse_Pi[31]  = 8'd63;
        reverse_Pi[32]  = 8'd224; reverse_Pi[33]  = 8'd39;  reverse_Pi[34]  = 8'd141; reverse_Pi[35]  = 8'd12;
        reverse_Pi[36]  = 8'd130; reverse_Pi[37]  = 8'd234; reverse_Pi[38]  = 8'd174; reverse_Pi[39]  = 8'd180;
        reverse_Pi[40]  = 8'd154; reverse_Pi[41]  = 8'd99;  reverse_Pi[42]  = 8'd73;  reverse_Pi[43]  = 8'd229;
        reverse_Pi[44]  = 8'd66;  reverse_Pi[45]  = 8'd228; reverse_Pi[46]  = 8'd21;  reverse_Pi[47]  = 8'd183;
        reverse_Pi[48]  = 8'd200; reverse_Pi[49]  = 8'd6;   reverse_Pi[50]  = 8'd112; reverse_Pi[51]  = 8'd157;
        reverse_Pi[52]  = 8'd65;  reverse_Pi[53]  = 8'd117; reverse_Pi[54]  = 8'd25;  reverse_Pi[55]  = 8'd201;
        reverse_Pi[56]  = 8'd170; reverse_Pi[57]  = 8'd252; reverse_Pi[58]  = 8'd77;  reverse_Pi[59]  = 8'd191;
        reverse_Pi[60]  = 8'd42;  reverse_Pi[61]  = 8'd115; reverse_Pi[62]  = 8'd132; reverse_Pi[63]  = 8'd213;
        reverse_Pi[64]  = 8'd195; reverse_Pi[65]  = 8'd175; reverse_Pi[66]  = 8'd43;  reverse_Pi[67]  = 8'd134;
        reverse_Pi[68]  = 8'd167; reverse_Pi[69]  = 8'd177; reverse_Pi[70]  = 8'd178; reverse_Pi[71]  = 8'd91;
        reverse_Pi[72]  = 8'd70;  reverse_Pi[73]  = 8'd211; reverse_Pi[74]  = 8'd159; reverse_Pi[75]  = 8'd253;
        reverse_Pi[76]  = 8'd212; reverse_Pi[77]  = 8'd15;  reverse_Pi[78]  = 8'd156; reverse_Pi[79]  = 8'd47;
        reverse_Pi[80]  = 8'd155; reverse_Pi[81]  = 8'd67;  reverse_Pi[82]  = 8'd239; reverse_Pi[83]  = 8'd217;
        reverse_Pi[84]  = 8'd121; reverse_Pi[85]  = 8'd182; reverse_Pi[86]  = 8'd83;  reverse_Pi[87]  = 8'd127;
        reverse_Pi[88]  = 8'd193; reverse_Pi[89]  = 8'd240; reverse_Pi[90]  = 8'd35;  reverse_Pi[91]  = 8'd231;
        reverse_Pi[92]  = 8'd37;  reverse_Pi[93]  = 8'd94;  reverse_Pi[94]  = 8'd181; reverse_Pi[95]  = 8'd30;
        reverse_Pi[96]  = 8'd162; reverse_Pi[97]  = 8'd223; reverse_Pi[98]  = 8'd166; reverse_Pi[99]  = 8'd254;
        reverse_Pi[100] = 8'd172; reverse_Pi[101] = 8'd34;  reverse_Pi[102] = 8'd249; reverse_Pi[103] = 8'd226;
        reverse_Pi[104] = 8'd74;  reverse_Pi[105] = 8'd188; reverse_Pi[106] = 8'd53;  reverse_Pi[107] = 8'd202;
        reverse_Pi[108] = 8'd238; reverse_Pi[109] = 8'd120; reverse_Pi[110] = 8'd5;   reverse_Pi[111] = 8'd107;
        reverse_Pi[112] = 8'd81;  reverse_Pi[113] = 8'd225; reverse_Pi[114] = 8'd89;  reverse_Pi[115] = 8'd163;
        reverse_Pi[116] = 8'd242; reverse_Pi[117] = 8'd113; reverse_Pi[118] = 8'd86;  reverse_Pi[119] = 8'd17;
        reverse_Pi[120] = 8'd106; reverse_Pi[121] = 8'd137; reverse_Pi[122] = 8'd148; reverse_Pi[123] = 8'd101;
        reverse_Pi[124] = 8'd140; reverse_Pi[125] = 8'd187; reverse_Pi[126] = 8'd119; reverse_Pi[127] = 8'd60;
        reverse_Pi[128] = 8'd123; reverse_Pi[129] = 8'd40;  reverse_Pi[130] = 8'd171; reverse_Pi[131] = 8'd210;
        reverse_Pi[132] = 8'd49;  reverse_Pi[133] = 8'd222; reverse_Pi[134] = 8'd196; reverse_Pi[135] = 8'd95;
        reverse_Pi[136] = 8'd204; reverse_Pi[137] = 8'd207; reverse_Pi[138] = 8'd118; reverse_Pi[139] = 8'd44;
        reverse_Pi[140] = 8'd184; reverse_Pi[141] = 8'd216; reverse_Pi[142] = 8'd46;  reverse_Pi[143] = 8'd54;
        reverse_Pi[144] = 8'd219; reverse_Pi[145] = 8'd105; reverse_Pi[146] = 8'd179; reverse_Pi[147] = 8'd20;
        reverse_Pi[148] = 8'd149; reverse_Pi[149] = 8'd190; reverse_Pi[150] = 8'd98;  reverse_Pi[151] = 8'd161;
        reverse_Pi[152] = 8'd59;  reverse_Pi[153] = 8'd22;  reverse_Pi[154] = 8'd102; reverse_Pi[155] = 8'd233;
        reverse_Pi[156] = 8'd92;  reverse_Pi[157] = 8'd108; reverse_Pi[158] = 8'd109; reverse_Pi[159] = 8'd173;
        reverse_Pi[160] = 8'd55;  reverse_Pi[161] = 8'd97;  reverse_Pi[162] = 8'd75;  reverse_Pi[163] = 8'd185;
        reverse_Pi[164] = 8'd227; reverse_Pi[165] = 8'd186; reverse_Pi[166] = 8'd241; reverse_Pi[167] = 8'd160;
        reverse_Pi[168] = 8'd133; reverse_Pi[169] = 8'd131; reverse_Pi[170] = 8'd218; reverse_Pi[171] = 8'd71;
        reverse_Pi[172] = 8'd197; reverse_Pi[173] = 8'd176; reverse_Pi[174] = 8'd51;  reverse_Pi[175] = 8'd250;
        reverse_Pi[176] = 8'd150; reverse_Pi[177] = 8'd111; reverse_Pi[178] = 8'd110; reverse_Pi[179] = 8'd194;
        reverse_Pi[180] = 8'd246; reverse_Pi[181] = 8'd80;  reverse_Pi[182] = 8'd255; reverse_Pi[183] = 8'd93;
        reverse_Pi[184] = 8'd169; reverse_Pi[185] = 8'd142; reverse_Pi[186] = 8'd23;  reverse_Pi[187] = 8'd27;
        reverse_Pi[188] = 8'd151; reverse_Pi[189] = 8'd125; reverse_Pi[190] = 8'd236; reverse_Pi[191] = 8'd88;
        reverse_Pi[192] = 8'd247; reverse_Pi[193] = 8'd31;  reverse_Pi[194] = 8'd251; reverse_Pi[195] = 8'd124;
        reverse_Pi[196] = 8'd9;   reverse_Pi[197] = 8'd13;  reverse_Pi[198] = 8'd122; reverse_Pi[199] = 8'd103;
        reverse_Pi[200] = 8'd69;  reverse_Pi[201] = 8'd135; reverse_Pi[202] = 8'd220; reverse_Pi[203] = 8'd232;
        reverse_Pi[204] = 8'd79;  reverse_Pi[205] = 8'd29;  reverse_Pi[206] = 8'd78;  reverse_Pi[207] = 8'd4;
        reverse_Pi[208] = 8'd235; reverse_Pi[209] = 8'd248; reverse_Pi[210] = 8'd243; reverse_Pi[211] = 8'd62;
        reverse_Pi[212] = 8'd61;  reverse_Pi[213] = 8'd189; reverse_Pi[214] = 8'd138; reverse_Pi[215] = 8'd136;
        reverse_Pi[216] = 8'd221; reverse_Pi[217] = 8'd205; reverse_Pi[218] = 8'd11;  reverse_Pi[219] = 8'd19;
        reverse_Pi[220] = 8'd152; reverse_Pi[221] = 8'd2;   reverse_Pi[222] = 8'd147; reverse_Pi[223] = 8'd128;
        reverse_Pi[224] = 8'd144; reverse_Pi[225] = 8'd208; reverse_Pi[226] = 8'd36;  reverse_Pi[227] = 8'd52;
        reverse_Pi[228] = 8'd203; reverse_Pi[229] = 8'd237; reverse_Pi[230] = 8'd244; reverse_Pi[231] = 8'd206;
        reverse_Pi[232] = 8'd153; reverse_Pi[233] = 8'd16;  reverse_Pi[234] = 8'd68;  reverse_Pi[235] = 8'd64;
        reverse_Pi[236] = 8'd146; reverse_Pi[237] = 8'd58;  reverse_Pi[238] = 8'd1;   reverse_Pi[239] = 8'd38;
        reverse_Pi[240] = 8'd18;  reverse_Pi[241] = 8'd26;  reverse_Pi[242] = 8'd72;  reverse_Pi[243] = 8'd104;
        reverse_Pi[244] = 8'd245; reverse_Pi[245] = 8'd129; reverse_Pi[246] = 8'd139; reverse_Pi[247] = 8'd199;
        reverse_Pi[248] = 8'd214; reverse_Pi[249] = 8'd32;  reverse_Pi[250] = 8'd10;  reverse_Pi[251] = 8'd8;
        reverse_Pi[252] = 8'd0;   reverse_Pi[253] = 8'd76;  reverse_Pi[254] = 8'd215; reverse_Pi[255] = 8'd116;
    end

    assign res = reverse_Pi[code];

endmodule
