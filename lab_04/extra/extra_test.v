`timescale 1ns / 1ns

module extra_test;
    typedef bit [11:0] bit_arr [7:0];
    import "DPI-C" function void extra_c(inout bit[] i [] ); 

    bit_arr arr;
    bit do_convert = 0;

    initial begin
        int i;
        for (i = 0; i < 8; i++) begin
            arr[i] = i;
            #10;
        end;
        extra_c(arr);
        do_convert = 1;
        #100
        for (i = 0; i < 8; i++) begin
            $display("src %d: result %d", i, arr[i]);
        end;
        
        $stop;
    end


endmodule