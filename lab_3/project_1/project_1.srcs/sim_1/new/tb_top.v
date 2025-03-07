`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2025 09:59:09 PM
// Design Name: 
// Module Name: tb_StepCounter
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


module tb_top(
    
    );

    /*
    module StepCounter(
    input clk, // Clock in (unused?)
    input rst, // Reset in - active HIGH
    input pulse, // Pulse in
    output reg [31:0] stepcount_raw, // Raw stepcount
    output SI // Saturation status
    );
    */
    

    // Inputs
    reg clk = 0;
    reg rst = 1;
    reg START = 1;
    reg [1:0] MODE = 0;

    // Outputs
    wire an;
    wire sseg;
    
    // Instantiate dut
    top dut (clk, rst, START, MODE, an, sseg);
    
    initial begin
        #10 rst = 0;

        forever begin
            // Clock generation
            #5
            clk = ~clk;
        end

    end

endmodule
