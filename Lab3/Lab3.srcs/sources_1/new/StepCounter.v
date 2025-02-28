`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2025 09:51:34 PM
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
    input clk, // Clock in (unused?)
    input rst, // Reset in - active HIGH
    input pulse, // Pulse in
    output reg [31:0] stepcount_raw, // Raw stepcount
    output SI // Saturation status
    );

    // SI generation
    assign SI = (stepcount_raw >= 9999) ? 1 : 0;

    // Step counter
    always @(posedge pulse or posedge rst) begin
        if (rst) begin
            stepcount_raw <= 0;
        end else begin
            stepcount_raw <= stepcount_raw + 1;
        end
    end

endmodule
