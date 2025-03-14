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


`ifndef CFGPKG_V12
`define CFGPKG_V12

///
///  INTEL CONFIDENTIAL
///
///  Copyright 2015 Intel Corporation All Rights Reserved.
///
///  The source code contained or described herein and all documents related
///  to the source code ("Material") are owned by Intel Corporation or its
///  suppliers or licensors. Title to the Material remains with Intel
///  Corporation or its suppliers and licensors. The Material contains trade
///  secrets and proprietary and confidential information of Intel or its
///  suppliers and licensors. The Material is protected by worldwide copyright
///  and trade secret laws and treaty provisions. No part of the Material may
///  be used, copied, reproduced, modified, published, uploaded, posted,
///  transmitted, distributed, or disclosed in any way without Intel's prior
///  express written permission.
///
///  No license under any patent, copyright, trade secret or other intellectual
///  property right is granted to or conferred upon you by disclosure or
///  delivery of the Materials, either expressly, by implication, inducement,
///  estoppel or otherwise. Any license under such intellectual property rights
///  must be express and approved by Intel in writing.
///


// HEY!  Whenever we change this file, we must also change the name of the
// package and the `ifndefs too!  And there's an endpackage at the bottom of
// the file!
// There is the $rtlgen_pkg_version in specman.pm which must also be changed.

// HEY!  Whenever we change this file, we must also make the following changes
// in the nebulon_qa directory.  (If we are doing nebulon_qa testing.)
// 1.	./nebulon_qa/tests/RTL_tests/common/test_reg_common.sv
// 2.	Add symlinks to ./nebulon_qa/tests/RTL_tests/src/
// 3.	Add symlinks to ./nebulon_qa/tests/RTL_tests/common/

package rtlgen_pkg_v12;

