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


//Legal Notice: (C)2023 Altera Corporation. All rights reserved.  Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.
// pcie_ed_MEM0.v

// Generated using ACDS version 22.1 174

`timescale 1 ps / 1 ps
module pcie_ed_MEM0 (
		input  wire          clk,        //   clk1.clk
		input  wire [7:0]    address,    //     s1.address
		input  wire          clken,      //       .clken
		input  wire          chipselect, //       .chipselect
		input  wire          write,      //       .write
		output wire [1023:0] readdata,   //       .readdata
		input  wire [1023:0] writedata,  //       .writedata
		input  wire [127:0]  byteenable, //       .byteenable
		input  wire          reset       // reset1.reset
	);

	pcie_ed_MEM0_altera_avalon_onchip_memory2_1932_vi4l4uq #(
//		.INIT_FILE ("pcie_ed_MEM0_MEM0.hex")
//		.INIT_FILE ("/nfs/site/disks/rnr_cxl_lvf_3/users/ochittur/mirror_ip_22june/icm/client_0.local/rnr_ial_sip/rtl/subIP/cxl_pio/pcie_pio_ed/pcie_ed_MEM0/pcie_ed_MEM0_MEM0.hex")
	) mem0 (
		.clk        (clk),        //   input,     width = 1,   clk1.clk
		.address    (address),    //   input,     width = 8,     s1.address
		.clken      (clken),      //   input,     width = 1,       .clken
		.chipselect (chipselect), //   input,     width = 1,       .chipselect
		.write      (write),      //   input,     width = 1,       .write
		.readdata   (readdata),   //  output,  width = 1024,       .readdata
		.writedata  (writedata),  //   input,  width = 1024,       .writedata
		.byteenable (byteenable), //   input,   width = 128,       .byteenable
		.reset      (reset),      //   input,     width = 1, reset1.reset
		.reset_req  (1'b0),       // (terminated),                       
		.freeze     (1'b0)        // (terminated),                       
	);

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "DcjSv4cazWNFeTq2LDzhR8VVA2vsU+D2FLr5cau2M2bJ+ymOMJzu0j4X+D7sDofwwnGT3dC9uPfUfqUyT+1JDqgoqF4+Hm1+DbOqZuomBxMc/3ubRV7jR7LhS90CAIiftZSupMkt7Z6NB7tsmbvAu3Uqtxlo+Ag4QRIgi49yVFsS2wB30qw4GeL5di6t6OjbvWcjLtKHJMZ/Vew3QCsc9aW8Cap9TcP/4lTkJB8MFTj75bM66oVU++0+GpAfGO87akuWskuoOBnlafLnXOCO2POi3ugnjztw7Ge0HQgFv/a7JFpAto4ubj2tQWHetF0XWKqc7fJhQQ6WdzeeFqqUGFttw1eS9jMgW2m+NFjRJ9vHpnriXf2A2t+Ff5tQVmEkQSKiZ7oTGf/ls8M/1uwvIHPl2fxXrjAvnMJXzFqe0TgdfcrTo4TFt/j/WbcXCifmB5fMVijh660Uu9lP6YLnx0cSP8YAuxygSKwjmRs1jPGaorGf9nEklM3kfS7JnpTKEQY+mpWrAMawvCpe51gvZmt1R3SuNxVGy6yIK2cNecFs4IB82e2vAqO0E8UvPbBqR6ak5N8rAwBhMshUr5MfYbbifs2CM1B2Zn1ujZqd2K3BUbCbXkP4sbcQhwwfbDWY5ZOWanNP3OelnzpRbVn36rUANLuzak5Kq6J6yKHrXMGVOkqZtitixH+IkXhTU0Q2KG4mH3jQHxZI4Cetz//j8igEPAU1AyGtONv7fS6JgxC84zfzb2htof2u9DVpC9CHjeAqFt5SWptaNxkGtHtojfGH2sEAR1jnAH0nn4+7wxBIyW6yg6xj1GSroGnK8OGwOy5r7AdFL3s2DI5Y5TcQpG03T9GSl55bdlVdMSMlUOMLC0k0pI8W3Y2u/ZDPcsnL0rRidB8fR2I4rsm2qMGYnJgWQ+PkD/2yGKX3yBkKREvmp5ewr6c6PBM2q+1RMUDdXjSSclBEoC0YM5pqEKrZs8xuxEifP5Juc8hvcniprB4HeD7FggHKjehNDcTYoM2M"
`endif