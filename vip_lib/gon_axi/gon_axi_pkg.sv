`ifndef GON_AXI_PKG_SV
`define GON_AXI_PKG_SV

package gon_axi_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "./common/gon_axi_types.sv"
  `include "./common/gon_axi_transaction.sv"
  `include "./common/gon_axi_configuration.sv"
  `include "./gon_axi_master/gon_axi_master_driver.sv"
  `include "./gon_axi_master/gon_axi_master_monitor.sv"
  `include "./gon_axi_master/gon_axi_master_sequencer.sv"
  `include "./gon_axi_master/gon_axi_master_agent.sv"
  `include "gon_axi_seq_lib.svh"


endpackage
`endif
