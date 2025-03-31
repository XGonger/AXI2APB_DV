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
// File Version     :        $Revision: #11 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2p/amba_dev/src/DW_axi_x2p_cmd_queue.v#11 $ 
*/

//
//
//-----------------------------------------------------------------------------
// Filename    : DW_axi_x2p_cmd_queue.v
// 
// Created     : Dec 15 2005
// Description : Connects to the DesignWare fifo control and the registers.
//               Allows for a single or two clocks, selects fifo based on 
//               clocking
//               The AXI side pushes with the acmd_queue_wd_int
//   
//-----------------------------------------------------------------------------

module DW_axi_x2p_cmd_queue(/*AUTOARG*/
   // Outputs
   acmd_rdy_int_n, 
                            push_af, 
                            hcmd_queue_wd_int, 
                            hcmd_rdy_int_n,
                            // Inputs
                            clk_axi, 
                            acmd_queue_wd_int, 
                            push_acmd_int_n, 
                            clk_apb,
                            pop_hcmd_int_n, 
                            pop_rst_n,
                            push_rst_n
                            );

// requires the following to be defined
//  X2P_CMD_QUEUE_WIDTH   total width of cmd queue word;
//  X2P_CMD_QUEUE_DEPTH   DEPTH of the FIFO

//  X2P_CLK_MODE          0 = Two Clocks implies FIFO with 2  push and pop sync 
//                        1 = Two Clocks  imnplies FIFO with 3 push and pop sync
//                        2 = single clock implies a single clock fifo
         
  input                              clk_axi;
  input [`X2P_CMD_QUEUE_WIDTH:0]   acmd_queue_wd_int;    // consisting of all the inputs
  input                              push_acmd_int_n;
  output                             acmd_rdy_int_n;
  output                             push_af;
  
  input                              clk_apb;
  input                              pop_hcmd_int_n;
  output [`X2P_CMD_QUEUE_WIDTH:0]  hcmd_queue_wd_int;
  output                             hcmd_rdy_int_n;

  input                              push_rst_n;
  input                              pop_rst_n;
  
  wire                               we_n, acmd_rdy_int_n,hcmd_rdy_int_n;
  wire                               push_af;

  
   
parameter FIFO_WIDTH=`X2P_CMD_QUEUE_WIDTH + 1;
parameter DEPTH=`X2P_CMD_QUEUE_DEPTH;
// push and pop syncs for dual clock systems.
// if the clocks are 0 use 2 clocks between domains
//  clock 1 use 3
// clock 2 a single clock use 1 clock
 parameter  PUSH_SYNC=`X2P_DUAL_CLK_SYNC_DEPTH;
 parameter  POP_SYNC=PUSH_SYNC;
 parameter PUSH_AF_LVL=1;
 parameter POP_AE_LVL=2;
 parameter POP_AF_LVL=2;
 parameter ERR_MODE=0;
 parameter PUSH_AE_LVL=(DEPTH == 1) ? 0 : 2;
// set up all the widths and depths assume here that the DEPTH cannot exceed 256
parameter COUNT_WIDTH=((DEPTH <= 2) ? 2 :(DEPTH <= 4) ? 3 :(DEPTH <= 8) ? 4 :(DEPTH <= 16) ? 5:(DEPTH <= 32) ? 6:(DEPTH <= 64) ? 7:(DEPTH <= 128) ? 8:9);
parameter DW_ADDR_WIDTH= (COUNT_WIDTH-1);
   // if FIFO is  dual-clocked adjusting the RAM DEPTH for odd and non-power of 2 compatibility with the control
parameter DW_EFFECTIVE_DEPTH_S1=DEPTH;
parameter DW_EFFECTIVE_DEPTH_S2=((DEPTH == (1 << DW_ADDR_WIDTH))? DEPTH : DEPTH + ((DEPTH & 1) ? 1: 2));
parameter DW_EFFECTIVE_DEPTH=((`X2P_CLK_MODE==2) ? DW_EFFECTIVE_DEPTH_S1 : DW_EFFECTIVE_DEPTH_S2);

   wire [DW_ADDR_WIDTH-1:0]          wr_addr,rd_addr;
   wire                              mem_rst_n;
   
  assign                    mem_rst_n = push_rst_n;
 parameter TST_MODE=0;      // scan test input not connected
  

  wire clk_push;
  assign                     clk_push = clk_axi;

  wire clk_pop;
  assign                     clk_pop = clk_apb;


//unused signals from the bcm07 module.
wire                    push_empty_unconn;              
wire                    push_ae_unconn;
wire                    push_hf_unconn;
wire                    push_error_unconn;
wire [COUNT_WIDTH-1:0] push_word_count_unconn;
wire                    pop_ae_unconn;
wire                    pop_hf_unconn;
wire                    pop_af_unconn;
wire                    pop_full_unconn;
wire                    pop_error_unconn;
wire [COUNT_WIDTH-1:0] pop_word_count_unconn;


  // Call fifo Controller
  //spyglass disable_block W528
  //SMD: A signal or variable is set but never read.
  //SJ : BCM components are configurable to use in various scenarios in this particular design we are not using certain ports. Hence although those signals are read we are not driving them. Therefore waiving this warning.
   
  // Dual clock controller
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
      U_CMD_FIFO_CONTROL_S2(
                .clk_push(clk_push),
                .clk_pop(clk_pop),
                .test(1'b0),                          
                .rst_push_n(push_rst_n),
                .init_push_n(1'b1),           
                .rst_pop_n(pop_rst_n),
                .init_pop_n(1'b1),            
                .push_full(acmd_rdy_int_n),
                .pop_empty(hcmd_rdy_int_n),
                .push_req_n(push_acmd_int_n),
                .pop_req_n(pop_hcmd_int_n),
                .we_n(we_n),
                .wr_addr(wr_addr),
                .rd_addr(rd_addr),
                .push_empty(push_empty_unconn),              
                .push_ae(push_ae_unconn),
                .push_hf(push_hf_unconn),
                .push_af(push_af),
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
  //      
  // The RAM
  wire [`X2P_CMD_QUEUE_WIDTH:0]   push2popaf_acmd_queue_wd_int; 
  wire [`X2P_CMD_QUEUE_WIDTH:0]   spush2popaf_hcmd_queue_wd_int; 
  
  assign push2popaf_acmd_queue_wd_int = acmd_queue_wd_int;
  assign hcmd_queue_wd_int            = spush2popaf_hcmd_queue_wd_int;

  DW_axi_x2p_bcm57
   #(FIFO_WIDTH,DW_EFFECTIVE_DEPTH,0,DW_ADDR_WIDTH)
     U_CMD_FIFO_RAM(.init_n(1'b1)                    
                    ,.clk(clk_push)
                    ,.rst_n(mem_rst_n)
                    ,.wr_n(we_n)
                    ,.rd_addr(rd_addr)
                    ,.wr_addr(wr_addr)
                    ,.data_in(push2popaf_acmd_queue_wd_int)
                    ,.data_out(spush2popaf_hcmd_queue_wd_int)
                      );
  
//`include "../../src/DW_axi_x2h_fifo_report.inc"

endmodule // DW_axi_x2p_cmd_queue






