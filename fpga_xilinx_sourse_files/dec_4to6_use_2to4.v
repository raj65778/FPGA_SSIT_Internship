`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2025 08:05:08
// Design Name: 
// Module Name: dec_4to6_use_2to4
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

module dec_4to16(i,o,en);
input [3:0]i;input en;
output [15:0]o;
wire w1,w2,w3,w4;
dec_2to4 d1(en,i[0],i[1],w1,w2,w3,w4);
dec_2to4 d2(w1,i[2],i[3],o[0],o[1],o[2],o[3]);
dec_2to4 d3(w2,i[2],i[3],o[4],o[5],o[6],o[7]);
dec_2to4 d4(w3,i[2],i[3],o[8],o[9],o[10],o[11]);
dec_2to4 d5(w4,i[2],i[3],o[12],o[13],o[14],o[15]);
endmodule
module dec_2to4(en,i0,i1,o0,o1,o2,o3);
input i0,i1;
input en;
output reg o0,o1,o2,o3;
always @ (*)
    begin
    if(en)
        begin
        o0=0;o1=0;o2=0;o3=0;
        case({i1,i0})
            2'b00:o0=1;
            2'b01:o1=1;
            2'b10:o2=1;
            2'b11:o3=1;
           
        endcase
        end
    else
        begin
        o0=0;o1=0;o2=0;o3=0;
        end
    
    end

endmodule