`timescale 1ns / 1ps
// input angle 8 bit = 1 bit integer + 7 bit fractional                   7_6543210
// input exp   8 bit = 3 bit integer + 5 bit fractional                   765_43210
// internal multipler result 16 bit = 4 bit integer + 12 bit fractional   FEDC_BA9876543210
// exp         8 bit = 3 bit integer + 5 bit fractional                   765_43210
module lut_piecewise_exponential#(parameter XY_SZ = 8)(
    input                           clk,
    input   signed  [XY_SZ-1:0]     angle,
    output  signed  [XY_SZ-1:0]     exp
    );
    
    reg     signed  [XY_SZ-1:0]     angle_inner;
    reg     signed  [XY_SZ-1:0]     exp_inner;

    reg     signed  [XY_SZ-1:0]     bias_inner_table[0:7];
    reg     signed  [XY_SZ-1:0]     slope_inner_table[0:7];
    reg     signed  [XY_SZ-1:0]     demarcation_table[0:7];
    reg             [7:0]           cmp;
    reg     signed  [XY_SZ-1:0]     slope_inner;
    reg     signed  [XY_SZ-1:0]     bias_inner;
    
    initial
    begin
        bias_inner_table[0]  = 8'b00011011;
        bias_inner_table[1]  = 8'b00011111;
        bias_inner_table[2]  = 8'b00100000;
        bias_inner_table[3]  = 8'b00011110;
        bias_inner_table[4]  = 8'b00011010;
        bias_inner_table[5]  = 8'b00010101;
        bias_inner_table[6]  = 8'b00001111;
        bias_inner_table[7]  = 8'b00000111;
        slope_inner_table[0] = 8'b00001111;
        slope_inner_table[1] = 8'b00011001;
        slope_inner_table[2] = 8'b00100010;
        slope_inner_table[3] = 8'b00101011;
        slope_inner_table[4] = 8'b00110100;
        slope_inner_table[5] = 8'b00111101;
        slope_inner_table[6] = 8'b01000110;
        slope_inner_table[7] = 8'b01001111;
        demarcation_table[0] = 8'b10000000;
        demarcation_table[1] = 8'b11001001;
        demarcation_table[2] = 8'b11110111;
        demarcation_table[3] = 8'b00011000;
        demarcation_table[4] = 8'b00110011;
        demarcation_table[5] = 8'b01001001;
        demarcation_table[6] = 8'b01011100;
        demarcation_table[7] = 8'b01101100;

    end
    
    // angle process, store input angle in this module and output the angle to multiplier.
    always@(*)
    begin
        angle_inner = angle;
    end
    

    genvar i;
    generate
    for(i = 0; i < 8 ; i = i + 1)
    begin
        always@(*) 
        begin
            cmp[i] = (angle_inner > demarcation_table[i])? 1:0;
        end
    end
    endgenerate
    
    always@(*)
    begin
        casex(cmp)
            8'b1xxx_xxxx: 
            begin 
                slope_inner = slope_inner_table[7];
                bias_inner  = bias_inner_table[7];
            end
            8'b01xx_xxxx:
            begin 
                slope_inner = slope_inner_table[6];
                bias_inner  = bias_inner_table[6];
            end 
            8'b001x_xxxx:
            begin 
                slope_inner = slope_inner_table[5];
                bias_inner  = bias_inner_table[5];
            end
            8'b0001_xxxx:
            begin 
                slope_inner = slope_inner_table[4];
                bias_inner  = bias_inner_table[4];
            end
            8'b0000_1xxx:
            begin 
                slope_inner = slope_inner_table[3];
                bias_inner  = bias_inner_table[3];
            end
            8'b0000_01xx:
            begin 
                slope_inner = slope_inner_table[2];
                bias_inner  = bias_inner_table[2];
            end
            8'b0000_001x:
            begin 
                slope_inner = slope_inner_table[1];
                bias_inner  = bias_inner_table[1];
            end
            8'b0000_0001:
            begin 
                slope_inner = slope_inner_table[0];
                bias_inner  = bias_inner_table[0];
            end
            8'b0000_0000:
            begin 
                slope_inner = slope_inner_table[0];
                bias_inner  = bias_inner_table[0];
            end
            default:
            begin 
                slope_inner = slope_inner_table[0];
                bias_inner  = bias_inner_table[0];
            end 
        endcase
    end
    
    wire    signed    [XY_SZ-1:0]    rst_truncate;
    wire    signed  [2*XY_SZ-1:0]    rst;
    wire    signed    [XY_SZ-1:0]    angle_out = angle_inner;
    wire    signed    [XY_SZ-1:0]    slope_out = slope_inner;
    
    Mul mul0(.A_0(slope_out),.B_0(angle_out), .CLK_0(clk), .P_0(rst));
    
    assign  rst_truncate = rst[14:7];
    
    always@(*)
    begin
        exp_inner    = rst_truncate + bias_inner;
    end
    
    assign exp = exp_inner;
    
endmodule
