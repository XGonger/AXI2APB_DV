`ifndef GON_APB_SLAVE_READY_SV
`define GON_APB_SLAVE_READY_SV

class gon_apb_slave_ready extends gon_apb_base_sequence;

  rand bit [15 : 0]   addr;
  rand bit [32 : 0]   data;
  rand bit            pready;
  rand bit            pslverr;
  rand int unsigned   nready_num;
  rand burst_size_enum bsize;

  constraint slave_ready_cstr {
    soft data == 0;
    soft addr == 0;
    soft nready_num == 0;
    soft pready == 1'b1;
    soft pslverr == 1'b0;
    soft bsize == BURST_SIZE_32BIT;
  }

  `uvm_object_utils(gon_apb_slave_ready)
  function new(string name = "gon_apb_slave_ready");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Starting sequence", UVM_HIGH)
    `uvm_do_with(req, {
                       data == local::data;
                       addr == local::addr;
                       pready == local::pready;
                       pslverr == local::pslverr;
                       nready_num == local::nready_num;
                       burst_size == local::bsize;
                       })
    `uvm_info(get_type_name(), $psprintf("Done sequence:  %s", req.convert2string()), UVM_HIGH)
  endtask : body
  
endclass

`endif // GON_APB_SLAVE_READY_SV
