`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.03.2023 02:14:22
// Design Name: 
// Module Name: groupTask
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

/**
    Basic Group Task
*/
module groupTask(input[8:0] state, input CLK ,segClk , middleMouse, leftMouse, rightMouse , input [12:0] pixel_index, indexMouse, input [15:0] sw, output reg led15, 
output reg whiteOut, greenOut, isGroupTaskDP, output reg [3:0] groupTaskNum, 
output reg [6:0] seg, output reg [3:0] an, output reg dp,
output reg [7:0] digit_L, digit_LM, digit_RM, digit_R);
reg segA, segB, segC, segD, segE, segF, segG, segAm, segBm, segCm , segDm, segEm, segFm, segGm, segAx, segBx, segCx, segDx, segEx, segFx, segGx, segOutline, greenOutline, whitePixels, num0, num1, num2, num3 ,num4, num5, num6, num7, num8, num9;
wire [7:0] x_Pindex = pixel_index % 96;
wire [7:0] y_Pindex = pixel_index / 96;
wire [7:0] x_Mouse = indexMouse % 96;
wire [7:0] y_Mouse = indexMouse / 96;
wire [6:0] seg_L_S2, seg_LM_S2, seg_RM_S2, seg_R_S2;
reg isSoundOn = 0;
reg [1:0] refreshment_counter = 0;


always @ (posedge CLK)
begin
    segA = x_Pindex <= 44 & x_Pindex >= 14 & y_Pindex <= 15 & y_Pindex >= 10; //true if pixel_index is correct position
    segB = x_Pindex <= 44 & x_Pindex >= 39 & y_Pindex <= 32 & y_Pindex >= 10; 
    segC = x_Pindex <= 44 & x_Pindex >= 39 & y_Pindex <= 49 & y_Pindex >= 27; 
    segD = x_Pindex <= 44 & x_Pindex >= 14 & y_Pindex <= 49 & y_Pindex >= 44; 
    segE = x_Pindex <= 19 & x_Pindex >= 14 & y_Pindex <= 49 & y_Pindex >= 27; 
    segF = x_Pindex <= 19 & x_Pindex >= 14 & y_Pindex <= 32 & y_Pindex >= 10;
    segG = x_Pindex <= 44 & x_Pindex >= 14 & y_Pindex <= 32 & y_Pindex >= 27; 
    greenOutline <= (x_Pindex > 0 &( x_Pindex % 58 == 0 | x_Pindex % 59 == 0 | x_Pindex % 60 == 0 )& y_Pindex <= 60) | (y_Pindex > 0 & (y_Pindex % 58 == 0 | y_Pindex % 59 == 0 | y_Pindex % 60 == 0) & x_Pindex <= 60);

if(state == 211)
begin
    whiteOut <= ((sw[0] & (segA | segB | segC | segD | segE | segF)) | ((sw[1] & ~sw[0]) & (segB | segC)) | ((sw[2] & ~sw[1] & ~sw[0]) & (segA | segB | segD | segE | segG)))? 1 : 0; 
    greenOut <= sw[10] & greenOutline;  
end
if(state == 301) // group task
begin
    segAx = segAm & segA; //true if seg supposed to be white and pixel_index is correct position
    segBx = segBm & segB; 
    segCx = segCm & segC; 
    segDx = segDm & segD; 
    segEx = segEm & segE; 
    segFx = segFm & segF;
    segGx = segGm & segG; 
    segAm <= (isSoundOn & ~sw[15])? 0:(x_Mouse <= 44 & x_Mouse >= 14 & y_Mouse <= 15 & y_Mouse >= 10)? ((leftMouse)? 1 : ((rightMouse)? 0 : segAm)) : segAm; //true if seg is supposed to be white
    segBm <= (isSoundOn & ~sw[15])? 0:(x_Mouse <= 44 & x_Mouse >= 39 & y_Mouse <= 32 & y_Mouse >= 10)? ((leftMouse)? 1 : ((rightMouse)? 0 : segBm)) : segBm; 
    segCm <= (isSoundOn & ~sw[15])? 0:(x_Mouse <= 44 & x_Mouse >= 39 & y_Mouse <= 49 & y_Mouse >= 27)? ((leftMouse)? 1 : ((rightMouse)? 0 : segCm)) : segCm;  
    segDm <= (isSoundOn & ~sw[15])? 0:(x_Mouse <= 44 & x_Mouse >= 14 & y_Mouse <= 49 & y_Mouse >= 44)? ((leftMouse)? 1 : ((rightMouse)? 0 : segDm)) : segDm;
    segEm <= (isSoundOn & ~sw[15])? 0:(x_Mouse <= 19 & x_Mouse >= 14 & y_Mouse <= 49 & y_Mouse >= 27)? ((leftMouse)? 1 : ((rightMouse)? 0 : segEm)) : segEm;
    segFm <= (isSoundOn & ~sw[15])? 0:(x_Mouse <= 19 & x_Mouse >= 14 & y_Mouse <= 32 & y_Mouse >= 10)? ((leftMouse)? 1 : ((rightMouse)? 0 : segFm)) : segFm;
    segGm <= (isSoundOn & ~sw[15])? 0:(x_Mouse <= 44 & x_Mouse >= 14 & y_Mouse <= 32 & y_Mouse >= 27)? ((leftMouse)? 1 : ((rightMouse)? 0 : segGm)) : segGm;
  
    
    num0 = segAm & segBm & segCm & segDm & segEm & segFm & ~segGm; //true if num on oled is white
    num1 = segBm & segCm & ~segAm & ~segDm & ~segEm & ~segFm & ~segGm;
    num2 = segAm & segBm & segDm & segEm & segGm & ~segCm & ~segFm;
    num3 = segAm & segBm & segCm & segDm & ~segEm & segGm & ~segFm;
    num4 = segBm & segCm & segFm & segGm & ~segAm & ~segDm & ~segEm;
    num5 = segAm & segCm & segDm & segFm & segGm & ~segBm & ~segEm;
    num6 = segAm & segCm & segDm & segEm & segFm & segGm & ~segBm;
    num7 = segAm & segBm & segCm & ~segDm & ~segEm & ~segFm & ~segGm;
    num8 = segAm & segBm & segCm & segDm & segEm & segFm & segGm;
    num9 = segAm & segBm & segCm & ~segDm & segFm & segGm & ~segEm;
    
    
    segOutline <= ((x_Pindex >= 14 & x_Pindex <= 44) & ((y_Pindex == 10) | (y_Pindex == 15) | (y_Pindex == 27) | (y_Pindex == 32) | (y_Pindex == 44) | (y_Pindex == 49))) | ((y_Pindex >= 10 & y_Pindex <= 49) & ((x_Pindex == 14) | (x_Pindex == 19) | (x_Pindex == 39) | (x_Pindex == 44)));
    whiteOut <= segOutline | segAx | segBx | segCx | segDx | segEx | segFx | segGx;
    greenOut <= sw[10] & greenOutline;            
    led15 <= (sw[15] & (num0 | num1 | num2 | num3 | num4 | num5 | num6 | num7 | num8 | num9))? 1 : 0;
    groupTaskNum <= (sw[15])? ((num0)? 1:(num1)? 2:(num2)? 3:(num3)? 4:(num4)? 5:(num5)? 6:(num6)? 7:(num7)? 8:(num8)? 9:(num9)? 10: 0): 0;
    isSoundOn <= (isSoundOn & ~sw[15])? 0 : (groupTaskNum <= 10 & groupTaskNum >= 1)? 1 : isSoundOn;
    isGroupTaskDP <= (num0 | num1 | num2 | num3 | num4 | num5 | num6 | num7 | num8 | num9);
    
    digit_L <=((num0 | num1 | num2 | num3 | num4 | num5 | num6 | num7 | num8)? 0 :(num9)? 1: 90);
    digit_LM <=((num0)? 1:(num1)? 2:(num2)? 3:(num3)? 4:(num4)? 5:(num5)? 6:(num6)? 7:(num7)? 8:(num8)? 9:(num9)? 0: 90);
    digit_RM <=90;
    digit_R <=90;
    end
end
/*
always @ (posedge segClk)
        begin
        refreshment_counter <= (refreshment_counter == 2'b11)? 2'b00:refreshment_counter+1;
        seg <= (refreshment_counter == 0 & state == 301)? seg_R_S2 : (refreshment_counter == 1 & state == 301)? seg_RM_S2: (refreshment_counter == 2 & state == 301)? seg_LM_S2: (refreshment_counter == 3 & state == 301)? seg_L_S2: 7'b1111111;
        dp <= (isGroupTaskDP & refreshment_counter == 3)? 0 : 1;
        an <= (refreshment_counter == 0 & state == 301)? 4'b1110 : (refreshment_counter == 1 & state == 301)? 4'b1101 : (refreshment_counter == 2 & state == 301)? 4'b1011 : (refreshment_counter == 3 & state == 301)? 4'b0111: an;
        end*/
endmodule
