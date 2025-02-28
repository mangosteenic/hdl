`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2025 01:15:54 PM
// Design Name: 
// Module Name: tb_HighActivityTime
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


module tb_HighActivityTime(

    );

    /*
    module HighActivityTime(
    input clk,
    input rst,
    input step_pulse,
    output reg [31:0] high_activity_time_secs
    );
    */

    // Inputs
    reg clk = 0;
    reg rst = 1;
    reg step_pulse = 0;

    // Outputs
    wire [31:0] high_activity_time_secs;
    
    // Instantiate dut
    HighActivityTime #(.CLOCK_SPEED(100)) dut (
        .clk(clk),
        .rst(rst),
        .step_pulse(step_pulse),
        .high_activity_time_secs(high_activity_time_secs)
    );
    
    initial begin
        #10 rst = 0;

        forever begin
            // Clock generation
            #1
            clk = ~clk;
            step_pulse = ~step_pulse;
        end

    end

    always @(*) begin
        $display("high_activity_time_secs: %d", high_activity_time_secs);

        if($time >= 20000000) begin
            // Test reset
            rst = 1;
            #100
            assert(high_activity_time_secs == 0);
            #100
            $finish;
        end
    end
endmodule
