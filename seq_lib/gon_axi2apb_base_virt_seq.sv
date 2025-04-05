`ifndef GON_AXI2APB_BASE_VIRT_SEQ_SV
`define GON_AXI2APB_BASE_VIRT_SEQ_SV

class gon_axi2apb_base_virt_seq extends uvm_sequence;

  gon_axi2apb_clk_reset_set_seq clk_reset_set;
  gon_axi2apb_write_seq burst_write;
  gon_axi2apb_read_seq burst_read;

  `uvm_declare_p_sequencer(gon_axi2apb_virt_sqr)

  `uvm_object_utils(gon_axi2apb_base_virt_seq)

  function new(string name = "gon_axi2apb_base_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info("body", "Entered...", UVM_LOW)

    `uvm_info("body", "Exited...", UVM_LOW)
  endtask

  function write_read_data_compare(bit [31:0] wr_data[], bit [31:0] rd_data[]);
    `uvm_info("DATACOMP", "write and read data compare begin", UVM_HIGH)
    foreach(wr_data[i]) begin
      if(wr_data[i] != rd_data[i])
        `uvm_error("DATACOMP_FAIL", $sformatf("wr_data[%0d] %0x != rd_data[%0d] %0x", i, wr_data[i], i, rd_data[i]))
      else
        `uvm_info("DATACOMP_SUCCESS", $sformatf("wr_data[%0d] %x == rd_data[%0d] %0x", i, wr_data[i], i, rd_data[i]),UVM_HIGH)
    end
    `uvm_info("DATACOMP", "write and read data compare end", UVM_HIGH)
  endfunction

endclass

`endif
