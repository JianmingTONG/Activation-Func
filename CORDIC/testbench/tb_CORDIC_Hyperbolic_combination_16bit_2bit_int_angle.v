`timescale 1ns / 1ps

module tb_CORDIC_combination_16bit_2bit_int_angle(

    );

localparam LEN = 16;
wire   [LEN-1:0] cosh, sinh;
reg              clk;

//  ------------------------------------------------------------------------------
//      Waveform generator
//  ------------------------------------------------------------------------------   
reg     signed      [LEN-1:0]   angle;

reg signed [63:0]  i;

localparam NUM = 16'hFFFF;

initial
begin
    clk =  0;
    angle = -32768;
        
    #10

   
    for(i = 0; i < NUM; i = i + 1)
    @(posedge clk)
    begin  
        angle = angle + 16'sb00000000_00000001; 
    end

    $write("Simulation has finished");
    $stop;
end

CORDIC_Hyperbolic_combination_16bit_2bit_int_angle#(.LEN(LEN)) sinh_cosh(.angle(angle),.cosh(cosh), .sinh(sinh));

always #5 clk = ~clk;

endmodule

