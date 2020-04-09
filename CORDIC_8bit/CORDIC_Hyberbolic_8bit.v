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
module CORDIC_Hyperbolic_8bit#(parameter XY_SZ = 8)(
    input                        clk,
    input   signed  [XY_SZ-1:0]  angle,
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
wire  signed  [XY_SZ-1:0]   atan_table [0:7];
// upper 2 bits = 2'b00 which represents 0      ~ PI/2   range
// upper 2 bits = 2'b01 which represents PI/2   ~ PI     range
// upper 2 bits = 2'b10 which represents PI     ~ 3*PI/2 range (i.e. -PI/2 to -PI  )
// upper 2 bits = 2'b11 which represents 3*PI/2 ~ 2*PI   range (i.e. 0     to -PI/2)
// The upper 2 bits therefore tell us which quadrant we are in

// sinh & cosh
assign atan_table[0] = 8'b00010110;
assign atan_table[1] = 8'b00001010;
assign atan_table[2] = 8'b00000101;
assign atan_table[3] = 8'b00000010;
assign atan_table[4] = 8'b00000001;
assign atan_table[5] = 8'b00000000;
assign atan_table[6] = 8'b00000000;


//  ------------------------------------------------------------------------------
//    registers
//  ------------------------------------------------------------------------------   

// stage output
reg signed   [XY_SZ:0]   X   [0:STG-1];
reg signed   [XY_SZ:0]   Y   [0:STG-1];
reg signed   [XY_SZ:0]   Z   [0:STG-1];

//  ------------------------------------------------------------------------------
//    stage 0
//  ------------------------------------------------------------------------------   

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
    assign Z_sign = Z[i][XY_SZ];  // Z_sign = 1 if Z[i] < 0
    
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
