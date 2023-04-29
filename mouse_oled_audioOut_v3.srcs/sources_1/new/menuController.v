`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2023 17:16:41
// Design Name: 
// Module Name: menuController
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


module menuController(output reg [6:0] seg = 7'b1111111, output reg [3:0] an = 4'b1111, output reg dp = 1, output reg [8:0] state = 100, input game_reset_win ,game_reset_lose, rejectUnlock, win, lose, CLK, middleMouse, leftMouse, rightMouse , isGroupTaskDP, input [12:0] pixel_index, indexMouse, input [15:0] sw, output reg [14:0] led,
    input [7:0] digit_L_301, digit_LM_301, digit_RM_301, digit_R_301, digit_L_217, digit_LM_217, digit_RM_217, digit_R_217, digit_L_232, digit_LM_232, digit_R_232, ascii_R_223, ascii_RM_223,
    input [11:0] audioOut_301, audioOut_232, audioOut_231,audioOut_302alarm, audioOut_303reject,audioOut_303unlock, output reg [11:0] audioOut = 0,
    input [11:0] peak ,input [31:0] freq, input alert_mode, pattern_unlocked);
reg BOX1, BOX2, BOX3, BOX4, BOX1HOVER, BOX2HOVER, BOX3HOVER, BOX4HOVER, BACKHOVER; 
reg move_on = 0;
reg [31:0] clickTimer = 0;
wire [7:0] x_Pindex = pixel_index % 96;
wire [7:0] y_Pindex = pixel_index / 96;
wire [7:0] x_Mouse = indexMouse % 96;
wire [7:0] y_Mouse = indexMouse / 96;
wire seg_clk;
wire [6:0] segW;
wire [3:0] anW;
wire dpW;
reg [7:0] ascii_L = 90, ascii_LM = 90, ascii_RM = 90, ascii_R = 90;
clk_divider clk_1KHZ(.clk(seg_clk), .basys_clk(CLK), .m(4999));
sevenSegController segOut( .seg(segW), .an(anW), .clk(seg_clk), .ascii_L(ascii_L), .ascii_LM(ascii_LM), .ascii_RM(ascii_RM), .ascii_R(ascii_R), .dp(dpW), .isGroupTaskDP(isGroupTaskDP));

always @ (posedge CLK)
begin
    seg <= segW;
    an <= anW;
    dp <= dpW;
    clickTimer <= (clickTimer <= 12499999)? clickTimer + 1 : 0 ;
    BOX1HOVER <= (x_Mouse >= 10 & x_Mouse <= 85 & y_Mouse >= 6 & y_Mouse <= 14); 
    BOX2HOVER <= (x_Mouse >= 10 & x_Mouse <= 85 & y_Mouse >= 20 & y_Mouse <= 28);
    BOX3HOVER <= (x_Mouse >= 10 & x_Mouse <= 85 & y_Mouse >= 34 & y_Mouse <= 42);
    BOX4HOVER <= (x_Mouse >= 10 & x_Mouse <= 85 & y_Mouse >= 48 & y_Mouse <= 56);
    BACKHOVER <= (indexMouse == 293 | indexMouse == 388 | indexMouse == 389 | (indexMouse <= 485 & indexMouse >= 483) | indexMouse == 580 | indexMouse == 581 | indexMouse == 677);    
    ////led <= state;
    if(middleMouse & state != 303) // for testing purposes
        begin
        state <= 100;
        end
    if (state == 100) //MAIN MENU
    begin
        if(leftMouse & clickTimer == 0)
        begin
        if(BOX1HOVER) //indiv
            begin
            state <= 200;
            end
        if(BOX2HOVER)
            begin
            state <= 300;
            end
        end
    end //state == 100 MAIN MENU
    if (state == 200) // indiv menu
        begin
        if(leftMouse  & clickTimer == 0)
        begin
        if(BOX1HOVER) //indiv
            begin
            state <= 210;
            end
        if(BOX2HOVER)
            begin
            state <= 220;
            end
        if(BOX3HOVER)
            begin
            state <= 230;
            end
        if(BOX4HOVER)
            begin
            state <= 240;
            end
        if(BACKHOVER)
            begin
            state <= 100;
            end
        end
    end // state == 200 indiv menu
    if (state == 300) //Group menu
        begin
        if(leftMouse & clickTimer == 0)
        begin
        if(BOX1HOVER) //group task
            begin
            state <= 301;
            end
        if(BOX2HOVER) //group proj
            begin
            state <= 302;
            end
        if(BACKHOVER)
            begin
            state <= 100;
            end
        end
        end //Group menu state == 300
    if(state == 301)
    begin
    ascii_L <= digit_L_301;
    ascii_LM <= digit_LM_301;
    ascii_RM <= digit_RM_301;
    if(peak >= 2048 && peak <= 2252)
        begin
            ascii_R <= 0;
        end
        else if(peak >= 2253 && peak <= 2457)
        begin
            ascii_R <= 1;
        end
        else if(peak >= 2458 && peak <= 2662)
        begin
            ascii_R <= 2;
        end
        else if(peak >= 2663 && peak <= 2867)
        begin
            ascii_R <= 3;
        end
        else if(peak >= 2868 && peak <= 3072)
        begin
            ascii_R <= 4;
        end
        else if(peak >= 3073 && peak < 3277)
        begin
            ascii_R <= 5;
        end
        else if(peak >= 3278 && peak < 3482)
        begin
            ascii_R <= 6;
        end
        else if(peak >= 3483 && peak < 3687)
        begin
            ascii_R <= 7;
        end
        else if(peak >= 3688 && peak < 3892)
        begin
            ascii_R <= 8;
        end
        else if(peak >= 3893 && peak <= 4095)
        begin
            ascii_R <= 9;
        end
    //ascii_R <= digit_R_301;
    audioOut <= audioOut_301;
    end
    //group proj starts here========================================
    if (state >= 302 & state <= 309)//group proj
    begin 
    
    if(state==302)
    begin
        if(freq>=1100 && freq<=1200)
        begin
            move_on<=1;
        end
        else if((freq>=900 && freq<=1099) || freq>=1201 && freq<=1400)
        begin
            audioOut <= audioOut_302alarm;
        end
        else
        begin
            move_on<=0;
        end
    end
    
    if(alert_mode) 
        begin
        audioOut <= audioOut_302alarm;
        end
    if (state == 302 & move_on)//mic
    begin
    state <= 303;
    end
    
    if (state == 303)//oled
    begin
    audioOut <= (rejectUnlock)? audioOut_303reject:(pattern_unlocked)?audioOut_303unlock: 0;
    state <=(rejectUnlock)? 302 :(pattern_unlocked)? 304:state;
    end
    /*if(state == 303 & rejectUnlock)
    begin
    audioOut <= audioOut_303reject;
    end*/
    if(sw[15])
    begin
    state <= 100;
    end
    end
    if (state == 210) //LINUS MENU
        begin
            if(leftMouse & clickTimer == 0)
            begin
            if(BOX1HOVER) //basic task
                begin
                state <= 211;
                end
            if(BOX2HOVER) //indiv proj
                begin
                state <= 212;
                end
            if(BACKHOVER)
                begin
                state <= 200;
                end
            end
        end
    if (state >= 212 & state <= 217) //Linus Indiv Proj task
        begin
        if(sw == 0)
        begin
        state <= 212;
        end
        if(middleMouse) // for testing purposes
        begin
        state <= 100;
        end
        if(sw[1] & (sw[15:2] == 0))
            begin
            state <= 213; // ballmover
            end
        if(sw[2] & (sw[15:3] == 0))
            begin
            state <= 214; // photo
            end
        if(sw[3] & (sw[15:4] == 0))
            begin
            state <= 215; // left right
            end
        if(sw[4] & (sw[15:5] == 0))
            begin
            state <= 216; //red
            end
        if(sw[5] & (sw[15:6] == 0))
            begin
            state <= 217; //blur
            end
        if (state == 217)
            begin
            ascii_L <= digit_L_217;
            ascii_LM <= digit_LM_217;
            ascii_RM <= digit_RM_217;
            ascii_R <= digit_R_217;
            end// state == 217
        else begin
        ascii_L <= 90;
        ascii_LM <= 90;
        ascii_RM <= 90;
        ascii_R <= 90;
        end
        end
        
    
    if (state == 220) //HUI MENU
        begin
            if(leftMouse & clickTimer == 0)
            begin
            if(BOX1HOVER) //basic task
                begin
                state <= 221;
                end
            if(BOX2HOVER) //indiv proj
                begin
                state <= 222;
                end
            if(BACKHOVER)
                begin
                state <= 200;
                end
            end
        end
    if(state>=222 & state <=225)//hui yu indiv proj
        begin
            if(middleMouse) // for testing purposes
            begin
            state <= 100;
            end
            if(state == 222 | state == 224 | state == 225)
            begin
            ascii_R <= 0;
            ascii_RM <= 0;
            end
            if(state == 223)
            begin
            ascii_R <= ascii_R_223;
            ascii_RM <= ascii_RM_223;
            end
            if(state == 222 & rightMouse)
            begin
            state <= (middleMouse)? 100: 223;
            end
            if(state == 223 & win)
            begin
            state <= (middleMouse)? 100: 224;
            end
            if (state == 223 & lose)
            begin
            state <= (middleMouse)? 100: 225;
            end
            if (game_reset_win | game_reset_lose)
            begin
            state <= (middleMouse)? 100:222;
            /*if(middleMouse) // for testing purposes
            begin
            state <= 100;
            end
            state <= 222;*/
            end
        end//hui yu indiv proj
    if (state == 230) //HONGYAO MENU
        begin
            if(leftMouse & clickTimer == 0)
            begin
            if(BOX1HOVER) //basic task
                begin
                state <= 231;
                end
            if(BOX2HOVER) //indiv proj
                begin
                state <= 232;
                end
            if(BACKHOVER)
                begin
                state <= 200;
                end
            end
        end
    if(state == 231)
    begin
    audioOut <= audioOut_231;
    end
    if(state == 232)
            begin
            ascii_L <= digit_L_232;
            ascii_LM <= digit_LM_232;
            ascii_RM <= 90;
            ascii_R <= digit_R_232;
            audioOut <= audioOut_232;
            end
    if (state == 240) //AKHIL MENU
        begin
            if(leftMouse & clickTimer == 0)
            begin
            if(BOX1HOVER) //BOTH TASKS
                begin
                state <= 241;
                end
            if(BOX2HOVER) //indiv proj
                begin
                state <= 241;
                end
            if(BACKHOVER)
                begin
                state <= 200;
                end
            end
        end
    if(state == 241)
        begin
        case(sw)
                5'b000_00: //state of normal display
                begin
                ascii_L<=90;
                ascii_LM <= 90;
                ascii_RM <= 90;
                    if(peak >= 2048 && peak <= 2252)
                    begin
                        ascii_R <= 0;
                        led <= 9'b00000_0000;
                    end
                    else if(peak >= 2253 && peak <= 2457)
                    begin
                        ascii_R <= 1;
                        led <= 9'b00000_0001;
                    end
                    else if(peak >= 2458 && peak <= 2662)
                    begin
                        ascii_R <= 2;
                        led <= 9'b00000_0011;
                    end
                    else if(peak >= 2663 && peak <= 2867)
                    begin
                        ascii_R <= 3;
                        led <= 9'b00000_0111;
                    end
                    else if(peak >= 2868 && peak <= 3072)
                    begin
                        ascii_R <= 4;
                        led <= 9'b00000_1111;
                    end
                    else if(peak >= 3073 && peak < 3277)
                    begin
                        ascii_R <= 5;
                        led <= 9'b00001_1111;
                    end
                    else if(peak >= 3278 && peak < 3482)
                    begin
                        ascii_R <= 6;
                        led <= 9'b00011_1111;
                    end
                    else if(peak >= 3483 && peak < 3687)
                    begin
                        ascii_R <= 7;
                        led <= 9'b00111_1111;
                    end
                    else if(peak >= 3688 && peak < 3892)
                    begin
                        ascii_R <= 8;
                        led <= 9'b01111_1111;
                    end
                    else if(peak >= 3893 && peak <= 4095)
                    begin
                        ascii_R <= 9;
                        led <= 9'b11111_1111;
                    end
                end
                
                5'b000_01: //Chromatic Scale
                begin
                ascii_RM<=90;
                    if(freq>=440 && freq<=465)
                    begin
                    // A Octave 4
                    ascii_L <= 65;
                    ascii_LM <= 90;
                    ascii_R <= 4;
                    end
        
                    else if(freq>=466 && freq<=493)
                    begin
                    // A# Ocatve 4
                    ascii_L <=65;
                    ascii_LM<=10;
                    ascii_R <= 4;
                    end
        
                    else if(freq>=494 && freq<=522)
                    begin
                    // B Octave 5
                    ascii_L <= 66;
                    ascii_LM <= 90;
                    ascii_R <= 4;
                    end
        
                    else if(freq>=523 && freq<=554)
                    begin
                    // C Octave 5            
                    ascii_L <= 67;
                    ascii_LM <= 90;
                    ascii_R <= 5;
                    end
        
                    else if(freq>=555 && freq<=587)
                    begin
                    // C# Octave 5
                    ascii_L <= 67;
                    ascii_LM <= 10;
                    ascii_R <= 5;
                    
                    end
        
                    else if(freq>=588 && freq<=622)
                    begin
                    // D Octave 5            
                    ascii_L <= 68;
                    ascii_LM <= 90;
                    ascii_R <= 5;
        
                    end
        
                    else if(freq>=623 && freq<=659)
                    begin
                    // D# Octave 5            
                    ascii_L <= 68;
                    ascii_LM <= 10;
                    ascii_R <= 5;
        
                    end
        
                    else if(freq>=660 && freq<=698)
                    begin
                    // E Oct 5            
                    ascii_L <= 69;
                    ascii_LM <= 90;
                    ascii_R <= 5;
        
                    end
        
                    else if(freq>=699 && freq<=739)
                    begin
                    // F Oct 5            
                    ascii_L <= 70;
                    ascii_LM <= 90;
                    ascii_R <= 5;
        
                    end
        
                    else if(freq>=740 && freq<=784)
                    begin
                    // F# Oct 5            
                    ascii_L <= 67;
                    ascii_LM <= 10;
                    ascii_R <= 5;
        
                    end
        
                    else if(freq>=785 && freq<=830)
                    begin
                    // G Oct 5            
                    ascii_L <= 71;
                    ascii_LM <= 90;
                    ascii_R <= 5;
        
                    end
        
                    else if(freq>=831 && freq<=879)
                    begin
                    // G# Oct 5            
                    ascii_L <= 71;
                    ascii_LM <= 10;
                    ascii_R <= 5;
        
                    end
        
                    else if(freq>=880 && freq<=932)
                    begin
                    // A Oct 5            
                    ascii_L <= 65;
                    ascii_LM <= 90;
                    ascii_R <= 5;
        
                    end
        
                    else if(freq>=933 && freq<=987)
                    begin 
                    //A# 5           
                    ascii_L <= 65;
                    ascii_LM <= 10;
                    ascii_R <= 5;
                    
                    end
        
                    else if(freq>=987 && freq<=1046)
                    begin
                    // B Oct 5            
                    ascii_L <= 66;
                    ascii_LM <= 90;
                    ascii_R <= 5;
        
                    end
        
                    else if(freq>=1047 && freq<=1108)
                    begin
                    // C Oct 6            
                    ascii_L <= 67;
                    ascii_LM <= 90;
                    ascii_R <= 6;
                    end
        
                    else if(freq>=1109 && freq<=1174)
                    begin
                    // C# Oct 6            
                    ascii_L <= 67;
                    ascii_LM <= 10;
                    ascii_R <= 6;
                    end
        
                    else if(freq>=1175 && freq<=1244)
                    begin
                    // D Oct 6            
                    ascii_L <= 68;
                    ascii_LM <= 90;
                    ascii_R <= 6;
                    end
        
                    else if(freq>=1245 && freq<=1318)
                    begin
                    // D# Oct 6            
                    ascii_L <= 68;
                    ascii_LM <= 10;
                    ascii_R <= 6;
                    end
        
                    else if(freq>=1319 && freq<=1396)
                    begin
                    // E 6            
                    ascii_L <= 69;
                    ascii_LM <= 90;
                    ascii_R <= 6;
                    end
        
                    else if(freq>=1397 && freq<=1479)
                    begin
                    //F 6            
                    ascii_L <= 70;
                    ascii_LM <= 90;
                    ascii_R <= 6;
                    end
        
                    else if(freq>=1480 && freq<=1567)
                    begin
                    // F# 6            
                    ascii_L <= 70;
                    ascii_LM <= 10;
                    ascii_R <= 6;
                    end
        
                    else if(freq>=1568 && freq<=1661)
                    begin
                    //G 6            
                    ascii_L <= 71;
                    ascii_LM <= 90;
                    ascii_R <= 6;
                    end
        
                    else if(freq>=1662 && freq<=1759)
                    begin
                    //G# 6            
                    ascii_L <= 71;
                    ascii_LM <= 10;
                    ascii_R <= 6;
                    end
        
                    else if(freq>=1760 && freq<=1864)
                    begin
                    //A 6            
                    ascii_L <= 65;
                    ascii_LM <= 90;
                    ascii_R <= 6;
                    end
        
                    else if(freq>=1865 && freq<=1975)
                    begin
                    //A# 6            
                    ascii_L <= 65;
                    ascii_LM <= 10;
                    ascii_R <= 6;
                    end
                    
                    else if(freq>=1976 && freq<=2093)
                    begin
                    //B 6            
                    ascii_L <= 66;
                    ascii_LM <= 90;
                    ascii_R <= 6;
                    end
        
                    else if(freq>=2094 && freq<=2217)
                    begin
                    //C 7            
                    ascii_L <= 67;
                    ascii_LM <= 90;
                    ascii_R <= 7;
                    end
                    
                    else if(freq>=2218 && freq<=2349)
                    begin
                    //C# 7            
                    ascii_L <= 67;
                    ascii_LM <= 10;
                    ascii_R <= 7;
                    end
        
                    else if(freq>=2350 && freq<=2489)
                    begin
                    //D 7            
                    ascii_L <= 68;
                    ascii_LM <= 90;
                    ascii_R <= 7;
                    end
        
                    else if(freq>=2490 && freq<=2637)
                    begin
                    //D# 7            
                    ascii_L <= 68;
                    ascii_LM <= 10;
                    ascii_R <= 7;
                    end
                    
                    else if(freq>=2638 && freq<=2793)
                    begin
                    //E 7            
                    ascii_L <= 69;
                    ascii_LM <= 90;
                    ascii_R <= 7;
                    end
                    
                    else if(freq>=2794 && freq<=2959)
                    begin
                    //F 7            
                    ascii_L <= 70;
                    ascii_LM <= 90;
                    ascii_R <= 7;
                    end
                    
                    else if(freq>=3000 && freq<=3135)
                    begin
                    //F# 7            
                    ascii_L <= 70;
                    ascii_LM <= 10;
                    ascii_R <= 7;
                    end
        
                    else if(freq>=3136 && freq<=3322)
                    begin
                    //G 7            
                    ascii_L <= 71;
                    ascii_LM <= 90;
                    ascii_R <= 7;
                    end
                    
                    else if(freq>=3323 && freq<=3519)
                    begin
                    //G# 7            
                    ascii_L <= 71;
                    ascii_LM <= 10;
                    ascii_R <= 7;
                    end
        
                    else if(freq>=3520 && freq<=3729)
                    begin
                    //A 7            
                    ascii_L <= 65;
                    ascii_LM <= 90;
                    ascii_R <= 7;
                    end
                    
                    else if(freq>=3730 && freq<=3951)
                    begin
                    //A# 7            
                    ascii_L <= 65;
                    ascii_LM <= 10;
                    ascii_R <= 7;
                    end
                    
                    else if(freq>=3952 && freq<=4186)
                    begin
                    //B 7            
                    ascii_L <= 66;
                    ascii_LM <= 90;
                    ascii_R <= 7;
                    end
                    
                    else if(freq>=4187 && freq<=4434)
                    begin
                    //C 8            
                    ascii_L <= 67;
                    ascii_LM <= 90;
                    ascii_R <= 8;
                    end
                    
                    else if(freq>=4435 && freq<=4698)
                    begin
                    //C# 8            
                    ascii_L <= 67;
                    ascii_LM <= 10;
                    ascii_R <= 8;
                    end
                    
                    else if(freq>=4699 && freq<=4978)
                    begin
                    //D 8            
                    ascii_L <= 68;
                    ascii_LM <= 90;
                    ascii_R <= 8;
                    end
                    
                    else if(freq>=4979 && freq<=5274)
                    begin
                    //D# 9            
                    ascii_L <= 68;
                    ascii_LM <= 10;
                    ascii_R <= 8;
                    end
                    
                    else if(freq>=5275 && freq<=5587)
                    begin
                    //E 9            
                    ascii_L <= 69;
                    ascii_LM <= 90;
                    ascii_R <= 8;
                    end
        
                    else if(freq>=5588 && freq<=5919)
                    begin
                    //F 9            
                    ascii_L <= 70;
                    ascii_LM <= 90;
                    ascii_R <= 8;
                    end
                    
                    else if(freq>=5920 && freq<=6271)
                    begin
                    //F# 9            
                    ascii_L <= 70;
                    ascii_LM <= 10;
                    ascii_R <= 8;
                    end
                    
                    else if(freq>=6272 && freq<=6644)
                    begin
                    //G 9            
                    ascii_L <= 71;
                    ascii_LM <= 90;
                    ascii_R <= 8;
                    end
                    
                    else if(freq>=6645 && freq<=7039)
                    begin
                    //G# 9            
                    ascii_L <= 71;
                    ascii_LM <= 10;
                    ascii_R <= 8;
                    end
        
                    else if(freq>=7040 && freq<=7458)
                    begin
                    //A 9            
                    ascii_L <= 65;
                    ascii_LM <= 90;
                    ascii_R <= 8;
                    end
        
                    else if(freq>=7459 && freq<=7902)
                    begin
                    //A# 9            
                    ascii_L <= 65;
                    ascii_LM <= 10;
                    ascii_R <= 8;
                    end
        
                end
                
                5'b000_10: // Major Scale
                begin
                ascii_RM<=90;
                ascii_LM <= 90;
                    if(freq>=440 && freq<=493)
                    begin
                    // A Octave 0
                    ascii_L <= 65;
                    ascii_LM <= 90;
                    ascii_R <= 0;
                    end
        
                    else if(freq>=494 && freq<=523)
                    begin
                    // B Ocatve 0
                    ascii_L <=66;
                    ascii_LM<=90;
                    ascii_R <= 0;
                    end
        
                    else if(freq>=524 && freq<=587)
                    begin
                    // C Octave 1
                    ascii_L <= 67;
                    ascii_LM <= 90;
                    ascii_R <= 1;
                    end
        
                    else if(freq>=588 && freq<=659)
                    begin
                    // D Octave 1           
                    ascii_L <= 68;
                    ascii_LM <= 90;
                    ascii_R <= 1;
                    end
        
                    else if(freq>=660 && freq<=698)
                    begin
                    // E Octave 1
                    ascii_L <= 69;
                    ascii_LM <= 90;
                    ascii_R <= 1;
                    
                    end
        
                    else if(freq>=699 && freq<=783)
                    begin
                    // F Octave 1            
                    ascii_L <= 70;
                    ascii_LM <= 90;
                    ascii_R <= 1;
        
                    end
        
                    else if(freq>=784 && freq<=879)
                    begin
                    // G Octave 1            
                    ascii_L <= 71;
                    ascii_LM <= 90;
                    ascii_R <= 1;
        
                    end
        
                    else if(freq>=880 && freq<=987)
                    begin
                    // A Octave 1            
                    ascii_L <= 65;
                    ascii_LM <= 90;
                    ascii_R <= 1;
        
                    end
        
                    else if(freq>=988 && freq<=1046)
                    begin
                    // B Octave 1            
                    ascii_L <= 66;
                    ascii_LM <= 90;
                    ascii_R <= 1;
        
                    end
        
                    else if(freq>=1047 && freq<=1174)
                    begin
                    // C Octave 2            
                    ascii_L <= 67;
                    ascii_LM <= 90;
                    ascii_R <= 2;
        
                    end
        
                    else if(freq>=1175 && freq<=1318)
                    begin
                    // D Octave 2            
                    ascii_L <= 68;
                    ascii_LM <= 90;
                    ascii_R <= 2;
        
                    end
        
                    else if(freq>=1319 && freq<=1396)
                    begin
                    // E Octave 2            
                    ascii_L <= 69;
                    ascii_LM <= 90;
                    ascii_R <= 2;
        
                    end
        
                    else if(freq>=1397 && freq<=1567)
                    begin 
                    // F Octave 2           
                    ascii_L <= 70;
                    ascii_LM <= 90;
                    ascii_R <= 2;
                    
                    end
        
                    else if(freq>=1568 && freq<=1759)
                    begin
                    // G Octave 2            
                    ascii_L <= 71;
                    ascii_LM <= 90;
                    ascii_R <= 2;
        
                    end
        
                    else if(freq>=1760 && freq<=1975)
                    begin
                    // A Octave 2            
                    ascii_L <= 65;
                    ascii_LM <= 90;
                    ascii_R <= 2;
                    end
        
                    else if(freq>=1976 && freq<=2093)
                    begin
                    // B Octave 2            
                    ascii_L <= 66;
                    ascii_LM <= 90;
                    ascii_R <= 2;
                    end
        
                    else if(freq>=2094 && freq<=2349)
                    begin
                    // C Octave 3            
                    ascii_L <= 67;
                    ascii_LM <= 90;
                    ascii_R <= 3;
                    end
        
                    else if(freq>=2350 && freq<=2637)
                    begin
                    // D Octave 3            
                    ascii_L <= 68;
                    ascii_LM <= 90;
                    ascii_R <= 3;
                    end
        
                    else if(freq>=2638 && freq<=2793)
                    begin
                    // E Octave 3         
                    ascii_L <= 69;
                    ascii_LM <= 90;
                    ascii_R <= 3;
                    end
        
                    else if(freq>=2794 && freq<=3135)
                    begin
                    // F Octave 3            
                    ascii_L <= 70;
                    ascii_LM <= 90;
                    ascii_R <= 3;
                    end
        
                    else if(freq>=3136 && freq<=3519)
                    begin
                    // G Octave 3            
                    ascii_L <= 71;
                    ascii_LM <= 90;
                    ascii_R <= 3;
                    end
        
                    else if(freq>=3520 && freq<=3951)
                    begin
                    // A Octave 3            
                    ascii_L <= 65;
                    ascii_LM <= 90;
                    ascii_R <= 3;
                    end
        
                    else if(freq>=3952 && freq<=4186)
                    begin
                    // B Octave 3           
                    ascii_L <= 66;
                    ascii_LM <= 90;
                    ascii_R <= 3;
                    end
        
                    else if(freq>=4187 && freq<=4698)
                    begin
                    // C Octave 4           
                    ascii_L <= 67;
                    ascii_LM <= 90;
                    ascii_R <= 4;
                    end
        
                    else if(freq>=4699 && freq<=5274)
                    begin
                    // D Octave 4            
                    ascii_L <= 68;
                    ascii_LM <= 90;
                    ascii_R <= 4;
                    end
                    
                    else if(freq>=5275 && freq<=5587)
                    begin
                    // E Octave 4            
                    ascii_L <= 69;
                    ascii_LM <= 90;
                    ascii_R <= 4;
                    end
        
                    else if(freq>=5588 && freq<=6271)
                    begin
                    // F Octave 4        
                    ascii_L <= 70;
                    ascii_LM <= 90;
                    ascii_R <= 4;
                    end
                    
                    else if(freq>=6272 && freq<=7039)
                    begin
                    // G Octave 4           
                    ascii_L <=71;
                    ascii_LM <=90;
                    ascii_R <= 4;
                    end
        
                    else if(freq>=7040 && freq<=7902)
                    begin
                    // A Octave 4            
                    ascii_L <= 65;
                    ascii_LM <= 90;
                    ascii_R <= 4;
                    end
                
                end
                
                5'b001_00: // Whole Tone Scale
                begin
                ascii_RM<=90;
                    if(freq>=415 && freq<=466)
                    begin
                    // G# Octave 0
                    ascii_L <= 71;
                    ascii_LM <= 10;
                    ascii_R <= 0;
                    end
        
                    else if(freq>=467 && freq<=523)
                    begin
                    // A# Octave 0
                    ascii_L <=65;
                    ascii_LM<=10;
                    ascii_R <= 0;
                    end
        
                    else if(freq>=524 && freq<=587)
                    begin
                    // C Octave 1
                    ascii_L <= 67;
                    ascii_LM <= 90;
                    ascii_R <= 1;
                    end
        
                    else if(freq>=588 && freq<=659)
                    begin
                    // D Octave 1           
                    ascii_L <= 68;
                    ascii_LM <= 90;
                    ascii_R <= 1;
                    end
        
                    else if(freq>=660 && freq<=739)
                    begin
                    // E Octave 1
                    ascii_L <= 69;
                    ascii_LM <= 90;
                    ascii_R <= 1;
                    
                    end
        
                    else if(freq>=740 && freq<=830)
                    begin
                    // F# Octave 1            
                    ascii_L <= 70;
                    ascii_LM <= 10;
                    ascii_R <= 1;
        
                    end
        
                    else if(freq>=831 && freq<=932)
                    begin
                    // G# Octave 1            
                    ascii_L <= 71;
                    ascii_LM <= 10;
                    ascii_R <= 1;
        
                    end
        
                    else if(freq>=933 && freq<=1046)
                    begin
                    // A# Octave 1            
                    ascii_L <= 65;
                    ascii_LM <= 10;
                    ascii_R <= 1;
        
                    end
        
                    else if(freq>=1047 && freq<=1174)
                    begin
                    // C Octave 2            
                    ascii_L <= 67;
                    ascii_LM <= 90;
                    ascii_R <= 2;
        
                    end
        
                    else if(freq>=1175 && freq<=1318)
                    begin
                    // D Octave 2            
                    ascii_L <= 68;
                    ascii_LM <= 90;
                    ascii_R <= 2;
        
                    end
        
                    else if(freq>=1319 && freq<=1479)
                    begin
                    // E Octave 2            
                    ascii_L <= 69;
                    ascii_LM <= 90;
                    ascii_R <= 2;
        
                    end
        
                    else if(freq>=1480 && freq<=1661)
                    begin
                    // F# Octave 2            
                    ascii_L <= 70;
                    ascii_LM <= 10;
                    ascii_R <= 2;
        
                    end
        
                    else if(freq>=1662 && freq<=1864)
                    begin 
                    // G# Octave 2           
                    ascii_L <= 71;
                    ascii_LM <= 10;
                    ascii_R <= 2;
                    
                    end
        
                    else if(freq>=1865 && freq<=2093)
                    begin
                    // A# Octave 2            
                    ascii_L <= 65;
                    ascii_LM <= 10;
                    ascii_R <= 2;
        
                    end
        
                    else if(freq>=2094 && freq<=2349)
                    begin
                    // C Octave 3            
                    ascii_L <= 67;
                    ascii_LM <= 90;
                    ascii_R <= 3;
                    end
        
                    else if(freq>=2350 && freq<=2637)
                    begin
                    // D Octave 3            
                    ascii_L <= 68;
                    ascii_LM <= 90;
                    ascii_R <= 2;
                    end
        
                    else if(freq>=2638 && freq<=2959)
                    begin
                    // E Octave 3            
                    ascii_L <= 69;
                    ascii_LM <= 90;
                    ascii_R <= 3;
                    end
        
                    else if(freq>=2960 && freq<=3322)
                    begin
                    // F# Octave 3            
                    ascii_L <= 70;
                    ascii_LM <= 10;
                    ascii_R <= 3;
                    end
        
                    else if(freq>=3323 && freq<=3729)
                    begin
                    // G# Octave 3         
                    ascii_L <= 71;
                    ascii_LM <= 10;
                    ascii_R <= 3;
                    end
        
                    else if(freq>=3730 && freq<=4186)
                    begin
                    // A# Octave 3            
                    ascii_L <= 65;
                    ascii_LM <= 10;
                    ascii_R <= 3;
                    end
        
                    else if(freq>=4187 && freq<=4698)
                    begin
                    // C Octave 4            
                    ascii_L <= 67;
                    ascii_LM <= 90;
                    ascii_R <= 4;
                    end
        
                    else if(freq>=4699 && freq<=5274)
                    begin
                    // D Octave 4            
                    ascii_L <= 68;
                    ascii_LM <= 90;
                    ascii_R <= 4;
                    end
        
                    else if(freq>=5275 && freq<=5919)
                    begin
                    // E Octave 4           
                    ascii_L <= 69;
                    ascii_LM <= 90;
                    ascii_R <= 4;
                    end
        
                    else if(freq>=5920 && freq<=6644)
                    begin
                    // F# Octave 4           
                    ascii_L <= 70;
                    ascii_LM <= 10;
                    ascii_R <= 4;
                    end
        
                    else if(freq>=6645 && freq<=7458)
                    begin
                    // G# Octave 4            
                    ascii_L <= 71;
                    ascii_LM <= 10;
                    ascii_R <= 4;
                    end     
                
                end
                
                
                5'b010_00: // Indian Scale
                begin
                ascii_RM<=90;
                    if(freq>=466 && freq<=523)
                    begin
                    // Sa Octave 0
                    ascii_L <= 78;
                    ascii_LM <= 73;
                    ascii_R <= 0;
                    end
        
                    else if(freq>=524 && freq<=587)
                    begin
                    // Re Octave 0
                    ascii_L <=83;
                    ascii_LM<=65;
                    ascii_R <= 0;
                    end
        
                    else if(freq>=588 && freq<=659)
                    begin
                    // Ga Octave 0
                    ascii_L <= 71;
                    ascii_LM <= 65;
                    ascii_R <= 0;
                    end
        
                    else if(freq>=660 && freq<=698)
                    begin
                    // Ma Octave 0           
                    ascii_L <= 77;
                    ascii_LM <= 65;
                    ascii_R <= 0;
                    end
        
                    else if(freq>=699 && freq<=783)
                    begin
                    // Pa Octave 0
                    ascii_L <= 80;
                    ascii_LM <= 65;
                    ascii_R <= 0;
                    
                    end
        
                    else if(freq>=784 && freq<=932)
                    begin
                    // Da Octave 0            
                    ascii_L <= 68;
                    ascii_LM <= 65;
                    ascii_R <= 0;
        
                    end
        
                    else if(freq>=933 && freq<=1046)
                    begin
                    // Ni Octave 0            
                    ascii_L <= 78;
                    ascii_LM <= 73;
                    ascii_R <= 0;
        
                    end
        
                    else if(freq>=1047 && freq<=1174)
                    begin
                    // Sa Octave 1            
                    ascii_L <= 83;
                    ascii_LM <= 65;
                    ascii_R <= 1;
        
                    end
        
                    else if(freq>=1175 && freq<=1318)
                    begin
                    // Re Octave 1            
                    ascii_L <= 82;
                    ascii_LM <= 69;
                    ascii_R <= 1;
        
                    end
        
                    else if(freq>=1319 && freq<=1396)
                    begin
                    // Ga Octave 1            
                    ascii_L <= 71;
                    ascii_LM <= 65;
                    ascii_R <= 1;
        
                    end
        
                    else if(freq>=1397 && freq<=1567)
                    begin
                    // Ma Octave 1           
                    ascii_L <= 77;
                    ascii_LM <= 65;
                    ascii_R <= 1;
        
                    end
        
                    else if(freq>=1568 && freq<=1864)
                    begin
                    // Pa Octave 1            
                    ascii_L <= 80;
                    ascii_LM <= 65;
                    ascii_R <= 1;
        
                    end
        
                    else if(freq>=1865 && freq<=2039)
                    begin 
                    // Da Octave 1           
                    ascii_L <= 68;
                    ascii_LM <= 65;
                    ascii_R <= 1;
                    
                    end
        
                    else if(freq>=2094 && freq<=2349)
                    begin
                    // Ni Octave 1            
                    ascii_L <= 78;
                    ascii_LM <=73;
                    ascii_R <= 1;
        
                    end
        
                    else if(freq>=2350 && freq<=2637)
                    begin
                    // Sa Octave 2            
                    ascii_L <= 83;
                    ascii_LM <= 65;
                    ascii_R <= 2;
                    end
        
                    else if(freq>=2638 && freq<=2793)
                    begin
                    // Re Octave 2            
                    ascii_L <= 82;
                    ascii_LM <= 69;
                    ascii_R <= 2;
                    end
        
                    else if(freq>=2794 && freq<=3135)
                    begin
                    // Ga Octave 2            
                    ascii_L <= 71;
                    ascii_LM <= 65;
                    ascii_R <= 2;
                    end
        
                    else if(freq>=3136 && freq<=3729)
                    begin
                    // Ma Octave 2            
                    ascii_L <= 77;
                    ascii_LM <= 65;
                    ascii_R <= 2;
                    end
        
                    else if(freq>=3730 && freq<=4186)
                    begin
                    // Pa Octave 2         
                    ascii_L <= 80;
                    ascii_LM <= 65;
                    ascii_R <= 2;
                    end
        
                    else if(freq>=4187 && freq<=4698)
                    begin
                    // Da Octave 2            
                    ascii_L <= 68;
                    ascii_LM <= 65;
                    ascii_R <= 2;
                    end
        
                    else if(freq>=4699 && freq<=5274)
                    begin
                    // Ni Octave 2            
                    ascii_L <= 78;
                    ascii_LM <= 73;
                    ascii_R <= 2;
                    end
        
                    else if(freq>=5275 && freq<=5587)
                    begin
                    // Sa Octave 3            
                    ascii_L <= 83;
                    ascii_LM <= 65;
                    ascii_R <= 3;
                    end
        
                    else if(freq>=5588 && freq<=6271)
                    begin
                    // Re Octave 3           
                    ascii_L <= 82;
                    ascii_LM <= 69;
                    ascii_R <= 3;
                    end
        
                    else if(freq>=6272 && freq<=7458)
                    begin
                    // Ga Octave 3           
                    ascii_L <= 71;
                    ascii_LM <= 65;
                    ascii_R <= 3;
                    end
        
                    else if(freq>=7459 && freq<=8372)
                    begin
                    // Ma Octave 3            
                    ascii_L <= 77;
                    ascii_LM <= 65;
                    ascii_R <= 4;
                    end     
        
                    else if(freq>=8373 && freq<=9397)
                    begin
                    // Pa Octave 3            
                    ascii_L <= 80;
                    ascii_LM <= 65;
                    ascii_R <= 3;
                    end     
        
                    else if(freq>=9398 && freq<=10548)
                    begin
                    // Da Octave 3            
                    ascii_L <= 68;
                    ascii_LM <= 65;
                    ascii_R <= 3;
                    end     
        
                    else if(freq>=10549 && freq<=11175)
                    begin
                    // Ni Octave 3            
                    ascii_L <= 78;
                    ascii_LM <= 73;
                    ascii_R <= 3;
                    end     
        
                    else if(freq>=11176 && freq<=12543)
                    begin
                    // Sa Octave 4            
                    ascii_L <= 83;
                    ascii_LM <= 65;
                    ascii_R <= 4;
                    end     
        
                    else if(freq>=12544 && freq<=14917)
                    begin
                    // Re Octave 4            
                    ascii_L <= 82;
                    ascii_LM <= 69;
                    ascii_R <= 4;
                    end     
        
                
                end
                5'b100_00: //state of exact frequency display
                begin
                    ascii_L <= freq/1000;
                    ascii_LM <= (freq/100) % 10;
                    ascii_RM <= (freq/10) % 10;
                    ascii_R <= freq % 10;
                end
                endcase
        end// state == 241
end
endmodule

