`ifndef GON_APB_SLAVE_DRIVER_SV
`define GON_APB_SLAVE_DRIVER_SV

class gon_apb_slave_driver extends gon_apb_driver;

  bit reset_state_flag = 0;
  bit [31:0] mem[bit [15:0]];

  `uvm_component_utils(gon_apb_slave_driver)

  function new(string name = "gon_apb_slave_driver", uvm_component parent = null);
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
      get_and_dirve();
      reset_listener();
    join_none
  endtask

  virtual task get_and_dirve();
    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info(get_type_name(), "sequencer get next item", UVM_HIGH)
      if(reset_state_flag == 0)
        drive_transfer(req);
      void'($cast(rsp, req.clone()));
      rsp.set_sequence_id(req.get_sequence_id());
      rsp.set_transaction_id(req.get_transaction_id());
      // no rsp transfer now
      seq_item_port.item_done();
      `uvm_info(get_type_name(), "sequencer item_done_triggered", UVM_HIGH)
    end
  endtask

  virtual task drive_transfer(REQ t);
    fork
      begin
        vif.cb_slv.pready <= t.pready;
        vif.cb_slv.pslverr <= t.pslverr;
        @(vif.cb_slv);
        while(1) begin
          if(vif.cb_slv.psel == 1'b1 && vif.cb_slv.penable == 1'b0)
            break;
          @(vif.cb_slv);
        end
        wait_ready_on(t.nready_num);
        case(vif.cb_slv.pwrite)
          1'b1 : store_data_with_addr(t);
          1'b0 : get_data_with_addr(t);
        endcase
      end
      begin
        @(vif.cb_slv iff (reset_state_flag == 1));
        disable fork;
      end
    join_any
  endtask

  virtual task store_data_with_addr(REQ t);
    if(!t.pslverr) begin
      store_data_with_hsize(t);
    end
  endtask

  virtual task get_data_with_addr(REQ t);
    if(!t.pslverr) begin
      get_data_with_hsize(t);
    end
    else 
      vif.cb_slv.prdata <= t.data;
  endtask

  virtual task store_data_with_hsize(REQ t);
    bit [15:0] addr = vif.cb_slv.paddr;
    case(t.burst_size)
      BURST_SIZE_8BIT  : mem[{addr[15:2], 2'b00}] <= extract_current_beat_mem_data(t);
      BURST_SIZE_16BIT : mem[{addr[15:2], 2'b00}] <= extract_current_beat_mem_data(t);
      BURST_SIZE_32BIT : mem[{addr[15:2], 2'b00}] <= extract_current_beat_mem_data(t);
      default          : `uvm_error("TYPEERR", "burst size not surpported") 
    endcase
  endtask

  virtual task get_data_with_hsize(REQ t);
    bit [15:0] addr = vif.cb_slv.paddr;
    case(t.burst_size)
      BURST_SIZE_8BIT  : vif.cb_slv.prdata <= (mem[{addr[15:2], 2'b00}] >> (8*(addr[1:0]))) & 32'hFF;
      BURST_SIZE_16BIT : vif.cb_slv.prdata <= ((mem[{addr[15:2], 2'b00}] >> (16*(addr[1])))) & 32'hFFFF;
      BURST_SIZE_32BIT : vif.cb_slv.prdata <= mem[{addr[15:2], 2'b00}];
      default          : `uvm_error("TYPEERR", "burst size not surpported") 
    endcase
  endtask
  
  function bit[31:0] extract_current_beat_mem_data(REQ t);
    bit [15:0] tr_addr = vif.cb_slv.paddr;
    bit [31:0] mdata = mem[{tr_addr[15:2], 2'b00}];
    bit [31:0] tdata = vif.cb_slv.pwdata;
    case(t.burst_size)
      BURST_SIZE_8BIT  : mdata[(tr_addr[1:0]*8 + 7) -: 8] = tdata >> (8*tr_addr[1:0]);
      BURST_SIZE_16BIT : mdata[(tr_addr[1]*16 + 15) -: 16] = tdata >> (16*tr_addr[1]);
      BURST_SIZE_32BIT : mdata = tdata;
      default          : `uvm_error("TYPEERR", "burst size not surpported") 
    endcase
    return mdata;
  endfunction


  virtual task wait_ready_on(int unsigned nready_num);
    for(int i=nready_num; i>0; i--) begin
      vif.cb_slv.pready <= 1'b0;
      @(vif.cb_slv);
    end
    vif.cb_slv.pready <= 1'b1;
  endtask

  virtual task _do_drive_idle();
    vif.cb_slv.pready <= 1'b0;
  endtask

  virtual task reset_listener();
    `uvm_info(get_type_name(), "reset_listener ...", UVM_LOW)
    fork
      forever begin
        @(negedge vif.presetn);
        reset_state_flag = 1;
        @(vif.cb_slv);
        _do_drive_idle();
        @(posedge vif.presetn);
        reset_state_flag = 0;
      end
    join_none
  endtask
endclass


`endif // GON_APB_SLAVE_DRIVER_SV
