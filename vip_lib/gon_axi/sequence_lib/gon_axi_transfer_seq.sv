`ifndef GON_AXI_TRANSFER_SEQ_SV
`define GON_AXI_TRANSFER_SEQ_SV

class gon_axi_transfer_seq extends gon_axi_base_seq;
  
  rand bit wr_rd;
  rand bit id;
  rand bit [31:0] addr;
  rand burst_length_e burst_length;
  rand burst_size_e   burst_size;
  rand burst_type_e   burst_type;

  rand bit [31:0]     data[];
  rand bit [7:0]      strb;

  resp_e resp[];

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
  
  `uvm_object_utils(gon_axi_transfer_seq)
  function new(string name = "gon_axi_transfer_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Starting sequence", UVM_HIGH)
    `uvm_do_with(req, {
                  wr_rd == local::wr_rd;
                  id == local::id;
                  addr == local::addr;
                  burst_length == local::burst_length;
                  burst_size == local::burst_size;
                  burst_type == local::burst_type;
                  data.size() == local::data.size();
                  foreach(data[i]) {data[i] == local::data[i];}
                  strb == local::strb;
    })
    `uvm_info(get_type_name(), $psprintf("Done sequence:  %s", req.convert2string()), UVM_HIGH)

    get_response(rsp);
    if(wr_rd == READ) begin
      data = new[rsp.data.size()];
      foreach(data[i]) data[i] = rsp.data[i];
      resp = new[data.size()];
      foreach(resp[i]) resp[i] = rsp.resp[i];
    end
  endtask
  

  
endclass

`endif 


