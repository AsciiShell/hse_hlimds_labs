
`timescale 1 ns / 100 ps

`ifndef SIMULATION_CYCLES
    `define SIMULATION_CYCLES 512
`endif

module sm_testbench;

    // simulation options
    parameter Tt     = 20;

    reg         [19:0] x;
    wire        [3:0] predict;


    layer layer
    (
        .x     ( x     ),
        .predict     ( predict   )

    );


`ifdef ICARUS
    initial $dumpvars;
    initial $dumpvars(0, predict);
`endif

    // simulation init
    initial begin
        x = 20'b10011111101110101110;#(Tt);
        x = 20'b10011001100110100110;#(Tt);
        x = 20'b11110001111100011111;#(Tt);
        x = 20'b01010101001101010101;#(Tt);
        x = 20'b11100010001000101110;#(Tt);
        x = 20'b10011011110111011001;#(Tt);
        x = 20'b11101010111000100011;#(Tt);
        x = 20'b00010010011011011001;#(Tt);
        $stop;

    end
endmodule
