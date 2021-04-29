`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2021 02:20:11 PM
// Design Name: 
// Module Name: find_row_col
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


module find_row_col(
    input [12:0] pixel_index,output [12:0] row,output [12:0] col);
    assign row = pixel_index / 96;
    assign col = pixel_index % 96;
endmodule
