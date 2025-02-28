`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2025 12:24:54 PM
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
    output reg [31:0] high_activity_time_secs
    );

    // Generate one second clock
    reg [31:0] clk_counter = 0;
    assign one_second_clk = (clk_counter >= (CLOCK_SPEED/2));

    // Local step counter
    reg [31:0] steps_counter = 0;

    reg [31:0] secs_of_high_activity = 0;
    reg [31:0] prev_high_activity_time_secs = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Async reset
            high_activity_time_secs <= 0;
            clk_counter <= 0;
        end else begin
            // 1 second clock counter
            if (clk_counter == CLOCK_SPEED - 1) begin
                clk_counter <= 0;
            end else begin
                clk_counter <= clk_counter + 1;
            end
        end
    end

    always @(posedge step_pulse or posedge rst) begin
        if(rst) begin
            // Async reset
            steps_counter <= 0;
        end else begin
            if(step_pulse) begin
                steps_counter <= steps_counter + 1;
            end
        end
    end

    always @(posedge one_second_clk) begin
        if(steps_counter >= STEP_THRESHOLD) begin
            secs_of_high_activity <= secs_of_high_activity + 1;
        end
        else begin
            secs_of_high_activity <= 0;
        end

        if(secs_of_high_activity >= INITIAL_MEASURE_TIME) begin
            high_activity_time_secs <= prev_high_activity_time_secs + secs_of_high_activity;
        end
        else begin
            prev_high_activity_time_secs <= high_activity_time_secs;
        end

        steps_counter = 0;
    end

endmodule
