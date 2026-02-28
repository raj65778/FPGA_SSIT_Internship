`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2025 14:39:03
// Design Name: 
// Module Name: freq_dev
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

module clk_divider(
    input clk,
    output reg clk_out
);
    reg [31:0] count;
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
endmodule

