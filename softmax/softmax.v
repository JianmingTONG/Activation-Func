`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// support maximal NUM = 2**9 = 512
//////////////////////////////////////////////////////////////////////////////////


module softmax#(parameter NUM = 18, LEN = 16)(
    input  clk,
    input  [NUM*LEN-1:0] in,
    output [NUM*LEN-1:0] softmax
    );
    
    localparam LEVEL =$clog2(NUM);
    genvar i;
    
    // find the maximal value of the input
    wire signed [LEN-1:0]  max;
    max#(.NUM(NUM),.LEN(LEN)) max0(
        .a(in),
        .max(max)
    );
    
    wire signed [LEN-1:0] in_inner[NUM-1:0];
    for(i=0;i<NUM;i=i+1)
    begin
       assign in_inner[i] = in[(i+1)*LEN-1:i*LEN] ;
    end
    // subtract each input by the max of input
    reg signed [LEN-1:0]    sub1[NUM-1:0]; 
    for (i=0;i<NUM;i=i+1)
    begin
        always@(*)
        begin
            sub1[i] = in_inner[i] - max;
        end
    end

    // calculate exponent of each sub1
    wire [LEN-1:0]             exp1[NUM-1:0];
    wire [NUM*LEN-1:0]         exp1_pack;
      
    // exp 16 bit = 2 bit 整数 14 bit小数 signed 2's complement
    generate
    for (i = 0;i < NUM ; i = i +1)
    begin
    exp_iteration_add_16bit_angle#(.LEN(LEN)) exp0(
        .angle(sub1[i]),
        .exp(exp1[i])
    );
    end
    endgenerate
    for(i=0;i<NUM;i=i+1)
    begin
       assign exp1_pack[(i+1)*LEN-1:i*LEN] = exp1[i];
    end
    
    // accmulate all input value.
    // sum: (LEVEL + 16) bit = (LEVEL + 2) bit 整数 14 bit小数 signed 2's complement
    wire [LEN+LEVEL-1:0]     sum;
    adder_tree_var_bit#(.NUM(NUM),.LEN(LEN)) addre_tree0(
        .in(exp1_pack),
        .sum(sum)
    );
    
    // calculate logrithm of the sum -> log
    // log: 19 bit = 5 bit 整数 + 14 bit小数 signed 2's complement
    wire [25:0]  ifc_sum_log = {{(26-LEN-LEVEL){1'b0}},sum};
    wire  signed [18:0] log; 
    lut_log_14in_19out log0(
        .in(ifc_sum_log[23:10]),
        .log(log)
    );
    
    
    // subtract each sub1 by log -> sub2 
    reg  signed [18:0]        sub2[NUM-1:0];
    
    for (i=0;i<NUM;i=i+1)
    begin
        always@(*)
        begin
            sub2[i] = sub1[i] - log;
        end
    end
    
    // calculate sigmoid of each in.
    // exp 19 bit input = 5 bit 整数 14 bit小数 signed 2's complement
    // output 16 bit = 2 bit integer + 14 bit fraction unsigned
    wire        [15:0]  softmax_inner[NUM-1:0];
    generate
    for (i = 0;i < NUM ; i = i +1)
    begin
    lut_exp_19in_16out exp1(
        .in(sub2[i]),
        .exp(softmax_inner[i])
    );
    end
    endgenerate

    for(i=0;i<NUM;i=i+1)
    begin
       assign softmax[(i+1)*16-1:i*16] = softmax_inner[i];
    end
    
endmodule

