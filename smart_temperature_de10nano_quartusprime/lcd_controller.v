`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.05.2025 11:13:20
// Design Name: 
// Module Name: lcd_controller
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

module lcd_controller (
    input wire clk,                // 50MHz clock
    input wire rst,                // active-high reset
    input wire [7:0] temperature,  // temperature value to display
    output reg lcd_rs,
    output reg lcd_en,
    output reg [3:0] lcd_data
);

// Clock divider to generate ~1ms strobe
reg [15:0] clk_div;
wire strobe = (clk_div == 0);
always @(posedge clk or posedge rst) begin
    if (rst)
        clk_div <= 0;
    else
        clk_div <= clk_div + 1;
end

// FSM states
localparam INIT       = 0,
           FUNCTION   = 1,
           DISP_CTRL  = 2,
           DISP_CLR   = 3,
           ENTRY_MODE = 4,
           LINE1      = 5,
           LINE2      = 6,
           IDLE       = 7;

reg [2:0] state = INIT;
reg [5:0] step = 0;
reg [7:0] char_data;
reg [7:0] line1 [15:0];
reg [7:0] line2 [15:0];
reg [3:0] nibble;
reg send_high;
reg [3:0] char_index = 0;

reg [7:0] temp_ascii[2:0];

// Convert temperature to ASCII (assuming max 3 digits)
always @(*) begin
    temp_ascii[2] = "0" + temperature / 100;
    temp_ascii[1] = "0" + (temperature % 100) / 10;
    temp_ascii[0] = "0" + (temperature % 10);
end

// LCD data and control generation
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= INIT;
        step <= 0;
        lcd_en <= 0;
        lcd_rs <= 0;
        lcd_data <= 4'b0000;
    end else if (strobe) begin
        case (state)
            INIT: begin
                // Wait a bit before initializing LCD
                if (step < 20) step <= step + 1;
                else begin
                    state <= FUNCTION;
                    step <= 0;
                end
            end

            FUNCTION: begin
                case (step)
                    0: begin lcd_rs <= 0; lcd_data <= 4'b0010; lcd_en <= 1; step <= 1; end // 4-bit mode
                    1: begin lcd_en <= 0; step <= 2; end
                    2: begin lcd_rs <= 0; lcd_data <= 4'b1000; lcd_en <= 1; step <= 3; end // 2 lines, 5x8
                    3: begin lcd_en <= 0; step <= 4; end
                    default: begin state <= DISP_CTRL; step <= 0; end
                endcase
            end

            DISP_CTRL: begin
                case (step)
                    0: begin lcd_rs <= 0; lcd_data <= 4'b0000; lcd_en <= 1; step <= 1; end
                    1: begin lcd_en <= 0; step <= 2; end
                    2: begin lcd_rs <= 0; lcd_data <= 4'b1100; lcd_en <= 1; step <= 3; end // Display ON, cursor OFF
                    3: begin lcd_en <= 0; step <= 4; end
                    default: begin state <= DISP_CLR; step <= 0; end
                endcase
            end

            DISP_CLR: begin
                case (step)
                    0: begin lcd_rs <= 0; lcd_data <= 4'b0000; lcd_en <= 1; step <= 1; end
                    1: begin lcd_en <= 0; step <= 2; end
                    2: begin lcd_rs <= 0; lcd_data <= 4'b0001; lcd_en <= 1; step <= 3; end // Clear display
                    3: begin lcd_en <= 0; step <= 4; end
                    default: begin state <= ENTRY_MODE; step <= 0; end
                endcase
            end

            ENTRY_MODE: begin
                case (step)
                    0: begin lcd_rs <= 0; lcd_data <= 4'b0000; lcd_en <= 1; step <= 1; end
                    1: begin lcd_en <= 0; step <= 2; end
                    2: begin lcd_rs <= 0; lcd_data <= 4'b0110; lcd_en <= 1; step <= 3; end // Entry mode set
                    3: begin lcd_en <= 0; step <= 4; end
                    default: begin state <= LINE1; step <= 0; char_index <= 0; end
                endcase
            end

            LINE1: begin
                if (step == 0) begin
                    lcd_rs <= 0; lcd_data <= 4'b1000; lcd_en <= 1; step <= 1; // Set DDRAM addr = 0x80
                end else if (step == 1) begin
                    lcd_en <= 0; step <= 2;
                end else if (step == 2) begin
                    lcd_rs <= 0; lcd_data <= 4'b0000; lcd_en <= 1; step <= 3;
                end else if (step == 3) begin
                    lcd_en <= 0; step <= 4;
                end else if (step < 36) begin
                    lcd_rs <= 1;
                    case (char_index)
                        0: char_data <= "T";
                        1: char_data <= "e";
                        2: char_data <= "m";
                        3: char_data <= "p";
                        4: char_data <= ":";
                        5: char_data <= " ";
                        6: char_data <= temp_ascii[2]; // hundreds
                        7: char_data <= temp_ascii[1]; // tens
                        8: char_data <= temp_ascii[0]; // ones
                        9: char_data <= 8'hDF; // degree symbol
                        10: char_data <= "C";
                        default: char_data <= " ";
                    endcase

                    if ((step % 2) == 0)
                        lcd_data <= char_data[7:4]; // high nibble
                    else begin
                        lcd_data <= char_data[3:0]; // low nibble
                        char_index <= char_index + 1;
                    end

                    lcd_en <= 1;
                    step <= step + 1;
                end else begin
                    state <= LINE2;
                    step <= 0;
                    char_index <= 0;
                end
            end

            LINE2: begin
                // Optional second line (you can add more display here)
                state <= IDLE;
            end

            IDLE: begin
                // Wait and refresh
                state <= ENTRY_MODE;
            end
        endcase
    end
end

endmodule
