`ifndef GON_AXI_MASTER_MONITOR_SV
`define GON_AXI_MASTER_MONITOR_SV

class gon_axi_master_monitor extends uvm_monitor;

  virtual gon_axi_master_if vif;
  uvm_analysis_port#(gon_axi_transaction) item_observed_port;
  gon_axi_configuration cfg;

  bit reset_state_check_flag = 0;
  bit reset_state_flag = 0;

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
    if(!uvm_config_db#(gon_axi_configuration)::get(this, "", "cfg", cfg))
      `uvm_fatal("GETCFG", "cannt get config object from config db");
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
        reset_listener();
        reset_state_check_task();
     join_none
  endtask

  virtual task observe_trans();
    fork
      begin
        forever observe_write_transfer();
      end
      begin
        forever observe_read_transfer();
      end
    join
  endtask

  virtual task observe_write_transfer();
    fork
      observe_write_address_channel();
      observe_write_data_channel();
      observe_write_response_channel();
    join
  endtask

  virtual task observe_write_address_channel();
    @(vif.mon_cb);
    if(reset_state_flag)
      return;
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
    if(reset_state_flag)
      return;
    if((vif.mon_cb.AXI_WVALID === 1'b1) && (vif.mon_cb.AXI_WREADY === 1'b1)) begin
      wr_t.data = new[wr_cnt+1](wr_t.data);
      wr_t.data[wr_cnt] = vif.mon_cb.AXI_WDATA;
      wr_t.strb = vif.mon_cb.AXI_WSTRB;
      wr_cnt++;
    end
  endtask

  virtual task observe_write_response_channel();
    @(vif.mon_cb) 
    if(reset_state_flag)
      return;
    if((vif.mon_cb.AXI_BVALID === 1'b1) && (vif.mon_cb.AXI_BREADY)) begin
      wr_t.resp = new[1];
      wr_t.resp[0] = vif.mon_cb.AXI_BRESP;
      wr_t.wr_rd = WRITE;
      item_observed_port.write(wr_t);
      wr_t = gon_axi_transaction::type_id::create("wr_t");
      wr_cnt = 0;
    end
  endtask

  virtual task observe_read_transfer();
    fork
      observe_read_address_channel();
      observe_read_data_channel();
    join
  endtask

  virtual task observe_read_address_channel();
    @(vif.mon_cb);
    if(reset_state_flag)
      return;
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
    if(reset_state_flag)
      return;
    if((vif.mon_cb.AXI_RVALID === 1'b1) && (vif.mon_cb.AXI_RREADY === 1'b1)) begin
      rd_t.data = new[rd_cnt+1](rd_t.data);
      rd_t.data[rd_cnt] = vif.mon_cb.AXI_RDATA;
      rd_t.resp = new[rd_cnt+1](rd_t.resp);
      rd_t.resp[rd_cnt] = vif.mon_cb.AXI_RRESP;
      rd_cnt++;
      if(vif.mon_cb.AXI_RLAST === 1'b1) begin
        rd_t.wr_rd = READ;
        item_observed_port.write(rd_t);
        rd_t = gon_axi_transaction::type_id::create("rd_t");
        rd_cnt = 0;
      end
    end
  endtask

  virtual task reset_state_check_task();
    if(cfg.reset_state_check) begin
      forever begin
        @(posedge vif.AXI_ACLK iff vif.AXI_ARESET_N == 0);
        if(vif.AXI_AWREADY != 0 || vif.AXI_WREADY != 1 || vif.AXI_BID != 0 || vif.AXI_BVALID != 0 || vif.AXI_BRESP != 0 || vif.AXI_ARREADY != 0
            || vif.AXI_RID != 0 || vif.AXI_RRESP != 0 || vif.AXI_RDATA != 0 || vif.AXI_RLAST != 0 || vif.AXI_RVALID != 0)
          reset_state_check_flag = 1;
        if(reset_state_check_flag)
          `uvm_error("RSTCHK", "reset state check error")
        reset_state_check_flag = 0;
      end
    end
  endtask

  virtual task reset_listener();
    `uvm_info(get_type_name(), "reset_listener ...", UVM_LOW)
    fork
      forever begin
        @(negedge vif.AXI_ARESET_N);
        reset_state_flag = 1;
        @(vif.mon_cb);
        _do_monitor_idle();
        @(posedge vif.AXI_ARESET_N);
        reset_state_flag = 0;
      end
    join_none
  endtask

  virtual task _do_monitor_idle();
    wr_cnt = 0;
    rd_cnt = 0;
  endtask

endclass

`endif
