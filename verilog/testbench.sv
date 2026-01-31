`timescale 1ns / 1ps
module tb_top_ann_eda;
    reg signed [15:0] f0, f1, f2, f3, f4, f5, f6, f7;
    wire signed [15:0] o0, o1, o2, o3;
    reg [1:0] predicted_class;
    integer i;

    top_ann_eda uut (
        .f0(f0), .f1(f1), .f2(f2), .f3(f3),
        .f4(f4), .f5(f5), .f6(f6), .f7(f7),
        .o0(o0), .o1(o1), .o2(o2), .o3(o3)
    );

    initial begin
        $display("=== FPGA ANN EEG Classification Test ===");
        
        // Test 1: Relaxed state (high alpha, moderate beta)
        $display("\nTest 1: Relaxed State");
        f0 = 180; f1 = 120; f2 = 220; f3 = 80;
        f4 = 100; f5 = 50; f6 = 110; f7 = 30;
        #10;
        // Use absolute values for argmax
        predicted_class = 0;
        if ((o1 > 0 ? o1 : -o1) > (o0 > 0 ? o0 : -o0)) predicted_class = 1;
        if ((o2 > 0 ? o2 : -o2) > (o0 > 0 ? o0 : -o0) && (o2 > 0 ? o2 : -o2) > (o1 > 0 ? o1 : -o1)) predicted_class = 2;
        if ((o3 > 0 ? o3 : -o3) > (o0 > 0 ? o0 : -o0) && (o3 > 0 ? o3 : -o3) > (o1 > 0 ? o1 : -o1) && (o3 > 0 ? o3 : -o3) > (o2 > 0 ? o2 : -o2)) predicted_class = 3;
        $display("Inputs: f0=%d, f1=%d, f2=%d, f3=%d, f4=%d, f5=%d, f6=%d, f7=%d", f0, f1, f2, f3, f4, f5, f6, f7);
        $display("Outputs: o0=%d, o1=%d, o2=%d, o3=%d", o0, o1, o2, o3);
        $display("Absolute values: o0=%d, o1=%d, o2=%d, o3=%d", 
                 (o0 > 0) ? o0 : -o0, (o1 > 0) ? o1 : -o1, 
                 (o2 > 0) ? o2 : -o2, (o3 > 0) ? o3 : -o3);
        $display("Predicted Class: %0d (0=Relaxed, 1=Stress, 2=Drowsy, 3=Sleep)", predicted_class);

        // Test 2: Stress state (high beta, low alpha)
        $display("\nTest 2: Stress State");
        f0 = 60; f1 = 40; f2 = 50; f3 = 250;
        f4 = 150; f5 = 200; f6 = 180; f7 = 220;
        #10;
        predicted_class = 0;
        if ((o1 > 0 ? o1 : -o1) > (o0 > 0 ? o0 : -o0)) predicted_class = 1;
        if ((o2 > 0 ? o2 : -o2) > (o0 > 0 ? o0 : -o0) && (o2 > 0 ? o2 : -o2) > (o1 > 0 ? o1 : -o1)) predicted_class = 2;
        if ((o3 > 0 ? o3 : -o3) > (o0 > 0 ? o0 : -o0) && (o3 > 0 ? o3 : -o3) > (o1 > 0 ? o1 : -o1) && (o3 > 0 ? o3 : -o3) > (o2 > 0 ? o2 : -o2)) predicted_class = 3;
        $display("Inputs: f0=%d, f1=%d, f2=%d, f3=%d, f4=%d, f5=%d, f6=%d, f7=%d", f0, f1, f2, f3, f4, f5, f6, f7);
        $display("Outputs: o0=%d, o1=%d, o2=%d, o3=%d", o0, o1, o2, o3);
        $display("Absolute values: o0=%d, o1=%d, o2=%d, o3=%d", 
                 (o0 > 0) ? o0 : -o0, (o1 > 0) ? o1 : -o1, 
                 (o2 > 0) ? o2 : -o2, (o3 > 0) ? o3 : -o3);
        $display("Predicted Class: %0d (0=Relaxed, 1=Stress, 2=Drowsy, 3=Sleep)", predicted_class);

        // Test 3: Drowsy state (high theta, moderate delta)
        $display("\nTest 3: Drowsy State");
        f0 = 120; f1 = 200; f2 = 80; f3 = 60;
        f4 = 90; f5 = 70; f6 = 95; f7 = 120;
        #10;
        predicted_class = 0;
        if ((o1 > 0 ? o1 : -o1) > (o0 > 0 ? o0 : -o0)) predicted_class = 1;
        if ((o2 > 0 ? o2 : -o2) > (o0 > 0 ? o0 : -o0) && (o2 > 0 ? o2 : -o2) > (o1 > 0 ? o1 : -o1)) predicted_class = 2;
        if ((o3 > 0 ? o3 : -o3) > (o0 > 0 ? o0 : -o0) && (o3 > 0 ? o3 : -o3) > (o1 > 0 ? o1 : -o1) && (o3 > 0 ? o3 : -o3) > (o2 > 0 ? o2 : -o2)) predicted_class = 3;
        $display("Inputs: f0=%d, f1=%d, f2=%d, f3=%d, f4=%d, f5=%d, f6=%d, f7=%d", f0, f1, f2, f3, f4, f5, f6, f7);
        $display("Outputs: o0=%d, o1=%d, o2=%d, o3=%d", o0, o1, o2, o3);
        $display("Absolute values: o0=%d, o1=%d, o2=%d, o3=%d", 
                 (o0 > 0) ? o0 : -o0, (o1 > 0) ? o1 : -o1, 
                 (o2 > 0) ? o2 : -o2, (o3 > 0) ? o3 : -o3);
        $display("Predicted Class: %0d (0=Relaxed, 1=Stress, 2=Drowsy, 3=Sleep)", predicted_class);

        // Test 4: Sleep state (high delta, low beta)
        $display("\nTest 4: Sleep State");
        f0 = 250; f1 = 100; f2 = 60; f3 = 30;
        f4 = 80; f5 = 40; f6 = 90; f7 = 20;
        #10;
        predicted_class = 0;
        if ((o1 > 0 ? o1 : -o1) > (o0 > 0 ? o0 : -o0)) predicted_class = 1;
        if ((o2 > 0 ? o2 : -o2) > (o0 > 0 ? o0 : -o0) && (o2 > 0 ? o2 : -o2) > (o1 > 0 ? o1 : -o1)) predicted_class = 2;
        if ((o3 > 0 ? o3 : -o3) > (o0 > 0 ? o0 : -o0) && (o3 > 0 ? o3 : -o3) > (o1 > 0 ? o1 : -o1) && (o3 > 0 ? o3 : -o3) > (o2 > 0 ? o2 : -o2)) predicted_class = 3;
        $display("Inputs: f0=%d, f1=%d, f2=%d, f3=%d, f4=%d, f5=%d, f6=%d, f7=%d", f0, f1, f2, f3, f4, f5, f6, f7);
        $display("Outputs: o0=%d, o1=%d, o2=%d, o3=%d", o0, o1, o2, o3);
        $display("Absolute values: o0=%d, o1=%d, o2=%d, o3=%d", 
                 (o0 > 0) ? o0 : -o0, (o1 > 0) ? o1 : -o1, 
                 (o2 > 0) ? o2 : -o2, (o3 > 0) ? o3 : -o3);
        $display("Predicted Class: %0d (0=Relaxed, 1=Stress, 2=Drowsy, 3=Sleep)", predicted_class);

        $display("\n=== Test Complete ===");
        $finish;
    end
endmodule
