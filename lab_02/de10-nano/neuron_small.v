
module neuron
(
    input [8:0] x,
    input [79:0] weights,
    output predict
);
    wire [7:0] bias = weights[7:0];
    wire [7:0] w [8:0];
    assign w[0] = weights[15:8];
    assign w[1] = weights[23:16];
    assign w[2] = weights[31:24];
    assign w[3] = weights[39:32];
    assign w[4] = weights[47:40];
    assign w[5] = weights[55:48];
    assign w[6] = weights[63:56];
    assign w[7] = weights[71:64];
    assign w[8] = weights[79:72];
    
    wire [7:0] predict_000 = bias + (x[0] ? w[0] : 8'h00);
    wire [7:0] predict_001 = (x[1] ? w[1] : 8'h00) + (x[2] ? w[2] : 8'h00);
    wire [7:0] predict_002 = (x[3] ? w[3] : 8'h00) + (x[4] ? w[4] : 8'h00);
    wire [7:0] predict_003 = (x[5] ? w[5] : 8'h00) + (x[6] ? w[6] : 8'h00);
    wire [7:0] predict_004 = (x[7] ? w[7] : 8'h00) + (x[8] ? w[8] : 8'h00);
    wire [7:0] predict_005 = predict_000 + predict_001;
    wire [7:0] predict_006 = predict_002 + predict_003;
    wire [7:0] predict_007 = predict_004 + predict_005;
    wire [7:0] predict_008 = predict_006 + predict_007;
    assign predict = predict_008[7] == 0;


endmodule
