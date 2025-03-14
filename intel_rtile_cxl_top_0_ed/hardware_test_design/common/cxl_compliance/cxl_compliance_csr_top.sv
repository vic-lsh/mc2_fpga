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

module cxl_compliance_csr_top (
    input               Uclk,
    input               Ureset_n,    
    input  logic        csr_avmm_clk,
    input  logic        csr_avmm_rstn,  
    output logic        csr_avmm_waitrequest,  
    output logic [63:0] csr_avmm_readdata,
    output logic        csr_avmm_readdatavalid,
    input  logic [63:0] csr_avmm_writedata,
    input  logic [21:0] csr_avmm_address,
    input  logic        csr_avmm_write,
    input  logic        csr_avmm_read, 
    input  logic [7:0]  csr_avmm_byteenable,
    input  logic [31:0] cxl_compliance_conf_base_addr_high ,
    input  logic        cxl_compliance_conf_base_addr_high_valid,
    input  logic [31:0] cxl_compliance_conf_base_addr_low ,
    input  logic        cxl_compliance_conf_base_addr_low_valid
);


//CSR block

   cxl_compliance_csr_avmm_slave cxl_compliance_csr_avmm_slave_inst(
       .clk          (csr_avmm_clk),
       .reset_n      (csr_avmm_rstn),
       .writedata    (csr_avmm_writedata),
       .read         (csr_avmm_read),
       .write        (csr_avmm_write),
       .byteenable   (csr_avmm_byteenable),
       .readdata     (csr_avmm_readdata),
       .readdatavalid(csr_avmm_readdatavalid),
       .address      (csr_avmm_address),
       .waitrequest  (csr_avmm_waitrequest)
   );

//USER LOGIC Implementation 
//
//


endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "DcjSv4cazWNFeTq2LDzhR8VVA2vsU+D2FLr5cau2M2bJ+ymOMJzu0j4X+D7sDofwwnGT3dC9uPfUfqUyT+1JDqgoqF4+Hm1+DbOqZuomBxMc/3ubRV7jR7LhS90CAIiftZSupMkt7Z6NB7tsmbvAu3Uqtxlo+Ag4QRIgi49yVFsS2wB30qw4GeL5di6t6OjbvWcjLtKHJMZ/Vew3QCsc9aW8Cap9TcP/4lTkJB8MFTgS2geADimcLBhs6t8eiDjkQvV/rAuNsGNHo3LqnS80tekwsNn6KfwFYogk8mzZF7yv6sPeT9mSd4MfLm9qIuRFXz9w4QUS01TaU/N0GJXNmu2enRHyRmkf5UBB93isxvcIWvBEiN2NcoP0BYIXKgE5ds7FKR3m9MOIpy1/0LocYMTnj2lFgyrBpLUgn9YKjiFudxYgFTchvOlqwKT8RMx5/BkpPSYkyQmpE5nKNd9zs1IBl46/oKZcV0N/xBVP+1GzeAhKlF3AZuTM5j/Oe7LdNfkbmafLy0qnp/p6/0Jbrr8AXzLRKYj6V+JjdIOquOzqn5Or0UiVj0w5HZCJhd944VRUv4FxccBUePdO0Q/z5vhH/zPBmL0oSNMfootx6+iDmh7hDWuvvf5SyVdvM0gbSYCdfcDOY8XlBAdIH6FZ4GFBNj3v6SSdITSjjsNS8w3K34VFxCim8CYQbNxljTaygRO6ZwGGOivGIWQH64O8V8cO8IRobn8wjCPVI3duzkW8D8RrTZmHLv+qUvWY0pKS+3YNi5psCH56mrt8kdsCPZpi53zpHFhk7RudeNu6HV+j0TFpg8iOqXUIct3PWKkB2hy+co1wmS4M7ADkV8L2qElxGV+ISHJujQx7kzhVXBbSNLqzHndIZNYDWfFzWoo9iONpefpr7gy3AQgupZpCJw/GV++thD7wNAuQNGfjXlukGgqzSbMjxtoQKrRRv80Ada21EBa81UIJ+2oBty5sb1n+ZqXiEwWTVh3xqSK6UWiJzTv5JpGBlSybRFltk6PZ"
`endif