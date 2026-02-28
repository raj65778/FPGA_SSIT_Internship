`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.05.2025 16:49:27
// Design Name: 
// Module Name: dec_4to6
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


module dec_4to6(i,en,d);
input [3:0]i;
input en;
output reg [5:0] d;

always @(*) begin
if(en)
    case(i)
        4'b0000:d=6'b000001;
        4'b0001:d=6'b000010;
        4'b0010:d=6'b000100;
        4'b0011:d=6'b001000;
        4'b0100:d=6'b010000;
        4'b0101:d=6'b100000;
        default:d=6'b000000;
     endcase
   else 
    d=6'b000000;
   end

endmodule
