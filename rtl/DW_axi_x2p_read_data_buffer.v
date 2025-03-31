/*
------------------------------------------------------------------------
--
//  ------------------------------------------------------------------------
//
//                    (C) COPYRIGHT 2001 - 2018 SYNOPSYS, INC.
//                            ALL RIGHTS RESERVED
//
//  This software and the associated documentation are confidential and
//  proprietary to Synopsys, Inc.  Your use or disclosure of this
//  software is subject to the terms and conditions of a written
//  license agreement between you, or your company, and Synopsys, Inc.
//
// The entire notice above must be reproduced on all authorized copies.
//
// Component Name   : DW_axi_x2p
// Component Version: 2.03a
// Release Type     : GA
//  ------------------------------------------------------------------------

// 
// Release version :  2.03a
// File Version     :        $Revision: #10 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2p/amba_dev/src/DW_axi_x2p_read_data_buffer.v#10 $ 
*/

//
//

//-----------------------------------------------------------------------------
// Filename    : DW_axi_x2p_read_data_buffer.v
// 
// Created     : Dec 15 2005
// Description : Connects to the DesignWare fifo control and the registers
//               Allows for a single or two clocks, selects fifo based on 
//               clocking
//               The APB side pushes with the data ID and resp
//               and monitors the condition of the stack by looking at
//               the adddress to the RAM (hrdata_uush_cnt)
//-----------------------------------------------------------------------------

module DW_axi_x2p_read_data_buffer(/*AUTOARG*/
   // Outputs
   arstatus_int, 
                                   arid_int, 
                                   arlast_int, 
                                   ardata_int, 
                                   arvalid_int_n,
                                   hrdata_rdy_int_n,
                                   // Inputs
                                   clk_axi,
                                   pop_data_int_n, 
                                   clk_apb, 
                                   push_data_int_n, 
                                   hrstatus_int,
                                   hrid_int, 
                                   hrlast_int, 
                                   hrdata_int, 
                                   pop_rst_n,
                                   push_rst_n
                                   );

     // requires the following to be defined
//  X2P_AXI_DATA_WIDTH       width of the read data word;
//  X2P_AXI_ID_WIDTH         width of the read id
//  X2P_READ_BUFFER_DEPTH    depth of the FIFO

//  X2P_CLK_MODE           0 = Two Clocks implies FIFO with 2 push and pop sync 
//                         1 = Two  Clocks  imnplies FIFO with 3 push and pop sync
//                         2 = single clock implies a single clock fifo
    
parameter FIFO_WIDTH =`X2P_AXI_DW + `X2P_AXI_SIDW + 2;
parameter DEPTH=`X2P_READ_BUFFER_DEPTH;
// push and pop syns for dual clock systems.
// if the clock ar sync use 1 reg between domains
// if async use the constraint
 parameter PUSH_SYNC=`X2P_DUAL_CLK_SYNC_DEPTH;
 parameter POP_SYNC= PUSH_SYNC;
 parameter PUSH_AF_LVL=2;
 parameter POP_AE_LVL=2;
 parameter POP_AF_LVL=2;
 parameter ERR_MODE=0;
// set up all the widths and depths assume here that the depth cannot exceed 256
parameter COUNT_WIDTH=((DEPTH <= 2) ? 2 :(DEPTH <= 4) ? 3 :(DEPTH <= 8) ? 4 :(DEPTH <= 16) ? 5:(DEPTH <= 32) ? 6:(DEPTH <= 64) ? 7:(DEPTH <= 128) ? 8:9);
parameter DW_ADDR_WIDTH= (COUNT_WIDTH-1);
   // if FIFO is  dual-clocked adjusting the RAM depth for odd and non-power of 2 compatibility with the control
