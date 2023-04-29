`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.02.2023 09:38:45
// Design Name: 
// Module Name: clk_20kHz
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


module clk_divider(output reg clk =0, input basys_clk, input [31:0]m);// input [31:0] m);
    // Delete this comment and include Basys3 inputs and outputs here
 
    reg [31:0]count=0;
    
    always @ (posedge basys_clk) begin
        count <= (count>=m)?0:count+1;
        clk<= (count==0)?~clk:clk;
    end

endmodule
