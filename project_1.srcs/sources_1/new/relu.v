`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Jianmin(Jimmy) Tong (tjm1998@stu.xjtu.edu.cn)
// For 1 sign bit + N-1 data bit
//////////////////////////////////////////////////////////////////////////////////

// unsigned code should use the 2's complement
module relu_unsign(
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
parameter           WIDTH           = 8;

// inout data
input   wire                        iClk;
input   wire                        iRst;
input   wire        [WIDTH-1:0]     data;
input   wire                        enable;
output  wire                        rdy;
output  wire        [WIDTH-1:0]     dataOut;

// internal variable
        reg         [WIDTH-1:0]     dataInner;
        reg                         ready;

assign  rdy      =   ready;
assign  dataOut  =   dataInner;

always@(posedge iClk or negedge iRst)
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
module relu_sign(
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
parameter           WIDTH           = 8;

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

always@(posedge iClk or negedge iRst)
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


// hardtanh unsign = 2's complement
module hardtanh_sign(
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
parameter           WIDTH                   =   8;
parameter           THRESHOLD               =   7'b1100100; // should be the hard code of 0.01,using 1 bit to indicate 0.01
parameter           THRESHOLD_COMPLEMENT    =   ~THRESHOLD + 1'b1;
// inout data
input   wire                        iClk;
input   wire                        iRst;
input   wire        [WIDTH-1:0]     data;
input   wire                        enable;
output  wire                        rdy;
output  wire        [WIDTH-1:0]     dataOut;

// internal variable
        reg         [WIDTH-1:0]     dataInner;
        reg                         ready;
             
assign  rdy      =   ready;
assign  dataOut  =   dataInner;

always@(posedge iClk or negedge iRst)
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
            if (data[WIDTH-2:0]   >  THRESHOLD  &&  data[WIDTH-1]   ==  0)                  // y = 1 for x>threshold (default=1)
            begin
                dataInner   <=  {1'b0,THRESHOLD};
                ready       <=  1;
            end
            else 
            begin
                if(data[WIDTH-2:0]  <   THRESHOLD_COMPLEMENT    &&  data[WIDTH-1]   ==  1)  // y = -1 for x<-threshold (default=1)
                begin
                    dataInner   <=  {1'b1,THRESHOLD_COMPLEMENT};
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


//// signed
//module hardtanh_sign(
//    iClk,
//    iRst,
    
//    //data
//    data,
//    dataOut,    
    
//    //control,
//    enable,
//    rdy
//    );

//// parameter
//parameter           WIDTH                   =   8;
//parameter           THRESHOLD               =   7'b1100100; // the binary code of +1 under the given resolution.

//// inout data
//input   wire                                    iClk;
//input   wire                                    iRst;
//input   wire        signed      [WIDTH-1:0]     data;
//input   wire                                    enable;
//output  wire                                    rdy;
//output  wire        signed      [WIDTH-1:0]     dataOut;

//// internal variable
//        reg         signed      [WIDTH-1:0]     dataInner;
//        reg                                     ready;

//assign  rdy      =   ready;
//assign  dataOut  =   dataInner;

//always@(posedge iClk or negedge iRst)
//begin
//    if(enable)
//    begin
//        if(!iRst)
//        begin
//            dataInner   <=  0;
//            ready       <=  0;
//        end
//        else
//        begin
//            if (data[WIDTH-2:0]   >  THRESHOLD)                  // y = 1 for x>threshold (default=1)
//            begin
//                dataInner   <=  {data[WIDTH-1],THRESHOLD};
//                ready       <=  1;
//            end
//            else
//            begin
//                dataInner   <=  data;
//                ready       <=  1;
//            end
//        end
//    end
//    else
//    begin
//        begin
//            dataInner   <=  0;
//            ready       <=  0;
//        end
//    end
//end

//endmodule


// 2's complement
module leakyRelu_unsign(
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
parameter           WIDTH                   =   8;
parameter           NEGATIVE_SLOPE_SHIFT    =   5; // 1/64

// inout data
input   wire                        iClk;
input   wire                        iRst;
input   wire        [WIDTH-1:0]     data;
input   wire                        enable;
output  wire                        rdy;
output  wire        [WIDTH-1:0]     dataOut;

// internal variable
        reg         [WIDTH-1:0]     dataInner;
        reg                         ready;           
assign  rdy         =   ready;
assign  dataOut     =   dataInner;

always@(posedge iClk or negedge iRst)
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
                dataInner   <= {data[WIDTH-1], data[WIDTH-2:0] >> NEGATIVE_SLOPE_SHIFT}; //
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
module leakyRelu_sign(
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
parameter           WIDTH                   =   8;
parameter           NEGATIVE_SLOPE_SHIFT    =   5; // 1/64

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

always@(posedge iClk or negedge iRst)
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
                dataInner   <= {data[WIDTH-1], data[WIDTH-2:0] >> NEGATIVE_SLOPE_SHIFT}; //
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
module relu_sign(
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
parameter           WIDTH           =   8;

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

always@(posedge iClk or negedge iRst)
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



// unsigned code should use the 2's complement
module sigmoid_sign(
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
parameter                                           WIDTH           =   8;
parameter                                           ZEROPOINT       =   6;
parameter               [WIDTH-ZEROPOINT-2:0]       INTEGERZERO     =   0;        
parameter               [ZEROPOINT-1:0]             fractionZero    =   0;  
parameter     signed    [WIDTH-1:0]                 One             =   8'sb01000000;

      
// inout data
input   wire                                    iClk;
input   wire                                    iRst;
input   wire        signed      [WIDTH-1:0]     data;
input   wire                                    enable;
output  wire                                    rdy;
output  wire        signed      [WIDTH-1:0]     dataOut;

// internal variable

        reg                                             ready;
        wire        signed      [WIDTH-1:0]             dataIn                  =   (data[WIDTH-1]==1)?data:~data+1'b1;
        wire        signed      [WIDTH-1:0]             dataOriginalCode        =   ~dataIn + 1'b1;
        wire        signed      [WIDTH-1:0]             integerPart             =   {dataOriginalCode[WIDTH-1:ZEROPOINT], fractionZero}; 
        
        wire                    [WIDTH-2:0]             fractionPart            =   {INTEGERZERO,dataOriginalCode[ZEROPOINT-1:0]};
        wire                    [WIDTH-2:0]             fractionPartDiv4        =   fractionPart[WIDTH-2:0]>>2;
        wire                    [WIDTH-2:0]             fractionDiv4Temp        =   ~fractionPartDiv4   +   1'b1;
        wire        signed      [WIDTH-1:0]             fractionDiv4Complement  =   (fractionDiv4Temp==0)?0:{data[WIDTH-1],fractionDiv4Temp};
        
        reg         signed      [WIDTH-1:0]             constant            =   2'sb01 << (ZEROPOINT-1);
        
        wire        signed      [WIDTH-1:0]             denominator         =   constant + fractionDiv4Complement;
        reg         signed      [WIDTH-1:0]             dataInner;  

assign  rdy             =   ready;
assign  dataOut         =   dataInner;


always@(posedge iClk or negedge iRst)
begin
    if(enable)
    begin
        if(!iRst)
        begin
            dataInner   <=  0;
            ready    <=  0;
        end
        else
        if(data[WIDTH-1]==1)
        begin
            dataInner   <=  denominator  >>>  integerPart[WIDTH-1:ZEROPOINT];
            ready    <=  1;
        end
        else
        begin
            dataInner   <=  One - (denominator  >>>  integerPart[WIDTH-1:ZEROPOINT]);
            ready    <=  1;
        end 
    end
    else
    begin
        begin
            dataInner   <=  0;
            ready    <=  0;
        end
    end
end

endmodule