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
//`include "cxl_ed_defines.svh.iv"

`include "cxl_typ3ddr_ed_defines.svh.iv"

import cxlip_top_pkg::*;

module afu_top(
    
    input  logic                                             afu_clk,
    input  logic                                             afu_rstn,
  `ifdef OOORSP_MC_AXI2AVMM 
     // April 2023 - Supporting out of order responses with AXI4
      input mc_axi_if_pkg::t_to_mc_axi4    [MC_CHANNEL-1:0] cxlip2iafu_to_mc_axi4,
      output mc_axi_if_pkg::t_to_mc_axi4   [MC_CHANNEL-1:0] iafu2mc_to_mc_axi4 ,
      input mc_axi_if_pkg::t_from_mc_axi4  [MC_CHANNEL-1:0] mc2iafu_from_mc_axi4,
      output mc_axi_if_pkg::t_from_mc_axi4 [MC_CHANNEL-1:0] iafu2cxlip_from_mc_axi4
  `else
    input  logic [cxlip_top_pkg::MC_CHANNEL-1:0]             mc2iafu_ready_eclk,
    input  logic [cxlip_top_pkg::MC_CHANNEL-1:0]             mc2iafu_read_poison_eclk,
    input  logic [cxlip_top_pkg::MC_CHANNEL-1:0]             mc2iafu_readdatavalid_eclk,
    // Error Correction Code (ECC)
    // Note *ecc_err_* are valid when mc2iafu_readdatavalid_eclk is active
    input  logic [cxlip_top_pkg::ALTECC_INST_NUMBER-1:0]     mc2iafu_ecc_err_corrected_eclk  [cxlip_top_pkg::MC_CHANNEL-1:0],
    input  logic [cxlip_top_pkg::ALTECC_INST_NUMBER-1:0]     mc2iafu_ecc_err_detected_eclk   [cxlip_top_pkg::MC_CHANNEL-1:0],
    input  logic [cxlip_top_pkg::ALTECC_INST_NUMBER-1:0]     mc2iafu_ecc_err_fatal_eclk      [cxlip_top_pkg::MC_CHANNEL-1:0],
    input  logic [cxlip_top_pkg::ALTECC_INST_NUMBER-1:0]     mc2iafu_ecc_err_syn_e_eclk      [cxlip_top_pkg::MC_CHANNEL-1:0],
    input  logic [cxlip_top_pkg::MC_CHANNEL-1:0]             mc2iafu_ecc_err_valid_eclk,
    input  logic [cxlip_top_pkg::MC_CHANNEL-1:0]             mc2iafu_cxlmem_ready,
    input  logic [cxlip_top_pkg::MC_HA_DP_DATA_WIDTH-1:0]    mc2iafu_readdata_eclk           [cxlip_top_pkg::MC_CHANNEL-1:0],
    input  logic [cxlip_top_pkg::MC_MDATA_WIDTH-1:0]         mc2iafu_rsp_mdata_eclk          [cxlip_top_pkg::MC_CHANNEL-1:0],
    
    
    output logic [cxlip_top_pkg::MC_HA_DP_DATA_WIDTH-1:0]    iafu2mc_writedata_eclk          [cxlip_top_pkg::MC_CHANNEL-1:0],
    output logic [cxlip_top_pkg::MC_HA_DP_BE_WIDTH-1:0]      iafu2mc_byteenable_eclk         [cxlip_top_pkg::MC_CHANNEL-1:0],
    output logic [cxlip_top_pkg::MC_CHANNEL-1:0]             iafu2mc_read_eclk,
    output logic [cxlip_top_pkg::MC_CHANNEL-1:0]             iafu2mc_write_eclk,
    output logic [cxlip_top_pkg::MC_CHANNEL-1:0]             iafu2mc_write_poison_eclk,
    output logic [cxlip_top_pkg::MC_CHANNEL-1:0]             iafu2mc_write_ras_sbe_eclk,    
    output logic [cxlip_top_pkg::MC_CHANNEL-1:0]             iafu2mc_write_ras_dbe_eclk,    
    //output logic [cxlip_top_pkg::MC_HA_DP_ADDR_WIDTH-1:0]    iafu2mc_address_eclk            [cxlip_top_pkg::MC_CHANNEL-1:0],
    output logic [(cxlip_top_pkg::CXLIP_FULL_ADDR_MSB):(cxlip_top_pkg::CXLIP_FULL_ADDR_LSB)]    iafu2mc_address_eclk            [cxlip_top_pkg::MC_CHANNEL-1:0],
    output logic [cxlip_top_pkg::MC_MDATA_WIDTH-1:0]         iafu2mc_req_mdata_eclk          [cxlip_top_pkg::MC_CHANNEL-1:0],

                //CXL_IP to AFU to MC TOP Passthrough signals
    output  logic [cxlip_top_pkg::MC_CHANNEL-1:0]             iafu2cxlip_ready_eclk,
    output  logic [cxlip_top_pkg::MC_CHANNEL-1:0]             iafu2cxlip_read_poison_eclk,
    output  logic [cxlip_top_pkg::MC_CHANNEL-1:0]             iafu2cxlip_readdatavalid_eclk,
    // Error Correction Code (ECC)
    // Note *ecc_err_* are valid when mc2iafu_readdatavalid_eclk is active
    output  logic [cxlip_top_pkg::ALTECC_INST_NUMBER-1:0]     iafu2cxlip_ecc_err_corrected_eclk  [cxlip_top_pkg::MC_CHANNEL-1:0],
    output  logic [cxlip_top_pkg::ALTECC_INST_NUMBER-1:0]     iafu2cxlip_ecc_err_detected_eclk   [cxlip_top_pkg::MC_CHANNEL-1:0],
    output  logic [cxlip_top_pkg::ALTECC_INST_NUMBER-1:0]     iafu2cxlip_ecc_err_fatal_eclk      [cxlip_top_pkg::MC_CHANNEL-1:0],
    output  logic [cxlip_top_pkg::ALTECC_INST_NUMBER-1:0]     iafu2cxlip_ecc_err_syn_e_eclk      [cxlip_top_pkg::MC_CHANNEL-1:0],
    output  logic [cxlip_top_pkg::MC_CHANNEL-1:0]             iafu2cxlip_ecc_err_valid_eclk,
    output  logic [cxlip_top_pkg::MC_CHANNEL-1:0]             iafu2cxlip_cxlmem_ready,
    output  logic [cxlip_top_pkg::MC_HA_DP_DATA_WIDTH-1:0]    iafu2cxlip_readdata_eclk           [cxlip_top_pkg::MC_CHANNEL-1:0],
    output  logic [cxlip_top_pkg::MC_MDATA_WIDTH-1:0]         iafu2cxlip_rsp_mdata_eclk          [cxlip_top_pkg::MC_CHANNEL-1:0],
    
    input logic [cxlip_top_pkg::MC_HA_DP_DATA_WIDTH-1:0]      cxlip2iafu_writedata_eclk          [cxlip_top_pkg::MC_CHANNEL-1:0],
    input logic [cxlip_top_pkg::MC_HA_DP_BE_WIDTH-1:0]        cxlip2iafu_byteenable_eclk         [cxlip_top_pkg::MC_CHANNEL-1:0],
    input logic [cxlip_top_pkg::MC_CHANNEL-1:0]               cxlip2iafu_read_eclk,
    input logic [cxlip_top_pkg::MC_CHANNEL-1:0]               cxlip2iafu_write_eclk,
    input logic [cxlip_top_pkg::MC_CHANNEL-1:0]               cxlip2iafu_write_poison_eclk,
    input logic [cxlip_top_pkg::MC_CHANNEL-1:0]               cxlip2iafu_write_ras_sbe_eclk,    
    input logic [cxlip_top_pkg::MC_CHANNEL-1:0]               cxlip2iafu_write_ras_dbe_eclk,    
    input logic  [(cxlip_top_pkg::CXLIP_FULL_ADDR_MSB):(cxlip_top_pkg::CXLIP_FULL_ADDR_LSB)]      cxlip2iafu_address_eclk            [cxlip_top_pkg::MC_CHANNEL-1:0],
    input logic [cxlip_top_pkg::MC_MDATA_WIDTH-1:0]           cxlip2iafu_req_mdata_eclk          [cxlip_top_pkg::MC_CHANNEL-1:0]
 `endif    
    
);


