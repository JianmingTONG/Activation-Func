`timescale 1ns / 1ps

module tb_cordic_exponential_8bit();


localparam SZ = 8;
reg  [SZ-1:0] Xin, Yin;
reg  [SZ-1:0] angle;
wire [SZ+1:0] exp;
reg           clk;

//  ------------------------------------------------------------------------------
//      Waveform generator
//  ------------------------------------------------------------------------------   
localparam FALSE = 1'b0;
localparam TRUE  = 1'b1; 
localparam VALUE = 64/0.82815936;  // reduce by a factor of 1.647 since thats the gain of the system

reg signed [63:0]  i;
reg                start;

initial
begin
    start = FALSE;
    $write("Starting sim");
    clk = 1'b0;
    angle = 0;
    Xin   = VALUE;             // Xout = 32000*cos(angle)
    Yin   = 1'd0;              // Yout = 32000*sin(angle)
    
    #10
    @(posedge clk);
    start = TRUE;
    
    // sin/cos output
    for ( i = -180; i< 180; i = i + 1)   // from 0 to 359 degress in 1 degree increment
    // for ( i = 30; i < 360; i=i+1)  // increment by 30 degrees only
    begin
        @(posedge clk);
        start = FALSE;
        angle = ((1 << SZ) * i)/360 ;  // example: 45 deg = 45 / 360 * 2^32 = 32'b00100000000000000000000000000000 = 45.000 degrees -> atan(2^0)
        $display( "angle = %d, %h", i, angle);
    end

    #500
    $write("Simulation has finished");
    $stop;
end

CORDIC_Exponential_8bit dut0(.clk(clk),.angle(angle), .Xin(Xin), .Yin(Yin), .exp(exp));

always #5 clk = ~clk;
endmodule
