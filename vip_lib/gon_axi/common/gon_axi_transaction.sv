`ifndef GON_AXI_TRANSACTION_SV
`define GON_AXI_TRANSACTION_SV

class gon_axi_transaction extends uvm_sequence_item;
  
  rand bit wr_rd;  // write or read transaction
  rand bit trans_of_reset; // indicate response when it is reset, should be ignored,
  
  // address phase
  rand bit          id;
  rand bit [31:0]   addr;
  rand burst_length_e burst_length;
  rand burst_size_e   burst_size;
  rand burst_type_e   burst_type;
  
  // data phase
  rand bit [31:0]   data[];
  rand bit [7:0]    strb;   // used only when write access
  resp_e              resp[]; // read and write response array 


  `uvm_object_utils_begin(gon_axi_transaction)
    `uvm_field_int(wr_rd, UVM_ALL_ON)
    `uvm_field_int(trans_of_reset, UVM_ALL_ON)
    `uvm_field_int(id, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_enum(burst_length_e, burst_length, UVM_ALL_ON)
    `uvm_field_enum(burst_size_e, burst_size, UVM_ALL_ON)
    `uvm_field_enum(burst_type_e, burst_type, UVM_ALL_ON)
    `uvm_field_array_int(data, UVM_ALL_ON)
    `uvm_field_int(strb, UVM_ALL_ON)
    `uvm_field_array_enum(resp_e, resp, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "gon_axi_transaction");
    super.new(name);
    wr_rd = WRITE;
    trans_of_reset = 0;
    id    = 1'b0;
    addr  = 32'h0;
    burst_length = LENGTH_01;
    burst_size   = BYTE_001;
    burst_type   = FIXED;
    strb         = 8'h0;
  endfunction

endclass



`endif
