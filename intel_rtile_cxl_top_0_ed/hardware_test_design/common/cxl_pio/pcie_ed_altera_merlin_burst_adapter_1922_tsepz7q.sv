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


`timescale 1 ns / 1 ns

// -----------------------------------------------------
// Top level for the burst adapter. This selects the
// implementation for the adapter, based on the
// parameterization.
// -----------------------------------------------------
module pcie_ed_altera_merlin_burst_adapter_1922_tsepz7q 
#(
    parameter 
    // Indicates the implementation to instantiate:
    //    "13.1" means the slow, inexpensive generic burst converter.
    //    "new" means the fast, expensive per-burst converter.
    ADAPTER_VERSION             = "13.1",

    // Indicates if this adapter needs to support read bursts
    // (almost always true).
    COMPRESSED_READ_SUPPORT     = 1,

    // Standard Merlin packet parameters that indicate
    // field position within the packet
    PKT_BEGIN_BURST             = 81,
    PKT_ADDR_H                  = 79,
    PKT_ADDR_L                  = 48,
    PKT_BYTE_CNT_H              = 5,
    PKT_BYTE_CNT_L              = 0,
    PKT_BURSTWRAP_H             = 11,
    PKT_BURSTWRAP_L             = 6,
    PKT_TRANS_COMPRESSED_READ   = 14,
    PKT_TRANS_WRITE             = 13,
    PKT_TRANS_READ              = 12,
    PKT_BYTEEN_H                = 83,
    PKT_BYTEEN_L                = 80,
    PKT_BURST_TYPE_H            = 88,
    PKT_BURST_TYPE_L            = 87,
    PKT_BURST_SIZE_H            = 86,
    PKT_BURST_SIZE_L            = 84,
    ST_DATA_W                   = 89,
    ST_CHANNEL_W                = 8,

    // Component-specific parameters. Explained
    // in the implementation levels
    IN_NARROW_SIZE              = 0,
    NO_WRAP_SUPPORT             = 0,
    INCOMPLETE_WRAP_SUPPORT     = 1,
    BURSTWRAP_CONST_MASK        = 0,
    BURSTWRAP_CONST_VALUE       = 2147483647, //equivalent to {31{1'b1}} -- ncsim does not like negative values (-1), or the replication format

    OUT_NARROW_SIZE             = 0,
    OUT_FIXED                   = 0,
    OUT_COMPLETE_WRAP           = 0,
    BYTEENABLE_SYNTHESIS        = 0,
    PIPE_INPUTS                 = 0,

    OUT_BYTE_CNT_H              = 5,
    OUT_BURSTWRAP_H             = 11,
    SYNC_RESET                  = 0
)
(
    input                            clk,
    input                            reset,

    // -------------------
    // Command Sink (Input)
    // -------------------
    input                            sink0_valid,
    input [ST_DATA_W-1 : 0]          sink0_data,
    input [ST_CHANNEL_W-1 : 0]       sink0_channel,
    input                            sink0_startofpacket,
    input                            sink0_endofpacket,
    output reg                       sink0_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output wire                      source0_valid,
    output wire [ST_DATA_W-1 : 0]    source0_data,
    output wire [ST_CHANNEL_W-1 : 0] source0_channel,
    output wire                      source0_startofpacket,
    output wire                      source0_endofpacket,
    input                            source0_ready
);

    localparam PKT_BURSTWRAP_W = PKT_BURSTWRAP_H - PKT_BURSTWRAP_L + 1;

    generate if (COMPRESSED_READ_SUPPORT == 0) begin : altera_merlin_burst_adapter_uncompressed_only

        // -------------------------------------------------------------------
        // The reduced version of the adapter is only meant to be used on
        // non-bursting wide to narrow links.
        // -------------------------------------------------------------------
        altera_merlin_burst_adapter_uncompressed_only #(
            .PKT_BYTE_CNT_H            (PKT_BYTE_CNT_H),
            .PKT_BYTE_CNT_L            (PKT_BYTE_CNT_L),
            .PKT_BYTEEN_H              (PKT_BYTEEN_H),
            .PKT_BYTEEN_L              (PKT_BYTEEN_L),
            .ST_DATA_W                 (ST_DATA_W),
            .ST_CHANNEL_W              (ST_CHANNEL_W)
        ) burst_adapter (
            .clk                   (clk),
            .reset                 (reset),
            .sink0_valid           (sink0_valid),
            .sink0_data            (sink0_data),
            .sink0_channel         (sink0_channel),
            .sink0_startofpacket   (sink0_startofpacket),
            .sink0_endofpacket     (sink0_endofpacket),
            .sink0_ready           (sink0_ready),
            .source0_valid         (source0_valid),
            .source0_data          (source0_data),
            .source0_channel       (source0_channel),
            .source0_startofpacket (source0_startofpacket),
            .source0_endofpacket   (source0_endofpacket),
            .source0_ready         (source0_ready)
        );

    end
    else if (ADAPTER_VERSION == "13.1") begin : altera_merlin_burst_adapter_13_1

        // -----------------------------------------------------
        // This is the generic converter implementation, which attempts
        // to convert all burst types with a generalized conversion
        // function. This results in low area, but low fmax.
        // -----------------------------------------------------
        altera_merlin_burst_adapter_13_1 #(
            .PKT_BEGIN_BURST           (PKT_BEGIN_BURST),
            .PKT_ADDR_H                (PKT_ADDR_H ),
            .PKT_ADDR_L                (PKT_ADDR_L),
            .PKT_BYTE_CNT_H            (PKT_BYTE_CNT_H),
            .PKT_BYTE_CNT_L            (PKT_BYTE_CNT_L ),
            .PKT_BURSTWRAP_H           (PKT_BURSTWRAP_H),
            .PKT_BURSTWRAP_L           (PKT_BURSTWRAP_L),
            .PKT_TRANS_COMPRESSED_READ (PKT_TRANS_COMPRESSED_READ),
            .PKT_TRANS_WRITE           (PKT_TRANS_WRITE),
            .PKT_TRANS_READ            (PKT_TRANS_READ),
            .PKT_BYTEEN_H              (PKT_BYTEEN_H),
            .PKT_BYTEEN_L              (PKT_BYTEEN_L),
            .PKT_BURST_TYPE_H          (PKT_BURST_TYPE_H),
            .PKT_BURST_TYPE_L          (PKT_BURST_TYPE_L),
            .PKT_BURST_SIZE_H          (PKT_BURST_SIZE_H),
            .PKT_BURST_SIZE_L          (PKT_BURST_SIZE_L),
            .IN_NARROW_SIZE            (IN_NARROW_SIZE),
            .BYTEENABLE_SYNTHESIS      (BYTEENABLE_SYNTHESIS),
            .OUT_NARROW_SIZE           (OUT_NARROW_SIZE),
            .OUT_FIXED                 (OUT_FIXED),
            .OUT_COMPLETE_WRAP         (OUT_COMPLETE_WRAP),
            .ST_DATA_W                 (ST_DATA_W),
            .ST_CHANNEL_W              (ST_CHANNEL_W),
            .BURSTWRAP_CONST_MASK      (BURSTWRAP_CONST_MASK),
            .BURSTWRAP_CONST_VALUE     (BURSTWRAP_CONST_VALUE),
            .PIPE_INPUTS               (PIPE_INPUTS),
            .NO_WRAP_SUPPORT           (NO_WRAP_SUPPORT),
            .OUT_BYTE_CNT_H            (OUT_BYTE_CNT_H),
            .OUT_BURSTWRAP_H           (OUT_BURSTWRAP_H),
            .SYNC_RESET                (SYNC_RESET)
        ) burst_adapter (
            .clk                   (clk),
            .reset                 (reset),
            .sink0_valid           (sink0_valid),
            .sink0_data            (sink0_data),
            .sink0_channel         (sink0_channel),
            .sink0_startofpacket   (sink0_startofpacket),
            .sink0_endofpacket     (sink0_endofpacket),
            .sink0_ready           (sink0_ready),
            .source0_valid         (source0_valid),
            .source0_data          (source0_data),
            .source0_channel       (source0_channel),
            .source0_startofpacket (source0_startofpacket),
            .source0_endofpacket   (source0_endofpacket),
            .source0_ready         (source0_ready)
        );

    end
    else begin : altera_merlin_burst_adapter_new

        wire                         sink0_pipe_valid;
        wire [ST_DATA_W    - 1 : 0]  sink0_pipe_data;
        wire [ST_CHANNEL_W - 1 : 0]  sink0_pipe_channel;
        wire                         sink0_pipe_sop;
        wire                         sink0_pipe_eop;
        wire                         sink0_pipe_ready;

        // -----------------------------------------------------
        // This is the per-burst-type converter implementation. This attempts
        // to convert bursts with specialized functions for each burst
        // type. This typically results in higher area, but higher fmax.
        // -----------------------------------------------------
        altera_merlin_burst_adapter_new #(
            .PKT_BEGIN_BURST           (PKT_BEGIN_BURST),
            .PKT_ADDR_H                (PKT_ADDR_H ),
            .PKT_ADDR_L                (PKT_ADDR_L),
            .PKT_BYTE_CNT_H            (PKT_BYTE_CNT_H),
            .PKT_BYTE_CNT_L            (PKT_BYTE_CNT_L ),
            .PKT_BURSTWRAP_H           (PKT_BURSTWRAP_H),
            .PKT_BURSTWRAP_L           (PKT_BURSTWRAP_L),
            .PKT_TRANS_COMPRESSED_READ (PKT_TRANS_COMPRESSED_READ),
            .PKT_TRANS_WRITE           (PKT_TRANS_WRITE),
            .PKT_TRANS_READ            (PKT_TRANS_READ),
            .PKT_BYTEEN_H              (PKT_BYTEEN_H),
            .PKT_BYTEEN_L              (PKT_BYTEEN_L),
            .PKT_BURST_TYPE_H          (PKT_BURST_TYPE_H),
            .PKT_BURST_TYPE_L          (PKT_BURST_TYPE_L),
            .PKT_BURST_SIZE_H          (PKT_BURST_SIZE_H),
            .PKT_BURST_SIZE_L          (PKT_BURST_SIZE_L),
            .IN_NARROW_SIZE            (IN_NARROW_SIZE),
            .BYTEENABLE_SYNTHESIS      (BYTEENABLE_SYNTHESIS),
            .OUT_NARROW_SIZE           (OUT_NARROW_SIZE),
            .OUT_FIXED                 (OUT_FIXED),
            .OUT_COMPLETE_WRAP         (OUT_COMPLETE_WRAP),
            .ST_DATA_W                 (ST_DATA_W),
            .ST_CHANNEL_W              (ST_CHANNEL_W),
            .BURSTWRAP_CONST_MASK      (BURSTWRAP_CONST_MASK),
            .BURSTWRAP_CONST_VALUE     (BURSTWRAP_CONST_VALUE),
            .PIPE_INPUTS               (PIPE_INPUTS),
            .NO_WRAP_SUPPORT           (NO_WRAP_SUPPORT),
            .INCOMPLETE_WRAP_SUPPORT   (INCOMPLETE_WRAP_SUPPORT),
            .OUT_BYTE_CNT_H            (OUT_BYTE_CNT_H),
            .OUT_BURSTWRAP_H           (OUT_BURSTWRAP_H),
            .SYNC_RESET                (SYNC_RESET)
        ) burst_adapter (
            .clk                   (clk),
            .reset                 (reset),
            .sink0_valid           (sink0_pipe_valid),
            .sink0_data            (sink0_pipe_data),
            .sink0_channel         (sink0_pipe_channel),
            .sink0_startofpacket   (sink0_pipe_sop),
            .sink0_endofpacket     (sink0_pipe_eop),
            .sink0_ready           (sink0_pipe_ready),
            .source0_valid         (source0_valid),
            .source0_data          (source0_data),
            .source0_channel       (source0_channel),
            .source0_startofpacket (source0_startofpacket),
            .source0_endofpacket   (source0_endofpacket),
            .source0_ready         (source0_ready)
        );


        if(PIPE_INPUTS == 1) begin: pipe_inputs
            pcie_ed_altera_merlin_burst_adapter_altera_avalon_st_pipeline_stage_1922_pev47ty # (
                .SYMBOLS_PER_BEAT (1),
                .BITS_PER_SYMBOL  (ST_DATA_W),
                .USE_PACKETS      (1),
                .USE_EMPTY        (0),
                .EMPTY_WIDTH      (0),
                .CHANNEL_WIDTH    (ST_CHANNEL_W),
                .PACKET_WIDTH     (2),
                .ERROR_WIDTH      (0),
                .PIPELINE_READY   (1),
	             .SYNC_RESET       (SYNC_RESET)
            ) pipe_stage (
                 .clk               (clk),
                 .reset             (reset),

                 .in_ready          (sink0_ready),
                 .in_valid          (sink0_valid),
                 .in_startofpacket  (sink0_startofpacket),
                 .in_endofpacket    (sink0_endofpacket),
                 .in_data           (sink0_data),
                 .in_channel        (sink0_channel),

                 .out_ready         (sink0_pipe_ready),
                 .out_valid         (sink0_pipe_valid),
                 .out_startofpacket (sink0_pipe_sop),
                 .out_endofpacket   (sink0_pipe_eop),
                 .out_data          (sink0_pipe_data),
                 .out_channel       (sink0_pipe_channel)
            );

         end
         else begin : no_input_pipeline

             assign sink0_pipe_valid   = sink0_valid;
             assign sink0_pipe_data    = sink0_data;
             assign sink0_pipe_channel = sink0_channel;
             assign sink0_pipe_sop     = sink0_startofpacket;
             assign sink0_pipe_eop     = sink0_endofpacket;
             assign sink0_ready        = sink0_pipe_ready;

         end 

    end 
    endgenerate

    // Generation of internal reset synchronization
   reg internal_sclr;
   generate if (SYNC_RESET == 1) begin : rst_syncronizer
      always @ (posedge clk) begin
         internal_sclr <= reset;
      end
   end
   endgenerate
    
    // synthesis translate_off
     
    // -----------------------------------------------------
    // Simulation-only check for incoming burstwrap values inconsistent with 
    // BURSTWRAP_CONST_MASK, which would indicate a paramerization error. 
    //
    // Should be turned into an assertion, really.
    // -----------------------------------------------------
    generate
    if (SYNC_RESET == 0) begin : async_rst0
      always @(posedge clk or posedge reset) begin
          if (reset) begin
          end
          else if (sink0_valid &&
            BURSTWRAP_CONST_MASK[PKT_BURSTWRAP_W - 1:0] &
            (BURSTWRAP_CONST_VALUE[PKT_BURSTWRAP_W - 1:0] ^ sink0_data[PKT_BURSTWRAP_H : PKT_BURSTWRAP_L])
          ) begin
              $display("%t: %m: Error: burstwrap value %X is inconsistent with BURSTWRAP_CONST_MASK value %X", $time(), sink0_data[PKT_BURSTWRAP_H : PKT_BURSTWRAP_L], BURSTWRAP_CONST_MASK[PKT_BURSTWRAP_W - 1:0]);
          end
      end
    end : async_rst0
  
    else begin : sync_rst0
      always @(posedge clk ) begin
          if ((internal_sclr == 1'b0) && sink0_valid &&
            BURSTWRAP_CONST_MASK[PKT_BURSTWRAP_W - 1:0] &
            (BURSTWRAP_CONST_VALUE[PKT_BURSTWRAP_W - 1:0] ^ sink0_data[PKT_BURSTWRAP_H : PKT_BURSTWRAP_L])
          ) begin
              $display("%t: %m: Error: burstwrap value %X is inconsistent with BURSTWRAP_CONST_MASK value %X", $time(), sink0_data[PKT_BURSTWRAP_H : PKT_BURSTWRAP_L], BURSTWRAP_CONST_MASK[PKT_BURSTWRAP_W - 1:0]);
          end
      end
   end : sync_rst0
  endgenerate
    // synthesis translate_on
endmodule

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "DcjSv4cazWNFeTq2LDzhR8VVA2vsU+D2FLr5cau2M2bJ+ymOMJzu0j4X+D7sDofwwnGT3dC9uPfUfqUyT+1JDqgoqF4+Hm1+DbOqZuomBxMc/3ubRV7jR7LhS90CAIiftZSupMkt7Z6NB7tsmbvAu3Uqtxlo+Ag4QRIgi49yVFsS2wB30qw4GeL5di6t6OjbvWcjLtKHJMZ/Vew3QCsc9aW8Cap9TcP/4lTkJB8MFThKxqujdWtz9jjqfffqcx02XXBSbxmNLbeVnPnVOTcrGbk1FBRiVrwHALV8YtFvVUa3aHMZwzcPxU1GVQDjOxd+fy2jR/QqJsgPLrJ79qV31oj66Ag7g98T0eEZ5u1lUOmaTVXhSnMgKhYymY/P7qrxQZhHEzjw5V3NQOpwh5SU/UfghzbCMMDQlTyNRZdkT+OdpIjJHAgtlaGA+GgHGbTzkSWlgRgein80eNBLmxIgAqXfmfMJCjF0loN5jg0wGB5aEgwip3ZTrCUTc8agseeHU8+KsSDhdHLG0NrDNudPi23Jr8AY9lsH89C2yIPvijmCbTnIaZZkkAhAYmS/BAnjvdhivpzCmW9KuYFnzMjp9+lDdkKyFujKx5v+GRg8c4CTnDPI3h8FkjaOCjilfe50+7kp3ELM8WKFxoA/3BLaCcpjIu9Aze/oW7uDy3LGa18PXgGJHpp0rr9AWskhtb6WpJWArcgBfxdjZckzkNpQ4rH9ah/st41m46sp0czsGfVNThcfxo4OeB47VeK2HNxmNk+T6oWiZNtZQDSVopXTKVCFOZDI76XNqzTRhLshlg6SpAmvwCYV3Of+//wZCF8nz0fakOadFvYKBPpi1G2XiySTR1e0pYlHlYUSmJK7Nt/ufdR92fFFIFMBUyZxOJg+EGEp5DA1MIipjfM+wrHI6AIIyWlT7C+zEdkLvlHh6j959pWx700pRH0iviQgy4A5tOf22rTY33lFamAqt0v5vaF+8mcqyzxnRg9trswfrLjLj0CXaTUqD0Jv1dY+dCMQ"
`endif