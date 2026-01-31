
`timescale 1ns/1ps
module tb_top_ann_dynamic;
    reg signed [15:0] f0,f1,f2,f3,f4,f5,f6,f7;
    wire [1:0] predicted_stage;

    top_ann_mem dut(
        .f0(f0),.f1(f1),.f2(f2),.f3(f3),
        .f4(f4),.f5(f5),.f6(f6),.f7(f7),
        .predicted_stage(predicted_stage)
    );

    initial begin
        f0 = 16'sd0;
        f1 = 16'sd0;
        f2 = 16'sd0;
        f3 = 16'sd0;
        f4 = 16'sd0;
        f5 = 16'sd0;
        f6 = 16'sd0;
        f7 = 16'sd42;

        #100;
        $display("PREDICTED_STAGE=%0d", predicted_stage);
        $finish;
    end
endmodule
