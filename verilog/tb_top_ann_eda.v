`timescale 1ns / 1ps
module tb_top_ann_eda;

    reg signed [15:0] features [0:7];
    wire signed [15:0] output_layer [0:3];
    integer i; reg [1:0] predicted_class;

    top_ann_eda uut(.features(features), .output_layer(output_layer));

    initial begin
        // Test vector 1
        features[0]=128; features[1]=64; features[2]=200; features[3]=100;
        features[4]=131; features[5]=90; features[6]=210; features[7]=84;
        #10;
        predicted_class=0;
        for(i=1;i<4;i=i+1) if(output_layer[i]>output_layer[predicted_class]) predicted_class=i;
        $display("Predicted stage (Test 1): %0d", predicted_class);

        // Test vector 2
        features[0]=100; features[1]=120; features[2]=140; features[3]=160;
        features[4]=180; features[5]=200; features[6]=220; features[7]=240;
        #10;
        predicted_class=0;
        for(i=1;i<4;i=i+1) if(output_layer[i]>output_layer[predicted_class]) predicted_class=i;
        $display("Predicted stage (Test 2): %0d", predicted_class);

        $finish;
    end

endmodule
