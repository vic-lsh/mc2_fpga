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


// (C) 2001-2023 Intel Corporation. All rights reserved.
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


//----------------------------------------------------------------------------- 
//  Project Name:  avmm_bridge_1024_ed                                   
//  Module Name :  intel_pcie_bam_v2.sv                                  
//  Author      :  klai4                                   
//  Date        :  Thu Jan 7, 2021                                 
//  Description :  This module integrates all the submodules with BAM block
//-----------------------------------------------------------------------------  

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
`ifdef REPORT_UVM_ERR
   import uvm_pkg::*;
`endif
module intel_pcie_bam_v2
  # (
     parameter DEVICE_FAMILY   = "Agilex 7",
     parameter PFNUM_WIDTH = 2,
     parameter VFNUM_WIDTH = 12,
     parameter BAM_DATAWIDTH = 1024,

  parameter pf0_bar0_address_width_hwtcl     = 20,
  parameter pf0_bar1_address_width_hwtcl     = 0,
  parameter pf0_bar2_address_width_hwtcl     = 0,
  parameter pf0_bar3_address_width_hwtcl     = 0,
  parameter pf0_bar4_address_width_hwtcl     = 0,
  parameter pf0_bar5_address_width_hwtcl     = 0,

  parameter pf1_bar0_address_width_hwtcl     = 0,
  parameter pf1_bar1_address_width_hwtcl     = 0,
  parameter pf1_bar2_address_width_hwtcl     = 0,
  parameter pf1_bar3_address_width_hwtcl     = 0,
  parameter pf1_bar4_address_width_hwtcl     = 0,
  parameter pf1_bar5_address_width_hwtcl     = 0,

  parameter pf2_bar0_address_width_hwtcl     = 0,
  parameter pf2_bar1_address_width_hwtcl     = 0,
  parameter pf2_bar2_address_width_hwtcl     = 0,
  parameter pf2_bar3_address_width_hwtcl     = 0,
  parameter pf2_bar4_address_width_hwtcl     = 0,
  parameter pf2_bar5_address_width_hwtcl     = 0,

  parameter pf3_bar0_address_width_hwtcl     = 0,
  parameter pf3_bar1_address_width_hwtcl     = 0,
  parameter pf3_bar2_address_width_hwtcl     = 0,
  parameter pf3_bar3_address_width_hwtcl     = 0,
  parameter pf3_bar4_address_width_hwtcl     = 0,
  parameter pf3_bar5_address_width_hwtcl     = 0
     )
    (
     /*AUTOINPUT*/
     // Beginning of automatic inputs (from unused autoinst inputs)
     input [BAM_DATAWIDTH-1:0]      bam_readdata_i,         // To bam_avmm_intf_inst of intel_pcie_bam_avmm_intf.v
     input              bam_readdatavalid_i,    // To bam_avmm_intf_inst of intel_pcie_bam_avmm_intf.v
     input [1:0]        bam_response_i,         // To bam_avmm_intf_inst of intel_pcie_bam_avmm_intf.v
     input [2:0]        bam_rx_bar_i,           // To bam_sch_intf_inst of intel_pcie_bam_sch_intf.v
     input              bam_rx_eop_i,           // To bam_sch_intf_inst of intel_pcie_bam_sch_intf.v
     input [127:0]      bam_rx_header_i,        // To bam_sch_intf_inst of intel_pcie_bam_sch_intf.v
     input [BAM_DATAWIDTH-1:0]      bam_rx_payload_i,       // To bam_sch_intf_inst of intel_pcie_bam_sch_intf.v
     input [PFNUM_WIDTH-1:0] bam_rx_pfnum_i,    // To bam_sch_intf_inst of intel_pcie_bam_sch_intf.v
     input              bam_rx_sop_i,           // To bam_sch_intf_inst of intel_pcie_bam_sch_intf.v
     input              bam_rx_valid_i,         // To bam_sch_intf_inst of intel_pcie_bam_sch_intf.v
     input              bam_rx_vfactive_i,      // To bam_sch_intf_inst of intel_pcie_bam_sch_intf.v
     input [VFNUM_WIDTH-1:0] bam_rx_vfnum_i,    // To bam_sch_intf_inst of intel_pcie_bam_sch_intf.v
     input              bam_txc_ready_i,        // To bam_sch_intf_inst of intel_pcie_bam_sch_intf.v
     input              bam_waitrequest_i,      // To bam_avmm_intf_inst of intel_pcie_bam_avmm_intf.v
     input              bam_writeresponsevalid_i,// To bam_avmm_intf_inst of intel_pcie_bam_avmm_intf.v
     input [12:0]       busdev_num,             // To bam_cpl_inst of intel_pcie_bam_cpl.v
     input              clk,                    // To bam_sch_intf_inst of intel_pcie_bam_sch_intf.v, ...
     input [2:0]        dev_mps,                // To bam_cpl_inst of intel_pcie_bam_cpl.v
     input              rst_n,                  // To bam_sch_intf_inst of intel_pcie_bam_sch_intf.v, ...
     // End of automatics
     /*AUTOOUTPUT*/
     // Beginning of automatic outputs (from unused autoinst outputs)
     output [63:0]      bam_address_o,          // From bam_avmm_intf_inst of intel_pcie_bam_avmm_intf.v
     output [2:0]       bam_bar_o,              // From bam_avmm_intf_inst of intel_pcie_bam_avmm_intf.v
     output [3:0]       bam_burstcount_o,       // From bam_avmm_intf_inst of intel_pcie_bam_avmm_intf.v
     output [(BAM_DATAWIDTH/8-1):0]      bam_byteenable_o,       // From bam_avmm_intf_inst of intel_pcie_bam_avmm_intf.v
     output [6:0]       bam_np_hdr_credit_o,    // From bam_cpl_inst of intel_pcie_bam_cpl.v
     output [PFNUM_WIDTH-1:0] bam_pfnum_o,      // From bam_avmm_intf_inst of intel_pcie_bam_avmm_intf.v
     output             bam_read_o,             // From bam_avmm_intf_inst of intel_pcie_bam_avmm_intf.v
     output             bam_rx_ready_o,         // From bam_sch_intf_inst of intel_pcie_bam_sch_intf.v
     output             bam_txc_eop_o,          // From bam_sch_intf_inst of intel_pcie_bam_sch_intf.v
     output [127:0]      bam_txc_header_o,       // From bam_sch_intf_inst of intel_pcie_bam_sch_intf.v
     output [BAM_DATAWIDTH-1:0]     bam_txc_payload_o,      // From bam_sch_intf_inst of intel_pcie_bam_sch_intf.v
     output [PFNUM_WIDTH-1:0] bam_txc_pfnum_o,  // From bam_sch_intf_inst of intel_pcie_bam_sch_intf.v
     output             bam_txc_sop_o,          // From bam_sch_intf_inst of intel_pcie_bam_sch_intf.v
     output             bam_txc_valid_o,        // From bam_sch_intf_inst of intel_pcie_bam_sch_intf.v
     output             bam_txc_vfactive_o,     // From bam_sch_intf_inst of intel_pcie_bam_sch_intf.v
     output [VFNUM_WIDTH-1:0] bam_txc_vfnum_o,  // From bam_sch_intf_inst of intel_pcie_bam_sch_intf.v
     output             bam_vfactive_o,         // From bam_avmm_intf_inst of intel_pcie_bam_avmm_intf.v
     output [VFNUM_WIDTH-1:0] bam_vfnum_o,      // From bam_avmm_intf_inst of intel_pcie_bam_avmm_intf.v
     output             bam_write_o,            // From bam_avmm_intf_inst of intel_pcie_bam_avmm_intf.v
     output [BAM_DATAWIDTH-1:0]     bam_writedata_o,        // From bam_avmm_intf_inst of intel_pcie_bam_avmm_intf.v
     output             bam_writeresponsevalid_o,// From bam_avmm_intf_inst of intel_pcie_bam_avmm_intf.v
     // End of automatics
        

     //For rx credit interface
     output logic [9:0]    for_rxcrdt_tlp_len_o,
     output logic          for_rxcrdt_hdr_valid_o,
     output logic          for_rxcrdt_hdr_is_rd_o,
     output logic          for_rxcrdt_hdr_is_wr_o

     );


