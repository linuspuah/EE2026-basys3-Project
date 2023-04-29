`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2023 11:02:51
// Design Name: 
// Module Name: mouse_cursor
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


module mouse_cursor(input CLOCK, inout PS2Clk, PS2Data,output reg middle_reg=0, left_reg ,right_reg , output reg [11:0] xpos_reg, ypos_reg=0, output reg [12:0] indexMouse
    );
    
    wire  new_event,left,right,middle;
    wire [11:0] xpos, ypos;
    wire [3:0] zpos;
    wire frame_begin;
    wire sending_pixels;
    reg [12:0] pixel_index=0;
    wire sample_pixel;
    
    MouseCtl m1(.clk(CLOCK), .rst(0), .setx(0), .sety(0), .setmax_x(0), .setmax_y(0), .value(0),
         .left(left), .middle(middle), .right(right), .new_event(new_event), .zpos(zpos), .xpos(xpos), .ypos(ypos), .ps2_clk(PS2Clk), .ps2_data(PS2Data));
   
   always @(posedge CLOCK) begin
        middle_reg <= middle;
        left_reg <= left;
        right_reg <= right;
        ypos_reg <= ypos;
        xpos_reg <= xpos;
        indexMouse <= (((xpos_reg/10)+(ypos_reg/10)*96) % 95 == 0)? (xpos_reg/10)+(ypos_reg/10)*96 - 1 : (xpos_reg/10)+(ypos_reg/10)*96;
   end 
endmodule
