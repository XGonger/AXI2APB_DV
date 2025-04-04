`ifndef GON_APB_MONITOR_SV
`define GON_APB_MONITOR_SV

class gon_apb_monitor extends uvm_monitor;
  gon_apb_agent_configuration cfg;
  virtual gon_apb_if vif;

  uvm_analysis_port #(gon_apb_transaction) item_observed_port;

  `uvm_component_utils(gon_apb_monitor)

  function new(string name = "gon_apb_monitor", uvm_component parent = null);
    super.new(name, parent);
    item_observed_port = new("item_observed_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork
      monitor_transaction();
    join_none
  endtask

  virtual task monitor_transaction();
    gon_apb_transaction t;
    forever begin
      collect_transfer(t);
      item_observed_port.write(t);
    end
  endtask

  virtual task collect_transfer(output gon_apb_transaction t);
    t = gon_apb_transaction::type_id::create("t");
    @(vif.cb_mon iff (vif.cb_mon.psel && !vif.cb_mon.penable));
    t.xact_type = xact_type_enum'(vif.cb_mon.pwrite);
    t.addr = vif.cb_mon.paddr;
    t.pstrb = vif.cb_mon.pstrb;
    t.pprot = vif.cb_mon.pprot;
    @(vif.cb_mon iff vif.cb_mon.pready);
    t.data = t.xact_type ? vif.cb_mon.pwdata : vif.cb_mon.prdata;
  endtask

endclass

`endif // GON_APB_MONITOR_SV
