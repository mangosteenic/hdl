`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2025 09:22:18 AM
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


module tb_top;

    reg clk, btnU, btnL, btnR, btnD;
    reg [7:0] sw;
    wire [7:0] leds;
    wire [6:0] segs;
    wire [3:0] an;
    
    top #(10) dut (clk, btnU, btnL, btnR, btnD, sw, leds, segs, an);
    
    always begin
        #5 clk = ~clk;
    end
    
    initial begin
        $dumpfile("lab5.vcd");
        $dumpvars(0,dut);

        clk = 0;
        btnU = 0;
        btnL = 0;
        btnR = 0;
        btnD = 0;
        sw = 8'b00000000;

        #90;
        
        sw = 8'b10010010;
        btnU = 1;
        #200 btnU = 0;
        #200
        
        sw = 8'b00100101;
        btnU = 1;
        #200 btnU = 0;
        #200
                
        btnR = 1;
        #200 btnU = 1;
        #200 btnU = 0;
        #200
        
        #5000
        
        $finish;
                 
    end
        
endmodule
