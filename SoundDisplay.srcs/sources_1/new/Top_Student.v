`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//
//  LAB SESSION DAY (Delete where applicable): MONDAY P.M, TUESDAY P.M, WEDNESDAY P.M, THURSDAY A.M., THURSDAY P.M
//
//  STUDENT A NAME: 
//  STUDENT A MATRICULATION NUMBER: 
//
//  STUDENT B NAME: 
//  STUDENT B MATRICULATION NUMBER: 
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input  J_MIC3_Pin3,   // Connect from this signal to Audio_Capture.v
    output J_MIC3_Pin1,   // Connect to this signal from Audio_Capture.v
    output J_MIC3_Pin4,    // Connect to this signal from Audio_Capture.v
    input CLK100MHZ,
    input [15:0] sw,
    output reg [15:0] led = 0,
    output reg [7:0] seg = 8'b11111111,
    output reg [3:0] an = 4'b1111,
    input btnD, btnU, btnC, btnL, btnR,
    output [7:0] JC
    );

    reg [3:0] state; // range 0 -> 15
    wire [3:0] state_out [0:15];
    
    always @ (*)
    begin
        if (state == 0) // main menu
        begin
            if (state_out[0] == 3) state <= 3; // game
            else if (state_out[0] == 2) state <= 2; // binh
            else if (state_out[0] == 1) state <= 1; // nigel
        end 
        
        else if (state == 1) // nigel
        begin
            if (state_out[1] == 0) state <= 0;
        end
        
        else if (state == 2) // binh
        begin
            if (state_out[2] == 0) state <= 0;
        end
        
        else if (state == 3) // game menu
        begin
            if (state_out[3] == 0) state <= 0; // main menu
            else if (state_out[3] == 4) state <= 4; // maze
        end 
        
        else if (state == 4) // maze
        begin
            if (state_out[4] == 0) state <= 0; // main
            else if (state_out[4] == 5) state <= 5; // shooting

        end
        
        else if (state == 5) // shooting game
        begin
            if (state_out[5] == 0) state <= 0; // main menu
        end
        
        
    end
    
    
    // output wires
    wire J_MIC3_Pin1_wire [0:15]; 
    wire J_MIC3_Pin4_wire [0:15];
    wire [7:0] JC_wire [0:15];
    
    wire [15:0] led_wire [0:15];
    wire [7:0] seg_wire [0:15];
    wire [3:0] an_wire [0:15];    
    
    main_menu unit_0 (state, CLK100MHZ, sw, btnD, btnU, btnC, JC_wire[0], state_out[0]);
                                             
    nigel unit_1 (state, J_MIC3_Pin3, J_MIC3_Pin1_wire[1] , J_MIC3_Pin4_wire[1],   
                  CLK100MHZ, sw, btnU, btnC, btnL, btnR, JC_wire[1], state_out[1]);
                      
    audio_binh unit_2 (state, J_MIC3_Pin3, J_MIC3_Pin1_wire[2] , J_MIC3_Pin4_wire[2],   
                       CLK100MHZ, sw, led_wire[2], seg_wire[2], an_wire[2], JC_wire[2], state_out[2]);
  
    game_menu unit_3 (state, CLK100MHZ, btnD, btnU, btnC, JC_wire[3], state_out[3]);
    
    maze unit_4 (state, CLK100MHZ, sw, btnC, btnL, btnR, btnU, btnD, JC_wire[4], seg_wire[4], an_wire[4], state_out[4]);
    
    shooting_game unit_5 (state, J_MIC3_Pin3, J_MIC3_Pin1_wire[5] , J_MIC3_Pin4_wire[5],
                          CLK100MHZ, sw, led_wire[5], seg_wire[5], an_wire[5],
                          btnD, btnU, btnC, btnL, btnR, JC_wire[5], state_out[5]);
                          
                          
//    game_over unit_9 (state, CLK100MHZ, sw, JC_wire[9], state_out[9]);
                                   
    // assign wire to output based on state                 
    assign JC = (state == 0) ? JC_wire[0] : 
                (state == 1) ? JC_wire[1] : 
                (state == 2) ? JC_wire[2] : 
                (state == 3) ? JC_wire[3] : 
                (state == 4) ? JC_wire[4] :
                JC_wire[5];
                //(state == 9) ? JC_wire[9] :
                //JC_wire[6];

    assign J_MIC3_Pin1 = (state == 1) ? J_MIC3_Pin1_wire[1] : 
                         (state == 2) ? J_MIC3_Pin1_wire[2] :
                         J_MIC3_Pin1_wire[5];
                         //J_MIC3_Pin1_wire[6];
                                                              
    assign J_MIC3_Pin4 = (state == 1) ? J_MIC3_Pin4_wire[1] : 
                         (state == 2) ? J_MIC3_Pin4_wire[2] :
                         J_MIC3_Pin4_wire[5];
                         //J_MIC3_Pin4_wire[6];  
    
    always @ (posedge CLK100MHZ)
    begin
        if (state == 0 || state == 3)
        begin
            led <= 0;
            seg <= 8'b11111111;
            an <= 4'b1111;
        end
        
        else if (state == 2)
        begin
            led <= led_wire[2];
            seg <= seg_wire[2];
            an <= an_wire[2];
        end
        
        else if (state == 1)
        begin
            led <= led_wire[1];
            seg <= seg_wire[1];
            an <= an_wire[1];
        end
        
        else if (state == 4)
        begin
            seg <= seg_wire[4];
            an <= an_wire[4];    
            led <= 0;        
        end
        
        else if (state == 5)
        begin
            seg <= seg_wire[5];
            an <= an_wire[5];    
            led <= 0;              
        end
    end                            

endmodule