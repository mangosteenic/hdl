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


module tb_StepCounter(
    
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
    reg pulse = 0;

    // Outputs
    wire [31:0] stepcount_raw;
    wire SI;
    
    // Instantiate dut
    StepCounter dut (
        .clk(clk),
        .rst(rst),
        .pulse(pulse),
        .stepcount_raw(stepcount_raw),
        .SI(SI)
    );
    
    initial begin
        #10 rst = 0;

        forever begin
            // Clock generation
            #5
            clk = ~clk;
            pulse = ~pulse;
        end

    end

    always @(*) begin
        $display("Stepcount: %d, SI: %d", stepcount_raw, SI);
        if(stepcount_raw >= 9999) begin
            // $display("Saturation");
            assert(SI == 1);
        end

        if($time > 10000000) begin
            $finish;
        end
    end

endmodule
