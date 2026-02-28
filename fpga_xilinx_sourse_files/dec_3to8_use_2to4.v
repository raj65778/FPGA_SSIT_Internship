`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.05.2025 16:20:07
// Design Name: 
// Module Name: dec_3to8_use_2to4
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


module ThreeBy8dec(a,b,c,o0,o1,o2,o3,o4,o5,o6,o7);
 input a,b,c;
output o0,o1,o2,o3,o4,o5,o6,o7;
wire [3:0] lower,upper;
Twoby4dec d1(.e(~a),.b(b),.c(c),.x(lower));
Twoby4dec d2(.e(a),.b(b),.c(c),.x(upper));
assign {o7,o6,o5,o4}=upper;
assign {o3,o2,o1,o0}=lower;
endmodule
module Twoby4dec(e,b,c,x);
input e,b,c;
output reg [3:0]x;
always @(*)
        begin
       x=4'b0000;
        if(e)
          begin
            case({b,c})
                2'b00:x[0]=1;
                2'b01:x[1]=1;
                2'b10:x[2]=1;
                2'b11:x[3]=1;   
            
            endcase
          end
        end
endmodule
