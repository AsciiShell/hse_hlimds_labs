module neuron
(
    input [19:0] x,
    output predict
);
    reg [7:0] bias;
    reg [7:0] w [19:0];

    assign predict = ( bias + x[0] * w[0] + x[1] * w[1] + x[2] * w[2] + x[3] * w[3] + x[4] * w[4] + x[5] * w[5] + x[6] * w[6] + x[7] * w[7] + x[8] * w[8] + x[9] * w[9] + x[10] * w[10] + x[11] * w[11] + x[12] * w[12] + x[13] * w[13] + x[14] * w[14] + x[15] * w[15] + x[16] * w[16] + x[17] * w[17] + x[18] * w[18] + x[19] * w[19]) > 0;

    initial begin
		bias = 7'h00;
		w[0] = 8'h02;
		w[1] = 8'hfe;
		w[2] = 8'hfe;
		w[3] = 8'h00;
		w[4] = 8'h00;
		w[5] = 8'h02;
		w[6] = 8'hfe;
		w[7] = 8'h02;
		w[8] = 8'hfe;
		w[9] = 8'hfe;
		w[10] = 8'h02;
		w[11] = 8'hfe;
		w[12] = 8'h02;
		w[13] = 8'hfe;
		w[14] = 8'hfe;
		w[15] = 8'h00;
		w[16] = 8'h04;
		w[17] = 8'h02;
		w[18] = 8'h00;
		w[19] = 8'h00;
    end

endmodule