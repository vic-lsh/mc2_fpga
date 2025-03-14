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

module fifo_sync_1
#(
   parameter DATA_WIDTH = 16,
   parameter FIFO_DEPTH = 16,
   parameter PTR_WIDTH  = 4,
   parameter THRESHOLD  = 10
)
(
  input                  clk,
  input                  reset_n,
  input [DATA_WIDTH-1:0] i_data,
  input                  i_write_enable,
  input                  i_read_enable,
  input                  i_clear_fifo,  // should come from top level set to busy
  
  output logic [DATA_WIDTH-1:0] o_data,
  output logic                  o_empty,
  output logic                  o_full,
  output logic [PTR_WIDTH-1:0]  o_count,
  output logic                  o_thresh
);

logic [DATA_WIDTH-1:0] fifo_ram [FIFO_DEPTH-1:0];

logic [PTR_WIDTH-1:0] write_ptr;
logic [PTR_WIDTH-1:0] read_ptr;


always_comb
begin
    o_empty  = (o_count == 0);
    o_full   = (o_count == (FIFO_DEPTH-1));
    o_thresh = (o_count > (THRESHOLD-1));
end


always_ff @( posedge clk )
begin
  if( (reset_n == 1'b0) 
    | (i_clear_fifo == 1'b1) ) begin
                               o_count <= 'd0;
  end
  else if( (o_full == 1'b0)
         & (i_write_enable == 1'b1)
         & (o_empty == 1'b0)
         & (i_read_enable == 1'b1) ) begin
                               o_count <= o_count;
  end
  else if( (o_full == 1'b0)
         & (i_write_enable == 1'b1) ) begin
                               o_count <= o_count + 'd1;
  end
  else if( (o_empty == 1'b0)
         & (i_read_enable == 1'b1) ) begin
                               o_count <= o_count - 'd1;
  end
  else                         o_count <= o_count;
end


always_ff @( posedge clk )
begin
  if( (reset_n == 1'b0) 
    | (i_clear_fifo == 1'b1) ) begin
                               o_data <= 'd0;
  end
  else if( (o_empty == 1'b0)
         & (i_read_enable == 1'b1) ) begin
                               o_data <= fifo_ram[read_ptr];
  end
  else                         o_data <= o_data;
end


always_ff @( posedge clk )
begin
  if( (o_full == 1'b0)
    & (i_write_enable == 1'b1) ) begin
                               fifo_ram[write_ptr] <= i_data;
  end
  else                         fifo_ram[write_ptr] <= fifo_ram[write_ptr];
end


always_ff @( posedge clk )
begin
  if( (reset_n == 1'b0) 
    | (i_clear_fifo == 1'b1) ) begin
                               write_ptr <= 'd0;
  end
  else if( (o_full == 1'b0)
         & (i_write_enable == 1'b1) ) begin  
                               write_ptr <= write_ptr + 'd1;
  end
  else                         write_ptr <= write_ptr;
end


always_ff @( posedge clk )
begin
  if( (reset_n == 1'b0) 
    | (i_clear_fifo == 1'b1) ) begin
                               read_ptr <= 'd0;
  end
  else if( (o_empty == 1'b0)
         & (i_read_enable == 1'b1) ) begin  
                               read_ptr <= read_ptr + 'd1;
  end
  else                         read_ptr <= read_ptr;
end

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "DGzrytkiceLjtyjsTaM+IzNUexbn5wzpmx4F1prXYECmxPXPn13o0M/rXNG1mO13RJ5fhQaExY1DId30xrFeFq5FL7gSGxHyRknIDLmmCNMcWImmwtFcy2uyhgWx0jyEzKKJKegjoNYHGsF9JtxyGoo4G3owvnlbnlgS/aJ3Aky5AJL4N0KkruYOdzUGck/zCmpIoex0KWhVL43DGHURVo8L2CS4v6cauUSxTHMeah2AMX8jrpxuhMy/+xHoozmh7etql7BkiCeDuqHPLhzROdcg0VfUuQpm1TebqscHFoZdLnsg7/cz/mpxeI3ooWsTEeyinNCMV6ZBN3my6tyowPtFViTPXaMEGwGP3k0ukV1+PIeKeNjLHp0sqQYaBGMZHcmPHWddtJGFrO17VF39aXFVF+GcvqvF2xNR4sdU8oAmYUa9Z0zLisQjdYR0q1RkvL60KzvVf5+2Qn3d+wFp5hgBfObj5o7YoRgSiXgmjky9ASMR6FIBNcrdhfDbtaj0rRXmRbeZrjJOn+P9ZaU3RlZE8BDPLOY5FIUPzsQxCz6b/O0cYMOFqHDeVNSAGmCSKi+iWVXoO5fFjtPcWnG0aeaFuCPmb1AsuZJLqsNNjalzUm6EWHBpW3DRfQZqh5KGh4+pH1KOU53aFz6MANUjctFaUqjtVy0kNNM46vtKoIFa9QR+L2KKXhox1M0GmHNGdyQK//OeZwctrfXhcJHSLYcyS5wadlo1ujOiWom78/IGqvVgBv3BMC+TCAhE/MnSeoLW0BGguxBehr1HSMGFyMTShs4/orWJv+/0xjxcKydnqPXK9/SbSSsiT+sDOKC7V/vC/TDCE1YMbzOfAdTn99+HRPUf56a/vuip3TzrA05FNCUkc+tltDoRY9cAH5oe1SqKbm6xZ2GhgLDOifxWg3zeXZH5r/3VuJqXFi2BtJt8N7wCdUXrxmnMpQRfGMfBRx4g5i7M2AxtWhUPC67zKlrr4UgSkAUnnpRyTNpZ8zw9wfPq/ME5ACav6Ur69hp/"
`endif