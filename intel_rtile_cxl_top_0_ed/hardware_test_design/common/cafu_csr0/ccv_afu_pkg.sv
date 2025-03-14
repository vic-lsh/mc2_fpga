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
/*
  Description   : FPGA CXL Compliance Engine Initiator AFU
                  Speaks to the AXI-to-CCIP+ translator.
                  This afu is the initiatior
                  The axi-to-ccip+ is the responder
*/

`ifndef CCV_AFU_PKG_VH
`define CCV_AFU_PKG_VH

package ccv_afu_pkg;

//-------------------------
//------ Parameters
//-------------------------
localparam CCV_AFU_DATA_WIDTH   =   512;
localparam CCV_AFU_ADDR_WIDTH   =   52;


typedef struct packed {
  logic illegal_base_address;
  logic illegal_protocol_value;
  logic illegal_write_semantics_value;
  logic illegal_read_semantics_execute_value;
  logic illegal_read_semantics_verify_value;
  logic illegal_pattern_size_value;
} config_check_t;





endpackage: ccv_afu_pkg

`endif
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "DGzrytkiceLjtyjsTaM+IzNUexbn5wzpmx4F1prXYECmxPXPn13o0M/rXNG1mO13RJ5fhQaExY1DId30xrFeFq5FL7gSGxHyRknIDLmmCNMcWImmwtFcy2uyhgWx0jyEzKKJKegjoNYHGsF9JtxyGoo4G3owvnlbnlgS/aJ3Aky5AJL4N0KkruYOdzUGck/zCmpIoex0KWhVL43DGHURVo8L2CS4v6cauUSxTHMeah2pvnhNK/zlhbkCFuev31gq5g45NiC4bFnwoK+5o1qGz0dsIYm3R7gfz8m5LBQ6qCq8Xe4fL6UHSVKURp0vW0WX1JPj4sezfVnaKTlPhRx017AzyUXkU6qO8mkiaZjrZ7JfTFHpK0524xlvRnXkRclxD7ddc8s/t+9OlabOkNbewVczUE7qkPZW17Bi6o81qILjRPSg5ABd956vPbl8vl5xiOaY66E4VaAW1tAKCsoJsfm7kZ22kD5oepapoyPEDgPm+CyfM++TSaXDxOtyndI+0R41N7En7QGMewnetH67C39yhK2tynm3XgX+pSc3sFZpB4M+HGcyMkXinwxCd8zAGdiFCyPVCoG//U6ghR8Dv2qoVJsDS8z/e1Q2VfX0+DIok9w/Dx4lnF8r9TtmMiKBRauSmC9SnSae8Jpb9zeZkNvr0i1EvJCDSuv6XToET/fQkQrCu2hLrsDK2jK+AkiGxEHH9gN13a9z/bxD5nhTOdA0EyEMD2865Aq9utk222U/tKoA9iipL2VuPj2TpzzNp0fQFUBAJXx8B4jUvvtQ2vR+gu1XV6oqxKxQVLbeFZSpHaH1aaIQmmdCHA5gt5W/uujrwryuFjPnZzx6q1gjOTEOAeBl+eYzhgZCvN5dIpJuEJjYiBNiUflkZg2vW5g95Q/j+p4UuAiOCMtsujvLt9e9RzbicGsbkkwQ+eOzqxb3UO0U4YAxR/yF5E9zkKJApiCNk8jxys4O7YswE4ThJAyTh4wjm+cFGLnZ6+guOEsBZ+YJLv93wcW3cIf9Dj4e"
`endif