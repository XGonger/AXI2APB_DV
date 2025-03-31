`ifndef GON_APB_TRANSACTION_SV
`define GON_APB_TRANSACTION_SV

class gon_apb_transaction extends uvm_sequence_item;
  
  rand bit [31:0]   data;
  rand bit [15:0]   addr;
  rand bit          pready;
  rand bit          pslverr;
  rand bit [2:0]    pprot;
  rand bit [3:0]    pstrb;
  rand int unsigned nready_num; 
  rand burst_size_enum burst_size;
  rand xact_type_enum xact_type;

  `uvm_object_utils_begin(gon_apb_transaction)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(pready, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(pslverr, UVM_ALL_ON)
    `uvm_field_int(pstrb, UVM_ALL_ON)
    `uvm_field_int(pprot, UVM_ALL_ON)
    `uvm_field_int(nready_num, UVM_ALL_ON)
    `uvm_field_enum(burst_size_enum, burst_size, UVM_ALL_ON)
    `uvm_field_enum(xact_type_enum, xact_type, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "gon_apb_transaction");
    super.new(name);
  endfunction
endclass

`endif // GON_APB_TRANSACTION_SV
