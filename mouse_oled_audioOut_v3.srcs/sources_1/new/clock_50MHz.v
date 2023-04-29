`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2023 22:38:40
// Design Name: 
// Module Name: clock_50MHz
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


module clock_50MHz(
    input CLOCK,
    output reg SLOW_CLOCK = 0
    );
    
    reg [31:0] COUNT = 0;
    always @ (posedge CLOCK) 
    begin
        COUNT <= (COUNT == 2)? 0 : COUNT + 1;
        SLOW_CLOCK <= (COUNT == 0)? ~SLOW_CLOCK : SLOW_CLOCK;
    end
endmodule
