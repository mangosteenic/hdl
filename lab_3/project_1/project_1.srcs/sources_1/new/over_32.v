`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2025 11:05:53 AM
// Design Name: 
// Module Name: over_32
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


module over_32(
    input clk,
    input rst,
    input pulse,
    output reg [15:0] seconds_w_steps_over_32
);

reg [31:0] cycles;
reg [31:0] steps;
reg [3:0] seconds;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cycles <= 0;
        steps <= 0;
        seconds <= 0;
        seconds_w_steps_over_32 <= 0;
    end else begin
        if (pulse) steps <= steps + 1;
        if (cycles == 100000000 - 1) begin
            cycles <= 0;
            if (seconds < 9) begin
                seconds <= seconds + 1;
                if (steps > 31) seconds_w_steps_over_32 <= seconds_w_steps_over_32 + 1;
                steps <= 0;
            end
        end else cycles <= cycles + 1;
    end
end
    
endmodule