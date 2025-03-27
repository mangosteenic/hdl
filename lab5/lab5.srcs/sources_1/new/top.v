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


module top(clk, btns, swtchs, leds, segs, an);
    input clk;
    input[3:0] btns;
    input[7:0] swtchs;
    output[7:0] leds;
    output [6:0] segs;
    output [3:0] an;
    
    //might need to change some of these from wires to regs
    wire cs;
    wire we;
    wire[6:0] addr;
    wire[7:0] data_out_mem;
    wire[7:0] data_out_ctrl;
    wire[7:0] data_bus;
    
    //CHANGE THESE TWO LINES
    assign data_bus = 1;    // 1st driver of the data bus -- tri state switches
                            // function of we and data_out_ctrl
    assign data_bus = 1;    // 2nd driver of the data bus -- tri state switches
                            // function of we and data_out_mem
    
    controller ctrl(clk, cs, we, addr, data_bus, data_out_ctrl,
        btns, swtchs, leds, segs, an);
    
    memory mem(clk, cs, we, addr, data_bus, data_out_mem);
    
    //add any other functions you need
    //(e.g. debouncing, multiplexing, clock-division, etc)

    wire [6:0] in0, in1;

    hexto7segment c1 (.x(data_out_ctrl[3:0]), .r(in0));
    hexto7segment c2 (.x(data_out_ctrl[7:4]), .r(in1));

    // multiplexing
    reg s;
    reg [6:0] segs_int;
    reg [3:0] an_int;
    always @(posedge clk) begin
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
    assign segs = segs_int;
    assign an = an_int;
endmodule
