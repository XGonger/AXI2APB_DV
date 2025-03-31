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
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2p/amba_dev/src/DW_axi_x2p_resp_buffer.v#11 $ 
*/

//
//
//-----------------------------------------------------------------------------
// Filename    : DW_axi_x2p_resp_buffer
// 
// Created     : Dec 15 2005
// Description : Connects to the DesignWare fifo control and the registers
//               Allows for a single or two clocks, selects fifo based on 
//               clocking
//               The APB side pushes with the response
//   
//-----------------------------------------------------------------------------

module DW_axi_x2p_resp_buffer(/*AUTOARG*/
   // Outputs
   hresp_rdy_int_n, 
                              aresp_rdy_int_n, 
                              awstatus_int, 
                              awid_int,
                              // Inputs
                              clk_axi,
                              clk_apb, 
                              hwstatus_int, 
                              hwid_int, 
                              push_resp_int_n,
                              pop_resp_int_n, 
                              pop_rst_n,
                              push_rst_n
                              );

     // requires the following to be defined
//  X2P_AXI_DATA_WIDTH      width of the read data word;
//  X2P_AXI_ID_WIDTH        width of the read id
//  X2P_WRITE_RESP_BUFFER_DEPTH   depth of the FIFO
   
//  X2P_CLK_MODE           0 = Async Clocks implies FIFO with 2 or 3 push and pop sync 
//                         1 = Sync Clocks  imnplies FIFO with 1 push and pop sync
//                         2 = single clock implies a single clock fifo
  input                   clk_axi;
  input                   clk_apb; 
  input                   hwstatus_int;
  input [`X2P_AXI_SIDW-1:0] hwid_int;
  input       push_resp_int_n;
  output      hresp_rdy_int_n;
  output      aresp_rdy_int_n;
  output      awstatus_int;
  output [`X2P_AXI_SIDW-1:0] awid_int;
  input        pop_resp_int_n;
  input        push_rst_n;
  input        pop_rst_n;  
  
parameter FIFO_WIDTH=`X2P_AXI_SIDW+1;                // fixed for ID plus status
parameter DEPTH=`X2P_WRITE_RESP_BUFFER_DEPTH;
// push and pop syncs for dual clock systems.
// if the clock are sync use 1 reg between domains
// if async use the constraint
 parameter PUSH_SYNC=`X2P_DUAL_CLK_SYNC_DEPTH;
 parameter POP_SYNC =PUSH_SYNC;
 parameter PUSH_AF_LVL=2;
 parameter POP_AE_LVL=2;
 parameter POP_AF_LVL=2;
 parameter ERR_MODE=0;
// set up all the widths and depths assume here that the depth cannot exceed 256
parameter COUNT_WIDTH=((DEPTH <= 2) ? 2 :(DEPTH <= 4) ? 3 :(DEPTH <= 8) ? 4 :(DEPTH <= 16) ? 5:(DEPTH <= 32) ? 6:(DEPTH <= 64) ? 7:(DEPTH <= 128) ? 8:9);
parameter DW_ADDR_WIDTH= (COUNT_WIDTH-1);
   // adjusting the RAM depth for odd and non-power of 2 compatibility with the control
   // if FIFO is  dual-clocked adjusting the RAM depth for odd and non-power of 2 compatibility with the control
parameter DW_EFFECTIVE_DEPTH_S1=DEPTH;
parameter DW_EFFECTIVE_DEPTH_S2=((DEPTH == (1 << DW_ADDR_WIDTH))? DEPTH : DEPTH + ((DEPTH & 1) ? 1: 2));
parameter DW_EFFECTIVE_DEPTH=((`X2P_CLK_MODE==2) ? DW_EFFECTIVE_DEPTH_S1 : DW_EFFECTIVE_DEPTH_S2);

  wire  [DW_ADDR_WIDTH-1:0] wr_addr,rd_addr;
  wire                      mem_rst_n;
  wire                      aresp_rdy_int_n,hresp_rdy_int_n;
  wire                      we_n;
  
  assign                    mem_rst_n = push_rst_n;
 parameter PUSH_AE_LVL=(DEPTH == 1) ? 0 : 2;
 parameter TST_MODE=0;      // scan test input not connected

  wire clk_push;

   assign                   clk_push = clk_apb;
   wire clk_pop;
   assign                   clk_pop = clk_axi;


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

  // Not concerned with unconnected ports, hence disable the
  // The following port(s) of this instance are intentionally unconnected.   
  // This instance design is shared by other module(s) that uses these port(s).
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
      U_RESP_FIFO_CONTROL_S2(
                .clk_push(clk_push),
                .clk_pop(clk_pop),
                .test(1'b0),                          
                .rst_push_n(push_rst_n),
                .init_push_n(1'b1),           
                .rst_pop_n(pop_rst_n),
                .init_pop_n(1'b1),            
                .push_full(hresp_rdy_int_n),
                .pop_empty(aresp_rdy_int_n),
                .push_req_n(push_resp_int_n),
                .pop_req_n(pop_resp_int_n),
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
  wire                     push2popaf_hwstatus_int;
  wire [`X2P_AXI_SIDW-1:0] push2popaf_hwid_int;
  wire                     spush2popaf_awstatus_int;
  wire [`X2P_AXI_SIDW-1:0] spush2popaf_awid_int;
  
  assign push2popaf_hwstatus_int = hwstatus_int;
  assign push2popaf_hwid_int     = hwid_int;
  assign awstatus_int            = spush2popaf_awstatus_int;
  assign awid_int                = spush2popaf_awid_int;

  DW_axi_x2p_bcm57
   #(FIFO_WIDTH,DW_EFFECTIVE_DEPTH,0,DW_ADDR_WIDTH)
     U_RESP_FIFO_RAM(.init_n(1'b1)                   
                     ,.clk(clk_push)
                     ,.rst_n(mem_rst_n)
                     ,.wr_n(we_n)
                     ,.rd_addr(rd_addr)
                     ,.wr_addr(wr_addr)
                     ,.data_in({push2popaf_hwstatus_int,push2popaf_hwid_int})
                     ,.data_out({spush2popaf_awstatus_int,spush2popaf_awid_int})
                      );

endmodule // DW_axi_x2p_resp_buffer













