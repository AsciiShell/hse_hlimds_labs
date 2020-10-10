module layer
#(
    parameter SIZE = 4
)
(
    input [19:0] x,
    output [SIZE - 1:0] predict
);
    reg [167:0] weights [SIZE - 1:0];
    genvar i;
    generate
        for(i = 0; i < SIZE; i = i + 1) 
        begin: 
            neuron neuron(x, weights[i], predict[i]);
        end
    endgenerate

    initial begin
        $readmemh ("program.hex", weights);
    end
endmodule