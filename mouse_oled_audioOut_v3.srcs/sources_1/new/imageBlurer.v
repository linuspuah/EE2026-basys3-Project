`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2023 01:50:55
// Design Name: 
// Module Name: imageBlurer
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


module imageBlurer(input CLOCK, input clk6p25, leftClick, rightClick, input [8:0] state,
    output reg [15:0] blurData, input [12:0] curr_pixel, mouse_index, input [15:0] sw,
    output reg [7:0] digit_L, digit_LM, digit_RM, digit_R);
    reg [12:0] kernel_pixels [0:8];
    reg [12:0] TLindex = 0, BRindex = 6143;
    reg [31:0] leftCounter;
    reg [1:0] cornerState = 0;
    reg leftClicked = 0, rightClicked = 0;
    wire [15:0] kernel_data [0:8];
    integer sumR, sumG, sumB;
    wire [7:0] x_curr_pixel = curr_pixel % 96;
    wire [7:0] y_curr_pixel = curr_pixel / 96;
    wire [7:0] TLindex_x = TLindex % 96;
    wire [7:0] TLindex_y = TLindex / 96;
    wire [7:0] BRindex_x = BRindex % 96;
    wire [7:0] BRindex_y = BRindex / 96;
    blk_mem_gen_0 mem0(.clka(CLOCK), .addra(kernel_pixels[0]), .douta(kernel_data[0]));
    blk_mem_gen_0 mem1(.clka(CLOCK), .addra(kernel_pixels[1]), .douta(kernel_data[1]));
    blk_mem_gen_0 mem2(.clka(CLOCK), .addra(kernel_pixels[2]), .douta(kernel_data[2]));
    blk_mem_gen_0 mem3(.clka(CLOCK), .addra(kernel_pixels[3]), .douta(kernel_data[3]));
    blk_mem_gen_0 mem4(.clka(CLOCK), .addra(kernel_pixels[4]), .douta(kernel_data[4]));
    blk_mem_gen_0 mem5(.clka(CLOCK), .addra(kernel_pixels[5]), .douta(kernel_data[5]));
    blk_mem_gen_0 mem6(.clka(CLOCK), .addra(kernel_pixels[6]), .douta(kernel_data[6]));
    blk_mem_gen_0 mem7(.clka(CLOCK), .addra(kernel_pixels[7]), .douta(kernel_data[7]));
    blk_mem_gen_0 mem8(.clka(CLOCK), .addra(kernel_pixels[8]), .douta(kernel_data[8]));
    always @ (posedge clk6p25)
    begin 
    if(state == 217)
    begin
    leftCounter <= (leftCounter > 7812499)? 0 : leftCounter + 1 ;
    cornerState <= (cornerState == 1 & leftClick & leftCounter == 3124000)? 2: (cornerState == 0 & leftClick & leftCounter == 3124000)? 1 :(rightClick)? 0 : cornerState;
    TLindex <= (cornerState == 0 & leftClick)? mouse_index : (rightClick)? 0 : TLindex ;
    BRindex <= (cornerState == 1 & leftClick)? mouse_index : (rightClick)? 0 : BRindex ; 
    digit_L <= (cornerState == 1)? TLindex_x/10 : (cornerState == 2)? BRindex_x/10 : 0;
    digit_LM <= (cornerState == 1)? TLindex_x%10 : (cornerState == 2)? BRindex_x%10 : 0;
    digit_RM <= (cornerState == 1)? TLindex_y/10 : (cornerState == 2)? BRindex_y/10 : 0;
    digit_R <= (cornerState == 1)? TLindex_y%10 : (cornerState == 2)? BRindex_y%10 : 0;
    kernel_pixels[0] <= (x_curr_pixel == TLindex_x)? curr_pixel : (y_curr_pixel == TLindex_y)? curr_pixel : curr_pixel - 97 ;
    kernel_pixels[1] <= (y_curr_pixel == TLindex_y)? curr_pixel : curr_pixel - 96 ;
    kernel_pixels[2] <= (x_curr_pixel == BRindex_x)? curr_pixel : (y_curr_pixel == TLindex_y)? curr_pixel : curr_pixel - 95 ;
    kernel_pixels[3] <= (x_curr_pixel == TLindex_x)? curr_pixel : curr_pixel - 1;
    kernel_pixels[4] <= curr_pixel;
    kernel_pixels[5] <= (x_curr_pixel == BRindex_x)? curr_pixel : curr_pixel + 1;
    kernel_pixels[6] <= (x_curr_pixel == TLindex_x)? curr_pixel : (y_curr_pixel == 63)? curr_pixel : curr_pixel + 95 ;
    kernel_pixels[7] <= (y_curr_pixel == BRindex_y)? curr_pixel : curr_pixel + 96 ;
    kernel_pixels[8] <= (x_curr_pixel == BRindex_x)? curr_pixel :(y_curr_pixel == BRindex_y)? curr_pixel : curr_pixel + 97 ;
    
    if(cornerState == 0 | (cornerState == 2 & x_curr_pixel < BRindex_x & x_curr_pixel > TLindex_x & y_curr_pixel < BRindex_y & y_curr_pixel > TLindex_y))
    begin
        sumR <= (kernel_data[0][15:11] + kernel_data[1][15:11] + kernel_data[2][15:11] + kernel_data[3][15:11] + kernel_data[4][15:11] + kernel_data[5][15:11] + kernel_data[6][15:11] + kernel_data[7][15:11] + kernel_data[8][15:11]) / 9;
        //sumR <= (sumR + kernel_data[4][15:11]) >> 2;
        sumG <= (kernel_data[0][10:5] + kernel_data[1][10:5] + kernel_data[2][10:5] + kernel_data[3][10:5] + kernel_data[4][10:5] + kernel_data[5][10:5] + kernel_data[6][10:5] + kernel_data[7][10:5] + kernel_data[8][10:5]) / 9;
        //sumG <= (sumG + kernel_data[4][10:5]) >> 2;
        sumB <= (kernel_data[0][4:0] + kernel_data[1][4:0] + kernel_data[2][4:0] + kernel_data[3][4:0]+ kernel_data[4][4:0] + kernel_data[5][4:0] + kernel_data[6][4:0] + kernel_data[7][4:0] + kernel_data[8][4:0]) / 9;
        //sumB <= (sumB + kernel_data[4][4:0]) >> 2;
        blurData <= sumR<<11 | ((sumG<<10)>>5) | sumB ;
    end //if within the blur box
    else begin
        blurData <= kernel_data[4];
    end
    end
    end
endmodule
