`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2021 11:40:23 PM
// Design Name: 
// Module Name: game_menu
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


module game_menu(
    input [3:0] state,
    input CLK100MHZ,
    input btnD, btnU, btnC,
    output [7:0] JC,
    output reg [3:0] state_out = 3
    );
    
    wire clk6p25m, clk10;
    
    clock_divider clock_6p25m (.basys_clock(CLK100MHZ), .m(7), .new_clock(clk6p25m));
    clock_divider clock_10 (.basys_clock(CLK100MHZ), .m(4999999), .new_clock(clk10));

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
    wire down, up, enter;
    
    find_row_col row_col (pixel_index, y, x);
    single_pulse go_down (.clock(clk10),.BTNC(btnD),.OUT(down));
    single_pulse go_up (.clock(clk10),.BTNC(btnU),.OUT(up));
    single_pulse enter_0 (.clock(clk10),.BTNC(btnC),.OUT(enter));
    
    
    wire play, exit;
    assign play = ((x == 38 && y == 30) || (x == 39 && y == 30) || (x == 40 && y == 30) || (x == 38 && y == 31) || (x == 41 && y == 31) || (x == 38 && y == 32) || (x == 39 && y == 32) || (x == 40 && y == 32) || (x == 38 && y == 33) || (x == 38 && y == 34) || (x == 43 && y == 30) || (x == 43 && y == 31) || (x == 43 && y == 32) || (x == 43 && y == 33) || (x == 43 && y == 34) || (x == 44 && y == 34) || (x == 45 && y == 34) || (x == 46 && y == 34) || (x == 49 && y == 30) || (x == 50 && y == 30) || (x == 48 && y == 31) || (x == 51 && y == 31) || (x == 48 && y == 32) || (x == 49 && y == 32) || (x == 50 && y == 32) || (x == 51 && y == 32) || (x == 48 && y == 33) || (x == 51 && y == 33) || (x == 48 && y == 34) || (x == 51 && y == 34) || (x == 53 && y == 30) || (x == 55 && y == 30) || (x == 53 && y == 31) || (x == 55 && y == 31) || (x == 54 && y == 32) || (x == 54 && y == 33) || (x == 54 && y == 34));        
    assign exit = ((x == 40 && y == 40) || (x == 41 && y == 40) || (x == 42 && y == 40) || (x == 43 && y == 40) || (x == 40 && y == 41) || (x == 40 && y == 42) || (x == 41 && y == 42) || (x == 42 && y == 42) || (x == 43 && y == 42) || (x == 40 && y == 43) || (x == 40 && y == 44) || (x == 41 && y == 44) || (x == 42 && y == 44) || (x == 43 && y == 44) || (x == 45 && y == 40) || (x == 47 && y == 40) || (x == 45 && y == 41) || (x == 47 && y == 41) || (x == 46 && y == 42) || (x == 45 && y == 43) || (x == 47 && y == 43) || (x == 45 && y == 44) || (x == 47 && y == 44) || (x == 49 && y == 40) || (x == 49 && y == 41) || (x == 49 && y == 42) || (x == 49 && y == 43) || (x == 49 && y == 44) || (x == 51 && y == 40) || (x == 52 && y == 40) || (x == 53 && y == 40) || (x == 52 && y == 41) || (x == 52 && y == 42) || (x == 52 && y == 43) || (x == 52 && y == 44));
          
  
    reg box_game = 0; // 0: play; 1: how_to_play; 2: exit
    always @ (posedge clk10)
    begin
        if (state == 3) // if game
        begin
            if (down == 1 || up == 1) box_game = ~box_game;
        end else box_game <= 0;
    end
    
    
    always @ (posedge clk10)
    begin
        if (state == 3) // game
        begin
            if (box_game == 1 && enter) state_out <= 0;
            else if (box_game == 0 && enter) state_out <= 4;
        end else state_out <= 3;
    end
    

    always @ (posedge CLK100MHZ)
    
    begin

        if (state == 3) // game
        begin 
            if (!(play || exit))
            begin
                if (((pixel_index >= 674) && (pixel_index <= 677)) || ((pixel_index >= 680) && (pixel_index <= 684)) || ((pixel_index >= 686) && (pixel_index <= 687)) || ((pixel_index >= 689) && (pixel_index <= 690)) || ((pixel_index >= 693) && (pixel_index <= 696)) || ((pixel_index >= 700) && (pixel_index <= 704)) || ((pixel_index >= 706) && (pixel_index <= 707)) || ((pixel_index >= 709) && (pixel_index <= 710)) || ((pixel_index >= 713) && (pixel_index <= 716)) || ((pixel_index >= 721) && (pixel_index <= 724)) || ((pixel_index >= 727) && (pixel_index <= 731)) || ((pixel_index >= 733) && (pixel_index <= 734)) || ((pixel_index >= 737) && (pixel_index <= 741)) || ((pixel_index >= 743) && (pixel_index <= 747)) || ((pixel_index >= 749) && (pixel_index <= 753)) || ((pixel_index >= 756) && (pixel_index <= 759)) || ((pixel_index >= 762) && (pixel_index <= 765)) || pixel_index == 780 || pixel_index == 802 || pixel_index == 827 || pixel_index == 837 || pixel_index == 845 || pixel_index == 874 || pixel_index == 876 || pixel_index == 886 || pixel_index == 893 || pixel_index == 895 || pixel_index == 898 || pixel_index == 900 || pixel_index == 906 || ((pixel_index >= 914) && (pixel_index <= 915)) || pixel_index == 921 || pixel_index == 923 || pixel_index == 931 || pixel_index == 933 || pixel_index == 937 || pixel_index == 941 || pixel_index == 943 || pixel_index == 955 || pixel_index == 972 || pixel_index == 989 || pixel_index == 991 || pixel_index == 994 || pixel_index == 1018 || pixel_index == 1029 || ((pixel_index >= 1034) && (pixel_index <= 1035)) || pixel_index == 1037 || pixel_index == 1068 || pixel_index == 1085 || pixel_index == 1087 || pixel_index == 1090 || pixel_index == 1114 || pixel_index == 1125 || ((pixel_index >= 1130) && (pixel_index <= 1131)) || pixel_index == 1133 || pixel_index == 1162 || pixel_index == 1164 || pixel_index == 1168 || pixel_index == 1170 || pixel_index == 1174 || pixel_index == 1181 || pixel_index == 1183 || pixel_index == 1186 || pixel_index == 1188 || pixel_index == 1194 || pixel_index == 1202 || pixel_index == 1209 || pixel_index == 1211 || pixel_index == 1221 || pixel_index == 1225 || pixel_index == 1229 || pixel_index == 1231 || pixel_index == 1243 || pixel_index == 1260 || pixel_index == 1277 || pixel_index == 1279 || pixel_index == 1282 || pixel_index == 1298 || pixel_index == 1307 || pixel_index == 1317 || pixel_index == 1325 || pixel_index == 1356 || pixel_index == 1360 || pixel_index == 1373 || pixel_index == 1375 || pixel_index == 1378 || pixel_index == 1394 || pixel_index == 1403 || pixel_index == 1413 || pixel_index == 1421 || pixel_index == 2479 || pixel_index == 2567 || pixel_index == 3066 || pixel_index == 3162 || pixel_index == 3244 || pixel_index == 3246 || pixel_index == 3354 || pixel_index == 4204 || pixel_index == 4299 || pixel_index == 4305 || pixel_index == 4397 || pixel_index == 4399) oled_data = 16'b1010010100010100;
                else if (pixel_index == 678 || pixel_index == 688 || pixel_index == 692 || pixel_index == 697 || pixel_index == 708 || pixel_index == 712 || pixel_index == 717 || pixel_index == 720 || pixel_index == 725 || ((pixel_index >= 760) && (pixel_index <= 761)) || pixel_index == 774 || pixel_index == 784 || pixel_index == 788 || pixel_index == 793 || pixel_index == 804 || ((pixel_index >= 807) && (pixel_index <= 808)) || pixel_index == 813 || pixel_index == 816 || pixel_index == 821 || pixel_index == 850 || ((pixel_index >= 856) && (pixel_index <= 857)) || ((pixel_index >= 868) && (pixel_index <= 869)) || pixel_index == 880 || pixel_index == 884 || ((pixel_index >= 887) && (pixel_index <= 889)) || pixel_index == 892 || pixel_index == 896 || ((pixel_index >= 903) && (pixel_index <= 904)) || ((pixel_index >= 907) && (pixel_index <= 909)) || pixel_index == 912 || pixel_index == 917 || ((pixel_index >= 944) && (pixel_index <= 945)) || ((pixel_index >= 950) && (pixel_index <= 951)) || pixel_index == 953 || ((pixel_index >= 956) && (pixel_index <= 957)) || pixel_index == 966 || pixel_index == 976 || pixel_index == 980 || pixel_index == 985 || ((pixel_index >= 999) && (pixel_index <= 1000)) || pixel_index == 1005 || pixel_index == 1008 || pixel_index == 1013 || pixel_index == 1027 || pixel_index == 1033 || pixel_index == 1042 || ((pixel_index >= 1048) && (pixel_index <= 1049)) || pixel_index == 1062 || pixel_index == 1072 || pixel_index == 1076 || pixel_index == 1081 || ((pixel_index >= 1095) && (pixel_index <= 1096)) || pixel_index == 1101 || pixel_index == 1104 || pixel_index == 1109 || pixel_index == 1123 || pixel_index == 1129 || pixel_index == 1138 || ((pixel_index >= 1144) && (pixel_index <= 1145)) || ((pixel_index >= 1154) && (pixel_index <= 1155)) || pixel_index == 1158 || pixel_index == 1172 || ((pixel_index >= 1175) && (pixel_index <= 1177)) || ((pixel_index >= 1191) && (pixel_index <= 1192)) || ((pixel_index >= 1195) && (pixel_index <= 1197)) || pixel_index == 1200 || pixel_index == 1219 || ((pixel_index >= 1232) && (pixel_index <= 1233)) || ((pixel_index >= 1236) && (pixel_index <= 1237)) || ((pixel_index >= 1240) && (pixel_index <= 1242)) || pixel_index == 1254 || pixel_index == 1258 || pixel_index == 1268 || pixel_index == 1273 || pixel_index == 1284 || ((pixel_index >= 1287) && (pixel_index <= 1288)) || pixel_index == 1293 || pixel_index == 1296 || pixel_index == 1305 || pixel_index == 1315 || pixel_index == 1330 || ((pixel_index >= 1336) && (pixel_index <= 1337)) || pixel_index == 1350 || pixel_index == 1354 || pixel_index == 1364 || pixel_index == 1369 || pixel_index == 1380 || pixel_index == 1384 || pixel_index == 1389 || pixel_index == 1392 || pixel_index == 1401 || pixel_index == 1411 || ((pixel_index >= 1432) && (pixel_index <= 1433)) || pixel_index == 2375 || pixel_index == 2384 || pixel_index == 2471 || pixel_index == 2480 || pixel_index == 2568 || pixel_index == 2574 || pixel_index == 2894 || pixel_index == 2989 || ((pixel_index >= 3242) && (pixel_index <= 3243)) || ((pixel_index >= 3338) && (pixel_index <= 3340)) || pixel_index == 3344 || pixel_index == 3468 || pixel_index == 3564 || pixel_index == 3644 || pixel_index == 3833 || pixel_index == 3837 || pixel_index == 3915 || ((pixel_index >= 3919) && (pixel_index <= 3920)) || pixel_index == 4010 || pixel_index == 4018 || pixel_index == 4024 || pixel_index == 4106 || pixel_index == 4114 || pixel_index == 4119 || ((pixel_index >= 4202) && (pixel_index <= 4203)) || pixel_index == 4209 || ((pixel_index >= 4300) && (pixel_index <= 4303)) || pixel_index == 4398) oled_data = 16'b0101001010001010;
                else if (((pixel_index >= 770) && (pixel_index <= 773)) || ((pixel_index >= 776) && (pixel_index <= 779)) || ((pixel_index >= 782) && (pixel_index <= 783)) || ((pixel_index >= 785) && (pixel_index <= 786)) || ((pixel_index >= 789) && (pixel_index <= 792)) || ((pixel_index >= 796) && (pixel_index <= 800)) || pixel_index == 803 || ((pixel_index >= 805) && (pixel_index <= 806)) || ((pixel_index >= 809) && (pixel_index <= 812)) || ((pixel_index >= 817) && (pixel_index <= 820)) || ((pixel_index >= 823) && (pixel_index <= 826)) || ((pixel_index >= 829) && (pixel_index <= 830)) || ((pixel_index >= 833) && (pixel_index <= 836)) || ((pixel_index >= 839) && (pixel_index <= 843)) || ((pixel_index >= 846) && (pixel_index <= 849)) || ((pixel_index >= 852) && (pixel_index <= 855)) || ((pixel_index >= 858) && (pixel_index <= 861)) || ((pixel_index >= 866) && (pixel_index <= 867)) || ((pixel_index >= 872) && (pixel_index <= 873)) || pixel_index == 875 || ((pixel_index >= 878) && (pixel_index <= 879)) || ((pixel_index >= 881) && (pixel_index <= 882)) || pixel_index == 885 || pixel_index == 894 || pixel_index == 899 || ((pixel_index >= 901) && (pixel_index <= 902)) || pixel_index == 905 || pixel_index == 913 || pixel_index == 916 || ((pixel_index >= 919) && (pixel_index <= 920)) || pixel_index == 922 || ((pixel_index >= 925) && (pixel_index <= 926)) || ((pixel_index >= 929) && (pixel_index <= 930)) || pixel_index == 932 || ((pixel_index >= 935) && (pixel_index <= 936)) || ((pixel_index >= 938) && (pixel_index <= 939)) || pixel_index == 942 || ((pixel_index >= 948) && (pixel_index <= 949)) || pixel_index == 954 || ((pixel_index >= 962) && (pixel_index <= 965)) || ((pixel_index >= 968) && (pixel_index <= 971)) || ((pixel_index >= 974) && (pixel_index <= 975)) || ((pixel_index >= 977) && (pixel_index <= 978)) || ((pixel_index >= 981) && (pixel_index <= 984)) || pixel_index == 990 || ((pixel_index >= 995) && (pixel_index <= 998)) || ((pixel_index >= 1001) && (pixel_index <= 1004)) || ((pixel_index >= 1009) && (pixel_index <= 1012)) || ((pixel_index >= 1015) && (pixel_index <= 1017)) || ((pixel_index >= 1021) && (pixel_index <= 1022)) || ((pixel_index >= 1025) && (pixel_index <= 1026)) || pixel_index == 1028 || ((pixel_index >= 1031) && (pixel_index <= 1032)) || ((pixel_index >= 1038) && (pixel_index <= 1041)) || ((pixel_index >= 1044) && (pixel_index <= 1047)) || ((pixel_index >= 1050) && (pixel_index <= 1053)) || ((pixel_index >= 1058) && (pixel_index <= 1061)) || ((pixel_index >= 1064) && (pixel_index <= 1067)) || ((pixel_index >= 1070) && (pixel_index <= 1071)) || ((pixel_index >= 1073) && (pixel_index <= 1074)) || ((pixel_index >= 1077) && (pixel_index <= 1080)) || pixel_index == 1086 || ((pixel_index >= 1091) && (pixel_index <= 1094)) || ((pixel_index >= 1097) && (pixel_index <= 1100)) || ((pixel_index >= 1105) && (pixel_index <= 1108)) || ((pixel_index >= 1111) && (pixel_index <= 1113)) || ((pixel_index >= 1117) && (pixel_index <= 1118)) || ((pixel_index >= 1121) && (pixel_index <= 1122)) || pixel_index == 1124 || ((pixel_index >= 1127) && (pixel_index <= 1128)) || ((pixel_index >= 1134) && (pixel_index <= 1137)) || ((pixel_index >= 1140) && (pixel_index <= 1143)) || ((pixel_index >= 1146) && (pixel_index <= 1149)) || ((pixel_index >= 1156) && (pixel_index <= 1157)) || ((pixel_index >= 1160) && (pixel_index <= 1161)) || pixel_index == 1163 || ((pixel_index >= 1166) && (pixel_index <= 1167)) || pixel_index == 1169 || pixel_index == 1173 || pixel_index == 1182 || pixel_index == 1187 || ((pixel_index >= 1189) && (pixel_index <= 1190)) || pixel_index == 1193 || pixel_index == 1201 || ((pixel_index >= 1207) && (pixel_index <= 1208)) || pixel_index == 1210 || ((pixel_index >= 1213) && (pixel_index <= 1214)) || ((pixel_index >= 1217) && (pixel_index <= 1218)) || pixel_index == 1220 || ((pixel_index >= 1223) && (pixel_index <= 1224)) || ((pixel_index >= 1226) && (pixel_index <= 1227)) || pixel_index == 1230 || ((pixel_index >= 1238) && (pixel_index <= 1239)) || ((pixel_index >= 1244) && (pixel_index <= 1245)) || ((pixel_index >= 1250) && (pixel_index <= 1253)) || ((pixel_index >= 1256) && (pixel_index <= 1257)) || pixel_index == 1259 || ((pixel_index >= 1262) && (pixel_index <= 1264)) || ((pixel_index >= 1269) && (pixel_index <= 1272)) || pixel_index == 1278 || pixel_index == 1283 || ((pixel_index >= 1285) && (pixel_index <= 1286)) || ((pixel_index >= 1289) && (pixel_index <= 1292)) || pixel_index == 1297 || ((pixel_index >= 1303) && (pixel_index <= 1304)) || pixel_index == 1306 || ((pixel_index >= 1309) && (pixel_index <= 1310)) || ((pixel_index >= 1313) && (pixel_index <= 1314)) || pixel_index == 1316 || ((pixel_index >= 1319) && (pixel_index <= 1323)) || ((pixel_index >= 1326) && (pixel_index <= 1329)) || ((pixel_index >= 1332) && (pixel_index <= 1335)) || ((pixel_index >= 1338) && (pixel_index <= 1341)) || ((pixel_index >= 1346) && (pixel_index <= 1349)) || ((pixel_index >= 1352) && (pixel_index <= 1353)) || pixel_index == 1355 || ((pixel_index >= 1358) && (pixel_index <= 1359)) || ((pixel_index >= 1365) && (pixel_index <= 1368)) || pixel_index == 1374 || pixel_index == 1379 || ((pixel_index >= 1381) && (pixel_index <= 1382)) || ((pixel_index >= 1385) && (pixel_index <= 1388)) || pixel_index == 1393 || ((pixel_index >= 1399) && (pixel_index <= 1400)) || pixel_index == 1402 || ((pixel_index >= 1405) && (pixel_index <= 1406)) || ((pixel_index >= 1409) && (pixel_index <= 1410)) || pixel_index == 1412 || ((pixel_index >= 1415) && (pixel_index <= 1419)) || ((pixel_index >= 1422) && (pixel_index <= 1425)) || ((pixel_index >= 1428) && (pixel_index <= 1431)) || ((pixel_index >= 1434) && (pixel_index <= 1437)) || pixel_index == 2383 || pixel_index == 2575) oled_data = 16'b1111011110011110;
                else if (pixel_index == 1265) oled_data = 16'b1010011110010100;
                else if (pixel_index == 1383 || pixel_index == 1426) oled_data = 16'b0000001010000000;
                else if (pixel_index == 2221 || pixel_index == 2315 || pixel_index == 2414 || pixel_index == 2417 || pixel_index == 2506 || pixel_index == 2512 || pixel_index == 2569 || pixel_index == 2576 || ((pixel_index >= 2601) && (pixel_index <= 2602)) || ((pixel_index >= 2605) && (pixel_index <= 2606)) || ((pixel_index >= 2664) && (pixel_index <= 2666)) || pixel_index == 2671 || ((pixel_index >= 2678) && (pixel_index <= 2680)) || ((pixel_index >= 2694) && (pixel_index <= 2697)) || pixel_index == 2703 || pixel_index == 2762 || pixel_index == 2767 || pixel_index == 2769 || pixel_index == 2775 || pixel_index == 2791 || pixel_index == 2859 || pixel_index == 2870 || pixel_index == 2946 || ((pixel_index >= 2955) && (pixel_index <= 2956)) || pixel_index == 2960 || pixel_index == 2969 || pixel_index == 2972 || pixel_index == 3041 || pixel_index == 3056 || pixel_index == 3065 || pixel_index == 3068 || pixel_index == 3089 || pixel_index == 3137 || pixel_index == 3139 || ((pixel_index >= 3147) && (pixel_index <= 3149)) || pixel_index == 3154 || pixel_index == 3161 || pixel_index == 3185 || pixel_index == 3240 || pixel_index == 3248 || pixel_index == 3257 || pixel_index == 3281 || pixel_index == 3331 || pixel_index == 3336 || ((pixel_index >= 3342) && (pixel_index <= 3343)) || ((pixel_index >= 3345) && (pixel_index <= 3348)) || pixel_index == 3352 || pixel_index == 3368 || pixel_index == 3370 || pixel_index == 3377 || pixel_index == 3429 || pixel_index == 3432 || pixel_index == 3445 || pixel_index == 3464 || pixel_index == 3469 || pixel_index == 3527 || pixel_index == 3529 || pixel_index == 3538 || pixel_index == 3562 || pixel_index == 3565 || pixel_index == 3625 || pixel_index == 3634 || pixel_index == 3638 || ((pixel_index >= 3656) && (pixel_index <= 3657)) || ((pixel_index >= 3659) && (pixel_index <= 3661)) || ((pixel_index >= 3720) && (pixel_index <= 3721)) || ((pixel_index >= 3725) && (pixel_index <= 3726)) || pixel_index == 3728 || pixel_index == 3733 || ((pixel_index >= 3752) && (pixel_index <= 3753)) || ((pixel_index >= 3755) && (pixel_index <= 3757)) || pixel_index == 3759 || ((pixel_index >= 3816) && (pixel_index <= 3817)) || ((pixel_index >= 3821) && (pixel_index <= 3824)) || pixel_index == 3827 || pixel_index == 3848 || ((pixel_index >= 3851) && (pixel_index <= 3853)) || ((pixel_index >= 3912) && (pixel_index <= 3913)) || pixel_index == 3918 || pixel_index == 3944 || pixel_index == 3951 || ((pixel_index >= 4008) && (pixel_index <= 4009)) || ((pixel_index >= 4104) && (pixel_index <= 4105)) || pixel_index == 4115 || pixel_index == 4118 || pixel_index == 4135 || ((pixel_index >= 4200) && (pixel_index <= 4201)) || pixel_index == 4210 || pixel_index == 4306 || pixel_index == 4328 || pixel_index == 4395 || pixel_index == 4424 || ((pixel_index >= 4493) && (pixel_index <= 4495)) || pixel_index == 4501 || ((pixel_index >= 4509) && (pixel_index <= 4510)) || pixel_index == 4520 || pixel_index == 4585 || pixel_index == 4587 || pixel_index == 4605 || pixel_index == 4617 || pixel_index == 4701 || ((pixel_index >= 4797) && (pixel_index <= 4798)) || pixel_index == 4874 || ((pixel_index >= 4876) && (pixel_index <= 4882)) || pixel_index == 4884 || ((pixel_index >= 4893) && (pixel_index <= 4894)) || pixel_index == 4904 || pixel_index == 4909 || pixel_index == 4969 || pixel_index == 5000 || ((pixel_index >= 5005) && (pixel_index <= 5006)) || pixel_index == 5067 || pixel_index == 5077) oled_data = 16'b0101000000000000;
                else if (pixel_index == 2316 || pixel_index == 2412 || pixel_index == 2509 || pixel_index == 2604 || pixel_index == 2792 || pixel_index == 2874 || pixel_index == 3177 || pixel_index == 3259 || pixel_index == 3272 || pixel_index == 3355 || pixel_index == 3558 || pixel_index == 3663 || pixel_index == 3761 || pixel_index == 3846 || pixel_index == 4425 || pixel_index == 4429 || pixel_index == 4521 || pixel_index == 4525 || pixel_index == 4621 || pixel_index == 4712 || pixel_index == 4717 || pixel_index == 4808 || pixel_index == 4813) oled_data = 16'b1010001010000000;
                else if (pixel_index == 2317 || pixel_index == 2413 || pixel_index == 2507 || ((pixel_index >= 2700) && (pixel_index <= 2701)) || pixel_index == 2796 || pixel_index == 2799 || pixel_index == 2893 || ((pixel_index >= 2895) && (pixel_index <= 2896)) || pixel_index == 2971 || pixel_index == 2984 || pixel_index == 2988 || pixel_index == 3078 || pixel_index == 3080 || ((pixel_index >= 3085) && (pixel_index <= 3087)) || pixel_index == 3163 || pixel_index == 3176 || pixel_index == 3178 || ((pixel_index >= 3180) && (pixel_index <= 3183)) || pixel_index == 3270 || pixel_index == 3274 || pixel_index == 3276 || pixel_index == 3341 || pixel_index == 3366 || ((pixel_index >= 3371) && (pixel_index <= 3373)) || pixel_index == 3375 || ((pixel_index >= 3434) && (pixel_index <= 3440)) || pixel_index == 3449 || pixel_index == 3463 || ((pixel_index >= 3472) && (pixel_index <= 3473)) || ((pixel_index >= 3530) && (pixel_index <= 3537)) || ((pixel_index >= 3559) && (pixel_index <= 3560)) || ((pixel_index >= 3567) && (pixel_index <= 3569)) || ((pixel_index >= 3626) && (pixel_index <= 3633)) || pixel_index == 3641 || pixel_index == 3654 || pixel_index == 3665 || ((pixel_index >= 3722) && (pixel_index <= 3724)) || pixel_index == 3727 || ((pixel_index >= 3729) && (pixel_index <= 3730)) || pixel_index == 3750 || ((pixel_index >= 3818) && (pixel_index <= 3820)) || ((pixel_index >= 3825) && (pixel_index <= 3826)) || pixel_index == 3847 || pixel_index == 3914 || ((pixel_index >= 3916) && (pixel_index <= 3917)) || ((pixel_index >= 3921) && (pixel_index <= 3922)) || pixel_index == 4040 || (pixel_index >= 4047) && (pixel_index <= 4048)) oled_data = 16'b1010001010001010;
                else if (pixel_index == 2318 || pixel_index == 2508 || pixel_index == 2798 || pixel_index == 2875 || pixel_index == 2982 || pixel_index == 3084 || pixel_index == 3174 || pixel_index == 3179 || pixel_index == 3275 || pixel_index == 3353 || ((pixel_index >= 3466) && (pixel_index <= 3467)) || pixel_index == 3471 || pixel_index == 3563 || pixel_index == 3658 || pixel_index == 3754 || pixel_index == 3850 || pixel_index == 3857 || pixel_index == 3942 || ((pixel_index >= 3945) && (pixel_index <= 3947)) || pixel_index == 3949 || ((pixel_index >= 4041) && (pixel_index <= 4043)) || pixel_index == 4045 || ((pixel_index >= 4137) && (pixel_index <= 4138)) || ((pixel_index >= 4141) && (pixel_index <= 4142)) || ((pixel_index >= 4233) && (pixel_index <= 4234)) || ((pixel_index >= 4237) && (pixel_index <= 4238)) || ((pixel_index >= 4329) && (pixel_index <= 4330)) || pixel_index == 4333 || pixel_index == 4616) oled_data = 16'b0101001010000000;
                else if (pixel_index == 2411 || pixel_index == 2672 || pixel_index == 2768 || pixel_index == 2776 || ((pixel_index >= 2864) && (pixel_index <= 2865)) || ((pixel_index >= 2871) && (pixel_index <= 2872)) || pixel_index == 2961 || pixel_index == 2968 || pixel_index == 3042 || ((pixel_index >= 3050) && (pixel_index <= 3055)) || pixel_index == 3057 || pixel_index == 3064 || pixel_index == 3138 || ((pixel_index >= 3145) && (pixel_index <= 3146)) || ((pixel_index >= 3150) && (pixel_index <= 3153)) || pixel_index == 3160 || pixel_index == 3234 || pixel_index == 3241 || ((pixel_index >= 3249) && (pixel_index <= 3251)) || pixel_index == 3256 || pixel_index == 3351 || ((pixel_index >= 3442) && (pixel_index <= 3444)) || ((pixel_index >= 3446) && (pixel_index <= 3447)) || pixel_index == 3528 || ((pixel_index >= 3539) && (pixel_index <= 3542)) || pixel_index == 3624 || ((pixel_index >= 3635) && (pixel_index <= 3637)) || ((pixel_index >= 3731) && (pixel_index <= 3732)) || ((pixel_index >= 3828) && (pixel_index <= 3829)) || ((pixel_index >= 3924) && (pixel_index <= 3925)) || ((pixel_index >= 4020) && (pixel_index <= 4021)) || ((pixel_index >= 4116) && (pixel_index <= 4117)) || ((pixel_index >= 4211) && (pixel_index <= 4213)) || pixel_index == 4297 || ((pixel_index >= 4307) && (pixel_index <= 4309)) || ((pixel_index >= 4393) && (pixel_index <= 4394)) || ((pixel_index >= 4402) && (pixel_index <= 4405)) || ((pixel_index >= 4489) && (pixel_index <= 4492)) || ((pixel_index >= 4496) && (pixel_index <= 4500)) || pixel_index == 4586 || ((pixel_index >= 4588) && (pixel_index <= 4596)) || ((pixel_index >= 4682) && (pixel_index <= 4692)) || ((pixel_index >= 4778) && (pixel_index <= 4788)) || pixel_index == 4875 || pixel_index == 4883 || ((pixel_index >= 4970) && (pixel_index <= 4971)) || ((pixel_index >= 4979) && (pixel_index <= 4980)) || pixel_index == 5076) oled_data = 16'b1010000000000000;
                else if (pixel_index == 2472) oled_data = 16'b0101010100001010;
                else if (pixel_index == 2603 || ((pixel_index >= 2698) && (pixel_index <= 2699)) || ((pixel_index >= 2793) && (pixel_index <= 2795)) || pixel_index == 2797 || ((pixel_index >= 2887) && (pixel_index <= 2892)) || pixel_index == 2983 || ((pixel_index >= 2985) && (pixel_index <= 2987)) || ((pixel_index >= 2990) && (pixel_index <= 2992)) || pixel_index == 3079 || ((pixel_index >= 3081) && (pixel_index <= 3083)) || pixel_index == 3088 || pixel_index == 3175 || pixel_index == 3184 || pixel_index == 3271 || pixel_index == 3277 || ((pixel_index >= 3279) && (pixel_index <= 3280)) || pixel_index == 3367 || pixel_index == 3376 || pixel_index == 3462 || pixel_index == 3655 || pixel_index == 3664 || pixel_index == 3751 || pixel_index == 3760 || pixel_index == 3856 || pixel_index == 3943 || pixel_index == 3952 || pixel_index == 4039) oled_data = 16'b1111001010001010;
                else if (pixel_index == 2970 || pixel_index == 3067 || pixel_index == 3258 || pixel_index == 4017) oled_data = 16'b1010010100001010;
                else if (((pixel_index >= 3450) && (pixel_index <= 3451)) || pixel_index == 3545 || pixel_index == 3640 || pixel_index == 3736 || pixel_index == 3832 || pixel_index == 4311 || pixel_index == 4606 || pixel_index == 4799 || pixel_index == 4895) oled_data = 16'b1010000000001010;
                else if (pixel_index == 3452 || pixel_index == 3544 || pixel_index == 3546 || pixel_index == 3548 || pixel_index == 3645 || pixel_index == 3735 || pixel_index == 3737 || pixel_index == 3740 || pixel_index == 3831 || pixel_index == 3927 || pixel_index == 4023 || pixel_index == 4413 || (pixel_index >= 4702) && (pixel_index <= 4703)) oled_data = 16'b0101000000001010;
                else if (pixel_index == 3741 || pixel_index == 4215) oled_data = 16'b0101001010010100;
                else if (pixel_index == 3834 || ((pixel_index >= 3929) && (pixel_index <= 3932)) || ((pixel_index >= 4025) && (pixel_index <= 4028)) || ((pixel_index >= 4121) && (pixel_index <= 4124)) || ((pixel_index >= 4216) && (pixel_index <= 4220)) || ((pixel_index >= 4312) && (pixel_index <= 4316)) || ((pixel_index >= 4407) && (pixel_index <= 4412)) || ((pixel_index >= 4503) && (pixel_index <= 4508)) || ((pixel_index >= 4598) && (pixel_index <= 4604)) || ((pixel_index >= 4694) && (pixel_index <= 4700)) || ((pixel_index >= 4790) && (pixel_index <= 4796)) || ((pixel_index >= 4886) && (pixel_index <= 4892)) || ((pixel_index >= 4982) && (pixel_index <= 4983)) || pixel_index == 4986) oled_data = 16'b0000000000001010;
                else if (pixel_index == 3838 || pixel_index == 4031 || pixel_index == 4120) oled_data = 16'b0000001010001010;
                else if (pixel_index == 3928) oled_data = 16'b0101010100010100;
                else if (pixel_index == 3934) oled_data = 16'b0000001010010100;
                else if (((pixel_index >= 4011) && (pixel_index <= 4016)) || ((pixel_index >= 4107) && (pixel_index <= 4113)) || (pixel_index >= 4205) && (pixel_index <= 4208)) oled_data = 16'b1111010100010100;
                else oled_data = 0;
            
            end else  oled_data = 16'hFFFF;
        
            if (box_game == 0) 
            begin
                    if ((x >= 25 && x <= 66) && (y >= 29 && y <= 35)) oled_data = 16'hFFFF;
                    if (play) oled_data = 0;
            end else // box = 1
            begin
                    if ((x >= 25 && x <= 66) && (y >= 39 && y <= 45)) oled_data = 16'hFFFF;
                    if (exit) oled_data = 0;
            end
        end            
    end
    
    
endmodule
