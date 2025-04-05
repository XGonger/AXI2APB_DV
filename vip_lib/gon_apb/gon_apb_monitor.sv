`ifndef GON_APB_MONITOR_SV
`define GON_APB_MONITOR_SV

class gon_apb_monitor extends uvm_monitor;
  gon_apb_agent_configuration cfg;
  virtual gon_apb_if vif;

  gon_apb_transaction t;

  bit reset_state_check_flag = 0;
  bit reset_state_flag = 0;
  uvm_analysis_port #(gon_apb_transaction) item_observed_port;

  `uvm_component_utils(gon_apb_monitor)

  function new(string name = "gon_apb_monitor", uvm_component parent = null);
    super.new(name, parent);
    item_observed_port = new("item_observed_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(gon_apb_agent_configuration)::get(this, "", "cfg", cfg))
      `uvm_fatal("GETCFG", "cannot get config object")
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork
      monitor_transaction();
      reset_state_check_task();
    join_none
  endtask

  virtual task monitor_transaction();
    forever begin
      collect_transfer(t);
    end
  endtask

  virtual task collect_transfer(output gon_apb_transaction t);
    @(vif.cb_mon);
    if(reset_state_flag)
      return;
    if(vif.cb_mon.psel && vif.cb_mon.penable && vif.pready) begin
      t = gon_apb_transaction::type_id::create("t");
      t.xact_type = xact_type_enum'(vif.cb_mon.pwrite);
      t.addr = vif.cb_mon.paddr;
      t.pstrb = vif.cb_mon.pstrb;
      t.pprot = vif.cb_mon.pprot;
      t.data = t.xact_type ? vif.cb_mon.pwdata : vif.cb_mon.prdata;
      item_observed_port.write(t);
    end
  endtask

  virtual task reset_state_check_task();
    if(cfg.reset_state_check) begin
      forever begin
        @(posedge vif.pclk iff vif.presetn == 0);
        if(vif.paddr != 0 || vif.penable != 0 || vif.psel != 0 || vif.pwrite != 0 || vif.pwdata != 0)
          reset_state_check_flag = 1;
        if(reset_state_check_flag)
          `uvm_error("RSTCHK", "reset state check error")
      end
    end
  endtask

  virtual task reset_listener();
    `uvm_info(get_type_name(), "reset_listener ...", UVM_LOW)
    fork
      forever begin
        @(negedge vif.presetn);
        reset_state_flag = 1;
        @(vif.cb_mon);
        _do_monitor_idle();
        @(posedge vif.presetn);
        reset_state_flag = 0;
      end
    join_none
  endtask

  virtual task _do_monitor_idle();
    t = null;
  endtask

endclass

`endif // GON_APB_MONITOR_SV
