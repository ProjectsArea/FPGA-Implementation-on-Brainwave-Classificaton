// tb_top_ann.v
`timescale 1ns / 1ps

module tb_top_ann;

    // Inputs
    reg signed [15:0] feature0;
    reg signed [15:0] feature1;
    reg signed [15:0] feature2;
    reg signed [15:0] feature3;
    reg signed [15:0] feature4;
    reg signed [15:0] feature5;
    reg signed [15:0] feature6;
    reg signed [15:0] feature7;

    // Output
    wire [1:0] predicted_stage;

    // Instantiate ANN
    top_ann uut(
        .feature0(feature0),
        .feature1(feature1),
        .feature2(feature2),
        .feature3(feature3),
        .feature4(feature4),
        .feature5(feature5),
        .feature6(feature6),
        .feature7(feature7),
        .predicted_stage(predicted_stage)
    );

    initial begin
        // Test case 1
        feature0=128; feature1=64; feature2=200; feature3=100;
        feature4=131; feature5=90; feature6=210; feature7=84;

        #10;
        $display("Predicted stage: %d", predicted_stage);

        // Test case 2
        feature0=64; feature1=128; feature2=50; feature3=180;
        feature4=90; feature5=210; feature6=100; feature7=131;

        #10;
        $display("Predicted stage (Test 2): %d", predicted_stage);

        $finish;
    end

endmodule
