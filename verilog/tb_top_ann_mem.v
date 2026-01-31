`timescale 1ns / 1ps

module tb_top_ann_mem;

    // -----------------------------
    // Input feature vector (Q8.8)
    // -----------------------------
    reg signed [15:0] f0, f1, f2, f3, f4, f5, f6, f7;

    // -----------------------------
    // ANN outputs (Q8.8)
    // -----------------------------
    wire signed [15:0] o0, o1, o2, o3;
    wire [1:0] predicted_stage;

    // -----------------------------
    // DUT instantiation
    // -----------------------------
    top_ann_mem dut (
        .f0(f0), .f1(f1), .f2(f2), .f3(f3),
        .f4(f4), .f5(f5), .f6(f6), .f7(f7),
        .o0(o0), .o1(o1), .o2(o2), .o3(o3),
        .predicted_stage(predicted_stage)
    );

    // -----------------------------
    // Test sequence
    // -----------------------------
    initial begin

        // === Test vector 1 ===
        // Example feature vector from Python verification
        f0 = 16'sd128;
        f1 = 16'sd64;
        f2 = 16'sd200;
        f3 = 16'sd100;
        f4 = 16'sd131;
        f5 = 16'sd90;
        f6 = 16'sd210;
        f7 = 16'sd84;

        #20;

        $display("--------------------------------------------------");
        $display("Test 1 Outputs (Q8.8)");
        $display("o0 = %d, o1 = %d, o2 = %d, o3 = %d",
                  o0, o1, o2, o3);
        $display("Predicted Sleep Stage = %d", predicted_stage);
        $display("--------------------------------------------------");

        // === Test vector 2 ===
        // Different feature pattern
        f0 = 16'sd80;
        f1 = 16'sd120;
        f2 = 16'sd60;
        f3 = 16'sd90;
        f4 = 16'sd150;
        f5 = 16'sd70;
        f6 = 16'sd180;
        f7 = 16'sd110;

        #20;

        $display("--------------------------------------------------");
        $display("Test 2 Outputs (Q8.8)");
        $display("o0 = %d, o1 = %d, o2 = %d, o3 = %d",
                  o0, o1, o2, o3);
        $display("Predicted Sleep Stage = %d", predicted_stage);
        $display("--------------------------------------------------");

        $finish;
    end

endmodule
