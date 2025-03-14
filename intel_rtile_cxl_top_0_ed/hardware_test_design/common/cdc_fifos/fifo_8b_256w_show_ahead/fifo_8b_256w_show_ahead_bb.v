module fifo_8b_256w_show_ahead (
		input  wire [7:0] data,  //  fifo_input.datain
		input  wire       wrreq, //            .wrreq
		input  wire       rdreq, //            .rdreq
		input  wire       clock, //            .clk
		input  wire       aclr,  //            .aclr
		output wire [7:0] q,     // fifo_output.dataout
		output wire [7:0] usedw, //            .usedw
		output wire       full,  //            .full
		output wire       empty  //            .empty
	);
endmodule

