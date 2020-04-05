`timescale 1ns / 1ps



module tb_relu(

    );
    
    reg clk;
    reg rst;
    reg enable;
    reg     signed      [7:0]   data;
    wire    signed      [7:0]   dataOut;
    wire ready;
    
    localparam WIDTH = 8;
    
    relu_sign#(.WIDTH(WIDTH))    tb_0(
    .iClk(clk),
    .iRst(rst),
    
    //data 
    .data(data),
    .dataOut(dataOut),    
    
    //control,
    .enable(enable),
    .rdy(ready)
    );
   
integer i;  
initial
begin
    clk =  0;
    rst =  0;
    #1  rst =   1;
    #1  rst =   0;
    #1  rst =   1;
    enable  =   1;
    data = -128;
end

localparam NUM = 8'b11111111;

always 
begin
    @(posedge clk)
    for(i = 0; i < NUM; i = i + 1)
    begin  
        data = data - 8'sb00000001; 
    end
end

always #5 clk=~clk;

endmodule

module tb_leakyRelu();
reg             clk;
reg             rst;
reg             enable;
reg   signed  [7:0]   data;
wire  signed  [7:0]   dataOut;
wire    rdy;

localparam NEGATIVE_SLOPE_SHIFT = 5 ;
localparam WIDTH = 8;
localparam NUM = 8'b11111111;

leakyRelu_sign#(.WIDTH(WIDTH), .NEGATIVE_SLOPE_SHIFT(NEGATIVE_SLOPE_SHIFT)) test1(
    .iClk(clk),
    .iRst(rst),
    
    //data
    .data(data),
    .dataOut(dataOut),    
    
    //control,
    .enable(enable),
    .rdy(rdy)
    );

integer i;  
initial
begin
    clk =  0;
    rst =  0;
    #1  rst =   1;
    #1  rst =   0;
    #1  rst =   1;
    enable  =   1;
    data = -128;
end

always 
begin
    @(posedge clk)
    for(i = 0; i < NUM; i = i + 1)
    begin  
        data = data - 8'sb00000001; 
    end
end

always # 5 clk = ~ clk;
    
endmodule

module tb_hardtanh(

    );
reg             clk;
reg             rst;
reg             enable;
reg     signed      [7:0]   data;
wire    signed      [7:0]   dataOut;
wire    rdy;

localparam DECIMAL_POINT = 4;
localparam WIDTH = 8;

hardtanh_sign#(.WIDTH(WIDTH),.DECIMAL_POINT(DECIMAL_POINT)) test1(
    .iClk(clk),
    .iRst(rst),
    
    //data
    .data(data),
    .dataOut(dataOut),    
    
    //control,
    .enable(enable),
    .rdy(rdy)
    );
    
integer i;  
initial
begin
    clk =  0;
    rst =  0;
    #1  rst =   1;
    #1  rst =   0;
    #1  rst =   1;
    enable  =   1;
    data = -128;
end

localparam NUM = 8'b11111111;
always 
begin
    @(posedge clk)
    for(i = 0; i < NUM; i = i + 1)
    begin  
        data = data - 8'sb00000001; 
    end
end

always #5 clk=~clk;
endmodule
 
    
module tb_sigmoid_sign(
    );
    
    reg clk;
    reg rst;
    reg enable;
    reg signed [7:0]   data;
    wire signed [7:0]   dataOut;
    wire ready;
    
    
    localparam WIDTH = 8;
    localparam DECIMAL_POINT = 4;
    
    sigmoid_sign#(.WIDTH(WIDTH),.DECIMAL_POINT(DECIMAL_POINT))    tb_0(
    .iClk(clk),
    .iRst(rst),
    
    //data 
    .data(data),
    .dataOut(dataOut),    
    
    //control,
    .enable(enable),
    .rdy(ready)
    );
    
    integer i;  
initial
begin
    clk =  0;
    rst =  0;
    #1  rst =   1;
    #1  rst =   0;
    #1  rst =   1;
    enable  =   1;
    data = -128;
end

localparam NUM = 8'b11111111;

always 
begin
    @(posedge clk)
    for(i = 0; i < NUM; i = i + 1)
    begin  
        data = data - 8'sb00000001; 
    end
end

always #5 clk=~clk;

endmodule
