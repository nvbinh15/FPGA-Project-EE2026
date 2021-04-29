`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2021 04:09:00 PM
// Design Name: 
// Module Name: single_pulse
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


module single_pulse(input clock, input BTNC, output reg OUT = 0);
    wire sig1,sig2;
    dff mod1 (.CLOCK(clock), .IN(BTNC), .OUT(sig1));
    dff mod2 (.CLOCK(clock), .IN(sig1), .OUT(sig2));
    
    always @ (posedge clock)
        begin
            OUT <= (sig1 & ~sig2) ;
        end
endmodule
