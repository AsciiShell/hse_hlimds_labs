module decoder17 (
    input  [7:0]  select,
    output [16:0] out
    );

    assign out = 1'b1 << select;

endmodule
