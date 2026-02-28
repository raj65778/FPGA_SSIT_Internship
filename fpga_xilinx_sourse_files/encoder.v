`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.05.2025 15:00:37
// Design Name: 
// Module Name: encoder
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


module encoder(i,o);
input [3:0]i;
output reg [1:0]o;
always @ (*)
    begin
     
    case(i)
        4'b0001: begin o[1]=0;o[0]=0;end
        4'b0010:begin  o[1]=0;o[0]=1;end
        4'b0100:begin  o[1]=1;o[0]=0;end
        4'b1000:begin  o[1]=1;o[0]=1;end
    endcase              
    end
endmodule
