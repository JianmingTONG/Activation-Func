`timescale 1ns / 1ps

module tb_exp_iteration_2bit_int_angle_16bit();

localparam LEN = 16;
wire   [LEN-1:0] exp;
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

exp_iteration_2bit_int_angle_16bit#(.LEN(LEN)) exp0(.angle(angle),.exp(exp));

always #5 clk = ~clk;

endmodule
