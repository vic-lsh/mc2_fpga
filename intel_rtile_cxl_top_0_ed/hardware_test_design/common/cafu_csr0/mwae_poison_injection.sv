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



// Copyright 2023 Intel Corporation.
//
// THIS SOFTWARE MAY CONTAIN PREPRODUCTION CODE AND IS PROVIDED BY THE
// COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
// WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
// EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
///////////////////////////////////////////////////////////////////////
`include "ccv_afu_globals.vh.iv"

module mwae_poison_injection
(
  input clk,
  input reset_n,
  input wvalid,    // from the axi write data channel
  input poison_injection_start,
  input force_disable_afu,

  output logic poison_injection_busy,
  output logic set_wuser_poison
);

/* =======================================================================================
*/
typedef enum logic [1:0] {
  IDLE                   = 2'd0,
  CHECK_FOR_WVALID       = 2'd1,
  CLEAR_BUSY             = 2'd2,
  WAIT_START_LOW         = 2'd3
} fsm_enum;

fsm_enum    state;
fsm_enum    next_state;

/* =======================================================================================
*/
always_ff @( posedge clk )
begin
       if( reset_n == 1'b0 )           state <= IDLE;
  else if( force_disable_afu == 1'b1 ) state <= IDLE; 
  else                                 state <= next_state;
end

/* =======================================================================================
*/
logic set_busy_high;
logic set_busy_low;

always_comb
begin
  set_busy_high    = 1'b0;
  set_busy_low     = 1'b0;
  set_wuser_poison = 1'b0;

  case( state )
    IDLE :
    begin
      if( poison_injection_start == 1'b0 )    next_state = IDLE;
      else begin
	                                   set_busy_high = 1'b1;
                                              next_state = CHECK_FOR_WVALID;
      end
    end

    CHECK_FOR_WVALID :
    begin
      if( wvalid == 1'b0 )                    next_state = CHECK_FOR_WVALID;
      else begin
	                                set_wuser_poison = 1'b1;
                                              next_state = CLEAR_BUSY;
      end
    end

    CLEAR_BUSY :
    begin
	                                    set_busy_low = 1'b1;
                                              next_state = WAIT_START_LOW;
    end

    WAIT_START_LOW :   // require clear of start to do another poison injection
    begin
      if( poison_injection_start == 1'b0 )    next_state = IDLE;
      else                                    next_state = WAIT_START_LOW;
    end

    default :                                 next_state = IDLE;
  endcase
end

/* =======================================================================================
*/
always_ff @( posedge clk )
begin
       if( reset_n == 1'b0 )       poison_injection_busy <= 1'b0;
  else if( set_busy_high == 1'b1 ) poison_injection_busy <= 1'b1;
  else if( set_busy_low  == 1'b1 ) poison_injection_busy <= 1'b0;
  else                             poison_injection_busy <= poison_injection_busy;
end

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "DGzrytkiceLjtyjsTaM+IzNUexbn5wzpmx4F1prXYECmxPXPn13o0M/rXNG1mO13RJ5fhQaExY1DId30xrFeFq5FL7gSGxHyRknIDLmmCNMcWImmwtFcy2uyhgWx0jyEzKKJKegjoNYHGsF9JtxyGoo4G3owvnlbnlgS/aJ3Aky5AJL4N0KkruYOdzUGck/zCmpIoex0KWhVL43DGHURVo8L2CS4v6cauUSxTHMeah3Jgw3ctjRPoDwHQhNeVtBUiDZXtw8f1b05/4JR8lJLSbsz2kB+ZpBBu3gWSUSlA8kVW0VZIChmtwu2jRpgdMTtcXuAnWpJ6JiJNUxKATu7pgRvEcjhVXIVBaqemWTAWYJMkoUGsJmVBWLdBQV7uMxSjThc3TE5EUTAOYsANUTQJU5U3xMLsAzuor4OCg/uewwR2VF+ZapVA17BROOvXGTyBTDEv/Ng5qCIE2puTQE3s0qMQAMcNDpKaTJwOYakzx6ZZ9+E/2C2EpclL5uBrxK/cZCa3r6FurzXjqkdYDbTfzA+iQxvUCW0NIjqB7WAzJR0b5OsCfZ78GAZJbztBGsFuaWrYwmhmfTX1O0QfkJe2kvGu+8ehDkf2JM4Uf3VW9FDyw6VH9xHxIdmGCOE1QB+5ieGcrL00kAoJK7wKW/7ZVJGgJlvjM1PKM000jb1Gx7tV3LEIdrLvqXruotlmhCQLqx44VPBAVvLlyjrycTxRcMd/BdnI46XVa60a0A3OsmSKZ1w5sXN+LszHuU+vZPKKUCOHt05rnzSA9kltZojjn48DzPviA+QneWBSVGVjUHr7vEweYNL9hdV96KHfB64sb1WfcSc3UFm7QxQAFh4f3uLvxqbKwraI3YwqQ+gd7W7nfsbKDS3eOzgWAZbrnOlDOxczllq6kHGa0dWa0HV+byNWQNAs02TpPVZB/8wR4PpMmagDkmdHHlOI1yGyjf8x4q7sl2Bp80HulqbYanLeiq94nHRiODKVwZjbKWtgv5mw3pghlsRTjMu4pQxtChT"
`endif