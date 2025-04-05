`ifndef GON_AXI2APB_ENV_SV
`define GON_AXI2APB_ENV_SV

class gon_axi2apb_env extends uvm_env;
  
  gon_axi2apb_config cfg;

  gon_axi_master_agent axi_mst;
  gon_apb_slave_agent  apb_slv;
  gon_clk_reset_agent  axi_clk_reset;
  gon_clk_reset_agent  apb_clk_reset;

  gon_axi2apb_scb scb;
  gon_axi2apb_cgm cgm;
  gon_axi2apb_virt_sqr virt_sqr;
  
  `uvm_component_utils(gon_axi2apb_env)

  function new(string name = "gon_axi2apb_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(gon_axi2apb_config)::get(this, "" , "cfg", cfg))
      `uvm_fatal("GETCFG", "cannot get config object from config db")

    uvm_config_db#(gon_axi_configuration)::set(this, "axi_mst*", "cfg", cfg.axi_config);
    uvm_config_db#(gon_apb_agent_configuration)::set(this, "apb_slv*", "cfg", cfg.apb_config);

    axi_mst = gon_axi_master_agent::type_id::create("axi_mst", this);
    apb_slv = gon_apb_slave_agent::type_id::create("apb_slv", this);
    axi_clk_reset = gon_clk_reset_agent::type_id::create("axi_clk_reset", this);
    apb_clk_reset = gon_clk_reset_agent::type_id::create("apb_clk_reset", this);

    scb = gon_axi2apb_scb::type_id::create("scb", this);
    cgm = gon_axi2apb_cgm::type_id::create("cgm", this);
    virt_sqr = gon_axi2apb_virt_sqr::type_id::create("virt_sqr", this);

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // scb and monitors
    // cgm and monitors
    // virt_sqr and sqr handles
    axi_mst.monitor.item_observed_port.connect(scb.axi_ana_fifo.analysis_export);
    axi_mst.monitor.item_observed_port.connect(cgm.axi_ana_fifo.analysis_export);

    apb_slv.monitor.item_observed_port.connect(scb.apb_ana_fifo.analysis_export);
    apb_slv.monitor.item_observed_port.connect(cgm.apb_ana_fifo.analysis_export);

    virt_sqr.axi_sqr = axi_mst.sequencer;
    virt_sqr.apb_sqr = apb_slv.sequencer;
    virt_sqr.axi_clk_reset_sqr = axi_clk_reset.sequencer;
    virt_sqr.apb_clk_reset_sqr = apb_clk_reset.sequencer;

  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask

endclass

`endif
