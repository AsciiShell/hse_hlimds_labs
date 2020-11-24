module decoder17 (
    input clk,
    input  [7:0]  select,
    output reg [16:0] out
    );

    always @ (posedge clk)
        out <= 1'b1 << select;  

endmodule
