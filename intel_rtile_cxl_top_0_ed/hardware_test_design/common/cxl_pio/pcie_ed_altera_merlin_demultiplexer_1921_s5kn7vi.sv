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


// -------------------------------------
// Merlin Demultiplexer
//
// Asserts valid on the appropriate output
// given a one-hot channel signal.
// -------------------------------------

`timescale 1 ns / 1 ns

// ------------------------------------------
// Generation parameters:
//   output_name:         pcie_ed_altera_merlin_demultiplexer_1921_s5kn7vi
//   ST_DATA_W:           1267
//   ST_CHANNEL_W:        1
//   NUM_OUTPUTS:         1
//   VALID_WIDTH:         1
// ------------------------------------------

//------------------------------------------
// Message Supression Used
// QIS Warnings
// 15610 - Warning: Design contains x input pin(s) that do not drive logic
//------------------------------------------

// altera message_off 16753
module pcie_ed_altera_merlin_demultiplexer_1921_s5kn7vi
(
    // -------------------
    // Sink
    // -------------------
    input  [1-1      : 0]   sink_valid,
    input  [1267-1    : 0]   sink_data, // ST_DATA_W=1267
    input  [1-1 : 0]   sink_channel, // ST_CHANNEL_W=1
    input                         sink_startofpacket,
    input                         sink_endofpacket,
    output                        sink_ready,

    // -------------------
    // Sources 
    // -------------------
    output reg                      src0_valid,
    output reg [1267-1    : 0] src0_data, // ST_DATA_W=1267
    output reg [1-1 : 0] src0_channel, // ST_CHANNEL_W=1
    output reg                      src0_startofpacket,
    output reg                      src0_endofpacket,
    input                           src0_ready,


    // -------------------
    // Clock & Reset
    // -------------------
    (*altera_attribute = "-name MESSAGE_DISABLE 15610" *) // setting message suppression on clk
    input clk,
    (*altera_attribute = "-name MESSAGE_DISABLE 15610" *) // setting message suppression on reset
    input reset

);

    localparam NUM_OUTPUTS = 1;
    wire [NUM_OUTPUTS - 1 : 0] ready_vector;

    // -------------------
    // Demux
    // -------------------
    always @* begin
        src0_data          = sink_data;
        src0_startofpacket = sink_startofpacket;
        src0_endofpacket   = sink_endofpacket;
        src0_channel       = sink_channel >> NUM_OUTPUTS;

        src0_valid         = sink_channel[0] && sink_valid;

    end

    // -------------------
    // Backpressure
    // -------------------
    assign ready_vector[0] = src0_ready;

    assign sink_ready = |(sink_channel & ready_vector);

endmodule

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "DcjSv4cazWNFeTq2LDzhR8VVA2vsU+D2FLr5cau2M2bJ+ymOMJzu0j4X+D7sDofwwnGT3dC9uPfUfqUyT+1JDqgoqF4+Hm1+DbOqZuomBxMc/3ubRV7jR7LhS90CAIiftZSupMkt7Z6NB7tsmbvAu3Uqtxlo+Ag4QRIgi49yVFsS2wB30qw4GeL5di6t6OjbvWcjLtKHJMZ/Vew3QCsc9aW8Cap9TcP/4lTkJB8MFTiqcPJcgT142PvrFuyMwJWcOHoixacjYclEclcOs/R/zHCRMTNdQCNM5f2623RycFBGJ2qM5eLtGGBM0AK+3b/Bt1tO3bas6qWKsJH7cgW9wHAD11dj2XaaKs4fXfUIb0YpHvJqUZfV4D91ctZWC7n1XY7Wo1ruNs8Ql8jkJXlENBEEurlVWrpau9Lj+R3cXi9BEjQ8ob0kxiiLmztF+MP+qnA5+TaiPrJhLZKK0jXX8TMAZFrD0e29YcN54HCHzyKiDd+Fkdf+AExjzaZcVTydFGucDzkj/rsfE7pTIBESp+/Er8Q5mhv3tsvm+huUckYv/Mz3KD0Gl26qh2G3DWIuG4sqRirXXTtKp/eiX+6XmHI+4/i3j8gy50d5v0kuePfwTgIfLj2u50kKz0e4WLpQfNJIZgqBOTYsjsv4d77CxxDYLdmgJjPBe8uiErqB23zzgYadOrIFOnLj+seqopSKSQBuXzPRBdlJ/TJqPtiLp1mtkmJyhj4h+NEDfI1HYVvDesNI7G1hG/jJ9D6/u3+PvmQBRmWBSnPZWjRJqjFe33BYQMYDEO1+TcakoC78K8ZBNG0J8Q7YcrrhZu9YxFi2hQpruVnq+vLxdGUQsN1lGd+QOcESyTXr6IAkAkfVdkBVMT8XpgXPVqBi1DdaQ6OJWIHjE5I0pzIFga1xeKxS1D+9AW+oXkXtz2JG+IBMZPw6mg4CdA4dt0IbTIDlW3qCY6m4bBpd96BARDRV20IW6+KryJjI2+NJanQc+pKX9l35eewslX2znKBfMSIFV8Ay"
`endif