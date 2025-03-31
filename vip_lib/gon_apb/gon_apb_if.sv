`ifndef GON_APB_IF_SV
`define GON_APB_IF_SV

interface gon_apb_if;

  import gon_apb_pkg::*;

  logic                pclk;
  logic                presetn;
  logic                apbactive;
  logic [31:0]         paddr;
  logic                penable;
  logic                psel;
  logic                pwrite;
  logic [3:0]          pstrb;
  logic [2:0]          pprot;
  logic [31:0]         pwdata;
  logic                pready;
  logic                pslverr;
  logic [31:0]         prdata;

  clocking cb_slv @(posedge pclk);
    default input #1ps output #1ps;
    output pready, pslverr, prdata;
    input apbactive, paddr, penable, psel,pwrite, pstrb, pprot, pwdata;
  endclocking

  clocking cb_mon @(posedge pclk);
    default input #1ps output #1ps;
    input pready, pslverr, prdata;
    input apbactive, paddr, penable, psel,pwrite, pstrb, pprot, pwdata;
  endclocking

endinterface


`endif // GON_APB_IF_SV
