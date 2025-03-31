`ifndef GON_APB_SLAVE_AGENT_SV
`define GON_APB_SLAVE_AGENT_SV

class gon_apb_slave_agent extends uvm_agent;
  
  gon_apb_agent_configuration cfg;

  gon_apb_slave_driver driver;
  
  gon_apb_slave_monitor monitor;

  gon_apb_slave_sequencer sequencer;

  virtual gon_apb_if vif;

  `uvm_component_utils(gon_apb_slave_agent)

  function new(string name = "gon_apb_slave_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(gon_apb_agent_configuration)::get(this,"","cfg", cfg)) begin
      `uvm_fatal("GETCFG","cannot get config object from config DB")
    end
    if(!uvm_config_db#(virtual gon_apb_if)::get(this,"","vif", vif)) begin
      `uvm_fatal("GETVIF","cannot get vif handle from config DB")
    end

    monitor = gon_apb_slave_monitor::type_id::create("monitor", this);

    if(cfg.is_active) begin
      driver = gon_apb_slave_driver::type_id::create("driver", this);
      sequencer = gon_apb_slave_sequencer::type_id::create("sequencer", this);
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


`endif // GON_APB_SLAVE_AGENT_SV
