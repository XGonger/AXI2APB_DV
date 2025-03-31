`ifndef GON_AXI2APB_CLK_RESET_SET_SEQ_SV
`define GON_AXI2APB_CLK_RESET_SET_SEQ_SV

class gon_axi2apb_clk_reset_set_seq extends gon_axi2apb_base_elem_seq;
  
  rand int unsigned axi_period;
  rand int unsigned apb_period;
  rand int unsigned rst_cycle;
  rand bit power_on;

  constraint clk_reset_set_cstr{
    soft axi_period == 10;
    soft apb_period == 10;
    soft rst_cycle == 0;
    soft power_on == 1'b1;
  }

  `uvm_object_utils(gon_axi2apb_clk_reset_set_seq)

  function new(string name = "gon_axi2apb_clk_reset_set_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info("body", "Entered...", UVM_LOW)
    fork
      `uvm_do_on_with(axi_clk_reset_seq, p_sequencer.axi_clk_reset_sqr, {
                      period == local::axi_period;
                      rst_cycle == local::rst_cycle;
                      power_on == local::power_on;
      })
      `uvm_do_on_with(apb_clk_reset_seq, p_sequencer.apb_clk_reset_sqr, {
                      period == local::apb_period;
                      rst_cycle == local::rst_cycle;
                      power_on == local::power_on;
      })
    join
    `uvm_info("body", "Exiting...", UVM_LOW)
  endtask

endclass

`endif
