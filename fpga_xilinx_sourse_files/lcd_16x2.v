`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.05.2025 17:10:05
// Design Name: 
// Module Name: lcd_16x2
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

`timescale 1ns / 1ps

module lcd(input clk, rst, output reg en, rs, output [7:0] data);
    reg [19:0] state = 0;
    reg [19:0] count = 0;
    reg [7:0] cmd;

    always @(posedge clk) begin
        if (rst) begin
            en <= 0;
            rs <= 0;
            cmd <= 0;
            state <= 0;
            count <= 0;
        end else begin
            case (state)
                // Initialization sequence...
                0: begin en <= 0; rs <= 0;
                    if (count == 750000) begin count <= 0; state <= state + 1; end
                    else count <= count + 1;
                end
                1: begin en <= 1; cmd <= 8'h30;
                    if (count == 12) begin count <= 0; state <= state + 1; end
                    else count <= count + 1;
                end
                2: begin en <= 0;
                    if (count == 205000) begin count <= 0; state <= state + 1; end
                    else count <= count + 1;
                end
                3: begin en <= 1; cmd <= 8'h30;
                    if (count == 12) begin count <= 0; state <= state + 1; end
                    else count <= count + 1;
                end
                4: begin en <= 0;
                    if (count == 5000) begin count <= 0; state <= state + 1; end
                    else count <= count + 1;
                end
                5: begin en <= 1; cmd <= 8'h30;
                    if (count == 12) begin count <= 0; state <= state + 1; end
                    else count <= count + 1;
                end
                6: begin en <= 0;
                    if (count == 2000) begin count <= 0; state <= state + 1; end
                    else count <= count + 1;
                end
                7: begin en <= 1; cmd <= 8'h38; // Function set
                    if (count == 12) begin count <= 0; state <= state + 1; end
                    else count <= count + 1;
                end
                8: begin en <= 0;
                    if (count == 2000) begin count <= 0; state <= state + 1; end
                    else count <= count + 1;
                end
                9: begin en <= 1; cmd <= 8'h0C; // Display ON
                    if (count == 12) begin count <= 0; state <= state + 1; end
                    else count <= count + 1;
                end
                10: begin en <= 0;
                    if (count == 2000) begin count <= 0; state <= state + 1; end
                    else count <= count + 1;
                end
                11: begin en <= 1; cmd <= 8'h06; // Entry mode set
                    if (count == 12) begin count <= 0; state <= state + 1; end
                    else count <= count + 1;
                end
                12: begin en <= 0;
                    if (count == 2000) begin count <= 0; state <= state + 1; end
                    else count <= count + 1;
                end
                13: begin en <= 1; cmd <= 8'h01; // Clear display
                    if (count == 12) begin count <= 0; state <= state + 1; end
                    else count <= count + 1;
                end
                14: begin en <= 0;
                    if (count == 82000) begin count <= 0; state <= state + 1; end
                    else count <= count + 1;
                end

                // Display characters: M A R U T H I
                15: begin en <= 1; rs <= 1; cmd <= 8'h4D; // M
                    if (count == 12) begin count <= 0; state <= state + 1; end else count <= count + 1;
                end
                16: begin en <= 0;
                    if (count == 2000) begin count <= 0; state <= state + 1; end else count <= count + 1;
                end
                17: begin en <= 1; rs <= 1; cmd <= 8'h41; // A
                    if (count == 12) begin count <= 0; state <= state + 1; end else count <= count + 1;
                end
                18: begin en <= 0;
                    if (count == 2000) begin count <= 0; state <= state + 1; end else count <= count + 1;
                end
                19: begin en <= 1; rs <= 1; cmd <= 8'h52; // R
                    if (count == 12) begin count <= 0; state <= state + 1; end else count <= count + 1;
                end
                20: begin en <= 0;
                    if (count == 2000) begin count <= 0; state <= state + 1; end else count <= count + 1;
                end
                21: begin en <= 1; rs <= 1; cmd <= 8'h55; // U
                    if (count == 12) begin count <= 0; state <= state + 1; end else count <= count + 1;
                end
                22: begin en <= 0;
                    if (count == 2000) begin count <= 0; state <= state + 1; end else count <= count + 1;
                end
                23: begin en <= 1; rs <= 1; cmd <= 8'h54; // T
                    if (count == 12) begin count <= 0; state <= state + 1; end else count <= count + 1;
                end
                24: begin en <= 0;
                    if (count == 2000) begin count <= 0; state <= state + 1; end else count <= count + 1;
                end
                25: begin en <= 1; rs <= 1; cmd <= 8'h48; // H
                    if (count == 12) begin count <= 0; state <= state + 1; end else count <= count + 1;
                end
                26: begin en <= 0;
                    if (count == 2000) begin count <= 0; state <= state + 1; end else count <= count + 1;
                end
                27: begin en <= 1; rs <= 1; cmd <= 8'h49; // I
                    if (count == 12) begin count <= 0; state <= state + 1; end else count <= count + 1;
                end
                28: begin en <= 0;
                    if (count == 2000) begin count <= 0; state <= 29; end else count <= count + 1;
                end

                default: begin en <= 0; rs <= 0; cmd <= 8'h00; end
            endcase
        end
    end

    assign data = cmd;
endmodule
