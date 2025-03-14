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


// Copyright 2022 Intel Corporation.
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

module csr0_mc_status_glue 
  import cafu_csr0_cfg_pkg::*;
  import cxlip_top_pkg::*;
(
        input  logic                    clk,
        input  logic                    rst,
        
        input  logic [cxlip_top_pkg::MC_SR_STAT_WIDTH-1:0]                mc_status [cxlip_top_pkg::MC_CHANNEL-1:0],
        output cafu_csr0_cfg_pkg::MC_STATUS_t           csr0_mc_status,
        output  logic                                   csr0_mem_active
);


/* internal signals begin */
logic [cxlip_top_pkg::MC_SR_STAT_WIDTH-1:0]     mc_statusQ [cxlip_top_pkg::MC_CHANNEL-1:0];
cafu_csr0_cfg_pkg::MC_STATUS_t                  csr0_mc_status_i;    
/* internal signals end */


/* Functional Logic begin */
  assign csr0_mc_status = csr0_mc_status_i;

  always_ff @(posedge clk) begin
    mc_statusQ <= mc_status; 
  end

  // MC[n][cxlip_top_pkg::MC_SR_STAT_WIDTH-1:0] status bits:
  // - status[0] = emif_cal_fail_eclk
  // - status[1] = emif_cal_success_eclk
  // - status[2] = emif_reset_done_eclk
  // - status[3] = emif_pll_locked_eclk
  // - status[4] = ram_init_done
  assign csr0_mc_status_i.mc0_status[cxlip_top_pkg::MC_SR_STAT_WIDTH-1:0] = mc_statusQ[0];
  assign csr0_mc_status_i.mc0_status[15:cxlip_top_pkg::MC_SR_STAT_WIDTH] = '0;

  generate
    if (cxlip_top_pkg::MC_CHANNEL == 2) begin : GenMc1Status
      assign csr0_mc_status_i.mc1_status[cxlip_top_pkg::MC_SR_STAT_WIDTH-1:0] = mc_statusQ[1];
      assign csr0_mc_status_i.mc1_status[15:cxlip_top_pkg::MC_SR_STAT_WIDTH]  = '0;
      assign csr0_mem_active = mc_statusQ[0][4] & mc_statusQ[1][4];
    end
    else if (cxlip_top_pkg::MC_CHANNEL == 4) begin : GenMc1Status
      assign csr0_mc_status_i.mc1_status[cxlip_top_pkg::MC_SR_STAT_WIDTH-1:0] = mc_statusQ[1];
      assign csr0_mc_status_i.mc1_status[15:cxlip_top_pkg::MC_SR_STAT_WIDTH]  = '0;
      assign csr0_mem_active =   mc_statusQ[0][4]
                              & mc_statusQ[1][4]
                              & mc_statusQ[2][4]
                              & mc_statusQ[3][4];
    end
    else begin : GenMc1Status
      assign csr0_mc_status_i.mc1_status = '0;
      assign csr0_mem_active = mc_statusQ[0][4];
    end
  endgenerate

/* Functional Logic end */

endmodule


`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "DGzrytkiceLjtyjsTaM+IzNUexbn5wzpmx4F1prXYECmxPXPn13o0M/rXNG1mO13RJ5fhQaExY1DId30xrFeFq5FL7gSGxHyRknIDLmmCNMcWImmwtFcy2uyhgWx0jyEzKKJKegjoNYHGsF9JtxyGoo4G3owvnlbnlgS/aJ3Aky5AJL4N0KkruYOdzUGck/zCmpIoex0KWhVL43DGHURVo8L2CS4v6cauUSxTHMeah2CRJX4J0PCXPb2q+gba4dSjB8RrbrvhBKEvUAjGw/GTNPIWyExMFcvuxwMH/OrUGddjFlU+NAtuAb+bSjn4sO5ApPP0t5iXVmO8W81yj6gc/hW/6Igb/xJhJ2OtPii+T9AE50CB0dEPMslDCsNUHEalamyzlajC91aYHRzLIlDr9SP8nRjZSXLOQ75UfwW4BzisuXAca6gNRwt30KBhnBwvq5+6sOC8MqnGP9wCww0Oqs7d+HqgNWioNPKqfCCsJWDHbEitBkfTEOotltnGrF8EWTDPE2gruLkGsIYepl7Jy2YDthm4JtEtNDgJSJo3REbxlVkbY2DDCT0sDh9hRHHVs0Js3wF0volK5nf11fUWi8yIOvZfu6ZRSgXR4LZoArpEs8upsyPsjBOzkTxn7Z5TL3x0S5aRq6jd8vljLzM+AJ50FSOkm9WRMUFHVFJLxxnZqV+x5iV0DCz1PfXlLl0TmBCCR/oJGUYsbFPWZh9xsClkLXb+2IzKSENdvy5sYVSD8DKG+5Y1/3JgvgvYmvvpN8/No+rQto2dT01s09zpttjk1PQHAjTXrkHwBzQZjdjdBuu+STeiorj07yqI4vR8N85MRPdUsLkFK3iWa8eOi/nv7I/9EmPd7U2Wm4TfcpYykpKsi3i3EA9zjxgJrRL02hAAut09m5vCZa0k9ySEZExM3orSzPF3gXrflnb9WY50pXixY2NglyjU8jGXscX0A9ZZyI42eHwX61Q/dVXCts+uAEo/M5MqAGVI+gkKE7OIpxekhRXhbyYsnj4hCAn"
`endif