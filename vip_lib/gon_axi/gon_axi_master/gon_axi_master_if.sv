`ifndef GON_AXI_MASTER_IF_SV
`define GON_AXI_MASTER_IF_SV

interface gon_axi_master_if #(
  parameter integer C_AXI_ID_WIDTH    = 1,
  parameter integer C_AXI_ADDR_WIDTH  = 32,
  parameter integer C_AXI_REG_WIDTH   = 4,
  parameter integer C_AXI_DATA_WIDTH  = 64,
  parameter integer C_AXI_LEN_WIDTH   = 4,
  parameter integer C_AXI_SIZE_WIDTH  = 3,
  parameter integer C_AXI_BURST_WIDTH = 2,
  parameter integer C_AXI_CACHE_WIDTH = 4,
  parameter integer C_AXI_PROT_WIDTH  = 3,
  parameter integer C_AXI_QOS_WIDTH   = 4,
  parameter integer C_AXI_STRB_WIDTH  = 8,
  parameter integer C_AXI_RESP_WIDTH  = 2,
  parameter integer C_AXI_LOCK_WIDTH  = 2,
  parameter integer C_AXI_VALID_WIDTH = 1,
  parameter integer C_AXI_READY_WIDTH = 1,
  parameter integer C_AXI_LAST_WIDTH  = 1,
  parameter string  name = "master_if"
) (input AXI_ACLK, input AXI_ARESET_N);

  import gon_axi_pkg::*;

  // AXI address write channel
  logic [C_AXI_ID_WIDTH - 1 : 0]     AXI_AWID;
  logic [C_AXI_ADDR_WIDTH - 1 : 0]   AXI_AWADDR;
  logic [C_AXI_REG_WIDTH - 1 : 0]    AXI_AWREG;
  logic [C_AXI_LEN_WIDTH - 1 : 0]    AXI_AWLEN;
  logic [C_AXI_SIZE_WIDTH - 1 : 0]   AXI_AWSIZE;
  logic [C_AXI_BURST_WIDTH - 1 : 0]  AXI_AWBURST;
  logic [C_AXI_LOCK_WIDTH - 1 : 0]   AXI_AWLOCK;
  logic [C_AXI_CACHE_WIDTH - 1 : 0]  AXI_AWCACHE;
  logic [C_AXI_PROT_WIDTH - 1 : 0]   AXI_AWPROT;
  logic [C_AXI_QOS_WIDTH - 1 : 0]    AXI_AWQOS;
  logic [C_AXI_VALID_WIDTH - 1 : 0]  AXI_AWVALID;
  logic [C_AXI_READY_WIDTH - 1 : 0]  AXI_AWREADY;
  
  // AXI data write channel
  logic [C_AXI_ID_WIDTH - 1 : 0]     AXI_WID;
  logic [C_AXI_DATA_WIDTH - 1 : 0]   AXI_WDATA;
  logic [C_AXI_STRB_WIDTH - 1 : 0]   AXI_WSTRB;
  logic [C_AXI_LAST_WIDTH - 1 : 0]   AXI_WLAST;
  logic [C_AXI_VALID_WIDTH - 1 : 0]  AXI_WVALID;
  logic [C_AXI_READY_WIDTH - 1 : 0]  AXI_WREADY;

  // AXI write response channel
  logic [C_AXI_ID_WIDTH - 1 : 0]     AXI_BID;
  logic [C_AXI_RESP_WIDTH - 1 : 0]   AXI_BRESP;
  logic [C_AXI_VALID_WIDTH - 1 : 0]  AXI_BVALID;
  logic [C_AXI_READY_WIDTH - 1 : 0]  AXI_BREADY;

  // AXI address read channel
  logic [C_AXI_ID_WIDTH - 1 : 0]     AXI_ARID;
  logic [C_AXI_ADDR_WIDTH - 1 : 0]   AXI_ARADDR;
  logic [C_AXI_REG_WIDTH - 1 : 0]    AXI_ARREG;
  logic [C_AXI_LEN_WIDTH - 1 : 0]    AXI_ARLEN;
  logic [C_AXI_SIZE_WIDTH - 1 : 0]   AXI_ARSIZE;
  logic [C_AXI_BURST_WIDTH - 1 : 0]  AXI_ARBURST;
  logic [C_AXI_LOCK_WIDTH - 1 : 0]   AXI_ARLOCK;
  logic [C_AXI_CACHE_WIDTH - 1 : 0]  AXI_ARCACHE;
  logic [C_AXI_PROT_WIDTH - 1 : 0]   AXI_ARPROT;
  logic [C_AXI_PROT_WIDTH - 1 : 0]   AXI_ARQOS;
  logic [C_AXI_VALID_WIDTH - 1 : 0]  AXI_ARVALID;
  logic [C_AXI_READY_WIDTH - 1 : 0]  AXI_ARREADY;

  // AXI data read channel
  logic [C_AXI_ID_WIDTH - 1 : 0]     AXI_RID;
  logic [C_AXI_DATA_WIDTH - 1 : 0]   AXI_RDATA;
  logic [C_AXI_RESP_WIDTH- 1 : 0]    AXI_RRESP;
  logic [C_AXI_LAST_WIDTH - 1 : 0]   AXI_RLAST;
  logic [C_AXI_VALID_WIDTH - 1 : 0]  AXI_RVALID;
  logic [C_AXI_READY_WIDTH - 1 : 0]  AXI_RREADY;

  resp_e debug_wr_resp;
  resp_e debug_rd_resp;
  burst_length_e debug_wr_length;
  burst_length_e debug_rd_length;
  burst_type_e debug_wr_type;
  burst_type_e debug_rd_type;
  burst_size_e debug_wr_size;
  burst_size_e debug_rd_size;

  assign debug_wr_resp = resp_e'(AXI_BRESP);
  assign debug_rd_resp = resp_e'(AXI_RRESP);
  assign debug_wr_length = burst_length_e'(AXI_AWLEN);
  assign debug_rd_length = burst_length_e'(AXI_ARLEN);
  assign debug_wr_type = burst_type_e'(AXI_AWBURST);
  assign debug_rd_type = burst_type_e'(AXI_ARBURST);
  assign debug_wr_size = burst_size_e'(AXI_AWSIZE);
  assign debug_rd_size = burst_size_e'(AXI_ARSIZE);

  clocking drv_cb @(posedge AXI_ACLK);
    default input #1ps output #1ps;
    input AXI_AWREADY, 
          AXI_WREADY, 
          AXI_BID, AXI_BVALID, AXI_BRESP, 
          AXI_ARREADY, 
          AXI_RID, AXI_RRESP, AXI_RDATA, AXI_RLAST, AXI_RVALID;
    output AXI_AWID, AXI_AWADDR, AXI_AWREG, AXI_AWLEN, AXI_AWSIZE, AXI_AWBURST, AXI_AWLOCK, AXI_AWCACHE, AXI_AWPROT, AXI_AWQOS, AXI_AWVALID, 
    AXI_WID, AXI_WDATA, AXI_WSTRB, AXI_WVALID, AXI_WLAST, 
    AXI_BREADY,
    AXI_ARID, AXI_ARADDR, AXI_ARREG, AXI_ARLEN, AXI_ARSIZE, AXI_ARBURST, AXI_ARLOCK, AXI_ARCACHE, AXI_ARPROT, AXI_ARQOS, AXI_ARVALID, 
    AXI_RREADY;
  endclocking

  clocking mon_cb @(posedge AXI_ACLK);
    default input #1ps output #1ps;
    input AXI_AWREADY, 
           AXI_WREADY, 
           AXI_BID, AXI_BVALID, AXI_BRESP, 
           AXI_ARREADY, 
           AXI_RID, AXI_RRESP, AXI_RDATA, AXI_RLAST, AXI_RVALID;
    input AXI_AWID, AXI_AWADDR, AXI_AWREG, AXI_AWLEN, AXI_AWSIZE, AXI_AWBURST, AXI_AWLOCK, AXI_AWCACHE, AXI_AWPROT, AXI_AWQOS, AXI_AWVALID, 
    AXI_WID, AXI_WDATA, AXI_WSTRB, AXI_WVALID, AXI_WLAST, 
    AXI_BREADY,
    AXI_ARID, AXI_ARADDR, AXI_ARREG, AXI_ARLEN, AXI_ARSIZE, AXI_ARBURST, AXI_ARLOCK, AXI_ARCACHE, AXI_ARPROT, AXI_ARQOS, AXI_ARVALID,
    AXI_RREADY;
  endclocking



endinterface

`endif // GON_AXI_MASTER_IF_SV
