`ifndef GON_AXI2APB_FREE_RESET_STATE_CHECK_VIRT_SEQ_SV
`define GON_AXI2APB_FREE_RESET_STATE_CHECK_VIRT_SEQ_SV

class gon_axi2apb_free_reset_state_check_virt_seq extends gon_axi2apb_base_virt_seq;
  
  `uvm_object_utils(gon_axi2apb_free_reset_state_check_virt_seq)

  function new(string name = "gon_axi2apb_free_reset_state_check_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    
    `uvm_do(clk_reset_set);

    #250ns;
    `uvm_info("body", "Exited...", UVM_LOW)
   
  endtask
endclass
`endif
