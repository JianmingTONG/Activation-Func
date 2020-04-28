`timescale 1ns / 1ps
// This script has multiple CORDIC implement of sinh & cosh with different length of input(angle) & output(sinh&cosh).
// Under the same length of input(angle) & output(sinh&cosh), both combinational circuit and sequential circuit are offered, which are distinguished by the suffix "combination"/"sequential"
// Each iteration is a separate pipeline stage in the sequential implementation.


////////////////////////////////////////////////////////////////////////////////// CORDIC_Hyperbolic_combination
// NOTE: 1. Input angle is a modulo of 2*PI scaled to fit in a 32 bit register. 
//          real angle in rad = angle/2**32 * 2*pi
//          angle = real angle in rad *2**32 /2/pi
//          angle is a signed value in the range of -PI to +PI that must be represented as a 32 bit signed number
//       2. If input Xin is set as the binary code of "1", sinh & cosh will be the 0.8281593662845027 times of the real value
//          because the \sqrt(1+2**(-1))*\sqrt(1+2**(-2))*...*\sqrt(1+2**(-LEN)) \approx 1.20749706 (1/0.8281593662845027),  
//          In order to compensate this gain, input Xin is multiplied by 1.20749706.
//       3. The module will iterates&add 29 times, and all above operations are finished in a single cycle. no pipeline.
//       4. If change the initial value of Xin(To be more specific, change the decimal point of Xin), 
// Parameter 
//       1. LEN is length of input angle
//       2. ITER is total iterations, which will iterate only if atantable[iteration] > 0
//       3. output sinh & cosh: signed 32 bit = 3 bit int + 29 bit fraction, the decimal point of output is the same as Xin, 
//          Therefore, the decimal point of output could be reduced by right shift the decimal point of initial value of Xin (Line 37)
//          And the decimal point of the Xin must be smaller than <iteration times 29>, otherwise the result will be invalid.
//          PS: the number of iteration which are valid is the same as the decimal point of Xin.
//             e.g. if the decimal point of Xin is smaller than <iteration times 29>,  The number of valid iterations is equal to the decimal point
// !!!ATTENTION!! 
//       this module is not parameterized, because LEN could only take 32
module CORDIC_Hyperbolic_combination_32bit#(parameter LEN = 32)(
    input   signed    [LEN-1:0]  angle,
    output  signed    [LEN-1:0]  cosh,  // X_n in the theory
    output  signed    [LEN-1:0]  sinh   // Y_n in the theory
    );
    
    localparam ITER = LEN-3;
    reg     signed        [LEN-1:0] Xin;
    reg     signed        [LEN-1:0] Yin;
    reg     signed        [LEN-1:0] angle_inner;
    
    initial begin
        Xin = 648270053; // 2**29*1.20749706 decimal point = 29 -> decimal point of output is 29 (29-bit fraction)
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
wire  signed  [LEN-1:0]   atan_table [ITER:0];

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

//  ------------------------------------------------------------------------------
//    registers
//  ------------------------------------------------------------------------------   

// stage output
reg signed  [LEN-1:0]   X   [0:ITER-1];
reg signed  [LEN-1:0]   Y   [0:ITER-1];
reg signed  [LEN-1:0]   Z   [0:ITER-1];

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
//    generate stage 1 to ITER-1
//  ------------------------------------------------------------------------------   

genvar i;
generate
for ( i = 0; i < (ITER-1); i = i + 1)
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
assign cosh = X[ITER-1];
assign sinh = Y[ITER-1];

endmodule
















////////////////////////////////////////////////////////////////////////////////// CORDIC_Hyperbolic_sequential_32bit
// NOTE: 1. Input angle is a modulo of 2*PI scaled to fit in a 32 bit register. 
//          real angle in rad = angle/2**32 * 2*pi
//          angle = real angle in rad *2**32 /2/pi
//          angle is a signed value in the range of -PI to +PI that must be represented as a 32 bit signed number
//       2. If input Xin is set as the binary code of "1", sinh & cosh will be the 0.8281593662845027 times of the real value
//          because the \sqrt(1+2**(-1))*\sqrt(1+2**(-2))*...*\sqrt(1+2**(-LEN)) \approx 1.20749706 (1/0.8281593662845027),  
//          In order to compensate this gain, input Xin is multiplied by 1.20749706.
//       3. The module will iterates&add 29 times, and all above operations are finished in a consective 29 cycles. 29-stage pipeline.
//       4. If change the initial value of Xin(To be more specific, change the decimal point of Xin), 
// Parameter 
//       1. LEN is length of input angle
//       2. ITER is total iterations, which will iterate only if atantable[iteration] > 0
//       3. output sinh & cosh: signed 32 bit = 3 bit int + 29 bit fraction, the decimal point of output is the same as Xin, 
//          Therefore, the decimal point of output could be reduced by right shift the decimal point of initial value of Xin (Line 37)
//          And the decimal point of the Xin must be smaller than <iteration times 29>, otherwise the result will be invalid.
//          PS: the number of iteration which are valid is the same as the decimal point of Xin.
//             e.g. if the decimal point of Xin is smaller than <iteration times 29>,  The number of valid iterations is equal to the decimal point
// !!!ATTENTION!! 
//       this module is not parameterized, because LEN could only take 32

module CORDIC_Hyperbolic_sequential_32bit#(parameter XY_SZ = 32)(
    input                          clk,
    input   signed         [31:0]  angle,
    output  signed    [XY_SZ-1:0]  cosh,  // X_n in the theory
    output  signed    [XY_SZ-1:0]  sinh   // Y_n in the theory
    );
   
    localparam STG = XY_SZ-3;
    reg     signed        [XY_SZ-1:0] Xin;
    reg     signed        [XY_SZ-1:0] Yin;
    reg     signed        [XY_SZ-1:0] angle_inner;
    
    initial begin
        Xin = 648270053; // 2**29*1.20749706 decimal point = 29 -> decimal point of output is 29 (29-bit fraction)
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
wire  signed  [31:0]   atan_table [0:30];

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
reg signed  [XY_SZ-1:0]   X   [0:STG-1];
reg signed  [XY_SZ-1:0]   Y   [0:STG-1];
reg signed       [31:0]   Z   [0:STG-1];

//  ------------------------------------------------------------------------------
//    stage 0
//  ------------------------------------------------------------------------------   

always @(posedge clk)
begin    
    X[0] <= Xin;
    Y[0] <= Yin;
    Z[0] <= angle_inner;   
end

//  ------------------------------------------------------------------------------
//    generate stage 1 to STG-1
//  ------------------------------------------------------------------------------   
genvar i;

generate

for ( i = 0; i < (STG-1); i = i + 1)
begin: XYZ
    wire                      Z_sign;
    wire signed   [XY_SZ-1:0] X_shr, Y_shr;
    
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
assign cosh = X[STG-1];
assign sinh = Y[STG-1];

endmodule




////////////////////////////////////////////////////////////////////////////////// CORDIC_Hyperbolic_combination_16bit
// NOTE: 1. Input angle is a modulo of 2*PI scaled to fit in a 16 bit register. 
//          real angle in rad = angle/2**16 * 2*pi
//          angle = real angle in rad *2**16 /2/pi
//          angle is a signed value in the range of -PI ~ +PI that must be represented as a 32 bit signed number
//       2. If input Xin is set as the binary code of "1", sinh & cosh will be the 0.8281593662845027 times of the real value
//          because the \sqrt(1+2**(-1))*\sqrt(1+2**(-2))*...*\sqrt(1+2**(-LEN)) \approx 1.20749706 (1/0.8281593662845027),  
//          In order to compensate this gain, input Xin is multiplied by 1.20749706.
//       3. The module will iterates&add 13 times, and all above operations are finished in a single cycle. no pipeline.
//       4. If change the initial value of Xin(To be more specific, change the decimal point of Xin), 
// Parameter 
//       1. LEN is length of input angle
//       2. ITER is total iterations, which will iterate only if atantable[iteration] > 0
//       3. output sinh & cosh: signed 16 bit = 3 bit int + 13 bit fraction, the decimal point of output is the same as Xin, 
//          Therefore, the decimal point of output could be reduced by right shift the decimal point of initial value of Xin (Line 177)
//          And the decimal point of the Xin must be smaller than <iteration times 13>, otherwise the result will be invalid.
//          PS: the number of iteration which are valid is the same as the decimal point of Xin.
//             e.g. if the decimal point of Xin is smaller than <iteration times 13>,  The number of valid iterations is equal to the decimal point
// !!!ATTENTION!! 
//       this module is not parameterized, because LEN could only take 16

module CORDIC_Hyperbolic_combination_16bit#(parameter LEN = 16)(
    input   signed    [LEN-1:0]  angle,
    output  signed    [LEN-1:0]  cosh,  // X_n in the theory
    output  signed    [LEN-1:0]  sinh   // Y_n in the theory
    );
    
    localparam STG = LEN-3;
    reg     signed        [LEN-1:0] Xin;
    reg     signed        [LEN-1:0] Yin;
    reg     signed        [LEN-1:0] angle_inner;
    
    initial begin
        Xin = 9892; // 2**13/0.82815936 
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
assign atan_table[0] = 16'sb0001011001100001;
assign atan_table[1] = 16'sb0000101001101000;
assign atan_table[2] = 16'sb0000010100011110;
assign atan_table[3] = 16'sb0000001010001100;
assign atan_table[4] = 16'sb0000000101000110;
assign atan_table[5] = 16'sb0000000010100010;
assign atan_table[6] = 16'sb0000000001010001;
assign atan_table[7] = 16'sb0000000000101000;
assign atan_table[8] = 16'sb0000000000010100;
assign atan_table[9] = 16'sb0000000000001010;
assign atan_table[10] = 16'sb0000000000000101;
assign atan_table[11] = 16'sb0000000000000010;
assign atan_table[12] = 16'sb0000000000000001;


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










////////////////////////////////////////////////////////////////////////////////// CORDIC_Hyperbolic_combination_16bit
// NOTE: 1. Input angle: signed  16 bit = 2 bit integer + 14 bit fraction; range (-2.0~1.99993896484375 rad)
//       2. If input Xin is set as the binary code of "1", sinh & cosh will be the 0.8281593662845027 times of the real value
//          because the \sqrt(1+2**(-1))*\sqrt(1+2**(-2))*...*\sqrt(1+2**(-LEN)) \approx 1.20749706 (1/0.8281593662845027),  
//          In order to compensate this gain, input Xin is multiplied by 1.20749706.
//       3. The module will iterates&add 13 times, and all above operations are finished in a single cycle. no pipeline.
//       4. If change the initial value of Xin(To be more specific, change the decimal point of Xin), 
// Parameter 
//       1. LEN is length of input angle
//       2. STG is total iterations, which will iterate only if atantable[iteration] > 0, i.e. STG = 14 means the result could be generated using 14 iterations.
//       3. output sinh & cosh: signed 16 bit = 3 bit int + 13 bit fraction, the decimal point of output is the same as Xin, 
//          Therefore, the decimal point of output could be reduced by right shift the decimal point of initial value of Xin (Line 177)
//          And the decimal point of the Xin must be smaller than <iteration times 13>, otherwise the result will be invalid.
//          PS: the number of iteration which are valid is the same as the decimal point of Xin.
//             e.g. if the decimal point of Xin is smaller than <iteration times 13>,  The number of valid iterations is equal to the decimal point
//       4.  sinh & cosh signed 16 bit = 2 bit integer + 14 bit fraction
// !!!ATTENTION!! 
//       this module is not parameterized, because LEN could only take 16
module CORDIC_Hyperbolic_combination_16bit_2bit_int_angle#(parameter LEN = 16)(
    input   signed    [LEN-1:0]  angle,
    output  signed    [LEN-1:0]  cosh,  // X_n in the theory
    output  signed    [LEN-1:0]  sinh   // Y_n in the theory
    );
    
    localparam STG = LEN-2;
    reg     signed        [LEN-1:0] Xin;
    reg     signed        [LEN-1:0] Yin;
    reg     signed        [LEN-1:0] angle_inner;
    
    initial begin
        Xin = 19784; // 2**14 * 1.20749706
        Yin = 0;
    end
    always@*
    begin
        angle_inner = angle;
    end
    
//  ------------------------------------------------------------------------------
//    arctan table
//  ------------------------------------------------------------------------------   
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

