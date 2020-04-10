`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2020 07:35:57 PM
// Design Name: 
// Module Name: lut_exponential
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


module lut_exponential#(parameter XY_SZ=8)(
    input   signed  [XY_SZ-1:0]  angle,
    output  signed  [XY_SZ-1:0]  exp
    );
    
    
reg  signed [7:0]  exp_table [0:255];
reg  signed [7:0]  exp_inner;
reg         [7:0]  index;

initial begin
exp_table[8'b10000000] = 8'b00001011;
exp_table[8'b10000001] = 8'b00001011;
exp_table[8'b10000010] = 8'b00001011;
exp_table[8'b10000011] = 8'b00001100;
exp_table[8'b10000100] = 8'b00001100;
exp_table[8'b10000101] = 8'b00001100;
exp_table[8'b10000110] = 8'b00001100;
exp_table[8'b10000111] = 8'b00001100;
exp_table[8'b10001000] = 8'b00001100;
exp_table[8'b10001001] = 8'b00001100;
exp_table[8'b10001010] = 8'b00001100;
exp_table[8'b10001011] = 8'b00001100;
exp_table[8'b10001100] = 8'b00001100;
exp_table[8'b10001101] = 8'b00001101;
exp_table[8'b10001110] = 8'b00001101;
exp_table[8'b10001111] = 8'b00001101;
exp_table[8'b10010000] = 8'b00001101;
exp_table[8'b10010001] = 8'b00001101;
exp_table[8'b10010010] = 8'b00001101;
exp_table[8'b10010011] = 8'b00001101;
exp_table[8'b10010100] = 8'b00001101;
exp_table[8'b10010101] = 8'b00001101;
exp_table[8'b10010110] = 8'b00001101;
exp_table[8'b10010111] = 8'b00001110;
exp_table[8'b10011000] = 8'b00001110;
exp_table[8'b10011001] = 8'b00001110;
exp_table[8'b10011010] = 8'b00001110;
exp_table[8'b10011011] = 8'b00001110;
exp_table[8'b10011100] = 8'b00001110;
exp_table[8'b10011101] = 8'b00001110;
exp_table[8'b10011110] = 8'b00001110;
exp_table[8'b10011111] = 8'b00001110;
exp_table[8'b10100000] = 8'b00001111;
exp_table[8'b10100001] = 8'b00001111;
exp_table[8'b10100010] = 8'b00001111;
exp_table[8'b10100011] = 8'b00001111;
exp_table[8'b10100100] = 8'b00001111;
exp_table[8'b10100101] = 8'b00001111;
exp_table[8'b10100110] = 8'b00001111;
exp_table[8'b10100111] = 8'b00001111;
exp_table[8'b10101000] = 8'b00010000;
exp_table[8'b10101001] = 8'b00010000;
exp_table[8'b10101010] = 8'b00010000;
exp_table[8'b10101011] = 8'b00010000;
exp_table[8'b10101100] = 8'b00010000;
exp_table[8'b10101101] = 8'b00010000;
exp_table[8'b10101110] = 8'b00010000;
exp_table[8'b10101111] = 8'b00010000;
exp_table[8'b10110000] = 8'b00010001;
exp_table[8'b10110001] = 8'b00010001;
exp_table[8'b10110010] = 8'b00010001;
exp_table[8'b10110011] = 8'b00010001;
exp_table[8'b10110100] = 8'b00010001;
exp_table[8'b10110101] = 8'b00010001;
exp_table[8'b10110110] = 8'b00010001;
exp_table[8'b10110111] = 8'b00010010;
exp_table[8'b10111000] = 8'b00010010;
exp_table[8'b10111001] = 8'b00010010;
exp_table[8'b10111010] = 8'b00010010;
exp_table[8'b10111011] = 8'b00010010;
exp_table[8'b10111100] = 8'b00010010;
exp_table[8'b10111101] = 8'b00010010;
exp_table[8'b10111110] = 8'b00010011;
exp_table[8'b10111111] = 8'b00010011;
exp_table[8'b11000000] = 8'b00010011;
exp_table[8'b11000001] = 8'b00010011;
exp_table[8'b11000010] = 8'b00010011;
exp_table[8'b11000011] = 8'b00010011;
exp_table[8'b11000100] = 8'b00010100;
exp_table[8'b11000101] = 8'b00010100;
exp_table[8'b11000110] = 8'b00010100;
exp_table[8'b11000111] = 8'b00010100;
exp_table[8'b11001000] = 8'b00010100;
exp_table[8'b11001001] = 8'b00010100;
exp_table[8'b11001010] = 8'b00010100;
exp_table[8'b11001011] = 8'b00010101;
exp_table[8'b11001100] = 8'b00010101;
exp_table[8'b11001101] = 8'b00010101;
exp_table[8'b11001110] = 8'b00010101;
exp_table[8'b11001111] = 8'b00010101;
exp_table[8'b11010000] = 8'b00010101;
exp_table[8'b11010001] = 8'b00010110;
exp_table[8'b11010010] = 8'b00010110;
exp_table[8'b11010011] = 8'b00010110;
exp_table[8'b11010100] = 8'b00010110;
exp_table[8'b11010101] = 8'b00010110;
exp_table[8'b11010110] = 8'b00010111;
exp_table[8'b11010111] = 8'b00010111;
exp_table[8'b11011000] = 8'b00010111;
exp_table[8'b11011001] = 8'b00010111;
exp_table[8'b11011010] = 8'b00010111;
exp_table[8'b11011011] = 8'b00010111;
exp_table[8'b11011100] = 8'b00011000;
exp_table[8'b11011101] = 8'b00011000;
exp_table[8'b11011110] = 8'b00011000;
exp_table[8'b11011111] = 8'b00011000;
exp_table[8'b11100000] = 8'b00011000;
exp_table[8'b11100001] = 8'b00011001;
exp_table[8'b11100010] = 8'b00011001;
exp_table[8'b11100011] = 8'b00011001;
exp_table[8'b11100100] = 8'b00011001;
exp_table[8'b11100101] = 8'b00011001;
exp_table[8'b11100110] = 8'b00011010;
exp_table[8'b11100111] = 8'b00011010;
exp_table[8'b11101000] = 8'b00011010;
exp_table[8'b11101001] = 8'b00011010;
exp_table[8'b11101010] = 8'b00011010;
exp_table[8'b11101011] = 8'b00011011;
exp_table[8'b11101100] = 8'b00011011;
exp_table[8'b11101101] = 8'b00011011;
exp_table[8'b11101110] = 8'b00011011;
exp_table[8'b11101111] = 8'b00011100;
exp_table[8'b11110000] = 8'b00011100;
exp_table[8'b11110001] = 8'b00011100;
exp_table[8'b11110010] = 8'b00011100;
exp_table[8'b11110011] = 8'b00011100;
exp_table[8'b11110100] = 8'b00011101;
exp_table[8'b11110101] = 8'b00011101;
exp_table[8'b11110110] = 8'b00011101;
exp_table[8'b11110111] = 8'b00011101;
exp_table[8'b11111000] = 8'b00011110;
exp_table[8'b11111001] = 8'b00011110;
exp_table[8'b11111010] = 8'b00011110;
exp_table[8'b11111011] = 8'b00011110;
exp_table[8'b11111100] = 8'b00011111;
exp_table[8'b11111101] = 8'b00011111;
exp_table[8'b11111110] = 8'b00011111;
exp_table[8'b11111111] = 8'b00011111;
exp_table[8'b00000000] = 8'b00100000;
exp_table[8'b00000001] = 8'b00100000;
exp_table[8'b00000010] = 8'b00100000;
exp_table[8'b00000011] = 8'b00100000;
exp_table[8'b00000100] = 8'b00100001;
exp_table[8'b00000101] = 8'b00100001;
exp_table[8'b00000110] = 8'b00100001;
exp_table[8'b00000111] = 8'b00100001;
exp_table[8'b00001000] = 8'b00100010;
exp_table[8'b00001001] = 8'b00100010;
exp_table[8'b00001010] = 8'b00100010;
exp_table[8'b00001011] = 8'b00100010;
exp_table[8'b00001100] = 8'b00100011;
exp_table[8'b00001101] = 8'b00100011;
exp_table[8'b00001110] = 8'b00100011;
exp_table[8'b00001111] = 8'b00100011;
exp_table[8'b00010000] = 8'b00100100;
exp_table[8'b00010001] = 8'b00100100;
exp_table[8'b00010010] = 8'b00100100;
exp_table[8'b00010011] = 8'b00100101;
exp_table[8'b00010100] = 8'b00100101;
exp_table[8'b00010101] = 8'b00100101;
exp_table[8'b00010110] = 8'b00100110;
exp_table[8'b00010111] = 8'b00100110;
exp_table[8'b00011000] = 8'b00100110;
exp_table[8'b00011001] = 8'b00100110;
exp_table[8'b00011010] = 8'b00100111;
exp_table[8'b00011011] = 8'b00100111;
exp_table[8'b00011100] = 8'b00100111;
exp_table[8'b00011101] = 8'b00101000;
exp_table[8'b00011110] = 8'b00101000;
exp_table[8'b00011111] = 8'b00101000;
exp_table[8'b00100000] = 8'b00101001;
exp_table[8'b00100001] = 8'b00101001;
exp_table[8'b00100010] = 8'b00101001;
exp_table[8'b00100011] = 8'b00101010;
exp_table[8'b00100100] = 8'b00101010;
exp_table[8'b00100101] = 8'b00101010;
exp_table[8'b00100110] = 8'b00101011;
exp_table[8'b00100111] = 8'b00101011;
exp_table[8'b00101000] = 8'b00101011;
exp_table[8'b00101001] = 8'b00101100;
exp_table[8'b00101010] = 8'b00101100;
exp_table[8'b00101011] = 8'b00101100;
exp_table[8'b00101100] = 8'b00101101;
exp_table[8'b00101101] = 8'b00101101;
exp_table[8'b00101110] = 8'b00101101;
exp_table[8'b00101111] = 8'b00101110;
exp_table[8'b00110000] = 8'b00101110;
exp_table[8'b00110001] = 8'b00101110;
exp_table[8'b00110010] = 8'b00101111;
exp_table[8'b00110011] = 8'b00101111;
exp_table[8'b00110100] = 8'b00110000;
exp_table[8'b00110101] = 8'b00110000;
exp_table[8'b00110110] = 8'b00110000;
exp_table[8'b00110111] = 8'b00110001;
exp_table[8'b00111000] = 8'b00110001;
exp_table[8'b00111001] = 8'b00110001;
exp_table[8'b00111010] = 8'b00110010;
exp_table[8'b00111011] = 8'b00110010;
exp_table[8'b00111100] = 8'b00110011;
exp_table[8'b00111101] = 8'b00110011;
exp_table[8'b00111110] = 8'b00110011;
exp_table[8'b00111111] = 8'b00110100;
exp_table[8'b01000000] = 8'b00110100;
exp_table[8'b01000001] = 8'b00110101;
exp_table[8'b01000010] = 8'b00110101;
exp_table[8'b01000011] = 8'b00110110;
exp_table[8'b01000100] = 8'b00110110;
exp_table[8'b01000101] = 8'b00110110;
exp_table[8'b01000110] = 8'b00110111;
exp_table[8'b01000111] = 8'b00110111;
exp_table[8'b01001000] = 8'b00111000;
exp_table[8'b01001001] = 8'b00111000;
exp_table[8'b01001010] = 8'b00111001;
exp_table[8'b01001011] = 8'b00111001;
exp_table[8'b01001100] = 8'b00111001;
exp_table[8'b01001101] = 8'b00111010;
exp_table[8'b01001110] = 8'b00111010;
exp_table[8'b01001111] = 8'b00111011;
exp_table[8'b01010000] = 8'b00111011;
exp_table[8'b01010001] = 8'b00111100;
exp_table[8'b01010010] = 8'b00111100;
exp_table[8'b01010011] = 8'b00111101;
exp_table[8'b01010100] = 8'b00111101;
exp_table[8'b01010101] = 8'b00111110;
exp_table[8'b01010110] = 8'b00111110;
exp_table[8'b01010111] = 8'b00111111;
exp_table[8'b01011000] = 8'b00111111;
exp_table[8'b01011001] = 8'b01000000;
exp_table[8'b01011010] = 8'b01000000;
exp_table[8'b01011011] = 8'b01000001;
exp_table[8'b01011100] = 8'b01000001;
exp_table[8'b01011101] = 8'b01000010;
exp_table[8'b01011110] = 8'b01000010;
exp_table[8'b01011111] = 8'b01000011;
exp_table[8'b01100000] = 8'b01000011;
exp_table[8'b01100001] = 8'b01000100;
exp_table[8'b01100010] = 8'b01000100;
exp_table[8'b01100011] = 8'b01000101;
exp_table[8'b01100100] = 8'b01000101;
exp_table[8'b01100101] = 8'b01000110;
exp_table[8'b01100110] = 8'b01000110;
exp_table[8'b01100111] = 8'b01000111;
exp_table[8'b01101000] = 8'b01001000;
exp_table[8'b01101001] = 8'b01001000;
exp_table[8'b01101010] = 8'b01001001;
exp_table[8'b01101011] = 8'b01001001;
exp_table[8'b01101100] = 8'b01001010;
exp_table[8'b01101101] = 8'b01001010;
exp_table[8'b01101110] = 8'b01001011;
exp_table[8'b01101111] = 8'b01001100;
exp_table[8'b01110000] = 8'b01001100;
exp_table[8'b01110001] = 8'b01001101;
exp_table[8'b01110010] = 8'b01001101;
exp_table[8'b01110011] = 8'b01001110;
exp_table[8'b01110100] = 8'b01001111;
exp_table[8'b01110101] = 8'b01001111;
exp_table[8'b01110110] = 8'b01010000;
exp_table[8'b01110111] = 8'b01010001;
exp_table[8'b01111000] = 8'b01010001;
exp_table[8'b01111001] = 8'b01010010;
exp_table[8'b01111010] = 8'b01010011;
exp_table[8'b01111011] = 8'b01010011;
exp_table[8'b01111100] = 8'b01010100;
exp_table[8'b01111101] = 8'b01010100;
exp_table[8'b01111110] = 8'b01010101;
exp_table[8'b01111111] = 8'b01010110;
end

always@(*)
begin
    index  = angle;
    exp_inner = exp_table[index];
end

assign exp = exp_inner;


endmodule
