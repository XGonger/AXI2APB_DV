`ifndef GON_CLK_RESET_AGENT_SV
`define GON_CLK_RESET_AGENT_SV

class gon_clk_reset_agent extends uvm_agent;

   virtual gon_clk_reset_if vif;

   gon_clk_reset_driver driver;
   gon_clk_reset_sequencer sequencer;
  
  `uvm_component_utils(gon_clk_reset_agent)

  function new(string name = "gon_clk_reset_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual gon_clk_reset_if)::get(this, "" , "vif", vif))
      `uvm_fatal("GETVIF", "cannot get vif handle from config db")

    sequencer = gon_clk_reset_sequencer::type_id::create("sequencer", this);
    driver = gon_clk_reset_driver::type_id::create("driver", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
    driver.vif = vif;
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask

endclass

`endif
