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

module ex_default_csr_avmm_slave(
 
// AVMM Slave Interface
   input               clk,
   input               reset_n,
   input  logic [63:0] writedata,
   input  logic        read,
   input  logic        write,
   input  logic [7:0]  byteenable,
   output logic [63:0] readdata,
   output logic        readdatavalid,
   input  logic [31:0] address,
   input  logic        poison,
   output logic        waitrequest
);


 logic [31:0] csr_test_reg;
 logic [63:0] mask ;
 logic config_access; 

 assign mask[7:0]   = byteenable[0]? 8'hFF:8'h0; 
 assign mask[15:8]  = byteenable[1]? 8'hFF:8'h0; 
 assign mask[23:16] = byteenable[2]? 8'hFF:8'h0; 
 assign mask[31:24] = byteenable[3]? 8'hFF:8'h0; 
 assign mask[39:32] = byteenable[4]? 8'hFF:8'h0; 
 assign mask[47:40] = byteenable[5]? 8'hFF:8'h0; 
 assign mask[55:48] = byteenable[6]? 8'hFF:8'h0; 
 assign mask[63:56] = byteenable[7]? 8'hFF:8'h0; 
 assign config_access = address[21];  


//Terminating extented capability header
 localparam EX_CAP_HEADER  = 32'h00000000;


//Write logic
always @(posedge clk) begin
    if (!reset_n) begin
        csr_test_reg <= 32'h0;
    end
    else begin
        if (write && (address == 22'h0000) && ~poison) begin 
           csr_test_reg <= (writedata[31:0] & mask[31:0]) | (csr_test_reg & ~mask[31:0]);
        end
        else begin
           csr_test_reg <= csr_test_reg;
        end        
    end    
end 

//Read logic
always @(posedge clk) begin
    if (!reset_n) begin
        readdata  <= 32'h0;
    end
    else begin
        if (read && (address[21:0] == 22'h0)) begin 
           readdata <= csr_test_reg & mask[31:0];
        end
        else if(read && (address[20:0] == 21'h00E00) && config_access) begin //In ED PF1 capability chain with HEADER E00 terminate here with data zero 
           readdata <= {EX_CAP_HEADER} & mask;
        end
        else begin
           readdata  <= 32'h0;
        end        
    end    
end 


//Control Logic
enum int unsigned { IDLE = 0,WRITE = 2, READ = 4 } state, next_state;

always_comb begin : next_state_logic
   next_state = IDLE;
      case(state)
      IDLE    : begin 
                   if( write ) begin
                       next_state = WRITE;
                   end
                   else begin
                     if (read) begin  
                       next_state = READ;
                     end
                     else begin
                       next_state = IDLE;
                     end
                   end 
                end
      WRITE     : begin
                   next_state = IDLE;
                end
      READ      : begin
                   next_state = IDLE;
                end
      default : next_state = IDLE;
   endcase
end


always_comb begin
   case(state)
   IDLE    : begin
               waitrequest  = 1'b1;
               readdatavalid= 1'b0;
             end
   WRITE     : begin 
               waitrequest  = 1'b0;
               readdatavalid= 1'b0;
             end
   READ     : begin 
               waitrequest  = 1'b0;
               readdatavalid= 1'b1;
             end
   default : begin 
               waitrequest  = 1'b1;
               readdatavalid= 1'b0;
             end
   endcase
end

always_ff@(posedge clk) begin
   if(~reset_n)
      state <= IDLE;
   else
      state <= next_state;
end

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "DcjSv4cazWNFeTq2LDzhR8VVA2vsU+D2FLr5cau2M2bJ+ymOMJzu0j4X+D7sDofwwnGT3dC9uPfUfqUyT+1JDqgoqF4+Hm1+DbOqZuomBxMc/3ubRV7jR7LhS90CAIiftZSupMkt7Z6NB7tsmbvAu3Uqtxlo+Ag4QRIgi49yVFsS2wB30qw4GeL5di6t6OjbvWcjLtKHJMZ/Vew3QCsc9aW8Cap9TcP/4lTkJB8MFTiEW+iK9t4hZyCrO+ZZJjHEY1a2gHQGVIsLH6o/4781ne4TAsTIqcLzzoaRwY0fdsNhUzDCsllcqPHtB3/q22QX/cSW7B3ehV46ZhTLRsfYAYGR/YRWg4C+hxX6MgcmEux04nQkwyAIjWRih7kpAeVnkLMAsHiD+t/GT1J+b1W7ZTYe9QrNzRHgMCdTgsKnpr02VWJEAGbLgy0yShK2URmwsKi0RYVrmk3MI3vFqruvRDKAN4nY3M6vlT+zVCym1wi+nCkOkajywcrqP/MEULXxLNeTbrrBliu1T1COrlDgozAe+kwq54/cEPYUZYuBckrFku6KUc3Ncsz6z2n5wID84F2VdjOSVNBUlNrr7xOuLOH8Aent61kgoaeC38bxu/1ERbRepGugm+z2gTWv3I+d/2QNDPZRIsmKGz64yaKVTdQoNZ4CFE685oQoKVXAMtW5fU/7RQWMvNUFjTPW2bgDSz8WI1DgqO+QRZjdzvtO1mm/BSC6Xz+1OVXEPeugvLHILJQaq28PDmI+EzsCiu1cxDXbo0Pbt5cJYljzbXQGGK9yaqI0SDFBLW9bS1CJg3L+eMIVRcFqn2aH/NQ057/k95s50nB/Tds06w8+JRbbEfIdhchJd5OVHGj3fheJvKiD9P52vhKFoe+osDl+8iGmKWEFJGRVBcpnxu7pRgGhLYOL+tOnlinAkkt6c+H1bwBiyOMb5hcaqxlsIuy4mzI6RzuGXYRZ/1Wc2OAL7/MGBm13mkk0ulKN+zDJ/lN2yxauMSlvNL3WzluomdUTvUvD"
`endif