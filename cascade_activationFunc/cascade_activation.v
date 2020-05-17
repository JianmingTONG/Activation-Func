`timescale 1ns / 1ps

module cascade_activation#(parameter NUM = 4, WIDTH = 16, DECIMAL_POINT = 14)(
    input clk,
    input rst,
    input [NUM*WIDTH-1:0] in_signal
    );
    
    wire [WIDTH-1:0] input_signal[NUM-1:0];
    
    genvar i;
    for (i = 0; i < NUM; i= i+1)
    begin
        assign input_signal[i] = in_signal[(i+1)*WIDTH-1:0+i*WIDTH];
    end
    
    wire [WIDTH-1:0] output_signal_level1 [NUM-1:0];
    reg   [NUM-1:0]  en_level1;
    reg   [NUM-1:0]  en_level3;
    wire  [NUM-1:0]  rdy_level1;
    wire  [NUM-1:0]  rdy_level3;
    initial begin
        en_level1 ={NUM{1'b1}};
        en_level3 ={NUM{1'b1}};
    end
    
    
    relu_sign#(.WIDTH(WIDTH)) level1_relu(
        .iClk(clk),
        .iRst(rst),
        .data(input_signal[0]),
        .dataOut(output_signal_level1[0]),
        .enable(en_level1[0]),
        .rdy(rdy_level1[0])
    );
        
        
    hardtanh_sign#(.WIDTH(WIDTH),.DECIMAL_POINT(DECIMAL_POINT)) level1_hardtanh(
        .iClk(clk),
        .iRst(rst),
        .data(input_signal[1]),
        .dataOut(output_signal_level1[1]),
        .enable(en_level1[1]),
        .rdy(rdy_level1[1])
    );
       
    sigmoid_sign#(.WIDTH(WIDTH),.DECIMAL_POINT(DECIMAL_POINT)) level1_sigmoid(
        .iClk(clk),
        .iRst(rst),
        .data(input_signal[2]),
        .dataOut(output_signal_level1[2]),
        .enable(en_level1[2]),
        .rdy(rdy_level1[2])
    );
    

    
    leakyRelu_sign#(.WIDTH(WIDTH)) level1_leakyrelu(
        .iClk(clk),
        .iRst(rst),
        .data(input_signal[3]),
        .dataOut(output_signal_level1[3]),
        .enable(en_level1[3]),
        .rdy(rdy_level1[3])
    );
    
    wire [NUM*WIDTH-1:0] softmax_in_signal;
    wire [NUM*WIDTH-1:0] softmax_out_signal_pack;
    
    for (i = 0; i < NUM; i = i +1)
    begin
        assign softmax_in_signal[(i+1)*WIDTH-1:0+i*WIDTH] = output_signal_level1[i];
    end
    
    softmax#(.NUM(NUM) ,.LEN(WIDTH)) softmax_level2(
        .clk(clk),
        .in(softmax_in_signal),
        .softmax(softmax_out_signal_pack)
    );
    
    wire [WIDTH-1:0] softmax_out_signal[NUM-1:0];

    for (i = 0; i < NUM; i= i+1)
    begin
        assign softmax_out_signal[i] = softmax_out_signal_pack[(i+1)*WIDTH-1:0+i*WIDTH];
    end
    
    
    wire [WIDTH-1:0] output_signal_level3[NUM-1:0];
    
    sigmoid_sign#(.WIDTH(WIDTH),.DECIMAL_POINT(DECIMAL_POINT)) level3_sigmoid(
        .iClk(clk),
        .iRst(rst),
        .data(softmax_out_signal[3]),
        .dataOut(output_signal_level3[3]),
        .enable(en_level3[3]),
        .rdy(rdy_level3[3])
    );
     
    hardtanh_sign#(.WIDTH(WIDTH),.DECIMAL_POINT(DECIMAL_POINT)) level3_hardtanh(
        .iClk(clk),
        .iRst(rst),
        .data(softmax_out_signal[2]),
        .dataOut(output_signal_level3[2]),
        .enable(en_level3[2]),
        .rdy(rdy_level3[2])
    );
       

    leakyRelu_sign#(.WIDTH(WIDTH)) level3_leakyrelu(
        .iClk(clk),
        .iRst(rst),
        .data(softmax_out_signal[1]),
        .dataOut(output_signal_level3[1]),
        .enable(en_level3[1]),
        .rdy(rdy_level3[1])
    );
    
    
    relu_sign#(.WIDTH(WIDTH)) level3_relu(
        .iClk(clk),
        .iRst(rst),
        .data(softmax_out_signal[0]),
        .dataOut(output_signal_level3[0]),
        .enable(en_level3[0]),
        .rdy(rdy_level3[0])
    );
    
endmodule
