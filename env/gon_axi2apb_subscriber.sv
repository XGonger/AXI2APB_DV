`ifndef GON_AXI2APB_SUBSCRIBER_SV
`define GON_AXI2APB_SUBSCRIBER_SV

class gon_axi2apb_subscriber extends uvm_component;
  uvm_blocking_get_port#(gon_axi_transaction) axi_get_port;
  uvm_blocking_get_port#(gon_apb_transaction) apb_get_port;

  uvm_tlm_analysis_fifo#(gon_axi_transaction) axi_ana_fifo;
  uvm_tlm_analysis_fifo#(gon_apb_transaction) apb_ana_fifo;

  `uvm_component_utils(gon_axi2apb_subscriber)

  function new(string name = "gon_axi2apb_subscriber", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    axi_get_port = new("axi_get_port", this);
    apb_get_port = new("apb_get_port", this);
    axi_ana_fifo = new("axi_ana_fifo", this);
    apb_ana_fifo = new("apb_ana_fifo", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    axi_get_port.connect(axi_ana_fifo.blocking_get_export);
    apb_get_port.connect(apb_ana_fifo.blocking_get_export);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask

endclass
`endif
