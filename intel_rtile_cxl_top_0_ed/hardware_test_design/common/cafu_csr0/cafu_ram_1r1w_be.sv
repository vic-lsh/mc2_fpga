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


// Copyright 2022 Intel Corporation.
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
// Description: Generic RAM with one read port and one write port.
//              Write port includes byte enables.
//

module cafu_ram_1r1w_be (clk,    // input   clock
                         we,     // input   write enable
                         be,     // input   write ByteEnables
                         waddr,  // input   write address with configurable width
                         din,    // input   write data with configurable width
                         raddr,  // input   read address with configurable width
                         dout    // output  write data with configurable width
                        );

parameter BUS_SIZE_ADDR = 4;                  // number of bits of address bus
parameter BUS_SIZE_DATA = 32;                 // number of bits of data bus
parameter BUS_SIZE_BE   = BUS_SIZE_DATA/8;
parameter GRAM_STYLE    = "no_rw_check, M20K";


input                           clk;
input                           we;
input   [BUS_SIZE_BE-1:0]       be;
input   [BUS_SIZE_ADDR-1:0]     waddr;
input   [BUS_SIZE_DATA-1:0]     din;
input   [BUS_SIZE_ADDR-1:0]     raddr;
output  [BUS_SIZE_DATA-1:0]     dout;

//Add directive to don't care the behavior of read/write same address
(*ramstyle=GRAM_STYLE*) reg [BUS_SIZE_BE-1:0][7:0] ram [(2**BUS_SIZE_ADDR)-1:0];  //ram divided into bytes.

reg [BUS_SIZE_ADDR-1:0] raddr_q;
reg [BUS_SIZE_DATA-1:0] dout;
reg [BUS_SIZE_DATA-1:0] ram_dout;
/*synthesis translate_off */
reg                     driveX;         // simultaneous access detected. Drive X on output
/*synthesis translate_on */


always_ff @(posedge clk)
  begin
    if (we)
      for (int i=0; i<BUS_SIZE_DATA/8; i++) 
      begin
        if (be[i])                
          ram[waddr][i]  <= din[7+(8*i)-:8];  // synchronous RAM write with byte enables
      end
    ram_dout<= ram[raddr];
    dout    <= ram_dout;
    /*synthesis translate_off */
    if(driveX)
      dout    <= 'hx;
    if(raddr==waddr && we)
      driveX <= 1;
    else
      driveX <= 0;            
    /*synthesis translate_on */
  end


endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "DGzrytkiceLjtyjsTaM+IzNUexbn5wzpmx4F1prXYECmxPXPn13o0M/rXNG1mO13RJ5fhQaExY1DId30xrFeFq5FL7gSGxHyRknIDLmmCNMcWImmwtFcy2uyhgWx0jyEzKKJKegjoNYHGsF9JtxyGoo4G3owvnlbnlgS/aJ3Aky5AJL4N0KkruYOdzUGck/zCmpIoex0KWhVL43DGHURVo8L2CS4v6cauUSxTHMeah12+AxB4D1TiPFVcDcJjuQoKI+yuuaK9IPJOu4Hv7KkTYp+vkyya77kwxx+GkGKpVwS/pwbZYkvx9kr9eL+2vbg81cbGfre/FV85NMNbRdaH1Dl9qT16+t1ttX98L5YoegNKv4YkikQK97PFMCz91JfE2MwPlVvA4KATj7fFgfV8PTfjX8YE1cX9uwleEwnvjkFjxfi1CAR1bW4QpqQqWpyc1bm/DsuHgIMTBf+8FtSu8+mhZYeB1ZeilVqoo3DA2v4jUhIqZnb7VYobuSv9FpWEB1lkjrWR9vX8r2tmjRPyqM6KSpZ2PnItAi+kHxDrJUKh9j5/35bI/ssoMpQANcHzuaa1ME/3vt3jKB1B4l5xDWbmi/omGG6XhkGI3JSIo84GILwXGThzuBsI05CTaVu4bURhrovlJmCLBJz1sl3PKClKpZZJFVbY3XoX4/8VoPx+1cNJIz3UGS012nB1BwC3Up7yHNXx//hFR9JFvaRL/TAQ9BdyarjBmQHm7zwMkK70wzUYw1y3g68o3pevQmNEIObHspt05fu4nidRMy1wUkvhXwGs2Ev2Vx/ymbP82EE9IebPTg0E+uHoQneqgJnxpq6PUicTb8dK3ZKqvl6a/fUUxSsS263kF4YjKB2fUqA+GGawZNgBKs7inDCKtD3z/cZV7VS7tQl7OyfhNdP5osksG21LTEvo8wLhW87LSxiWw1kzJTMhxWZOI7AZrAH0yDzJecibkZsfY61cosCdAXtT421ZfqnQg2uYQ5670oMo5h8YcVHFe3hLfz7lrnG"
`endif