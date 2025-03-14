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


`timescale 1 ns / 1 ns
module altera_s10_user_rst_clkgate (
	output logic ninit_done
);

	localparam USER_RESET_DELAY = 0;
	
	initial begin
		#0 ninit_done = 1;
		#1 ninit_done = 0;
	end
					
	
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "MoT3sSDnP/Dlpi3kfj5FQ7eMtBvFaTYciwgmSM0iGFGI8yrdjf8fjOzey0LySWPn6EapPOkKDXt6AFlg8UXm2hZ8460X5Z0OXM9KxHagg8l+D1m1zPDEPsecYwRXQo0abxrlTNXLBo81W1USGp9h1c2xhvhbyVbDjNZl8SsPr5lR2gm1vEt+fLVLKW6JIALjU3AVg1R5ajAnQoM/L2MGJJ8/1DrzxJuYqv2q7pbJp1tMqx/PpGaZ7R3eMQqZjGSd4IHHLqKnyF7yDAm6C1Ws8uzptx8g0B7/t+LYdkx/eEtj94M764fHPqJmz57NAm6EtEF5s8X95zpA6eH6OfSXAJf3e1WC23SqGzH8r50pEAikbpCdw63jWqJzjBL+HF23r1CRPFxjLhs1JaUOpvdROF3IojEldSsHQAY97y53KfKC8CmfSvK1QSUal0KCtZTRUyOvPvFZ2lgUPFd4jrI3CFR0Qg3E+kSJfodzY7U4l0MnMYL1wGh/4c1wxxeCbenoO3FAW7UJaAr4wTpNPdkCdT+JtUorsyeOlZe3wouvAQj5gWT51dij/PSB+eHcUegtI5bfDe0QNEZsgivZWeS+1yh3F76o6XOC71XmlLS4vrspLb7xPNCopAMd2ZLGXmKa2TPHGa9tLa97zsY1TgEPRzTmdRpb0HTs7PzETyvzIZN1sm1to1j3kSARc+fZk0inb6jN6cUA8sJaZ3bZFe3FmPBlN6B1veL5aGfyoPKYikVuLNhlJKpaFV6aP0IyKOLMGfUWb6gYIRK9+EVeC0ZyMjSLCqW+qn8k58/t48V+ecoZ6yv0kuL39uhTh5X3uK8U5w1xKD1HxXMXFv4FLQWibZ4UDZfXcuP9qWG+SfmbVMT9uMAsNT7ZMc7uIW6RCSBxkkGcT3VDhukwkpbS4HReEMdVl9Ys6rvMyGeW3kHD5FLlCqkoDv7fj5kKWbk+eztsjV+a76hX7Kov2Hp60/hxNjFV+NkNu03SvQHuARphJnL5qeJYWNf6ARi9GlRYDhfu"
`endif