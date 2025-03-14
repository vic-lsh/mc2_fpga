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
`include "ccv_afu_globals.vh.iv"

module mwae_error_injection_regs
    import ccv_afu_pkg::*;
//   import ccv_afu_cfg_pkg::*;
   import tmp_cafu_csr0_cfg_pkg::*;
(
  input clk,
  input reset_n,

  `ifdef INCLUDE_POISON_INJECTION
         input [2:0] algorithm_reg,
         input       force_disable_afu,
         input       i_cache_poison_inject_busy,
  `endif

  output tmp_cafu_csr0_cfg_pkg::tmp_new_DEVICE_ERROR_INJECTION_t   new_device_error_injection_reg
);

logic cache_poison_busy;

`ifdef INCLUDE_POISON_INJECTION
  always_ff @( posedge clk )
  begin
         if( reset_n == 1'b0 )           cache_poison_busy <= 1'b0;
//    else if( algorithm_reg == 'd0 )      cache_poison_busy <= 1'b0;
    else if( force_disable_afu == 1'b1 ) cache_poison_busy <= 1'b0;
    else                                 cache_poison_busy <= i_cache_poison_inject_busy;
  end
`else
      assign cache_poison_busy = 1'b0;
`endif

assign new_device_error_injection_reg.CachePoisonInjectionBusy = cache_poison_busy;
//assign new_device_error_injection_reg.MemPoisonInjectionBusy   = 1'b0;
//assign new_device_error_injection_reg.IOPoisonInjectionBusy    = 1'b0;
//assign new_device_error_injection_reg.CacheMemCRCInjectionBusy = 1'b0;

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "DGzrytkiceLjtyjsTaM+IzNUexbn5wzpmx4F1prXYECmxPXPn13o0M/rXNG1mO13RJ5fhQaExY1DId30xrFeFq5FL7gSGxHyRknIDLmmCNMcWImmwtFcy2uyhgWx0jyEzKKJKegjoNYHGsF9JtxyGoo4G3owvnlbnlgS/aJ3Aky5AJL4N0KkruYOdzUGck/zCmpIoex0KWhVL43DGHURVo8L2CS4v6cauUSxTHMeah3PTk0Bg3VBTGrMlucqa5RDLxw0jZg8WkdB+7gxl3KanHKeXYKpZTOY1+o09FstNUwQfV9HlQ8NU24tQ8hwkdZMsGLHgT8K8OG6M8VAhK7wSdct3ftkqTnFplvCg09qlkke2dZE8ncs4pFZ1S21nXeHk0U9xFgzC1dQYV7vCbVL1fknmxjcEi7N1l2kK6AjTs318JPAN6WIZr89wXTxbv42Qd/dgnISFuyOWBG7+G4s4TeEvUbUGekKKs+Teq/cDrQHfZP1ZQ3VhIv0sOWGGdFLVT87B0XV/v1Zl0Sbs6q0b2MM1cB2O6cdH7qyrdhYV/mPGgp+QWls/mBPdnzFTYuaj1o3NmttLsoPDqissF8WU3XHlQrmkIllirs/6IicTze14st+gGAsCQZ6A3TSfoA8Pu3SvRYUki3pvlFLmn1aoApBwILrFUU5U50JYEDJnyqhaVeow25JRvwXFGOpJLvuGvyL1tr6aIeytWMbpmHoyOUEFkzmFKOVy3ON8SSjYB+G90nYMQqUirQKtPsMFdNk9YJuzE3PJ7QO+WFqg5dC4CHUkjb0BtBbkfig/+h7WI0nTd73H/24n8K0De/JOGpl8WMtvj0PfHSpskR5LjVAM/qoMI5ouHevtdMx/Nu7H5XnEvBtax04jHPypFC0cFcPF9jVr43mNPhpAmv9AORGp5uKcWeMMdutXEtECu/xh4eRt0cyxNoQtA8CZLNepB2dR01pGN10PDkRBKncWRIr8FzrtczjJNJlReuzwaKCSfRZ3pT9Yu4FEfP3Pu1UWKu3"
`endif