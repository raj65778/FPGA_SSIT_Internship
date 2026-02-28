`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2025 18:35:43
// Design Name: 
// Module Name: main
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



module test_dht11_lcd (
    input wire clk,
    input wire rst,
    inout wire dht11_data,
    output wire lcd_rs,
    output wire lcd_en,
    output wire [3:0] lcd_data
);

wire [7:0] temperature;
wire temp_ready;

// Instantiate DHT11 interface
dht11_interface dht11_inst (
    .clk(clk),
    .rst(rst),
    .dht11_data(dht11_data),
    .temperature(temperature),
    .ready(temp_ready)
);

// Instantiate LCD controller
lcd_controller lcd_inst (
    .clk(clk),
    .rst(rst),
    .temperature(temperature),
    .lcd_rs(lcd_rs),
    .lcd_en(lcd_en),
    .lcd_data(lcd_data)
);

endmodule
