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

module cxl_compliance_csr_avmm_slave(
 
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
   output logic        waitrequest
);


 logic [63:0] csr_test_f000_reg;
 logic [31:0] csr_test_fffc_reg;
 logic [31:0] csr_test_f00_reg;
 logic [31:0] csr_test_ffc_reg;
 logic [63:0] mask ;
 logic config_access; 

 assign mask[7:0]   = byteenable[0]? 8'hFF:8'h0; 
 assign mask[15:8]  = byteenable[1]? 8'hFF:8'h0; 
 assign mask[23:16] = byteenable[2]? 8'hFF:8'h0; 
 assign mask[31:24] = byteenable[3]? 8'hFF:8'h0; 
 assign mask[39:32] = byteenable[3]? 8'hFF:8'h0; 
 assign mask[47:40] = byteenable[3]? 8'hFF:8'h0; 
 assign mask[55:48] = byteenable[3]? 8'hFF:8'h0; 
 assign mask[63:56] = byteenable[3]? 8'hFF:8'h0; 
 assign config_access = address[21];  

 
//Write logic
always @(posedge clk) begin
    if (!reset_n) begin
        csr_test_f000_reg <= 64'h0;
        csr_test_fffc_reg <= 32'h0;
        csr_test_f00_reg  <= 32'h0;
        csr_test_ffc_reg  <= 32'h0;
    end
    else begin
        if (write && (address[20:0] == 21'hF000)) begin 
           csr_test_f000_reg <= writedata & mask;
        end
        else if (write && (address[20:0] == 21'hFFFC)) begin 
          csr_test_fffc_reg <= writedata & mask;
        end
        else if (write && (address[20:0] == 21'h000F00) && config_access) begin
          csr_test_f00_reg <= writedata & mask;
        end  
        else if (write && (address[20:0] == 21'h000FFC) && config_access) begin
          csr_test_ffc_reg <= writedata & mask;
        end  
        else begin
           csr_test_f000_reg <= csr_test_f000_reg;
           csr_test_fffc_reg <= csr_test_fffc_reg;
           csr_test_f00_reg <= csr_test_f00_reg;
           csr_test_ffc_reg <= csr_test_ffc_reg;
        end        
    end    
end 

//Read logic
always @(posedge clk) begin
    if (!reset_n) begin
        readdata  <= 64'h0;
    end
    else begin
        if (read && (address[20:0] == 21'hF000)) begin 
           readdata <= csr_test_f000_reg & mask;
        end
        else if(read && (address[20:0] == 21'hFFFC)) begin
           readdata <= {32'h0,csr_test_fffc_reg} & mask;
        end
        else if(read && (address[20:0] == 21'h00F00) && config_access) begin
           readdata <= {32'h0,csr_test_f00_reg} & mask;
        end
        else if(read && (address[20:0] == 21'h00FFC) && config_access) begin
           readdata <= {32'h0,csr_test_ffc_reg} & mask;
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
`pragma questa_oem_00 "DcjSv4cazWNFeTq2LDzhR8VVA2vsU+D2FLr5cau2M2bJ+ymOMJzu0j4X+D7sDofwwnGT3dC9uPfUfqUyT+1JDqgoqF4+Hm1+DbOqZuomBxMc/3ubRV7jR7LhS90CAIiftZSupMkt7Z6NB7tsmbvAu3Uqtxlo+Ag4QRIgi49yVFsS2wB30qw4GeL5di6t6OjbvWcjLtKHJMZ/Vew3QCsc9aW8Cap9TcP/4lTkJB8MFTjKeqoRJuOYjy0yTcD7QpE8C9gJrkIIaPYfxQ99OU8PnMgMLOtfGso5W+qAXew9ugZkU/Fej+LQxAvDWuMoE3jOKeQIp+ul8Mt2y0ESGKBMNDNrfGgHHxcFiGYwjyehkQNSzKYzU07VmRujfnlHTcwsxcqVwUuHqXPsb64VjnRks1SnQ2hcOQYAtS2MG/klNz+eexl5rTM0LxmY+Tl+QUfg1XTfuZweOYuNoSh3U+MIgY8i+xx4V/A9OGAK4u/kosnni0bS0EUvHDy3PD4ciNbx8Wb6owOJqOxI5euSkLvsLlmngI59tgI76R9+rPLwbBNB10bKEZ2akkHcjt6GgOd/7vxXMGp7Syc1Mn4KCxVfqh14JdUibrEwjmqxugQIn9oHGcz1v3ZLxxfJzpBbtHLCMhknJWzPKJv7Fg0QSKtpb86Lm5irrKPmqV5I0CCT9pC9E8L9YyAubQDAnYfz0fVA6bhB3lUfyHnZ9b/7hpMTh9Cgpmv+IfvWXJdjw+sjZ0fLVwYBdG2jyf0NQq2MapQenus+Fvf0Mm+DrFypLda6bHuLU8M2be+ua7sgMnKmrnJYtBOHIq/8GI4xLrrqsyRLT3oaxVFfF/85XzbrPQfZZ8irZ107x9kbAKBtbEiknS+rf+DADFboo/ZYCqEVSYh2Hs05riDNexH9t7oxIB2tAGkosYPIDSOSWhBvxjYr4QJxHPyoU8iBPY+Ooq+ll7AmHxyM7JMPPHHK4TedKhP6/1Cwae2AeEm1TguQ7PoCNJwlyO5u0ZqYgmrdvwDl3Iee"
`endif