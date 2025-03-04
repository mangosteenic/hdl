`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2025 04:54:53 PM
// Design Name: 
// Module Name: DistanceCovered
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


module DistanceCovered(
    input clk,
    input rst,
    input [31:0] steps,
    output reg [31:0] distance
    );

    // Negedge of steps[10] = every 2048 steps

    always @(negedge steps[10] or posedge rst) begin
        if(rst) begin
            distance <= 32'b0;
        end
        else begin
            distance <= distance + 5;
        end
    end

endmodule
