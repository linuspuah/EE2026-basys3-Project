`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2023 22:34:24
// Design Name: 
// Module Name: grouptaskBeepResult
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


module grouptaskBeepResult(
input CLOCK,
input [3:0] selectedNum,
/*
output reg activeLED,
output reg mDurZeroLED,
output soundclockLED,
*/
output reg [11:0] audioSignal = 0
    );
    reg [31:0] COUNT = 2147483647;
    reg [31:0] mDur = 0;
    reg [3:0] prevNum = 0;
    
    wire s380;
    
    clk_divider audio_380Hz(.basys_clk(CLOCK), .m(131578),.clk(s380));
    
    always @ (posedge CLOCK)
    begin
    case (selectedNum)
                1: mDur <= 4999999;
                2: mDur <= 9999999;
                3: mDur <= 14999999;
                4: mDur <= 19999999;
                5: mDur <= 24999999;
                6: mDur <= 29999999;
                7: mDur <= 34999999;
                8: mDur <= 39999999;
                9: mDur <= 44999999;
                10: mDur <= 49999999;
                default: mDur <= 0;
            endcase
    if (selectedNum != prevNum)
    begin
        COUNT <= 0;
    end else begin
        
        COUNT <= (COUNT < mDur)? COUNT + 1 : COUNT;
        audioSignal[11] <= (COUNT < mDur)? s380 : 0;
    end
    /*
    LED for debug
    activeLED <= (COUNT < mDur)? 1 : 0;
    mDurZeroLED <= (mDur == 0)? 1 : 0;
    assign soundclockLED = s380;
    */
    prevNum <= selectedNum;
end
endmodule
