`ifndef GON_AXI2APB_CGM_SV
`define GON_AXI2APB_CGM_SV

class gon_axi2apb_cgm extends gon_axi2apb_subscriber;

  `uvm_component_utils(gon_axi2apb_cgm);

  // Covergroup definition below
  // T1 AXI address
  covergroup gon_axi2apb_t1_address_cg with function sample(bit [31:0] addr, bit wr_rd);
    option.name = "T1 axi2apb write and read address range coverage";
    WR_ADDR: coverpoint addr iff (wr_rd == 1'b1) {
      bins addr_start      = {32'h400};
      bins addr_end        = {[32'hFFF - 64 : 32'hFFF]};
      bins legal_range[32] = {[32'h400 : 32'hFFF]};
    }
    RD_ADDR: coverpoint addr iff (wr_rd == 1'b0) {
      bins addr_start      = {32'h400};
      bins addr_end        = {[32'hFFF - 64 : 32'hFFF]};
      bins legal_range[32] = {[32'h400 : 32'hFFF]};
    }
  endgroup

  // T2 burst length coverage
  covergroup gon_axi2apb_t2_length_cg with function sample(burst_length_e burst_length, bit wr_rd);
    option.name = "T2 axi2apb write and read burst length coverage";
    WR_LEN: coverpoint burst_length iff (wr_rd == 1'b1) {
      bins length_01 = {LENGTH_01};
      bins length_02 = {LENGTH_02};
      bins length_03 = {LENGTH_03};
      bins length_04 = {LENGTH_04};
      bins length_05 = {LENGTH_05};
      bins length_06 = {LENGTH_06};
      bins length_07 = {LENGTH_07};
      bins length_08 = {LENGTH_08};
      bins length_09 = {LENGTH_09};
      bins length_10 = {LENGTH_10};
      bins length_11 = {LENGTH_11};
      bins length_12 = {LENGTH_12};
      bins length_13 = {LENGTH_13};
      bins length_14 = {LENGTH_14};
      bins length_15 = {LENGTH_15};
      bins length_16 = {LENGTH_16};
    }
    RD_LEN: coverpoint burst_length iff (wr_rd == 1'b0) {
      bins length_01 = {LENGTH_01};
      bins length_02 = {LENGTH_02};
      bins length_03 = {LENGTH_03};
      bins length_04 = {LENGTH_04};
      bins length_05 = {LENGTH_05};
      bins length_06 = {LENGTH_06};
      bins length_07 = {LENGTH_07};
      bins length_08 = {LENGTH_08};
      bins length_09 = {LENGTH_09};
      bins length_10 = {LENGTH_10};
      bins length_11 = {LENGTH_11};
      bins length_12 = {LENGTH_12};
      bins length_13 = {LENGTH_13};
      bins length_14 = {LENGTH_14};
      bins length_15 = {LENGTH_15};
      bins length_16 = {LENGTH_16};
    }
  endgroup

  // T3 axi2apb burst type coverage
  covergroup gon_axi2apb_t3_type_cg with function sample(burst_type_e burst_type, bit wr_rd);
    option.name = "T3 axi2apb write and read burst type coverage";
    WR_TYPE: coverpoint burst_type iff (wr_rd == 1'b1) {
      bins fixed = {FIXED};
      bins incr  = {INCR};
      bins wrap  = {WRAP};
    }
    RD_TYPE: coverpoint burst_type iff (wr_rd == 1'b0) {
      bins fixed = {FIXED};
      bins incr  = {INCR};
      bins wrap  = {WRAP}; 
    }
  endgroup

  // T4 axi2apb strobe coverage
  covergroup gon_axi2apb_t4_strob_cg with function sample(bit [7:0] strob);
    option.name = "T4 axi2apb write strobes coverage";
    STROB: coverpoint strob{
      bins all_on = {8'hF};
      bins all_off = {8'h0};
    }
  endgroup

  function new(string name = "gon_axi2apb_cgm", uvm_component parent);
    super.new(name, parent);
    // covergroups new here
    gon_axi2apb_t1_address_cg = new();
    gon_axi2apb_t2_length_cg = new();
    gon_axi2apb_t3_type_cg = new();
    gon_axi2apb_t4_strob_cg = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork
      func_cover();
    join_none
  endtask

  virtual task func_cover();
    gon_axi_transaction axi_trans;
    gon_apb_transaction apb_trans;
    forever begin
      axi_get_port.get(axi_trans);
      apb_get_port.get(apb_trans);

      gon_axi2apb_t1_address_cg.sample(axi_trans.addr, axi_trans.wr_rd);
      gon_axi2apb_t2_length_cg.sample(axi_trans.burst_length, axi_trans.wr_rd);
      gon_axi2apb_t3_type_cg.sample(axi_trans.burst_type, axi_trans.wr_rd);
      gon_axi2apb_t4_strob_cg.sample(axi_trans.strb);
    end
  endtask

endclass
`endif
