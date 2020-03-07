`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2020 08:02:06 AM
// Design Name: 
// Module Name: tb_hardtanh
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


module tb_hardtanh_unsign(

    );
reg             clk;
reg             rst;
reg             enable;
reg     [7:0]   data;
wire    [7:0]   dataOut;
wire    rdy;

 
hardtanh_unsign test1(
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
  #15 data=8'b00000000;
        #15 data=8'b00000001;
        #15 data=8'b00000010;
        #15 data=8'b00000011;
        #15 data=8'b00000100;
        #15 data=8'b00000101;
        #15 data=8'b00000110;
        #15 data=8'b00000111;
        #15 data=8'b00001000;
        #15 data=8'b00001001;
        #15 data=8'b00001010;
        #15 data=8'b00001011;
        #15 data=8'b00001100;
        #15 data=8'b00001101;
        #15 data=8'b00001110;
        #15 data=8'b00001111;
        #15 data=8'b00010000;
        #15 data=8'b00010001;
        #15 data=8'b00010010;
        #15 data=8'b00010011;
        #15 data=8'b00010100;
        #15 data=8'b00010101;
        #15 data=8'b00010110;
        #15 data=8'b00010111;
        #15 data=8'b00011000;
        #15 data=8'b00011001;
        #15 data=8'b00011010;
        #15 data=8'b00011011;
        #15 data=8'b00011100;
        #15 data=8'b00011101;
        #15 data=8'b00011110;
        #15 data=8'b00011111;
        #15 data=8'b00100000;
        #15 data=8'b00100001;
        #15 data=8'b00100010;
        #15 data=8'b00100011;
        #15 data=8'b00100100;
        #15 data=8'b00100101;
        #15 data=8'b00100110;
        #15 data=8'b00100111;
        #15 data=8'b00101000;
        #15 data=8'b00101001;
        #15 data=8'b00101010;
        #15 data=8'b00101011;
        #15 data=8'b00101100;
        #15 data=8'b00101101;
        #15 data=8'b00101110;
        #15 data=8'b00101111;
        #15 data=8'b00110000;
        #15 data=8'b00110001;
        #15 data=8'b00110010;
        #15 data=8'b00110011;
        #15 data=8'b00110100;
        #15 data=8'b00110101;
        #15 data=8'b00110110;
        #15 data=8'b00110111;
        #15 data=8'b00111000;
        #15 data=8'b00111001;
        #15 data=8'b00111010;
        #15 data=8'b00111011;
        #15 data=8'b00111100;
        #15 data=8'b00111101;
        #15 data=8'b00111110;
        #15 data=8'b00111111;
        #15 data=8'b01000000;
        #15 data=8'b01000001;
        #15 data=8'b01000010;
        #15 data=8'b01000011;
        #15 data=8'b01000100;
        #15 data=8'b01000101;
        #15 data=8'b01000110;
        #15 data=8'b01000111;
        #15 data=8'b01001000;
        #15 data=8'b01001001;
        #15 data=8'b01001010;
        #15 data=8'b01001011;
        #15 data=8'b01001100;
        #15 data=8'b01001101;
        #15 data=8'b01001110;
        #15 data=8'b01001111;
        #15 data=8'b01010000;
        #15 data=8'b01010001;
        #15 data=8'b01010010;
        #15 data=8'b01010011;
        #15 data=8'b01010100;
        #15 data=8'b01010101;
        #15 data=8'b01010110;
        #15 data=8'b01010111;
        #15 data=8'b01011000;
        #15 data=8'b01011001;
        #15 data=8'b01011010;
        #15 data=8'b01011011;
        #15 data=8'b01011100;
        #15 data=8'b01011101;
        #15 data=8'b01011110;
        #15 data=8'b01011111;
        #15 data=8'b01100000;
        #15 data=8'b01100001;
        #15 data=8'b01100010;
        #15 data=8'b01100011;
        #15 data=8'b01100100;
        #15 data=8'b01100101;
        #15 data=8'b01100110;
        #15 data=8'b01100111;
        #15 data=8'b01101000;
        #15 data=8'b01101001;
        #15 data=8'b01101010;
        #15 data=8'b01101011;
        #15 data=8'b01101100;
        #15 data=8'b01101101;
        #15 data=8'b01101110;
        #15 data=8'b01101111;
        #15 data=8'b01110000;
        #15 data=8'b01110001;
        #15 data=8'b01110010;
        #15 data=8'b01110011;
        #15 data=8'b01110100;
        #15 data=8'b01110101;
        #15 data=8'b01110110;
        #15 data=8'b01110111;
        #15 data=8'b01111000;
        #15 data=8'b01111001;
        #15 data=8'b01111010;
        #15 data=8'b01111011;
        #15 data=8'b01111100;
        #15 data=8'b01111101;
        #15 data=8'b01111110;
        #15 data=8'b01111111;
        #15 data=8'b10000000;
        #15 data=8'b10000001;
        #15 data=8'b10000010;
        #15 data=8'b10000011;
        #15 data=8'b10000100;
        #15 data=8'b10000101;
        #15 data=8'b10000110;
        #15 data=8'b10000111;
        #15 data=8'b10001000;
        #15 data=8'b10001001;
        #15 data=8'b10001010;
        #15 data=8'b10001011;
        #15 data=8'b10001100;
        #15 data=8'b10001101;
        #15 data=8'b10001110;
        #15 data=8'b10001111;
        #15 data=8'b10010000;
        #15 data=8'b10010001;
        #15 data=8'b10010010;
        #15 data=8'b10010011;
        #15 data=8'b10010100;
        #15 data=8'b10010101;
        #15 data=8'b10010110;
        #15 data=8'b10010111;
        #15 data=8'b10011000;
        #15 data=8'b10011001;
        #15 data=8'b10011010;
        #15 data=8'b10011011;
        #15 data=8'b10011100;
        #15 data=8'b10011101;
        #15 data=8'b10011110;
        #15 data=8'b10011111;
        #15 data=8'b10100000;
        #15 data=8'b10100001;
        #15 data=8'b10100010;
        #15 data=8'b10100011;
        #15 data=8'b10100100;
        #15 data=8'b10100101;
        #15 data=8'b10100110;
        #15 data=8'b10100111;
        #15 data=8'b10101000;
        #15 data=8'b10101001;
        #15 data=8'b10101010;
        #15 data=8'b10101011;
        #15 data=8'b10101100;
        #15 data=8'b10101101;
        #15 data=8'b10101110;
        #15 data=8'b10101111;
        #15 data=8'b10110000;
        #15 data=8'b10110001;
        #15 data=8'b10110010;
        #15 data=8'b10110011;
        #15 data=8'b10110100;
        #15 data=8'b10110101;
        #15 data=8'b10110110;
        #15 data=8'b10110111;
        #15 data=8'b10111000;
        #15 data=8'b10111001;
        #15 data=8'b10111010;
        #15 data=8'b10111011;
        #15 data=8'b10111100;
        #15 data=8'b10111101;
        #15 data=8'b10111110;
        #15 data=8'b10111111;
        #15 data=8'b11000000;
        #15 data=8'b11000001;
        #15 data=8'b11000010;
        #15 data=8'b11000011;
        #15 data=8'b11000100;
        #15 data=8'b11000101;
        #15 data=8'b11000110;
        #15 data=8'b11000111;
        #15 data=8'b11001000;
        #15 data=8'b11001001;
        #15 data=8'b11001010;
        #15 data=8'b11001011;
        #15 data=8'b11001100;
        #15 data=8'b11001101;
        #15 data=8'b11001110;
        #15 data=8'b11001111;
        #15 data=8'b11010000;
        #15 data=8'b11010001;
        #15 data=8'b11010010;
        #15 data=8'b11010011;
        #15 data=8'b11010100;
        #15 data=8'b11010101;
        #15 data=8'b11010110;
        #15 data=8'b11010111;
        #15 data=8'b11011000;
        #15 data=8'b11011001;
        #15 data=8'b11011010;
        #15 data=8'b11011011;
        #15 data=8'b11011100;
        #15 data=8'b11011101;
        #15 data=8'b11011110;
        #15 data=8'b11011111;
        #15 data=8'b11100000;
        #15 data=8'b11100001;
        #15 data=8'b11100010;
        #15 data=8'b11100011;
        #15 data=8'b11100100;
        #15 data=8'b11100101;
        #15 data=8'b11100110;
        #15 data=8'b11100111;
        #15 data=8'b11101000;
        #15 data=8'b11101001;
        #15 data=8'b11101010;
        #15 data=8'b11101011;
        #15 data=8'b11101100;
        #15 data=8'b11101101;
        #15 data=8'b11101110;
        #15 data=8'b11101111;
        #15 data=8'b11110000;
        #15 data=8'b11110001;
        #15 data=8'b11110010;
        #15 data=8'b11110011;
        #15 data=8'b11110100;
        #15 data=8'b11110101;
        #15 data=8'b11110110;
        #15 data=8'b11110111;
        #15 data=8'b11111000;
        #15 data=8'b11111001;
        #15 data=8'b11111010;
        #15 data=8'b11111011;
        #15 data=8'b11111100;
        #15 data=8'b11111101;
        #15 data=8'b11111110;
        #15 data=8'b11111111;
      
end

always # 5 clk = ~ clk;
    
endmodule