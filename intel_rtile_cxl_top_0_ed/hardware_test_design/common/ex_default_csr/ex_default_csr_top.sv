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

module ex_default_csr_top (
    input  logic        csr_avmm_clk,
    input  logic        csr_avmm_rstn,  
    output logic        csr_avmm_waitrequest,  
    output logic [63:0] csr_avmm_readdata,
    output logic        csr_avmm_readdatavalid,
    input  logic [63:0] csr_avmm_writedata,
    input  logic [21:0] csr_avmm_address,
    input  logic        csr_avmm_poison,
    input  logic        csr_avmm_write,
    input  logic        csr_avmm_read, 
    input  logic [7:0]  csr_avmm_byteenable
);


//CSR block


  

   ex_default_csr_avmm_slave ex_default_csr_avmm_slave_inst(
       .clk          (csr_avmm_clk),
       .reset_n      (csr_avmm_rstn),
       .writedata    (csr_avmm_writedata),
       .read         (csr_avmm_read),
       .write        (csr_avmm_write),
       .byteenable   (csr_avmm_byteenable),
       .readdata     (csr_avmm_readdata),
       .readdatavalid(csr_avmm_readdatavalid),
       .address      ({10'h0,csr_avmm_address}),
       .poison       (csr_avmm_poison),
       .waitrequest  (csr_avmm_waitrequest)
   );

//USER LOGIC Implementation 
//
//


endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "DcjSv4cazWNFeTq2LDzhR8VVA2vsU+D2FLr5cau2M2bJ+ymOMJzu0j4X+D7sDofwwnGT3dC9uPfUfqUyT+1JDqgoqF4+Hm1+DbOqZuomBxMc/3ubRV7jR7LhS90CAIiftZSupMkt7Z6NB7tsmbvAu3Uqtxlo+Ag4QRIgi49yVFsS2wB30qw4GeL5di6t6OjbvWcjLtKHJMZ/Vew3QCsc9aW8Cap9TcP/4lTkJB8MFTicZPWQeumJonayx2JMgOTnpapSpEHZCSifgSD2LuJLGEZT1dEGydWhhG6vY0G8NdhQ8us1cWDIVk5liFY8c/7t9ry4zFqvHu2S+p1aAWjDRpLpFYPsg5pjSHIJgA8tr7qE48QEp1wy2uVCbtcRG1/rkhnJyUHIxXDxSi4oE33DgdnijsKiWCoiBtu9ykaB0+bg0G7Z4z9OODC8gXzBSsMUjhT40XOQjSllFfKjC5iMmR0IIzIajGvFBqQqAp1Xp4Z6M5AqPw6XXJJEInDazTfYdCHyJaf3lvHguSgQ0gx+aQiL6FSOnso1IrYDhwGve1M4SrgmOBwRRPw5lSXzb7LiFT0tiWO/cNt1y2hKs463kuGEIGH/0KIpTrkWaEpQRifAJQdiDJXhabuXZHO646K5HGwpe+YeeDv/FEQsSiTUCgtowmNIMypw6nnF/QxC1qSiVchMKzAIwkCGflZJ5jvbj/p/q8Ew/FLmh0+qVCTgKJld73cFPhHAFQSMWhFbULzOF+uR7YiFIKc038UPegaapXhFClT9g3iaAyIgh1BtiWwCj0wOlSeIVjVS+qbQU9vSy9fhWkodAV7gpMLv9Mok5XQVlthV0aeINzLvMRwYGnX00URXrsV0DFDZANkelrkkG3+P5PKBufdwp+EBXWGx8o871ZCCEa5Nk2wP57IJfG2ym4TYvjWlRn3LbXae+YGFqclcUsmWnfQuFcLyyZRKQaL+xKOKnnQoIJJ95SdqkKMNkAddLdTC5HkSbBFMRx3ijYk8ssvSQO2BdNVnkCOI"
`endif