logic           preproc_cmd_fifo_empty ; 
logic  [BAM_DATAWIDTH-1:0]   rx_data_fifo_rddata; 
logic           tx_hdr_fifo_rreq ;
logic  [8:0]   cplram_rd_addr ;
logic           preproc_cmd_fifo_read ;
logic           rx_data_fifo_rdreq ; 
logic   [80:0]        cpl_cmd_fifo_rddata;
logic           cpl_cmd_fifo_empty;
logic   [214:0]    avmm_cmd_fifo_rddata;  
logic           avmm_cmd_fifo_empty;   
logic           avmm_writedata_rdreq; 
logic   [BAM_DATAWIDTH+127:0]        avmm_writedata;      
logic           avmm_cmd_fifo_rdreq ; 
logic           cpl_ram_rdreq ;
logic   [BAM_DATAWIDTH:0]        cplram_read_data ;
logic           avmm_read_data_valid;
logic           cpl_cmd_fifo_rdreq ;
logic   [96:0]     tx_hdr_fifo_rdata ; 
logic           tx_hdr_fifo_empty ;  
logic   [BAM_DATAWIDTH+1:0]  cplram_rd_data;
logic  [430:0]  preproc_cmd_fifo_data;      
logic           rx_valid_eop;
logic           write_done;
logic in_pkt;



 intel_pcie_bam_v2_sch_intf  
    #(
    .PFNUM_WIDTH(PFNUM_WIDTH),
    .VFNUM_WIDTH(VFNUM_WIDTH),
    .BAM_DATAWIDTH(BAM_DATAWIDTH),
   .pf0_bar0_address_width_hwtcl(pf0_bar0_address_width_hwtcl),
  .pf0_bar1_address_width_hwtcl(pf0_bar1_address_width_hwtcl),
  .pf0_bar2_address_width_hwtcl(pf0_bar2_address_width_hwtcl),
  .pf0_bar3_address_width_hwtcl(pf0_bar3_address_width_hwtcl),
  .pf0_bar4_address_width_hwtcl(pf0_bar4_address_width_hwtcl),
  .pf0_bar5_address_width_hwtcl(pf0_bar5_address_width_hwtcl),
  .pf1_bar0_address_width_hwtcl(pf1_bar0_address_width_hwtcl),
  .pf1_bar1_address_width_hwtcl(pf1_bar1_address_width_hwtcl),
  .pf1_bar2_address_width_hwtcl(pf1_bar2_address_width_hwtcl),
  .pf1_bar3_address_width_hwtcl(pf1_bar3_address_width_hwtcl),
  .pf1_bar4_address_width_hwtcl(pf1_bar4_address_width_hwtcl),
  .pf1_bar5_address_width_hwtcl(pf1_bar5_address_width_hwtcl),
  .pf2_bar0_address_width_hwtcl(pf2_bar0_address_width_hwtcl),
  .pf2_bar1_address_width_hwtcl(pf2_bar1_address_width_hwtcl),
  .pf2_bar2_address_width_hwtcl(pf2_bar2_address_width_hwtcl),
  .pf2_bar3_address_width_hwtcl(pf2_bar3_address_width_hwtcl),
  .pf2_bar4_address_width_hwtcl(pf2_bar4_address_width_hwtcl),
  .pf2_bar5_address_width_hwtcl(pf2_bar5_address_width_hwtcl),
  .pf3_bar0_address_width_hwtcl(pf3_bar0_address_width_hwtcl),
  .pf3_bar1_address_width_hwtcl(pf3_bar1_address_width_hwtcl),
  .pf3_bar2_address_width_hwtcl(pf3_bar2_address_width_hwtcl),
  .pf3_bar3_address_width_hwtcl(pf3_bar3_address_width_hwtcl),
  .pf3_bar4_address_width_hwtcl(pf3_bar4_address_width_hwtcl),
  .pf3_bar5_address_width_hwtcl(pf3_bar5_address_width_hwtcl)
    ) bam_sch_intf (
    .clk(clk ),
    .rst_n(rst_n ),
    .bam_rx_ready_o(bam_rx_ready_o ),
    .bam_rx_payload_i(bam_rx_payload_i),
    .bam_rx_header_i(bam_rx_header_i ), 
    .bam_rx_bar_i(bam_rx_bar_i ), 
    .bam_rx_sop_i(bam_rx_sop_i ),
    .bam_rx_valid_i(bam_rx_valid_i ),
    .bam_rx_eop_i(bam_rx_eop_i ),
    .bam_rx_vfactive_i(bam_rx_vfactive_i ),
    .bam_rx_pfnum_i(bam_rx_pfnum_i ),
    .bam_rx_vfnum_i(bam_rx_vfnum_i ),
    .preproc_cmd_fifo_empty_o(preproc_cmd_fifo_empty ), 
    .preproc_cmd_fifo_rdreq_i(preproc_cmd_fifo_read ), 
    .preproc_cmd_fifo_rddata_o(preproc_cmd_fifo_data ), 
    .rx_data_fifo_rddata_o(rx_data_fifo_rddata),    
    .rx_data_fifo_rdreq_i(rx_data_fifo_rdreq ),
    .tx_hdr_fifo_rreq_o(tx_hdr_fifo_rreq ),
    .tx_hdr_fifo_empty_i(tx_hdr_fifo_empty ),
    .tx_hdr_fifo_rdata_i(tx_hdr_fifo_rdata ),
    .cplram_rd_addr_o(cplram_rd_addr ),
    .cplram_rd_data_i(cplram_rd_data ),
    .bam_txc_ready_i(bam_txc_ready_i ),
    .bam_txc_payload_o(bam_txc_payload_o ),
    .bam_txc_eop_o(bam_txc_eop_o ), 
    .bam_txc_valid_o(bam_txc_valid_o),
    .bam_txc_header_o(bam_txc_header_o ),
    .bam_txc_sop_o(bam_txc_sop_o ),
    .bam_txc_vfactive_o(bam_txc_vfactive_o ),
    .bam_txc_pfnum_o(bam_txc_pfnum_o ),
    .bam_txc_vfnum_o(bam_txc_vfnum_o),   
    .valid_eop_o(rx_valid_eop),
    .max_payload_size_i(dev_mps),
    .for_rxcrdt_tlp_len_o(for_rxcrdt_tlp_len_o),        //For rx credit interface
    .for_rxcrdt_hdr_valid_o(for_rxcrdt_hdr_valid_o),    //For rx credit interface
    .for_rxcrdt_hdr_is_rd_o(for_rxcrdt_hdr_is_rd_o),    //For rx credit interface
    .for_rxcrdt_hdr_is_wr_o(for_rxcrdt_hdr_is_wr_o)    //For rx credit interface


);


 intel_pcie_bam_v2_rw 
