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
 /* structs for bit widths
  
    APRIL 14 2023 - these are set based on Darren's current CXL IP HAS draft ch3.3 values
 */

package mc_axi_if_pkg;
  import afu_axi_if_pkg::*;  // import to use protocol specific enumuration structs
  import cxlip_top_pkg::*;

// ================================================================================================
 /* structs for bit widths
  
    APRIL 14 2023 - these are set based on Darren's current CXL IP HAS draft ch3.3 values
 */

  localparam MC_AXI_WAC_REGION_BW  =  4; // awregion
  localparam MC_AXI_WAC_ADDR_BW    = 52; // awaddr  - using bits 51:6 of 64-bits, also grabbing the lower 6 bits?
  localparam MC_AXI_WAC_USER_BW    =  1; // awuser
  localparam MC_AXI_WAC_ID_BW      =  8; // awid
  localparam MC_AXI_WAC_BLEN_BW    = 10; // awlen
  
  localparam MC_AXI_WDC_DATA_BW = 512; // wwdata
  localparam MC_AXI_WDC_USER_BW =  1;  // wuser  // currently only poison
  
  localparam MC_AXI_WDC_STRB_BW = MC_AXI_WDC_DATA_BW / 8; // wstrb
  
  localparam MC_AXI_WRC_ID_BW   =  8; // bid
  localparam MC_AXI_WRC_USER_BW =  1; // buser
  
  localparam MC_AXI_RAC_REGION_BW  =  4; // arregion
  localparam MC_AXI_RAC_ID_BW      =  8; // arid
  localparam MC_AXI_RAC_ADDR_BW    = 52; // araddr  - using bits 51:6 of 64-bits, also grabbing the lower 6 bits?
  localparam MC_AXI_RAC_BLEN_BW    = 10; // arlen
  localparam MC_AXI_RAC_USER_BW    =  1; // aruser
  
  localparam MC_AXI_RRC_ID_BW   =   8; // rid
  localparam MC_AXI_RRC_DATA_BW = 512; // rdata
  
// ================================================================================================
/* struct for read response channel response field
 */
  typedef struct packed {
    //logic [cxlip_top_pkg::ALTECC_INST_NUMBER-1:0] ecc_err_corrected;
	//logic [cxlip_top_pkg::ALTECC_INST_NUMBER-1:0] ecc_err_syn_e;
    //logic [cxlip_top_pkg::ALTECC_INST_NUMBER-1:0] ecc_err_fatal;
	
	//logic ecc_err_valid;
	logic poison;
  } t_rd_rsp_user;

  localparam MC_AXI_RRC_USER_BW = $bits( t_rd_rsp_user );
  
// ================================================================================================
/* AXI signals from BBS to MC
 */
  typedef struct packed {
    afu_axi_if_pkg::t_axi4_wr_resp_ready   bready;
    afu_axi_if_pkg::t_axi4_rd_resp_ready   rready;
	
	logic [MC_AXI_WAC_ID_BW-1:0]                 awid;
	logic [MC_AXI_WAC_ADDR_BW-1:0]               awaddr;
	logic [MC_AXI_WAC_BLEN_BW-1:0]               awlen;
	afu_axi_if_pkg::t_axi4_burst_size_encoding   awsize;
	afu_axi_if_pkg::t_axi4_burst_encoding        awburst;
	afu_axi_if_pkg::t_axi4_prot_encoding         awprot;
	afu_axi_if_pkg::t_axi4_qos_encoding          awqos;
	logic                                        awvalid;
	afu_axi_if_pkg::t_axi4_awcache_encoding      awcache;
	afu_axi_if_pkg::t_axi4_lock_encoding         awlock;
	logic [MC_AXI_WAC_REGION_BW-1:0]             awregion;
	logic [MC_AXI_WAC_USER_BW-1:0]               awuser;
	
    logic [MC_AXI_WDC_DATA_BW-1:0] wdata;
	logic [MC_AXI_WDC_STRB_BW-1:0] wstrb;
	logic                          wlast;
	logic                          wvalid;
	logic [MC_AXI_WDC_USER_BW-1:0] wuser; // currently only poison
	
	logic [MC_AXI_RAC_ID_BW-1:0]                 arid;
	logic [MC_AXI_RAC_ADDR_BW-1:0]               araddr;
	logic [MC_AXI_RAC_BLEN_BW-1:0]               arlen;
    afu_axi_if_pkg::t_axi4_burst_size_encoding   arsize;
    afu_axi_if_pkg::t_axi4_burst_encoding        arburst;
    afu_axi_if_pkg::t_axi4_prot_encoding         arprot;
    afu_axi_if_pkg::t_axi4_qos_encoding          arqos;
	logic                                        arvalid;
    afu_axi_if_pkg::t_axi4_arcache_encoding      arcache;
    afu_axi_if_pkg::t_axi4_lock_encoding         arlock;
    logic [MC_AXI_RAC_REGION_BW-1:0]             arregion;
    logic [MC_AXI_RAC_USER_BW-1:0]               aruser;
  } t_to_mc_axi4;
  
  localparam TO_MC_AXI4_BW = $bits(t_to_mc_axi4);
  
