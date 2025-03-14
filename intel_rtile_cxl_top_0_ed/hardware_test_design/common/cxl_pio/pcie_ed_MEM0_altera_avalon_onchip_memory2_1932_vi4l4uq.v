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

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 13469 16735 16788 

module pcie_ed_MEM0_altera_avalon_onchip_memory2_1932_vi4l4uq (
                                                                // inputs:
                                                                 address,
                                                                 byteenable,
                                                                 chipselect,
                                                                 clk,
                                                                 clken,
                                                                 freeze,
                                                                 reset,
                                                                 reset_req,
                                                                 write,
                                                                 writedata,

                                                                // outputs:
                                                                 readdata
                                                              )
;

//  parameter INIT_FILE = "pcie_ed_MEM0_MEM0.hex";


  output  [1023: 0] readdata;
  input   [  7: 0] address;
  input   [127: 0] byteenable;
  input            chipselect;
  input            clk;
  input            clken;
  input            freeze;
  input            reset;
  input            reset_req;
  input            write;
  input   [1023: 0] writedata;


wire             clocken0;
wire             freeze_dummy_signal;
reg     [1023: 0] readdata;
wire    [1023: 0] readdata_ram;
wire             reset_dummy_signal;
wire             wren;
  assign reset_dummy_signal = reset;
  assign freeze_dummy_signal = freeze;
  always @(posedge clk)
    begin
      if (clken)
          readdata <= readdata_ram;
    end


  assign wren = chipselect & write;
  assign clocken0 = clken & ~reset_req;
  altsyncram the_altsyncram
    (
      .address_a (address),
      .byteena_a (byteenable),
      .clock0 (clk),
      .clocken0 (clocken0),
      .data_a (writedata),
      .q_a (readdata_ram),
      .wren_a (wren)
    );

  defparam the_altsyncram.byte_size = 8,
//           the_altsyncram.init_file = INIT_FILE,
           the_altsyncram.lpm_type = "altsyncram",
           the_altsyncram.maximum_depth = 256,
           the_altsyncram.numwords_a = 256,
           the_altsyncram.operation_mode = "SINGLE_PORT",
           the_altsyncram.outdata_reg_a = "UNREGISTERED",
           the_altsyncram.ram_block_type = "AUTO",
           the_altsyncram.read_during_write_mode_mixed_ports = "DONT_CARE",
           the_altsyncram.read_during_write_mode_port_a = "DONT_CARE",
           the_altsyncram.width_a = 1024,
           the_altsyncram.width_byteena_a = 128,
           the_altsyncram.widthad_a = 8;

  //s1, which is an e_avalon_slave
  //s2, which is an e_avalon_slave

endmodule

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "DcjSv4cazWNFeTq2LDzhR8VVA2vsU+D2FLr5cau2M2bJ+ymOMJzu0j4X+D7sDofwwnGT3dC9uPfUfqUyT+1JDqgoqF4+Hm1+DbOqZuomBxMc/3ubRV7jR7LhS90CAIiftZSupMkt7Z6NB7tsmbvAu3Uqtxlo+Ag4QRIgi49yVFsS2wB30qw4GeL5di6t6OjbvWcjLtKHJMZ/Vew3QCsc9aW8Cap9TcP/4lTkJB8MFTgjvcua+ttVDyuUZ0FNnWb2fFu8iBke1TiINTZswUjF8EIzzSTD38jl6bXxYnSAFxo2vfkAVhifUzCs/xddGSyRrs0s9BF4rthctJrFJ6G1D22YaC768jaxkWNSrLGgYZMd0EFSM2G/j9DykdbrTZzNp5lbv8p4RBuII2jZZFBrzMoF3uPcwh4U40m57eLEMnaqH6TLtLXj7zg46IWvgZYD9heMaIynysvtbRxYoX8Usv/qCDUJBaKwqcx+Quc319LjfIZVxmFZdOJ3O3naVmh5QJoSU5gTcXoh5RlcAiNv41DVokKmfgrUkyNNoIPUwz7Yy2VWpYBd2d/YZwg1UvqNnHyLrWFgem3sEur/UahrQ+xih/7vmrNycnmszB2m897ocp7/9lFb1EM5pn3EK1VNTLJfQVCAFWTyHc0K5hTsxNdLvRMyLd6cDFkOkFm35IaOazK0Fq2ySOL/VqXJWfEpAcMkw7PpiMwQxqw6vD8sTDw8e1SIm0b1rQzDS7pLyiv5ED7IKJ8AJsWa7eeW6DAyzMDDXPG0Tx5P17qBu3ad1MSZ5tE1R1V596Vuu2xx1ufaOl594kBUwSf1GzWmOxE3n0w9iz/28stWhlD44c01ASGQqU1f+chhMcSrZAUJJLHWH71YGvmLVBm3u+h8UNcerjPtshh0d6OXYW55znrr8Kb0yDu6IfmGoZF5LT/n/KwF/dMrQRD074JmSQPed2VLWa+Su3ySTI2P+J29PXbdK1j+VrsSlrKNZiB8ZdZ+IGfe7VGWsJide0bKaD7vF4us"
`endif