//  logic [(cxlip_top_pkg::CXLIP_FULL_ADDR_MSB):(cxlip_top_pkg::CXLIP_FULL_ADDR_LSB)]    cxlip2iafu_chan_address_eclk            [cxlip_top_pkg::MC_CHANNEL-1:0];  //added from 22ww18a
//
//  always_comb begin
//    for (int i=0; i<cxlip_top_pkg::MC_CHANNEL; i++) begin
//      cxlip2iafu_chan_address_eclk[i] = { '0, cxlip2iafu_address_eclk[i][(cxlip_top_pkg::CXLIP_CHAN_ADDR_MSB):(cxlip_top_pkg::CXLIP_CHAN_ADDR_LSB)] };
//    end
//  end



//Passthrough User can implement the AFU logic here 
  `ifdef OOORSP_MC_AXI2AVMM 
      assign iafu2mc_to_mc_axi4      = cxlip2iafu_to_mc_axi4;
      assign iafu2cxlip_from_mc_axi4 = mc2iafu_from_mc_axi4;

`else
assign iafu2cxlip_ready_eclk                = mc2iafu_ready_eclk             ;
assign iafu2cxlip_read_poison_eclk          = mc2iafu_read_poison_eclk       ;
assign iafu2cxlip_readdatavalid_eclk        = mc2iafu_readdatavalid_eclk     ;
assign iafu2cxlip_ecc_err_corrected_eclk    = mc2iafu_ecc_err_corrected_eclk ;
assign iafu2cxlip_ecc_err_detected_eclk     = mc2iafu_ecc_err_detected_eclk  ;
assign iafu2cxlip_ecc_err_fatal_eclk        = mc2iafu_ecc_err_fatal_eclk     ;
assign iafu2cxlip_ecc_err_syn_e_eclk        = mc2iafu_ecc_err_syn_e_eclk     ;
assign iafu2cxlip_ecc_err_valid_eclk        = mc2iafu_ecc_err_valid_eclk     ;
assign iafu2cxlip_cxlmem_ready              = mc2iafu_cxlmem_ready           ;
assign iafu2cxlip_readdata_eclk             = mc2iafu_readdata_eclk          ;
assign iafu2cxlip_rsp_mdata_eclk            = mc2iafu_rsp_mdata_eclk         ;  


