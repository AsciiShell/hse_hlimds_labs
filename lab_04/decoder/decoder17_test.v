`timescale 1ns / 1ns

module decoder17_test;
    typedef bit [16:0] bv17;
    import "DPI-C" function void decoder17(input int select, output bv17 out ); 
    int src;
    bv17 out;
    initial begin
        src = 0;
        decoder17(src, out);
        $display("src %d: result %x", src, out);
        src = 1;
        decoder17(src, out);
        $display("src %d: result %x", src, out);
    end;
endmodule