`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Jianmin(Jimmy) Tong (tjm1998@stu.xjtu.edu.cn)
// For 1 sign bit + N-1 data bit
//////////////////////////////////////////////////////////////////////////////////


// signed 
module relu_sign#(parameter WIDTH = 8)(
    iClk,
    iRst,
    
    //data
    data,
    dataOut,    
    
    //control,
    enable,
    rdy
    );


// inout data
input   wire                                    iClk;
input   wire                                    iRst;
input   wire        signed      [WIDTH-1:0]     data;
input   wire                                    enable;
output  wire                                    rdy;
output  wire        signed      [WIDTH-1:0]     dataOut;

// internal variable
        reg         signed      [WIDTH-1:0]     dataInner;
        reg                                     ready;

assign  rdy      =   ready;
assign  dataOut  =   dataInner;

always@*
begin
    if(enable)
    begin
        if(!iRst || data[WIDTH-1] == 1)
        begin
            dataInner   <=  0;
            ready       <=  0;
        end
        else
        begin
            dataInner   <=  data;
            ready       <=  1;
        end
    end
    else
    begin
        begin
            dataInner   <=  0;
            ready       <=  0;
        end
    end
end

endmodule




// signed
module leakyRelu_sign#(parameter WIDTH = 8, NEGATIVE_SLOPE_SHIFT = 5)(
    iClk,
    iRst,
    
    //data
    data,
    dataOut,    
    
    //control,
    enable,
    rdy
    );

//parameter           NEGATIVE_SLOPE_SHIFT    =   5; // 1/64

// inout data
input   wire                                    iClk;
input   wire                                    iRst;
input   wire        signed      [WIDTH-1:0]     data;
input   wire                                    enable;
output  wire                                    rdy;
output  wire        signed      [WIDTH-1:0]     dataOut;

// internal variable
        reg         signed      [WIDTH-1:0]     dataInner;
        reg                                     ready;      
assign  rdy         =   ready;
assign  dataOut     =   dataInner;

always@*
begin
    if(enable)
    begin
        if(!iRst)
        begin
            dataInner   <=  0;
            ready       <=  0;
        end
        else
        case(data[WIDTH-1])
            1'b0:   
            begin
                dataInner   <=  data;
                ready       <=  1;
            end 
            1'b1:
            begin
                dataInner   <= data >>> NEGATIVE_SLOPE_SHIFT; //
                ready       <=  1;
            end
            default:
            begin
                dataInner   <=  0;
                ready       <=  0;
            end
        endcase
    end
    else
    begin
        begin
            dataInner   <=  0;
            ready       <=  0;
        end
    end
end

endmodule


// signed
module hardtanh_sign#(parameter WIDTH = 8,DECIMAL_POINT = 4)(
    iClk,
    iRst,
    
    //data
    data,
    dataOut,    
    
    //control,
    enable,
    rdy
    );

// parameter
// if decimal point  = 0, value 4'sb0001 = 1
// if decimal point  = 1, value 4'sb0001 = 2

//parameter           WIDTH                   =   8;
localparam   signed  [7:0]     THRESHOLD      =   2'sb01 <<< DECIMAL_POINT;   // stands for 1
localparam   signed  [7:0]     NEGATHRESHOLD  =   2'sb11 <<< DECIMAL_POINT;   // stands for -1
// inout data
input   wire                                    iClk;
input   wire                                    iRst;
input   wire        signed      [WIDTH-1:0]     data;
input   wire                                    enable;
output  wire                                    rdy;
output  wire        signed      [WIDTH-1:0]     dataOut;

// internal variable
        reg         signed      [WIDTH-1:0]     dataInner;
        reg                                     ready;
        wire        above_1;
        wire        below_neg1;
        
assign  rdy      =   ready;
assign  dataOut  =   dataInner;

assign above_1   =   data > THRESHOLD     ? 1: 0;
assign below_neg1=   data < NEGATHRESHOLD ? 1: 0;

always@*
begin
    if(enable)
    begin
        if(!iRst)
        begin
            dataInner   <=  0;
            ready       <=  0;
        end
        else
        begin
            if (above_1)      
            begin
                dataInner   <=  THRESHOLD;
                ready       <=  1;
            end
            else
            begin
                if (below_neg1)
                begin
                    dataInner   <=  NEGATHRESHOLD;
                    ready       <=  1;
                end
                else
                begin
                    dataInner   <=  data;
                    ready       <=  1;
                end
            end
        end
    end
    else
    begin
        begin
            dataInner   <=  0;
            ready       <=  0;
        end
    end
end

endmodule




// unsigned code should use the 2's complement
module sigmoid_sign#(parameter WIDTH = 8, DECIMAL_POINT = 4)(
    iClk,
    iRst,
    
    //data
    data,
    dataOut,    
    
    //control,
    enable,
    rdy
    );

// parameter
localparam               [WIDTH-DECIMAL_POINT-2:0]   INTEGERZERO     =   0;        
localparam               [WIDTH-DECIMAL_POINT-2:0]   INTEGERONE      =   0;        
localparam               [DECIMAL_POINT-1:0]         FRACTIONZERO    =   0;  
localparam     signed    [WIDTH-1:0]                 One             =   2'sb01 <<< DECIMAL_POINT;

      
// inout data
input   wire                                    iClk;
input   wire                                    iRst;
input   wire        signed      [WIDTH-1:0]     data;
input   wire                                    enable;
output  wire                                    rdy;
output  wire        signed      [WIDTH-1:0]     dataOut;

// internal variable
        
        reg                                                ready;
        wire        signed      [WIDTH-1-DECIMAL_POINT:0]  integerPartIn           =   {data[WIDTH-1:DECIMAL_POINT]}; 
        wire        signed      [WIDTH-1-DECIMAL_POINT:0]  integerPartABS          =    data[WIDTH-1]==1?  ~integerPartIn + 1 : integerPartIn;
        
        wire        signed      [DECIMAL_POINT:0]          fractionPart            =   {data[WIDTH-1],data[DECIMAL_POINT-1:0]};
        wire        signed      [DECIMAL_POINT:0]          fractionPartABS         =   data[WIDTH-1]==1?  ~fractionPart + 1 : fractionPart;
        wire        signed      [DECIMAL_POINT:0]          fractionPartABSDiv4     =   fractionPartABS >>> 4;
        reg         signed      [WIDTH-1:0]                dataInner;  

assign  rdy             =   ready;
assign  dataOut         =   data[WIDTH-1]==1? dataInner:One-dataInner;


always@*
begin
    if(enable)
    begin
        if(!iRst)
        begin
            dataInner  <=  0;
            ready      <=  0;
        end
        else
        begin
            dataInner <=  (One>>>2 - fractionPartABSDiv4) >>>  integerPartABS;
            ready     <=  1;
        end 
    end
    else
    begin
        begin
            dataInner   <=  0;
            ready       <=  0;
        end
    end
end

endmodule

