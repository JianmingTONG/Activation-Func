`timescale 1ns / 1ps

module CORDIC_Exponential_8bit#(parameter XY_SZ = 8)(
    input                        clk,
    input   signed       [31:0]  angle,
    input   signed  [XY_SZ-1:0]  Xin,
    input   signed  [XY_SZ-1:0]  Yin,
    output  signed  [XY_SZ+1:0]  exp
    );
    
    
    wire    signed    [XY_SZ:0]  Xout;   // X_n in the theory
    wire    signed    [XY_SZ:0]  Yout;   // Y_n in the theory
    reg     signed  [XY_SZ+1:0]  exp_inner;
    
CORDIC_Hyperbolic_8bit#(.XY_SZ(XY_SZ)) sinh_cosh(.clk(clk),.angle(angle), .Xin(Xin), .Yin(Yin), .Xout(Xout), .Yout(Yout));

always@(*)
begin
    exp_inner = Xout  + Yout;
end

assign exp = exp_inner;

endmodule
