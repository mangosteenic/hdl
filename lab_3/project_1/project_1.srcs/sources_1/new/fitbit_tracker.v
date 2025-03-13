`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2025 10:02:16 AM
// Design Name: 
// Module Name: fitbit_tracker
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


module fitbit_tracker(CLK, RESET, pulse, stepcount, distance, seconds_w_steps_over_32, high_activity_time_secs, SI);
    
    input CLK, RESET, pulse;
    output [15:0] stepcount, distance, seconds_w_steps_over_32, high_activity_time_secs;
    output SI;
        
    StepCounter sc1 (RESET, pulse, stepcount, SI);
    DistanceCovered dc1 (RESET, pulse, distance);
    over_32 o1 (CLK, RESET, pulse, seconds_w_steps_over_32);
    HighActivityTime hat1 (CLK, RESET, pulse, high_activity_time_secs);
        
endmodule
