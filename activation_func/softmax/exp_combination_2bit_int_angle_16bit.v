`timescale 1ns / 1ps



module exp_iteration_2bit_int_angle_16bit#(parameter LEN = 16)(
    input   signed    [LEN-1:0]  angle,
    output            [LEN-1:0]  exp  // X_n in the theory
    );
    
    
    reg    signed [LEN:0]   exp_inner;
    wire   signed [LEN-1:0] sinh;
    wire   signed [LEN-1:0] cosh;
    
    CORDIC_combination_2bit_int_angle_16bit#(.LEN(LEN)) sinh_cosh(
        .angle(angle),
        .sinh(sinh),
        .cosh(cosh)
    );
    
    always@*
    begin
        exp_inner= sinh + cosh;
    end
    
    assign exp = exp_inner[LEN-1:0];
    
endmodule
