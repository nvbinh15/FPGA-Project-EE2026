`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2021 08:43:58 PM
// Design Name: 
// Module Name: game_over
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


module game_over(
    input [3:0] state,
    input CLK100MHZ,
    input [15:0] sw,
    output [7:0] JC,
    output reg [3:0] state_out = 9
    );
    
    
    wire clk6p25m;
    
    clock_divider clock_6p25m (.basys_clock(CLK100MHZ), .m(7), .new_clock(clk6p25m));
    
    reg [15:0] oled_data = 0;
    wire frame_begin, sending_pixels, sample_pixel, teststate;
    wire [12:0] pixel_index;
    Oled_Display oled(
        .clk(clk6p25m), .reset(0), .frame_begin(frame_begin), .sending_pixels(sending_pixels),
        .sample_pixel(sample_pixel), .pixel_index(pixel_index), .pixel_data(oled_data), .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]),
        .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]),
        .pmoden(JC[7]),.teststate(teststate)
    );
    
    wire [12:0] x, y;
    find_row_col row_col (pixel_index, y, x);
    
    always @ (posedge CLK100MHZ)
    begin
        if (state == 9)
        begin
            if (sw[15] == 1) state_out <= 0;
        end else state_out <= 9;
    end
    
    always @ (posedge CLK100MHZ)
    begin
    if (state == 9) begin
        if ((x == 26 && y == 5) || (x == 27 && y == 5) || (x == 28 && y == 5) || (x == 25 && y == 6) || (x == 25 && y == 7) || (x == 27 && y == 7) || (x == 28 && y == 7) || (x == 29 && y == 7) || (x == 25 && y == 8) || (x == 29 && y == 8) || (x == 26 && y == 9) || (x == 27 && y == 9) || (x == 28 && y == 9) || (x == 32 && y == 5) || (x == 33 && y == 5) || (x == 31 && y == 6) || (x == 34 && y == 6) || (x == 31 && y == 7) || (x == 32 && y == 7) || (x == 33 && y == 7) || (x == 34 && y == 7) || (x == 31 && y == 8) || (x == 34 && y == 8) || (x == 31 && y == 9) || (x == 34 && y == 9) || (x == 36 && y == 5) || (x == 40 && y == 5) || (x == 36 && y == 6) || (x == 37 && y == 6) || (x == 39 && y == 6) || (x == 40 && y == 6) || (x == 36 && y == 7) || (x == 38 && y == 7) || (x == 40 && y == 7) || (x == 36 && y == 8) || (x == 40 && y == 8) || (x == 36 && y == 9) || (x == 40 && y == 9) || (x == 42 && y == 5) || (x == 43 && y == 5) || (x == 44 && y == 5) || (x == 45 && y == 5) || (x == 42 && y == 6) || (x == 42 && y == 7) || (x == 43 && y == 7) || (x == 44 && y == 7) || (x == 45 && y == 7) || (x == 42 && y == 8) || (x == 42 && y == 9) || (x == 43 && y == 9) || (x == 44 && y == 9) || (x == 45 && y == 9) || (x == 51 && y == 5) || (x == 52 && y == 5) || (x == 50 && y == 6) || (x == 53 && y == 6) || (x == 50 && y == 7) || (x == 53 && y == 7) || (x == 50 && y == 8) || (x == 53 && y == 8) || (x == 51 && y == 9) || (x == 52 && y == 9) || (x == 55 && y == 5) || (x == 59 && y == 5) || (x == 55 && y == 6) || (x == 59 && y == 6) || (x == 55 && y == 7) || (x == 59 && y == 7) || (x == 56 && y == 8) || (x == 58 && y == 8) || (x == 57 && y == 9) || (x == 61 && y == 5) || (x == 62 && y == 5) || (x == 63 && y == 5) || (x == 64 && y == 5) || (x == 61 && y == 6) || (x == 61 && y == 7) || (x == 62 && y == 7) || (x == 63 && y == 7) || (x == 64 && y == 7) || (x == 61 && y == 8) || (x == 61 && y == 9) || (x == 62 && y == 9) || (x == 63 && y == 9) || (x == 64 && y == 9) || (x == 66 && y == 5) || (x == 67 && y == 5) || (x == 68 && y == 5) || (x == 66 && y == 6) || (x == 69 && y == 6) || (x == 66 && y == 7) || (x == 67 && y == 7) || (x == 68 && y == 7) || (x == 66 && y == 8) || (x == 68 && y == 8) || (x == 66 && y == 9) || (x == 69 && y == 9))
        oled_data <= 16'hFFFF;
    
        else if (((pixel_index >= 1679) && (pixel_index <= 1683)) || ((pixel_index >= 1775) && (pixel_index <= 1781)) || ((pixel_index >= 1865) && (pixel_index <= 1867)) || ((pixel_index >= 1869) && (pixel_index <= 1870)) || ((pixel_index >= 1878) && (pixel_index <= 1879)) || pixel_index == 1963 || pixel_index == 1965 || ((pixel_index >= 1975) && (pixel_index <= 1976)) || pixel_index == 2055 || ((pixel_index >= 2058) && (pixel_index <= 2062)) || pixel_index == 2154 || ((pixel_index >= 2158) && (pixel_index <= 2159)) || pixel_index == 2246 || pixel_index == 2249 || pixel_index == 2254 || pixel_index == 2257 || pixel_index == 2341 || pixel_index == 2351 || ((pixel_index >= 2360) && (pixel_index <= 2362)) || pixel_index == 2440 || pixel_index == 2447 || pixel_index == 2535 || pixel_index == 2544 || pixel_index == 2555 || pixel_index == 2628 || ((pixel_index >= 2631) && (pixel_index <= 2632)) || pixel_index == 2724 || pixel_index == 2727 || ((pixel_index >= 2729) && (pixel_index <= 2730)) || pixel_index == 2823 || pixel_index == 2840 || pixel_index == 2843 || pixel_index == 2916 || ((pixel_index >= 2919) && (pixel_index <= 2920)) || pixel_index == 2931 || ((pixel_index >= 2934) && (pixel_index <= 2935)) || pixel_index == 2937 || pixel_index == 3015 || ((pixel_index >= 3020) && (pixel_index <= 3023)) || ((pixel_index >= 3030) && (pixel_index <= 3031)) || pixel_index == 3033 || pixel_index == 3108 || ((pixel_index >= 3111) && (pixel_index <= 3112)) || pixel_index == 3116 || ((pixel_index >= 3118) && (pixel_index <= 3119)) || pixel_index == 3123 || ((pixel_index >= 3126) && (pixel_index <= 3127)) || ((pixel_index >= 3129) && (pixel_index <= 3130)) || ((pixel_index >= 3207) && (pixel_index <= 3208)) || ((pixel_index >= 3214) && (pixel_index <= 3215)) || pixel_index == 3219 || ((pixel_index >= 3222) && (pixel_index <= 3223)) || pixel_index == 3225 || ((pixel_index >= 3303) && (pixel_index <= 3304)) || pixel_index == 3310 || ((pixel_index >= 3318) && (pixel_index <= 3321)) || pixel_index == 3396 || ((pixel_index >= 3399) && (pixel_index <= 3400)) || ((pixel_index >= 3404) && (pixel_index <= 3408)) || ((pixel_index >= 3414) && (pixel_index <= 3416)) || pixel_index == 3492 || pixel_index == 3496 || pixel_index == 3500 || pixel_index == 3503 || ((pixel_index >= 3507) && (pixel_index <= 3508)) || pixel_index == 3511 || pixel_index == 3516 || pixel_index == 3587 || pixel_index == 3591 || ((pixel_index >= 3596) && (pixel_index <= 3597)) || pixel_index == 3600 || pixel_index == 3603 || ((pixel_index >= 3606) && (pixel_index <= 3607)) || pixel_index == 3612 || ((pixel_index >= 3683) && (pixel_index <= 3684)) || ((pixel_index >= 3692) && (pixel_index <= 3693)) || pixel_index == 3699 || ((pixel_index >= 3702) && (pixel_index <= 3703)) || pixel_index == 3779 || pixel_index == 3783 || ((pixel_index >= 3788) && (pixel_index <= 3789)) || pixel_index == 3792 || ((pixel_index >= 3795) && (pixel_index <= 3796)) || pixel_index == 3798 || ((pixel_index >= 3802) && (pixel_index <= 3803)) || pixel_index == 3875 || ((pixel_index >= 3879) && (pixel_index <= 3880)) || pixel_index == 3885 || pixel_index == 3888 || ((pixel_index >= 3891) && (pixel_index <= 3892)) || ((pixel_index >= 3894) && (pixel_index <= 3895)) || pixel_index == 3975 || pixel_index == 3980 || pixel_index == 3984 || ((pixel_index >= 3987) && (pixel_index <= 3988)) || ((pixel_index >= 4071) && (pixel_index <= 4072)) || pixel_index == 4077 || pixel_index == 4087 || pixel_index == 4163 || pixel_index == 4167 || pixel_index == 4169 || ((pixel_index >= 4262) && (pixel_index <= 4263)) || ((pixel_index >= 4265) && (pixel_index <= 4266)) || pixel_index == 4269 || pixel_index == 4355 || pixel_index == 4359 || pixel_index == 4361 || pixel_index == 4363 || pixel_index == 4459 || pixel_index == 4647 || pixel_index == 4668 || ((pixel_index >= 4742) && (pixel_index <= 4744)) || ((pixel_index >= 4837) && (pixel_index <= 4841)) || pixel_index == 4861 || ((pixel_index >= 4932) && (pixel_index <= 4938)) || pixel_index == 4943 || pixel_index == 4957 || ((pixel_index >= 5029) && (pixel_index <= 5030)) || pixel_index == 5032 || pixel_index == 5044 || pixel_index == 5053 || pixel_index == 5125 || ((pixel_index >= 5128) && (pixel_index <= 5130)) || pixel_index == 5136 || pixel_index == 5147 || ((pixel_index >= 5149) && (pixel_index <= 5150)) || pixel_index == 5220 || ((pixel_index >= 5224) && (pixel_index <= 5229)) || pixel_index == 5232 || ((pixel_index >= 5236) && (pixel_index <= 5237)) || pixel_index == 5243 || pixel_index == 5245 || pixel_index == 5314 || pixel_index == 5316 || ((pixel_index >= 5318) && (pixel_index <= 5320)) || ((pixel_index >= 5324) && (pixel_index <= 5325)) || pixel_index == 5328 || pixel_index == 5332 || ((pixel_index >= 5339) && (pixel_index <= 5340)) || pixel_index == 5410 || ((pixel_index >= 5414) && (pixel_index <= 5416)) || pixel_index == 5419 || pixel_index == 5421 || pixel_index == 5423 || pixel_index == 5428 || pixel_index == 5432 || pixel_index == 5437 || pixel_index == 5506 || pixel_index == 5510 || pixel_index == 5512 || ((pixel_index >= 5515) && (pixel_index <= 5517)) || pixel_index == 5519 || pixel_index == 5521 || pixel_index == 5524 || ((pixel_index >= 5526) && (pixel_index <= 5527)) || ((pixel_index >= 5531) && (pixel_index <= 5534)) || pixel_index == 5604 || ((pixel_index >= 5606) && (pixel_index <= 5607)) || pixel_index == 5618 || pixel_index == 5621 || pixel_index == 5623 || ((pixel_index >= 5626) && (pixel_index <= 5629)) || ((pixel_index >= 5703) && (pixel_index <= 5704)) || ((pixel_index >= 5706) && (pixel_index <= 5707)) || ((pixel_index >= 5711) && (pixel_index <= 5712)) || ((pixel_index >= 5716) && (pixel_index <= 5724)) || ((pixel_index >= 5801) && (pixel_index <= 5805)) || ((pixel_index >= 5807) && (pixel_index <= 5812)) || pixel_index == 5900 || (pixel_index >= 5903) && (pixel_index <= 5904)) oled_data = 16'b0101001010001010;
        else if (((pixel_index >= 1773) && (pixel_index <= 1774)) || pixel_index == 1868 || pixel_index == 1871 || pixel_index == 1873 || pixel_index == 1877 || ((pixel_index >= 1961) && (pixel_index <= 1962)) || pixel_index == 1966 || ((pixel_index >= 1968) && (pixel_index <= 1970)) || ((pixel_index >= 2056) && (pixel_index <= 2057)) || ((pixel_index >= 2064) && (pixel_index <= 2068)) || pixel_index == 2072 || ((pixel_index >= 2151) && (pixel_index <= 2153)) || pixel_index == 2157 || ((pixel_index >= 2160) && (pixel_index <= 2165)) || pixel_index == 2169 || ((pixel_index >= 2247) && (pixel_index <= 2248)) || ((pixel_index >= 2250) && (pixel_index <= 2251)) || pixel_index == 2253 || pixel_index == 2256 || ((pixel_index >= 2258) && (pixel_index <= 2262)) || pixel_index == 2265 || ((pixel_index >= 2342) && (pixel_index <= 2345)) || ((pixel_index >= 2347) && (pixel_index <= 2350)) || pixel_index == 2352 || ((pixel_index >= 2354) && (pixel_index <= 2359)) || ((pixel_index >= 2437) && (pixel_index <= 2439)) || ((pixel_index >= 2441) && (pixel_index <= 2446)) || ((pixel_index >= 2448) && (pixel_index <= 2458)) || ((pixel_index >= 2533) && (pixel_index <= 2534)) || ((pixel_index >= 2536) && (pixel_index <= 2543)) || ((pixel_index >= 2545) && (pixel_index <= 2554)) || ((pixel_index >= 2629) && (pixel_index <= 2630)) || ((pixel_index >= 2633) && (pixel_index <= 2651)) || ((pixel_index >= 2725) && (pixel_index <= 2726)) || ((pixel_index >= 2731) && (pixel_index <= 2742)) || ((pixel_index >= 2744) && (pixel_index <= 2747)) || ((pixel_index >= 2820) && (pixel_index <= 2822)) || ((pixel_index >= 2825) && (pixel_index <= 2839)) || ((pixel_index >= 2841) && (pixel_index <= 2842)) || ((pixel_index >= 2917) && (pixel_index <= 2918)) || ((pixel_index >= 2921) && (pixel_index <= 2924)) || ((pixel_index >= 2926) && (pixel_index <= 2930)) || ((pixel_index >= 2932) && (pixel_index <= 2933)) || ((pixel_index >= 2938) && (pixel_index <= 2939)) || ((pixel_index >= 3012) && (pixel_index <= 3014)) || ((pixel_index >= 3016) && (pixel_index <= 3019)) || ((pixel_index >= 3024) && (pixel_index <= 3029)) || pixel_index == 3032 || ((pixel_index >= 3034) && (pixel_index <= 3035)) || ((pixel_index >= 3109) && (pixel_index <= 3110)) || ((pixel_index >= 3113) && (pixel_index <= 3115)) || pixel_index == 3117 || ((pixel_index >= 3120) && (pixel_index <= 3122)) || ((pixel_index >= 3124) && (pixel_index <= 3125)) || pixel_index == 3128 || pixel_index == 3131 || ((pixel_index >= 3204) && (pixel_index <= 3206)) || ((pixel_index >= 3209) && (pixel_index <= 3211)) || pixel_index == 3213 || ((pixel_index >= 3216) && (pixel_index <= 3218)) || ((pixel_index >= 3220) && (pixel_index <= 3221)) || pixel_index == 3224 || ((pixel_index >= 3226) && (pixel_index <= 3227)) || ((pixel_index >= 3300) && (pixel_index <= 3302)) || ((pixel_index >= 3305) && (pixel_index <= 3307)) || ((pixel_index >= 3311) && (pixel_index <= 3314)) || ((pixel_index >= 3316) && (pixel_index <= 3317)) || ((pixel_index >= 3322) && (pixel_index <= 3323)) || ((pixel_index >= 3397) && (pixel_index <= 3398)) || ((pixel_index >= 3401) && (pixel_index <= 3403)) || ((pixel_index >= 3409) && (pixel_index <= 3410)) || ((pixel_index >= 3412) && (pixel_index <= 3413)) || ((pixel_index >= 3417) && (pixel_index <= 3419)) || ((pixel_index >= 3493) && (pixel_index <= 3494)) || ((pixel_index >= 3497) && (pixel_index <= 3499)) || ((pixel_index >= 3501) && (pixel_index <= 3502)) || ((pixel_index >= 3505) && (pixel_index <= 3506)) || ((pixel_index >= 3509) && (pixel_index <= 3510)) || ((pixel_index >= 3512) && (pixel_index <= 3515)) || ((pixel_index >= 3588) && (pixel_index <= 3590)) || ((pixel_index >= 3592) && (pixel_index <= 3595)) || ((pixel_index >= 3598) && (pixel_index <= 3599)) || ((pixel_index >= 3601) && (pixel_index <= 3602)) || ((pixel_index >= 3604) && (pixel_index <= 3605)) || ((pixel_index >= 3608) && (pixel_index <= 3611)) || ((pixel_index >= 3685) && (pixel_index <= 3686)) || ((pixel_index >= 3688) && (pixel_index <= 3691)) || ((pixel_index >= 3694) && (pixel_index <= 3695)) || ((pixel_index >= 3697) && (pixel_index <= 3698)) || ((pixel_index >= 3700) && (pixel_index <= 3701)) || ((pixel_index >= 3704) && (pixel_index <= 3707)) || ((pixel_index >= 3780) && (pixel_index <= 3782)) || ((pixel_index >= 3784) && (pixel_index <= 3787)) || ((pixel_index >= 3790) && (pixel_index <= 3791)) || ((pixel_index >= 3793) && (pixel_index <= 3794)) || pixel_index == 3797 || ((pixel_index >= 3800) && (pixel_index <= 3801)) || ((pixel_index >= 3876) && (pixel_index <= 3878)) || ((pixel_index >= 3881) && (pixel_index <= 3884)) || ((pixel_index >= 3886) && (pixel_index <= 3887)) || ((pixel_index >= 3889) && (pixel_index <= 3890)) || pixel_index == 3893 || ((pixel_index >= 3896) && (pixel_index <= 3897)) || pixel_index == 3900 || ((pixel_index >= 3972) && (pixel_index <= 3974)) || ((pixel_index >= 3977) && (pixel_index <= 3979)) || ((pixel_index >= 3982) && (pixel_index <= 3983)) || ((pixel_index >= 3985) && (pixel_index <= 3986)) || ((pixel_index >= 3989) && (pixel_index <= 3996)) || ((pixel_index >= 4068) && (pixel_index <= 4070)) || ((pixel_index >= 4073) && (pixel_index <= 4075)) || ((pixel_index >= 4078) && (pixel_index <= 4086)) || ((pixel_index >= 4088) && (pixel_index <= 4092)) || ((pixel_index >= 4164) && (pixel_index <= 4166)) || ((pixel_index >= 4170) && (pixel_index <= 4188)) || ((pixel_index >= 4260) && (pixel_index <= 4261)) || ((pixel_index >= 4267) && (pixel_index <= 4268)) || ((pixel_index >= 4270) && (pixel_index <= 4284)) || ((pixel_index >= 4356) && (pixel_index <= 4358)) || pixel_index == 4362 || ((pixel_index >= 4364) && (pixel_index <= 4374)) || ((pixel_index >= 4376) && (pixel_index <= 4380)) || ((pixel_index >= 4452) && (pixel_index <= 4455)) || ((pixel_index >= 4457) && (pixel_index <= 4458)) || ((pixel_index >= 4460) && (pixel_index <= 4476)) || ((pixel_index >= 4548) && (pixel_index <= 4551)) || ((pixel_index >= 4553) && (pixel_index <= 4572)) || ((pixel_index >= 4644) && (pixel_index <= 4646)) || ((pixel_index >= 4649) && (pixel_index <= 4667)) || ((pixel_index >= 4740) && (pixel_index <= 4741)) || ((pixel_index >= 4745) && (pixel_index <= 4764)) || ((pixel_index >= 4842) && (pixel_index <= 4860)) || ((pixel_index >= 4939) && (pixel_index <= 4942)) || ((pixel_index >= 4944) && (pixel_index <= 4956)) || ((pixel_index >= 5034) && (pixel_index <= 5043)) || ((pixel_index >= 5045) && (pixel_index <= 5052)) || pixel_index == 5126 || ((pixel_index >= 5131) && (pixel_index <= 5135)) || ((pixel_index >= 5137) && (pixel_index <= 5139)) || ((pixel_index >= 5141) && (pixel_index <= 5146)) || pixel_index == 5148 || pixel_index == 5222 || ((pixel_index >= 5230) && (pixel_index <= 5231)) || ((pixel_index >= 5233) && (pixel_index <= 5235)) || ((pixel_index >= 5238) && (pixel_index <= 5241)) || pixel_index == 5244 || pixel_index == 5323 || ((pixel_index >= 5326) && (pixel_index <= 5327)) || ((pixel_index >= 5329) && (pixel_index <= 5331)) || ((pixel_index >= 5334) && (pixel_index <= 5335)) || pixel_index == 5337 || pixel_index == 5341 || pixel_index == 5422 || ((pixel_index >= 5425) && (pixel_index <= 5427)) || ((pixel_index >= 5430) && (pixel_index <= 5431)) || pixel_index == 5518 || (pixel_index >= 5522) && (pixel_index <= 5523)) oled_data = 16'b1010010100010100;
        else if (pixel_index == 1872 || pixel_index == 1874 || pixel_index == 1967 || pixel_index == 2063 || pixel_index == 2070 || ((pixel_index >= 2155) && (pixel_index <= 2156)) || pixel_index == 2167) oled_data = 16'b1111011110011110;
        else if (((pixel_index >= 1875) && (pixel_index <= 1876)) || ((pixel_index >= 1972) && (pixel_index <= 1974)) || pixel_index == 2071 || pixel_index == 2168 || pixel_index == 2263) oled_data = 16'b1010011110011110;
        else if (pixel_index == 1960 || pixel_index == 3804 || pixel_index == 4076 || pixel_index == 5033 || pixel_index == 5124 || pixel_index == 5242 || pixel_index == 5315 || ((pixel_index >= 5321) && (pixel_index <= 5322)) || pixel_index == 5417 || ((pixel_index >= 5433) && (pixel_index <= 5436)) || pixel_index == 5525 || pixel_index == 5529 || pixel_index == 5612 || pixel_index == 5622) oled_data = 16'b0101010100001010;
        else if (pixel_index == 1971 || pixel_index == 2069 || pixel_index == 2166 || pixel_index == 2252 || pixel_index == 2264 || pixel_index == 2346 || pixel_index == 2353 || pixel_index == 2743 || (pixel_index >= 3898) && (pixel_index <= 3899)) oled_data = 16'b1010011110010100;
        else if (pixel_index == 2925 || pixel_index == 4375) oled_data = 16'b1010010100001010;
        else if (pixel_index == 3324 || pixel_index == 3491 || pixel_index == 5705 || pixel_index == 5816 || pixel_index == 5818 || (pixel_index >= 5999) && (pixel_index <= 6000)) oled_data = 16'b0101000000000000;
        else if (pixel_index == 4643 || pixel_index == 4739 || pixel_index == 4835 || pixel_index == 4930 || ((pixel_index >= 5026) && (pixel_index <= 5027)) || pixel_index == 5054 || pixel_index == 5122 || pixel_index == 5140 || ((pixel_index >= 5217) && (pixel_index <= 5218)) || pixel_index == 5246 || pixel_index == 5313 || pixel_index == 5342 || pixel_index == 5411 || pixel_index == 5424 || pixel_index == 5513 || pixel_index == 5528 || pixel_index == 5530 || ((pixel_index >= 5608) && (pixel_index <= 5611)) || ((pixel_index >= 5613) && (pixel_index <= 5615)) || pixel_index == 5620 || ((pixel_index >= 5624) && (pixel_index <= 5625)) || pixel_index == 5713) oled_data = 16'b0000001010001010;
        else if (pixel_index == 4669 || pixel_index == 4765 || pixel_index == 4931 || pixel_index == 4958 || pixel_index == 5121 || pixel_index == 5123 || pixel_index == 5219 || pixel_index == 5221 || pixel_index == 5343 || pixel_index == 5429 || pixel_index == 5514 || pixel_index == 5617) oled_data = 16'b0000001010000000;
        else if (pixel_index == 4836 || pixel_index == 5028 || pixel_index == 5336 || pixel_index == 5338) oled_data = 16'b0101010100010100;
        else if (pixel_index == 5605 || pixel_index == 5709 || pixel_index == 5907) oled_data = 16'b0101001010000000;
        else oled_data = 0;
    end
    end


endmodule
