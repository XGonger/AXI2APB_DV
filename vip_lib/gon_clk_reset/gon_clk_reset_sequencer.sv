`ifndef GON_CLK_RESET_SEQUENCER_SV
`define GON_CLK_RESET_SEQUENCER_SV

class gon_clk_reset_sequencer extends uvm_sequencer #(gon_clk_reset_transaction);

  virtual gon_clk_reset_if vif;

  `uvm_component_utils(gon_clk_reset_sequencer)

  function new(string name = "gon_clk_reset_sequencer", uvm_component parent = null);
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
