`ifndef GON_AXI2APB_BASE_TEST_SV
`define GON_AXI2APB_BASE_TEST_SV

class gon_axi2apb_base_test extends uvm_test;

  gon_axi2apb_config cfg;
  gon_axi2apb_env env;
  
  `uvm_component_utils(gon_axi2apb_base_test)

  function new(string name = "gon_axi2apb_base_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cfg = gon_axi2apb_config::type_id::create("cfg", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    phase.drop_objection(this);
  endtask
endclass

`endif