#(
    .BAM_DATAWIDTH(BAM_DATAWIDTH)
) bam_rw (
  .clk(clk ),
  .rst_n(rst_n ),
  .preproc_cmd_fifo_read_o(preproc_cmd_fifo_read ),
  .preproc_cmd_fifo_data_i(preproc_cmd_fifo_data ),
  .preproc_cmd_fifo_empty_i(preproc_cmd_fifo_empty ),
  .rx_data_fifo_rdreq_o(rx_data_fifo_rdreq ), 
  .rx_data_fifo_rdata_i(rx_data_fifo_rddata ),
  .cpl_cmd_fifo_rdreq_i(cpl_cmd_fifo_rdreq),
  .cpl_cmd_fifo_rddata_o(cpl_cmd_fifo_rddata),
  .cpl_cmd_fifo_empty_o(cpl_cmd_fifo_empty),
  .avmm_cmd_fifo_rdreq_i(avmm_cmd_fifo_rdreq),   
  .avmm_cmd_fifo_rddata_o(avmm_cmd_fifo_rddata),  
  .avmm_cmd_fifo_empty_o(avmm_cmd_fifo_empty),   
  .avmm_writedata_rdreq_i(avmm_writedata_rdreq), 
  .avmm_writedata_o(avmm_writedata),  
  .rx_valid_eop_i(rx_valid_eop),    
  .max_payload_size_i(dev_mps),
  .bam_np_hdr_credit_o(bam_np_hdr_credit_o),
  .write_done_o (write_done)         
);


 intel_pcie_bam_v2_avmm_intf
