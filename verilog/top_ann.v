// top_ann.v
module top_ann(
    input signed [15:0] feature0,
    input signed [15:0] feature1,
    input signed [15:0] feature2,
    input signed [15:0] feature3,
    input signed [15:0] feature4,
    input signed [15:0] feature5,
    input signed [15:0] feature6,
    input signed [15:0] feature7,
    output reg [1:0] predicted_stage
);

    reg signed [15:0] features [0:7];
    reg signed [15:0] hidden [0:15];
    reg signed [15:0] output_layer [0:3];

    reg signed [15:0] layer0_weights [0:127];
    reg signed [15:0] layer0_biases [0:15];
    reg signed [15:0] layer1_weights [0:63];
    reg signed [15:0] layer1_biases [0:3];

    integer i,j;
    integer acc;

    initial begin
        $readmemh("layer0_weights.mem", layer0_weights);
        $readmemh("layer0_biases.mem", layer0_biases);
        $readmemh("layer1_weights.mem", layer1_weights);
        $readmemh("layer1_biases.mem", layer1_biases);
    end

    always @(*) begin
        features[0] = feature0;
        features[1] = feature1;
        features[2] = feature2;
        features[3] = feature3;
        features[4] = feature4;
        features[5] = feature5;
        features[6] = feature6;
        features[7] = feature7;
    end

    always @(*) begin
        // Hidden layer
        for (i=0; i<16; i=i+1) begin
            acc = 0;
            for (j=0; j<8; j=j+1)
                acc = acc + features[j]*layer0_weights[i*8+j];
            acc = acc + (layer0_biases[i]<<8);

            if (acc >= 0)
                hidden[i] = (acc << 8)/(256 + acc);
            else
                hidden[i] = (acc << 8)/(256 - acc);
        end

        // Output layer
        for (i=0; i<4; i=i+1) begin
            acc = 0;
            for (j=0; j<16; j=j+1)
                acc = acc + hidden[j]*layer1_weights[i*16+j];
            acc = acc + (layer1_biases[i]<<8);

            if (acc >= 0)
                output_layer[i] = (acc << 8)/(256 + acc);
            else
                output_layer[i] = (acc << 8)/(256 - acc);
        end

        // Argmax
        predicted_stage = 0;
        for (i=1; i<4; i=i+1)
            if (output_layer[i] > output_layer[predicted_stage])
                predicted_stage = i[1:0];
    end

endmodule
