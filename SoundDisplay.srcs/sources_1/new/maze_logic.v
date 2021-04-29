`timescale 1ns / 1ps

module maze_logic(
    input hard_reset,   //reset COUNTDOWN
    input activated,    //sync timer,
    input clk1,         //1 hz
    input clk381,
    output reg game_over,   //1 if gamemover
    output reg [3:0] an,    //anode
    output reg [7:0] seg,   //seg
    input fclock,
    input BTNU_sig,
    input BTNL_sig,
    input BTNR_sig,
    input BTNC_sig,
    input BTND_sig,
    input clk_10hz,
    output reg [12:0] row = 4,  //this is the row of the player
    output reg [12:0] col = 0,  //this is the col of the player
    //generate obstacles
    input [12:0] row_query, //this is the running input from the display
    input [12:0] col_query, //this is the running input from the display
    output state,            //0 == free, 1 == obstacle etc.
    output reg clear = 0,
    output reg transposed = 0,
    input hacks_on
    );
    
    //simple countdown
    reg [5:0] COUNTDOWN = 60;
    integer COUNT_A = 6;
    integer COUNT_B = 0;
    //assign game_over;  //1 if countdown = 0
    always @ (posedge clk1 or posedge hard_reset)
    begin
        if (activated == 1)     //ensures sync
            begin
                //implement subtraction
                if ((COUNT_A != 0 || COUNT_B != 0) && (clear == 0)) begin
                COUNT_B = (COUNT_B > 0)? COUNT_B - 1 : 9;
                COUNT_A = (COUNT_B == 9)? COUNT_A - 1: COUNT_A;
                COUNTDOWN = (COUNTDOWN > 0)? COUNTDOWN - 1 : 0;
                end
            end
        if (hard_reset == 1)
            begin
                COUNTDOWN = 60;
                COUNT_A = 6;
                COUNT_B = 0;
                game_over = 0;
            end
        else if (COUNTDOWN == 0) game_over = 1;
       
    end
    
    // counter for segment display
        reg [2:0] count = 0;
        always @ (posedge clk381)
        begin
            if (activated == 1) begin
            if (count != 3'd3) count <= count + 1;
            else count <= 0;
            end
        end
     //display countdown on 7-seg 
     // control led and 7-seg display    
         always @ (posedge fclock)
             begin 
             if (game_over == 0) begin
             case (count)
                2:           
                             case (COUNT_A)
                                 0: begin an <= 4'b1101; seg <= 8'b11000000;end 
                                 1: begin an <= 4'b1101; seg <= 8'b11111001;end
                                 2: begin an <= 4'b1101; seg <= 8'b10100100;end
                                 3: begin an <= 4'b1101; seg <= 8'b10110000;end 
                                 4: begin an <= 4'b1101; seg <= 8'b10011001;end 
                                 5: begin an <= 4'b1101; seg <= 8'b10010010;end
                                 6: begin an <= 4'b1101; seg <= 8'b10000010; end
                                 7: begin an <= 4'b1101; seg <= 8'b11111000; end 
                                 8: begin an <= 4'b1101; seg <= 8'b10000000; end 
                                 9: begin an <= 4'b1101; seg <= 8'b10010000; end
                              endcase

                3:           
                              case (COUNT_B)
                                          0: begin an <= 4'b1110; seg <= 8'b11000000; end 
                                          1: begin an <= 4'b1110; seg <= 8'b11111001; end
                                          2: begin an <= 4'b1110; seg <= 8'b10100100; end
                                          3: begin an <= 4'b1110; seg <= 8'b10110000; end 
                                          4: begin an <= 4'b1110; seg <= 8'b10011001; end 
                                          5: begin an <= 4'b1110; seg <= 8'b10010010; end
                                          6: begin an <= 4'b1110; seg <= 8'b10000010; end
                                          7: begin an <= 4'b1110; seg <= 8'b11111000; end 
                                          8: begin an <= 4'b1110; seg <= 8'b10000000; end 
                                          9: begin an <= 4'b1110; seg <= 8'b10010000; end
                                             endcase   
 
                endcase
                end
                
                else if (game_over == 1)
                    begin
                        case(count) //OVER
                        0: begin an<= 4'b0111; seg <= 8'b1100_0000; end
                        1: begin an <= 4'b1011; seg <= 8'b1110_0011; end
                        2: begin an <= 4'b1101; seg <= 8'b1000_0110; end
                        3: begin an <= 4'b1110; seg <= 8'b1010_1111; end
                        endcase
                    end
             end
    parameter end_rowa = 57;
    parameter end_rowb = 58;
    parameter end_rowc = 59;
    parameter end_cola = 61;
    parameter end_colb = 62;
    parameter end_colc = 63;
//    assign clear = (transposed == 0 && (row >= end_rowa && row <= end_rowc) && (col >= end_cola && col <= end_colc)) || 
//                    (transposed == 1 && (row >= end_cola && row <= end_colc) && (col >= end_rowa && col <= end_rowc) );                    
    
    always @ (posedge clk1)
    begin
        if (activated == 1 && hard_reset == 0) 
            clear = (COUNTDOWN < 50) && ((transposed == 0 && (row >= end_rowa && row <= end_rowc) && (col >= end_cola && col <= end_colc)) || 
                       (transposed == 1 && (row >= end_cola && row <= end_colc) && (col >= end_rowa && col <= end_rowc))); 
        else clear = 0;
    end
    
    parameter star_rowa = 3;
    parameter star_rowb = 4;
    parameter star_rowc = 5;
    parameter star_cola = 0;
    parameter star_colb = 1;
    parameter star_colc = 2;
    
    reg [0:63]maze[0:63];
     //generate maze//
    initial begin
    maze[0]=64'b1111111111111111111111111111111111111111111111111111111111111111;
    maze[1]=64'b1111111111111111111111111111111111111111111111111111111111111111;
    maze[2]=64'b1111111111111111111111111111111111111111111111111111111111111111;
    maze[3]=64'b0000000000000000001110001110000000000000000000001110000000001111;
    maze[4]=64'b0000000000000000001110001110000000000000000000001110000000001111;
    maze[5]=64'b0000000000000000001110001110000000000000000000001110000000001111;
    maze[6]=64'b1110001110001110001110001110001111111111111110001110001110001111;
    maze[7]=64'b1110001110001110001110001110001111111111111110001110001110001111;
    maze[8]=64'b1110001110001110001110001110001111111111111110001110001110001111;
    maze[9]=64'b1110001110001110000000001110001110000000000000000000001110001111;
    maze[10]=64'b1110001110001110000000001110001110000000000000000000001110001111;
    maze[11]=64'b1110001110001110000000001110001110000000000000000000001110001111;
    maze[12]=64'b1111111110001111111111111110001110001111111111111111111110001111;
    maze[13]=64'b1111111110001111111111111110001110001111111111111111111110001111;
    maze[14]=64'b1111111110001111111111111110001110001111111111111111111110001111;
    maze[15]=64'b1110000000001110000000000000001110001110001110000000001110001111;
    maze[16]=64'b1110000000001110000000000000001110001110001110000000001110001111;
    maze[17]=64'b1110000000001110000000000000001110001110001110000000001110001111;
    maze[18]=64'b1110001111111110001111111111111111111110001110001111111110001111;
    maze[19]=64'b1110001111111110001111111111111111111110001110001111111110001111;
    maze[20]=64'b1110001111111110001111111111111111111110001110001111111110001111;
    maze[21]=64'b1110001110000000001110000000000000001110001110001110000000001111;
    maze[22]=64'b1110001110000000001110000000000000001110001110001110000000001111;
    maze[23]=64'b1110001110000000001110000000000000001110001110001110000000001111;
    maze[24]=64'b1110001110001111111110001111111110001110001110001110001111111111;
    maze[25]=64'b1110001110001111111110001111111110001110001110001110001111111111;
    maze[26]=64'b1110001110001111111110001111111110001110001110001110001111111111;
    maze[27]=64'b1110001110000000000000001110000000001110001110001110001110001111;
    maze[28]=64'b1110001110000000000000001110000000001110001110001110001110001111;
    maze[29]=64'b1110001110000000000000001110000000001110001110001110001110001111;
    maze[30]=64'b1110001111111111111111111110001111111110001110001110001110001111;
    maze[31]=64'b1110001111111111111111111110001111111110001110001110001110001111;
    maze[32]=64'b1110001111111111111111111110001111111110001110001110001110001111;
    maze[33]=64'b1110000000001110000000001110000000000000001110001110000000001111;
    maze[34]=64'b1110000000001110000000001110000000000000001110001110000000001111;
    maze[35]=64'b1110000000001110000000001110000000000000001110001110000000001111;
    maze[36]=64'b1110001110001110001110001111111111111111111110001111111110001111;
    maze[37]=64'b1110001110001110001110001111111111111111111110001111111110001111;
    maze[38]=64'b1110001110001110001110001111111111111111111110001111111110001111;
    maze[39]=64'b1110001110001110001110000000001110000000000000001110000000001111;
    maze[40]=64'b1110001110001110001110000000001110000000000000001110000000001111;
    maze[41]=64'b1110001110001110001110000000001110000000000000001110000000001111;
    maze[42]=64'b1110001111111110001110001110001110001111111110001110001111111111;
    maze[43]=64'b1110001111111110001110001110001110001111111110001110001111111111;
    maze[44]=64'b1110001111111110001110001110001110001111111110001110001111111111;
    maze[45]=64'b1110000000000000001110001110001110001110001110001110000000001111;
    maze[46]=64'b1110000000000000001110001110001110001110001110001110000000001111;
    maze[47]=64'b1110000000000000001110001110001110001110001110001110000000001111;
    maze[48]=64'b1110001111111111111110001110001110001110001110001111111110001111;
    maze[49]=64'b1110001111111111111110001110001110001110001110001111111110001111;
    maze[50]=64'b1110001111111111111110001110001110001110001110001111111110001111;
    maze[51]=64'b1110001110001110000000001110001110000000001110000000001110001111;
    maze[52]=64'b1110001110001110000000001110001110000000001110000000001110001111;
    maze[53]=64'b1110001110001110000000001110001110000000001110000000001110001111;
    maze[54]=64'b1110001110001110001111111111111111111110001111111110001110001111;
    maze[55]=64'b1110001110001110001111111111111111111110001111111110001110001111;
    maze[56]=64'b1110001110001110001111111111111111111110001111111110001110001111;
    maze[57]=64'b1110000000001110000000000000000000000000000000001110000000000000;
    maze[58]=64'b1110000000001110000000000000000000000000000000001110000000000000;
    maze[59]=64'b1110000000001110000000000000000000000000000000001110000000000000;
    maze[60]=64'b1111111111111111111111111111111111111111111111111111111111111111;
    maze[61]=64'b1111111111111111111111111111111111111111111111111111111111111111;
    maze[62]=64'b1111111111111111111111111111111111111111111111111111111111111111;
    maze[63]=64'b1111111111111111111111111111111111111111111111111111111111111111;
    end
    
    parameter obstacle = 1;
    parameter checkpoint = 2;
    
    assign state = maze[row_query][col_query] && row_query <= 63 && col_query <= 63;

    reg [0:63]maze_trans[0:63];
    integer i, j;
    integer ri, rj;
    integer new_row, new_col;
    reg flag = 0;
    
   integer step = 0; 
   integer step1 = 0;
     
    wire clk20;
    clock_divider clock_20(.basys_clock(fclock), .m(2499999), .new_clock(clk20));
    //generate logic for movement
    always @(posedge clk20) //changed from clk_10hz
        begin 
            if (hard_reset == 1) begin
            if (transposed == 0) begin row = 4; col = 0;end
            else if (transposed == 1) begin row = 0; col = 4; end
            end
            if (hacks_on == 0) begin
            //flag 
            if (flag == 0) begin
            if (BTNU_sig == 1)
                begin
                    if (((row - 1) >= 0) && ((row - 1) <= 63 )&& (maze[row - 1][col] == 0)) row <= row - 1;
                    else flag = 1; 
                end
            if (BTNL_sig == 1)
                begin
                    if (((col - 1) >= 0) && ((col - 1) <= 63) && (maze[row][col - 1] == 0)) col <= col - 1;
                    else flag = 1;
                end
            if (BTNC_sig == 1)
                begin
                    //reset timer
                end
            if (BTNR_sig == 1)
                begin
                    if (((col + 1) >= 0) && ((col + 1) <= 63) && (maze[row][col + 1] == 0)) col <= col + 1;
                    else flag = 1;
                end
            if (BTND_sig == 1)
                begin
                    if (((row + 1) >= 0) && ((row + 1) <= 63) && (maze[row + 1][col] == 0)) row <= row + 1;
                    else flag = 1;
                end
            end
            else if (flag == 1) begin
                //debug
                if (maze[row][col] == 1) begin if (transposed == 0) begin row = 4; col = 0; end if (transposed == 1) begin col = 4; row = 0; end flag = 0;end
                
            else begin
            for (i=0; i <= 63; i = i + 1) begin
               for (j=0 ; j <= 63; j = j + 1) begin
                   maze_trans[j][i] = maze[i][j];
                   end
                   end
             
                                               for (ri = 0; ri <= 63; ri = ri + 1) begin
                                                   for (rj = 0; rj <= 63; rj = rj + 1) begin
                                                           maze[ri][rj] = maze_trans[ri][rj];
                                                   end
                                                   end
                                              //stage 2: copy over player data
                                              new_row = col;
                                              new_col = row;
                                              col = new_col;
                                              row = new_col;
                                              transposed = ~transposed;
                                              flag = 0; end //set flag back to default 
                                              end
                end //hacks flag
                
                else if (hacks_on == 1 && clear == 0)
                    begin
                        if (transposed == 0) begin 
                          if (row >= 3 && row <= 5 && col >= 0 && col <= 17) begin 
                            if (col > 11) col <= col - 1;
                            if (col < 11) col <= col + 1;
                            if (col == 11) row <= row + 1;
                            end //first block col == 11, row = 6    - first block FIND DOWN
                            
                          if (row >= 6 && row <= 16 && col >= 10 && col <= 12) row <= row + 1;  //2nd block DOWN
                          if (row == 17 && col >= 3 && col <= 11)begin if (col < 4) col <= col + 1; if (col > 4) col <= col - 1; if (col == 4) row <= row + 1; end
                          if (row >= 18 && row <= 46 && col >= 3 && col <= 4) row <= row + 1;   //bring to row 47
                          if (row == 47 && col >= 3 && col <= 14)  if (col < 15) col <= col + 1;  //fix at col == 15
                          if (row >= 34 && row <= 47 && col >= 15 && col <= 17) begin if (row > 34) row <= row - 1; if (row == 34) col <= col + 1;  end//row 34, col 18
                          if (row >= 34 && row <= 35 && col >= 18 && col <= 23) begin if (col < 23) col <= col + 1; if (col == 23) row <= row + 1; end //ends at row 36
                          if (row >= 36 && row <= 52 && col >= 21 && col <= 23) begin if (row < 52) row <= row + 1; if (row == 52) col <= col - 1;end  //ends at row 52, col 21 - 23
                          if (row >= 51 && row <= 52 && col >= 15 && col <= 20) begin if (col > 15) col <= col - 1; if (col == 15) row <= row + 1; end
                          if (row >= 53 && row <= 58 && col >= 15 && col <= 17) begin if (row < 58) row <= row + 1; if (row == 58) col <= col + 1;  end //exit vert block at 57, 17
                          if (row >= 57 && row <= 59 && col >= 18 && col <= 38) begin if (col < 39) col <= col + 1; end //move right until col 38
                          if (row >= 52 && row <= 59 && col >= 39 && col <= 41) begin if (row > 51) row <= row - 1; if (row < 51) row <= row + 1; if (row == 51) col <= col - 1; end  //move up until row 51 then move left to exit
                          //new
                          if (row >= 51 && row <= 53 && col >= 39 && col <= 41) begin col <= col - 1; end
                          if (row >= 51 && row <= 53 && col >= 36 && col <= 38) begin col <= col - 1;end   //move left
                          if (row >= 39 && row <= 53 && col >= 33 && col <= 35) begin if (row > 39) row <= row - 1; if (row == 39) col <= col + 1; end  //move up then right to break
                          if (row >= 39 && row <= 41 && col >= 36 && col <= 47) begin if (col < 47) col <= col + 1; if (col == 47) row <= row + 1; end  //move right then down
                          if (row >= 42 && row <= 53 && col >= 45 && col <= 47) begin if (row < 53) row <= row + 1; if (row == 53) col <= col + 1; end
                          if (row >= 51 && row <= 53 && col >= 48 && col <= 53) begin if (col < 53) col <= col + 1; if (col == 53) row <= row + 1; end
                          if (row >= 54 && row <= 59 && col >= 51 && col <= 53) begin if (row < 59) row <= row + 1; if (row == 59) col <= col + 1; end
                          if (row >= 57 && row <= 59 && col >= 54 && col <= 63) begin if (col < 62) col <= col + 1; end     //reached the end!
                                
                        end
                        
                        if (transposed == 1) begin
                          if (col >= 3 && col <= 5 && row >= 0 && row <= 17) begin
                            if (row > 11) row <= row - 1;
                        if (row < 11) row <= row + 1;
                        if (row == 11) col <= col + 1;
                        end //first block row == 11, col = 6    - first block FIND DOWN
                        
                        if (col >= 6 && col <= 16 && row >= 10 && row <= 12) col <= col + 1;  //2nd block DOWN
                        if (col == 17 && row >= 3 && row <= 11)begin if (row < 4) row <= row + 1; if (row > 4) row <= row - 1; if (row == 4) col <= col + 1; end
                        if (col >= 18 && col <= 46 && row >= 3 && row <= 4) col <= col + 1;   //bring to col 47
                        if (col == 47 && row >= 3 && row <= 14)  if (row < 15) row <= row + 1;  //fix at row == 15
                        if (col >= 34 && col <= 47 && row >= 15 && row <= 17) begin if (col > 34) col <= col - 1; if (col == 34) row <= row + 1;  end//col 34, row 18
                        if (col >= 34 && col <= 35 && row >= 18 && row <= 23) begin if (row < 23) row <= row + 1; if (row == 23) col <= col + 1; end //ends at col 36
                        if (col >= 36 && col <= 52 && row >= 21 && row <= 23) begin if (col < 52) col <= col + 1; if (col == 52) row <= row - 1; end //ends at col 52, row 21 - 23
                        if (col >= 51 && col <= 52 && row >= 15 && row <= 20) begin if (row > 15) row <= row - 1; if (row == 15) col <= col + 1; end
                        if (col >= 53 && col <= 58 && row >= 15 && row <= 17) begin if (col < 58) col <= col + 1; if (col == 58) row <= row + 1;  end //exit vert block at 57, 17
                        if (col >= 57 && col <= 59 && row >= 18 && row <= 38) begin if (row < 39) row <= row + 1; end //move right until row 38
                        if (col >= 52 && col <= 59 && row >= 39 && row <= 41) begin if (col > 51) col <= col - 1; if (col < 51) col <= col + 1; if (col == 51) row <= row - 1; end  //move up until col 51 then move left to exit
                        //new
                        if (col >= 51 && col <= 53 && row >= 39 && row <= 41) begin row <= row - 1; end
                        if (col >= 51 && col <= 53 && row >= 36 && row <= 38) begin row <= row - 1; end  //move left
                        if (col >= 39 && col <= 53 && row >= 33 && row <= 35) begin if (col > 39) col <= col - 1; if (col == 39) row <= row + 1; end  //move up then right to break
                        if (col >= 39 && col <= 41 && row >= 36 && row <= 47) begin if (row < 47) row <= row + 1; if (row == 47) col <= col + 1; end  //move right then down
                        if (col >= 42 && col <= 53 && row >= 45 && row <= 47) begin if (col < 53) col <= col + 1; if (col == 53) row <= row + 1; end
                        if (col >= 51 && col <= 53 && row >= 48 && row <= 53) begin if (row < 53) row <= row + 1; if (row == 53) col <= col + 1; end
                        if (col >= 54 && col <= 59 && row >= 51 && row <= 53) begin if (col < 59) col <= col + 1; if (col == 59) row <= row + 1; end
                        if (col >= 57 && col <= 59 && row >= 54 && row <= 63) begin if (row < 62) row <= row + 1; end     //reached the end!
                        
                        end
                        //empty
                        end
            end
     
    
    endmodule
