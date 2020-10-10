module neuron
(
    input [19:0] x,
    input [167:0] weights,
    output predict
);
    wire [7:0] bias = weights[7:0];
    wire [7:0] w [19:0];
    assign w[0] = weights[15:8];
    assign w[1] = weights[23:16];
    assign w[2] = weights[31:24];
    assign w[3] = weights[39:32];
    assign w[4] = weights[47:40];
    assign w[5] = weights[55:48];
    assign w[6] = weights[63:56];
    assign w[7] = weights[71:64];
    assign w[8] = weights[79:72];
    assign w[9] = weights[87:80];
    assign w[10] = weights[95:88];
    assign w[11] = weights[103:96];
    assign w[12] = weights[111:104];
    assign w[13] = weights[119:112];
    assign w[14] = weights[127:120];
    assign w[15] = weights[135:128];
    assign w[16] = weights[143:136];
    assign w[17] = weights[151:144];
    assign w[18] = weights[159:152];
    assign w[19] = weights[167:160];

    assign predict_000 = bias + x[0] ? w[0] : 8'h00;
    assign predict_001 = x[1] ? w[1] : 8'h00 + x[2] ? w[2] : 8'h00;
    assign predict_002 = x[3] ? w[3] : 8'h00 + x[4] ? w[4] : 8'h00;
    assign predict_003 = x[5] ? w[5] : 8'h00 + x[6] ? w[6] : 8'h00;
    assign predict_004 = x[7] ? w[7] : 8'h00 + x[8] ? w[8] : 8'h00;
    assign predict_005 = x[9] ? w[9] : 8'h00 + x[10] ? w[10] : 8'h00;
    assign predict_006 = x[11] ? w[11] : 8'h00 + x[12] ? w[12] : 8'h00;
    assign predict_007 = x[13] ? w[13] : 8'h00 + x[14] ? w[14] : 8'h00;
    assign predict_008 = x[15] ? w[15] : 8'h00 + x[16] ? w[16] : 8'h00;
    assign predict_009 = x[17] ? w[17] : 8'h00 + x[18] ? w[18] : 8'h00;
    assign predict_010 = x[19] ? w[19] : 8'h00 + predict_000;
    assign predict_011 = predict_001 + predict_002;
    assign predict_012 = predict_003 + predict_004;
    assign predict_013 = predict_005 + predict_006;
    assign predict_014 = predict_007 + predict_008;
    assign predict_015 = predict_009 + predict_010;
    assign predict_016 = predict_011 + predict_012;
    assign predict_017 = predict_013 + predict_014;
    assign predict_018 = predict_015 + predict_016;
    assign predict_019 = predict_017 + predict_018;
    assign predict = predict_019 > 0;


endmodule