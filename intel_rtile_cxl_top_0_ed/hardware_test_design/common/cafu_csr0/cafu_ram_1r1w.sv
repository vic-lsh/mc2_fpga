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
// Description: Generic RAM with one read port and one write port
//

module cafu_ram_1r1w (clk,     // input   clock
                      we,      // input   write enable
                      waddr,   // input   write address with configurable width
                      din,     // input   write data with configurable width
                      raddr,   // input   read address with configurable width
                      dout     // output  write data with configurable width
                     );      

parameter BUS_SIZE_ADDR = 4;                  // number of bits of address bus
parameter BUS_SIZE_DATA = 32;                 // number of bits of data bus
parameter GRAM_STYLE    = "no_rw_check";


input                           clk;
input                           we;
input   [BUS_SIZE_ADDR-1:0]     waddr;
input   [BUS_SIZE_DATA-1:0]     din;
input   [BUS_SIZE_ADDR-1:0]     raddr;
output  [BUS_SIZE_DATA-1:0]     dout;

//Add directive to don't care the behavior of read/write same address
(*ramstyle= GRAM_STYLE*) reg [BUS_SIZE_DATA-1:0] ram [(2**BUS_SIZE_ADDR)-1:0];

reg [BUS_SIZE_DATA-1:0] dout;
reg [BUS_SIZE_DATA-1:0] ram_dout;
/*synthesis translate_off */
reg                     driveX;         // simultaneous access detected. Drive X on output
/*synthesis translate_on */


always @(posedge clk)
     begin
           if (we)
             ram[waddr]<=din;  // synchronous RAM write

            ram_dout<= ram[raddr];
            dout    <= ram_dout;
                                            /*synthesis translate_off */
            if(driveX)
                 dout    <= 'hx;
            if(raddr==waddr && we)
                    driveX <= 1;
            else    driveX <= 0;            /*synthesis translate_on */
     end


endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "DGzrytkiceLjtyjsTaM+IzNUexbn5wzpmx4F1prXYECmxPXPn13o0M/rXNG1mO13RJ5fhQaExY1DId30xrFeFq5FL7gSGxHyRknIDLmmCNMcWImmwtFcy2uyhgWx0jyEzKKJKegjoNYHGsF9JtxyGoo4G3owvnlbnlgS/aJ3Aky5AJL4N0KkruYOdzUGck/zCmpIoex0KWhVL43DGHURVo8L2CS4v6cauUSxTHMeah1uJtID8srN3iOdcBqeiLOTROP/1mHaeDL/HVoS1mGiVPNW1rQCtTGpU8t7+soSe1nFpLFad4wtaxcY5Vn8SI2sp0z6EWvEDZX1uoA5AeFAHph9hhvAwv8xJHrwz4MNoAVahroa5jV39fZn+Aq9wNoO/OAdP8Kgs8BrTBhBODvbxiD3tFZJWgQwIloBOvDS5jw3tKhqKZLzKc0UgXTyDKbRrfvATrH6ZyFFVasnLJjyWGNQ+FLjuck10NT4qdcbIOoIykShIOXtleSK/Rz6BiLgsooiJy3FwUf+c7sVkg45H3swOhf7UPYq6HLsnNmyP+I3+TKIwjfQcpDD+CnNn1pBcqgsooEDO1AGlxX0otM8164ltGJuIcjmG+hUciODknt86bGYLxMrF8+OW/Cp1YUICjm7TMssGWpoGinPE1o/PSSqNN4FR1WwEeGOgYXIm30SfV0JG7oF7Jzvnfmxmlf76xyC3+FgnYxqVpO7os5r05cukbb6u+iMLl+zVgbxIKH2hc0Pk9qyFrUTKUPh4cerW2CVZ+A5ZbA+pSRMHkVwXHzHIU4WAP9eqctVFoNPrOuvo9WiWJc5iZ/l8nk3odtVqjP/Bc+RIZcSEPILOsgZN9OpMjvg4+U47Ijrk0vJH/CO/2yIDsqxF9CpcWZpq+uB6O7r2pk0YUrBgxaykP4snqQ3ek9ytB/2V3EETRk8b82gneW6giKB+AaCnRowGZ18USMdgJ3iyuKLAh5fpww4wSU/WNI6mUHKiyg20fZV9ld0/KJuPTkNHkibsoyHS5FI"
`endif