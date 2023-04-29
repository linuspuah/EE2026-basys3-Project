`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2023 13:53:44
// Design Name: 
// Module Name: imageEditor
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


module imageEditor(
    input CLOCK,
    input [12:0] pixel_index,
    input [8:0] state,
    input [15:0] sw,
    input debounceLeft, debounceRight, debounceCentre,
    output reg taskDoneLeft = 0, taskDoneRight = 0, taskDoneCentre = 0,
    //output reg [7:0] led,
    output reg [15:0] new_image_data,
    input [15:0] raw_image_data
    );
    wire [12:0] new_index;
    wire [15:0] newImageData;
    reg [12:0] image_pixel_index, translated_pixel_index;
    image_rom imageData(.dataOut(newImageData), .pixel_index(image_pixel_index));
    
    //imageTranslator
    reg [7:0] pos_shift_index = 0;
    reg [7:0] neg_shift_index = 0;
    always @(CLOCK)
    begin
        if(state == 215)
        begin
        pos_shift_index <= (debounceCentre)? 0 : (debounceLeft & ~taskDoneLeft)? ((pos_shift_index + 1) % 96 == 0)? 0 : pos_shift_index + 1 : pos_shift_index;
        taskDoneLeft <= (debounceLeft)? 1 : 0;
        neg_shift_index <= (debounceCentre)? 0 : (debounceRight & ~taskDoneRight)? ((neg_shift_index + 1) % 96 == 0)? 0 : neg_shift_index + 1 : neg_shift_index;
        taskDoneRight <= (debounceRight)? 1 : 0;
        taskDoneCentre <= (debounceCentre)? 1 : 0;
        
        translated_pixel_index<= (neg_shift_index > pos_shift_index)? (((pixel_index % 96 < (neg_shift_index - pos_shift_index)))? pixel_index + 96 - (neg_shift_index - pos_shift_index) : pixel_index - (neg_shift_index - pos_shift_index)) : ((neg_shift_index < pos_shift_index)? 
        (((pixel_index % 96 + (pos_shift_index - neg_shift_index)) > 95)? pixel_index + (pos_shift_index - neg_shift_index) - 96 : pixel_index + (pos_shift_index - neg_shift_index)) : pixel_index);                                                          
        
        //led <= (neg_shift_index > pos_shift_index)? neg_shift_index - pos_shift_index:pos_shift_index - neg_shift_index ;
        image_pixel_index <= translated_pixel_index;      
        new_image_data <= newImageData;
        
        end
    end
endmodule
