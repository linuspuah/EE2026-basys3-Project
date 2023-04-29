`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2023 22:43:18
// Design Name: 
// Module Name: clock_20kHz
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


module clock_20kHz(input CLOCK, output reg slow_clock = 0);

    reg [31:0] COUNT = 0;
    always @ (posedge CLOCK) 
    begin
        COUNT <= (COUNT == 2499)? 0 : COUNT + 1;
        slow_clock <= (COUNT == 0)? ~slow_clock : slow_clock;
    end
    
endmodule

