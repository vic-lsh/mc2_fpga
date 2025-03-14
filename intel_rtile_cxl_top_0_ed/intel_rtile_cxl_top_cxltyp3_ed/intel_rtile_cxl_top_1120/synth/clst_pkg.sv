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

package clst_pkg;

    typedef enum logic [3:0] {
        CLSTSTATE_I       = 4'h0,
        CLSTSTATE_S       = 4'h1,
        CLSTSTATE_E       = 4'h2,
        CLSTSTATE_M       = 4'h3,
        CLSTSTATE_IMPRECISE_IS = 4'h4,
        CLSTSTATE_UNKNOWN      = 4'h5,
        CLSTSTATE_RSVD_06 = 4'h6,
        CLSTSTATE_RSVD_07 = 4'h7,
        CLSTSTATE_RSVD_08 = 4'h8,
        CLSTSTATE_RSVD_09 = 4'h9,
        CLSTSTATE_RSVD_10 = 4'hA,
        CLSTSTATE_RSVD_11 = 4'hB,
        CLSTSTATE_RSVD_12 = 4'hC,
        CLSTSTATE_RSVD_13 = 4'hD,
        CLSTSTATE_RSVD_14 = 4'hE,
        CLSTSTATE_ILLEGAL = 4'hF
    } clst_state_e;

    typedef enum logic {
        CLSTCHGSRC_CAFU = 1'b0,
        CLSTCHGSRC_HOST = 1'b1
    } clst_chg_src_e;

    typedef struct packed {
        logic [2:0]            Rsvd;
        clst_chg_src_e         ChgSrc;
        clst_state_e           HostFinalState;
        clst_state_e           HostOrigState;
        clst_state_e           IPFinalState;
        clst_state_e           IPOrigState;
        logic [51:0]  Addr;
    } clst_attr_t;

endpackage: clst_pkg
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "Fidd1oyAhusLLJ6+7Y4fW+UxvqV+8TisWbzB76p8J7jCbedVkgTXiBKrUzNVBIRDckfBwS/gk4qyrpXnk44TsazVN20DO3TdF1x8MmH2pGcTjxrJqgYV/z3UJLaYPiY1WrKUNRPOAuHkyYvfI5GoAsKohhmpB04sGLV6+cGIymx/RXK+eIUgAROf9S5AOXsk1U/Lqv4gR7i2yfj3c/IhJWMX+Ld3X1LJ1lp+Ly9OQozz+Y9L/2Q539kf8mg++CG3tnB17EJ8BSVm1fltRaVW2yRRl2hMuaWa2tJrZre2JMEaQTuQnWTnIG+ZsV934QykhhL+cDnqz5/UGrWDYdft/Z3ND6j4lazBbILkytPY1bpUVWNnYkRVrrZwvm+Q+VQpblAjU+p++yJXhxydaFg8YG+bE2Nwv/i+rG2hykG1+lrrCsNy8yx9BtPg20t08pRn4dSh+ixF2ntPq6SraYLJljchZjqIFtepP0w16V8dtFM6Ko1yb5Blr1PxQ+f9n27XA70Ffhm8HaQs3jUwnU9JXcZGfFzXcZ1qS5+PkYNelUoMyezzcW2ROBHwFLS+b/X/Mhd8sr5pto4FQeHDPOFcIjU1VmY44vk3CQ6iGJDPhu9mewFy32j0bWkKf4Hylssd7oBCcBaEjv0aaZgKoFsV35FlQGfQnXZoZUNzjigSJCU30XPiFahwmALSf1TVZcqThIG6FoD/TeG656eOgstz3IkSMOH4v+nWsayuCVodHrvwOcv00/A0k8l+9FBMNEryk3trjjoNgBVvyjQuEbU4hnKHfg64yqDHNY8+7XbJtKhYqvvoS7y7Mw9tGvJCSOMnB8CqNbdcdpIDVMFe6v4OkNzGDIlysHflkSUWR15iDjWlytcmnhshYgKvmzFrkV/1yq/C9DsBM96J0BKaBieOpWwF+X6UDIRKKTlkDLOQfK65rY6zyhONCfso9MB7RrWtbRkdy6vlx9Yk/etcM1Xx7AhU3KYbelB3/KDJ8/T1NcomCWrj0dS9m0Z/hQ2Ujp0h"
`endif