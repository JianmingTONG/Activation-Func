`timescale 1ns / 1ps
/*
    Top Module:  tb_sigmoid_seq
    Data:        Only data width matters -- 2's complement data representation
    Format:      keeping the input format unchange
    Timing:      Sequential Logic
    Reset:       Asynchronized Reset [Low Reset]
    Latency:     1 cycle
    Dummy Data:  {DATA_WIDTH{1'b0}}

    Function:   
                        
                        ^ o_data_bus [DATA_WIDTH-1:0]
                        |
                        |       /
                        |      /
                        |     /
                        |    /
                        |   /
                        |  /
                        | /
     ___________________|/__________________ > i_data_bus [DATA_WIDTH-1:0]
                        0                        

    Author:      Jianming Tong (jianming.tong@gatech.edu)
*/

module tb_sigmoid_seq();
    localparam   DATA_WIDTH = 8;
    localparam   NUM_INPUT_DATA = 1;
    localparam   WIDTH_INPUT_DATA = NUM_INPUT_DATA * DATA_WIDTH;
    localparam   NUM_OUTPUT_DATA = 1;
    localparam   WIDTH_OUTPUT_DATA = WIDTH_INPUT_DATA;

    localparam   signed  [DATA_WIDTH-1:0]     ZERO_POINT = {DATA_WIDTH{1'b0}};
    
    localparam NUM = {DATA_WIDTH{1'b1}};

    // interface
    reg                                        clk;
    reg                                        rst_n;

    reg  [NUM_INPUT_DATA-1:0]                  i_valid;
    reg  [WIDTH_INPUT_DATA-1:0]                i_data_bus;

    wire [NUM_OUTPUT_DATA-1:0]                 o_valid;
    wire [WIDTH_OUTPUT_DATA-1:0]               o_data_bus; //{o_data_a, o_data_b}

    reg                                        i_en;

    initial 
    begin
        clk = 1'b0;    
        rst_n = 1'b1;
        i_data_bus = ZERO_POINT;
        i_valid = 1'b0;
        i_en = 1'b1;

        // reset 
        #10 
        rst_n = 1'b0;

        // input activate below zero (negative)
        #10
        rst_n = 1'b1;
        i_data_bus = {1'b1, {(DATA_WIDTH-1){1'b0}}};
        i_valid = 1'b1;

        // input activate larger than zero
        #10
        // i_data_bus = {1'b0, {(DATA_WIDTH-1){1'b1}}};
        i_data_bus = {DATA_WIDTH{1'b1}};
        i_valid = 1'b1;
        
        #2600
        $stop;
    end

    integer i;
    
    always 
    begin
        @(posedge clk)
        for(i = 0; i < NUM; i = i + 1)
        begin  
            i_data_bus = i_data_bus + 2'sb01; 
        end
    end

    always #5 clk=~clk;

    sigmoid_seq#(
        .DATA_WIDTH(DATA_WIDTH)
    )dut (
        .clk(clk),
        .rst_n(rst_n),
        .i_data_bus(i_data_bus),
        .i_valid(i_valid),
        .o_data_bus(o_data_bus),
        .o_valid(o_valid),
        .i_en(i_en)
    );

endmodule
