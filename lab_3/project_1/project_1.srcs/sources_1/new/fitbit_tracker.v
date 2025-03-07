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


module fitbit_tracker(CLK, RESET, pulse, stepcount, distance, steps_over_32, high_activity_time_secs);
    
    input CLK, RESET, pulse;
    output [15:0] stepcount, distance, steps_over_32, high_activity_time_secs;
    
    wire [15:0] stepcount_raw;
    
    StepCounter sc1 (CLK, RESET, pulse, stepcount_raw, SI);
    DistanceCovered dc1 (CLK, RESET, stepcount_raw, distance);
    over_32 o1 (CLK, RESET, pulse, seconds_over32);
    HighActivityTime hat1 (CLK, RESEt, pulse, high_activity_time_secs);
    
    assign stepcount = (stepcount_raw > 9999) ? 9999 : stepcount_raw;
    
endmodule
