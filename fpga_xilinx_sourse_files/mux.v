`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.05.2025 15:59:11
// Design Name: 
// Module Name: mux
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


module mux(i,s,out);
input [3:0] i;
input [1:0] s;
output reg out;

always @(*) begin
    case(s)
        2'b00:out=i[0];
        2'b01:out=i[1];
        2'b10:out=i[2];
        2'b11:out=i[3];
        default:out=0;
    endcase
    end
endmodule
