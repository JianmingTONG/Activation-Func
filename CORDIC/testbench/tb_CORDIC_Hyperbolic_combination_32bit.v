`timescale 1ns / 1ps

module tb_CORDIC_Hyperbolic_combination_32bit(

    );

localparam LEN = 32;
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
    angle = 32'h80000000;
        
    #10

   
    for(i = 0; i < NUM; i = i + 1)
    @(posedge clk)
    begin  
        angle = angle + 32'sb00000000_00000001_00000000_00000000; 
    end

    $write("Simulation has finished");
    $stop;
end

CORDIC_Hyperbolic_combination_32bit#(.LEN(LEN)) sinh_cosh(.angle(angle),.cosh(cosh), .sinh(sinh));

always #5 clk = ~clk;

endmodule

