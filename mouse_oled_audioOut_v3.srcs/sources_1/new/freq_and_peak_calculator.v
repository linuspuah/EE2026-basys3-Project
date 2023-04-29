`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2023 02:18:48
// Design Name: 
// Module Name: freq_and_peak_calculator
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2023 12:43:59 AM
// Design Name: 
// Module Name: freq_and_peak_calculator
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


module freq_and_peak_calculator(
    input clock,
    input J_MIC3_Pin3,
    output J_MIC3_Pin1,
    output J_MIC3_Pin4,
    output reg [11:0] peak,
    output reg [31:0] freq
    );
     
    reg [13:0] samples = 0;
    reg [11:0] current_sample = 0;
    reg [11:0] prev_sample = 0;
    wire [11:0] audio_sample;
    wire clk_10, clk_20k, clk_display;
    
    //Registers needed for zero crossing
    reg [31:0] number_samples=0;
    reg [31:0] counter=0;
    reg reset_value = 0;
    reg reset_period = 0;
    
    clk_divider clk20k (.basys_clk(clock), .m(2499), .clk(clk_20k));
    
    Audio_Input audio_input(.CLK(clock), .cs(clk_20k), .MISO(J_MIC3_Pin3), .clk_samp(J_MIC3_Pin1), .sclk(J_MIC3_Pin4), .sample(audio_sample));
    
        
    always @ (posedge clk_20k)
    begin
        if(samples < 14'd4000)
        begin
            current_sample = audio_sample;
            if(current_sample > peak) peak <= current_sample;
            samples <= samples + 1;
        end
        else
        begin
            peak <= 0;
            samples <= 0;
        end
    end
    

    always @ (posedge clk_20k) 
    begin
        counter <= counter +1;
        
        reset_value = 0;
        
        if(audio_sample > 2090)
            reset_period <= 1;
        else
            reset_period <= 0;
       
        if(number_samples == 1000)
        begin
            counter <= 0;
            freq <= (number_samples * 20000) / (counter); //counting only the zero crossings at the positive cycle
            reset_value = 1;
        end
    end
    
    always @ (posedge reset_period, posedge reset_value)
        begin
            if (reset_value == 1)
                number_samples <= 0;
            else 
                number_samples <= number_samples + 1;
        end

    

endmodule

