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



// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.




// -------------------------------------------------------
// Merlin Router
//
// Asserts the appropriate one-hot encoded channel based on 
// the dest id.
//
// -------------------------------------------------------

`timescale 1 ns / 1 ns

// ------------------------------------------
// Generation parameters:
//    decoder_type            1 (dest id decoder)
//    default_channel         0
//    default_destid          0
//    default_rd_channel      -1
//    default_wr_channel      -1
//    has_default_slave       0
//    memory_aliasing_decode  0
//    output_name             pcie_ed_altera_merlin_router_1921_sv2vwxi
//    pkt_addr_h              1215
//    pkt_addr_l              1152
//    pkt_dest_id_h           1244
//    pkt_dest_id_l           1244
//    pkt_protection_h        1248
//    pkt_protection_l        1246
//    pkt_trans_read          1219
//    pkt_trans_write         1218
//    slaves_info             0:1:0x0:0x0:both:1:0:0:1
//    st_channel_w            1
//    st_data_w               1267
// ------------------------------------------

module pcie_ed_altera_merlin_router_1921_sv2vwxi_default_decode
  #(
     parameter DEFAULT_CHANNEL = 0,
               DEFAULT_WR_CHANNEL = -1,
               DEFAULT_RD_CHANNEL = -1,
               DEFAULT_DESTID = 0 
   )
  (output [1244 - 1244 : 0] default_destination_id,
   output [1-1 : 0] default_wr_channel,
   output [1-1 : 0] default_rd_channel,
   output [1-1 : 0] default_src_channel
  );

  assign default_destination_id = 
    DEFAULT_DESTID[1244 - 1244 : 0];

  generate
    if (DEFAULT_CHANNEL == -1) begin : no_default_channel_assignment
      assign default_src_channel = '0;
    end
    else begin : default_channel_assignment
      assign default_src_channel = 1'b1 << DEFAULT_CHANNEL;
    end
  endgenerate

  generate
    if (DEFAULT_RD_CHANNEL == -1) begin : no_default_rw_channel_assignment
      assign default_wr_channel = '0;
      assign default_rd_channel = '0;
    end
    else begin : default_rw_channel_assignment
      assign default_wr_channel = 1'b1 << DEFAULT_WR_CHANNEL;
      assign default_rd_channel = 1'b1 << DEFAULT_RD_CHANNEL;
    end
  endgenerate

endmodule


module pcie_ed_altera_merlin_router_1921_sv2vwxi
(
    // -------------------
    // Clock & Reset
    // -------------------
    input clk,
    input reset,

    // -------------------
    // Command Sink (Input)
    // -------------------
    input                       sink_valid,
    input  [1267-1 : 0]    sink_data,
    input                       sink_startofpacket,
    input                       sink_endofpacket,
    output                      sink_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output                          src_valid,
    output reg [1267-1    : 0] src_data,
    output reg [1-1 : 0] src_channel,
    output                          src_startofpacket,
    output                          src_endofpacket,
    input                           src_ready
);

    // -------------------------------------------------------
    // Local parameters and variables
    // -------------------------------------------------------
    localparam PKT_ADDR_H = 1215;
    localparam PKT_ADDR_L = 1152;
    localparam PKT_DEST_ID_H = 1244;
    localparam PKT_DEST_ID_L = 1244;
    localparam PKT_PROTECTION_H = 1248;
    localparam PKT_PROTECTION_L = 1246;
    localparam ST_DATA_W = 1267;
    localparam ST_CHANNEL_W = 1;
    localparam DECODER_TYPE = 1;

    localparam PKT_TRANS_WRITE = 1218;
    localparam PKT_TRANS_READ  = 1219;

    localparam PKT_ADDR_W = PKT_ADDR_H-PKT_ADDR_L + 1;
    localparam PKT_DEST_ID_W = PKT_DEST_ID_H-PKT_DEST_ID_L + 1;



    // -------------------------------------------------------
    // Figure out the number of bits to mask off for each slave span
    // during address decoding
    // -------------------------------------------------------
    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 64'h0;
    localparam RANGE_ADDR_WIDTH = log2ceil(ADDR_RANGE);
    localparam OPTIMIZED_ADDR_H = (RANGE_ADDR_WIDTH > PKT_ADDR_W) ||
                                  (RANGE_ADDR_WIDTH == 0) ?
                                        PKT_ADDR_H :
                                        PKT_ADDR_L + RANGE_ADDR_WIDTH - 1;

    localparam REAL_ADDRESS_RANGE = OPTIMIZED_ADDR_H - PKT_ADDR_L;

    reg [PKT_DEST_ID_W-1 : 0] destid;

    // -------------------------------------------------------
    // Pass almost everything through, untouched
    // -------------------------------------------------------
    assign sink_ready        = src_ready;
    assign src_valid         = sink_valid;
    assign src_startofpacket = sink_startofpacket;
    assign src_endofpacket   = sink_endofpacket;
    wire [1-1 : 0] default_src_channel;






    pcie_ed_altera_merlin_router_1921_sv2vwxi_default_decode the_default_decode(
      .default_destination_id (),
      .default_wr_channel   (),
      .default_rd_channel   (),
      .default_src_channel  (default_src_channel)
    );

    always @* begin
        src_data    = sink_data;
        src_channel = default_src_channel;

        // --------------------------------------------------
        // DestinationID Decoder
        // Sets the channel based on the destination ID.
        // --------------------------------------------------
        destid      = sink_data[PKT_DEST_ID_H : PKT_DEST_ID_L];



        if (destid == 0 ) begin
            src_channel = 1'b1;
        end

    end


    // --------------------------------------------------
    // Ceil(log2()) function
    // It's the 21st century. Consider using $clog2().
    // --------------------------------------------------
    function integer log2ceil;
        input reg[65:0] val;
        reg [65:0] i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction

endmodule


`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "DcjSv4cazWNFeTq2LDzhR8VVA2vsU+D2FLr5cau2M2bJ+ymOMJzu0j4X+D7sDofwwnGT3dC9uPfUfqUyT+1JDqgoqF4+Hm1+DbOqZuomBxMc/3ubRV7jR7LhS90CAIiftZSupMkt7Z6NB7tsmbvAu3Uqtxlo+Ag4QRIgi49yVFsS2wB30qw4GeL5di6t6OjbvWcjLtKHJMZ/Vew3QCsc9aW8Cap9TcP/4lTkJB8MFThHTL/pOWHvoyBMYgCpxTp1c5CkUvh5ACvGqxx64ZcprFiH85s8rPy3INRE/8CaYGbShviJcujTUfcOQehdeHpfEW7tiRrV+xgN3VHNMNXtSvavkprrZxNrUVadYOepBxsG+alkrFUxcG7Sno+zq67JHM1+zAfl3cjiq5m9Byl1w7hsRVU60bO7RCRG10FZFu9ZfBm4xhqWaHtHcwvxreXifqI1jVyDTh0+7af6Vd1a2GiXrrd13f2TFn1YLrN49kjIi6KGdTD49U2dEhTonGLlSXl3lz/CG3u2bX7mRhyo30KVQeWHiBf5W8wiBWIiJoDkPbnnjMeadkk0CajX4hGyTHypHlZUaTnRFpAewKJZUx5KoONPVxHoq5xM33xu+Zm/+7BBEyaJOlGNmINk+H+xzn9eSPXpzOV+aOGEjd73+YCqSNM+ztorA0pA6bVC7ybauN0FwkRIH4fmCZMjjZ7irnYBYfm/oOkltSg+Z5OjvOwfo0y/mV5L+da1jC85MICH9xJacJQZW7k154pfxGNtiCCiLCx2WmmvnBOTBlC23gF8PTDHSYk0bK5F/ZZ0nvYn4oosjCCpa+9tVlkS+F6zPNDPg7TxOQdVKF43sjmGhC12WygPFSvC0wUN0EJtDLaGDMWAjoyDp8u8yddWk6mxju3He+DRBtmrSD13O8Lt0mfrFh1vtnrXoGRizFkLAgiw8BRRM4kfQAyMC/P1NjzhKCi8YfBejoSUfBaJ6xrr6knTa9vRg4l6XZNMWMm2bawYVelkuOwhPZDCjaPz7a1e"
`endif