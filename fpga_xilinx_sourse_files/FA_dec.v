`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.05.2025 14:29:02
// Design Name: 
// Module Name: FA_dec
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


module fullDec3by8(a, b, cin, s, ca);
    input a, b, cin;
    output s, ca;
    wire o0, o1, o2, o3, o4, o5, o6, o7;
    dec3by8 d1(a, b, cin, o0, o1, o2, o3, o4, o5, o6, o7);
    assign s  = o1 | o2 | o4 | o7;
    assign ca = o3 | o5 | o6 | o7;
endmodule
module dec3by8(i0, i1, i2, o0, o1, o2, o3, o4, o5, o6, o7);
    input i2, i1, i0;
    output reg o0, o1, o2, o3, o4, o5, o6, o7;
    always @(*) begin
        o0 = 0; o1 = 0; o2 = 0; o3 = 0;
        o4 = 0; o5 = 0; o6 = 0; o7 = 0;
        case ({i2, i1, i0})
            3'b000: o0 = 1;
            3'b001: o1 = 1;
            3'b010: o2 = 1;
            3'b011: o3 = 1;
            3'b100: o4 = 1;
            3'b101: o5 = 1;
            3'b110: o6 = 1;
            3'b111: o7 = 1;
        endcase
    end
endmodule