#(
    .BAM_DATAWIDTH(BAM_DATAWIDTH)

) bam_avmm_intf (
    .clk(clk ),
    .rst_n(rst_n ),
    .bam_bar_o(bam_bar_o ),
    .bam_vfactive_o(bam_vfactive_o ),
    .bam_pfnum_o(bam_pfnum_o ),
    .bam_vfnum_o(bam_vfnum_o ),
    .bam_write_o(bam_write_o ),
    .bam_address_o(bam_address_o ),
    .bam_writedata_o(bam_writedata_o ),
    .bam_byteenable_o(bam_byteenable_o ),
    .bam_burstcount_o(bam_burstcount_o ),
    .bam_waitrequest_i(bam_waitrequest_i ),
    .bam_read_o(bam_read_o ),
    .bam_readdata_i(bam_readdata_i ),
    .bam_readdatavalid_i(bam_readdatavalid_i ),
    .bam_writeresponsevalid_i(bam_writeresponsevalid_i ),
    .bam_response_i(bam_response_i ),
    .bam_writeresponsevalid_o(bam_writeresponsevalid_o ),
    .avmm_cmd_fifo_rreq_o(avmm_cmd_fifo_rdreq ), 
    .avmm_cmd_fifo_rdata_i(avmm_cmd_fifo_rddata ),
    .avmm_cmd_fifo_empty_i(avmm_cmd_fifo_empty ), 
    .avmm_data_fifo_rreq_o(avmm_writedata_rdreq ), 
    .avmm_data_fifo_rdata_i(avmm_writedata ),
    .cpl_ram_rdreq_i(cpl_ram_rdreq ),
    .cplram_read_data_o(cplram_read_data ),
    .avmm_read_data_valid_o(avmm_read_data_valid),
    .write_done_i(write_done)
    
);


 intel_pcie_bam_v2_cpl 
