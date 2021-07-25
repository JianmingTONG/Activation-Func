`timescale 1ns / 1ps


module tb_softmax();
    
localparam NUM = 18, LEN = 16;
wire[NUM*LEN-1:0] softmax;


reg clk;
reg [LEN-1:0] a_inner[NUM-1:0]; 
reg [NUM*LEN-1:0] a;

integer i;
initial begin
    clk = 0;
    a = 0;
    for (i=0; i<NUM; i=i+1) 
    begin
        a_inner[i] = i<<3;
    end
    
    for (i = 0; i < NUM; i = i + 1) begin
        a = {a,a_inner[NUM-1-i]}; 
    end
end

always #5 clk=~clk;
    
softmax dut(
.clk(clk),
.in(a),
.softmax(softmax)
);

 
endmodule
