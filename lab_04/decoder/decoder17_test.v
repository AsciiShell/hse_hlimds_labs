`timescale 1ns / 1ns

module decoder17_test;
    typedef bit [16:0] bv17;
    import "DPI-C" function void decoder17_c(input int select, output bv17 out ); 

    int src;
    bv17 out;
    parameter CLK_PD = 100;               
    bit clock = 0;        
    reg [7:0] src_verilog;               
    reg [16:0] out_verilog;

    always #(CLK_PD/2) clock = ~clock;
    decoder17 decoder17
    (
		.clk     (clock),
        .select  ( src_verilog),
        .out     ( out_verilog )
    );


    initial begin
        src = 0;
        src_verilog = 8'b00000000;
    end;

    always @ (posedge clock)
    begin
        
        decoder17_c(src, out);
        #1; // Wait for verilog
        $display("src %d: result %x, verilog: %x", src, out, out_verilog);

        src = src + 1;
        src_verilog = src_verilog + 1;
        if (src > 17)
        begin
            $stop;
        end
    end


endmodule