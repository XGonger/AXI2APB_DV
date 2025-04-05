`ifndef GON_AXI2APB_BUSY_RESET_STATE_CHECK_VIRT_SEQ_SV
`define GON_AXI2APB_BUSY_RESET_STATE_CHECK_VIRT_SEQ_SV

class gon_axi2apb_busy_reset_state_check_virt_seq extends gon_axi2apb_base_virt_seq;
  
  `uvm_object_utils(gon_axi2apb_busy_reset_state_check_virt_seq)

  function new(string name = "gon_axi2apb_busy_reset_state_check_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    bit id = 1'b1; // transaction id
    bit [31:0] addr;
    int unsigned cycle_to_wait;
    burst_length_e burst_length = LENGTH_16;
    burst_size_e burst_size = BYTE_004;
    burst_type_e burst_type = INCR;
    bit [31:0] data[];
    bit [7:0] strb = 8'hF;
    `uvm_info("body", "Entered...", UVM_LOW)
    std::randomize(addr) with {addr inside {[32'h400:32'hFFF]}; addr[1:0] == 2'b00;};
    std::randomize(data) with {data.size() == (int'(burst_length) + 1);
                               foreach(data[i]) {data[i] == ((i+1)<<24) + ((i+1)<<16) + ((i+1)<<8) + (i+1);}
    };
    std::randomize(cycle_to_wait) with {cycle_to_wait inside {[3:8]};};

    `uvm_do(clk_reset_set)
    
    fork
      `uvm_do_with(burst_write, {
                                  id == local::id;
                                  addr == local::addr;
                                  burst_length == local::burst_length;
                                  burst_size == local::burst_size;
                                  burst_type == local::burst_type;
                                  data.size() == local::data.size();
                                  foreach(data[i]) {data[i] == local::data[i];}
                                  strb == local::strb;
      })
      
      begin
        @(posedge p_sequencer.axi_clk_reset_sqr.vif.reset_);
        repeat(cycle_to_wait) @(posedge p_sequencer.axi_clk_reset_sqr.vif.clk);
        `uvm_do_with(clk_reset_set, {
              power_on == 1'b0;
              rst_cycle == 5;
        })
        @(posedge p_sequencer.axi_clk_reset_sqr.vif.reset_);
      end
    join

    `uvm_do_with(burst_write, {
                                id == local::id;
                                addr == local::addr;
                                burst_length == local::burst_length;
                                burst_size == local::burst_size;
                                burst_type == local::burst_type;
                                data.size() == local::data.size();
                                foreach(data[i]) {data[i] == local::data[i];}
                                strb == local::strb;
    })

    `uvm_do_with(burst_read, {
                                id == local::id;
                                addr == local::addr;
                                burst_length == local::burst_length;
                                burst_size == local::burst_size;
                                burst_type == local::burst_type;
    })

    write_read_data_compare(data, burst_read.axi_transfer_seq.data);

    #50ns;
    `uvm_info("body", "Exited...", UVM_LOW)
   
  endtask
endclass
`endif
