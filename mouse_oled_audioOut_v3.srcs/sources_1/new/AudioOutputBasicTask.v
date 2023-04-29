`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2023 07:29:40
// Design Name: 
// Module Name: AudioOutputBasicTask
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


module AudioOutputBasicTask(
    input CLOCK,
    input BTN,
    input sw,
    output reg [11:0] audioOut = 0
    );
    
    reg lowTone = 0;    //190Hz
    reg highTone = 0;   //380Hz
    
    reg [31:0] lowToneCount = 0;
    reg [31:0] highToneCount = 0;

    reg [31:0] btnCount = 2147483647;
    reg prevState = 0;
    reg active = 0;
        always @ (posedge CLOCK)
        begin
        //btn debounce
            if (BTN && !prevState)
            begin
                btnCount <= 0;
            end else
            begin
                if (btnCount <= 90000000)
                begin
                    btnCount <= btnCount + 1;
                    active <= 1;
                end else
                begin
                    active <= 0;
                end
            end
            prevState <= BTN;
        
        //audio
        if (active)
        begin
            if (sw)
            begin
                audioOut <= (lowTone)? 12'hFFF : 0;
            end else
            begin
                audioOut <= (highTone)? 12'h800 : 0;
            end
            
        end
        
        //tone clocks
        lowToneCount <= (lowToneCount == 263156)? 0 : lowToneCount + 1;
        lowTone <= (lowToneCount == 0)? ~lowTone : lowTone;
        
        highToneCount <= (highToneCount == 131578)? 0 : highToneCount + 1;
        highTone <= (highToneCount == 0)? ~highTone : highTone;
        end
endmodule
