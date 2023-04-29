`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2023 18:00:12
// Design Name: 
// Module Name: ascii_to_seg
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


//converts decimal index in ascii table to seg
// ** shows numbers 0-9 and alphabets execpt for K,T,V,X and Z
// input the respective decimal of CAPITAL letters 
module ascii_to_seg(input [7:0] index, output reg [6:0]seg);
    
    always @ (index) begin
           case (index)
               0: seg<= 7'b1000000; //show 0
               1: seg<= 7'b1111001; //show 1
               2: seg<= 7'b0100100; //show 2
               3: seg<= 7'b0110000; //show 3
               4: seg<= 7'b0011001; //show 4
               5: seg<= 7'b0010010; //show 5
               6: seg<= 7'b0000010; //show 6
               7: seg<= 7'b1111000; //show 7
               8: seg<= 7'b0000000; //show 8
               9: seg<= 7'b0010000; // show 9
               10: seg<= 7'b0001011; // show h
               11: seg<= 7'b1000000; // show -
               65: seg<= 7'b0001000;//show A
               66: seg<= 7'b0000011;//show B
               67: seg<= 7'b1000010;// show C
               68: seg<= 7'b1000000;//show D
               69: seg<= 7'b0000110;//show E
               70: seg<= 7'b0001110;//show F
               71: seg<= 7'b0000010;//show G
               72: seg<= 7'b0001001;//show H
               73: seg<= 7'b1111001; //show I
               74: seg<= 7'b1110001;//show J
               76: seg<= 7'b1000111;//show L
               77: seg<= 7'b1101010;//show M
               78: seg<= 7'b0101011;//show N
               79: seg<= 7'b0100011; //show O
               80: seg<= 7'b0001100; //show P
               81: seg<= 7'b0011000; //show Q
               82: seg<= 7'b0101111; //show R
               83: seg<= 7'b0010010; //show S
               85: seg<= 7'b1000001; //show U
               87: seg<= 7'b1010101; //show W
               89: seg<= 7'b0010001; //show Y
               90: seg<= 7'b1111111; // OFF
            
               default: seg<= 7'b1111111; // off segment
           endcase
       end
   endmodule


