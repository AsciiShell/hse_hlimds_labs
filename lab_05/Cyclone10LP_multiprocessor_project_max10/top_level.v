//
//  Nios2  Multiprocessor Reference Design top-level verilog module for C10 LP design variant.
//  
//

module top_level
(
  input           clkin_50,
  input           clkin_125,

  input           cpu_reset_n
     
);

//
// Declare a localparam for the number of reset sources that exist in this design.
// This parameter will be used by the global_reset_generator module.
//
localparam RESET_SOURCES_COUNT = 1;

//
// define the wires required for the top level stitching
//

reg [(RESET_SOURCES_COUNT - 1):0]   resetn_sources;

wire            global_resetn;

//
// Tie the reset sources from the system into the global_reset_generator module.
// The reset counter width of 16 should provide a 2^16 clock assertion of global reset
// which at 50MHz should be 1.31ms long.
//
  always @ (*) begin
        resetn_sources[(RESET_SOURCES_COUNT - 1)]   <=  cpu_reset_n;
  end

global_reset_generator 
#(
  .RESET_SOURCES_WIDTH  (RESET_SOURCES_COUNT),
  .RESET_COUNTER_WIDTH  (16)
) global_reset_generator_inst
(
  .clk            (clkin_50),
  .resetn_sources (resetn_sources),
  .global_resetn  (global_resetn),
);

//
// The QSYS system instantiation.
//
multiprocessor_tutorial_main_system  multiprocessor_tutorial_main_system_inst
(
  // 1) global signals:
  .clk_in_clk                                                 (clkin_50),
  .clk_clk_in_reset_reset_n                                   (global_resetn)

);

endmodule
