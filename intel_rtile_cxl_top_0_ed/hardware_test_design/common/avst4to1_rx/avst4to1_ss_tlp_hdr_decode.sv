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


//------------------------------------------------------------
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
//------------------------------------------------------------


module avst4to1_ss_tlp_hdr_decode (
//
// PLD IF
//
  input                   pld_clk,                                   // Clock (Core)
  input                   pld_rst_n,
  
  input                   tlp_valid,
  input                   tlp_sop,
  input [127:0]           tlp_hdr,
  
  output logic            func_num_val,
  output logic            bcast_msg,
  output logic [7:0]      func_num,
  
  output logic            mem_addr_val,
  output logic            mem_64b_addr,
  output logic [63:0]     mem_addr,
  
  output logic [1:0]      tlp_crd_type                            // // credit type: 00-P, 01-NP, 10-CPL, 11-ERR
 
);
//----------------------------------------------------------------------------//


logic [63:0]  mem_tlp_hdr_dw1_3;


assign mem_addr = mem_tlp_hdr_dw1_3;

// S0 segment
always @(posedge pld_clk)
begin
   if (~pld_rst_n)
     begin
       bcast_msg <= 1'b0;
       func_num_val <= 1'b0;
       mem_addr_val <= 1'b0;
       mem_64b_addr <= 1'b0;
       
       func_num[7:0] <= 8'd0;
       
       tlp_crd_type[1:0] <= 2'b11; //ERR
       mem_tlp_hdr_dw1_3[63:0] <= {2{32'hBAAD_BAAD}};
     end
   else
     begin
        if (tlp_valid & tlp_sop)
          begin
            if (~tlp_hdr[127])
              begin
                // get header info
                case (tlp_hdr[124:121])
                4'hd: // Deferred Memory Request
                  begin
                    bcast_msg <= 1'b0;
                    func_num_val <= 1'b0;
                    mem_addr_val <= 1'b1;
                    tlp_crd_type[1:0] <= 2'b01; //NP
                    
                    if (tlp_hdr[125]) // 64 bit
                      begin
                        mem_64b_addr <= 1'b1;
                        mem_tlp_hdr_dw1_3[63:0] <= tlp_hdr[63:0];
                      end
                    else              // 32 bit
                      begin
                        mem_64b_addr <= 1'b0;
                        mem_tlp_hdr_dw1_3[31:0] <= tlp_hdr[63:32];
                        mem_tlp_hdr_dw1_3[63:32] <= 32'hBAAD_BAAD;
                      end
                  end
                4'h8, 4'h9, 4'ha, 4'hb: // Message Request
                  begin //brocast from root complex/local 
                    if (tlp_hdr[122:120] == 3'b100 | tlp_hdr[122:120] == 3'b011 | tlp_hdr[122:120] == 3'b010 | tlp_hdr[122:120] == 3'b000)
                      func_num_val <= 1'b1;
                    else
                      func_num_val <= 1'b0;
                      
                    if (tlp_hdr[122:120] == 3'b001)
                      mem_addr_val <= 1'b1;
                    else
                      mem_addr_val <= 1'b0;
                    
                    if (tlp_hdr[122:120] == 3'b011)
                      bcast_msg <= 1'b1;
                    else
                      bcast_msg <= 1'b0;
                    
                    if (tlp_hdr[122:120] == 3'b100 | tlp_hdr[122:120] == 3'b011 | tlp_hdr[122:120] == 3'b000)
                      func_num[7:0] <= 8'd0;
                    else
                      func_num[7:0] <= tlp_hdr[55:48];
                    
                    tlp_crd_type[1:0] <= 2'b00; //P
                    if (tlp_hdr[125]) // 64 bit
                      begin
                        mem_64b_addr <= 1'b1;
                        mem_tlp_hdr_dw1_3[63:0] <= tlp_hdr[63:0];
                      end
                    else             // 32 bit
                      begin
                        mem_64b_addr <= 1'b0;
                        mem_tlp_hdr_dw1_3[31:0] <= tlp_hdr[63:32];
                        mem_tlp_hdr_dw1_3[63:32] <= 32'hBAAD_BAAD;
                      end
                  end
                4'h6, 4'h7: // AtomicOp Request
                  begin
                    bcast_msg <= 1'b0;
                    func_num_val <= 1'b0;
                    mem_addr_val <= 1'b1;
                    
                    tlp_crd_type[1:0] <= 2'b01; //NP
                    if (tlp_hdr[125]) // 64 bit
                      begin
                        mem_64b_addr <= 1'b1;
                        mem_tlp_hdr_dw1_3[63:0] <= tlp_hdr[63:0];
                      end
                    else                    // 32 bit
                      begin
                        mem_64b_addr <= 1'b0;
                        mem_tlp_hdr_dw1_3[31:0] <= tlp_hdr[63:32];
                        mem_tlp_hdr_dw1_3[63:32] <= 32'hBAAD_BAAD;
                      end
                  end
                4'h5: // Completion Request
                  begin
                    bcast_msg <= 1'b0;
                    func_num_val <= 1'b1;
                    mem_addr_val <= 1'b0;
                    mem_64b_addr <= 1'b0;
                    
                    func_num[7:0] <= tlp_hdr[55:48];
                    
                    tlp_crd_type[1:0] <= 2'b10; //CPL
                    mem_tlp_hdr_dw1_3[63:0] <= {2{32'hBAAD_BAAD}};
                  end
                4'h2: // Configuration Request
                  begin
                    bcast_msg <= 1'b0;
                    func_num_val <= 1'b1;
                    mem_addr_val <= 1'b0;
                    mem_64b_addr <= 1'b0;
                    
                    func_num[7:0] <= tlp_hdr[55:48];
                    
                    tlp_crd_type[1:0] <= 2'b01; //NP
                    mem_tlp_hdr_dw1_3[63:0] <= {2{32'hBAAD_BAAD}};
                  end
                4'h1: // IO Request
                  begin
                    bcast_msg <= 1'b0;
                    func_num_val <= 1'b0;
                    mem_addr_val <= 1'b1;
                    mem_64b_addr <= 1'b0;
                    
                    tlp_crd_type[1:0] <= 2'b01; //NP
                    mem_tlp_hdr_dw1_3[31:0] <= tlp_hdr[63:32];
                    mem_tlp_hdr_dw1_3[63:32] <= 32'hBAAD_BAAD;
                  end
                4'h0: // Memory Request
                  begin
                    bcast_msg <= 1'b0;
                    func_num_val <= 1'b0;
                    mem_addr_val <= 1'b1;
                    if (tlp_hdr[126])     // write
                      tlp_crd_type[1:0] <= 2'b00; //P
                    else                  // read
                      tlp_crd_type[1:0] <= 2'b01; //NP
                    
                    if (tlp_hdr[125]) // 64 bit
                      begin
                        mem_64b_addr <= 1'b1;
                        mem_tlp_hdr_dw1_3[63:0] <= tlp_hdr[63:0];
                      end
                    else              // 32 bit
                      begin
                        mem_64b_addr <= 1'b0;
                        mem_tlp_hdr_dw1_3[31:0] <= tlp_hdr[63:32];
                        mem_tlp_hdr_dw1_3[63:32] <= 32'hBAAD_BAAD;
                      end
                  end
                default: // NA
                  begin
                    bcast_msg <= 1'b0;
                    func_num_val <= 1'b0;
                    mem_addr_val <= 1'b0;
                    mem_64b_addr <= 1'b0;
                    
                    tlp_crd_type[1:0] <= 2'b11;
                    mem_tlp_hdr_dw1_3[63:0] <= {2{32'hBAAD_BAAD}};
                  end
                endcase
              end
            else // prefix
              begin
                bcast_msg <= 1'b0;
                func_num_val <= 1'b0;
                mem_addr_val <= 1'b0;
                mem_64b_addr <= 1'b0;
                
                tlp_crd_type[1:0] <= 2'b11;
              end
          end
          else begin
             bcast_msg <= 1'b0;
             func_num_val <= 1'b0;
             mem_addr_val <= 1'b0;
             mem_64b_addr <= 1'b0;
          end
     end
end

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "DGzrytkiceLjtyjsTaM+IzNUexbn5wzpmx4F1prXYECmxPXPn13o0M/rXNG1mO13RJ5fhQaExY1DId30xrFeFq5FL7gSGxHyRknIDLmmCNMcWImmwtFcy2uyhgWx0jyEzKKJKegjoNYHGsF9JtxyGoo4G3owvnlbnlgS/aJ3Aky5AJL4N0KkruYOdzUGck/zCmpIoex0KWhVL43DGHURVo8L2CS4v6cauUSxTHMeah3NIiy23ks779Ae2r03T8CfzQLXthLGYhCUWnNf6Cl1Ly1LjHV0syZWrGuizCS6IbV59dx+ej3TYnqPomO4PQalrkk2nW3z2DLufhomhWOfAShgkk9ZhS9HJiNxceQkRWnvwVoitfgH40B4KOFvbjMZRuEyvcMuI395ouS7IS38m9v/M9aXxCvmc3kemkd0S10XfHhpUHgM+X2qzo+81Pf9qs+FmlSXdsUbSBOhdh8Btq2rqy9STInv2ALehcXyizJt08G/cWkHVC2ZT6BKR7Uh7oBdGzyXQ9mutD3dly1HvMAZigsnIKKNKsOd/shTloMCy3Kr7Lp0G8AqcRJSvhP/OW3x8c24aOy4S1AhM9UXpX4q1U6xuvSo1e6ieHUi40dEn46na/1NqJ39BmwgL9prBiF/ZJ0Mx8vBy5RkN2un2CyEn2YmAJYJqCO3VOB8axJSLfjCRzkIGhfhuoBW/enMalDx9fPewaUFmRENCFgeKmzEukk0CrJzi4MhtDO99jdoyAXEg8xsocRN8YgLVGOjtaLIaaBpd5N1Mvngl54ZbnkHOqyMJOUKCu0O8Xc6aWZsvu/u0AqORRVUdQT7duj3YvgFYPFXl7xKZ7hij5Zm9s6iZ3+rXHMpfiWnmr0mOIL3T7aKgVSF65kHQN+3MIdXT0vR/Vcmlfe6+DRpAE5GH/WOdolHhoHrnpjr42PQ+gaW4VtA4btExiA+eO0ubBbtrqGEta6k9tAfEbQbWBsW6/gOm95kACn78YbxxrhSPNoeX99N6zP3svkSWvaTq2gw"
`endif