parameter DW_EFFECTIVE_DEPTH_S1=DEPTH;
parameter DW_EFFECTIVE_DEPTH_S2=((DEPTH == (1 << DW_ADDR_WIDTH))? DEPTH : DEPTH + ((DEPTH & 1) ? 1: 2));
parameter DW_EFFECTIVE_DEPTH=((`X2P_CLK_MODE==2) ? DW_EFFECTIVE_DEPTH_S1 : DW_EFFECTIVE_DEPTH_S2);
  
  input                                   clk_axi;
  output                                  arstatus_int; 
  output [`X2P_AXI_SIDW-1:0]              arid_int;
  output                                  arlast_int;
  output [`X2P_AXI_DW-1:0]                ardata_int;
  input                                   pop_data_int_n;
  output                                  arvalid_int_n;
  output                                  hrdata_rdy_int_n;
   
  
  input                                   clk_apb;
  input                                   push_data_int_n;
  input                                   hrstatus_int; 
  input [`X2P_AXI_SIDW-1:0]               hrid_int;
  input                                   hrlast_int;
  input [`X2P_AXI_DW-1:0]                 hrdata_int;
  
  input                                   push_rst_n;
  input                                   pop_rst_n;
  
  wire                                    arstatus_int;
  wire [DW_ADDR_WIDTH-1:0]                wr_addr,rd_addr;
 
  wire                                    we_n, hrdata_rdy_int_n, arvalid_int_n; 
  wire                                    mem_rst_n;
  wire                                    clk_push;
  wire                                    clk_pop;
  assign clk_pop = clk_axi;
  wire [FIFO_WIDTH-1:0]                  data_out_int;
  wire [FIFO_WIDTH-1:0]                  data_in_int;
   
  assign                    mem_rst_n = push_rst_n;
 parameter PUSH_AE_LVL=(DEPTH == 1) ? 0 : 2;
 parameter TST_MODE=0;     // scan test input not connected

  assign clk_push = clk_apb;


//unused signals from the bcm07 module.

wire                    push_empty_unconn;              
wire                    push_ae_unconn;
wire                    push_hf_unconn;
wire                    push_af_unconn;
wire                    push_error_unconn;
wire [COUNT_WIDTH-1:0]  push_word_count_unconn;
wire                    pop_ae_unconn;
wire                    pop_hf_unconn;
wire                    pop_af_unconn;
wire                    pop_full_unconn;
wire                    pop_error_unconn;
wire [COUNT_WIDTH-1:0]  pop_word_count_unconn;


  // Call fifo Controller
  //spyglass disable_block W528
  //SMD: A signal or variable is set but never read.
  //SJ : BCM components are configurable to use in various scenarios in this particular design we are not using certain ports. Hence although those signals are read we are not driving them. Therefore waiving this warning.
   
    // dual clock controller
  DW_axi_x2p_bcm07
   #(DEPTH,DW_ADDR_WIDTH,COUNT_WIDTH,
                       PUSH_AE_LVL,
                       PUSH_AF_LVL,
                       POP_AE_LVL,
                       POP_AF_LVL,
                       ERR_MODE,
                       PUSH_SYNC,
                       POP_SYNC,
                       TST_MODE,
                       0, 0, 0,
                       `X2P_VERIF_EN   
                       )                     
      U_READ_FIFO_CONTROL_S2(
                .clk_push(clk_push),
                .clk_pop(clk_pop),
                .test(1'b0),                          
                .rst_push_n(push_rst_n),
                .init_push_n(1'b1),           
                .rst_pop_n(pop_rst_n),
                .init_pop_n(1'b1),            
                .push_full(hrdata_rdy_int_n),
                .pop_empty(arvalid_int_n),
                .push_req_n(push_data_int_n),
                .pop_req_n(pop_data_int_n),
                .we_n(we_n),
                .wr_addr(wr_addr),
                .rd_addr(rd_addr),
                .push_empty(push_empty_unconn),              
                .push_ae(push_ae_unconn),
                .push_hf(push_hf_unconn),
                .push_af(push_af_unconn),
                .push_error(push_error_unconn),
                .push_word_count(push_word_count_unconn),
                .pop_ae(pop_ae_unconn),
                .pop_hf(pop_hf_unconn),
                .pop_af(pop_af_unconn),
                .pop_full(pop_full_unconn),
                .pop_error(pop_error_unconn),
                .pop_word_count(pop_word_count_unconn) 
                 );
  // spyglass enable_block W528                              
  // The RAM
  wire [FIFO_WIDTH-1:0]           push2popaf_data_in_int;
  wire [FIFO_WIDTH-1:0]           spush2popaf_data_out_int;
  
  assign push2popaf_data_in_int = data_in_int;
  assign data_out_int           = spush2popaf_data_out_int;

  DW_axi_x2p_bcm57
   #(FIFO_WIDTH,DW_EFFECTIVE_DEPTH,0,DW_ADDR_WIDTH)
     U_READ_DATA_FIFO_RAM(.init_n(1'b1)                    
                      ,.clk(clk_push)
                      ,.rst_n(mem_rst_n)
                      ,.wr_n(we_n)
                      ,.rd_addr(rd_addr)
                      ,.wr_addr(wr_addr)
                      ,.data_in(push2popaf_data_in_int)
                      ,.data_out(spush2popaf_data_out_int)
                      );

  assign                     arstatus_int = data_out_int[`X2P_AXI_DW+`X2P_AXI_SIDW+1];
  assign                     arid_int = data_out_int[`X2P_AXI_DW+`X2P_AXI_SIDW:`X2P_AXI_DW+1];
  assign                     arlast_int = data_out_int[`X2P_AXI_DW];
  assign                     ardata_int = data_out_int[`X2P_AXI_DW-1:0];
  
  assign data_in_int = {hrstatus_int,hrid_int,hrlast_int,hrdata_int};
  
endmodule // DW_axi_x2p_read_data_buffer

  
  

  











         
                      
