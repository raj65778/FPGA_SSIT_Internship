`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2025 07:07:49
// Design Name: 
// Module Name: dec_2to4_mux
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


module mux_2to1(i0,i1,s,y);
input i0,i1,s;
output reg y;

always @(*) begin
    case(s)
        1'b0:y=i0;
        1'b1:y=i1;
     endcase
   end
endmodule

module dec_2to4(s0,s1,d1,d2,d3,d4);
input s0,s1;
output  d1,d2,d3,d4;
wire ns0;
mux_2to1 n(1'b1,1'b0,s0,ns0);

mux_2to1 m1(ns0,1'b0,s1,d1);
mux_2to1 m2(s0,1'b0,s1,d2);
mux_2to1 m3(1'b0,ns0,s1,d3);
mux_2to1 m4(1'b0,s0,s1,d4);
endmodule