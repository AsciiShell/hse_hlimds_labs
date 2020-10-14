module layer
#(
    parameter SIZE = 4
)
(
    input [19:0] x,
    output [SIZE - 1:0] predict
);
    reg [167:0] weights [SIZE - 1:0];
neuron neuron1(x, weights[0], predict[0]);
neuron neuron2(x, weights[1], predict[1]);
neuron neuron3(x, weights[2], predict[2]);
neuron neuron4(x, weights[3], predict[3]);

    initial begin
        $readmemh ("program.hex", weights);
    end
endmodule