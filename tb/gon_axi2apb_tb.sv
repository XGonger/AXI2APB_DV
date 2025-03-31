`ifndef MST_NUM
  `define MST_NUM 1
`endif

`ifndef DATA_SIZE
  `define DATA_SIZE 32
`endif

`ifndef APB_DATA_SIZE
  `define APB_DATA_SIZE 32
`endif

module gon_axi2apb_tb;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import gon_axi2apb_pkg::*;

  logic psel_s0;
  logic psel_s1;
  logic psel_s2;
  
  gon_clk_reset_if axi_clk_reset_if();
  gon_clk_reset_if apb_clk_reset_if();
  gon_axi_master_if axi_if[`MST_NUM](axi_clk_reset_if.clk, axi_clk_reset_if.reset_);
  gon_apb_if apb_if();
  assign apb_if.pclk = apb_clk_reset_if.clk;
  assign apb_if.presetn = apb_clk_reset_if.reset_;
 
  // initiate the dut
  DW_axi_x2p dut(
    // clock and resetn
    .aclk(axi_clk_reset_if.clk),
    .aresetn(axi_clk_reset_if.reset_),
    // write address channel
    .awid(axi_if[0].AXI_AWID),
    .awaddr(axi_if[0].AXI_AWADDR),
    .awlen(axi_if[0].AXI_AWLEN),
    .awsize(axi_if[0].AXI_AWSIZE),
    .awburst(axi_if[0].AXI_AWBURST),
    .awlock(axi_if[0].AXI_AWLOCK),
    .awcache(axi_if[0].AXI_AWCACHE),
    .awprot(axi_if[0].AXI_AWPROT),
    .awvalid(axi_if[0].AXI_AWVALID),
    .awready(axi_if[0].AXI_AWREADY),
    // write data channel
    .wid(axi_if[0].AXI_WID),
    .wdata(axi_if[0].AXI_WDATA),
    .wstrb(axi_if[0].AXI_WSTRB),
    .wlast(axi_if[0].AXI_WLAST),
    .wready(axi_if[0].AXI_WREADY),
    .wvalid(axi_if[0].AXI_WVALID),
    // write response channel
    .bid(axi_if[0].AXI_BID),
    .bresp(axi_if[0].AXI_BRESP),
    .bvalid(axi_if[0].AXI_BVALID),
    .bready(axi_if[0].AXI_BREADY),
    // read address channel
    .arid(axi_if[0].AXI_ARID),
    .araddr(axi_if[0].AXI_ARADDR),
    .arlen(axi_if[0].AXI_ARLEN),
    .arsize(axi_if[0].AXI_ARSIZE),
    .arburst(axi_if[0].AXI_ARBURST),
    .arlock(axi_if[0].AXI_ARLOCK),
    .arcache(axi_if[0].AXI_ARCACHE),
    .arprot(axi_if[0].AXI_ARPROT),
    .arvalid(axi_if[0].AXI_ARVALID),
    .arready(axi_if[0].AXI_ARREADY),
    // read data channel
    .rid(axi_if[0].AXI_RID),
    .rdata(axi_if[0].AXI_RDATA),
    .rlast(axi_if[0].AXI_RLAST),
    .rresp(axi_if[0].AXI_RRESP),
    .rready(axi_if[0].AXI_RREADY),
    .rvalid(axi_if[0].AXI_RVALID),
    // apb
    .pclk(apb_clk_reset_if.clk),
    .presetn(apb_clk_reset_if.reset_),
    .psel_s0(psel_s0),
    .psel_s1(psel_s1),
    .psel_s2(psel_s2),
    .paddr(apb_if.paddr),
    .penable(apb_if.penable),
    .pwdata(apb_if.pwdata),
    .pwrite(apb_if.pwrite),
    //.pready(apb_if.pready),
    .prdata_s0(apb_if.prdata),
    .prdata_s1(apb_if.prdata),
    .prdata_s2(apb_if.prdata)
  );

  assign apb_if.psel = psel_s0 | psel_s1 | psel_s2;
  assign apb_if.pready = 1'b1;

  initial begin
    uvm_config_db#(virtual gon_axi_master_if)::set(null, "uvm_test_top.env.axi_mst", "vif", axi_if[0]);
    uvm_config_db#(virtual gon_apb_if)::set(null, "uvm_test_top.env.apb_slv", "vif", apb_if);
    uvm_config_db#(virtual gon_clk_reset_if)::set(null, "uvm_test_top.env.axi_clk_reset", "vif", axi_clk_reset_if);
    uvm_config_db#(virtual gon_clk_reset_if)::set(null, "uvm_test_top.env.apb_clk_reset", "vif", apb_clk_reset_if);
    run_test();
  end
  
  //////////////////////////////////
  // assertions definition here
  // P1 handshake process
  property gon_axi2apb_p1_handshake(valid, ready);
    @(posedge axi_clk_reset_if.clk) disable iff (!axi_clk_reset_if.reset_)
    $rose(valid) |-> (valid throughout ##[0:$] ready) ##0 (valid && ready);
  endproperty

  assert property(gon_axi2apb_p1_handshake(axi_if[0].AXI_AWVALID, axi_if[0].AXI_AWREADY))
    else `uvm_error("ASSERT", "write address channel: handshake process goes wrong!")
  assert property(gon_axi2apb_p1_handshake(axi_if[0].AXI_WVALID, axi_if[0].AXI_WREADY))
    else `uvm_error("ASSERT", "write data channel: handshake process goes wrong!")
  assert property(gon_axi2apb_p1_handshake(axi_if[0].AXI_BVALID, axi_if[0].AXI_BREADY))
    else `uvm_error("ASSERT", "write response channel: handshake process goes wrong!")
  assert property(gon_axi2apb_p1_handshake(axi_if[0].AXI_ARVALID, axi_if[0].AXI_ARREADY))
    else `uvm_error("ASSERT", "read address channel: handshake process goes wrong!")
  assert property(gon_axi2apb_p1_handshake(axi_if[0].AXI_RVALID, axi_if[0].AXI_RREADY))
    else `uvm_error("ASSERT", "read data channel: handshake process goes wrong!")

  // P2 read address before read data
  property gon_axi2apb_p2_read_address_before_data;
    @(posedge axi_clk_reset_if.clk) disable iff (!axi_clk_reset_if.reset_)
    (axi_if[0].AXI_ARVALID && axi_if[0].AXI_ARREADY) |-> ##[1:$] (axi_if[0].AXI_RVALID && axi_if[0].AXI_RREADY);
  endproperty

  assert property(gon_axi2apb_p2_read_address_before_data)
    else `uvm_error("ASSERT", "read address phase is not prior to read data phase!")

  // P3 write data phase before write response phase
  property gon_axi2apb_p3_write_data_before_response;
    @(posedge axi_clk_reset_if.clk) disable iff (!axi_clk_reset_if.reset_)
    (axi_if[0].AXI_WVALID && axi_if[0].AXI_WREADY && axi_if[0].AXI_WLAST) |-> ##[1:$] (axi_if[0].AXI_BVALID && axi_if[0].AXI_BREADY);
  endproperty

  assert property(gon_axi2apb_p3_write_data_before_response)
    else `uvm_error("ASSERT", "write data phase is not prior to write response phase")

  // P4 write address phase before write response phase
  property gon_axi2apb_p4_write_address_before_response;
    @(posedge axi_clk_reset_if.clk) disable iff (!axi_clk_reset_if.reset_)
    (axi_if[0].AXI_AWVALID && axi_if[0].AXI_AWREADY) |-> ##[1:$] (axi_if[0].AXI_BVALID && axi_if[0].AXI_BREADY);
  endproperty

  assert property(gon_axi2apb_p4_write_address_before_response)
    else `uvm_error("ASSERT", "write address phase is not prior to write response phase")
  
  // p5 address must not be x when slave is selected 
  property gon_axi2apb_p5_paddr_no_x;
    @(posedge axi_clk_reset_if.clk) disable iff (!axi_clk_reset_if.reset_)
    apb_if.psel |-> !$isunknown(apb_if.paddr);
  endproperty: gon_axi2apb_p5_paddr_no_x
  assert property(gon_axi2apb_p5_paddr_no_x) else `uvm_error("ASSERT", "PADDR is unknown when PSEL is high")
  
  // P6 psel rose and the next cycle penable rose
  property gon_axi2apb_p6_psel_rose_next_cycle_penable_rise;
    @(posedge axi_clk_reset_if.clk) disable iff (!axi_clk_reset_if.reset_)
    $rose(apb_if.psel) |=> $rose(apb_if.penable);
  endproperty: gon_axi2apb_p6_psel_rose_next_cycle_penable_rise
  assert property(gon_axi2apb_p6_psel_rose_next_cycle_penable_rise) else `uvm_error("ASSERT", "PENABLE not rose after 1 cycle PSEL rose")

  // p7 penable and pready high, the next cycle penable fall,
  property gon_axi2apb_p7_penable_rose_next_cycle_fall;
    @(posedge axi_clk_reset_if.clk) disable iff (!axi_clk_reset_if.reset_)
    apb_if.penable && apb_if.pready |=> $fell(apb_if.penable);
  endproperty: gon_axi2apb_p7_penable_rose_next_cycle_fall
  assert property(gon_axi2apb_p7_penable_rose_next_cycle_fall) else `uvm_error("ASSERT", "PENABLE not fall after 1 cycle PENABLE rose")

  // p8 pwdata must be stable during trans phase
  property gon_axi2apb_p8_pwdata_stable_during_trans_phase;
    @(posedge axi_clk_reset_if.clk) disable iff (!axi_clk_reset_if.reset_)
    ((apb_if.psel && !apb_if.penable) ##1 (apb_if.psel && apb_if.penable)) |-> $stable(apb_if.pwdata);
  endproperty: gon_axi2apb_p8_pwdata_stable_during_trans_phase
  assert property(gon_axi2apb_p8_pwdata_stable_during_trans_phase) else `uvm_error("ASSERT", "PWDATA not stable during transaction phase")

  // p9 paddr must be stable until next transaction
  property gon_axi2apb_p9_paddr_stable_until_next_trans;
    logic[31:0] addr1, addr2;
    @(posedge axi_clk_reset_if.clk) disable iff (!axi_clk_reset_if.reset_)
    first_match(($rose(apb_if.penable),addr1=apb_if.paddr) ##1 ((apb_if.psel && !apb_if.penable)[=1],addr2=$past(apb_if.paddr))) |-> addr1 == addr2;
  endproperty: gon_axi2apb_p9_paddr_stable_until_next_trans
  assert property(gon_axi2apb_p9_paddr_stable_until_next_trans) else `uvm_error("ASSERT", "PADDR not stable until next transaction start")

//  // p10 pwrite must be stable until next transaction
//  property gon_axi2apb_p10_pwrite_stable_until_next_trans;
//    logic pwrite1, pwrite2;
//    @(posedge axi_clk_reset_if.clk) disable iff (!axi_clk_reset_if.reset_)
//    first_match(($rose(apb_if.penable),pwrite1=apb_if.pwrite) ##1 ((apb_if.psel && !apb_if.penable)[=1],pwrite2=$past(apb_if.pwrite))) |-> pwrite1 == pwrite2;
//  endproperty: gon_axi2apb_p10_pwrite_stable_until_next_trans
//  assert property(gon_axi2apb_p10_pwrite_stable_until_next_trans) else `uvm_error("ASSERT", "PWRITE not stable until next transaction start")
  
endmodule
