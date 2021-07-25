`timescale 1ns / 1ps
/*
    Top Module:  sigmoid_seq
    Data:        Only data width matters -- 2's complement data representation
    Format:      keeping the input format unchange
    Timing:      Sequential Logic
    Reset:       Asynchronized Reset [Low Reset]
    Latency:     1 cycle
    Dummy Data:  {DATA_WIDTH{1'b0}}

    Function:   
                        
                                      ^ o_data_bus [DATA_WIDTH-1:0]
                                      |                                     
                                      |                           /
                                      |                  /
                                      |            /
                                      |        /
                                      |     /
                                      |   /
                                      | /
     _________________________________|/______________________________ > i_data_bus [DATA_WIDTH-1:0]
                                     /| 0                        
                                    / |                        
                                  /   |                      
                               /      |                   
                           /          |               
                    /                 |        
            /                         |


    Author:      Jianming Tong (jianming.tong@gatech.edu)
*/

module sigmoid_seq#(
    parameter DATA_WIDTH = 16,  // indicate the length of input data, in 2's complement
    parameter DECIMAL_POINT = 5 // indicate the location of decimal point, starting at 0 (LSB) 
)(
    // timeing signals
    clk,
    rst_n,

    // data signals
    i_valid,        // valid input data signal
    i_data_bus,     // input data bus coming into adder

    o_valid,        // output valid
    o_data_bus,     // output data

    // control signals
    i_en            // adder enable
);
    // parameter 
    localparam                                       INTEGER_LENGTH = DATA_WIDTH-DECIMAL_POINT;
    
    localparam   signed  [DATA_WIDTH-1:0]            ZERO_POINT = {DATA_WIDTH{1'b0}};
    localparam           [INTEGER_LENGTH-1:0]        INTEGERZERO = 0;        
    localparam   signed  [DATA_WIDTH-1:0]            One = 2'sb01 <<< DECIMAL_POINT;

    // timing signals
    input                                            clk;
    input                                            rst_n;

    // interface
    input        signed  [DATA_WIDTH-1:0]            i_data_bus;
    input                                            i_valid;

    output       signed  [DATA_WIDTH-1:0]            o_data_bus;
    output                                           o_valid;

    input                                            i_en;

    // inner logic
    reg          signed  [DATA_WIDTH-1:0]            o_data_bus_inner;         
    reg                                              o_valid_inner;         
    
    reg          signed  [DATA_WIDTH-1:0]            dataABS;
    reg          signed  [INTEGER_LENGTH-1:0]        integerPartABS;
    
    reg          signed  [DECIMAL_POINT-1:0]         fractionPartABS;
    reg          signed  [DECIMAL_POINT-1:0]         fractionPartABSDiv4;
    reg          signed  [DATA_WIDTH-1:0]            OneShift;
    reg          signed  [DATA_WIDTH-1:0]            fractionPartABSDiv4Scale;
    reg          signed  [DATA_WIDTH-1:0]            numerator;
    reg          signed  [DATA_WIDTH-1:0]            dataInner;

    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            dataABS = {DATA_WIDTH{1'b0}};
            integerPartABS = {INTEGER_LENGTH{1'b0}};
            fractionPartABS = {DECIMAL_POINT{1'b0}};
            fractionPartABSDiv4 = {DECIMAL_POINT{1'b0}};
            OneShift = {DATA_WIDTH{1'b0}};
            fractionPartABSDiv4Scale = {INTEGERZERO, fractionPartABSDiv4};
            numerator = {DATA_WIDTH{1'b0}};
            o_data_bus_inner = ZERO_POINT;
            o_valid_inner = 1'b0;
        end
        else if(i_en & i_valid)
        begin
            dataABS = (i_data_bus[DATA_WIDTH-1])? ((~i_data_bus) + 1) : i_data_bus;
            integerPartABS = i_data_bus[DATA_WIDTH-1:DECIMAL_POINT];
            fractionPartABS = dataABS[DECIMAL_POINT-1:0];
            fractionPartABSDiv4 = fractionPartABS >> 2;
            OneShift = One >>> 1;
            fractionPartABSDiv4Scale = {INTEGERZERO, fractionPartABSDiv4};
            numerator = OneShift - fractionPartABSDiv4Scale;
            o_data_bus_inner = numerator >> integerPartABS;       
            o_valid_inner = 1'b1;
        end
        else
        begin
            dataABS = {DATA_WIDTH{1'b0}};
            integerPartABS = {INTEGER_LENGTH{1'b0}};
            fractionPartABS = {DECIMAL_POINT{1'b0}};
            fractionPartABSDiv4 = {DECIMAL_POINT{1'b0}};
            OneShift = {DATA_WIDTH{1'b0}};
            fractionPartABSDiv4Scale = {INTEGERZERO, fractionPartABSDiv4};
            numerator = {DATA_WIDTH{1'b0}};
            o_data_bus_inner = ZERO_POINT;
            o_valid_inner = 1'b0;
        end
    end

    assign o_data_bus = o_data_bus_inner;
    assign o_valid = o_valid_inner;

endmodule
