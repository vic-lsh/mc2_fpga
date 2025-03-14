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


// (C) 2001-2016 Altera Corporation. All rights reserved.
// Your use of Altera Corporat's design                tools, logic functions and other
// software and tools, and its AMPP partner logic functions, and any output
// files any of the foregoing (including device programming or simulation
// files), and any associated documentation or information are expressly subject
// to the terms and conditions of the Altera Program License Subscription
// Agreement, Altera MegaCore Function License Agreement, or other applicable
// license agreement, including, without limitation, that your use is for the
// sole purpose of programming logic devices manufactured by Altera and sold by
// Altera or its authorized distributors.  Please refer to the applicable
// agreement for further details.

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

//`default_nettype none

module intel_pcie_reset_sync #(
  parameter                  WIDTH_RST              = 1
) (
  input                      clk,
  input                      rst_n,
  output [WIDTH_RST-1:0]     srst_n
);

  wire                       sync_rst_n;

  reg   [WIDTH_RST-1:0]      sync_rst_n_r /* synthesis dont_merge */;
  reg   [WIDTH_RST-1:0]      sync_rst_n_rr /* synthesis dont_merge */;

  assign srst_n              = sync_rst_n_rr;

  intel_std_synchronizer_nocut sync (.clk (clk), .reset_n (rst_n), .din (1'b1), .dout (sync_rst_n) );

  always @(posedge clk) begin
    sync_rst_n_r             <= {(WIDTH_RST){sync_rst_n}};
    sync_rst_n_rr            <= {(WIDTH_RST){sync_rst_n_r}};
  end 


endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "DcjSv4cazWNFeTq2LDzhR8VVA2vsU+D2FLr5cau2M2bJ+ymOMJzu0j4X+D7sDofwwnGT3dC9uPfUfqUyT+1JDqgoqF4+Hm1+DbOqZuomBxMc/3ubRV7jR7LhS90CAIiftZSupMkt7Z6NB7tsmbvAu3Uqtxlo+Ag4QRIgi49yVFsS2wB30qw4GeL5di6t6OjbvWcjLtKHJMZ/Vew3QCsc9aW8Cap9TcP/4lTkJB8MFTj+2JivjV+GEp+RXdymnMvZ1wwhSCaHdCG4qjpF0zBl4COnd5NT0Y/5IUjx21mzSbsgjS9QJFy2WbOsKhOaAF6NmmhR62OkpC+VsfadctC8ptEUyUKdIxSpQq3c1KtojKuY5+dDvPj8L2mMNGLcTMUxOU7MhwsAhJJH99m0GsCkuAMz2Egqa7NSEoJ8ZJVuOvP2KVnh0FOpa7SkXyojLZD+PJdLg5B7ITc3lvM3IMGMB/JLHhldvzR3AsdfarV5vAxyM9so3HDSDh3eO3TEVirXFmZ+A1ayZ/DSI8Vd9G17l1QHbll2N0ZZyA8Bru7oBW2M3RPdgWSrYLC7YzfG30F02iFVV11dhFtiXrHQCLXqmUpqG6Cqfp8s+SYvtQbebgamjBUq17UikM9rUpEd/cB/rSzPH76ySQ7yKDwUGjKJ0R6eM44avDC4x719MnpvYmFtDO+LnMHR3pUrSx1apcJBJsXq0a76k/LUigJ89xpYYkl3Rn9S0/mSOIP6cbmgH0aSzf5lDQCFdSXD754fihuijjYgZQAbhXM5UXY2Gh6vqosrT0hDiBtRUSouCXTo59zyMcCnVvHvfBETZ3ZY9GL+E4gizl0xtT/9e1jzdZql+onUCb7BdaxgZ7Tcz7G+2CEGj4PxIxzV/6ok1AnFI8QzlBkHdQNSKA4XOIKELMnyZdjWYYZcT0mdG15itZq1146KOq3i8k77uXnVXSSTdiypBkzqDoGsalcRWZb3MekolrINqtbWWSfi+ToO0Wqrh4quOgDtUeXG+/HAlNGiouPE"
`endif