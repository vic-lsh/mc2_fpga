// (C) 2001-2024 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// Copyright 2023 Intel Corporation.
//
// THIS SOFTWARE MAY CONTAIN PREPRODUCTION CODE AND IS PROVIDED BY THE
// COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
// WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
// EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
///////////////////////////////////////////////////////////////////////
/*
  Description   : FPGA CXL Compliance Engine Initiator AFU
                  Speaks to the AXI-to-CCIP+ translator.
                  This afu is the initiatior
                  The axi-to-ccip+ is the responder
*/

`ifndef CCV_AFU_ALG1A_PKG_VH
`define CCV_AFU_ALG1A_PKG_VH

package ccv_afu_alg1a_pkg;

//-------------------------
//------ Parameters
//-------------------------

typedef enum logic [1:0] {
  MODE_IDLE        = 2'd0,
  MODE_EXECUTE     = 2'd1,
  MODE_VERIFY_SC   = 2'd2,
  MODE_VERIFY_NSC  = 2'd3
} alg1a_mode_enum;

typedef enum logic [3:0] {
  AXI_WR_IDLE            = 4'd0,
//  AXI_WR_WAIT_TIL_4      = 4'd1,
  AXI_WR_WAIT_TIL_NOT_EMPTY = 4'd1,
  AXI_WR_FIRST_POP       = 4'd2,
  AXI_WR_FIRST_AWVALID   = 4'd3,
  AXI_WR_FIRST_AWREADY   = 4'd4,
  AXI_WR_NEXT_AWREADY    = 4'd5,
  AXI_WR_NEXT_AWVALID    = 4'd6,
  AXI_WR_LAST_AWREADY    = 4'd7,
  AXI_WR_LAST_AWVALID    = 4'd8,
  AXI_WR_LAST_WREADY     = 4'd9,
  AXI_WR_LAST_WVALID     = 4'd10,

  AXI_WR_FIRST_WAIT              = 4'd11,
  AXI_WR_FIRST_AWREADY_PLUS_POP2 = 4'd12



} alg1a_exe_axi_write_fsm_enum;







endpackage: ccv_afu_alg1a_pkg

`endif
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "DGzrytkiceLjtyjsTaM+IzNUexbn5wzpmx4F1prXYECmxPXPn13o0M/rXNG1mO13RJ5fhQaExY1DId30xrFeFq5FL7gSGxHyRknIDLmmCNMcWImmwtFcy2uyhgWx0jyEzKKJKegjoNYHGsF9JtxyGoo4G3owvnlbnlgS/aJ3Aky5AJL4N0KkruYOdzUGck/zCmpIoex0KWhVL43DGHURVo8L2CS4v6cauUSxTHMeah2HkRzrw2/JrSar/Bd4cLVz17PHHOeLeCsAlg8ugi7YeMKX4Mp5lftakl9jJa/NdrPGt81Srg/cFlt7z98IXjU05oMZ8qZo47NPl47YXk2hruwiw0cvs2wgUQEYhQNsNJW2Rct0gbsHmh2gd+IMiA8WOomnY1GQYyaTGNJdZDX91IAfGhOPNAC84kUCN24F3UQE3RYyFYWzIXsxzJ6jLLam5vMkZjTJKzCMGPIjKlNilFJ8fnKv8oh7iF0uKfIyBUZlTSsq3ZvIkjiV0H10Si5TGDKD9EOnseVJnpzcf4AHu4tIg7hvtUhSFlTJjx5C8G32xhzXAMZdqQ8e5W1XbaDyroRtzFFWhaG1+cn0D4fVOGCmqZEp/uBIPQgk6PiJ2SXIAAO7PuvZ10U/+kXXpdobB7tCCZVdrtODg/j7sULQsx/1ci+CVMmrtTdgDT+QNPjdmytrOFT1NG2jRpQO6bBfnsRY00TSw/z9VaO8LHBtwzqYgUePIvGF5uK5KpXMzzaS2LHh7PVqxC80q+njitKygJYf9WweFxOVDxBd4SkoZqzabMPlmM3XD4L+bITrSZVUKClaIO938Zz95F6Zi4hUPHa+HZSh/ufomgBu3CdtDHmjEp0rK0SDF84x3y11DQnvD66tc+lRhssTtgXLMWUy96vdkcliQ+jsbmZw8cuiHBRRo6Rr4/ez8Ra2kk3qoJ3PqN1PZ61JzXt31E54funP4GdBnAQreWzUbON6CzcxAYh1zmdbtUoeLRn2LusgqM3Y8ZXWItgX15gjw/I+dGFL"
`endif