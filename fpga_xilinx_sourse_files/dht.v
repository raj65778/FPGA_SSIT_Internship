`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.05.2025 16:59:41
// Design Name: 
// Module Name: dht
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


module dht11_display (
    input wire clk,
    input wire rst,
    inout wire dht_data,
    output reg [6:0] seg,
    output reg [3:0] an,
    output reg ac_relay,
    output reg fan_relay,
    output reg heater_relay
);

reg [31:0] us_count;
reg [5:0] bit_index;
reg [39:0] data;
reg [3:0] state;
reg [7:0] temperature;
reg [3:0] digit1, digit0;
reg [16:0] refresh_counter;
wire [1:0] refresh_digit;

reg dht_out;
reg dht_dir;
wire dht_in;

assign dht_data = dht_dir ? dht_out : 1'bz;
assign dht_in = dht_data;
assign refresh_digit = refresh_counter[16:15];

always @(posedge clk) begin
    refresh_counter <= refresh_counter + 1;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 0;
        us_count <= 0;
        bit_index <= 0;
        data <= 0;
        temperature <= 0;
        dht_out <= 1;
        dht_dir <= 1;
    end else begin
        case (state)
            0: begin
                dht_out <= 0;
                dht_dir <= 1;
                if (us_count < 1800000)
                    us_count <= us_count + 1;
                else begin
                    us_count <= 0;
                    state <= 1;
                end
            end
            1: begin
                dht_out <= 1;
                dht_dir <= 0;
                state <= 2;
            end
            2: if (~dht_in) state <= 3;
            3: if (dht_in) state <= 4;
            4: if (~dht_in) begin bit_index <= 0; state <= 5; end
            5: begin
                if (bit_index < 40) begin
                    if (dht_in) us_count <= us_count + 1;
                    else begin
                        if (us_count > 4000)
                            data[39 - bit_index] <= 1;
                        else
                            data[39 - bit_index] <= 0;
                        bit_index <= bit_index + 1;
                        us_count <= 0;
                    end
                end else begin
                    temperature <= data[39:32];
                    state <= 6;
                end
            end
            6: begin
                digit1 <= temperature / 10;
                digit0 <= temperature % 10;
                state <= 0;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (temperature > 8'd35) begin
        ac_relay <= 1;
        fan_relay <= 1;
        heater_relay <= 0;
    end else if (temperature >= 8'd30 && temperature <= 8'd35) begin
        ac_relay <= 0;
        fan_relay <= 1;
        heater_relay <= 0;
    end else begin
        ac_relay <= 0;
        fan_relay <= 0;
        heater_relay <= 1;
    end
end

always @(*) begin
    case (refresh_digit)
        2'b00: begin
            an = 4'b1110;
            case (digit0)
                0: seg = 7'b1000000;
                1: seg = 7'b1111001;
                2: seg = 7'b0100100;
                3: seg = 7'b0110000;
                4: seg = 7'b0011001;
                5: seg = 7'b0010010;
                6: seg = 7'b0000010;
                7: seg = 7'b1111000;
                8: seg = 7'b0000000;
                9: seg = 7'b0010000;
                default: seg = 7'b1111111;
            endcase
        end
        2'b01: begin
            an = 4'b1101;
            case (digit1)
                0: seg = 7'b1000000;
                1: seg = 7'b1111001;
                2: seg = 7'b0100100;
                3: seg = 7'b0110000;
                4: seg = 7'b0011001;
                5: seg = 7'b0010010;
                6: seg = 7'b0000010;
                7: seg = 7'b1111000;
                8: seg = 7'b0000000;
                9: seg = 7'b0010000;
                default: seg = 7'b1111111;
            endcase
        end
        default: begin
            an = 4'b1111;
            seg = 7'b1111111;
        end
    endcase
end

endmodule



