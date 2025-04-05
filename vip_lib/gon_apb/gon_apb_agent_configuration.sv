`ifndef GON_APB_AGENT_CONFIGURATION_SV
`define GON_APB_AGENT_CONFIGURATION_SV


class gon_apb_agent_configuration extends uvm_object;
  bit reset_state_check = 0;
  bit is_active = 1;

  `uvm_object_utils_begin(gon_apb_agent_configuration)
  `uvm_object_utils_end

  function new(string name = "gon_apb_agent_configuration");
    super.new(name);
  endfunction


endclass

`endif // GON_APB_AGENT_CONFIGURATION_SV
