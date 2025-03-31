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
// File Version     :        $Revision: #8 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2p/amba_dev/src/DW_axi_x2p_s_unpack.v#8 $ 
*/
//
//
//
//-----------------------------------------------------------------------------
// Filename    : DW_axi_x2ps_unpack.v
// 
// Description : APB write data unpacking for DW_axi_x2p bridge.
//-----------------------------------------------------------------------------


module DW_axi_x2p_s_unpack (/*AUTOARG*/
  // Outputs
  selected_data, selected_strobes, 
  // Inputs
  clk, rstn, write_buff_data, write_buff_strobes,
  next_apb_wd_sel, set_data
  );


   input                                clk;
   input                                rstn;
   input [`X2P_AXI_DW-1:0]              write_buff_data;
   input [(`X2P_AXI_DW/8)-1:0]          write_buff_strobes;
   input [7:0]                          next_apb_wd_sel;
   input                                set_data;
   
   output [`X2P_APB_DATA_WIDTH-1:0]     selected_data;
   output [(`X2P_APB_DATA_WIDTH/8)-1:0] selected_strobes;
   
   reg [`X2P_APB_DATA_WIDTH-1:0]    selected_data;
   wire [`X2P_AXI_DW-1:0]           write_buff_data;
   wire [(`X2P_AXI_DW/8)-1:0]       write_buff_strobes;
   wire [7:0]                       next_apb_wd_sel;
   reg [`X2P_APB_DATA_WIDTH-1:0]    next_selected_data;
   wire [`X2P_APB_DATA_WIDTH-1:0]   selected_data_ns;
   reg [(`X2P_APB_DATA_WIDTH/8)-1:0] selected_strobes_ns;
   wire [(`X2P_APB_DATA_WIDTH/8)-1:0] selected_strobes;

  integer                               i;
  integer                               j;

  always@(/*AUTOSENSE*/next_apb_wd_sel or write_buff_data)
    /*AUTO_CONSTANT(`X2P_APB_DATA_WIDTH)*/
    begin: NEXT_SEL_DATA_PROC
      for(i=0; i<`X2P_APB_DATA_WIDTH; i=i+1)
        begin
          next_selected_data[i] = write_buff_data[i+(next_apb_wd_sel*`X2P_APB_DATA_WIDTH)];
        end
    end // always@ (...
  
  always@(/*AUTOSENSE*/next_apb_wd_sel or write_buff_strobes)
    /*AUTO_CONSTANT(`X2P_APB_WSTRB_WIDTH)*/
    begin:SEL_STROBES_NS_PROC
      for(j=0; j<`X2P_APB_WSTRB_WIDTH; j=j+1)
        begin

          selected_strobes_ns[j] = write_buff_strobes[j+(next_apb_wd_sel*`X2P_APB_WSTRB_WIDTH)];
        end
    end // always@ (...

  
   assign selected_strobes = selected_strobes_ns;   
   assign selected_data_ns = (set_data==1'b1) ? next_selected_data : selected_data;
      
  always @(posedge clk or negedge rstn)
    begin:S_SEL_DATA_PROC
      if (!rstn)
        begin
          selected_data <= {`X2P_APB_DATA_WIDTH{1'b0}};
        end
      else
        begin
          selected_data <= selected_data_ns;
        end
    end // always @ (posedge clk or negedge rstn)
   
endmodule // DW_axi_x2ps_unpack

















