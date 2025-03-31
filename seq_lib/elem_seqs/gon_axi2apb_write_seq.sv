`ifndef GON_AXI2APB_WRITE_SEQ_SV
`define GON_AXI2APB_WRITE_SEQ_SV

class gon_axi2apb_write_seq extends gon_axi2apb_base_elem_seq;

  rand bit id;
  rand bit [31:0] addr;
  rand burst_length_e burst_length;
  rand burst_size_e   burst_size;
  rand burst_type_e   burst_type;

  rand bit [31:0]     data[];
  rand bit [7:0]      strb;
  int unsigned i;

  constraint cstr {
    soft id == 1'b0;
    soft addr == 32'h1000;
    soft burst_length == LENGTH_01;
    soft burst_size == BYTE_001;
    soft burst_type == FIXED;
    soft data.size() == 1;
    soft data[0] == 32'h1;
    soft strb == 8'hF;
  }
  
  `uvm_object_utils(gon_axi2apb_write_seq)
  function new(string name = "gon_axi2apb_write_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Starting sequence", UVM_HIGH)
    
    fork
      begin
        for(i=0;i<=burst_length;i++) begin
          `uvm_do_on_with(slave_ready_seq, p_sequencer.apb_sqr, {
                          nready_num == 0;
                          pready == 1'b1;
                          pslverr == 1'b0;
                          burst_size == BURST_SIZE_32BIT;
          })
        end
      end

      begin
        `uvm_do_on_with(axi_transfer_seq, p_sequencer.axi_sqr, {
                        wr_rd == 1'b1;
                        id == local::id;
                        addr == local::addr;
                        burst_length == local::burst_length;
                        burst_size == local::burst_size;
                        burst_type == local::burst_type;
                        data.size() == local::data.size();
                        foreach(data[i]) {data[i] == local::data[i];}
                        strb == local::strb;
        })
      end
    join
    `uvm_info(get_type_name(), $psprintf("Done sequence"), UVM_HIGH)
  endtask
  
endclass

`endif 


