`ifndef GON_APB_CONFIGURATION_SV
`define GON_APB_CONFIGURATION_SV


class gon_apb_configuration extends uvm_object;
  `uvm_object_utils_begin(gon_apb_configuration)
  `uvm_object_utils_end

  function new(string name = "gon_apb_configuration");
    super.new(name);
  endfunction


endclass

`endif // GON_APB_CONFIGURATION_SV
