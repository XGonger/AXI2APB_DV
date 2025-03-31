`ifndef GON_AXI_BASE_SEQ_SV
`define GON_AXI_BASE_SEQ_SV

class gon_axi_base_seq extends uvm_sequence #(gon_axi_transaction);
  
  `uvm_object_utils(gon_axi_base_seq)
  function new(string name = "gon_axi_base_seq");
    super.new(name);
  endfunction
  
endclass

`endif 
