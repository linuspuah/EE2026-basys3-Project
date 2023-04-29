`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2023 14:37:07
// Design Name: 
// Module Name: colourShiftRed
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


module colourShiftRed(
    input [15:0] imageData,
    output reg [15:0] newImageData,
    input [8:0] state,
    input debounceUp, debounceD, debounceC,
    input clk,
    output reg redBtnU = 0, redBtnD = 0, redBtnC = 0
    //output reg [7:0] led
    );
    reg [15:0] R, G, B;
    reg [7:0] pos_R_shift = 0, neg_R_shift = 0;
    always @ (clk)
    begin
    if(state == 216)//print image
        begin
            
            pos_R_shift <= (debounceC)? 0 : (debounceUp & ~redBtnU & (pos_R_shift < 7'b00011111))? pos_R_shift + 1 : pos_R_shift;
            redBtnU <= (debounceUp)? 1 : 0;
            neg_R_shift <= (debounceC)? 0 : (debounceD & ~redBtnD & (neg_R_shift < 7'b00011111))? neg_R_shift + 1 :  neg_R_shift;
            redBtnD <= (debounceD)? 1 : 0;
            redBtnC <= (debounceC)? 1 : 0;
            //end
            //led <= pos_R_shift;
            
            R <= ((neg_R_shift > pos_R_shift))? ((imageData[15:11] > (neg_R_shift - pos_R_shift))? (imageData[15:11] - (neg_R_shift - pos_R_shift)) : 0):
                ((neg_R_shift < pos_R_shift)? ((imageData[15:11] < 5'b11111 - (pos_R_shift - neg_R_shift))? (imageData[15:11] + pos_R_shift - neg_R_shift) : 5'b11111) : imageData[15:11]);            
            G <= imageData[10:5];
            B <= imageData[4:0];
            
            newImageData <= R<<11 | ((G<<10)>>5) | B ;
        end
    end
endmodule
