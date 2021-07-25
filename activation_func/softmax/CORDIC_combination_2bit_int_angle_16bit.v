`timescale 1ns / 1ps

// NOTE: 1. Input angle: signed  16 bit = 2 bit integer + 14 bit fraction; range (-2.0~1.99993896484375 rad)
//       2. Length of cosh & sinh should be 1 bit larger than INPUT angle due to a system gain of 1.20749706 (which is < 2),
//          but the length could still be the same as input angle if initial value has been multiplied by 1/1.20749706 = 0.8281593662845027  
// Parameter 
//       1. LEN is the input and output data
//       2. STG is the iteration times, i.e. STG = 14 means the result could be generated using 14 iterations.
//       3. sinh & cosh signed 16 bit = 2 bit integer + 14 bit fraction
// !!!ATTENTION!! 
//       this module is not parameterized, because LEN could only take 32


module CORDIC_combination_2bit_int_angle_16bit#(parameter LEN = 16)(
    input   signed    [LEN-1:0]  angle,
    output  signed    [LEN-1:0]  cosh,  // X_n in the theory
    output  signed    [LEN-1:0]  sinh   // Y_n in the theory
    );
    
    localparam STG = LEN-2;
    reg     signed        [LEN-1:0] Xin;
    reg     signed        [LEN-1:0] Yin;
    reg     signed        [LEN-1:0] angle_inner;
    
    initial begin
        Xin = 19784; // 2**14/0.82815936 
        Yin = 0;
    end
    always@*
    begin
        angle_inner = angle;
    end
    
//  ------------------------------------------------------------------------------
//    arctan table
//  ------------------------------------------------------------------------------   

// NOTE: The atan_table was chosen to be 31 bits wide giving resolution up to atan (2^-30)
wire  signed  [LEN-1:0]   atan_table [STG-1:0];

// sinh & cosh
assign atan_table[0] = 16'sb0010001100100111;
assign atan_table[1] = 16'sb0001000001011000;
assign atan_table[2] = 16'sb0000100000001010;
assign atan_table[3] = 16'sb0000010000000001;
assign atan_table[4] = 16'sb0000001000000000;
assign atan_table[5] = 16'sb0000000100000000;
assign atan_table[6] = 16'sb0000000010000000;
assign atan_table[7] = 16'sb0000000001000000;
assign atan_table[8] = 16'sb0000000000100000;
assign atan_table[9] = 16'sb0000000000010000;
assign atan_table[10] = 16'sb0000000000001000;
assign atan_table[11] = 16'sb0000000000000100;
assign atan_table[12] = 16'sb0000000000000010;
assign atan_table[13] = 16'sb0000000000000001;


//  ------------------------------------------------------------------------------
//    registers
//  ------------------------------------------------------------------------------   

// stage output
reg signed  [LEN-1:0]   X   [0:STG-1];
reg signed  [LEN-1:0]   Y   [0:STG-1];
reg signed  [LEN-1:0]   Z   [0:STG-1];

//  ------------------------------------------------------------------------------
//    stage 0
//  ------------------------------------------------------------------------------   

always @(*)
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
    wire                          Z_sign;
    wire signed   [LEN-1:0] X_shr, Y_shr;
    
    assign X_shr = X[i] >>> (i+1); // signed shift right
    assign Y_shr = Y[i] >>> (i+1);
    
    // the sign of the current rotation angle
    assign Z_sign = Z[i][LEN-1];  // Z_sign = 1 if Z[i] < 0
    
    always @(*)
    begin
        // add/substract shifted data
        X[i+1] = Z_sign ? X[i] - Y_shr         :  X[i] + Y_shr;
        Y[i+1] = Z_sign ? Y[i] - X_shr         :  Y[i] + X_shr;
        Z[i+1] = Z_sign ? Z[i] + atan_table[i] :  Z[i] - atan_table[i];
    end
end
endgenerate

//  ------------------------------------------------------------------------------
//    output
//  ------------------------------------------------------------------------------   
assign cosh = X[STG-1];
assign sinh = Y[STG-1];

endmodule