assign iafu2mc_writedata_eclk               = cxlip2iafu_writedata_eclk     ;
assign iafu2mc_byteenable_eclk              = cxlip2iafu_byteenable_eclk    ;
assign iafu2mc_read_eclk                    = cxlip2iafu_read_eclk          ;
assign iafu2mc_write_eclk                   = cxlip2iafu_write_eclk         ;
assign iafu2mc_write_poison_eclk            = cxlip2iafu_write_poison_eclk  ;
assign iafu2mc_write_ras_sbe_eclk           = cxlip2iafu_write_ras_sbe_eclk ;
assign iafu2mc_write_ras_dbe_eclk           = cxlip2iafu_write_ras_dbe_eclk ;
//assign iafu2mc_address_eclk                 = cxlip2iafu_chan_address_eclk       ;
assign iafu2mc_address_eclk                 = cxlip2iafu_address_eclk       ;
assign iafu2mc_req_mdata_eclk               = cxlip2iafu_req_mdata_eclk     ;

`endif


endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "DcjSv4cazWNFeTq2LDzhR8VVA2vsU+D2FLr5cau2M2bJ+ymOMJzu0j4X+D7sDofwwnGT3dC9uPfUfqUyT+1JDqgoqF4+Hm1+DbOqZuomBxMc/3ubRV7jR7LhS90CAIiftZSupMkt7Z6NB7tsmbvAu3Uqtxlo+Ag4QRIgi49yVFsS2wB30qw4GeL5di6t6OjbvWcjLtKHJMZ/Vew3QCsc9aW8Cap9TcP/4lTkJB8MFTiPgVYmn8s5FPCpgUPmMWBr/IqpWtYEs4+XOwmBRp81T3wwUkBDL66euUaDgvla1L4J7hBvBgn5NcKdbD2N7MGDF0Fh2EI2lzcDPSHKq3ErHU05PpKcDWJRWnBHssTy/ELdRwisxTkEeYIcfZAnFPQZM4O2xeybF8SQmJ3q5KM+dwXzltKsCzJ3rphesMdrmLIT4y/gxLMC/B8CH8k0gorjUAOZR8tF4Jm+1pv8mKKl9GY1irzlwpGUGfRfDsE6/DXZexc291OSw28HYaSKsKtEQcSH4d3FcnK0/1nUHBye2myOQV5sqmwwoFV7bYpgM5vOeAOhk4soRKgpoPxZ9RFaDTGtudVYpp+pSa6RVWKauqwKYFcB7l78LXBs2XPvQ8g1sXQ0mh2Lz1D7r/M79VzqvUMmD9i+t4GmYB+B1ov53whvfclpQtOZR3FCVF9xrOlgtcPkwsegdTe/OPOmD4mSIOmOCM5NXWKCSLqyBPD6FfJls6Dk0dxb7hfLcEaENgakjIj/iChEvhydgUyAiigPqVNLtIM1wV4c6ICIKYDS3QKXPU0mfufUAn1PnxhqUTCnXRzNDU/BtTbXtC3oWuFdzYAp5D6q/q0sB08bSFmOo/6rHr06ktuPlSlrcGnRPBBKp3vVTltiq1IIJMMM6xirI9IHG0ZzMqT8vea+k/XL4jepvRTyOBuxNqH4P9rchN4XbREyjh9MvsdvivriLk+x+3kVMl02iKBsz/ns5dnJ7l55uu2vgVF2AZqhX+9iG6TxEv73av2OaZHty+BYd3yt"
`endif