`timescale 1ns / 1ps
/*
    Top Module:  hardtanh_seq
    Data:        Only data width matters -- 2's complement data representation
    Format:      keeping the input format unchange
    Timing:      Sequential Logic
    Reset:       Asynchronized Reset [Low Reset]
    Latency:     1 cycle
    Dummy Data:  {DATA_WIDTH{1'b0}}

    Function:   
                        
                  ^ o_data_bus [DATA_WIDTH-1:0]
                  |
                  |    
                  |   ______
                  |1 /
                  | /
     _____________|/________ > i_data_bus [DATA_WIDTH-1:0]
            -1    /0   1                     
                 /|                     
         _______/ |-1                     
                  |                     
                  |                     


    Author:      Jianming Tong (jianming.tong@gatech.edu)
*/


module hardtanh_seq#(
    parameter DATA_WIDTH = 16,
    parameter DECIMAL_POINT = 6
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
    localparam   signed  [DATA_WIDTH-1:0]     ZERO_POINT = {DATA_WIDTH{1'b0}};
    localparam   signed  [DATA_WIDTH-1:0]     THRESHOLD = 2'sb01 <<< DECIMAL_POINT;       // stands for 1
    localparam   signed  [DATA_WIDTH-1:0]     NEGATHRESHOLD  = 2'sb11 <<< DECIMAL_POINT;  // stands for -1

    // timing signals
    input                                           clk;
    input                                           rst_n;

    // interface
    input      signed       [DATA_WIDTH-1:0]        i_data_bus;
    input                                           i_valid;

    output     signed       [DATA_WIDTH-1:0]        o_data_bus;
    output                                          o_valid;

    input                                           i_en;

    // inner logic
    reg        signed       [DATA_WIDTH-1:0]        o_data_bus_inner;         
    reg                                             o_valid_inner;         

    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            o_data_bus_inner <= ZERO_POINT;
            o_valid_inner <= 1'b0;
        end
        else if(i_en & i_valid)
        begin
            o_data_bus_inner <= (i_data_bus > THRESHOLD)? THRESHOLD:((i_data_bus < NEGATHRESHOLD)?NEGATHRESHOLD:i_data_bus);       
            o_valid_inner <= 1'b1;
        end
        else
        begin
            o_data_bus_inner <= ZERO_POINT;
            o_valid_inner <= 1'b0;
        end
    end

    assign o_data_bus = o_data_bus_inner;
    assign o_valid = o_valid_inner;

endmodule
