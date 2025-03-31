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
// File Version     :        $Revision: #9 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2p/amba_dev/src/DW_axi_x2p_dcdr.v#9 $ 
------------------------------------------------------------------------
--
//
//
--
-- File :                       DW_axi_x2p_dcdr
-- Date :                       $Date: 2016/02/01 $
-- Abstract     :               APB address decoder module.
--
-- This module takes as input the address. It decodes the address and
-- either generates a valid decode or an invalid_addr signal (psel_int = 0)
-- The decoder is maximally configured
-- - 16 slaves - always, and the required PSEL lines are sliced out of
-- this maximally configured system.
--
--
--
-- Modification History:        Refer to perforce log
-- =====================================================================
*/

module DW_axi_x2p_dcdr (/*AUTOARG*/
  // Outputs
  psel_int, psel_err,
  // Inputs
  psel_addr
  );
  // parameter apb_size = `X2P_APB_SIZE;
  // parameter NUM_APB_SLAVES = `X2P_NUM_APB_SLAVES;

//-----------------
// IO declarations
//-----------------

   input [`X2P_CMD_ADDR_WIDTH-1:10]   psel_addr;    // input address bus

   output [`X2P_NUM_APB_SLAVES-1:0]   psel_int;  // PSEL output bus

   output                             psel_err;  // set when no selects or more than 1 sel

//----------------
// wires and regs
//----------------
  wire [`X2P_NUM_APB_SLAVES-1:0]                           psel_int;
  reg                                 psel_err;
  wire [31:10]                        paddr;      // 64 bit addressing the top 32 arn not seen

//---------------------------
// Internal wires and regs
//---------------------------
   wire [`X2P_NUM_APB_SLAVES-1:0] psel_tmp; // max width psel bus
//   wire [3:0]  num_slaves = NUM_APB_SLAVES;
//   integer     adjusted_size;

parameter [63:0] START_TMP_PADDR0     = `X2P_START_PADDR_S0;
parameter [63:0] END_TMP_PADDR0       = `X2P_END_PADDR_S0; 
parameter [63:0] START_TMP_PADDR1     = `X2P_START_PADDR_S1;
parameter [63:0] END_TMP_PADDR1       = `X2P_END_PADDR_S1; 
parameter [63:0] START_TMP_PADDR2     = `X2P_START_PADDR_S2;
parameter [63:0] END_TMP_PADDR2       = `X2P_END_PADDR_S2; 
                                                           
   assign      paddr = psel_addr[31:10];

// the selection is only in 1k blocks
// Generate comparator based decoder for a maximally configured
// APB system always
//
   assign      psel_tmp[0] = ((paddr[31:10] >= START_TMP_PADDR0[31:10]) && (paddr[31:10] <= END_TMP_PADDR0[31:10]));
   assign      psel_tmp[1] = ((paddr[31:10] >= START_TMP_PADDR1[31:10]) && (paddr[31:10] <= END_TMP_PADDR1[31:10]));
   assign      psel_tmp[2] = ((paddr[31:10] >= START_TMP_PADDR2[31:10]) && (paddr[31:10] <= END_TMP_PADDR2[31:10]));

//
// Extract the active slice from the maximally configured bus
//
   assign psel_int = psel_tmp;

   // if no selects set the error
   // 1st is out of range
   // 2nd is not aligned to the APB
  always @(/*AS*/psel_tmp)
    begin: PSEL_ERR_PROC
      psel_err = 1'b0;
      //if (|psel_tmp == 0) psel_err = 1'b1;
      if (!(|psel_tmp)) psel_err = 1'b1;
    end

endmodule // DW_axi_x2p_dcdr























