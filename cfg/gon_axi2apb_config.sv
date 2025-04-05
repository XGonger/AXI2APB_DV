`ifndef GON_AXI2APB_CONFIG_SV
`define GON_AXI2APB_CONFIG_SV

class gon_axi2apb_config extends uvm_object;
  

  gon_axi_configuration axi_config;
  gon_apb_agent_configuration apb_config;

  `uvm_object_utils(gon_axi2apb_config)

  function new(string name = "gon_axi2apb_config");
    super.new(name);
    axi_config = gon_axi_configuration::type_id::create("axi_config");
    apb_config = gon_apb_agent_configuration::type_id::create("apb_config");
  endfunction

endclass


`endif
