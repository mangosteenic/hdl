`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2025 05:10:13 PM
// Design Name: 
// Module Name: tb_top
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

    // Inputs
    reg clk = 0;
    reg rst = 1;
    reg START = 1;
    reg [1:0] MODE = 0;

    reg btnU = 0;
    reg btnL = 0;
    reg btnR = 0;
    reg btnD = 0;
    reg [1:0] sw = 2'b10;

    // Outputs
    wire [3:0] an;
    wire [6:0] sseg;
    
    // Instantiate dut
    top #(.CLOCK_FREQ(100)) dut (clk, btnU, btnL, btnR, btnD, sw, an, sseg);
    
    initial begin
        $dumpfile("lab4.vcd");
        $dumpvars(0,dut);

        #10 sw = 2'b00;

        forever begin
            // Clock generation
            #5
            clk = ~clk;
        end

    end

endmodule
