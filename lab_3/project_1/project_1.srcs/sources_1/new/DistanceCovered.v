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
    input rst,
    input pulse,
    output reg [15:0] distance
    );

    reg [11:0] pulse_count = 0;
    
    always @(posedge pulse or posedge rst) begin
        if (rst) begin
                pulse_count <= 0;
                distance[15:12] <= 0;
                distance[11:8] <= 0;
                distance[7:4] <= 4'b1010;
                distance[3:0] <= 0;
        end else if (pulse_count == 2048) begin
            pulse_count <= 0;
            distance[7:4] <= 4'b1010;
            if (distance[3:0] == 0) begin
                distance[3:0] <= distance[3:0] + 5;
            end else if (distance[11:8] < 9) begin
                distance[11:8] <= distance[11:8] + 1;
                distance[3:0] <= 0;
            end else if (distance[15:12] < 9) begin
                distance[15:12] <= distance[15:12] + 1;
                distance[7:4] <= 0;
                distance[3:0] <= 0;
            end else begin
                distance[15:12] <= 9;
                distance[11:8] <= 9;
                distance[3:0] <= 5;
            end
        end else pulse_count <= pulse_count + 1;
    end

endmodule