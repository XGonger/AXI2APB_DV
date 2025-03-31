`ifndef GON_CLK_RESET_TRANSACTION_SV
`define GON_CLK_RESET_TRANSACTION_SV

class gon_clk_reset_transaction extends uvm_sequence_item;
  
  rand bit power_on;
  rand int unsigned period;
  rand int unsigned rst_cycle;

  `uvm_object_utils_begin(gon_clk_reset_transaction)
    `uvm_field_int(power_on, UVM_ALL_ON)
    `uvm_field_int(period, UVM_ALL_ON)
    `uvm_field_int(rst_cycle, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "gon_clk_reset_transaction");
    super.new(name);
    power_on = 1'b0;
    period = 0;
    rst_cycle = 0;
  endfunction

endclass

`endif
