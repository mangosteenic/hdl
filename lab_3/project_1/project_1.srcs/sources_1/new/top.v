`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2025 01:03:32 PM
// Design Name: 
// Module Name: top
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


module top(CLK, RESET, START, MODE, an, sseg, SI);
    
    input CLK, RESET, START;
    input [1:0] MODE;
    output [3:0] an;
    output [6:0] sseg;
    output SI;
    
    wire pulse;
    wire [15:0] stepcount, distance, seconds_w_steps_over_32, high_activity_time_secs;

    pulse_gen p1 (CLK, RESET, START, MODE, pulse);
    fitbit_tracker f1 (CLK, RESET, pulse, stepcount, distance, seconds_w_steps_over_32, high_activity_time_secs, SI);
    display d1 (CLK, RESET, stepcount, distance, seconds_w_steps_over_32, high_activity_time_secs, an, sseg);

endmodule
