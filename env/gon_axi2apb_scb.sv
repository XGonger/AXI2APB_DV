`ifndef GON_AXI2APB_SCB_SV
`define GON_AXI2APB_SCB_SV

class gon_axi2apb_scb extends gon_axi2apb_subscriber;

  gon_axi_transaction axi_trans;
  gon_apb_transaction apb_trans;

  gon_axi_transaction axi_write_trans_q[$];
  gon_axi_transaction axi_read_trans_q[$];
  gon_apb_transaction apb_write_trans_q[$];
  gon_apb_transaction apb_read_trans_q[$];

  `uvm_component_utils(gon_axi2apb_scb);

  function new(string name = "gon_axi2apb_scb", uvm_component parent);
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
      get_and_check_trans();
    join_none
  endtask

  virtual task get_and_check_trans();
    fork
      get_trans();
      check_trans();
    join
  endtask

  virtual task get_trans();
    fork
      begin
        forever begin
          axi_get_port.get(axi_trans);
          if(axi_trans.wr_rd === 1'b1)
            axi_write_trans_q.push_back(axi_trans);
          else
            axi_read_trans_q.push_back(axi_trans);
        end
      end
      begin
        forever begin
          apb_get_port.get(apb_trans);
          if(apb_trans.xact_type == 1'b1)
            apb_write_trans_q.push_back(apb_trans);
          else
            apb_read_trans_q.push_back(apb_trans);
        end
      end
    join
  endtask

  virtual task check_trans();
    fork
      check_write_trans();
      check_read_trans();
    join
  endtask

  virtual task check_write_trans();
    int unsigned i;
    int unsigned wrap_ptr;
    bit [31:0] axi_addr;
    gon_axi_transaction axi_t;
    gon_apb_transaction apb_t;
    forever begin
      wait(axi_write_trans_q.size()>0);
      axi_t = axi_write_trans_q.pop_front();
      for(i=0; i<axi_t.data.size(); i++) begin
        wait(apb_write_trans_q.size()>0);
        apb_t = apb_write_trans_q.pop_front();
        //-------------------------------- data compare begin ----------------------
        if(axi_t.data[i] == apb_t.data)
          `uvm_info("DATACHK", $sformatf("axi write data 'h%0x = apb write data 'h%0x", axi_t.data[i], apb_t.data), UVM_HIGH)
        else
          `uvm_error("DATACHK", $sformatf("axi write data 'h%0x != apb write data 'h%0x", axi_t.data[i], apb_t.data))
        //-------------------------------- data compare end ----------------------
        
        //-------------------------------- address compare begin ----------------------
        case(axi_t.burst_type)
          INCR  : axi_addr = axi_t.addr + i*(8'h1 << axi_t.burst_size);
          FIXED : axi_addr = axi_t.addr;
          WRAP  : begin
            wrap_ptr = (axi_t.addr >> 2) % (axi_t.burst_length + 1);
            axi_addr = (i < axi_t.burst_length + 1 - wrap_ptr)
                        ? (axi_t.addr + i*(8'h1 << axi_t.burst_size)) 
                        : (axi_t.addr + (i - axi_t.burst_length - 1) * (8'h1 << axi_t.burst_size)); 
          end
          default : `uvm_error("TYPEERR", $sformatf("error burst type"))
        endcase

        if(axi_addr == apb_t.addr)
          `uvm_info("ADRRCHK", $sformatf("axi write address 'h%0x = apb write address 'h%0x", axi_addr, apb_t.addr), UVM_HIGH)
        else
          `uvm_error("ADDRCHK", $sformatf("axi write address 'h%0x != apb write address 'h%0x", axi_addr, apb_t.addr))
       //-------------------------------- address compare end ----------------------
      end
    end
  endtask

  virtual task check_read_trans();
    int unsigned i;
    int unsigned wrap_ptr;
    bit [31:0] axi_addr;
    gon_axi_transaction axi_t;
    gon_apb_transaction apb_t;
    forever begin
      wait(axi_read_trans_q.size()>0);
      axi_t = axi_read_trans_q.pop_front();
      for(i=0; i<axi_t.data.size(); i++) begin
        wait(apb_read_trans_q.size()>0);
        apb_t = apb_read_trans_q.pop_front();
        //-------------------------------- data compare begin ----------------------
        if(axi_t.data[i] == apb_t.data)
          `uvm_info("DATACHK", $sformatf("axi read data 'h%0x = apb read data 'h%0x", axi_t.data[i], apb_t.data), UVM_HIGH)
        else
          `uvm_error("DATACHK", $sformatf("axi read data 'h%0x != apb read data 'h%0x", axi_t.data[i], apb_t.data))
        //-------------------------------- data compare end ----------------------
        
        //-------------------------------- address compare begin ----------------------
        case(axi_t.burst_type)
          INCR  : axi_addr = axi_t.addr + i*(8'h1 << axi_t.burst_size);
          FIXED : axi_addr = axi_t.addr;
          WRAP  : begin
            wrap_ptr = (axi_t.addr >> 2) % (axi_t.burst_length + 1);
            axi_addr = (i < axi_t.burst_length + 1 - wrap_ptr)
                        ? (axi_t.addr + i*(8'h1 << axi_t.burst_size)) 
                        : (axi_t.addr + (i - axi_t.burst_length - 1) * (8'h1 << axi_t.burst_size)); 
          end
          default : `uvm_error("TYPEERR", $sformatf("error burst type"))
        endcase

        if(axi_addr == apb_t.addr)
          `uvm_info("ADRRCHK", $sformatf("axi write address 'h%0x = apb write address 'h%0x", axi_addr, apb_t.addr), UVM_HIGH)
        else
          `uvm_error("ADDRCHK", $sformatf("axi write address 'h%0x != apb write address 'h%0x", axi_addr, apb_t.addr))
       //-------------------------------- address compare end ----------------------
      end
    end
  endtask



endclass
`endif
