`ifndef GON_AXI2APB_SMOKE_VIRT_SEQ_SV
`define GON_AXI2APB_SMOKE_VIRT_SEQ_SV

class gon_axi2apb_smoke_virt_seq extends gon_axi2apb_base_virt_seq;
  
  `uvm_object_utils(gon_axi2apb_smoke_virt_seq)

  function new(string name = "gon_axi2apb_smoke_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    bit id = 1'b1;
    bit [31:0] addr;
    burst_length_e burst_length = LENGTH_01;
    burst_size_e burst_size = BYTE_004;
    burst_type_e burst_type = FIXED;
    bit [31:0] data[];
    bit [7:0] strb = 8'hF;
    `uvm_info("body", "Entered...", UVM_LOW)
    std::randomize(addr) with {addr inside {[32'h400:32'hFFF]}; addr[1:0] == 2'b00;};
    std::randomize(data) with {data.size() == (int'(burst_length) + 1);
                               foreach(data[i]) {data[i] == ((i+1)<<24) + ((i+1)<<16) + ((i+1)<<8) + (i+1);}
    };

    `uvm_do(clk_reset_set);
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
