`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2023 02:21:26
// Design Name: 
// Module Name: Audio_Input
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


module Audio_Input(
    input CLK,                  // 100MHz clock
    input cs,                   // sampling clock, 20kHz
    input MISO,                 // J_MIC3_Pin3, serial mic input
    output clk_samp,            // J_MIC3_Pin1
    output reg sclk,            // J_MIC3_Pin4, MIC3 serial clock
    output reg [11:0]sample     // 12-bit audio sample data
    );
    
    reg [11:0]count2 = 0;
    reg [11:0]temp = 0;
       
    reg sampled = 0;
    initial begin
        sclk = 0;
    end
    
    assign clk_samp = cs;
    
    //Creating SPI clock signals
    always @ (posedge CLK) begin
        count2 <= (cs == 0) ? count2 + 1 : 0;
        sclk <= (count2 == 50 || count2 == 100 || count2 == 150 || count2 == 200 || count2 == 250 || count2 == 300 || count2 == 350 || count2 == 400 || count2 == 450 || count2 == 500 || count2 == 550 || count2 == 600 || count2 == 650 || count2 == 700 || count2 == 750 || count2 == 800 || count2 == 850 || count2 == 900 || count2 == 950 || count2 == 1000 ||count2 == 1050 || count2 == 1100 || count2 == 1150 || count2 == 1200 || count2 == 1250 || count2 == 1300 || count2 == 1350 || count2 == 1400 || count2 == 1450 || count2 == 1500 || count2 == 1550 || count2 == 1600) ?  ~sclk  : sclk ;
    end
    
    always @ (negedge sclk) begin
        temp <= temp<<1 | MISO;
    end

    always @ (posedge cs) begin
        sample <= temp[11:0];
    end
    
endmodule
