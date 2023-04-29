`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2023 08:56:59
// Design Name: 
// Module Name: AlarmSound
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


module AlarmSound(
    input CLOCK,
    input alarmOn,
    output reg [11:0] audioOutput = 0
    );
    reg audioOn = 0;
    
    reg highTone = 0; 
    reg lowTone = 0;
    reg alarmState = 0; //1 for high tone, 0 for low tone

    reg [31:0] alarmStateCount = 0;
    reg [31:0] lowToneCount = 0;
    reg [31:0] highToneCount = 0;
    always @ (posedge CLOCK)
    begin
        if (alarmOn)
        begin
            audioOn <= (alarmState)? highTone : lowTone;
            audioOutput <= (audioOn)? 12'hFFF : 0;
        end
        //clock for alarmState
        alarmStateCount <= (alarmStateCount == 24999999)? 0 : alarmStateCount + 1;
        alarmState <= (alarmStateCount == 0)? ~alarmState : alarmState;
        
        //clock for lowTone
        lowToneCount <= (lowToneCount == 25309)? 0 : lowToneCount + 1;
        lowTone <= (lowToneCount == 0)? ~lowTone : lowTone;
        
        //clock for highTone
        highToneCount <= (highToneCount == 18960)? 0 : highToneCount + 1;
        highTone <= (highToneCount == 0)? ~highTone : highTone;
    end
endmodule
