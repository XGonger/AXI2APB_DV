`ifndef GON_AXI_MASTER_DRIVER_SV
`define GON_AXI_MASTER_DRIVER_SV

class gon_axi_master_driver extends uvm_driver #(gon_axi_transaction);

  virtual gon_axi_master_if vif;

  int unsigned rd_cnt = 0;
  //
  `uvm_component_utils(gon_axi_master_driver)

  function new(string name = "gon_axi_master_driver", uvm_component parent = null);
    super.new(name, parent);
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
      get_and_drive();
      reset_listener();
    join_none
  endtask

  virtual task get_and_drive();
    wait_for_reset();
    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info(get_type_name(), "sequencer get next item", UVM_HIGH)
      drive_transfer(req);
      void'($cast(rsp, req.clone()));
      // set sequence and transaction id
      rsp.set_id_info(req);
      seq_item_port.item_done(rsp);
      `uvm_info(get_type_name(), "sequencer item_done_triggered", UVM_HIGH)
    end
  endtask

  virtual task drive_transfer(gon_axi_transaction t);
    case(t.wr_rd)
      WRITE: write_transfer(t);
      READ:  read_transfer(t);
    endcase
  endtask

  // ------------------------ write transfer begin ---------------------------------------------
  virtual task write_transfer(gon_axi_transaction t);
    fork
      write_address_channel(t);
      write_data_channel(t);
    join
    write_response_channel(t);
  endtask

  virtual task write_address_channel(gon_axi_transaction t);
    @(vif.drv_cb iff vif.AXI_ARESET_N === 1'b1);
    vif.drv_cb.AXI_AWID    <= t.id;
    vif.drv_cb.AXI_AWADDR  <= t.addr;
    vif.drv_cb.AXI_AWVALID <= 1'b1;
    vif.drv_cb.AXI_AWLEN   <= t.burst_length;
    vif.drv_cb.AXI_AWSIZE  <= t.burst_size;
    vif.drv_cb.AXI_AWBURST <= t.burst_type;
    @(vif.drv_cb iff vif.drv_cb.AXI_AWREADY === 1'b1);
    vif.drv_cb.AXI_AWVALID <= 1'b0;
    // be ready after the write address phase
    vif.drv_cb.AXI_BREADY  <= 1'b1;
  endtask

  virtual task write_data_channel(gon_axi_transaction t);
    if(t.data.size() == 0)
      `uvm_fatal(get_type_name(), "write data is empty!")
    else begin
      @(vif.drv_cb iff vif.AXI_ARESET_N === 1'b1);
      foreach(t.data[i]) begin
        vif.drv_cb.AXI_WID    <= t.id;
        vif.drv_cb.AXI_WDATA  <= t.data[i];
        vif.drv_cb.AXI_WSTRB  <= t.strb;
        vif.drv_cb.AXI_WVALID <= 1'b1;
        if(i == t.data.size() - 1)
          vif.drv_cb.AXI_WLAST <= 1'b1;
        @(vif.drv_cb iff vif.drv_cb.AXI_WREADY === 1'b1);
      end
      vif.drv_cb.AXI_WVALID <= 1'b0;
      vif.drv_cb.AXI_WLAST  <= 1'b0; 
    end
  endtask
  
  virtual task write_response_channel(gon_axi_transaction t);
    @(vif.drv_cb iff (vif.drv_cb.AXI_BVALID === 1'b1 && vif.AXI_ARESET_N === 1'b1));
    t.resp = new[1];
    t.resp[0] = vif.drv_cb.AXI_BRESP;
    vif.drv_cb.AXI_BREADY <= 1'b0;
  endtask
  // ------------------------ write transfer end ---------------------------------------------

  // ------------------------ read transfer begin ---------------------------------------------
  virtual task read_transfer(gon_axi_transaction t);
    read_address_channel(t);
    read_data_channel(t);
  endtask

  virtual task read_address_channel(gon_axi_transaction t);
    @(vif.drv_cb iff vif.AXI_ARESET_N === 1'b1);
    vif.drv_cb.AXI_ARID     <= t.id;
    vif.drv_cb.AXI_ARADDR   <= t.addr;
    vif.drv_cb.AXI_ARLEN    <= t.burst_length;
    vif.drv_cb.AXI_ARSIZE   <= t.burst_size;
    vif.drv_cb.AXI_ARBURST  <= t.burst_type;
    vif.drv_cb.AXI_ARVALID  <= 1'b1;
    @(vif.drv_cb iff vif.drv_cb.AXI_ARREADY === 1'b1);
    vif.drv_cb.AXI_ARVALID <= 1'b0;
    // be ready after the read address phase
    vif.drv_cb.AXI_RREADY  <= 1'b1;
  endtask

  virtual task read_data_channel(gon_axi_transaction t);
    forever begin
      @(vif.drv_cb iff (vif.drv_cb.AXI_RVALID && vif.AXI_ARESET_N === 1'b1));
      t.id = vif.drv_cb.AXI_RID;
      t.resp = new[rd_cnt+1](t.resp);
      t.resp[rd_cnt] = vif.drv_cb.AXI_RRESP;
      t.data[rd_cnt] = vif.drv_cb.AXI_RDATA;
      rd_cnt++;
      if(vif.drv_cb.AXI_RLAST === 1'b1)
        break;
    end
    rd_cnt = 0;
  endtask
  // ------------------------ read transfer end ---------------------------------------------

  virtual task _do_drive_idle();
    // write address channel
    vif.drv_cb.AXI_AWID    <= 0;
    vif.drv_cb.AXI_AWADDR  <= 0;
    vif.drv_cb.AXI_AWSIZE  <= 0;
    vif.drv_cb.AXI_AWBURST <= 0;
    vif.drv_cb.AXI_AWLEN   <= 0;
    vif.drv_cb.AXI_AWCACHE <= 0;
    vif.drv_cb.AXI_AWLOCK  <= 0;
    vif.drv_cb.AXI_AWPROT  <= 0;
    vif.drv_cb.AXI_AWVALID <= 0;
    // write data channel
    vif.drv_cb.AXI_WID    <= 0;
    vif.drv_cb.AXI_WDATA  <= 0;
    vif.drv_cb.AXI_WSTRB  <= 0;
    vif.drv_cb.AXI_WVALID <= 0;
    vif.drv_cb.AXI_WLAST  <= 0;
    // write response channel
    vif.drv_cb.AXI_BREADY  <= 0;

    // read address channel
    vif.drv_cb.AXI_ARID    <= 0;
    vif.drv_cb.AXI_ARADDR  <= 0;
    vif.drv_cb.AXI_ARSIZE  <= 0;
    vif.drv_cb.AXI_ARBURST <= 0;
    vif.drv_cb.AXI_ARLEN   <= 0;
    vif.drv_cb.AXI_ARCACHE <= 0;
    vif.drv_cb.AXI_ARLOCK  <= 0;
    vif.drv_cb.AXI_ARPROT  <= 0;
    vif.drv_cb.AXI_ARVALID <= 0;
    // write data channel
    vif.drv_cb.AXI_RREADY  <= 0;
  endtask

  virtual task wait_for_reset();
    @(negedge vif.AXI_ARESET_N);
    `uvm_info(get_type_name(), "reset is finished", UVM_LOW)
  endtask

  virtual task reset_listener();
    `uvm_info(get_type_name(), "reset_listener ...", UVM_LOW)
    fork
      forever begin
        @(negedge vif.AXI_ARESET_N);
        _do_drive_idle();
      end
    join_none
    
  endtask
endclass
  
`endif
