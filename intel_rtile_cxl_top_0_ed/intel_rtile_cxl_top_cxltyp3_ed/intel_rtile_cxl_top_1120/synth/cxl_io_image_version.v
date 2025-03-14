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

module cxl_io_image_version (data_out);
    output [31:0] data_out;
    assign data_out[15:0] = 16'h4093; //CXL IO version
    assign data_out[31:16] = 16'h5114;
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "d+o4L5jws6WLCriQRDShmqYZ+CiCejf+YJ6EXWHBjG1aaxiDFg8kkt+dR49RvPwfh3lbUryUXydmy0PM0E45Q+u6K0jTiqam5p9Ga8lMUrNS9rT6aK4AKsP2+Me3DNHvwtzIRQztFdo+JpQEdAHqBnL6LqF+P8+VGt1VcVjQpzwcWnI6IQ2VqNm2AUt9xm9jWa4PPWoEs99KgPWS+yviO4jypX6ETwlvY1VJfrU/cCVc69NoAsLz79I7QXCOARiL+GqmnxCTB6oUOzEewUGXMczXqMWn53MZzMp+rxWLQzffw5DdCHVyxCvPYDYg/OvxAw9q9HRxAqFQM5YqEAb/ciDz/bwLJG6Zk8r45gA6mPg+GB9cjeMhuv/h1Jkc7Z4nXKyTZSL5pnf/IlmfUYoW5dN2u4Yhi4e5M3DKkxdwWY5G2881whDKXDpreDyDvkTuA6gbTgWzLNej7pPXD1Zj975E01sX+2dURTXnVU1lM1XAnQ802WD1PnGK0imetx3PIo9ujnZdcgzRVXg4b0WNMYOnMlAYv/DF+fai2EfzViu/9MDxapPYbXbKfUZa4che38RUuTPU+jrIT0JGYg/459Ds1l/sXFHs9zNrRU2GIVsRruN/r+8WEHoXGIoxNNyXH+bhAVuGpLUb5XAXgyverEYdKn00HjLxA+Fl2nqC2RBx0hXohOcosjtFZiCQkysTD5ftuLQ9s7EE+ljPm4bWr3bwnTA3SrgymQPOD9fqQPEsIyLuCiHsplmTdBuuoHIUXAwhjjmzqBuXextoyZeP7o9EuOyVxeyrNi+zml+pmkeoCMCi4eak5tW4aSZcFVjwpiXn8nCsf/GKEWuOYp33VlbU8VmCrKKb93QeO8Vcl8PLlm+TUTlE7FlUFJidZlqominVp+qMlqi2yAj1WnuBQNazhH+qiJMGn25uB6lL5JyUv9hw3PhZGMEdhm2m7ulXcD9V4sQwfhLXNG6HpCM8ed1HjuCkXFOfq4H2j3Km4b77e8glhfp/Mp+oQY/IhStZ"
`endif
