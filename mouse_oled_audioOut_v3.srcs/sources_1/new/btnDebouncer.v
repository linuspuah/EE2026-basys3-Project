`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2023 00:09:11
// Design Name: 
// Module Name: btnDebouncer
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


module btnDebouncer(
    input CLOCK,
    input btnIn,
    output reg btnOut = 0
    );
    //wire debounceClock;
    //clock_universal debouncerclock(.CLOCK(CLOCK),.m(123123),.SLOW_CLOCK(debounceClock));
    reg prevBtn = 0;
    reg [31:0] COUNT = 49999;
    always @ (posedge CLOCK)
    begin

        btnOut = (btnIn && !prevBtn && COUNT == 49999)? 1 : 0;
       
        COUNT = (btnIn && !prevBtn && COUNT == 49999)? 0 : ((COUNT == 49999)? COUNT : COUNT + 1);
        prevBtn = btnIn;
    end
endmodule
