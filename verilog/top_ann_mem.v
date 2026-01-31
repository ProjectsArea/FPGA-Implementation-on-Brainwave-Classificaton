`timescale 1ns / 1ps

module top_ann_mem (
    input  signed [15:0] f0, f1, f2, f3, f4, f5, f6, f7,
    output reg signed [15:0] o0, o1, o2, o3,
    output reg [1:0] predicted_stage
);

    // -------------------------------------------------
    // Memory declarations
    // -------------------------------------------------
    reg signed [15:0] layer0_weights [0:127]; // 16 x 8
    reg signed [15:0] layer0_biases  [0:15];

    reg signed [15:0] layer1_weights [0:63];  // 4 x 16
    reg signed [15:0] layer1_biases  [0:3];

    // -------------------------------------------------
    // Internal signals
    // -------------------------------------------------
    reg signed [15:0] features [0:7];
    reg signed [15:0] hidden   [0:15];
    reg signed [31:0] acc;
    integer i, j;

    // -------------------------------------------------
    // Load trained weights
    // -------------------------------------------------
    initial begin
        $readmemh("layer0_weights.mem", layer0_weights);
        $readmemh("layer0_biases.mem",  layer0_biases);
        $readmemh("layer1_weights.mem", layer1_weights);
        $readmemh("layer1_biases.mem",  layer1_biases);
    end

    // -------------------------------------------------
    // Input feature assignment
    // -------------------------------------------------
    always @(*) begin
        features[0] = f0;
        features[1] = f1;
        features[2] = f2;
        features[3] = f3;
        features[4] = f4;
        features[5] = f5;
        features[6] = f6;
        features[7] = f7;
    end

    // -------------------------------------------------
    // Hidden layer (Sigmoid approx)
    // y = x / (1 + |x|)
    // -------------------------------------------------
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            acc = 0;
            for (j = 0; j < 8; j = j + 1) begin
                acc = acc + features[j] * layer0_weights[i*8 + j];
            end
            acc = acc + (layer0_biases[i] <<< 8);

            // Sigmoid approximation (Q8.8)
            hidden[i] = (acc <<< 8) / (256 + (acc[31] ? -acc : acc));
        end
    end

    // -------------------------------------------------
    // Output layer (Linear)
    // -------------------------------------------------
    always @(*) begin
        acc = 0;
        for (j = 0; j < 16; j = j + 1)
            acc = acc + hidden[j] * layer1_weights[j];
        o0 = (acc >>> 8) + layer1_biases[0];

        acc = 0;
        for (j = 0; j < 16; j = j + 1)
            acc = acc + hidden[j] * layer1_weights[16 + j];
        o1 = (acc >>> 8) + layer1_biases[1];

        acc = 0;
        for (j = 0; j < 16; j = j + 1)
            acc = acc + hidden[j] * layer1_weights[32 + j];
        o2 = (acc >>> 8) + layer1_biases[2];

        acc = 0;
        for (j = 0; j < 16; j = j + 1)
            acc = acc + hidden[j] * layer1_weights[48 + j];
        o3 = (acc >>> 8) + layer1_biases[3];
    end

    // -------------------------------------------------
    // Argmax logic
    // -------------------------------------------------
    always @(*) begin
        predicted_stage = 0;

        if (o1 > o0) predicted_stage = 1;
        if (o2 > (predicted_stage == 0 ? o0 : o1)) predicted_stage = 2;
        if (o3 > ((predicted_stage == 0) ? o0 :
                  (predicted_stage == 1) ? o1 : o2))
            predicted_stage = 3;
    end

endmodule
