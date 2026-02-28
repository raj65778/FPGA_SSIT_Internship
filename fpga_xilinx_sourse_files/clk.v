`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.05.2025 09:32:09
// Design Name: 
// Module Name: clk
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

module digital_clock (
    input clk, 
    input rst, 
    output reg [3:0] an, 
    output reg [7:0] ca 
);

    reg clk1Hz = 0;
    reg [31:0] count = 0;
    reg [5:0] sec = 0;
    reg [5:0] min = 0;
    reg [4:0] hour = 0;
    reg [3:0] digit = 0;
    reg [1:0] mux = 0;

    // Generate 1Hz clock from FPGA system clock
    always @(posedge clk) begin
        if (count == 50_000_000) begin // Adjust for board clock speed
            count <= 0;
            clk1Hz <= ~clk1Hz;
        end else begin
            count <= count + 1;
        end
    end

    // Time update logic
    always @(posedge clk1Hz) begin
        sec <= sec + 1;
        if (sec == 59) begin
            sec <= 0;
            min <= min + 1;
            if (min == 59) begin
                min <= 0;
                hour <= hour + 1;
                if (hour == 23) begin
                    hour <= 0;
                end
            end
        end
    end

    // Multiplexing to display time
    always @(posedge clk) begin
        mux <= mux + 1;
        case (mux)
            2'b00: begin
                an = 4'b0001; // Active HIGH anode for first digit
                digit = sec % 10;
            end
            2'b01: begin
                an = 4'b0010; // Active HIGH anode for second digit
                digit = sec / 10;
            end
            2'b10: begin
                an = 4'b0100; // Active HIGH anode for third digit
                digit = min % 10;
            end
            2'b11: begin
                an = 4'b1000; // Active HIGH anode for fourth digit
                digit = min / 10;
            end
        endcase
    end

    // **Active-Low Seven-Segment Encoding**
    always @(*) begin
        case (digit)
            4'b0000: ca = ~8'b11000000; // 0
            4'b0001: ca = ~8'b11111001; // 1
            4'b0010: ca = ~8'b10100100; // 2
            4'b0011: ca = ~8'b10110000; // 3
            4'b0100: ca = ~8'b10011001; // 4
            4'b0101: ca = ~8'b10010010; // 5
            4'b0110: ca = ~8'b10000010; // 6
            4'b0111: ca = ~8'b11111000; // 7
            4'b1000: ca = ~8'b10000000; // 8
            4'b1001: ca = ~8'b10010000; // 9
            default: ca = ~8'b11111111; // Blank
        endcase
    end

endmodule
