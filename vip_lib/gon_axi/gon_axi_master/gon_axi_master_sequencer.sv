`ifndef GON_AXI_MASTER_SEQUENCER_SV
`define GON_AXI_MASTER_SEQUENCER_SV

class gon_axi_master_sequencer extends uvm_sequencer #(gon_axi_transaction);

  virtual gon_axi_master_if vif;

  `uvm_component_utils(gon_axi_master_sequencer)

  function new(string name = "gon_axi_master_sequencer", uvm_component parent = null);
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
