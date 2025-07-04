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


// (C) 2001-2017 Intel Corporation. All rights reserved.
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

// $Id: //acds/main/ip/merlin/altera_merlin_master_translator/altera_merlin_master_translator.sv#47 $
// $Revision: #47 $
// $Date: 2018/06/12 $

// --------------------------------------
// Merlin Master Translator
//
// Converts an Avalon-MM master interface into an 
// Avalon-MM "universal" master interface.
//
// The universal interface is defined as the superset of ports
// and parameters that can represent any legal Avalon 
// interface.
// --------------------------------------

`timescale 1 ns / 1 ns

module avmm_ic_altera_merlin_master_translator_192_lykd4la #(
   parameter
      // widths
      AV_ADDRESS_W                = 32,
      AV_DATA_W                   = 32,
      AV_BURSTCOUNT_W             = 4,
      AV_BYTEENABLE_W             = 4,

      UAV_ADDRESS_W               = 38,
      UAV_BURSTCOUNT_W            = 10,
  
      // optional ports
      USE_BURSTCOUNT              = 1,
      USE_BEGINBURSTTRANSFER      = 0,
      USE_BEGINTRANSFER           = 0,
      USE_CHIPSELECT              = 0,
      USE_READ                    = 1,
      USE_READDATAVALID           = 1,
      USE_WRITE                   = 1,
      USE_WAITREQUEST             = 1,
      USE_WRITERESPONSE           = 0,
      USE_READRESPONSE            = 0,
      USE_OUTPUTENABLE		  = 0,
   
      AV_REGISTERINCOMINGSIGNALS  = 0,
      AV_SYMBOLS_PER_WORD         = 4,
      AV_ADDRESS_SYMBOLS          = 0,
      // must be enabled for a bursting master
      AV_CONSTANT_BURST_BEHAVIOR  = 1,
      UAV_CONSTANT_BURST_BEHAVIOR = 0,
      AV_BURSTCOUNT_SYMBOLS       = 0,
      AV_LINEWRAPBURSTS           = 0,

      WAITREQUEST_ALLOWANCE       = 0,

      SYNC_RESET                  = 0
)(
   input wire                           clk,
   input wire                           reset,

   // Universal Avalon Master
   output reg                           uav_write,
   output reg                           uav_read,
   output reg [UAV_ADDRESS_W -1 : 0]    uav_address,
   output reg [UAV_BURSTCOUNT_W -1 : 0] uav_burstcount,
   output wire [AV_BYTEENABLE_W -1 : 0] uav_byteenable,
   output wire [AV_DATA_W -1 : 0]       uav_writedata,
   output wire                          uav_lock,
   output wire                          uav_debugaccess,
   output wire                          uav_clken,

   input wire [AV_DATA_W -1 : 0]        uav_readdata,
   input wire                           uav_readdatavalid,
   input wire                           uav_waitrequest,
   input wire [1 : 0]                   uav_response,
   input wire                           uav_writeresponsevalid,
   input wire                           uav_outputenable,

   // Avalon-MM Anti-master (slave)
   input reg                            av_write,
   input reg                            av_read,
   input wire [AV_ADDRESS_W -1 : 0]     av_address,
   input wire [AV_BYTEENABLE_W -1 : 0]  av_byteenable,
   input wire [AV_BURSTCOUNT_W -1 : 0]  av_burstcount,
   input wire [AV_DATA_W -1 : 0]        av_writedata,
   input wire                           av_begintransfer,
   input wire                           av_beginbursttransfer,
   input wire                           av_lock,
   input wire                           av_chipselect,
   input wire                           av_debugaccess,
   input wire                           av_clken,

   output wire [AV_DATA_W -1 : 0]       av_readdata,
   output wire                          av_readdatavalid,
   output reg                           av_waitrequest,
   output reg [1 : 0]                   av_response,
   output reg                           av_writeresponsevalid
);

   localparam BITS_PER_WORD = clog2(AV_SYMBOLS_PER_WORD);
   localparam AV_MAX_SYMBOL_BURST = flog2(pow2(AV_BURSTCOUNT_W - 1) * (AV_BURSTCOUNT_SYMBOLS ? 1 : AV_SYMBOLS_PER_WORD));
   localparam AV_MAX_SYMBOL_BURST_MINUS_ONE = AV_MAX_SYMBOL_BURST ? AV_MAX_SYMBOL_BURST - 1 : 0;
   localparam UAV_BURSTCOUNT_H_OR_31 = (UAV_BURSTCOUNT_W > 32) ? 31 : UAV_BURSTCOUNT_W - 1;
   localparam UAV_ADDRESS_H_OR_31 = (UAV_ADDRESS_W > 32) ? 31 : UAV_ADDRESS_W - 1;

   localparam BITS_PER_WORD_BURSTCOUNT = (UAV_BURSTCOUNT_W == 1) ? 0 : BITS_PER_WORD;
   localparam BITS_PER_WORD_ADDRESS    = (UAV_ADDRESS_W == 1) ? 0 : BITS_PER_WORD;

   localparam ADDRESS_LOW     = AV_ADDRESS_SYMBOLS ? 0 : BITS_PER_WORD_ADDRESS;
   localparam BURSTCOUNT_LOW  = AV_BURSTCOUNT_SYMBOLS ? 0 : BITS_PER_WORD_BURSTCOUNT;

   localparam ADDRESS_HIGH    = (UAV_ADDRESS_W > AV_ADDRESS_W + ADDRESS_LOW) ? AV_ADDRESS_W : (UAV_ADDRESS_W - ADDRESS_LOW);
   localparam BURSTCOUNT_HIGH = (UAV_BURSTCOUNT_W > AV_BURSTCOUNT_W + BURSTCOUNT_LOW) ? AV_BURSTCOUNT_W : (UAV_BURSTCOUNT_W - BURSTCOUNT_LOW);

   localparam UAV_BURSTLEN_W = UAV_BURSTCOUNT_W - BITS_PER_WORD_BURSTCOUNT;

   function integer flog2;
      input [31:0]  depth;
      integer       i;
      begin
         i = depth;
         if ( i <= 0 ) flog2 = 0;
         else begin
            for (flog2 = -1; i > 0; flog2 = flog2 + 1)
               i = i >> 1;
         end
      end
   endfunction // flog2

    // ------------------------------------------------------------
    // Calculates the ceil(log2()) of the input val.
    //
    // Limited to a positive 32-bit input value.
    // ------------------------------------------------------------
    function integer clog2;
        input[31:0] val;
        reg[31:0] i;

        begin
            i = 1;
            clog2 = 0;

            while (i < val) begin
                clog2 = clog2 + 1;
                i = i[30:0] << 1;
            end
        end
    endfunction

   function integer pow2;
      input [31:0] toShift;
      begin
         pow2 = 1;
         pow2 = pow2 << toShift;
      end
   endfunction // pow2

   reg internal_sclr;
   generate if (SYNC_RESET == 1) begin : rst_syncronizer
      always @ (posedge clk) begin
         internal_sclr <= reset;
      end
   end
   endgenerate

   // -------------------------------------------------
   // Assign some constants to appropriately-sized signals to
   // avoid synthesis warnings. This also helps some simulators
   // with their inferred sensitivity lists.
   //
   // The symbols per word calculation here rounds non-power of two
   // symbols to the next highest power of two, which is what we want
   // when calculating the decrementing byte count.
   // -------------------------------------------------
   wire [31 : 0] symbols_per_word_int = 2**(clog2(AV_SYMBOLS_PER_WORD[UAV_BURSTCOUNT_H_OR_31 : 0]));
   wire [UAV_BURSTCOUNT_H_OR_31 : 0] symbols_per_word = symbols_per_word_int[UAV_BURSTCOUNT_H_OR_31 : 0];

   reg                            internal_beginbursttransfer;
   reg                            internal_begintransfer;
   reg [UAV_ADDRESS_W -1 : 0]     uav_address_pre;
   reg [UAV_BURSTCOUNT_W -1 : 0]  uav_burstcount_pre;

   reg uav_read_pre;
   reg uav_write_pre;
   reg read_accepted;

   // -------------------------------------------------
   // Pass through signals that we don't touch
   // -------------------------------------------------
   assign uav_writedata    = av_writedata;
   assign uav_byteenable   = av_byteenable;
   assign uav_lock         = av_lock;
   assign uav_debugaccess  = av_debugaccess;
   assign uav_clken        = av_clken;

   assign av_readdata      = uav_readdata;
   assign av_readdatavalid = uav_readdatavalid;

   // -------------------------------------------------
   // Response signals
   // -------------------------------------------------
   always_comb begin
      if (!USE_READRESPONSE && !USE_WRITERESPONSE)
         av_response = '0;
      else
         av_response = uav_response;

      if (USE_WRITERESPONSE) begin
         av_writeresponsevalid = uav_writeresponsevalid;
      end else begin
         av_writeresponsevalid = '0;
      end
   end

   // -------------------------------------------------
   // Convert byte and word addresses into byte addresses
   // -------------------------------------------------
   always_comb begin
      uav_address_pre = {UAV_ADDRESS_W{1'b0}};

      if (AV_ADDRESS_SYMBOLS)
         uav_address_pre[(ADDRESS_HIGH ? ADDRESS_HIGH - 1 : 0) : 0] = av_address[(ADDRESS_HIGH ? ADDRESS_HIGH - 1 : 0) : 0];
      else begin
         uav_address_pre[ADDRESS_LOW + ADDRESS_HIGH - 1 : ADDRESS_LOW] = av_address[(ADDRESS_HIGH ? ADDRESS_HIGH - 1 : 0) : 0];
      end
   end

   // -------------------------------------------------
   // Convert burstcount into symbol units
   // -------------------------------------------------
   always_comb begin
      uav_burstcount_pre = symbols_per_word;  // default to a single transfer

      if (USE_BURSTCOUNT) begin
         uav_burstcount_pre = {UAV_BURSTCOUNT_W{1'b0}};
         if (AV_BURSTCOUNT_SYMBOLS)
            uav_burstcount_pre[(BURSTCOUNT_HIGH ? BURSTCOUNT_HIGH - 1 : 0) :0] = av_burstcount[(BURSTCOUNT_HIGH ? BURSTCOUNT_HIGH - 1 : 0) : 0];
         else begin
            uav_burstcount_pre[UAV_BURSTCOUNT_W - 1 : BURSTCOUNT_LOW] = av_burstcount[(BURSTCOUNT_HIGH ? BURSTCOUNT_HIGH - 1 : 0) : 0];
         end
      end
   end

   // -------------------------------------------------
   // This is where we perform the per-transfer address and burstcount 
   // calculations that are required by downstream modules.
   // -------------------------------------------------
   reg [UAV_ADDRESS_W -1 : 0] address_register;
   wire [UAV_ADDRESS_W -1 : 0] n_uav_address;
   wire [UAV_BURSTCOUNT_W -1 : 0] burstcount_register;
   reg [UAV_BURSTCOUNT_W : 0] burstcount_register_lint;

   wire [UAV_BURSTLEN_W - 1 : 0] burstlen_register;
   reg  [UAV_BURSTLEN_W     : 0] burstlen_register_lint;
   wire [UAV_BURSTLEN_W - 1 : 0] uav_burstlen_pre;

   always_comb begin
      uav_address = uav_address_pre;
      uav_burstcount = uav_burstcount_pre;

      if (AV_CONSTANT_BURST_BEHAVIOR && !UAV_CONSTANT_BURST_BEHAVIOR && ~internal_beginbursttransfer) begin
         uav_address = address_register;
         uav_burstcount = burstcount_register;
      end
   end

   assign uav_burstlen_pre    = uav_burstcount_pre[UAV_BURSTCOUNT_W - 1 : BITS_PER_WORD_BURSTCOUNT];
   assign burstcount_register = burstcount_register_lint[UAV_BURSTCOUNT_W -1 : 0];
   assign burstlen_register   = burstlen_register_lint[UAV_BURSTLEN_W -1 : 0];

   generate
      if (AV_LINEWRAPBURSTS && AV_MAX_SYMBOL_BURST != 0) begin
         if (AV_MAX_SYMBOL_BURST > UAV_ADDRESS_W - 1) begin
            always @ (posedge clk) begin
               if(av_waitrequest & (WAITREQUEST_ALLOWANCE == 0)) begin
                  address_register <= n_uav_address;
               end
               else if(uav_write) begin
                  address_register <= n_uav_address[UAV_ADDRESS_W-1:0] + AV_SYMBOLS_PER_WORD[BITS_PER_WORD:0]; 
               end
            end
         end
         else begin
            always @ (posedge clk) begin
               if(av_waitrequest & (WAITREQUEST_ALLOWANCE == 0)) begin
                  address_register <= n_uav_address;
               end
               else if(uav_write) begin
                  address_register <= {
                                       n_uav_address[UAV_ADDRESS_W - 1 : AV_MAX_SYMBOL_BURST], 
                                       n_uav_address[AV_MAX_SYMBOL_BURST_MINUS_ONE:0] + AV_SYMBOLS_PER_WORD[AV_MAX_SYMBOL_BURST_MINUS_ONE:0] 
                                      };
               end
            end
         end
      end
      else begin
         always @ (posedge clk) begin
            if(av_waitrequest & (WAITREQUEST_ALLOWANCE == 0)) begin
               address_register <= n_uav_address;
            end
            else if(uav_write) begin
               address_register <= n_uav_address + AV_SYMBOLS_PER_WORD[BITS_PER_WORD:0]; 
            end
         end
      end
   endgenerate

   assign n_uav_address = internal_beginbursttransfer ? uav_address_pre : address_register; 

   generate if (WAITREQUEST_ALLOWANCE == 0) 
   begin : waitreq_eq0
      reg first_burst_stalled;
      reg burst_stalled;

      always @(posedge clk) begin
         if (internal_beginbursttransfer || first_burst_stalled) begin
            if (av_waitrequest) begin
               burstlen_register_lint[UAV_BURSTLEN_W - 1 : 0] <= uav_burstlen_pre;
            end else begin
               burstlen_register_lint <= uav_burstlen_pre - 1'b1;
            end
         end else if (internal_begintransfer || burst_stalled) begin
            if (~av_waitrequest) begin
               burstlen_register_lint <= burstlen_register - 1'b1;
            end
         end
      end

      if(SYNC_RESET == 0) begin
         always @(posedge clk, posedge reset) begin
            if (reset) begin
               first_burst_stalled <= 1'b0;
               burst_stalled <= 1'b0;
            end else begin
               if (internal_beginbursttransfer || first_burst_stalled) begin
                  if (av_waitrequest) begin
                     first_burst_stalled <= 1'b1;
                  end else begin
                     first_burst_stalled <= 1'b0;
                  end
               end else if (internal_begintransfer || burst_stalled) begin
                  if (~av_waitrequest) begin
                     burst_stalled <= 1'b0;
                  end else begin
                     burst_stalled <= 1'b1;
                  end
               end
            end
         end
      end
      else begin
         always @(posedge clk) begin
            if (internal_sclr) begin
               first_burst_stalled <= 1'b0;
               burst_stalled <= 1'b0;
            end else begin
               if (internal_beginbursttransfer || first_burst_stalled) begin
                  if (av_waitrequest) begin
                     first_burst_stalled <= 1'b1;
                  end else begin
                     first_burst_stalled <= 1'b0;
                  end
               end else if (internal_begintransfer || burst_stalled) begin
                  if (~av_waitrequest) begin
                     burst_stalled <= 1'b0;
                  end else begin
                     burst_stalled <= 1'b1;
                  end
               end
            end
         end
      end
   end   // end waitreq_eq0
   else begin : waitreq_gt0
      always @ (posedge clk) begin
         if(internal_beginbursttransfer) begin
            burstlen_register_lint <= uav_burstlen_pre - 1'b1;
         end
         else if(internal_begintransfer) begin
            burstlen_register_lint <= burstlen_register - 1'b1;
         end
      end
   end   // end waitreq_gt0
   endgenerate

   always_comb begin
      burstcount_register_lint = {burstlen_register_lint,{BITS_PER_WORD_BURSTCOUNT{1'b0}}};
   end


   // -------------------------------------------------
   // Waitrequest translation
   // -------------------------------------------------
   generate
   if (SYNC_RESET == 0) begin : async_rst1
      always @(posedge clk, posedge reset) begin
         if (reset)
            read_accepted <= 1'b0;
         else begin
            read_accepted <= read_accepted;
            if (read_accepted == 0)
               read_accepted <= av_waitrequest ? uav_read_pre & ~uav_waitrequest : 1'b0;
            else if (read_accepted == 1 && uav_readdatavalid == 1)  // reset acceptance only when rdv arrives
               read_accepted <= 1'b0;
         end
      end
   end
   else begin : sync_rst1
      always @(posedge clk) begin
         if (internal_sclr)
            read_accepted <= 1'b0;
         else begin
            read_accepted <= read_accepted;
            if (read_accepted == 0)
               read_accepted <= av_waitrequest ? uav_read_pre & ~uav_waitrequest : 1'b0;
            else if (read_accepted == 1 && uav_readdatavalid == 1)  // reset acceptance only when rdv arrives
               read_accepted <= 1'b0;
         end
      end // @always
   end
   endgenerate

   reg write_accepted;
   generate if (AV_REGISTERINCOMINGSIGNALS) begin
      if (SYNC_RESET == 0) begin : async_rst2
         always @(posedge clk, posedge reset) begin
            if (reset)
               write_accepted <= 1'b0;
            else begin
               write_accepted <=
               ~av_waitrequest ? 1'b0 :
               uav_write & ~uav_waitrequest? 1'b1 :
               write_accepted;
            end
         end
      end
      else begin
         always @(posedge clk) begin
            if (internal_sclr)
               write_accepted <= 1'b0;
            else begin
               write_accepted <=
               ~av_waitrequest ? 1'b0 :
               uav_write & ~uav_waitrequest? 1'b1 :
               write_accepted;
            end
         end
      end
   end endgenerate

   always_comb begin
      av_waitrequest = uav_waitrequest;

      if (USE_READDATAVALID == 0) begin
         av_waitrequest = uav_read_pre ? ~uav_readdatavalid : uav_waitrequest;
      end

      if (AV_REGISTERINCOMINGSIGNALS) begin
         av_waitrequest =
            uav_read_pre ? ~uav_readdatavalid :
            uav_write_pre ? (internal_begintransfer | uav_waitrequest) & ~write_accepted :
            1'b1;
      end

      if (USE_WAITREQUEST == 0) begin
         av_waitrequest = 0;
      end
   end

   // -------------------------------------------------
   // Determine the output read and write signals from 
   // the read/write/chipselect input signals.
   // -------------------------------------------------
   always_comb begin
      uav_write      =  1'b0;
      uav_write_pre  =  1'b0;
      uav_read       =  1'b0;
      uav_read_pre   =  1'b0;

      if (!USE_CHIPSELECT) begin
         if (USE_READ) begin
            uav_read_pre = av_read;
         end
     
         if (USE_WRITE) begin
            uav_write_pre = av_write;
         end
      end else begin
         if (!USE_WRITE && USE_READ) begin
            uav_write_pre = av_chipselect & ~av_read;
            uav_read_pre = av_read;
         end else if (!USE_READ && USE_WRITE) begin
            uav_write_pre = av_write;
            uav_read_pre = av_chipselect & ~av_write;
         end else if (USE_READ && USE_WRITE) begin
            uav_write_pre = av_write;
            uav_read_pre = av_read;
         end
      end

      if (USE_READDATAVALID == 0)
         uav_read = uav_read_pre & ~read_accepted;
      else
         uav_read = uav_read_pre;

      if (AV_REGISTERINCOMINGSIGNALS == 0)
         uav_write = uav_write_pre;
      else
         uav_write = uav_write_pre & ~write_accepted;
   end

   // -------------------------------------------------
   // Begintransfer assignment
   // -------------------------------------------------
   reg end_begintransfer;

   always_comb begin
      if (USE_BEGINTRANSFER) begin
         internal_begintransfer = av_begintransfer;
      end else begin
         if(WAITREQUEST_ALLOWANCE == 0) begin
            internal_begintransfer = ( uav_write | uav_read ) & ~end_begintransfer;
         end
         else begin
            internal_begintransfer = ( uav_write | uav_read );
         end
      end
   end

   generate
   if (SYNC_RESET == 0) begin : async_rst3 
      always @(posedge clk or posedge reset) begin
         if (reset) begin
            end_begintransfer <= 1'b0;
         end else begin
            if (internal_begintransfer == 1 && uav_waitrequest)
               end_begintransfer <= 1'b1;
            else if (uav_waitrequest)
               end_begintransfer <= end_begintransfer;
            else
               end_begintransfer <= 1'b0;
         end
      end
   end
   else begin : sync_rst3
      always @(posedge clk ) begin
         if (internal_sclr) begin
            end_begintransfer <= 1'b0;
         end else begin
            if (internal_begintransfer == 1 && uav_waitrequest)
               end_begintransfer <= 1'b1;
            else if (uav_waitrequest)
               end_begintransfer <= end_begintransfer;
            else
               end_begintransfer <= 1'b0;
         end
      end
    end : sync_rst3
    endgenerate
   // -------------------------------------------------
   // Beginbursttransfer assignment
   // -------------------------------------------------
   reg   end_beginbursttransfer;
   wire  last_burst_transfer_pre;
   wire  last_burst_transfer_reg;
   wire  last_burst_transfer;

   // compare values before the mux to shorten critical path; benchmark before changing
   assign last_burst_transfer_pre = (uav_burstlen_pre == 1);
   assign last_burst_transfer_reg = (burstlen_register == 1);
   assign last_burst_transfer     = (internal_beginbursttransfer) ? last_burst_transfer_pre : last_burst_transfer_reg;

   always_comb begin
      if (USE_BEGINBURSTTRANSFER) begin
         internal_beginbursttransfer = av_beginbursttransfer;
      end else begin
         internal_beginbursttransfer = uav_read ? internal_begintransfer : internal_begintransfer && ~end_beginbursttransfer;
      end
   end

   generate
   if (SYNC_RESET == 0) begin : async_rst4
      always @(posedge clk or posedge reset) begin
         if (reset) begin
            end_beginbursttransfer <= 1'b0;
         end else begin
            end_beginbursttransfer <= end_beginbursttransfer;
            if (last_burst_transfer && internal_begintransfer || uav_read) begin
               end_beginbursttransfer <= 1'b0;
            end
            else if (uav_write && internal_begintransfer) begin
               end_beginbursttransfer <= 1'b1;
            end
         end
      end
   end : async_rst4
   else begin : sync_rst4
     always @(posedge clk ) begin
         if (internal_sclr) begin
            end_beginbursttransfer <= 1'b0;
         end else begin
            end_beginbursttransfer <= end_beginbursttransfer;
            if (last_burst_transfer && internal_begintransfer || uav_read) begin
               end_beginbursttransfer <= 1'b0;
            end
            else if (uav_write && internal_begintransfer) begin
               end_beginbursttransfer <= 1'b1;
            end
         end
      end
   end : sync_rst4
   endgenerate
   // synthesis translate_off

   // ------------------------------------------------
   // check_1   : for waitrequest signal violation
   //             Ensure that when waitreqeust is asserted, the master is not allowed to change its controls
   // Exception : begintransfer / beginbursttransfer
   //           : previously not in any transaction (idle)
   // Note : Not checking clken which is not exactly part of Avalon controls/inputs
   //      : Not using system verilog assertions (seq/prop) since it is not supported if using Modelsim_SE
   // ------------------------------------------------

   generate if(WAITREQUEST_ALLOWANCE == 0) 
   begin : waitrequest_monitor
      reg av_waitrequest_r;
      reg av_write_r, av_read_r, av_lock_r, av_chipselect_r, av_debugaccess_r;
      reg [AV_ADDRESS_W-1:0]    av_address_r;
      reg [AV_BYTEENABLE_W-1:0] av_byteenable_r;
      reg [AV_BURSTCOUNT_W-1:0] av_burstcount_r;
      reg [AV_DATA_W-1:0]       av_writedata_r;

      if (SYNC_RESET == 0) begin : async_rst5
         always @(posedge clk or posedge reset) begin
            if (reset) begin
               av_waitrequest_r           <= '0;
               av_write_r                 <= '0;
               av_read_r                  <= '0;
               av_lock_r                  <= '0;
               av_chipselect_r            <= '0;
               av_debugaccess_r           <= '0;
               av_address_r               <= '0;
               av_byteenable_r            <= '0;
               av_burstcount_r            <= '0;
               av_writedata_r             <= '0;
            end else begin
               av_waitrequest_r           <= av_waitrequest;
               av_write_r                 <= av_write;
               av_read_r                  <= av_read;
               av_lock_r                  <= av_lock;
               av_chipselect_r            <= av_chipselect;
               av_debugaccess_r           <= av_debugaccess;
               av_address_r               <= av_address;
               av_byteenable_r            <= av_byteenable;
               av_burstcount_r            <= av_burstcount;
               av_writedata_r             <= av_writedata;
         
               if (
                  av_waitrequest_r && // When waitrequest is asserted
                  (
                     (av_write                  != av_write_r) ||   // Checks that : Input controls/data does not change
                     (av_read                   != av_read_r)  ||
                     (av_lock                   != av_lock_r)  ||
                     (av_debugaccess            != av_debugaccess_r) ||
                     (av_address                != av_address_r) ||
                     (av_byteenable             != av_byteenable_r) ||
                     (av_burstcount             != av_burstcount_r)
                  )  &&
                  (av_write_r | av_read_r) &&         // Check only when : previously initiated a write/read
                  (!USE_CHIPSELECT | av_chipselect_r) //                   and chipselect was asserted (or unused)
               ) begin
                  $display( "%t: %m: Error: Input controls/data changed while av_waitrequest is asserted.", $time());
                  $display("av_address                %x --> %x", av_address_r               , av_address               );
                  $display("av_byteenable             %x --> %x", av_byteenable_r            , av_byteenable            );
                  $display("av_burstcount             %x --> %x", av_burstcount_r            , av_burstcount            );
                  $display("av_writedata              %x --> %x", av_writedata_r             , av_writedata             );
                  $display("av_write                  %x --> %x", av_write_r                 , av_write                 );
                  $display("av_read                   %x --> %x", av_read_r                  , av_read                  );
                  $display("av_lock                   %x --> %x", av_lock_r                  , av_lock                  );
                  $display("av_chipselect             %x --> %x", av_chipselect_r            , av_chipselect            );
                  $display("av_debugaccess            %x --> %x", av_debugaccess_r           , av_debugaccess           );
               end
            end
         
         // end check_1
         
         end
      end
      else begin : sync_rst5
         always @(posedge clk) begin
            if (internal_sclr) begin
               av_waitrequest_r           <= '0;
               av_write_r                 <= '0;
               av_read_r                  <= '0;
               av_lock_r                  <= '0;
               av_chipselect_r            <= '0;
               av_debugaccess_r           <= '0;
               av_address_r               <= '0;
               av_byteenable_r            <= '0;
               av_burstcount_r            <= '0;
               av_writedata_r             <= '0;
            end else begin
               av_waitrequest_r           <= av_waitrequest;
               av_write_r                 <= av_write;
               av_read_r                  <= av_read;
               av_lock_r                  <= av_lock;
               av_chipselect_r            <= av_chipselect;
               av_debugaccess_r           <= av_debugaccess;
               av_address_r               <= av_address;
               av_byteenable_r            <= av_byteenable;
               av_burstcount_r            <= av_burstcount;
               av_writedata_r             <= av_writedata;
         
               if (
                  av_waitrequest_r && // When waitrequest is asserted
                  (
                     (av_write                  != av_write_r) ||   // Checks that : Input controls/data does not change
                     (av_read                   != av_read_r)  ||
                     (av_lock                   != av_lock_r)  ||
                     (av_debugaccess            != av_debugaccess_r) ||
                     (av_address                != av_address_r) ||
                     (av_byteenable             != av_byteenable_r) ||
                     (av_burstcount             != av_burstcount_r)
                  )  &&
                  (av_write_r | av_read_r) &&         // Check only when : previously initiated a write/read
                  (!USE_CHIPSELECT | av_chipselect_r) //                   and chipselect was asserted (or unused)
               ) begin
                  $display( "%t: %m: Error: Input controls/data changed while av_waitrequest is asserted.", $time());
                  $display("av_address                %x --> %x", av_address_r               , av_address               );
                  $display("av_byteenable             %x --> %x", av_byteenable_r            , av_byteenable            );
                  $display("av_burstcount             %x --> %x", av_burstcount_r            , av_burstcount            );
                  $display("av_writedata              %x --> %x", av_writedata_r             , av_writedata             );
                  $display("av_write                  %x --> %x", av_write_r                 , av_write                 );
                  $display("av_read                   %x --> %x", av_read_r                  , av_read                  );
                  $display("av_lock                   %x --> %x", av_lock_r                  , av_lock                  );
                  $display("av_chipselect             %x --> %x", av_chipselect_r            , av_chipselect            );
                  $display("av_debugaccess            %x --> %x", av_debugaccess_r           , av_debugaccess           );
               end
            end
         
         // end check_1
         
         end // @always 
      end : sync_rst5
   end
   endgenerate

  // synthesis translate_on


endmodule

