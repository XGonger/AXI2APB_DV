`ifndef GON_CLK_RESET_DRIVER_SV
`define GON_CLK_RESET_DRIVER_SV

`timescale 1ns/10ps

class gon_clk_reset_driver extends uvm_driver #(gon_clk_reset_transaction);

  virtual gon_clk_reset_if vif;
  
  `uvm_component_utils(gon_clk_reset_driver)

  function new(string name = "gon_clk_reset_driver", uvm_component parent = null);
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
      clk_reset_drive();
    join_none
  endtask

  virtual task clk_reset_drive();
    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info(get_type_name(), "sequencer get next item", UVM_HIGH)
      drive_transfer(req);
      seq_item_port.item_done();
      `uvm_info(get_type_name(), "sequencer item_done_triggered", UVM_HIGH)
    end
  endtask

  virtual task drive_transfer(gon_clk_reset_transaction t);
    fork
      begin
        if(t.power_on) begin
          vif.clk = 1'b0;
          #50ns;
          vif.reset_ = 1'b0;
          #50ns;
          @(posedge vif.clk);
          vif.reset_ = 1'b1;
        end
      end

      begin
        if(t.power_on) begin
          forever begin
            #(t.period/2);
            vif.clk = ~vif.clk;
          end
        end
      end

      begin
        if(t.rst_cycle > 0) begin
          vif.reset_ = 1'b0;
          repeat(t.rst_cycle) @(posedge vif.clk);
          vif.reset_ = 1'b1;
        end
      end

    join_none
  endtask

endclass
  
`endif