#(
    .BAM_DATAWIDTH(BAM_DATAWIDTH)

) bam_cpl (
    .clk(clk ),
    .rst_n(rst_n ),
    .cplcmd_fifo_rdreq_o(cpl_cmd_fifo_rdreq ),
    .cplcmd_fifo_data_i(cpl_cmd_fifo_rddata ),
    .cplcmd_fifo_empty_i(cpl_cmd_fifo_empty ),
    .cpl_buf_rdreq_o(cpl_ram_rdreq ),
    .cpl_buf_data_i(cplram_read_data ),
    .cpl_buff_wrreq_i(avmm_read_data_valid),  
    .tx_data_buff_rd_addr_i(cplram_rd_addr ),
    .tx_data_buff_o(cplram_rd_data ),
    .tx_hdr_fifo_rreq_i(tx_hdr_fifo_rreq ),  
    .tx_hdr_fifo_rdata_o(tx_hdr_fifo_rdata ), 
    .tx_hdr_fifo_empty_o(tx_hdr_fifo_empty ),  
    .busdev_num_i(busdev_num)
   
 
 );












// Assertions
`ifdef ALTERA_PCIE_S10_ENABLE_ASSERTIONS

always @(posedge clk) begin
	if(~rst_n) begin
		in_pkt <= 1'b0;
	end
	else if(bam_rx_valid_i === 1'b1) begin
		if(bam_rx_sop_i === 1'b1 && bam_rx_eop_i === 1'b0) begin
			in_pkt <= 1'b1;
		end
		else if(bam_rx_eop_i=== 1'b1) begin
			in_pkt <= 1'b0;
		end
	end
end

property bam_avst_error_sop_sop;
  @(posedge clk)
  disable iff (~rst_n)
   (in_pkt === 1'b1 && bam_rx_valid_i === 1'b1) -> (bam_rx_sop_i === 1'b0);
endproperty
ERROR_bam_avst_sop_sop :
  begin
    assert property (bam_avst_error_sop_sop)
    `ifdef REPORT_UVM_ERR
       else uvm_report_error("BAM", $psprintf("UVM_ASSERTION FAILED: SOP followed by SOP"), UVM_NONE);
    `else
       else $error("%t, RTL_ASSERTION_ERROR: SOP followed by SOP",$time());
    `endif
  end

