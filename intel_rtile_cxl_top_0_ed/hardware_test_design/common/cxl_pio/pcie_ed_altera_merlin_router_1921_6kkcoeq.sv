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
// the address.
//
// Also sets the binary-encoded destination id.
// -------------------------------------------------------

`timescale 1 ns / 1 ns

// ------------------------------------------
// Generation parameters:
//    decoder_type            0 (address decoder)
//    default_channel         0
//    default_destid          0
//    default_rd_channel      -1
//    default_wr_channel      -1
//    has_default_slave       0
//    memory_aliasing_decode  0
//    output_name             pcie_ed_altera_merlin_router_1921_6kkcoeq
//    pkt_addr_h              1215
//    pkt_addr_l              1152
//    pkt_dest_id_h           1244
//    pkt_dest_id_l           1244
//    pkt_protection_h        1248
//    pkt_protection_l        1246
//    pkt_trans_read          1219
//    pkt_trans_write         1218
//    slaves_info             0:1:0x0:0x8000:both:1:0:0:1
//    st_channel_w            1
//    st_data_w               1267
// ------------------------------------------

module pcie_ed_altera_merlin_router_1921_6kkcoeq_default_decode
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


module pcie_ed_altera_merlin_router_1921_6kkcoeq
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
    localparam DECODER_TYPE = 0;

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
    localparam ADDR_RANGE = 64'h8000;
    localparam RANGE_ADDR_WIDTH = log2ceil(ADDR_RANGE);
    localparam OPTIMIZED_ADDR_H = (RANGE_ADDR_WIDTH > PKT_ADDR_W) ||
                                  (RANGE_ADDR_WIDTH == 0) ?
                                        PKT_ADDR_H :
                                        PKT_ADDR_L + RANGE_ADDR_WIDTH - 1;

    localparam REAL_ADDRESS_RANGE = OPTIMIZED_ADDR_H - PKT_ADDR_L;


    // -------------------------------------------------------
    // Pass almost everything through, untouched
    // -------------------------------------------------------
    assign sink_ready        = src_ready;
    assign src_valid         = sink_valid;
    assign src_startofpacket = sink_startofpacket;
    assign src_endofpacket   = sink_endofpacket;
    wire [PKT_DEST_ID_W-1:0] default_destid;
    wire [1-1 : 0] default_src_channel;






    pcie_ed_altera_merlin_router_1921_6kkcoeq_default_decode the_default_decode(
      .default_destination_id (default_destid),
      .default_wr_channel   (),
      .default_rd_channel   (),
      .default_src_channel  (default_src_channel)
    );

    always @* begin
        src_data    = sink_data;
        src_channel = default_src_channel;
        src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = default_destid;

        // --------------------------------------------------
        // Address Decoder
        // Sets the channel and destination ID based on the address
        // --------------------------------------------------
           
         
          // slave 0: [0x0, 0x8000)
          src_channel = 1'b1;
          src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 0;
	     
        
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
`pragma questa_oem_00 "DcjSv4cazWNFeTq2LDzhR8VVA2vsU+D2FLr5cau2M2bJ+ymOMJzu0j4X+D7sDofwwnGT3dC9uPfUfqUyT+1JDqgoqF4+Hm1+DbOqZuomBxMc/3ubRV7jR7LhS90CAIiftZSupMkt7Z6NB7tsmbvAu3Uqtxlo+Ag4QRIgi49yVFsS2wB30qw4GeL5di6t6OjbvWcjLtKHJMZ/Vew3QCsc9aW8Cap9TcP/4lTkJB8MFThXqPw84tPggIe6jczb1Y0VD2Upz00rGwawWoBlAWH6Uo7BTHDjUfCiShfsDyrhtDRv4D8tm8ysGJlb3ezIl9aYImWUdxUHgTBatg2O9WDLcMi1+szi6tQRY8v2NoKu2EdSh6KYY1gvxy3fL56upXbfGw/C9rWHrS5AgdiyssbC5TcpVa9JEncSK02WjgCQTnlYm2WsMIGR6qCLxf9NJ/mfvGH0uO6auniNbJH/9rV6ap7KRpdpC3Ec8dmos66UoC9UKPJgArVJ1FEzGHadFwjGfS6g++qiNTp23L+Oa8LU+gx2snZko1o5pFJfCeou4i0mqSar8ChHjTCiUQ8FWYwHlTrLD871K0P5u6LtbQidoIOSpUvfJ15I900KDNccZ6g429V/mHlFq+UOM/VM6i2iqEGdrDzVEcALzg2vxOUnCeQyUMqVOktuSZY2LgUhgxtqz52IYJS6gIqQ0vFSngvGAFqMOwQOf89jBqmZzRCrkCM2GZP0YfnIbpoq7jIsuGuHLYY1dBPgxF+mCV2f5LDCa2jJQ5CoMoN5S6Fxa5vuaxNu0hHjcgIz7AntgAMnMYY8qzG8yiuB8cYC23YkAESsnobvWaXrnPxz3DnGXKxpV50V1V8aTVnvbCA6piBGrUEgIAYpp3Pe1bEEa5tcdbIRwe9hb+qXTpDBeTiof94oq8d2nyEmnmPSUyn6dprZhiAUP8drxkfLZO5qOa3OIvOrSvu/Ld2qqxS0s4gC22LfvXzZzF47xIvrgtV8jY2Iun5GEoX6bR80aV2DIUqSgxdf"
`endif