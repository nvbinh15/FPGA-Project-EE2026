`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2021 03:22:27 PM
// Design Name: 
// Module Name: clock_divider
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


module clock_divider(input basys_clock, input [31:0] m, output reg new_clock = 0);

    reg [31:0] count = 0;
    
    always @ (posedge basys_clock)
    begin
        count <= (count == m) ? 0 : count + 1;
        new_clock <= (count == 0) ? ~new_clock : new_clock;
    end
endmodule
