`ifndef GON_CLK_RESET_SEQ_SV
`define GON_CLK_RESET_SEQ_SV

class gon_clk_reset_seq extends uvm_sequence #(gon_clk_reset_transaction);

  rand int unsigned period;
  rand int unsigned rst_cycle;
  rand bit power_on;

  constraint clk_reset_cstr {
    soft period == 10;
    soft rst_cycle == 0;
    soft power_on == 1'b1;
  }

  `uvm_object_utils(gon_clk_reset_seq)

  function new(string name = "gon_clk_reset_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info("body", "Entered...", UVM_LOW)
    `uvm_do_with(req, {
                        period == local::period;
                        rst_cycle == local::rst_cycle;
                        power_on == local::power_on;
    })

    `uvm_info("body", "Exited...", UVM_LOW)
  endtask


endclass

`endif
