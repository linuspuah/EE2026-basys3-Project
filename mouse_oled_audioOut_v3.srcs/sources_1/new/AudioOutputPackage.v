`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2023 22:37:07
// Design Name: 
// Module Name: AudioOutputPackage
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


module AudioOutputPackage(
    input CLOCK,
    input [11:0] audioOut,
    output D1, D2, CLK_OUT, nSYNC
    );
    wire clk50MHz, clk20kHz;
    wire DONE;
    clock_50MHz clock50MHz (.CLOCK(CLOCK), .SLOW_CLOCK(clk50MHz));
    clock_20kHz clock20kHz (.CLOCK(CLOCK), .slow_clock(clk20kHz));
    Audio_Output audioout(.CLK(clk50MHz),.START(clk20kHz),.DATA1(audioOut),
        .DATA2(0),.RST(1'b0),.D1(D1),.D2(D2),.CLK_OUT(CLK_OUT),.nSYNC(nSYNC),
        .DONE(DONE));
    
endmodule
