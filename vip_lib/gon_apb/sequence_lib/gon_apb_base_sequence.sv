`ifndef GON_APB_BASE_SEQUENCE_SV
`define GON_APB_BASE_SEQUENCE_SV

class gon_apb_base_sequence extends uvm_sequence #(gon_apb_transaction);
  
  `uvm_object_utils(gon_apb_base_sequence)
  function new(string name = "gon_apb_base_sequence");
    super.new(name);
  endfunction
  
endclass

`endif // GON_APB_BASE_SEQUENCE_SV
