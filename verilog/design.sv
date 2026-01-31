`timescale 1ns / 1ps
module top_ann_eda(
    input signed [15:0] f0, f1, f2, f3, f4, f5, f6, f7,
    output reg signed [15:0] o0, o1, o2, o3
);

    // Simplified weights for EDA Playground compatibility
    // Layer 0 weights (16 neurons x 8 inputs)
    reg signed [15:0] layer0_weights [0:127];
    reg signed [15:0] layer0_biases [0:15];
    reg signed [15:0] layer1_weights [0:63];
    reg signed [15:0] layer1_biases [0:3];
    
    reg signed [15:0] hidden [0:15];
    integer i, j;

    // Initialize weights
    initial begin
        // Layer 0 weights
        layer0_weights[0] = 402; layer0_weights[1] = 728; layer0_weights[2] = -77; layer0_weights[3] = 392;
        layer0_weights[4] = -533; layer0_weights[5] = -701; layer0_weights[6] = -434; layer0_weights[7] = -161;
        layer0_weights[8] = -607; layer0_weights[9] = 373; layer0_weights[10] = -380; layer0_weights[11] = 616;
        layer0_weights[12] = -669; layer0_weights[13] = 445; layer0_weights[14] = -501; layer0_weights[15] = 316;
        layer0_weights[16] = 143; layer0_weights[17] = 307; layer0_weights[18] = 272; layer0_weights[19] = 129;
        layer0_weights[20] = 13; layer0_weights[21] = -324; layer0_weights[22] = 54; layer0_weights[23] = -390;
        layer0_weights[24] = -69; layer0_weights[25] = 256; layer0_weights[26] = 241; layer0_weights[27] = 245;
        layer0_weights[28] = -378; layer0_weights[29] = -153; layer0_weights[30] = -293; layer0_weights[31] = -375;
        layer0_weights[32] = 29; layer0_weights[33] = 426; layer0_weights[34] = 522; layer0_weights[35] = 87;
        layer0_weights[36] = 123; layer0_weights[37] = -236; layer0_weights[38] = 147; layer0_weights[39] = -423;
        layer0_weights[40] = 32; layer0_weights[41] = 292; layer0_weights[42] = 400; layer0_weights[43] = 158;
        layer0_weights[44] = -519; layer0_weights[45] = -242; layer0_weights[46] = -285; layer0_weights[47] = -338;
        layer0_weights[48] = -406; layer0_weights[49] = 558; layer0_weights[50] = 524; layer0_weights[51] = -332;
        layer0_weights[52] = 594; layer0_weights[53] = -517; layer0_weights[54] = 537; layer0_weights[55] = -596;
        layer0_weights[56] = 572; layer0_weights[57] = 599; layer0_weights[58] = 446; layer0_weights[59] = 454;
        layer0_weights[60] = -551; layer0_weights[61] = -576; layer0_weights[62] = -674; layer0_weights[63] = -548;
        layer0_weights[64] = 549; layer0_weights[65] = 645; layer0_weights[66] = -238; layer0_weights[67] = 515;
        layer0_weights[68] = -484; layer0_weights[69] = 56; layer0_weights[70] = -460; layer0_weights[71] = 708;
        layer0_weights[72] = -553; layer0_weights[73] = -367; layer0_weights[74] = -392; layer0_weights[75] = 215;
        layer0_weights[76] = -220; layer0_weights[77] = 813; layer0_weights[78] = -571; layer0_weights[79] = 520;
        layer0_weights[80] = 284; layer0_weights[81] = 4; layer0_weights[82] = -114; layer0_weights[83] = 350;
        layer0_weights[84] = -503; layer0_weights[85] = 368; layer0_weights[86] = -364; layer0_weights[87] = 676;
        layer0_weights[88] = -400; layer0_weights[89] = -482; layer0_weights[90] = -392; layer0_weights[91] = -161;
        layer0_weights[92] = 145; layer0_weights[93] = 602; layer0_weights[94] = -113; layer0_weights[95] = 471;
        layer0_weights[96] = -589; layer0_weights[97] = -439; layer0_weights[98] = -390; layer0_weights[99] = -453;
        layer0_weights[100] = 633; layer0_weights[101] = -542; layer0_weights[102] = 654; layer0_weights[103] = -465;
        layer0_weights[104] = 534; layer0_weights[105] = 606; layer0_weights[106] = 228; layer0_weights[107] = 243;
        layer0_weights[108] = 300; layer0_weights[109] = -615; layer0_weights[110] = 318; layer0_weights[111] = -183;
        layer0_weights[112] = -552; layer0_weights[113] = 824; layer0_weights[114] = 766; layer0_weights[115] = -443;
        layer0_weights[116] = 536; layer0_weights[117] = -702; layer0_weights[118] = 651; layer0_weights[119] = -579;
        layer0_weights[120] = 545; layer0_weights[121] = 674; layer0_weights[122] = 549; layer0_weights[123] = 673;
        layer0_weights[124] = -793; layer0_weights[125] = -823; layer0_weights[126] = -652; layer0_weights[127] = -672;

        // Layer 0 biases
        layer0_biases[0] = -105; layer0_biases[1] = -197; layer0_biases[2] = -19; layer0_biases[3] = -92;
        layer0_biases[4] = 93; layer0_biases[5] = 131; layer0_biases[6] = 47; layer0_biases[7] = 85;
        layer0_biases[8] = 169; layer0_biases[9] = -99; layer0_biases[10] = 46; layer0_biases[11] = -120;
        layer0_biases[12] = 69; layer0_biases[13] = -91; layer0_biases[14] = 159; layer0_biases[15] = -23;

        // Layer 1 weights
        layer1_weights[0] = -58; layer1_weights[1] = -124; layer1_weights[2] = 64; layer1_weights[3] = 251;
        layer1_weights[4] = -183; layer1_weights[5] = 183; layer1_weights[6] = 9; layer1_weights[7] = 253;
        layer1_weights[8] = -152; layer1_weights[9] = 180; layer1_weights[10] = 82; layer1_weights[11] = -150;
        layer1_weights[12] = -198; layer1_weights[13] = -283; layer1_weights[14] = 58; layer1_weights[15] = 241;
        layer1_weights[16] = 175; layer1_weights[17] = 337; layer1_weights[18] = -21; layer1_weights[19] = -246;
        layer1_weights[20] = 128; layer1_weights[21] = -376; layer1_weights[22] = 214; layer1_weights[23] = -114;
        layer1_weights[24] = 17; layer1_weights[25] = 266; layer1_weights[26] = -125; layer1_weights[27] = -358;
        layer1_weights[28] = 59; layer1_weights[29] = -511; layer1_weights[30] = 214; layer1_weights[31] = 142;
        layer1_weights[32] = 172; layer1_weights[33] = 275; layer1_weights[34] = 12; layer1_weights[35] = -397;
        layer1_weights[36] = -8; layer1_weights[37] = 442; layer1_weights[38] = -174; layer1_weights[39] = 30;
        layer1_weights[40] = 15; layer1_weights[41] = 352; layer1_weights[42] = 87; layer1_weights[43] = -330;
        layer1_weights[44] = -40; layer1_weights[45] = 262; layer1_weights[46] = -100; layer1_weights[47] = 249;
        layer1_weights[48] = 273; layer1_weights[49] = -310; layer1_weights[50] = -78; layer1_weights[51] = -79;
        layer1_weights[52] = 23; layer1_weights[53] = -250; layer1_weights[54] = 142; layer1_weights[55] = 311;
        layer1_weights[56] = 324; layer1_weights[57] = -118; layer1_weights[58] = 126; layer1_weights[59] = -318;
        layer1_weights[60] = 76; layer1_weights[61] = -403; layer1_weights[62] = 3; layer1_weights[63] = 311;

        // Layer 1 biases
        layer1_biases[0] = 4; layer1_biases[1] = -6; layer1_biases[2] = 14; layer1_biases[3] = -19;
    end

    // Neural network computation
    always @* begin
        // Hidden layer
        for (i = 0; i < 16; i = i + 1) begin
            reg signed [31:0] acc;
            acc = 0;
            for (j = 0; j < 8; j = j + 1) begin
                case (j)
                    0: acc = acc + f0 * layer0_weights[i*8 + j];
                    1: acc = acc + f1 * layer0_weights[i*8 + j];
                    2: acc = acc + f2 * layer0_weights[i*8 + j];
                    3: acc = acc + f3 * layer0_weights[i*8 + j];
                    4: acc = acc + f4 * layer0_weights[i*8 + j];
                    5: acc = acc + f5 * layer0_weights[i*8 + j];
                    6: acc = acc + f6 * layer0_weights[i*8 + j];
                    7: acc = acc + f7 * layer0_weights[i*8 + j];
                endcase
            end
            acc = acc + (layer0_biases[i] << 4);  // Reduced bias scaling
            // Improved sigmoid approximation with better range
            if (acc > 32767) acc = 32767;
            if (acc < -32768) acc = -32768;
            hidden[i] = (acc >>> 1) + 128;  // Simpler activation: shift + offset
        end

        // Output layer
        for (i = 0; i < 4; i = i + 1) begin
            reg signed [31:0] acc;
            acc = 0;
            for (j = 0; j < 16; j = j + 1) begin
                acc = acc + hidden[j] * layer1_weights[i*16 + j];
            end
            acc = acc + (layer1_biases[i] << 4);  // Reduced bias scaling
            // Improved sigmoid approximation with better range
            if (acc > 32767) acc = 32767;
            if (acc < -32768) acc = -32768;
            case (i)
                0: o0 = (acc >>> 1) + 128;
                1: o1 = (acc >>> 1) + 128;
                2: o2 = (acc >>> 1) + 128;
                3: o3 = (acc >>> 1) + 128;
            endcase
        end
    end
endmodule
