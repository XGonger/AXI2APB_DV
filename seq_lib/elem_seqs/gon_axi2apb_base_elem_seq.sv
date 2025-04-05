`ifndef GON_AXI2APB_BASE_ELEM_SEQ_SV
`define GON_AXI2APB_BASE_ELEM_SEQ_SV

class gon_axi2apb_base_elem_seq extends uvm_sequence;

  // vip sequences declaration
  gon_clk_reset_seq axi_clk_reset_seq;
  gon_clk_reset_seq apb_clk_reset_seq;
  gon_apb_slave_ready slave_ready_seq;

  gon_axi_transfer_seq axi_transfer_seq;

  `uvm_declare_p_sequencer(gon_axi2apb_virt_sqr)

  `uvm_object_utils(gon_axi2apb_base_elem_seq)

  function new(string name = "gon_axi2apb_base_elem_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info("body", "Entered...", UVM_LOW)

    `uvm_info("body", "Exited...", UVM_LOW)
  endtask
endclass
`endif
