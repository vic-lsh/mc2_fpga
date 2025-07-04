// cfg_to_iosf_fifo_vcd.v

// Generated using ACDS version 24.1 115

`timescale 1 ps / 1 ps
module cfg_to_iosf_fifo_vcd (
		input  wire [68:0] data,    //  fifo_input.datain
		input  wire        wrreq,   //            .wrreq
		input  wire        rdreq,   //            .rdreq
		input  wire        wrclk,   //            .wrclk
		input  wire        rdclk,   //            .rdclk
		input  wire        aclr,    //            .aclr
		output wire [68:0] q,       // fifo_output.dataout
		output wire        rdempty, //            .rdempty
		output wire        wrfull   //            .wrfull
	);

	intel_rtile_cxl_top_cxltyp3_ed_fifo_1927_qmktr7y cfg_to_iosf_fifo_vcd (
		.data    (data),    //   input,  width = 69,  fifo_input.datain
		.wrreq   (wrreq),   //   input,   width = 1,            .wrreq
		.rdreq   (rdreq),   //   input,   width = 1,            .rdreq
		.wrclk   (wrclk),   //   input,   width = 1,            .wrclk
		.rdclk   (rdclk),   //   input,   width = 1,            .rdclk
		.aclr    (aclr),    //   input,   width = 1,            .aclr
		.q       (q),       //  output,  width = 69, fifo_output.dataout
		.rdempty (rdempty), //  output,   width = 1,            .rdempty
		.wrfull  (wrfull)   //  output,   width = 1,            .wrfull
	);

endmodule
