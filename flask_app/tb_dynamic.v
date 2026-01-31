initial begin
    $readmemh("../verilog/layer0_weights.mem", layer0_weights);
    $readmemh("../verilog/layer0_biases.mem",   layer0_biases);
    $readmemh("../verilog/layer1_weights.mem", layer1_weights);
    $readmemh("../verilog/layer1_biases.mem",  layer1_biases);
end