// ================================================================================================
  typedef struct packed {
    afu_axi_if_pkg::t_axi4_wr_addr_ready   awready;
    afu_axi_if_pkg::t_axi4_wr_data_ready    wready;
    afu_axi_if_pkg::t_axi4_rd_addr_ready   arready;
	
	logic [MC_AXI_WRC_ID_BW-1:0]           bid;
	afu_axi_if_pkg::t_axi4_resp_encoding   bresp;
	logic                                  bvalid;
	logic [MC_AXI_WRC_USER_BW-1:0]         buser;
	
	logic [MC_AXI_RRC_ID_BW-1:0]           rid;
	logic [MC_AXI_RRC_DATA_BW-1:0]         rdata;
	afu_axi_if_pkg::t_axi4_resp_encoding   rresp;
	logic                                  rvalid;
	logic                                  rlast;
    //logic [MC_AXI_RRC_USER_BW-1:0]         ruser;
	t_rd_rsp_user                          ruser;
  } t_from_mc_axi4;
  
  localparam FROM_MC_AXI4_BW = $bits(t_from_mc_axi4);

// ================================================================================================
  typedef struct packed {
    logic [MC_AXI_RRC_ID_BW-1:0]           rid;
    logic [MC_AXI_RRC_DATA_BW-1:0]         rdata;
    afu_axi_if_pkg::t_axi4_resp_encoding   rresp;
    logic                                  rvalid;
	logic                                  rlast;	
    t_rd_rsp_user                          ruser;
  } t_mc_rdrsp_axi4;



endpackage : mc_axi_if_pkg
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "Fidd1oyAhusLLJ6+7Y4fW+UxvqV+8TisWbzB76p8J7jCbedVkgTXiBKrUzNVBIRDckfBwS/gk4qyrpXnk44TsazVN20DO3TdF1x8MmH2pGcTjxrJqgYV/z3UJLaYPiY1WrKUNRPOAuHkyYvfI5GoAsKohhmpB04sGLV6+cGIymx/RXK+eIUgAROf9S5AOXsk1U/Lqv4gR7i2yfj3c/IhJWMX+Ld3X1LJ1lp+Ly9OQoy+AjZlo3hanu5GY+PvEKwcCRGL43E1bXUnv5dyhT7BSKx65eTTLIb55wFZ1TLxdmMg+SPPEc4ahcRvrRVSD2cLvvcDmV0e3/GhFGAxtLZ2XAI8+By190kZrSFnbBKn0I3CTgpL2/uHzh8y6ew+jcITjnJAi8figSb4p3svVjY1D0LjaIWCKAvWkeUVRRdPzXm1nCfpGBzT/R2eGos8qUqgjrBRwG9bgXg/n5Ss7rIR0b+qOnilecJmT0+73iM8WmM5uh44gHpSx3pb9XpYoknVzfSTZEMm39ju/yPM/FL/on3RgfXKjo5zAPVD9bv5pmFlh9lCMvgcpiUdykj5KeVrixcq/RO041MUBQlgpNdQW4YLIe01OtHexVvPQ9dxZGGKmOKctDVdP67byedyU2kx4zE56CP8WXwJ8PmVQgnf2R3ryMmzSYktotok1+/yjhIIaFh7xjUa3ZMC6RYorogWIqB2Vgmk4iQYaYK6jAib9x+UHrO/ljZKmfgKivg8B7+c10pi5fUc6aCxFpflotKFMNe/8mfHx55KavTUxlhpHNObdo7mNLi7YEtAJ54SVcsepyR/tbFJ3h18VR4lqD51MHLN6uhEiuKPHOh+giky0c7uCD0RUqrSyBcs2oS2zmsYoDWR/ZN/QWiLXbVMyh+J3fauM77NDhXyJ9aXo0kKhxHk0TtNu1eV6r5rF15MzabL0OTUsoIfqG38x9j+ePdpd9LQVwRDucgc1TwZ4GAYJ9m02fa/n7tTMff85z6642JImzexAgYPJmj3jgBVo+Ht"
`endif