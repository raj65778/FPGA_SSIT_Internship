`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2025 15:19:46
// Design Name: 
// Module Name: jk_flf
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module jk_flf(clk,j,k,qnext,qnbar);
input clk,j,k;
output reg qnext;
output qnbar;
initial qnext<=0;

 reg [31:0] count;
 reg clk_out;
 
  initial begin
  clk_out<=0;
  end
    always @(posedge clk) begin
       
        if(count == 25000000) begin
            count <= 0;
            clk_out <= ~clk_out;
            end
           else begin
            count <= count + 1;
        end
      end
        
always @(posedge clk_out) begin 
    case({j,k})
    2'b00:qnext<=qnext;
    2'b01:qnext<=0;
    2'b10:qnext<=1;
    2'b11:qnext<=~qnext;
    endcase
  end
   assign qnbar =~qnext;
endmodule

