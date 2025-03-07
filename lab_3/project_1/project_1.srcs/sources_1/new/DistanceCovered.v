`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2025 10:55:57 AM
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
    input [15:0] stepcount_raw,
    output reg [15:0] distance
    );

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            distance <= 0;
        end
        else begin
            distance <= (stepcount_raw) / 2048 * 5;
            distance[15:8] <= distance / 10;
            distance[7:4] <= 4'b1010;
            distance[3:0] <= (distance % 10) * 10;
        end
    end

endmodule