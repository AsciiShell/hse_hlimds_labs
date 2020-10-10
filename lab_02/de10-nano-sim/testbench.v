
`timescale 1 ns / 100 ps

`ifndef SIMULATION_CYCLES
    `define SIMULATION_CYCLES 1000
`endif

module sm_testbench;

    // simulation options
    parameter Tt     = 2000;

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
        x = 20'b11111001100111111001;#(Tt);
        x = 20'b11111001100110011001;#(Tt);
        x = 20'b11111000111110001111;#(Tt);
        x = 20'b10101010110010101010;#(Tt);
        x = 20'b11111000100010001111;#(Tt);
        x = 20'b10011011101111011001;#(Tt);
        x = 20'b11000100011101010111;#(Tt);
        x = 20'b10011011011001001000;#(Tt);
        $stop;
        
    end
endmodule
