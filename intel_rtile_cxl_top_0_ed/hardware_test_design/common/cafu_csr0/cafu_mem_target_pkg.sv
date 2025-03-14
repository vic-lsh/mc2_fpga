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


package cafu_mem_target_pkg;
    
    localparam  CL_ADDR_MSB = 51;
    localparam  CL_ADDR_LSB = 6;    
    
    typedef logic [CL_ADDR_MSB:CL_ADDR_LSB]        Cl_Addr_t;
    
    typedef struct packed {
        logic [CL_ADDR_MSB:28]  Addr;
        logic [CL_ADDR_MSB:28]  Size;
        logic [3:0]             IW;
        logic [3:0]             IG;
    }  hdm_mem_base_t;  //used for address decode in fabric_slice 
    
    typedef enum logic {
       TARGET_HOST_MEM     = 1'b0,
       TARGET_DEV_MEM      = 1'b1
    } fabric_target_dcd_e;    
    
    function automatic fabric_target_dcd_e fabric_target_dcd_f;
        input Cl_Addr_t        Addr;
        input hdm_mem_base_t   Base;
    
        localparam ADDRMATCH1  = 'h0_0000_0004;
        localparam ADDRMATCH2  = 'h0_0000_0005;
    
        logic [CL_ADDR_MSB:28]      shifted_addr;
    
        //shifted_addr = Addr << 22; //since CL Addr, shift 22 instead of 28
        shifted_addr = Addr[CL_ADDR_MSB:28];
    
        if ( (shifted_addr[CL_ADDR_MSB:28] <   Base.Addr + Base.Size)
           & (shifted_addr[CL_ADDR_MSB:28] >=  Base.Addr))
            fabric_target_dcd_f = TARGET_DEV_MEM;
        else
            fabric_target_dcd_f = TARGET_HOST_MEM;  
    
    endfunction    
    

endpackage
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "DGzrytkiceLjtyjsTaM+IzNUexbn5wzpmx4F1prXYECmxPXPn13o0M/rXNG1mO13RJ5fhQaExY1DId30xrFeFq5FL7gSGxHyRknIDLmmCNMcWImmwtFcy2uyhgWx0jyEzKKJKegjoNYHGsF9JtxyGoo4G3owvnlbnlgS/aJ3Aky5AJL4N0KkruYOdzUGck/zCmpIoex0KWhVL43DGHURVo8L2CS4v6cauUSxTHMeah3a9UkjjSz34HxhIW7q0Q/224E1O3n/WmhMpmI8MTDB7wyF4mI4B4/rXg8YKFHgftgl7Uq6hjI83BTsX52B7AVDn9Iu2bfVlj5v0BBG1bfjFgJ6EFxs81sLKP0ytSL3jy7z4KGqsLQYqGtuepKPjVW72VCe6PxHfIR6ZkxuMGHCHeG7ND2OKx2XnAGy/x60NFToc5xK2s0nkZNSGfpryiQ/LIRnm+1ySxM47MninngAYsWBZXwjt+mO1HOtTfJrpawpbUFiLHMDyQRtT6b33hPD9/ffSuhI/sPhYBcAmg1NO/6+aVto9Zh5jfscNZkt5Rrqbqodb+WoprhfQT+YyFkx+AvF1XfmqA/OE3TjThRUUGRQ8AgEvi8B6IxO7iMh7oiVd7jmVgiyHN7f+1Ru0MNcG4Db/WRyLo+Qx0Mwec02ZeaPMBxKy6p/IcBaVjfvZh0loSJh4dreVwRcDxFX507g1nukIVQ2lim42FwHiUqcp5Jxah1KQ3Oabj0zxTbzcwsxP32Vr2zZe3MLPpVkP+Ny09nTePaXQ1yA+moizUkdPQ7Wn/9pmAsK7jf4h/wVNGXitGO+Pyc+nrv6hDu1l1RQr/eRiQWbkGkCautlom8bThcg4qocgxEAEBeNMMUJiMfXubCUrrA2zQpFRdHTGtDDRT6B8h5tCu4WfCbmBBKPetOQyDEqrFIIg05ueEjv7gF6//2JaeXcs9aBlztd3Ah9hQUTty+riMyCnJ6of3ra0Pk+7729gNg0nybgde+Xl99DK5cMUvQJY4fU/znvt8HR"
`endif