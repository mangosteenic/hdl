`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2025 11:40:54 PM
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
    #(parameter CLOCK_FREQ = 100000000)
    (
    input CLK,
    input btnU, btnL, btnR, btnD,
    input [1:0] sw,
    output [3:0] an,
    output [6:0] sseg
    );
    
    wire add_10, add_180, add_200, add_550;
    wire rst_to_10, rst_to_205;
    wire dp = 0;

    wire [15:0] seconds_left;

    InputModule #(.CLOCKS_PER_50MS(CLOCK_FREQ * 0.05)) input_module (btnU, btnL, btnR, btnD, sw, CLK, add_10, add_180, add_200, add_550, rst_to_10, rst_to_205);

    ControllerModule #(.CLOCK_FREQ(CLOCK_FREQ)) controller_module (CLK, add_10, add_180, add_200, add_550, rst_to_10, rst_to_205, seconds_left);

    OutputModule output_module(CLK, seconds_left, an, dp, sseg);
    
endmodule
