`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.03.2023 01:47:41
// Design Name: 
// Module Name: debouncer
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


module debouncer(input btnIn ,clk, output reg btnOut, input taskDone);
reg holdStatus = 0;
reg [25:0] countOn = 0;
reg [25:0] countOff = 0;
always @ (posedge clk)
begin
    countOn <= (btnIn == 1)? countOn + 1: 0; //holding button causes state to alternate
    countOff  <= (btnIn == 0)? countOff + 1: 0; 
    btnOut <= (countOn == 4000001)? 1 : ((countOff == 2000001) | (taskDone))? 0 : btnOut;
    
end
endmodule 
