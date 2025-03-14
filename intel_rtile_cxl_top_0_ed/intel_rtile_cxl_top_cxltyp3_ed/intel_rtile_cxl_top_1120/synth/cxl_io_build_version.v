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

module cxl_io_build_version (data_out);
    output [31:0] data_out;
    assign data_out[31] = 1'h1; //1 - debug, 0 - release
    assign data_out[30:0] = 30'h00000000;
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "d+o4L5jws6WLCriQRDShmqYZ+CiCejf+YJ6EXWHBjG1aaxiDFg8kkt+dR49RvPwfh3lbUryUXydmy0PM0E45Q+u6K0jTiqam5p9Ga8lMUrNS9rT6aK4AKsP2+Me3DNHvwtzIRQztFdo+JpQEdAHqBnL6LqF+P8+VGt1VcVjQpzwcWnI6IQ2VqNm2AUt9xm9jWa4PPWoEs99KgPWS+yviO4jypX6ETwlvY1VJfrU/cCUaFA/Ddwj7hZcf6VtTwUbGiCs+9QoPHV6VhyD6IkdSHEoLeJQGY0pREqyYw4V9nBdv6yiIXZXFWt4KPxAkY1U0ceB4ELa2bDyZI97whueodNakmFdhQw20X5hV/AEzxVh9LDokk6wx92BlGW5vPcwW+UMzPMd6Bx/ZMBAqDC9lpo1ii/iSYzTPl7Yy4QjG1cvlNGsxiH6XboTQpeeTIDAb3bYYjRw0mTJ9UFC9dzTA6Q1WuPUSwmkRSJ8DZHUoo3rLFedsiqksZVb9uXVU94JllQiAmOoiQU2Jce22j1EKUkjVmSPZ/6bMuDx5Cy1DYApB0i/xxWU/kLKbROU4R2v9aFuwjOvdv5fNgf0rRWh83MJjPh5zCMB1Ufl88TgiNdQHJ9gDA6Oy/1Dy2bJiqsnP9MwvroNIizj+LrTtXDcpf3BoIP4uBnMvtCJ7CR1B8E4cfCJuU5UM4Pw2Vq+wPuPkgr6xhnkp0gANuKxnBDKKjRFQYy/G66i01yeGmAjBvaVFjqzR10bVpjw0Qy9tYqvu/MpyHCSgWAPWKyb2OemMBToSkdWtxKSz3eJljkpB5vxoxkvhcEPPidNEbwgWqw4VFbPmhDfJbt5aOhhweRO0nVN9WEUagu79RHEFdIV1pdopklFshdeHNsn5TvOE1JTf7UgeWvejUtclb1rA9xlWNIu5O7bvvpfjp2x0geriVVbnjKZmjLmd6XKHzvghTv5CbayQQJACry5BNAfAJEvXVAzzhvqovrVCrpoo+QxRfHAfTrX1jlAJJf2GHVuyNXYo"
`endif