`ifndef GON_APB_DRIVER_SV
`define GON_APB_DRIVER_SV

class gon_apb_driver #(type REQ = gon_apb_transaction, type RSP = REQ) extends uvm_driver #(REQ, RSP);
  gon_apb_agent_configuration cfg;
  virtual gon_apb_if vif;

  `uvm_component_utils(gon_apb_driver)

  function new(string name = "gon_apb_driver", uvm_component parent = null);
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
    fork
      get_and_dirve();
      reset_listener();
    join_none
  endtask

  virtual task get_and_dirve();
    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info(get_type_name(), "sequencer get next item", UVM_HIGH)
      drive_transfer(req);
      void'($cast(rsp, req.clone()));
      rsp.set_sequence_id(req.get_sequence_id());
      rsp.set_transaction_id(req.get_transaction_id());
      // no rsp transfer now
      seq_item_port.item_done();
      `uvm_info(get_type_name(), "sequencer item_done_triggered", UVM_HIGH)
    end
  endtask

  virtual task drive_transfer(REQ t);
  endtask
  
  virtual task reset_listener(); 
  endtask
endclass


`endif // GON_APB_DRIVER_SV
