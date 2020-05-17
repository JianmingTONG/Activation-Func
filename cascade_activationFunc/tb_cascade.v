`timescale 1ns / 1ps

module tb_cascade(

    );
    localparam NUM = 4;
    localparam DECIMAL_POINT = 14;
    localparam WIDTH = 16;
    reg clk;
    reg rst;
    reg [NUM*WIDTH-1:0] in_signal_pack;
    reg  [WIDTH-1:0]     in_signal[NUM-1:0];
    integer i,j;
    
    initial begin
        clk = 0;
        rst = 0;
        #10 rst = 1;
        for ( j = 0; j < WIDTH ; j = j + 1)
        begin
            #100
            for ( i = 0; i < NUM ; i = i + 1)
            begin
                in_signal[i] = i + 1<<j;
            end
            for ( i = 0; i < NUM; i = i + 1)
            begin
                in_signal_pack = {in_signal_pack, in_signal[i]};
            end
       end
    end
    
    always #10 clk = ~clk;

    cascade_activation#(.NUM(NUM), .WIDTH(WIDTH), .DECIMAL_POINT(DECIMAL_POINT))  test(
        .clk(clk),
        .rst(rst),
        .in_signal(in_signal_pack)
    );
   
    
endmodule
