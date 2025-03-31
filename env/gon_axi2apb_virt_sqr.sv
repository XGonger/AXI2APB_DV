`ifndef GON_AXI2APB_VIRT_SQR_SV
`define GON_AXI2APB_VIRT_SQR_SV

class gon_axi2apb_virt_sqr extends uvm_sequencer;

  gon_axi_master_sequencer axi_sqr;
  gon_apb_sequencer apb_sqr;
  gon_clk_reset_sequencer axi_clk_reset_sqr;
  gon_clk_reset_sequencer apb_clk_reset_sqr;

  `uvm_component_utils(gon_axi2apb_virt_sqr);

  function new(string name = "gon_axi2apb_virt_sqr", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask

endclass
`endif
