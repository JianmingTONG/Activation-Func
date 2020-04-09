`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// copy from video https://www.youtube.com/watch?v=TJe4RUYiOIg
//////////////////////////////////////////////////////////////////////////////////
// NOTE: 1. Input angle is a modulo of 2*PI scaled to fit in a 32 bit register. 
//          The user must translate this angle to a value from 0 ~ (2^32-1). 0 deg = 32'h0, 
//          359.99999 = 32'hFF_FF_FF_FF
//          To translate from degrees to a 32 bit value, multiply 2^32 by the angle (in degrees), then divide by 360
//       2. Size of Xout, Yout is 1 bit larger due to a system gain of 1.647 (which is < 2)
// Parameter 
//       1. XY_SZ is the input and output data
//       2. STG is the same as bit width of X and Y
//       3. angle is a signed value in the range of -PI to +PI that must be represented as a 32 bit signed number

// !!!ATTENTION!! 
//    not support angle = pi or angle = 3/2 * pi
module CORDIC_Hyperbolic#(parameter XY_SZ = 16)(
    input                        clk,
    input   signed       [31:0]  angle,
    input   signed  [XY_SZ-1:0]  Xin,
    input   signed  [XY_SZ-1:0]  Yin,
    output  signed    [XY_SZ:0]  Xout,  // X_n in the theory
    output  signed    [XY_SZ:0]  Yout   // Y_n in the theory
    );
    
    localparam STG = XY_SZ;
    
//  ------------------------------------------------------------------------------
//    arctan table
//  ------------------------------------------------------------------------------   

// NOTE: The atan_table was chosen to be 31 bits wide giving resolution up to atan (2^-30)
wire  signed  [31:0]   atan_table [0:30];
// upper 2 bits = 2'b00 which represents 0      ~ PI/2   range
// upper 2 bits = 2'b01 which represents PI/2   ~ PI     range
// upper 2 bits = 2'b10 which represents PI     ~ 3*PI/2 range (i.e. -PI/2 to -PI  )
// upper 2 bits = 2'b11 which represents 3*PI/2 ~ 2*PI   range (i.e. 0     to -PI/2)
// The upper 2 bits therefore tell us which quadrant we are in

// sinh & cosh
assign atan_table[0] = 32'b00010110011000010111100010001101;
assign atan_table[1] = 32'b00001010011010000000110101100001;
assign atan_table[2] = 32'b00000101000111101010011011111100;
assign atan_table[3] = 32'b00000010100011001011111111011101;
assign atan_table[4] = 32'b00000001010001100000111000110100;
assign atan_table[5] = 32'b00000000101000101111110011101000;
assign atan_table[6] = 32'b00000000010100010111110100101110;
assign atan_table[7] = 32'b00000000001010001011111001101110;
assign atan_table[8] = 32'b00000000000101000101111100110010;
assign atan_table[9] = 32'b00000000000010100010111110011000;
assign atan_table[10] = 32'b00000000000001010001011111001100;
assign atan_table[11] = 32'b00000000000000101000101111100110;
assign atan_table[12] = 32'b00000000000000010100010111110011;
assign atan_table[13] = 32'b00000000000000001010001011111001;
assign atan_table[14] = 32'b00000000000000000101000101111100;
assign atan_table[15] = 32'b00000000000000000010100010111110;
assign atan_table[16] = 32'b00000000000000000001010001011111;
assign atan_table[17] = 32'b00000000000000000000101000101111;
assign atan_table[18] = 32'b00000000000000000000010100010111;
assign atan_table[19] = 32'b00000000000000000000001010001011;
assign atan_table[20] = 32'b00000000000000000000000101000101;
assign atan_table[21] = 32'b00000000000000000000000010100010;
assign atan_table[22] = 32'b00000000000000000000000001010001;
assign atan_table[23] = 32'b00000000000000000000000000101000;
assign atan_table[24] = 32'b00000000000000000000000000010100;
assign atan_table[25] = 32'b00000000000000000000000000001010;
assign atan_table[26] = 32'b00000000000000000000000000000101;
assign atan_table[27] = 32'b00000000000000000000000000000010;
assign atan_table[28] = 32'b00000000000000000000000000000001;
assign atan_table[29] = 32'b00000000000000000000000000000000;
assign atan_table[30] = 32'b00000000000000000000000000000000;


//  ------------------------------------------------------------------------------
//    registers
//  ------------------------------------------------------------------------------   

// stage output
reg signed  [XY_SZ:0]   X   [0:STG-1];
reg signed  [XY_SZ:0]   Y   [0:STG-1];
reg signed     [31:0]   Z   [0:STG-1];

//  ------------------------------------------------------------------------------
//    stage 0
//  ------------------------------------------------------------------------------   
wire            [1:0]   quadrant;
assign  quadrant = angle[31:30];

always @(posedge clk)
begin    
    X[0] <= Xin;
    Y[0] <= Yin;
    Z[0] <= angle;   
end

//  ------------------------------------------------------------------------------
//    generate stage 1 to STG-1
//  ------------------------------------------------------------------------------   
genvar i;

generate

for ( i = 0; i < (STG-1); i = i + 1)
begin: XYZ
    wire                    Z_sign;
    wire signed   [XY_SZ:0] X_shr, Y_shr;
    
    assign X_shr = X[i] >>> (i+1); // signed shift right
    assign Y_shr = Y[i] >>> (i+1);
    
    // the sign of the current rotation angle
    assign Z_sign = Z[i][31];  // Z_sign = 1 if Z[i] < 0
    
    always @(posedge clk)
    begin
        // add/substract shifted data
        X[i+1] <= Z_sign ? X[i] - Y_shr         :  X[i] + Y_shr;
        Y[i+1] <= Z_sign ? Y[i] - X_shr         :  Y[i] + X_shr;
        Z[i+1] <= Z_sign ? Z[i] + atan_table[i] :  Z[i] - atan_table[i];
    end
end
endgenerate

//  ------------------------------------------------------------------------------
//    output
//  ------------------------------------------------------------------------------   
assign Xout = X[STG-1];
assign Yout = Y[STG-1];

endmodule
