`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2021 08:48:18 PM
// Design Name: 
// Module Name: random
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


module random(input clock, reset, output reg [3:0] Q = 4'b0000);
    
    always @ (posedge clock, posedge reset)
    begin
        if (reset) Q <= 0;
        else begin
            Q[3] <= Q[2];
            Q[2] <= Q[1];
            Q[1] <= Q[0];
            Q[0] <= ~(Q[2] ^ Q[3]);
        end
    end

endmodule
