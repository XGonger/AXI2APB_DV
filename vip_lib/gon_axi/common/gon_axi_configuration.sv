`ifndef GON_AXI_CONFIGURATION_SV
`define GON_AXI_CONFIGURATION_SV

class base_config extends uvm_object;
  `uvm_object_utils(base_config)

  function new(string name = "base_conf");
    super.new(name);
  endfunction
endclass

class gon_axi_configuration extends uvm_object;
    
  bit is_active = 1'b1;
  
  `uvm_object_utils(gon_axi_configuration)

  function new(string name = "gon_axi_configuration");
    super.new(name);
  endfunction
endclass
`endif
