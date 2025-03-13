`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2025 10:48:15 AM
// Design Name: 
// Module Name: StepCounter
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


module StepCounter(
    // input clk, // Clock in (unused?)
    input rst, // Reset in - active HIGH
    input pulse, // Pulse in
    // output reg [31:0] stepcount_raw, // Raw stepcount
    output reg [15:0] stepcount,
    output reg SI // Saturation status
    );

    // Step counter
    always @(posedge pulse or posedge rst) begin
        if (rst) begin
            stepcount <= 0;
            SI <= 0;
        end else begin
            SI <= 0;
            if (stepcount[3:0] < 9) begin
                stepcount[3:0] <= stepcount[3:0] + 1;
            end else if (stepcount[7:4] < 9) begin
                stepcount[7:4] <= stepcount[7:4] + 1;
                stepcount[3:0] <= 0;
            end else if (stepcount[11:8] < 9) begin
                stepcount[11:8] <= stepcount[11:8] + 1;
                stepcount[7:4] <= 0;
                stepcount[3:0] <= 0;
            end else if (stepcount[15:12] < 9) begin
                stepcount[15:12] <= stepcount[15:12] + 1;
                stepcount[11:8] <= 0;
                stepcount[7:4] <= 0;
                stepcount[3:0] <= 0;
            end else begin
                stepcount[15:12] <= 9;
                stepcount[11:8] <= 9;
                stepcount[7:4] <= 9;
                stepcount[3:0] <= 9;
                SI <= 1;
            end
        end
    end

endmodule

