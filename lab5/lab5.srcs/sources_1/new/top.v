`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2025 03:04:18 PM
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
    #(parameter CLOCKS_PER_25MS = 5000000) // Original: 2500000
    (clk, btnU, btnL, btnR, btnD, sw, leds, segs, an);
    input clk;
    // input[3:0] btns;
    input btnU;
    input btnL;
    input btnR;
    input btnD;
    input[7:0] sw;
    output[15:0] leds;
    output reg [6:0] segs;
    output reg [3:0] an;
    
    //might need to change some of these from wires to regs
    wire cs;
    wire we;
    wire[6:0] addr;
    wire[7:0] data_out_mem;
    wire[7:0] data_out_ctrl;
    wire[7:0] data_bus;

    wire btnU_singlepress;
    wire btnL_singlepress;
    wire btnR_singlepress;
    wire btnD_singlepress;

    // TODO: Check if this is correct
    wire [3:0] btns = {btnD_synch, btnR_synch, btnL_singlepress, btnU_singlepress};
    assign leds[11:8] = btns;
    
    // CHANGE THESE TWO LINES
    assign data_bus = (we ? data_out_ctrl : data_out_mem);    // 1st driver of the data bus -- tri state switches
                            // function of we and data_out_ctrl
    // assign data_bus = (!we ? data_out_mem : 8'bz);    // 2nd driver of the data bus -- tri state switches
                            // function of we and data_out_mem
    
    wire dummy;
    wire [3:0] state;
    controller ctrl(debounce_clk, cs, we, addr, data_bus, data_out_ctrl,
        btns, sw, leds[7:0], dummy, state);
    
    memory mem(disp_clk[15], cs, we, addr, data_bus, data_out_mem);
    
    // add any other functions you need
    // (e.g. debouncing, multiplexing, clock-division, etc)

    // Slow clock generation (for debounce)
    // Clock divider for 50ms
    reg debounce_clk = 0;
    reg [31:0] clock_count = 0;

    // assign leds[12] = debounce_clk;
    assign leds[15:12] = state; // Current state of the controller

    always @(posedge clk) begin
        if(clock_count >= CLOCKS_PER_25MS) begin
            debounce_clk <= 1;
        end else begin
            debounce_clk <= 0;
        end

        if(clock_count >= (2 * CLOCKS_PER_25MS)) begin
            clock_count <= 0;
        end
        else begin
            clock_count <= clock_count + 1;
        end
    end

    // Synchronizers
    // BtnU
    reg btnU_synch_temp = 0;
    reg btnU_synch = 0;
    always @(posedge debounce_clk) begin
        btnU_synch_temp <= btnU;
        btnU_synch <= btnU_synch_temp;
    end

    // BtnL
    reg btnL_synch_temp = 0;
    reg btnL_synch = 0;
    always @(posedge debounce_clk) begin
        btnL_synch_temp <= btnL;
        btnL_synch <= btnL_synch_temp;
    end

    // BtnR
    reg btnR_synch_temp = 0;
    reg btnR_synch = 0;
    always @(posedge debounce_clk) begin
        btnR_synch_temp <= btnR;
        btnR_synch <= btnR_synch_temp;
    end

    // BtnD
    reg btnD_synch_temp = 0;
    reg btnD_synch = 0;
    always @(posedge debounce_clk) begin
        btnD_synch_temp <= btnD;
        btnD_synch <= btnD_synch_temp;
    end

    // Single pulse generation
    // BtnU
    
    reg btnU_sp_temp = 0;
    always @(posedge debounce_clk) begin
        btnU_sp_temp <= btnU_synch;
    end
    assign btnU_singlepress = (~btnU_sp_temp) & btnU_synch;

    // BtnL
    reg btnL_sp_temp = 0;
    always @(posedge debounce_clk) begin
        btnL_sp_temp <= btnL_synch;
    end
    assign btnL_singlepress = (~btnL_sp_temp) & btnL_synch;

    // BtnR
    reg btnR_sp_temp = 0;
    always @(posedge debounce_clk) begin
        btnR_sp_temp <= btnR_synch;
    end
    assign btnR_singlepress = (~btnR_sp_temp) & btnR_synch;

    // BtnD
    reg btnD_sp_temp = 0;
    always @(posedge debounce_clk) begin
        btnD_sp_temp <= btnD_synch;
    end
    assign btnD_singlepress = (~btnD_sp_temp) & btnD_synch;

    wire [6:0] in0, in1;

    hexto7segment c1 (.x(data_bus[3:0]), .r(in0));
    hexto7segment c2 (.x(data_bus[7:4]), .r(in1));

    // multiplexing
    reg s;
    reg [31:0] disp_clk = 0;
    always @(posedge clk) begin
        disp_clk <= disp_clk + 1;
    end

    always @(posedge disp_clk[15]) begin
        case(s)
            0: begin
                s <= 1;
                an <= 4'b1110;
                segs <= in0;
            end
            1: begin
                s <= 0;
                an <= 4'b1101;
                segs <= in1;
            end
        endcase
    end
endmodule
