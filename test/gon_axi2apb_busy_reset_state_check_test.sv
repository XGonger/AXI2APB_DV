`ifndef GON_AXI2APB_BUSY_RESET_STATE_CHECK_TEST_SV
`define GON_AXI2APB_BUSY_RESET_STATE_CHECK_TEST_SV

class gon_axi2apb_busy_reset_state_check_test extends gon_axi2apb_base_test;

  gon_axi2apb_busy_reset_state_check_virt_seq seq;
  
  `uvm_component_utils(gon_axi2apb_busy_reset_state_check_test)

  function new(string name = "gon_axi2apb_busy_reset_state_check_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // cfg modify begin
    cfg.axi_config.reset_state_check = 1;
    cfg.apb_config.reset_state_check = 1;
    // cfg modify end

    uvm_config_db#(gon_axi2apb_config)::set(this, "env", "cfg", cfg);
    env = gon_axi2apb_env::type_id::create("env", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    seq = gon_axi2apb_busy_reset_state_check_virt_seq::type_id::create("seq", this);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq.start(env.virt_sqr);
    phase.drop_objection(this);
  endtask
endclass

`endif

