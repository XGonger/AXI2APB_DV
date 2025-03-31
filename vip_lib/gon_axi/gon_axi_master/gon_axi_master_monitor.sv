`ifndef GON_AXI_MASTER_MONITOR_SV
`define GON_AXI_MASTER_MONITOR_SV

class gon_axi_master_monitor extends uvm_monitor;

  virtual gon_axi_master_if vif;
  uvm_analysis_port#(gon_axi_transaction) item_observed_port;

  gon_axi_transaction wr_t;
  gon_axi_transaction rd_t;

  int unsigned wr_cnt = 0;
  int unsigned rd_cnt = 0;
  
  `uvm_component_utils(gon_axi_master_monitor)

  function new(string name = "gon_axi_master_monitor", uvm_component parent);
    super.new(name, parent);
    item_observed_port = new("item_observed_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wr_t = gon_axi_transaction::type_id::create("wr_t");
    rd_t = gon_axi_transaction::type_id::create("rd_t");
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
     fork
        observe_trans();
     join_none
  endtask

  virtual task observe_trans();
    fork
      observe_write_transfer();
      observe_read_transfer();
    join
  endtask

  virtual task observe_write_transfer();
    forever begin
      fork
        observe_write_address_channel();
        observe_write_data_channel();
        observe_write_response_channel();
      join
    end
  endtask

  virtual task observe_write_address_channel();
    @(vif.mon_cb);
    if((vif.mon_cb.AXI_AWVALID === 1'b1) && (vif.mon_cb.AXI_AWREADY === 1'b1)) begin
      wr_t.id = vif.mon_cb.AXI_AWID;
      wr_t.addr = vif.mon_cb.AXI_AWADDR;
      wr_t.burst_length = burst_length_e'(vif.mon_cb.AXI_AWLEN);
      wr_t.burst_size = burst_size_e'(vif.mon_cb.AXI_AWSIZE);
      wr_t.burst_type = burst_type_e'(vif.mon_cb.AXI_AWBURST);
    end
  endtask

  virtual task observe_write_data_channel();
    @(vif.mon_cb);
    if((vif.mon_cb.AXI_WVALID === 1'b1) && (vif.mon_cb.AXI_WREADY === 1'b1)) begin
      wr_t.data = new[wr_cnt+1](wr_t.data);
      wr_t.data[wr_cnt] = vif.mon_cb.AXI_WDATA;
      wr_t.strb = vif.mon_cb.AXI_WSTRB;
      wr_cnt++;
      if(vif.mon_cb.AXI_WLAST === 1'b1) begin
        wr_t.wr_rd = WRITE;
        item_observed_port.write(wr_t);
        wr_cnt = 0;
      end
    end
  endtask

  virtual task observe_write_response_channel();
    @(vif.mon_cb) 
    if((vif.mon_cb.AXI_BVALID === 1'b1) && (vif.mon_cb.AXI_BREADY)) begin
      wr_t.resp = new[1];
      wr_t.resp[0] = vif.mon_cb.AXI_BRESP;
    end
  endtask

  virtual task observe_read_transfer();
    forever begin
      fork
        observe_read_address_channel();
        observe_read_data_channel();
      join
    end
  endtask

  virtual task observe_read_address_channel();
    @(vif.mon_cb);
    if((vif.mon_cb.AXI_ARVALID === 1'b1) && (vif.mon_cb.AXI_ARREADY === 1'b1)) begin
      rd_t.id = vif.mon_cb.AXI_ARID;
      rd_t.addr = vif.mon_cb.AXI_ARADDR;
      rd_t.burst_length = burst_length_e'(vif.mon_cb.AXI_ARLEN);
      rd_t.burst_size = burst_size_e'(vif.mon_cb.AXI_ARSIZE);
      rd_t.burst_type = burst_type_e'(vif.mon_cb.AXI_ARBURST);
    end
  endtask

  virtual task observe_read_data_channel();
    @(vif.mon_cb) 
    if((vif.mon_cb.AXI_RVALID === 1'b1) && (vif.mon_cb.AXI_RREADY === 1'b1)) begin
      rd_t.data = new[rd_cnt+1](rd_t.data);
      rd_t.data[rd_cnt] = vif.mon_cb.AXI_RDATA;
      rd_t.resp = new[rd_cnt+1](rd_t.resp);
      rd_t.resp[rd_cnt] = vif.mon_cb.AXI_RRESP;
      rd_cnt++;
      if(vif.mon_cb.AXI_RLAST === 1'b1) begin
        rd_t.wr_rd = READ;
        item_observed_port.write(rd_t);
        rd_cnt = 0;
      end
    end
  endtask
endclass

`endif
