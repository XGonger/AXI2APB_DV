`ifndef GON_AXI2APB_PKG_SV
`define GON_AXI2APB_PKG_SV

package gon_axi2apb_pkg;
  
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  import gon_apb_pkg::*;
  import gon_axi_pkg::*;
  import gon_clk_reset_pkg::*;

  `include "gon_axi2apb_config.sv"
  `include "gon_axi2apb_subscriber.sv"
  `include "gon_axi2apb_cgm.sv"
  `include "gon_axi2apb_scb.sv"
  `include "gon_axi2apb_virt_sqr.sv"
  `include "gon_axi2apb_env.sv"

  `include "gon_axi2apb_seq_lib.svh"
  `include "gon_axi2apb_tests.svh"

endpackage

`endif
