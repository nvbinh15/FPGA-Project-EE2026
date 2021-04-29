`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2021 03:07:46 PM
// Design Name: 
// Module Name: nigel
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


module nigel(
    input [3:0] state,
    input  J_MIC3_Pin3,   // Connect from this signal to Audio_Capture.v
    output J_MIC3_Pin1,   // Connect to this signal from Audio_Capture.v
    output J_MIC3_Pin4,    // Connect to this signal from Audio_Capture.v
    input CLK100MHZ,
    input [15:0] sw,
    input BTNU, BTNC, BTNL, BTNR,
    output [7:0] JC,
    output reg [3:0] state_out = 1
    );
    
    // sw[15] -> go back to main menu (state = 0)
    always @ (posedge CLK100MHZ)
    begin
        if (state == 1)
        begin
            if (sw[15] == 1) state_out <= 0;
        end else state_out <= 1;
    end
    
    wire clk20k,  clk10, clk6p25m;
    clock_divider clock_20k (.basys_clock(CLK100MHZ), .m(2499), .new_clock(clk20k));
    clock_divider clock_10 (.basys_clock(CLK100MHZ), .m(4999999), .new_clock(clk10));
    clock_divider clock_6p25m (.basys_clock(CLK100MHZ), .m(7), .new_clock(clk6p25m));

    
    
    wire [11:0] mic_in;
    
    Audio_Capture audio0 (.CLK(CLK100MHZ), .cs(clk20k), .MISO(J_MIC3_Pin3), 
                          .clk_samp(J_MIC3_Pin1), .sclk(J_MIC3_Pin4), .sample(mic_in));
    
    
    reg [11:0] peak = 0; // store the value of peak
    reg [13:0] samples = 0; // count the number of samples taken
    reg [11:0] current = 0; // store the value of current sample
    reg [5:0] encoded_peak = 0; // encode the value of peak [0 -> 15]
                          
    always @ (posedge clk20k)
    begin
    if (state == 1) begin
        if (samples < 14'd4000) // find peak every 0.2sec
        begin
            current = mic_in;
            if (current > peak) peak <= current;
                samples <= samples + 1;
        end else 
        begin 
            samples <= 0;
            peak <= 0;
        end
    end
    end    
    
    // encode the value of peaks [0 - 4095] -> [0 -> 16]
    always @ (posedge CLK100MHZ)
    begin
    if (state == 1) begin
        if (peak < 2048) encoded_peak <= 0;
        else encoded_peak <= (peak - 2048) / 128 + 1;
    end
    end    
    

    wire blinky_tick;
    single_pulse blink(.clock(clk10),.BTNC(BTNC),.OUT(blinky_tick));
    reg [15:0] oled_data = 0;
    wire frame_begin, sending_pixels, sample_pixel, teststate;
    wire [12:0] pixel_index;
    Oled_Display oled(
        .clk(clk6p25m), .reset(blinky_tick), .frame_begin(frame_begin), .sending_pixels(sending_pixels),
        .sample_pixel(sample_pixel), .pixel_index(pixel_index), .pixel_data(oled_data), .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]),
        .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]),
        .pmoden(JC[7]),.teststate(teststate)
    );
    
    
    
    //starting block of row//
    parameter row_start = 8;
    parameter thicc = 1;    //thickness of individual blocks
    parameter gap = thicc + 2;  //include spacing between blocks
    //COLOURS//
    parameter border_colour = 16'b00000_000000_11111;
    
    parameter vol_high = 16'b11111_000000_00000;
    parameter vol_mid = 16'b11111_111111_00000;
    parameter vol_low = 16'b00000_111111_00000;
    
    wire [15:0] background_colour = {sw[14:11], 1'b0, sw[10:7], 2'b0, sw[6:3], 1'b0};
    
    //if border --> look at switch 0//
    wire border, thicker_border, volume;
    assign border = sw[0]; 
    assign thicker_border = sw[1];
    assign volume = sw[2];
    
    //row, column module//
    wire[12:0] row, col;
    reg [6:0] col_left_limit;
    reg [6:0] col_right_limit;
    initial begin
        col_left_limit = 47;
        col_right_limit = 50;
    end
    
    //to convert mic_in to volume (up to 15 bits)
    //wire [15:0] volume_bar;
    reg [15:0] volume_bar;
    
    always @ (*)
    begin
    if (state == 1) begin
        case (encoded_peak)
            0: volume_bar <= 0;
            1: volume_bar <= 16'b0000_0000_0000_0001;
            2: volume_bar <= 16'b0000_0000_0000_0011;
            3: volume_bar <= 16'b0000_0000_0000_0111;
            4: volume_bar <= 16'b0000_0000_0000_1111;
            5: volume_bar <= 16'b0000_0000_0001_1111;
            6: volume_bar <= 16'b0000_0000_0011_1111;
            7: volume_bar <= 16'b0000_0000_0111_1111;
            8: volume_bar <= 16'b0000_0000_1111_1111;
            9: volume_bar <= 16'b0000_0001_1111_1111;
            10: volume_bar <= 16'b0000_0011_1111_1111;
            11: volume_bar <= 16'b0000_0111_1111_1111;
            12: volume_bar <= 16'b0000_1111_1111_1111;
            13: volume_bar <= 16'b0001_1111_1111_1111;
            14: volume_bar <= 16'b0011_1111_1111_1111;
            15: volume_bar <= 16'b0111_1111_1111_1111;
            16: volume_bar <= 16'b1111_1111_1111_1111;
        endcase
    end  
    end
    
    
    //buttons to move the columns --> remember to keep within limits!
    wire move_l, move_r;
    wire reset_count;
    single_pulse move_left(.clock(clk10),.BTNC(BTNL), .OUT(move_l));
    single_pulse move_right(.clock(clk10), .BTNC(BTNR), .OUT(move_r));
    single_pulse reset(.clock(clk10), .BTNC(BTNU), .OUT(reset_count));
    
    //finding row, col of a pixel
    find_row_col solve(.pixel_index(pixel_index), .row(row), .col(col));
    
    //animating the frame
    always @ (posedge clk10) 
    begin   
    if (state == 1) begin
         if (move_l == 1 && (col_left_limit - 1 >= 0) && (col_left_limit - 1 <= 92) && (col_right_limit - 1 >= 4) && (col_right_limit - 1 <= 95)) begin col_left_limit = (col_left_limit - 1); col_right_limit = (col_right_limit - 1);  end
         if (move_r == 1 && (col_left_limit + 1 >= 0) && (col_left_limit + 1 <= 92) && (col_right_limit + 1 >= 4) && (col_right_limit + 1 <= 95)) begin col_left_limit = (col_left_limit + 1); col_right_limit = (col_right_limit + 1);  end
         if (reset_count == 1) begin col_left_limit <= 47; col_right_limit <= 50; end          
         end
    end
    
         
    always @ (posedge CLK100MHZ)
    begin
    if (state == 1) begin

            if (border == 1 && ( row == 0 || col == 0 || (col == 95 ) || row == 63))
                oled_data <= border_colour;
                
            else if (thicker_border == 1 && (row <= 2 || row >= 61 || col <= 2 || col >= 93))
                oled_data <= border_colour;
            //volume bar - TOP
            else if ((volume == 1) && (              (col_left_limit <= col) && (col <= col_right_limit) && 
                                                      ((row_start <= row) && (row <= row_start + (0 * gap) + thicc) && (volume_bar[15] == 1) ||
                                                       (row_start + (gap) <= row) && (row <= (row_start + (1 * gap) + thicc) ) && (volume_bar[14] == 1) ||
                                                       (row_start + (2 * gap) <= row) && (row <= (row_start + (2 * gap) + thicc)) && (volume_bar[13] == 1) ||
                                                     (row_start + (3 * gap) <= row) && (row <= (row_start + (3 * gap) + thicc)) && (volume_bar[12] == 1) ||
                                                     (row_start + (4 * gap) <= row) && (row <= (row_start + (4 * gap) + thicc)) && (volume_bar[11] == 1) )))
                oled_data <= vol_high;
            else if ((volume == 1) && (            (col_left_limit <= col) && (col <= col_right_limit) && 
                                                   ((row_start + (5 * gap) <= row) && (row <= (row_start + (5 * gap) + thicc)) && (volume_bar[10] == 1) ||
                                                    (row_start + (6 * gap) <= row) && (row <= (row_start + (6 * gap) + thicc)) && (volume_bar[9] == 1) ||
                                                    (row_start + (7 * gap) <= row) && (row <= (row_start + (7 * gap) + thicc)) && (volume_bar[8] == 1) ||
                                                    (row_start + (8 * gap) <= row) && (row <= (row_start + (8 * gap) + thicc)) && (volume_bar[7] == 1) ||
                                                    (row_start + (9 * gap) <= row) && (row <= (row_start + (9 * gap) + thicc)) && (volume_bar[6] == 1) )))
                oled_data <= vol_mid;
                
            else if ((volume == 1)&& (             (col_left_limit <= col) && (col <= col_right_limit) &&
                                                   ((row_start + (10 * gap) <= row) && (row <= (row_start + (10 * gap) + thicc)) && (volume_bar[5] == 1) ||
                                                   (row_start + (11 * gap) <= row) && (row <= (row_start + (11 * gap) + thicc)) && (volume_bar[4] == 1) ||
                                                    (row_start + (12 * gap) <= row) && (row <= (row_start + (12 * gap) + thicc)) && (volume_bar[3] == 1) ||
                                                    (row_start + (13 * gap) <= row) && (row <= (row_start + (13 * gap) + thicc)) && (volume_bar[2] == 1) ||
                                                    (row_start + (14 * gap) <= row) && (row <= (row_start + (14 * gap) + thicc)) && (volume_bar[1] == 1) ||
                                                    (row_start + (15 * gap) <= row) && (row <= (row_start + (15 * gap) + thicc)) && (volume_bar[0] == 1) )))
                oled_data <= vol_low;
                else oled_data <= background_colour;
        end
                
    end

        
          
        
 
    
endmodule
