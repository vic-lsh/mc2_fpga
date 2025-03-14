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

/*  Page 602 of CXL 2.0 Spec
*/

module verify_sc_compare
(
    input [511:0]   received_in,
    input [511:0]   expected_in,
    input [63:0]    byte_mask_reg_in,
    
    output logic [63:0]  compare_out
);
   
logic [511:0]  compare_z;


generate
genvar i;
    for( i = 0; i<512; i=i+1 )
    begin : gen_compare_z
        assign compare_z[i] = ( received_in[i] ^ expected_in[i] );
    end
endgenerate

generate
genvar j;
    /*
     *  do an binary OR of each byte to see if it has a mismatch but then
     *  AND that result with the byte mask index of that byte to see if 
     *  it is a byte that is enabled
     */
    for( j=0; j<512; j=j+8 )
    begin : gen_compare_out
       assign compare_out[j/8] = |compare_z[(j+7):j] & byte_mask_reg_in[j/8];
    end
endgenerate
    

endmodule

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "jgUY1TOzAui2kWGBWGId0qwlRDt/QZM+8cUCMzuqn4bRhK94gT2qOQTeFRI4g2b1oJ8t/dDILql2HY30uqmJb1jubHnd0oqI9NzF5dRB5GvwUt009aa+CM2om/l0CIO9QdcgEVsdHT5CaQJFzy/RTiHoncrLDYom5U1fLRwlUT9DdWE/Gm1BAeenEazOxoTduIzvP4QOOxqDy37ltJB6oA8RAnX5BEqihz2WQlV0fiLMUPGfLwx64BG95j1UF5hko0cGD78Ya1rWpBiRLZtxocOtYiVZePcAEyzCqpqcgl8mHhN8TSKVLWZjPj7luUfZfxPz1eEiSPmlS7+L4FVtPoZrBtJoBnGRAuC+/GwEFotVXlGQiC2koCR8/2Hu1icoreJKpzgpuO3CcvETpQGI7fdk2ZwBS5tStKGTAgbwwQtetIao+bxBCRbXeeo2RS0gFfed7oYxvpr30ixxNjsq0cpOvPizppKAKlLR/MrfA+1+0B7gCKlB7sOZTj+6iSoI74Uve8W8w+B6YJrs7toQubERgrXDoKG3qCEtqzXlWkDf9Yd9U4qOu/L4gp1wYwgBXhc9RqaZoN6rq9Cq3UEscfEDmeQj+Op9y3Mbv0/mykwjatBvvZiUpaPd3ZVm1DZjnQslJmWfJlSA+KTluV4GqYQImC3RB+sYBGXxMI8wB3mvV0Nv9vujQ191uTmimg856i8xnqg3wU9k9BYKgfDXnJUZG5CL/PrSOw/I97fp3gB7IygsVVRGvg1m9WAPh32ccTTIIlVdQfs+QQ+ys4w0jj3TNlCJaLZrK/VHK9UqkyOEg+GiTpw6rQmaTQDOmc49rlWTdR1p/dYCmodfsIvgDwBhC6OqD7gpQzzx0sdlNmTfOB1SsyU35NtAclIVyT4RKbjvR7bxzHA549yuMzZfxBfE2X46SBU/NOA78To6vRJuQUNLCaIUUwuVr9M7VO4ahdWBqTapfMTVBEHMDfqUCeL0q/XcnZajm44EvV3LL0kWAjy6bVwDoy/izX+4ooWu"
`endif