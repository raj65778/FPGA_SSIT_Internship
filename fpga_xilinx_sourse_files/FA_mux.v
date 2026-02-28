`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.05.2025 12:53:15
// Design Name: 
// Module Name: FA_mux
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

module fullMux(a, b, c, s, ca);
    input a, b, c;
    output s, ca;

    wire s1 = a;
    wire s2 = b;

    mux4by1 m1(.i0(c), .i1(~c), .i2(~c), .i3(c), .s1(s1), .s2(s2), .out(s));
    mux4by1 m2(.i0(1'b0), .i1(c), .i2(c), .i3(1'b1), .s1(s1), .s2(s2), .out(ca));
endmodule

module mux4by1(i0, i1, i2, i3, s1, s2, out);
    input i0, i1, i2, i3;
    input s1, s2;
    output reg out;

    always @(*) begin
        case ({s1, s2})
            2'b00: out = i0;
            2'b01: out = i1;
            2'b10: out = i2;
            2'b11: out = i3;
        endcase
    end
endmodule