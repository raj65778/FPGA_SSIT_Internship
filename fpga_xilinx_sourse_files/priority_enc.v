`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.05.2025 15:50:18
// Design Name: 
// Module Name: priority_enc
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


module priority_enc(i,o);
input [3:0]i;
output reg [1:0]o;
always @(*)
    begin
     
    case(i)
        4'b0001: begin o[1]=0;o[0]=0;end
        4'b001x:begin  o[1]=0;o[0]=1;end
        4'b01xx:begin  o[1]=1;o[0]=0;end
        4'b1xxx:begin  o[1]=1;o[0]=1;end
    endcase              
    end
endmodule


