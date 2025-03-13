`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2025 11:10:54 AM
// Design Name: 
// Module Name: HighActivityTime
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

/*
module HighActivityTime
    // Parameters
    #(
        parameter CLOCK_SPEED = 100000000, // To calculate one second
        parameter STEP_THRESHOLD = 64, // >= # steps/sec for high activity
        parameter INITIAL_MEASURE_TIME = 60 // Initial time (secs) to measure high activity
    )
    // Ports
    (
    input clk,
    input rst,
    input step_pulse,
    // output reg [31:0] high_activity_time_secs
    output reg [15:0] high_activity_time_secs
    );

    // Generate one second clock
    reg [31:0] clk_counter = 0;

    // Local step counter
    reg [31:0] steps_counter = 0;

    reg [31:0] secs_of_high_activity = 0;
    reg [15:0] soha = 0;
    reg [15:0] prev_high_activity_time_secs = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            clk_counter <= 0;
            high_activity_time_secs <= 0;
            steps_counter <= 0;
        end else begin
            if(step_pulse) begin
                steps_counter <= steps_counter + 1;
            end
            
            if (clk_counter == 100000000 - 1) begin
                if(steps_counter >= STEP_THRESHOLD) begin
                    secs_of_high_activity <= secs_of_high_activity + 1;
                    if (soha[3:0] < 9) begin
                        soha[3:0] <= soha[3:0] + 1;
                    end else if (soha[7:4] < 9) begin
                        soha[7:4] <= soha[7:4] + 1;
                        soha[3:0] <= 0;
                    end else if (soha[11:8] < 9) begin
                        soha[11:8] <= soha[11:8] + 1;
                        soha[7:4] <= 0;
                        soha[3:0] <= 0;
                    end else if (soha[15:12] < 9) begin
                        soha[15:12] <= soha[15:12] + 1;
                        soha[11:8] <= 0;
                        soha[7:4] <= 0;
                        soha[3:0] <= 0;
                    end else begin
                        soha[15:12] <= 9;
                        soha[11:8] <= 9;
                        soha[7:4] <= 9;
                        soha[3:0] <= 9;
                    end
                end
                else begin
                    secs_of_high_activity <= 0;
                    soha <= 0;
                end
        
                if(secs_of_high_activity >= INITIAL_MEASURE_TIME) begin
                    if (prev_high_activity_time_secs[3:0] + soha[3:0] < 10) begin
                        high_activity_time_secs[3:0] <= prev_high_activity_time_secs[3:0] + soha[3:0];
                    end else begin
                        high_activity_time_secs[3:0] <= (prev_high_activity_time_secs[3:0] + soha[3:0]) - 10;
                        high_activity_time_secs[7:4] <= high_activity_time_secs[7:4] + 1;
                    end
        
                    if (prev_high_activity_time_secs[7:4] + soha[7:4] < 10) begin
                        high_activity_time_secs[7:4] <= prev_high_activity_time_secs[7:4] + soha[7:4];
                    end else begin
                        high_activity_time_secs[7:4] <= (prev_high_activity_time_secs[7:4] + soha[7:4]) - 10;
                        high_activity_time_secs[11:8] <= high_activity_time_secs[11:8] + 1;
                    end
        
                    if (prev_high_activity_time_secs[11:8] + soha[11:8] < 10) begin
                        high_activity_time_secs[11:8] <= prev_high_activity_time_secs[11:8] + soha[11:8];
                    end else begin
                        high_activity_time_secs[11:8] <= (prev_high_activity_time_secs[11:8] + soha[11:8]) - 10;
                        high_activity_time_secs[15:12] <= high_activity_time_secs[15:12] + 1;
                    end
        
                    if (prev_high_activity_time_secs[15:12] + soha[15:12] < 10) begin
                        high_activity_time_secs[15:12] <= prev_high_activity_time_secs[15:12] + soha[15:12];
                    end else begin
                        high_activity_time_secs[15:12] <= 9;
                    end
                end
                else begin
                    prev_high_activity_time_secs <= high_activity_time_secs;
                end
        
                steps_counter = 0;
            end else begin
                clk_counter <= clk_counter + 1;
            end
        end
    end

endmodule
*/

module HighActivityTime(
    input clk,
    input rst,
    input pulse,
    output reg [15:0] high_activity_time
    );
    
    reg [31:0] cycles;
    reg [31:0] steps;
    reg [15:0] high_activity_seconds;
    reg [31:0] minute_count = 0;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cycles <= 0;
            steps <= 0;
            minute_count <= 0;
            high_activity_seconds <= 0;
            high_activity_time <= 0;
        end else begin
            if (pulse) steps <= steps + 1;
            if (cycles == 100000000 - 1) begin
                cycles <= 0;
                if (steps >= 64) begin
                    minute_count = minute_count + 1;
                    if (high_activity_seconds[3:0] < 9) begin
                        high_activity_seconds[3:0] <= high_activity_seconds[3:0] + 1;
                    end else if (high_activity_seconds[7:4] < 9) begin
                        high_activity_seconds[7:4] <= high_activity_seconds[7:4] + 1;
                        high_activity_seconds[3:0] <= 0;
                    end else if (high_activity_seconds[11:8] < 9) begin
                        high_activity_seconds[11:8] <= high_activity_seconds[11:8] + 1;
                        high_activity_seconds[7:4] <= 0;
                        high_activity_seconds[3:0] <= 0;
                    end else if (high_activity_seconds[15:12] < 9) begin
                        high_activity_seconds[15:12] <= high_activity_seconds[15:12] + 1;
                        high_activity_seconds[11:8] <= 0;
                        high_activity_seconds[7:4] <= 0;
                        high_activity_seconds[3:0] <= 0;
                    end else begin
                        high_activity_seconds[15:12] <= 9;
                        high_activity_seconds[11:8] <= 9;
                        high_activity_seconds[7:4] <= 9;
                        high_activity_seconds[3:0] <= 9;
                    end
                    
                    if (minute_count == 60) begin
                        if (high_activity_time[3:0] + high_activity_seconds[3:0] < 10) begin
                            high_activity_time[3:0] <= high_activity_time[3:0] + high_activity_seconds[3:0];
                        end else begin
                            high_activity_time[3:0] <= (high_activity_time[3:0] + high_activity_seconds[3:0]) - 10;
                            high_activity_time[7:4] <= high_activity_time[7:4] + 1;
                        end
            
                        if (high_activity_time[7:4] + high_activity_seconds[7:4] < 10) begin
                            high_activity_time[7:4] <= high_activity_time[7:4] + high_activity_seconds[7:4];
                        end else begin
                            high_activity_time[7:4] <= (high_activity_time[7:4] + high_activity_seconds[7:4]) - 10;
                            high_activity_time[11:8] <= high_activity_time[11:8] + 1;
                        end
            
                        if (high_activity_time[11:8] + high_activity_seconds[11:8] < 10) begin
                            high_activity_time[11:8] <= high_activity_time[11:8] + high_activity_seconds[11:8];
                        end else begin
                            high_activity_time[11:8] <= (high_activity_time[11:8] + high_activity_seconds[11:8]) - 10;
                            high_activity_time[15:12] <= high_activity_time[15:12] + 1;
                        end
            
                        if (high_activity_time[15:12] + high_activity_seconds[15:12] < 10) begin
                            high_activity_time[15:12] <= high_activity_time[15:12] + high_activity_seconds[15:12];
                        end else begin
                            high_activity_time[15:12] <= 9;
                        end
                    end
                end else begin
                    minute_count <= 0;
                    high_activity_seconds <= 0;
                end
                steps <= 0;
            end else cycles <= cycles + 1;
        end
    end

endmodule