`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2021 08:45:34 PM
// Design Name: 
// Module Name: audio_binh
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


module audio_binh(
    input [3:0] state,
    input  J_MIC3_Pin3,   // Connect from this signal to Audio_Capture.v
    output J_MIC3_Pin1,   // Connect to this signal from Audio_Capture.v
    output J_MIC3_Pin4,    // Connect to this signal from Audio_Capture.v
    input CLK100MHZ,
    input [15:0] sw,
    output reg [15:0] led = 0,
    output reg [7:0] seg = 8'b11111111,
    output reg [3:0] an = 4'b1111,
    output [7:0] JC,
    output reg [3:0] state_out = 2
    );
    
    always @ (posedge CLK100MHZ)
    begin
        if (state == 2)
        begin
            if (sw[15] == 1) state_out <= 0;
        end else state_out <= 2;
    end
    
    
    
    wire clk20k, clk100, clk10, clk6p25m, clk3, clk381, clk60, clk30;
    clock_divider clock_20k (.basys_clock(CLK100MHZ), .m(2499), .new_clock(clk20k));
    clock_divider clock_100 (.basys_clock(CLK100MHZ), .m(499999), .new_clock(clk100));
    clock_divider clock_10 (.basys_clock(CLK100MHZ), .m(4999999), .new_clock(clk10));
    clock_divider clock_6p25m (.basys_clock(CLK100MHZ), .m(7), .new_clock(clk6p25m));
    clock_divider clock_3 (.basys_clock(CLK100MHZ), .m(16666666), .new_clock(clk3));
    clock_divider clock_381 (.basys_clock(CLK100MHZ), .m(131233), .new_clock(clk381));
    clock_divider clock_60 (.basys_clock(CLK100MHZ), .m(833332), .new_clock(clk60));
    clock_divider clock_30 (.basys_clock(CLK100MHZ), .m(1666665), .new_clock(clk30));

    
    reg [15:0] oled_data = 0;
    wire frame_begin, sending_pixels, sample_pixel, teststate;
    wire [12:0] pixel_index;
    Oled_Display oled(
        .clk(clk6p25m), .reset(0), .frame_begin(frame_begin), .sending_pixels(sending_pixels),
        .sample_pixel(sample_pixel), .pixel_index(pixel_index), .pixel_data(oled_data), .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]),
        .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]),
        .pmoden(JC[7]),.teststate(teststate)
    );
   
    
    wire [11:0] mic_in;
    Audio_Capture audio0 (.CLK(CLK100MHZ), .cs(clk20k), .MISO(J_MIC3_Pin3), 
                          .clk_samp(J_MIC3_Pin1), .sclk(J_MIC3_Pin4), .sample(mic_in));
    
    
    reg [5:0] encoded_audio = 0; // encode the value of peak [0 -> 15]
    
    wire [12:0] x, y; 
    find_row_col row_col (pixel_index, y, x);
    
    reg [11:0] peak = 0; // store the value of peak
    reg [13:0] samples = 0; // count the number of samples taken
    reg [11:0] current = 0; // store the value of current sample
    reg [5:0] encoded_peak = 0; // encode the value of peak [0 -> 15]
    
    always @ (posedge clk20k)
    begin
    if (state == 2)
    begin
        if (samples < 14'd4000) // find peak every 0.2sec
        //if (samples < 14'd12000) // find peak every 0.6sec
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
    
    always @ (posedge CLK100MHZ)
    begin
    if (state == 2)
    begin
        if (peak < 2048) encoded_peak <= 0;
        else encoded_peak <= (peak - 2048) / 128 + 1;
    end
    end
    
    
    // Encode mic_in data
    always @ (posedge clk20k)
    begin
    if (state == 2)
    begin
        if (mic_in < 2048) encoded_audio = 0;
        else encoded_audio = (mic_in - 2048) / 128 + 1;
    end
    end
    
    reg [4:0] wave [0:95];
    
    always @ (posedge clk30)
    begin
    if (state == 2)
    begin
        wave[0] <= encoded_audio * 3;
        wave[1] <= wave[0]; wave[2] <= wave[1]; wave[3] <= wave[2]; wave[4] <= wave[3]; wave[5] <= wave[4]; wave[6] <= wave[5]; wave[7] <= wave[6]; wave[8] <= wave[7]; wave[9] <= wave[8]; wave[10] <= wave[9]; wave[11] <= wave[10]; wave[12] <= wave[11]; wave[13] <= wave[12]; wave[14] <= wave[13]; wave[15] <= wave[14]; wave[16] <= wave[15]; wave[17] <= wave[16]; wave[18] <= wave[17]; wave[19] <= wave[18]; wave[20] <= wave[19]; wave[21] <= wave[20]; wave[22] <= wave[21]; wave[23] <= wave[22]; wave[24] <= wave[23]; wave[25] <= wave[24]; wave[26] <= wave[25]; wave[27] <= wave[26]; wave[28] <= wave[27]; wave[29] <= wave[28]; wave[30] <= wave[29]; wave[31] <= wave[30]; wave[32] <= wave[31]; wave[33] <= wave[32]; wave[34] <= wave[33]; wave[35] <= wave[34]; wave[36] <= wave[35]; wave[37] <= wave[36]; wave[38] <= wave[37]; wave[39] <= wave[38]; wave[40] <= wave[39]; wave[41] <= wave[40]; wave[42] <= wave[41]; wave[43] <= wave[42]; wave[44] <= wave[43]; wave[45] <= wave[44]; wave[46] <= wave[45]; wave[47] <= wave[46]; wave[48] <= wave[47]; wave[49] <= wave[48]; wave[50] <= wave[49]; wave[51] <= wave[50]; wave[52] <= wave[51]; wave[53] <= wave[52]; wave[54] <= wave[53]; wave[55] <= wave[54]; wave[56] <= wave[55]; wave[57] <= wave[56]; wave[58] <= wave[57]; wave[59] <= wave[58]; wave[60] <= wave[59]; wave[61] <= wave[60]; wave[62] <= wave[61]; wave[63] <= wave[62]; wave[64] <= wave[63]; wave[65] <= wave[64]; wave[66] <= wave[65]; wave[67] <= wave[66]; wave[68] <= wave[67]; wave[69] <= wave[68]; wave[70] <= wave[69]; wave[71] <= wave[70]; wave[72] <= wave[71]; wave[73] <= wave[72]; wave[74] <= wave[73]; wave[75] <= wave[74]; wave[76] <= wave[75]; wave[77] <= wave[76]; wave[78] <= wave[77]; wave[79] <= wave[78]; wave[80] <= wave[79]; wave[81] <= wave[80]; wave[82] <= wave[81]; wave[83] <= wave[82]; wave[84] <= wave[83]; wave[85] <= wave[84]; wave[86] <= wave[85]; wave[87] <= wave[86]; wave[88] <= wave[87]; wave[89] <= wave[88]; wave[90] <= wave[89]; wave[91] <= wave[90]; wave[92] <= wave[91]; wave[93] <= wave[92]; wave[94] <= wave[93]; wave[95] <= wave[94]; 
    end    
    end
    
    wire [3:0] color;
    random random_color (clk3, 0, color);
    reg [15:0] wave_color [0:15];
    
    initial
    begin
        wave_color[0] = 16'b00000_000000_11111;
        wave_color[1] = 16'b01111_000000_01111;
        wave_color[3] = 16'b00000_000111_11111;
        wave_color[4] = 16'b00000_001111_11111;
        wave_color[5] = 16'b00011_011111_11111;
        wave_color[6] = 16'b00000_111111_11111;
        wave_color[7] = 16'b00011_111111_11111;
        wave_color[8] = 16'b00111_000000_11111;
        wave_color[9] = 16'b11111_000000_00111;
        wave_color[10] = 16'b00000_111111_00011;
        wave_color[11] = 16'b01111_111111_00011;
        wave_color[12] = 16'b00000_111111_00000;
        wave_color[13] = 16'b00000_100111_01000;
        wave_color[14] = 16'b10111_111111_00000;
        wave_color[15] = 16'b11111_001111_00011;
    end
    
    
        
    reg [15:0] peak_color = 16'b00000_000000_11111;
    
    reg [4:0] visual_peak [0:95];
    
    always @ (posedge clk30)
    begin
    if (state == 2)
    begin
        visual_peak[0] <= encoded_peak;
        visual_peak[1] <= visual_peak[0]; visual_peak[2] <= visual_peak[1]; visual_peak[3] <= visual_peak[2]; visual_peak[4] <= visual_peak[3]; visual_peak[5] <= visual_peak[4]; visual_peak[6] <= visual_peak[5]; visual_peak[7] <= visual_peak[6]; visual_peak[8] <= visual_peak[7]; visual_peak[9] <= visual_peak[8]; visual_peak[10] <= visual_peak[9]; visual_peak[11] <= visual_peak[10]; visual_peak[12] <= visual_peak[11]; visual_peak[13] <= visual_peak[12]; visual_peak[14] <= visual_peak[13]; visual_peak[15] <= visual_peak[14]; visual_peak[16] <= visual_peak[15]; visual_peak[17] <= visual_peak[16]; visual_peak[18] <= visual_peak[17]; visual_peak[19] <= visual_peak[18]; visual_peak[20] <= visual_peak[19]; visual_peak[21] <= visual_peak[20]; visual_peak[22] <= visual_peak[21]; visual_peak[23] <= visual_peak[22]; visual_peak[24] <= visual_peak[23]; visual_peak[25] <= visual_peak[24]; visual_peak[26] <= visual_peak[25]; visual_peak[27] <= visual_peak[26]; visual_peak[28] <= visual_peak[27]; visual_peak[29] <= visual_peak[28]; visual_peak[30] <= visual_peak[29]; visual_peak[31] <= visual_peak[30]; visual_peak[32] <= visual_peak[31]; visual_peak[63] <= visual_peak[32]; visual_peak[64] <= visual_peak[63]; visual_peak[65] <= visual_peak[64]; visual_peak[66] <= visual_peak[65]; visual_peak[67] <= visual_peak[66]; visual_peak[68] <= visual_peak[67]; visual_peak[69] <= visual_peak[68]; visual_peak[70] <= visual_peak[69]; visual_peak[71] <= visual_peak[70]; visual_peak[72] <= visual_peak[71]; visual_peak[73] <= visual_peak[72]; visual_peak[74] <= visual_peak[73]; visual_peak[75] <= visual_peak[74]; visual_peak[76] <= visual_peak[75]; visual_peak[77] <= visual_peak[76]; visual_peak[78] <= visual_peak[77]; visual_peak[79] <= visual_peak[78]; visual_peak[80] <= visual_peak[79]; visual_peak[81] <= visual_peak[80]; visual_peak[82] <= visual_peak[81]; visual_peak[83] <= visual_peak[82]; visual_peak[84] <= visual_peak[83]; visual_peak[85] <= visual_peak[84]; visual_peak[86] <= visual_peak[85]; visual_peak[87] <= visual_peak[86]; visual_peak[88] <= visual_peak[87]; visual_peak[89] <= visual_peak[88]; visual_peak[90] <= visual_peak[89]; visual_peak[91] <= visual_peak[90]; visual_peak[92] <= visual_peak[91]; visual_peak[93] <= visual_peak[92]; visual_peak[94] <= visual_peak[93]; visual_peak[95] <= visual_peak[94];
    end
    end
    
    
    reg [2:0] count = 0;
    always @ (posedge clk381)
    begin
    if (state == 2)
    begin
        if (count != 3'd3) count <= count + 1;
        else count <= 0;
    end
    end
    
    
    reg [5:0] encoded_audio_slow = 0;
    always @ (posedge clk10)
    begin
    if (state == 2)
        encoded_audio_slow <= encoded_audio;
    end
    
    always @ (posedge CLK100MHZ)
    begin
    if (state == 2)
    begin
        // control led and seg display
        if (sw[0] == 1) // led change wrt encoded_audio
        begin
            case (encoded_audio_slow)
                5'd0:
            begin
                led <= 16'b0000_0000_0000_0000;
                case (count)
                    3'd0: begin an <= 4'b0111; seg <= 8'b11000111; end // L
                    3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                    3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                    3'd3: begin an <= 4'b1110; seg <= 8'b11000000; end // 0
                endcase
            end
            
            5'd1:
            begin
                led <= 16'b0000_0000_0000_0001;
                case (count)
                    3'd0: begin an <= 4'b0111; seg <= 8'b11000111; end // L
                    3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                    3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                    3'd3: begin an <= 4'b1110; seg <= 8'b11111001; end // 1       
                endcase
            end
            
            5'd2:
            begin
                led <= 16'b0000_0000_0000_0011;
                case (count)
                    3'd0: begin an <= 4'b0111; seg <= 8'b11000111; end // L
                    3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                    3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                    3'd3: begin an <= 4'b1110; seg <= 8'b10100100; end // 2    
                endcase
            end  
            
            5'd3:
            begin
                led <= 16'b0000_0000_0000_0111;
                case (count)
                    3'd0: begin an <= 4'b0111; seg <= 8'b11000111; end // L
                    3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                    3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                    3'd3: begin an <= 4'b1110; seg <= 8'b10110000; end // 3       
                endcase 
            end
            
            5'd4:
            begin
                led <= 16'b0000_0000_0000_1111;
                case (count)
                    3'd0: begin an <= 4'b0111; seg <= 8'b11000111; end // L
                    3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                    3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                    3'd3: begin an <= 4'b1110; seg <= 8'b10011001; end // 4       
                endcase 
            end
            
            5'd5:
            begin
                led <= 16'b0000_0000_0001_1111;
                case (count)
                    3'd0: begin an <= 4'b0111; seg <= 8'b11000111; end // L
                    3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                    3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                    3'd3: begin an <= 4'b1110; seg <= 8'b10010010; end // 5       
                endcase 
            end
            
            5'd6:
            begin
                led <= 16'b0000_0000_0011_1111;
                case (count)
                    3'd0: begin an <= 4'b0111; seg <= 8'b11101010; end // M
                    3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                    3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                    3'd3: begin an <= 4'b1110; seg <= 8'b10000010; end // 6      
                endcase 
            end
            
            5'd7:
            begin
                led <= 16'b0000_0000_0111_1111;
                case (count)
                    3'd0: begin an <= 4'b0111; seg <= 8'b11101010; end // M
                    3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                    3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                    3'd3: begin an <= 4'b1110; seg <= 8'b11111000; end // 7       
                endcase 
            end
            
            5'd8:
            begin
                led <= 16'b0000_0000_1111_1111;
                case (count)
                    3'd0: begin an <= 4'b0111; seg <= 8'b11101010; end // M
                    3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                    3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                    3'd3: begin an <= 4'b1110; seg <= 8'b10000000; end // 8       
                endcase 
            end                                                
        
            5'd9:
            begin
                led <= 16'b0000_0001_1111_1111;
                case (count)
                    3'd0: begin an <= 4'b0111; seg <= 8'b11101010; end // M
                    3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                    3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                    3'd3: begin an <= 4'b1110; seg <= 8'b10010000; end // 9       
                endcase 
            end 
           
            5'd10:
            begin
                led <= 16'b0000_0011_1111_1111;
                case (count)
                    3'd0: begin an <= 4'b0111; seg <= 8'b11101010; end // M
                    3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                    3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                    3'd3: begin an <= 4'b1110; seg <= 8'b11000000; end // 0       
                endcase 
            end 
    
            5'd11:
            begin
                led <= 16'b0000_0111_1111_1111;
                case (count)
                    3'd0: begin an <= 4'b0111; seg <= 8'b11101010; end // M
                    3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                    3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                    3'd3: begin an <= 4'b1110; seg <= 8'b11111001; end // 1       
                endcase 
            end                                             
        
            5'd12:
            begin
                led <= 16'b0000_1111_1111_1111;
                case (count)
                    3'd0: begin an <= 4'b0111; seg <= 8'b10001001; end // H
                    3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                    3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                    3'd3: begin an <= 4'b1110; seg <= 8'b10100100; end // 2       
                endcase 
            end    
            
            5'd13:
            begin
                led <= 16'b0001_1111_1111_1111;
                case (count)
                    3'd0: begin an <= 4'b0111; seg <= 8'b10001001; end // H
                    3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                    3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                    3'd3: begin an <= 4'b1110; seg <= 8'b10110000; end // 3       
                endcase 
            end    
            
            5'd14:
            begin
                led <= 16'b0011_1111_1111_1111;
                case (count)
                    3'd0: begin an <= 4'b0111; seg <= 8'b10001001; end // H
                    3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                    3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                    3'd3: begin an <= 4'b1110; seg <= 8'b10011001; end // 4       
                endcase 
            end    
            
            5'd15:
            begin
                led <= 16'b0111_1111_1111_1111;
                case (count)
                    3'd0: begin an <= 4'b0111; seg <= 8'b10001001; end // H
                    3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                    3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                    3'd3: begin an <= 4'b1110; seg <= 8'b10010010; end // 5       
                endcase 
            end    
           
            5'd16:
            begin
                led <= 16'b1111_1111_1111_1111;
                case (count)
                    3'd0: begin an <= 4'b0111; seg <= 8'b10001001; end // H
                    3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                    3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                    3'd3: begin an <= 4'b1110; seg <= 8'b10000010; end // 6       
                endcase 
            end
            
            endcase        
        end else // led change wrt peak
        begin
            case (encoded_peak)
                5'd0:
                begin
                    led <= 16'b0000_0000_0000_0000;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b11000111; end // L
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                        3'd3: begin an <= 4'b1110; seg <= 8'b11000000; end // 0
                    endcase
                end
                
                5'd1:
                begin
                    led <= 16'b0000_0000_0000_0001;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b11000111; end // L
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                        3'd3: begin an <= 4'b1110; seg <= 8'b11111001; end // 1       
                    endcase
                end
                
                5'd2:
                begin
                    led <= 16'b0000_0000_0000_0011;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b11000111; end // L
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                        3'd3: begin an <= 4'b1110; seg <= 8'b10100100; end // 2    
                    endcase
                end  
                
                5'd3:
                begin
                    led <= 16'b0000_0000_0000_0111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b11000111; end // L
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                        3'd3: begin an <= 4'b1110; seg <= 8'b10110000; end // 3       
                    endcase 
                end
                
                5'd4:
                begin
                    led <= 16'b0000_0000_0000_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b11000111; end // L
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                        3'd3: begin an <= 4'b1110; seg <= 8'b10011001; end // 4       
                    endcase 
                end
                
                5'd5:
                begin
                    led <= 16'b0000_0000_0001_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b11000111; end // L
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                        3'd3: begin an <= 4'b1110; seg <= 8'b10010010; end // 5       
                    endcase 
                end
                
                5'd6:
                begin
                    led <= 16'b0000_0000_0011_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b11101010; end // M
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                        3'd3: begin an <= 4'b1110; seg <= 8'b10000010; end // 6      
                    endcase 
                end
                
                5'd7:
                begin
                    led <= 16'b0000_0000_0111_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b11101010; end // M
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                        3'd3: begin an <= 4'b1110; seg <= 8'b11111000; end // 7       
                    endcase 
                end
                
                5'd8:
                begin
                    led <= 16'b0000_0000_1111_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b11101010; end // M
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                        3'd3: begin an <= 4'b1110; seg <= 8'b10000000; end // 8       
                    endcase 
                end                                                
            
                5'd9:
                begin
                    led <= 16'b0000_0001_1111_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b11101010; end // M
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                        3'd3: begin an <= 4'b1110; seg <= 8'b10010000; end // 9       
                    endcase 
                end 
               
                5'd10:
                begin
                    led <= 16'b0000_0011_1111_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b11101010; end // M
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                        3'd3: begin an <= 4'b1110; seg <= 8'b11000000; end // 0       
                    endcase 
                end 
    
                5'd11:
                begin
                    led <= 16'b0000_0111_1111_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b11101010; end // M
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                        3'd3: begin an <= 4'b1110; seg <= 8'b11111001; end // 1       
                    endcase 
                end                                             
            
                5'd12:
                begin
                    led <= 16'b0000_1111_1111_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b10001001; end // H
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                        3'd3: begin an <= 4'b1110; seg <= 8'b10100100; end // 2       
                    endcase 
                end    
                
                5'd13:
                begin
                    led <= 16'b0001_1111_1111_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b10001001; end // H
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                        3'd3: begin an <= 4'b1110; seg <= 8'b10110000; end // 3       
                    endcase 
                end    
                
                5'd14:
                begin
                    led <= 16'b0011_1111_1111_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b10001001; end // H
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                        3'd3: begin an <= 4'b1110; seg <= 8'b10011001; end // 4       
                    endcase 
                end    
                
                5'd15:
                begin
                    led <= 16'b0111_1111_1111_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b10001001; end // H
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                        3'd3: begin an <= 4'b1110; seg <= 8'b10010010; end // 5       
                    endcase 
                end    
               
                5'd16:
                begin
                    led <= 16'b1111_1111_1111_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b10001001; end // H
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                        3'd3: begin an <= 4'b1110; seg <= 8'b10000010; end // 6       
                    endcase 
                end                
    
            endcase  
        end
       
    
        // control oled
        if (sw[2] == 0)
        begin
            if (sw[1] == 1)
            begin
                if (((y > 65 - wave[0]) && (x == 0)) || ((y > 65 - wave[1]) && (x == 1)) || ((y > 65 - wave[2]) && (x == 2)) || ((y > 65 - wave[3]) && (x == 3)) || ((y > 65 - wave[4]) && (x == 4)) || ((y > 65 - wave[5]) && (x == 5)) || ((y > 65 - wave[6]) && (x == 6)) || ((y > 65 - wave[7]) && (x == 7)) || ((y > 65 - wave[8]) && (x == 8)) || ((y > 65 - wave[9]) && (x == 9)) || ((y > 65 - wave[10]) && (x == 10)) || ((y > 65 - wave[11]) && (x == 11)) || ((y > 65 - wave[12]) && (x == 12)) || ((y > 65 - wave[13]) && (x == 13)) || ((y > 65 - wave[14]) && (x == 14)) || ((y > 65 - wave[15]) && (x == 15)) || ((y > 65 - wave[16]) && (x == 16)) || ((y > 65 - wave[17]) && (x == 17)) || ((y > 65 - wave[18]) && (x == 18)) || ((y > 65 - wave[19]) && (x == 19)) || ((y > 65 - wave[20]) && (x == 20)) || ((y > 65 - wave[21]) && (x == 21)) || ((y > 65 - wave[22]) && (x == 22)) || ((y > 65 - wave[23]) && (x == 23)) || ((y > 65 - wave[24]) && (x == 24)) || ((y > 65 - wave[25]) && (x == 25)) || ((y > 65 - wave[26]) && (x == 26)) || ((y > 65 - wave[27]) && (x == 27)) || ((y > 65 - wave[28]) && (x == 28)) || ((y > 65 - wave[29]) && (x == 29)) || ((y > 65 - wave[30]) && (x == 30)) || ((y > 65 - wave[31]) && (x == 31)) || ((y > 65 - wave[32]) && (x == 32)) || ((y > 65 - wave[33]) && (x == 33)) || ((y > 65 - wave[34]) && (x == 34)) || ((y > 65 - wave[35]) && (x == 35)) || ((y > 65 - wave[36]) && (x == 36)) || ((y > 65 - wave[37]) && (x == 37)) || ((y > 65 - wave[38]) && (x == 38)) || ((y > 65 - wave[39]) && (x == 39)) || ((y > 65 - wave[40]) && (x == 40)) || ((y > 65 - wave[41]) && (x == 41)) || ((y > 65 - wave[42]) && (x == 42)) || ((y > 65 - wave[43]) && (x == 43)) || ((y > 65 - wave[44]) && (x == 44)) || ((y > 65 - wave[45]) && (x == 45)) || ((y > 65 - wave[46]) && (x == 46)) || ((y > 65 - wave[47]) && (x == 47)) || ((y > 65 - wave[48]) && (x == 48)) || ((y > 65 - wave[49]) && (x == 49)) || ((y > 65 - wave[50]) && (x == 50)) || ((y > 65 - wave[51]) && (x == 51)) || ((y > 65 - wave[52]) && (x == 52)) || ((y > 65 - wave[53]) && (x == 53)) || ((y > 65 - wave[54]) && (x == 54)) || ((y > 65 - wave[55]) && (x == 55)) || ((y > 65 - wave[56]) && (x == 56)) || ((y > 65 - wave[57]) && (x == 57)) || ((y > 65 - wave[58]) && (x == 58)) || ((y > 65 - wave[59]) && (x == 59)) || ((y > 65 - wave[60]) && (x == 60)) || ((y > 65 - wave[61]) && (x == 61)) || ((y > 65 - wave[62]) && (x == 62)) || ((y > 65 - wave[63]) && (x == 63)) || ((y > 65 - wave[64]) && (x == 64)) || ((y > 65 - wave[65]) && (x == 65)) || ((y > 65 - wave[66]) && (x == 66)) || ((y > 65 - wave[67]) && (x == 67)) || ((y > 65 - wave[68]) && (x == 68)) || ((y > 65 - wave[69]) && (x == 69)) || ((y > 65 - wave[70]) && (x == 70)) || ((y > 65 - wave[71]) && (x == 71)) || ((y > 65 - wave[72]) && (x == 72)) || ((y > 65 - wave[73]) && (x == 73)) || ((y > 65 - wave[74]) && (x == 74)) || ((y > 65 - wave[75]) && (x == 75)) || ((y > 65 - wave[76]) && (x == 76)) || ((y > 65 - wave[77]) && (x == 77)) || ((y > 65 - wave[78]) && (x == 78)) || ((y > 65 - wave[79]) && (x == 79)) || ((y > 65 - wave[80]) && (x == 80)) || ((y > 65 - wave[81]) && (x == 81)) || ((y > 65 - wave[82]) && (x == 82)) || ((y > 65 - wave[83]) && (x == 83)) || ((y > 65 - wave[84]) && (x == 84)) || ((y > 65 - wave[85]) && (x == 85)) || ((y > 65 - wave[86]) && (x == 86)) || ((y > 65 - wave[87]) && (x == 87)) || ((y > 65 - wave[88]) && (x == 88)) || ((y > 65 - wave[89]) && (x == 89)) || ((y > 65 - wave[90]) && (x == 90)) || ((y > 65 - wave[91]) && (x == 91)) || ((y > 65 - wave[92]) && (x == 92)) || ((y > 65 - wave[93]) && (x == 93)) || ((y > 65 - wave[94]) && (x == 94)) || ((y > 65 - wave[95]) && (x == 95)) )
                    oled_data <= wave_color[color];
            end else begin // (sw[0] == 0)
                if (((x - 48) * (x - 48) + (y - 38) * (y - 38)) < (encoded_audio + 10) * (encoded_audio + 10))
                        oled_data <= wave_color[color];
            end
                        
            if (pixel_index == 101 || pixel_index == 106 || pixel_index == 195 || pixel_index == 204 || pixel_index == 290 || pixel_index == 301 || pixel_index == 481 || pixel_index == 494 || pixel_index == 961 || pixel_index == 974 || pixel_index == 1154 || pixel_index == 1251 || pixel_index == 1349 || pixel_index == 1354) oled_data = 16'b0101001010000000;
                    else if (pixel_index == 102 || pixel_index == 105 || pixel_index == 577 || pixel_index == 590 || pixel_index == 865 || pixel_index == 878 || pixel_index == 1350 || pixel_index == 1353) oled_data = 16'b1010010100000000;
                    else if (((pixel_index >= 103) && (pixel_index <= 104)) || ((pixel_index >= 197) && (pixel_index <= 202)) || ((pixel_index >= 291) && (pixel_index <= 300)) || ((pixel_index >= 387) && (pixel_index <= 390)) || pixel_index == 393 || pixel_index == 396 || ((pixel_index >= 482) && (pixel_index <= 484)) || ((pixel_index >= 492) && (pixel_index <= 493)) || pixel_index == 578 || pixel_index == 589 || ((pixel_index >= 673) && (pixel_index <= 674)) || ((pixel_index >= 685) && (pixel_index <= 686)) || ((pixel_index >= 769) && (pixel_index <= 770)) || ((pixel_index >= 781) && (pixel_index <= 782)) || pixel_index == 866 || pixel_index == 877 || ((pixel_index >= 962) && (pixel_index <= 965)) || ((pixel_index >= 972) && (pixel_index <= 973)) || ((pixel_index >= 1059) && (pixel_index <= 1062)) || ((pixel_index >= 1064) && (pixel_index <= 1065)) || ((pixel_index >= 1067) && (pixel_index <= 1068)) || ((pixel_index >= 1155) && (pixel_index <= 1164)) || ((pixel_index >= 1253) && (pixel_index <= 1258)) || (pixel_index >= 1351) && (pixel_index <= 1352)) oled_data = 16'b1111010100001010;
                    else if (pixel_index == 196 || pixel_index == 203 || pixel_index == 386 || pixel_index == 392 || pixel_index == 395 || pixel_index == 397 || pixel_index == 485 || ((pixel_index >= 488) && (pixel_index <= 489)) || pixel_index == 579 || pixel_index == 584 || pixel_index == 588 || pixel_index == 675 || pixel_index == 680 || pixel_index == 684 || pixel_index == 771 || pixel_index == 776 || pixel_index == 780 || pixel_index == 867 || pixel_index == 876 || pixel_index == 968 || pixel_index == 970 || pixel_index == 1058 || pixel_index == 1063 || pixel_index == 1069 || pixel_index == 1252 || pixel_index == 1259) oled_data = 16'b1010010100001010;
                    else if (pixel_index == 391 || pixel_index == 394 || ((pixel_index >= 490) && (pixel_index <= 491)) || ((pixel_index >= 585) && (pixel_index <= 587)) || ((pixel_index >= 681) && (pixel_index <= 683)) || ((pixel_index >= 777) && (pixel_index <= 779)) || pixel_index == 868 || ((pixel_index >= 872) && (pixel_index <= 875)) || pixel_index == 966 || pixel_index == 969 || pixel_index == 971 || pixel_index == 1066) oled_data = 16'b1010001010001010;
                    else if (pixel_index == 486) oled_data = 16'b0101001010010100;
                    else if (pixel_index == 487 || ((pixel_index >= 580) && (pixel_index <= 583)) || ((pixel_index >= 676) && (pixel_index <= 679)) || ((pixel_index >= 772) && (pixel_index <= 775)) || ((pixel_index >= 869) && (pixel_index <= 871)) || pixel_index == 967) oled_data = 16'b0101000000010100;
                    else if (pixel_index == 1165 || pixel_index == 1260) oled_data = 16'b0000001010000000;
            else if ((x == 26 && y == 5) || (x == 27 && y == 5) || (x == 25 && y == 6) || (x == 28 && y == 6) || (x == 25 && y == 7) || (x == 26 && y == 7) || (x == 27 && y == 7) || (x == 28 && y == 7) || (x == 25 && y == 8) || (x == 28 && y == 8) || (x == 25 && y == 9) || (x == 28 && y == 9) || (x == 30 && y == 5) || (x == 33 && y == 5) || (x == 30 && y == 6) || (x == 33 && y == 6) || (x == 30 && y == 7) || (x == 33 && y == 7) || (x == 30 && y == 8) || (x == 33 && y == 8) || (x == 31 && y == 9) || (x == 32 && y == 9) || (x == 35 && y == 5) || (x == 36 && y == 5) || (x == 37 && y == 5) || (x == 35 && y == 6) || (x == 38 && y == 6) || (x == 35 && y == 7) || (x == 38 && y == 7) || (x == 35 && y == 8) || (x == 38 && y == 8) || (x == 35 && y == 9) || (x == 36 && y == 9) || (x == 37 && y == 9) || (x == 40 && y == 5) || (x == 40 && y == 6) || (x == 40 && y == 7) || (x == 40 && y == 8) || (x == 40 && y == 9) || (x == 43 && y == 5) || (x == 44 && y == 5) || (x == 42 && y == 6) || (x == 45 && y == 6) || (x == 42 && y == 7) || (x == 45 && y == 7) || (x == 42 && y == 8) || (x == 45 && y == 8) || (x == 43 && y == 9) || (x == 44 && y == 9) || (x == 51 && y == 5) || (x == 52 && y == 5) || (x == 50 && y == 6) || (x == 53 && y == 6) || (x == 50 && y == 7) || (x == 50 && y == 8) || (x == 53 && y == 8) || (x == 51 && y == 9) || (x == 52 && y == 9) || (x == 56 && y == 5) || (x == 57 && y == 5) || (x == 55 && y == 6) || (x == 58 && y == 6) || (x == 55 && y == 7) || (x == 56 && y == 7) || (x == 57 && y == 7) || (x == 58 && y == 7) || (x == 55 && y == 8) || (x == 58 && y == 8) || (x == 55 && y == 9) || (x == 58 && y == 9) || (x == 60 && y == 5) || (x == 61 && y == 5) || (x == 62 && y == 5) || (x == 60 && y == 6) || (x == 63 && y == 6) || (x == 60 && y == 7) || (x == 61 && y == 7) || (x == 62 && y == 7) || (x == 60 && y == 8) || (x == 60 && y == 9) || (x == 65 && y == 5) || (x == 66 && y == 5) || (x == 67 && y == 5) || (x == 66 && y == 6) || (x == 66 && y == 7) || (x == 66 && y == 8) || (x == 66 && y == 9) || (x == 69 && y == 5) || (x == 72 && y == 5) || (x == 69 && y == 6) || (x == 72 && y == 6) || (x == 69 && y == 7) || (x == 72 && y == 7) || (x == 69 && y == 8) || (x == 72 && y == 8) || (x == 70 && y == 9) || (x == 71 && y == 9) || (x == 74 && y == 5) || (x == 75 && y == 5) || (x == 76 && y == 5) || (x == 74 && y == 6) || (x == 77 && y == 6) || (x == 74 && y == 7) || (x == 75 && y == 7) || (x == 76 && y == 7) || (x == 74 && y == 8) || (x == 76 && y == 8) || (x == 74 && y == 9) || (x == 77 && y == 9) || (x == 79 && y == 5) || (x == 80 && y == 5) || (x == 81 && y == 5) || (x == 82 && y == 5) || (x == 79 && y == 6) || (x == 79 && y == 7) || (x == 80 && y == 7) || (x == 81 && y == 7) || (x == 82 && y == 7) || (x == 79 && y == 8) || (x == 79 && y == 9) || (x == 80 && y == 9) || (x == 81 && y == 9) || (x == 82 && y == 9))   
                        oled_data = 16'b11111_100000_00111; // "audio capture"
            else oled_data = 16'hFFFF;
            
        end else // sw[2] == 1 -> hulk mode
        begin
            if (((y < 31 + visual_peak[0]) && (y > 31 - visual_peak[0]) && (x == 0)) || ((y < 31 + visual_peak[1]) && (y > 31 - visual_peak[1]) && (x == 1)) || ((y < 31 + visual_peak[2]) && (y > 31 - visual_peak[2]) && (x == 2)) || ((y < 31 + visual_peak[3]) && (y > 31 - visual_peak[3]) && (x == 3)) || ((y < 31 + visual_peak[4]) && (y > 31 - visual_peak[4]) && (x == 4)) || ((y < 31 + visual_peak[5]) && (y > 31 - visual_peak[5]) && (x == 5)) || ((y < 31 + visual_peak[6]) && (y > 31 - visual_peak[6]) && (x == 6)) || ((y < 31 + visual_peak[7]) && (y > 31 - visual_peak[7]) && (x == 7)) || ((y < 31 + visual_peak[8]) && (y > 31 - visual_peak[8]) && (x == 8)) || ((y < 31 + visual_peak[9]) && (y > 31 - visual_peak[9]) && (x == 9)) || ((y < 31 + visual_peak[10]) && (y > 31 - visual_peak[10]) && (x == 10)) || ((y < 31 + visual_peak[11]) && (y > 31 - visual_peak[11]) && (x == 11)) || ((y < 31 + visual_peak[12]) && (y > 31 - visual_peak[12]) && (x == 12)) || ((y < 31 + visual_peak[13]) && (y > 31 - visual_peak[13]) && (x == 13)) || ((y < 31 + visual_peak[14]) && (y > 31 - visual_peak[14]) && (x == 14)) || ((y < 31 + visual_peak[15]) && (y > 31 - visual_peak[15]) && (x == 15)) || ((y < 31 + visual_peak[16]) && (y > 31 - visual_peak[16]) && (x == 16)) || ((y < 31 + visual_peak[17]) && (y > 31 - visual_peak[17]) && (x == 17)) || ((y < 31 + visual_peak[18]) && (y > 31 - visual_peak[18]) && (x == 18)) || ((y < 31 + visual_peak[19]) && (y > 31 - visual_peak[19]) && (x == 19)) || ((y < 31 + visual_peak[20]) && (y > 31 - visual_peak[20]) && (x == 20)) || ((y < 31 + visual_peak[21]) && (y > 31 - visual_peak[21]) && (x == 21)) || ((y < 31 + visual_peak[22]) && (y > 31 - visual_peak[22]) && (x == 22)) || ((y < 31 + visual_peak[23]) && (y > 31 - visual_peak[23]) && (x == 23)) || ((y < 31 + visual_peak[24]) && (y > 31 - visual_peak[24]) && (x == 24)) || ((y < 31 + visual_peak[25]) && (y > 31 - visual_peak[25]) && (x == 25)) || ((y < 31 + visual_peak[26]) && (y > 31 - visual_peak[26]) && (x == 26)) || ((y < 31 + visual_peak[27]) && (y > 31 - visual_peak[27]) && (x == 27)) || ((y < 31 + visual_peak[28]) && (y > 31 - visual_peak[28]) && (x == 28)) || ((y < 31 + visual_peak[29]) && (y > 31 - visual_peak[29]) && (x == 29)) || ((y < 31 + visual_peak[30]) && (y > 31 - visual_peak[30]) && (x == 30)) || ((y < 31 + visual_peak[31]) && (y > 31 - visual_peak[31]) && (x == 31)) || ((y < 31 + visual_peak[32]) && (y > 31 - visual_peak[32]) && (x == 32)) || ((y < 31 + visual_peak[63]) && (y > 31 - visual_peak[63]) && (x == 63)) || ((y < 31 + visual_peak[64]) && (y > 31 - visual_peak[64]) && (x == 64)) || ((y < 31 + visual_peak[65]) && (y > 31 - visual_peak[65]) && (x == 65)) || ((y < 31 + visual_peak[66]) && (y > 31 - visual_peak[66]) && (x == 66)) || ((y < 31 + visual_peak[67]) && (y > 31 - visual_peak[67]) && (x == 67)) || ((y < 31 + visual_peak[68]) && (y > 31 - visual_peak[68]) && (x == 68)) || ((y < 31 + visual_peak[69]) && (y > 31 - visual_peak[69]) && (x == 69)) || ((y < 31 + visual_peak[70]) && (y > 31 - visual_peak[70]) && (x == 70)) || ((y < 31 + visual_peak[71]) && (y > 31 - visual_peak[71]) && (x == 71)) || ((y < 31 + visual_peak[72]) && (y > 31 - visual_peak[72]) && (x == 72)) || ((y < 31 + visual_peak[73]) && (y > 31 - visual_peak[73]) && (x == 73)) || ((y < 31 + visual_peak[74]) && (y > 31 - visual_peak[74]) && (x == 74)) || ((y < 31 + visual_peak[75]) && (y > 31 - visual_peak[75]) && (x == 75)) || ((y < 31 + visual_peak[76]) && (y > 31 - visual_peak[76]) && (x == 76)) || ((y < 31 + visual_peak[77]) && (y > 31 - visual_peak[77]) && (x == 77)) || ((y < 31 + visual_peak[78]) && (y > 31 - visual_peak[78]) && (x == 78)) || ((y < 31 + visual_peak[79]) && (y > 31 - visual_peak[79]) && (x == 79)) || ((y < 31 + visual_peak[80]) && (y > 31 - visual_peak[80]) && (x == 80)) || ((y < 31 + visual_peak[81]) && (y > 31 - visual_peak[81]) && (x == 81)) || ((y < 31 + visual_peak[82]) && (y > 31 - visual_peak[82]) && (x == 82)) || ((y < 31 + visual_peak[83]) && (y > 31 - visual_peak[83]) && (x == 83)) || ((y < 31 + visual_peak[84]) && (y > 31 - visual_peak[84]) && (x == 84)) || ((y < 31 + visual_peak[85]) && (y > 31 - visual_peak[85]) && (x == 85)) || ((y < 31 + visual_peak[86]) && (y > 31 - visual_peak[86]) && (x == 86)) || ((y < 31 + visual_peak[87]) && (y > 31 - visual_peak[87]) && (x == 87)) || ((y < 31 + visual_peak[88]) && (y > 31 - visual_peak[88]) && (x == 88)) || ((y < 31 + visual_peak[89]) && (y > 31 - visual_peak[89]) && (x == 89)) || ((y < 31 + visual_peak[90]) && (y > 31 - visual_peak[90]) && (x == 90)) || ((y < 31 + visual_peak[91]) && (y > 31 - visual_peak[91]) && (x == 91)) || ((y < 31 + visual_peak[92]) && (y > 31 - visual_peak[92]) && (x == 92)) || ((y < 31 + visual_peak[93]) && (y > 31 - visual_peak[93]) && (x == 93)) || ((y < 31 + visual_peak[94]) && (y > 31 - visual_peak[94]) && (x == 94)) || ((y < 31 + visual_peak[95]) && (y > 31 - visual_peak[95]) && (x == 95)))
                oled_data <= peak_color;
        
            if (visual_peak[32] > 5 || visual_peak[63] > 5) // hulk
            begin
                if (pixel_index == 1387) oled_data = 16'b1010011110011110;
                else if (pixel_index == 1388 || ((pixel_index >= 1390) && (pixel_index <= 1392)) || ((pixel_index >= 1481) && (pixel_index <= 1482)) || pixel_index == 1484 || pixel_index == 1491 || pixel_index == 1574 || pixel_index == 1577 || pixel_index == 1588 || pixel_index == 1686 || pixel_index == 1689 || pixel_index == 1766 || pixel_index == 1787 || pixel_index == 1861 || pixel_index == 1882 || pixel_index == 1955 || ((pixel_index >= 1980) && (pixel_index <= 1981)) || pixel_index == 2268 || pixel_index == 2338 || pixel_index == 2434 || pixel_index == 2530 || pixel_index == 2556 || pixel_index == 2627 || pixel_index == 2818 || pixel_index == 2843 || pixel_index == 2914 || ((pixel_index >= 2939) && (pixel_index <= 2940)) || pixel_index == 3037 || ((pixel_index >= 3305) && (pixel_index <= 3306)) || ((pixel_index >= 3318) && (pixel_index <= 3319)) || pixel_index == 3491 || pixel_index == 3684 || pixel_index == 3708 || pixel_index == 3781 || pixel_index == 3803 || pixel_index == 3899 || ((pixel_index >= 3978) && (pixel_index <= 3982)) || pixel_index == 3984 || ((pixel_index >= 3986) && (pixel_index <= 3990)) || pixel_index == 3995 || ((pixel_index >= 4074) && (pixel_index <= 4086)) || ((pixel_index >= 4170) && (pixel_index <= 4182)) || pixel_index == 4262 || ((pixel_index >= 4267) && (pixel_index <= 4268)) || ((pixel_index >= 4276) && (pixel_index <= 4277)) || pixel_index == 4282 || pixel_index == 4455 || pixel_index == 4473 || pixel_index == 4648 || pixel_index == 4664) oled_data = 16'b1010010100010100;
                else if (pixel_index == 1389 || pixel_index == 1670 || pixel_index == 1687 || pixel_index == 2147 || pixel_index == 2243 || pixel_index == 2460 || pixel_index == 2652) oled_data = 16'b0101010100010100;
                else if (((pixel_index >= 1485) && (pixel_index <= 1489)) || ((pixel_index >= 1578) && (pixel_index <= 1580)) || ((pixel_index >= 1582) && (pixel_index <= 1586)) || pixel_index == 1671 || ((pixel_index >= 1675) && (pixel_index <= 1685)) || ((pixel_index >= 1767) && (pixel_index <= 1785)) || ((pixel_index >= 1863) && (pixel_index <= 1881)) || ((pixel_index >= 1957) && (pixel_index <= 1978)) || ((pixel_index >= 2052) && (pixel_index <= 2077)) || ((pixel_index >= 2148) && (pixel_index <= 2172)) || ((pixel_index >= 2244) && (pixel_index <= 2266)) || ((pixel_index >= 2339) && (pixel_index <= 2364)) || ((pixel_index >= 2436) && (pixel_index <= 2459)) || ((pixel_index >= 2532) && (pixel_index <= 2555)) || ((pixel_index >= 2628) && (pixel_index <= 2630)) || ((pixel_index >= 2635) && (pixel_index <= 2637)) || ((pixel_index >= 2639) && (pixel_index <= 2641)) || ((pixel_index >= 2643) && (pixel_index <= 2644)) || ((pixel_index >= 2647) && (pixel_index <= 2651)) || ((pixel_index >= 2724) && (pixel_index <= 2726)) || ((pixel_index >= 2734) && (pixel_index <= 2736)) || pixel_index == 2739 || ((pixel_index >= 2744) && (pixel_index <= 2748)) || ((pixel_index >= 2819) && (pixel_index <= 2821)) || ((pixel_index >= 2830) && (pixel_index <= 2831)) || pixel_index == 2842 || ((pixel_index >= 2915) && (pixel_index <= 2917)) || pixel_index == 3017 || pixel_index == 3031 || ((pixel_index >= 3112) && (pixel_index <= 3115)) || ((pixel_index >= 3125) && (pixel_index <= 3128)) || ((pixel_index >= 3211) && (pixel_index <= 3212)) || ((pixel_index >= 3220) && (pixel_index <= 3221)) || pixel_index == 3309 || pixel_index == 3315) oled_data = 16'b0000000000000000;
                else if (pixel_index == 1490 || pixel_index == 1589 || ((pixel_index >= 1672) && (pixel_index <= 1674)) || pixel_index == 1688 || pixel_index == 1786 || pixel_index == 1862 || pixel_index == 1956 || pixel_index == 1979 || pixel_index == 2051 || pixel_index == 2173 || pixel_index == 2365 || pixel_index == 2723 || pixel_index == 2844 || pixel_index == 2938) oled_data = 16'b0101001010001010;
                else if (pixel_index == 1581 || pixel_index == 1587 || pixel_index == 2267 || pixel_index == 2435 || pixel_index == 3210 || pixel_index == 3222) oled_data = 16'b0000001010001010;
                else if (pixel_index == 2631 || pixel_index == 2638 || pixel_index == 2646 || ((pixel_index >= 2727) && (pixel_index <= 2728)) || pixel_index == 2730 || pixel_index == 2732 || ((pixel_index >= 2737) && (pixel_index <= 2738)) || pixel_index == 2740 || ((pixel_index >= 2822) && (pixel_index <= 2824)) || pixel_index == 2829 || pixel_index == 2834 || pixel_index == 2840 || ((pixel_index >= 2918) && (pixel_index <= 2920)) || ((pixel_index >= 2925) && (pixel_index <= 2926)) || ((pixel_index >= 2936) && (pixel_index <= 2937)) || ((pixel_index >= 3012) && (pixel_index <= 3015)) || ((pixel_index >= 3033) && (pixel_index <= 3036)) || pixel_index == 3107 || pixel_index == 3110 || pixel_index == 3116 || pixel_index == 3124 || pixel_index == 3130 || ((pixel_index >= 3132) && (pixel_index <= 3133)) || pixel_index == 3203 || ((pixel_index >= 3206) && (pixel_index <= 3209)) || pixel_index == 3213 || pixel_index == 3219 || ((pixel_index >= 3223) && (pixel_index <= 3226)) || pixel_index == 3229 || pixel_index == 3299 || ((pixel_index >= 3302) && (pixel_index <= 3304)) || pixel_index == 3310 || pixel_index == 3312 || pixel_index == 3314 || ((pixel_index >= 3320) && (pixel_index <= 3322)) || pixel_index == 3325 || pixel_index == 3396 || pixel_index == 3398 || pixel_index == 3400 || pixel_index == 3416 || pixel_index == 3418 || pixel_index == 3420 || pixel_index == 3492 || pixel_index == 3494 || ((pixel_index >= 3498) && (pixel_index <= 3502)) || ((pixel_index >= 3506) && (pixel_index <= 3510)) || pixel_index == 3514 || pixel_index == 3516 || ((pixel_index >= 3588) && (pixel_index <= 3590)) || ((pixel_index >= 3597) && (pixel_index <= 3598)) || ((pixel_index >= 3602) && (pixel_index <= 3603)) || ((pixel_index >= 3610) && (pixel_index <= 3612)) || ((pixel_index >= 3685) && (pixel_index <= 3686)) || ((pixel_index >= 3693) && (pixel_index <= 3694)) || ((pixel_index >= 3698) && (pixel_index <= 3699)) || ((pixel_index >= 3706) && (pixel_index <= 3707)) || ((pixel_index >= 3782) && (pixel_index <= 3783)) || ((pixel_index >= 3801) && (pixel_index <= 3802)) || ((pixel_index >= 3878) && (pixel_index <= 3879)) || ((pixel_index >= 3897) && (pixel_index <= 3898)) || ((pixel_index >= 3974) && (pixel_index <= 3975)) || ((pixel_index >= 3993) && (pixel_index <= 3994)) || ((pixel_index >= 4070) && (pixel_index <= 4071)) || ((pixel_index >= 4089) && (pixel_index <= 4090)) || pixel_index == 4167 || pixel_index == 4185 || pixel_index == 4263 || pixel_index == 4281 || pixel_index == 4458 || ((pixel_index >= 4462) && (pixel_index <= 4466)) || pixel_index == 4470 || ((pixel_index >= 4555) && (pixel_index <= 4558)) || ((pixel_index >= 4562) && (pixel_index <= 4565)) || pixel_index == 4652 || pixel_index == 4660) oled_data = 16'b0101001010000000;
                else if (((pixel_index >= 2632) && (pixel_index <= 2633)) || pixel_index == 2642 || pixel_index == 2645 || pixel_index == 2731 || pixel_index == 2743 || pixel_index == 2841 || pixel_index == 3016 || pixel_index == 3018 || pixel_index == 3030 || pixel_index == 3032 || ((pixel_index >= 3108) && (pixel_index <= 3109)) || pixel_index == 3111 || pixel_index == 3129 || pixel_index == 3131 || ((pixel_index >= 3204) && (pixel_index <= 3205)) || ((pixel_index >= 3227) && (pixel_index <= 3228)) || ((pixel_index >= 3300) && (pixel_index <= 3301)) || ((pixel_index >= 3307) && (pixel_index <= 3308)) || ((pixel_index >= 3316) && (pixel_index <= 3317)) || ((pixel_index >= 3323) && (pixel_index <= 3324)) || pixel_index == 3397 || pixel_index == 3406 || pixel_index == 3410 || pixel_index == 3419 || pixel_index == 3493 || pixel_index == 3515) oled_data = 16'b0000001010000000;
                else if (pixel_index == 2634 || pixel_index == 2729 || pixel_index == 2733 || ((pixel_index >= 2741) && (pixel_index <= 2742)) || ((pixel_index >= 2825) && (pixel_index <= 2828)) || ((pixel_index >= 2832) && (pixel_index <= 2833)) || ((pixel_index >= 2835) && (pixel_index <= 2839)) || ((pixel_index >= 2921) && (pixel_index <= 2924)) || ((pixel_index >= 2927) && (pixel_index <= 2935)) || ((pixel_index >= 3019) && (pixel_index <= 3029)) || ((pixel_index >= 3117) && (pixel_index <= 3123)) || ((pixel_index >= 3214) && (pixel_index <= 3218)) || pixel_index == 3311 || pixel_index == 3313 || pixel_index == 3399 || pixel_index == 3401 || ((pixel_index >= 3407) && (pixel_index <= 3409)) || pixel_index == 3415 || pixel_index == 3417 || ((pixel_index >= 3495) && (pixel_index <= 3497)) || ((pixel_index >= 3511) && (pixel_index <= 3513)) || ((pixel_index >= 3591) && (pixel_index <= 3596)) || pixel_index == 3601 || ((pixel_index >= 3604) && (pixel_index <= 3609)) || ((pixel_index >= 3687) && (pixel_index <= 3692)) || ((pixel_index >= 3700) && (pixel_index <= 3705)) || ((pixel_index >= 3784) && (pixel_index <= 3791)) || ((pixel_index >= 3793) && (pixel_index <= 3800)) || ((pixel_index >= 3880) && (pixel_index <= 3882)) || ((pixel_index >= 3885) && (pixel_index <= 3891)) || ((pixel_index >= 3894) && (pixel_index <= 3896)) || ((pixel_index >= 3976) && (pixel_index <= 3977)) || ((pixel_index >= 3991) && (pixel_index <= 3992)) || pixel_index == 4072 || pixel_index == 4088 || pixel_index == 4168 || pixel_index == 4184 || ((pixel_index >= 4264) && (pixel_index <= 4265)) || ((pixel_index >= 4279) && (pixel_index <= 4280)) || ((pixel_index >= 4360) && (pixel_index <= 4361)) || pixel_index == 4368 || ((pixel_index >= 4375) && (pixel_index <= 4376)) || ((pixel_index >= 4456) && (pixel_index <= 4457)) || ((pixel_index >= 4459) && (pixel_index <= 4461)) || ((pixel_index >= 4467) && (pixel_index <= 4469)) || ((pixel_index >= 4471) && (pixel_index <= 4472)) || ((pixel_index >= 4553) && (pixel_index <= 4554)) || ((pixel_index >= 4559) && (pixel_index <= 4561)) || ((pixel_index >= 4566) && (pixel_index <= 4567)) || ((pixel_index >= 4649) && (pixel_index <= 4651)) || ((pixel_index >= 4653) && (pixel_index <= 4659)) || ((pixel_index >= 4661) && (pixel_index <= 4663)) || (pixel_index >= 4746) && (pixel_index <= 4758)) oled_data = 16'b0101010100000000;
                else if (pixel_index == 3011 || pixel_index == 3395 || ((pixel_index >= 3402) && (pixel_index <= 3404)) || ((pixel_index >= 3412) && (pixel_index <= 3414)) || ((pixel_index >= 3503) && (pixel_index <= 3505)) || ((pixel_index >= 3599) && (pixel_index <= 3600)) || ((pixel_index >= 3695) && (pixel_index <= 3697)) || pixel_index == 3792 || ((pixel_index >= 3883) && (pixel_index <= 3884)) || ((pixel_index >= 3892) && (pixel_index <= 3893)) || pixel_index == 4073 || pixel_index == 4087 || pixel_index == 4166 || pixel_index == 4169 || pixel_index == 4183 || pixel_index == 4186 || ((pixel_index >= 4271) && (pixel_index <= 4273)) || pixel_index == 4278 || pixel_index == 4359 || ((pixel_index >= 4362) && (pixel_index <= 4367)) || ((pixel_index >= 4369) && (pixel_index <= 4374)) || pixel_index == 4377 || pixel_index == 4552 || pixel_index == 4568 || pixel_index == 4745 || pixel_index == 4759) oled_data = 16'b0101010100001010;
                else if (pixel_index == 3405 || pixel_index == 3411 || pixel_index == 3421 || pixel_index == 3877 || pixel_index == 3973 || pixel_index == 3983 || pixel_index == 3985 || pixel_index == 4266 || ((pixel_index >= 4269) && (pixel_index <= 4270)) || (pixel_index >= 4274) && (pixel_index <= 4275)) oled_data = 16'b1010010100001010;
                else if (pixel_index == 3517 || pixel_index == 4069 || pixel_index == 4091) oled_data = 16'b1010011110010100;
                else oled_data = 16'hFFFF;        
            end else // bruce
            begin
                if (((pixel_index >= 1397) && (pixel_index <= 1398)) || ((pixel_index >= 1483) && (pixel_index <= 1484)) || pixel_index == 1490 || pixel_index == 1495 || pixel_index == 1576 || pixel_index == 1592 || pixel_index == 1671 || pixel_index == 1957 || pixel_index == 2073 || pixel_index == 2148 || pixel_index == 2169 || pixel_index == 2244 || pixel_index == 2458 || pixel_index == 2554 || pixel_index == 2650 || pixel_index == 2746 || pixel_index == 2842 || pixel_index == 2938 || pixel_index == 3877 || ((pixel_index >= 4076) && (pixel_index <= 4080)) || pixel_index == 4172 || pixel_index == 4183 || pixel_index == 4262 || pixel_index == 4269 || pixel_index == 4271 || pixel_index == 4374 || pixel_index == 4469 || pixel_index == 4553 || pixel_index == 4564 || pixel_index == 4650 || pixel_index == 4659 || pixel_index == 4747 || pixel_index == 4753) oled_data = 16'b1010010100010100;
                else if (pixel_index == 1485 || pixel_index == 1489 || pixel_index == 1491 || pixel_index == 1688 || pixel_index == 2346 || pixel_index == 2444 || pixel_index == 2454 || pixel_index == 2535 || pixel_index == 2544 || ((pixel_index >= 2546) && (pixel_index <= 2547)) || pixel_index == 2918 || ((pixel_index >= 3017) && (pixel_index <= 3020)) || ((pixel_index >= 3025) && (pixel_index <= 3028)) || pixel_index == 3031 || pixel_index == 3127 || pixel_index == 3221 || pixel_index == 3223 || pixel_index == 3225 || pixel_index == 3315 || pixel_index == 3319 || ((pixel_index >= 3415) && (pixel_index <= 3416)) || pixel_index == 3512 || ((pixel_index >= 3589) && (pixel_index <= 3590)) || pixel_index == 3608 || pixel_index == 3685 || pixel_index == 3798 || ((pixel_index >= 3978) && (pixel_index <= 3979)) || ((pixel_index >= 3985) && (pixel_index <= 3986)) || pixel_index == 3988 || pixel_index == 3991 || pixel_index == 4081 || pixel_index == 4272 || pixel_index == 4748) oled_data = 16'b1010001010001010;
                else if (((pixel_index >= 1486) && (pixel_index <= 1488)) || pixel_index == 1492 || pixel_index == 1577 || pixel_index == 1767 || pixel_index == 1784 || pixel_index == 1880 || pixel_index == 1958 || pixel_index == 1976 || pixel_index == 2053 || pixel_index == 2265 || pixel_index == 2340 || pixel_index == 2345 || pixel_index == 2436 || pixel_index == 2545 || pixel_index == 3108 || pixel_index == 3125 || pixel_index == 3129 || pixel_index == 3204 || pixel_index == 3306 || pixel_index == 3686 || pixel_index == 3895 || pixel_index == 3977 || pixel_index == 4166 || pixel_index == 4177 || pixel_index == 4268 || pixel_index == 4278 || pixel_index == 4359 || pixel_index == 4456 || pixel_index == 4658) oled_data = 16'b0101001010001010;
                else if (((pixel_index >= 1493) && (pixel_index <= 1494)) || ((pixel_index >= 1578) && (pixel_index <= 1590)) || ((pixel_index >= 1673) && (pixel_index <= 1687)) || ((pixel_index >= 1768) && (pixel_index <= 1783)) || ((pixel_index >= 1863) && (pixel_index <= 1879)) || ((pixel_index >= 1959) && (pixel_index <= 1975)) || ((pixel_index >= 2054) && (pixel_index <= 2072)) || ((pixel_index >= 2149) && (pixel_index <= 2168)) || ((pixel_index >= 2245) && (pixel_index <= 2264)) || ((pixel_index >= 2341) && (pixel_index <= 2343)) || ((pixel_index >= 2348) && (pixel_index <= 2357)) || ((pixel_index >= 2359) && (pixel_index <= 2360)) || ((pixel_index >= 2437) && (pixel_index <= 2438)) || ((pixel_index >= 2447) && (pixel_index <= 2451)) || ((pixel_index >= 2456) && (pixel_index <= 2457)) || ((pixel_index >= 2532) && (pixel_index <= 2534)) || ((pixel_index >= 2552) && (pixel_index <= 2553)) || ((pixel_index >= 2628) && (pixel_index <= 2630)) || ((pixel_index >= 2648) && (pixel_index <= 2649)) || ((pixel_index >= 2724) && (pixel_index <= 2726)) || ((pixel_index >= 2744) && (pixel_index <= 2745)) || ((pixel_index >= 2820) && (pixel_index <= 2821)) || ((pixel_index >= 2840) && (pixel_index <= 2841)) || ((pixel_index >= 2916) && (pixel_index <= 2917)) || ((pixel_index >= 2935) && (pixel_index <= 2937)) || pixel_index == 3012 || ((pixel_index >= 3032) && (pixel_index <= 3033)) || pixel_index == 3128 || pixel_index == 3224 || pixel_index == 3878 || ((pixel_index >= 3974) && (pixel_index <= 3975)) || pixel_index == 3990 || ((pixel_index >= 4071) && (pixel_index <= 4074)) || ((pixel_index >= 4082) && (pixel_index <= 4086)) || ((pixel_index >= 4167) && (pixel_index <= 4171)) || ((pixel_index >= 4178) && (pixel_index <= 4182)) || ((pixel_index >= 4263) && (pixel_index <= 4267)) || ((pixel_index >= 4273) && (pixel_index <= 4277)) || ((pixel_index >= 4360) && (pixel_index <= 4365)) || ((pixel_index >= 4368) && (pixel_index <= 4373)) || ((pixel_index >= 4457) && (pixel_index <= 4461)) || ((pixel_index >= 4464) && (pixel_index <= 4468)) || ((pixel_index >= 4554) && (pixel_index <= 4562)) || ((pixel_index >= 4652) && (pixel_index <= 4657)) || (pixel_index >= 4749) && (pixel_index <= 4751)) oled_data = 16'b0000000000000000;
                else if (pixel_index == 1591 || pixel_index == 1672 || pixel_index == 2344 || pixel_index == 2358 || pixel_index == 2361 || pixel_index == 2446 || pixel_index == 2452 || pixel_index == 2822 || pixel_index == 3124 || pixel_index == 3314 || pixel_index == 3402 || pixel_index == 3410 || pixel_index == 3894 || pixel_index == 3976 || pixel_index == 3989 || pixel_index == 4070 || pixel_index == 4463 || pixel_index == 4563 || pixel_index == 4752) oled_data = 16'b0101000000000000;
                else if (pixel_index == 2347 || pixel_index == 2439 || pixel_index == 2445 || pixel_index == 2453 || pixel_index == 2455 || pixel_index == 2551 || pixel_index == 2647 || pixel_index == 2743 || pixel_index == 2839 || pixel_index == 3013 || pixel_index == 3109 || ((pixel_index >= 3112) && (pixel_index <= 3116)) || ((pixel_index >= 3121) && (pixel_index <= 3123)) || pixel_index == 3205 || pixel_index == 3301 || pixel_index == 3307 || pixel_index == 3320 || pixel_index == 3397 || pixel_index == 3403 || pixel_index == 3411 || pixel_index == 3493 || pixel_index == 3511 || pixel_index == 3607 || pixel_index == 3703 || pixel_index == 3782 || pixel_index == 3799 || pixel_index == 3879 || ((pixel_index >= 3980) && (pixel_index <= 3984)) || pixel_index == 4075 || ((pixel_index >= 4366) && (pixel_index <= 4367)) || pixel_index == 4462 || pixel_index == 4651) oled_data = 16'b0101001010000000;
                else if (pixel_index == 2440 || pixel_index == 2543 || pixel_index == 2550 || pixel_index == 2631 || pixel_index == 2646 || pixel_index == 2727 || pixel_index == 2742 || pixel_index == 2838 || pixel_index == 2934 || pixel_index == 3014 || pixel_index == 3016 || pixel_index == 3024 || pixel_index == 3030 || pixel_index == 3110 || pixel_index == 3120 || pixel_index == 3126 || ((pixel_index >= 3206) && (pixel_index <= 3208)) || pixel_index == 3222 || pixel_index == 3300 || pixel_index == 3302 || pixel_index == 3318 || pixel_index == 3321 || pixel_index == 3396 || ((pixel_index >= 3398) && (pixel_index <= 3399)) || pixel_index == 3406 || pixel_index == 3414 || pixel_index == 3417 || pixel_index == 3492 || ((pixel_index >= 3494) && (pixel_index <= 3495)) || pixel_index == 3501 || pixel_index == 3510 || pixel_index == 3513 || pixel_index == 3591 || pixel_index == 3597 || pixel_index == 3606 || pixel_index == 3687 || pixel_index == 3693 || pixel_index == 3702 || pixel_index == 3704 || pixel_index == 3781 || pixel_index == 3783 || pixel_index == 3789 || ((pixel_index >= 3885) && (pixel_index <= 3887)) || pixel_index == 3893 || pixel_index == 3987 || pixel_index == 4087) oled_data = 16'b1010010100001010;
                else if (((pixel_index >= 2441) && (pixel_index <= 2443)) || ((pixel_index >= 2536) && (pixel_index <= 2542)) || ((pixel_index >= 2548) && (pixel_index <= 2549)) || ((pixel_index >= 2632) && (pixel_index <= 2645)) || ((pixel_index >= 2728) && (pixel_index <= 2741)) || ((pixel_index >= 2823) && (pixel_index <= 2837)) || ((pixel_index >= 2919) && (pixel_index <= 2933)) || pixel_index == 3015 || ((pixel_index >= 3021) && (pixel_index <= 3023)) || pixel_index == 3029 || pixel_index == 3111 || ((pixel_index >= 3117) && (pixel_index <= 3119)) || ((pixel_index >= 3209) && (pixel_index <= 3220)) || ((pixel_index >= 3303) && (pixel_index <= 3305)) || ((pixel_index >= 3308) && (pixel_index <= 3313)) || ((pixel_index >= 3316) && (pixel_index <= 3317)) || ((pixel_index >= 3400) && (pixel_index <= 3401)) || ((pixel_index >= 3404) && (pixel_index <= 3405)) || ((pixel_index >= 3407) && (pixel_index <= 3409)) || ((pixel_index >= 3412) && (pixel_index <= 3413)) || ((pixel_index >= 3496) && (pixel_index <= 3500)) || ((pixel_index >= 3502) && (pixel_index <= 3509)) || pixel_index == 3588 || ((pixel_index >= 3592) && (pixel_index <= 3596)) || ((pixel_index >= 3598) && (pixel_index <= 3605)) || pixel_index == 3609 || pixel_index == 3684 || ((pixel_index >= 3688) && (pixel_index <= 3692)) || ((pixel_index >= 3694) && (pixel_index <= 3701)) || ((pixel_index >= 3784) && (pixel_index <= 3788)) || ((pixel_index >= 3790) && (pixel_index <= 3797)) || ((pixel_index >= 3880) && (pixel_index <= 3884)) || (pixel_index >= 3888) && (pixel_index <= 3892)) oled_data = 16'b1111010100001010;
                else if (pixel_index == 3395 || pixel_index == 3491 || pixel_index == 3587 || pixel_index == 3780) oled_data = 16'b1111011110010100;
                else if (pixel_index == 3705 || pixel_index == 3800) oled_data = 16'b1111010100010100;
                else oled_data = 16'hFFFF;
            end
        end 
    end
    end

endmodule
