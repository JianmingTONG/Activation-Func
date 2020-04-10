`timescale 1ns / 1ps

module tb_lut_exponential();

localparam SZ = 8;
reg  [SZ-1:0] angle;
wire [SZ-1:0] exp;
reg           clk;

//  ------------------------------------------------------------------------------
//      Waveform generator
//  ------------------------------------------------------------------------------   

reg signed [63:0]  i;

initial
begin
    $write("Starting sim");
    clk = 1'b0;
    angle = 0;
    
    #10
    @(posedge clk);  
    // sin/cos output
    for ( i = -180; i< 180; i = i + 1)   // from 0 to 359 degress in 1 degree increment
    // for ( i = 30; i < 360; i=i+1)  // increment by 30 degrees only
    begin
        @(posedge clk);
        angle = ((1 << SZ) * i)/360 ;  // example: 45 deg = 45 / 360 * 2^32 = 32'b00100000000000000000000000000000 = 45.000 degrees -> atan(2^0)
        $display( "angle = %d, %h", i, angle);
    end

    #500
    $write("Simulation has finished");
    $stop;
end

lut_exponential dut0(.angle(angle), .exp(exp));

always #5 clk = ~clk;
endmodule
