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
// File Version     :        $Revision: #7 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2p/amba_dev/src/DW_axi_x2p_mux.v#7 $ 
*/
//-----------------------------------------------------------------------------
//
//
// Description : Output multiplexor.
//-----------------------------------------------------------------------------
module DW_axi_x2p_mux (/*AUTOARG*/
  // Outputs
  prdata, 
                       prdata_s1_s,
                       prdata_s2_s,
                       // Inputs
                       psel, 
                       prdata_s0_s
                       );
  
  input [`X2P_NUM_APB_SLAVES-1:0]        psel;
  input [`X2P_APB_DATA_WIDTH-1:0]        prdata_s0_s;
  input [`X2P_APB_DATA_WIDTH-1:0]        prdata_s1_s;
  input [`X2P_APB_DATA_WIDTH-1:0]        prdata_s2_s;
  

  
  output [`X2P_APB_DATA_WIDTH-1:0]       prdata;

  reg [`X2P_APB_DATA_WIDTH-1:0]          prdata_s;

  assign                                 prdata = prdata_s;
  
    always@(*)
        begin: PRDATA_PROC
            case (psel)
              1:     prdata_s = prdata_s0_s;
              2:     prdata_s = prdata_s1_s;
              4:     prdata_s = prdata_s2_s;
              default:  prdata_s = {`X2P_APB_DATA_WIDTH{1'b0}};
            endcase // case(psel)
        end // always@ (prdata_s0 or prdata_s1 or prdata_s10...



  
//       
endmodule // DW_axi_x2p_mux
