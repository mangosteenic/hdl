`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2025 02:31:11 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top
    #(parameter CLOCKS_PER_50MS = 5000000, parameter CLOCKS_PER_DISP = 100000000)
    (clk, btnU, btnL, btnR, btnD, swtchs, leds, segs, an);
    input clk;
    //input[3:0] btns;
    input btnU, btnL, btnR, btnD;
    input[7:0] swtchs;
    output[7:0] leds;
    output[6:0] segs;
    output[3:0] an;
    
    //might need to change some of these from wires to regs
    wire cs;
    wire we;
    wire[6:0] addr;
    wire[7:0] data_out_mem;
    wire[7:0] data_out_ctrl;
    wire[7:0] data_bus;
    
    reg btnU_synch, btnL_synch, btnR_synch, btnD_synch;
    
    wire btnU_singlepress;
    wire btnL_singlepress;
    //wire btnR_singlepress;
    //wire btnD_singlepress;
    
    wire [3:0] btns;
    assign btns = {btnD_synch, btnR_synch, btnL_singlepress, btnU_singlepress};

    reg clk_50mhz = 0;
    always @(posedge clk) begin
        clk_50mhz <= ~clk_50mhz;
    end
    
    //CHANGE THESE TWO LINES
    assign data_bus = (we ? data_out_ctrl : 8'bz);  // 1st driver of the data bus -- tri state switches
                                                    // function of we and data_out_ctrl
    assign data_bus = (!we ? data_out_mem : 8'bz);  // 2nd driver of the data bus -- tri state switches
                                                    // function of we and data_out_mem
                                                    
    controller ctrl(clk_50mhz, cs, we, addr, data_bus, data_out_ctrl,
        btns, swtchs, leds, segs, an);
    
    memory mem(clk_50mhz, cs, we, addr, data_bus, data_out_mem);

    //add any other functions you need
    //(e.g. debouncing, multiplexing, clock-division, etc)
    
    // Slow clock generation (for debounce)
    // Clock divider for 50ms
    reg debounce_clk = 0;
    reg [31:0] clock_count = 0;
    always @(posedge clk) begin
        clock_count <= clock_count + 1;

        if(clock_count >= CLOCKS_PER_50MS) begin
            debounce_clk <= 1;
        end
        else begin
            debounce_clk <= 0;
        end

        if(clock_count >= (2 * CLOCKS_PER_50MS)) begin
            clock_count <= 0;
        end
    end
       
    // Synchronizers
    // BtnU
    reg btnU_synch_temp = 0;
    always @(posedge debounce_clk) begin
        btnU_synch_temp <= btnU;
        btnU_synch <= btnU_synch_temp;
    end
    
    // BtnL
    reg btnL_synch_temp = 0;
    always @(posedge debounce_clk) begin
        btnL_synch_temp <= btnL;
        btnL_synch <= btnL_synch_temp;
    end
    
    // BtnR
    reg btnR_synch_temp = 0;
    always @(posedge debounce_clk) begin
        btnR_synch_temp <= btnR;
        btnR_synch <= btnR_synch_temp;
    end
    
    // BtnD
    reg btnD_synch_temp = 0;
    always @(posedge debounce_clk) begin
        btnD_synch_temp <= btnD;
        btnD_synch <= btnD_synch_temp;
    end
    
    // Single pulse generation
    // BtnU
    reg btnU_sp_temp = 0;
    always @(posedge clk_50mhz) begin
        btnU_sp_temp <= btnU_synch;
    end
    assign btnU_singlepress = (~btnU_sp_temp) & btnU_synch;
    
    // BtnL
    reg btnL_sp_temp = 0;
    always @(posedge clk_50mhz) begin
        btnL_sp_temp <= btnL_synch;
    end
    assign btnL_singlepress = (~btnL_sp_temp) & btnL_synch;
    
    // multiplexing
    // Clock divider for display
    reg display_clk = 0;
    reg [31:0] clk_cnt = 0;
    always @(posedge clk) begin
        clk_cnt <= clk_cnt + 1;

        if(clk_cnt >= CLOCKS_PER_DISP) begin
            display_clk <= 1;
        end
        else begin
            display_clk <= 0;
        end

        if(clk_cnt >= (2 * CLOCKS_PER_DISP)) begin
            clk_cnt <= 0;
        end
    end
    
    wire [6:0] in0, in1;
    
    hexto7segment c1 (.x(data_bus[3:0]), .r(in0));
    hexto7segment c2 (.x(data_bus[7:4]), .r(in1));
    
    reg [6:0] segs_int;
    reg [3:0] an_int;
    assign segs = segs_int;
    assign an = an_int;
    
    reg s = 0;
    always @(posedge clk_50mhz) begin 
        case(s)
            0: begin
                s <= 1;
                segs_int <= in0;
                an_int <= 4'b1110;
            end
            1: begin
                s <= 0;
                segs_int <= in1;
                an_int <= 4'b1101;
            end
        endcase
    end
    
endmodule