function automatic logic [7:0] f_sai_sb_to_cr (
   input logic [7:0] sai_sb
);
   if (sai_sb[0] == 1) begin 
      if (sai_sb[7:4] != 4'b0000) begin
         f_sai_sb_to_cr = ({2'b00, 6'b111111});
      end
      else begin
         f_sai_sb_to_cr =  ({2'b00, 3'b000, sai_sb[3:1]});
      end
   end
   else begin 
      if (sai_sb[7:1] > 7'b0000111 && sai_sb[7:1] < 7'b0111111) begin
         f_sai_sb_to_cr =  ({2'b00, sai_sb[6:1]});
      end
      else begin 
         f_sai_sb_to_cr = ({2'b00, 6'b111111});
      end
   end  
endfunction : f_sai_sb_to_cr

// ==========================================================================
// Config Opcodes (same as IOSF Sideband)

typedef enum logic [3:0] {
    MRD   = 4'h0,
    MWR   = 4'h1,
    IORD  = 4'h2,
    IOWR  = 4'h3,
    CFGRD = 4'h4,
    CFGWR = 4'h5,
    CRRD  = 4'h6,
    CRWR  = 4'h7
} cfg_opcode_t;

// ==========================================================================
// Config Request Address formats for...

localparam CR_REQ_ADDR_LEN = 48;
localparam CR_REQ_ADDR_HI = 47;
// Mem
localparam CR_MEM_ADDR_HI = 47;
typedef struct packed { // 48
    logic [CR_MEM_ADDR_HI:0] offset;
} cfg_addr_mem_t;

// IO
localparam CR_IO_ADDR_HI = 15;
typedef struct packed { // 32+16=48
    logic [31:0] pad;
    logic [CR_IO_ADDR_HI:0] offset;
} cfg_addr_io_t;

// Cfg
localparam CR_CFG_ADDR_HI = 11;
typedef struct packed { // 36+12=48
    logic [35:0] pad;
    logic [CR_CFG_ADDR_HI:0] offset;
} cfg_addr_cfg_t;

// MSG
localparam CR_MSG_ADDR_HI = 15;
typedef struct packed { // 32+16=48
    logic [31:0] pad;
    logic [CR_MSG_ADDR_HI:0] offset;
} cfg_addr_msg_t;

// CR
localparam CR_CR_ADDR_HI = 15;
typedef struct packed { // 32+16=48
    logic [31:0] pad;
    logic [CR_CR_ADDR_HI:0] offset;
} cfg_addr_cr_t;

typedef union packed { // All structs must be 48
    cfg_addr_mem_t mem;
    cfg_addr_io_t  io;
    cfg_addr_cfg_t cfg;
    cfg_addr_msg_t  msg;
    cfg_addr_cr_t  cr;
} cfg_addr_t;

// ==========================================================================

// for 64bit bus
typedef struct packed { 
    logic        valid;
    cfg_opcode_t opcode;
    cfg_addr_t   addr;
    logic  [7:0] be;
    logic [63:0] data;
    logic [7:0] sai;
    logic  [7:0] fid;
    logic [2:0] bar;
} cfg_req_64bit_t;

typedef struct packed {
    logic        read_valid;
    logic        read_miss;
    logic        write_valid;
    logic        write_miss;
    logic        sai_successfull;
    logic [63:0] data;
} cfg_ack_64bit_t;

// for 32bit bus
typedef struct packed { 
    logic        valid;
    cfg_opcode_t opcode;
    cfg_addr_t   addr;
    logic  [3:0] be;
    logic [31:0] data;
    logic [7:0] sai;
    logic  [7:0] fid;
    logic [2:0] bar;
} cfg_req_32bit_t;

typedef struct packed {
    logic        read_valid;
    logic        read_miss;
    logic        write_valid;
    logic        write_miss;
    logic        sai_successfull;
    logic [31:0] data;
} cfg_ack_32bit_t;

// for 8bit bus
typedef struct packed { 
    logic        valid;
    cfg_opcode_t opcode;
    cfg_addr_t   addr;
    logic  [0:0] be;
    logic  [7:0] data;
    logic [7:0] sai;
    logic  [7:0] fid;
    logic [2:0] bar;
} cfg_req_8bit_t;

typedef struct packed {
    logic        read_valid;
    logic        read_miss;
    logic        write_valid;
    logic        write_miss;
    logic        sai_successfull;
    logic  [7:0] data;
} cfg_ack_8bit_t;

// ==========================================================================
// Merge ack from multiple CR banks
typedef struct packed {
   logic treg_trdy; 
   logic treg_cerr;   
   logic treg_rdata;
} cr_bank_ack_t;

// ==========================================================================

endpackage: rtlgen_pkg_v12

`endif

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "DGzrytkiceLjtyjsTaM+IzNUexbn5wzpmx4F1prXYECmxPXPn13o0M/rXNG1mO13RJ5fhQaExY1DId30xrFeFq5FL7gSGxHyRknIDLmmCNMcWImmwtFcy2uyhgWx0jyEzKKJKegjoNYHGsF9JtxyGoo4G3owvnlbnlgS/aJ3Aky5AJL4N0KkruYOdzUGck/zCmpIoex0KWhVL43DGHURVo8L2CS4v6cauUSxTHMeah3OIQ6abA/63uSrBS2Yj8hdLR0Pg83ata+A5W60BVYB0SYnjkV26rsMejnWk1fxf9vurIKnr9ie7NSedtfPi4svxIHiYn2aFSElZbzy95GDNHPdIaZyvFOWQbydU1a/odGtueiwYVmorYjdbjkoB6RmnaT+SfzUX72xpnZ0skfm6wSYzstsRWVKklzCbC0+N4ch9UFFjcV3YC0eVXVCSscJIJz+oV5P22zBlhuIS9kTUgExoz/gR+OAbP1PLxHRhthojU3myx6pX1R0D1AcX+HeZa31/yzqFPOStA+JXgHmOHCKRpe061QFe6yeh3YbPACb+DKLbfZ/YV7WUUdx2KJvVnQfoEsGZQppMGrKJGS21F6g7Vd6iAhhbRlpYSIshyuQLeMW9EDxCNX7hwVEEofhNgDttKVDCkRTLgYxpgkOiYqBDFErp184ZihstHEJxCw/xH3ZwFIjhx1Rc8tDaXGQO4ZEWDUur0MMgkI2I1TRmfejdrRp+MlPTuBge8sLW6v841YZQ2I0M2Y9nIOtLgrUxwcImr3Rx+0V+ECZ/DmuJEki88gkQr/cvDVtbRgkH+qZZgAWMrhN7tz9r1MqQwUdKhNU2Yu+eFZOeIbUDAPv9vp4hwPqq0DNOSkzrMENcpUab8vibDecdLNW0qLgke5pufwHISwlJoazKvXgoYQSLh4bgIGvkG3EILyQlmSOt52gSCj5/qkJHbEHMywy09YoFd/kfeT5tVulAL6iZiGsyjJzWin07IaW8VZgnImEyGxDwv/kz0JgRsyCPE6tN2kG"
`endif