property bam_avst_error_eop_eop;
  @(posedge clk)
  disable iff (~rst_n)
   (in_pkt === 1'b0 && bam_rx_sop_i === 1'b0 && bam_rx_valid_i === 1'b1) -> (bam_rx_eop_i === 1'b0);
endproperty
ERROR_bam_avst_eop_eop :
  begin
    assert property (bam_avst_error_eop_eop)
    `ifdef REPORT_UVM_ERR
       else uvm_report_error("BAM", $psprintf("UVM_ASSERTION FAILED: EOP followed by EOP"), UVM_NONE);
    `else
       else $error("%t, RTL_ASSERTION_ERROR: EOP followed by EOP",$time());
    `endif
  end  

property bam_avst_error_unexpected_valid;
  @(posedge clk)
  disable iff (~rst_n)
   (in_pkt === 1'b0 && bam_rx_sop_i === 1'b0) -> (bam_rx_valid_i === 1'b0);
endproperty
ERROR_bam_avst_unexpected_valid :
  begin
    assert property (bam_avst_error_unexpected_valid)
    `ifdef REPORT_UVM_ERR
       else uvm_report_error("BAM", $psprintf("UVM_ASSERTION FAILED: Valid data with no SOP"), UVM_NONE);
    `else
       else $error("%t, RTL_ASSERTION_ERROR: Valid data with no SOP",$time());
    `endif
  end  
  
`endif











   

   
    
    
endmodule //intel_pcie_bam

/*
 Local Variables:
 verilog-library-directories:(".")
 verilog-auto-inst-param-value: t
 */
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "DcjSv4cazWNFeTq2LDzhR8VVA2vsU+D2FLr5cau2M2bJ+ymOMJzu0j4X+D7sDofwwnGT3dC9uPfUfqUyT+1JDqgoqF4+Hm1+DbOqZuomBxMc/3ubRV7jR7LhS90CAIiftZSupMkt7Z6NB7tsmbvAu3Uqtxlo+Ag4QRIgi49yVFsS2wB30qw4GeL5di6t6OjbvWcjLtKHJMZ/Vew3QCsc9aW8Cap9TcP/4lTkJB8MFTi28pDTXkGFOXGosgDjWCNMlW7O8zq3CWfT+BynU0i9gt1mbncIdrQjTervTMfQVUb62Od+GrSVnhc0aVWycvix9pWE9GJwC/6OfoOJ+QfDBaCGawwSLM3M1QXZuadtKYsebcMNxSvrtwV0wwuQhpMlqY4X8ZX4AekpJ2EoR2EMuHPHMG+jpiI/wYtlSlN/BN5xpPDYa+HEIaHfq3PPn+guPlsN7NdyscbAkE613v7lgyTRlugGJAy8thayel2Bbp1dbhni795YqOkdAMI2MCc7u4DlI1baRmRK4Bbz5A79mhKD3Uuz84tun/B4JsdnKy7VvHc0adW5q8C7S1lhCEUj/Iv7J9FYlotjOH76IchqO56q9v97EYF/SSzmAERcKDPvtJQzITMir5JA9Weba9IjFkb1acEW4SY51uOgpbxA8RoQRYZlU2n+Xl+13zL8hEMemOKeSlYdiVLsfn8JUA8ONg4cEZShCR6Lg/AmmA9b3Xo8KO85L6rPFPBGbzbZbAm6p1uoTyday4nxIazFk79UWBZf7xwXv9fZelkwf89MhtKIwWl5KgOuz4tqPiMUIKyTHWY4Ac7p80mhGOhtLMNlZXx9eQ4IDDE5xHHMf4zAcTnkQR6NcDFUbBEaQjIosj+gyXI7vpXka4wBtUkXZom9OXb3uWuumj0i3+sGbRq8zfJuyi/bylSZD+Km9EOLt7t3hBlNmpDlg7wkSRS+dj6IeF0ZTuVNkFuQ2NhWmw6Ou81N+Da1/Owmn76rwL1NQ5cX0fB/WOm+HJ34OFiBjXpE"
`endif