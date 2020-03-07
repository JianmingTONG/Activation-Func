`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2020 08:37:15 PM
// Design Name: 
// Module Name: tb_leakyRelu
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


module tb_leakyRelu_sign();
reg             clk;
reg             rst;
reg             enable;
reg     [7:0]   data;
wire    [7:0]   dataOut;
wire    rdy;

 
leakyRelu_sign test1(
    .iClk(clk),
    .iRst(rst),
    
    //data
    .data(data),
    .dataOut(dataOut),    
    
    //control,
    .enable(enable),
    .rdy(rdy)
    );

    
initial
begin
    clk =  0;
    rst =  0;
    #1  rst =   1;
    #1  rst =   0;
    #1  rst =   1;
    enable  =   1;
#15 data=8'sb00000000;
#15 data=8'sb00000001;
#15 data=8'sb00000010;
#15 data=8'sb00000011;
#15 data=8'sb00000100;
#15 data=8'sb00000101;
#15 data=8'sb00000110;
#15 data=8'sb00000111;
#15 data=8'sb00001000;
#15 data=8'sb00001001;
#15 data=8'sb00001010;
#15 data=8'sb00001011;
#15 data=8'sb00001100;
#15 data=8'sb00001101;
#15 data=8'sb00001110;
#15 data=8'sb00001111;
#15 data=8'sb00010000;
#15 data=8'sb00010001;
#15 data=8'sb00010010;
#15 data=8'sb00010011;
#15 data=8'sb00010100;
#15 data=8'sb00010101;
#15 data=8'sb00010110;
#15 data=8'sb00010111;
#15 data=8'sb00011000;
#15 data=8'sb00011001;
#15 data=8'sb00011010;
#15 data=8'sb00011011;
#15 data=8'sb00011100;
#15 data=8'sb00011101;
#15 data=8'sb00011110;
#15 data=8'sb00011111;
#15 data=8'sb00100000;
#15 data=8'sb00100001;
#15 data=8'sb00100010;
#15 data=8'sb00100011;
#15 data=8'sb00100100;
#15 data=8'sb00100101;
#15 data=8'sb00100110;
#15 data=8'sb00100111;
#15 data=8'sb00101000;
#15 data=8'sb00101001;
#15 data=8'sb00101010;
#15 data=8'sb00101011;
#15 data=8'sb00101100;
#15 data=8'sb00101101;
#15 data=8'sb00101110;
#15 data=8'sb00101111;
#15 data=8'sb00110000;
#15 data=8'sb00110001;
#15 data=8'sb00110010;
#15 data=8'sb00110011;
#15 data=8'sb00110100;
#15 data=8'sb00110101;
#15 data=8'sb00110110;
#15 data=8'sb00110111;
#15 data=8'sb00111000;
#15 data=8'sb00111001;
#15 data=8'sb00111010;
#15 data=8'sb00111011;
#15 data=8'sb00111100;
#15 data=8'sb00111101;
#15 data=8'sb00111110;
#15 data=8'sb00111111;
#15 data=8'sb01000000;
#15 data=8'sb01000001;
#15 data=8'sb01000010;
#15 data=8'sb01000011;
#15 data=8'sb01000100;
#15 data=8'sb01000101;
#15 data=8'sb01000110;
#15 data=8'sb01000111;
#15 data=8'sb01001000;
#15 data=8'sb01001001;
#15 data=8'sb01001010;
#15 data=8'sb01001011;
#15 data=8'sb01001100;
#15 data=8'sb01001101;
#15 data=8'sb01001110;
#15 data=8'sb01001111;
#15 data=8'sb01010000;
#15 data=8'sb01010001;
#15 data=8'sb01010010;
#15 data=8'sb01010011;
#15 data=8'sb01010100;
#15 data=8'sb01010101;
#15 data=8'sb01010110;
#15 data=8'sb01010111;
#15 data=8'sb01011000;
#15 data=8'sb01011001;
#15 data=8'sb01011010;
#15 data=8'sb01011011;
#15 data=8'sb01011100;
#15 data=8'sb01011101;
#15 data=8'sb01011110;
#15 data=8'sb01011111;
#15 data=8'sb01100000;
#15 data=8'sb01100001;
#15 data=8'sb01100010;
#15 data=8'sb01100011;
#15 data=8'sb01100100;
#15 data=8'sb01100101;
#15 data=8'sb01100110;
#15 data=8'sb01100111;
#15 data=8'sb01101000;
#15 data=8'sb01101001;
#15 data=8'sb01101010;
#15 data=8'sb01101011;
#15 data=8'sb01101100;
#15 data=8'sb01101101;
#15 data=8'sb01101110;
#15 data=8'sb01101111;
#15 data=8'sb01110000;
#15 data=8'sb01110001;
#15 data=8'sb01110010;
#15 data=8'sb01110011;
#15 data=8'sb01110100;
#15 data=8'sb01110101;
#15 data=8'sb01110110;
#15 data=8'sb01110111;
#15 data=8'sb01111000;
#15 data=8'sb01111001;
#15 data=8'sb01111010;
#15 data=8'sb01111011;
#15 data=8'sb01111100;
#15 data=8'sb01111101;
#15 data=8'sb01111110;
#15 data=8'sb01111111;
#15 data=8'sb10000000;
#15 data=8'sb10000001;
#15 data=8'sb10000010;
#15 data=8'sb10000011;
#15 data=8'sb10000100;
#15 data=8'sb10000101;
#15 data=8'sb10000110;
#15 data=8'sb10000111;
#15 data=8'sb10001000;
#15 data=8'sb10001001;
#15 data=8'sb10001010;
#15 data=8'sb10001011;
#15 data=8'sb10001100;
#15 data=8'sb10001101;
#15 data=8'sb10001110;
#15 data=8'sb10001111;
#15 data=8'sb10010000;
#15 data=8'sb10010001;
#15 data=8'sb10010010;
#15 data=8'sb10010011;
#15 data=8'sb10010100;
#15 data=8'sb10010101;
#15 data=8'sb10010110;
#15 data=8'sb10010111;
#15 data=8'sb10011000;
#15 data=8'sb10011001;
#15 data=8'sb10011010;
#15 data=8'sb10011011;
#15 data=8'sb10011100;
#15 data=8'sb10011101;
#15 data=8'sb10011110;
#15 data=8'sb10011111;
#15 data=8'sb10100000;
#15 data=8'sb10100001;
#15 data=8'sb10100010;
#15 data=8'sb10100011;
#15 data=8'sb10100100;
#15 data=8'sb10100101;
#15 data=8'sb10100110;
#15 data=8'sb10100111;
#15 data=8'sb10101000;
#15 data=8'sb10101001;
#15 data=8'sb10101010;
#15 data=8'sb10101011;
#15 data=8'sb10101100;
#15 data=8'sb10101101;
#15 data=8'sb10101110;
#15 data=8'sb10101111;
#15 data=8'sb10110000;
#15 data=8'sb10110001;
#15 data=8'sb10110010;
#15 data=8'sb10110011;
#15 data=8'sb10110100;
#15 data=8'sb10110101;
#15 data=8'sb10110110;
#15 data=8'sb10110111;
#15 data=8'sb10111000;
#15 data=8'sb10111001;
#15 data=8'sb10111010;
#15 data=8'sb10111011;
#15 data=8'sb10111100;
#15 data=8'sb10111101;
#15 data=8'sb10111110;
#15 data=8'sb10111111;
#15 data=8'sb11000000;
#15 data=8'sb11000001;
#15 data=8'sb11000010;
#15 data=8'sb11000011;
#15 data=8'sb11000100;
#15 data=8'sb11000101;
#15 data=8'sb11000110;
#15 data=8'sb11000111;
#15 data=8'sb11001000;
#15 data=8'sb11001001;
#15 data=8'sb11001010;
#15 data=8'sb11001011;
#15 data=8'sb11001100;
#15 data=8'sb11001101;
#15 data=8'sb11001110;
#15 data=8'sb11001111;
#15 data=8'sb11010000;
#15 data=8'sb11010001;
#15 data=8'sb11010010;
#15 data=8'sb11010011;
#15 data=8'sb11010100;
#15 data=8'sb11010101;
#15 data=8'sb11010110;
#15 data=8'sb11010111;
#15 data=8'sb11011000;
#15 data=8'sb11011001;
#15 data=8'sb11011010;
#15 data=8'sb11011011;
#15 data=8'sb11011100;
#15 data=8'sb11011101;
#15 data=8'sb11011110;
#15 data=8'sb11011111;
#15 data=8'sb11100000;
#15 data=8'sb11100001;
#15 data=8'sb11100010;
#15 data=8'sb11100011;
#15 data=8'sb11100100;
#15 data=8'sb11100101;
#15 data=8'sb11100110;
#15 data=8'sb11100111;
#15 data=8'sb11101000;
#15 data=8'sb11101001;
#15 data=8'sb11101010;
#15 data=8'sb11101011;
#15 data=8'sb11101100;
#15 data=8'sb11101101;
#15 data=8'sb11101110;
#15 data=8'sb11101111;
#15 data=8'sb11110000;
#15 data=8'sb11110001;
#15 data=8'sb11110010;
#15 data=8'sb11110011;
#15 data=8'sb11110100;
#15 data=8'sb11110101;
#15 data=8'sb11110110;
#15 data=8'sb11110111;
#15 data=8'sb11111000;
#15 data=8'sb11111001;
#15 data=8'sb11111010;
#15 data=8'sb11111011;
#15 data=8'sb11111100;
#15 data=8'sb11111101;
#15 data=8'sb11111110;
#15 data=8'sb11111111;
end

always # 5 clk = ~ clk;
    
endmodule
