`timescale 1ns / 1ps

module tb_lut_log_14in_19out();

reg         [13:0] in;
wire signed [18:0] log;
reg                clk;

//  ------------------------------------------------------------------------------
//      Waveform generator
//  ------------------------------------------------------------------------------   

integer i;  
initial
begin
    clk =  0;
    in = -32768;
end

localparam NUM = 14'b111111_11111111;
always 
begin
    @(posedge clk)
    for(i = 0; i < NUM; i = i + 1)
    begin  
        in = in - 14'sb000000_00000001; 
    end
end

always #5 clk=~clk;

lut_log_14in_19out dut0(.in(in), .log(log));

endmodule
