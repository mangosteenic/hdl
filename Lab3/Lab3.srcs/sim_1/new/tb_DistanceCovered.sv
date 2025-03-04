`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2025 10:55:28 PM
// Design Name: 
// Module Name: tb_DistanceCovered
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


module tb_DistanceCovered(

    );

    /*
    module DistanceCovered(
    input clk,
    input rst,
    input [31:0] steps,
    output reg [31:0] distance
    );
    */

    // Inputs
    reg clk = 0;
    reg rst = 1;
    reg step_pulse = 0;
    reg [31:0] steps = 0;

    // Outputs
    wire [31:0] distance;
    
    // Instantiate dut
    DistanceCovered dut (
        .clk(clk),
        .rst(rst),
        .steps(steps),
        .distance(distance)
    );
    
    initial begin
        #10 rst = 0;

        forever begin
            // Clock generation
            #1
            clk <= ~clk;
            steps <= steps + 1;
        end

    end

    always @(*) begin
        $display("Distance: %d", distance);

        if($time >= 20000000) begin
            // Test reset
            rst = 1;
            #100
            // assert(distance == 0);
            #100
            $finish;
        end
    end

endmodule
