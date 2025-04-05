`ifndef GON_AXI_MASTER_AGENT_SV
`define GON_AXI_MASTER_AGENT_SV

class gon_axi_master_agent extends uvm_agent;

   virtual gon_axi_master_if vif;
   gon_axi_configuration cfg;

   gon_axi_master_driver driver;
   gon_axi_master_monitor monitor;
   gon_axi_master_sequencer sequencer;
  
  `uvm_component_utils(gon_axi_master_agent)

  function new(string name = "gon_axi_master_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(gon_axi_configuration)::get(this, "" , "cfg", cfg))
      `uvm_fatal("GETCFG", "cannot get config object from config db")

    if(!uvm_config_db#(virtual gon_axi_master_if)::get(this, "" , "vif", vif))
      `uvm_fatal("GETVIF", "cannot get vif handle from config db")

    monitor = gon_axi_master_monitor::type_id::create("monitor", this);

    if(cfg.is_active) begin
      sequencer = gon_axi_master_sequencer::type_id::create("sequencer", this);
      driver = gon_axi_master_driver::type_id::create("driver", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    monitor.vif = vif;
    if(cfg.is_active) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
      driver.vif = vif;
      sequencer.vif = vif;
    end
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask

endclass

`endif
