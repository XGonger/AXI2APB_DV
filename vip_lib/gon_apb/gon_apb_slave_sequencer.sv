`ifndef GON_APB_SLAVE_SEQUENCER_SV
`define GON_APB_SLAVE_SEQUENCER_SV

class gon_apb_slave_sequencer extends gon_apb_sequencer;
  gon_apb_agent_configuration cfg;
  virtual gon_apb_if vif;

  `uvm_component_utils(gon_apb_slave_sequencer)

  function new(string name = "gon_apb_slave_sequencer", uvm_component parent = null);
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


`endif // GON_APB_SLAVE_SEQUENCER_SV
