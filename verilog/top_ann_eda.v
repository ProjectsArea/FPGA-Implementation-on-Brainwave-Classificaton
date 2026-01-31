`timescale 1ns / 1ps
module top_ann_eda(
    input signed [15:0] features [0:7], // 8 input features Q8.8
    output reg signed [15:0] output_layer [0:3] // 4 output neurons
);

    reg signed [15:0] layer0_weights [0:127] = '{402,728,-77,392,-533,-701,-434,-161, ...};
    reg signed [15:0] layer0_biases [0:15] = '{-105,-197,-19,-92,93,131,47,85,169,-99,46,-120,69,-91,159,-23};
    reg signed [15:0] layer1_weights [0:63] = '{-58,-124,64,251,-183,183,9,253, ...};
    reg signed [15:0] layer1_biases [0:3] = '{4,-6,14,-19};

    integer i,j;
    reg signed [15:0] hidden [0:15];

    always @* begin
        // Hidden layer
        for (i = 0; i < 16; i = i + 1) begin
            integer acc;
            acc = 0;
            for (j = 0; j < 8; j = j + 1) acc = acc + features[j]*layer0_weights[i*8+j];
            acc = acc + (layer0_biases[i]<<8);
            hidden[i] = (acc << 8) / (256 + (acc<0 ? -acc : acc));
        end

        // Output layer
        for (i = 0; i < 4; i = i + 1) begin
            integer acc2;
            acc2 = 0;
            for (j = 0; j < 16; j = j + 1) acc2 = acc2 + hidden[j]*layer1_weights[i*16+j];
            acc2 = acc2 + (layer1_biases[i]<<8);
            output_layer[i] = (acc2 << 8) / (256 + (acc2<0 ? -acc2 : acc2));
        end
    end

endmodule
