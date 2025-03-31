`ifndef GON_CLK_RESET_PKG_SV
`define GON_CLK_RESET_PKG_SV

package gon_clk_reset_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "gon_clk_reset_transaction.sv"
  `include "gon_clk_reset_driver.sv"
  `include "gon_clk_reset_sequencer.sv"
  `include "gon_clk_reset_agent.sv"
  `include "./sequence_lib/gon_clk_reset_seq.sv"
endpackage

`endif
