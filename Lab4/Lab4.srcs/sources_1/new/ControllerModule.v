`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2025 07:52:27 PM
// Design Name: 
// Module Name: ControllerModule
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


module ControllerModule
    #(parameter CLOCK_FREQ = 100000000)
    (
    input clk,
    input add_10, add_180, add_200, add_550,
    input rst_to_10, rst_to_205,
    output reg [15:0] second_count = 0
    );
    
    wire do_add = (add_550 || add_200 || add_180 || add_10);
    wire [15:0] add_num = (add_550 ? 550 : (add_200 ? 200 : (add_180 ? 180 : (add_10 ? 10 : 0))));

    // Clock divider for seconds
    reg do_sub = 0;
    reg [31:0] clock_count = 0;
    always @(posedge clk) begin
        if(clock_count >= CLOCK_FREQ) begin
            do_sub <= 1;
            clock_count <= 0;
        end else begin
            do_sub <= 0;
            clock_count <= clock_count + 1;
        end
    end

    always @(posedge clk or posedge rst_to_10 or posedge rst_to_205) begin
        if(rst_to_205) begin
            second_count <= 205;
        end
        else if(rst_to_10) begin
            second_count <= 10;
        end
        else if(do_add) begin
            second_count <= second_count + add_num;
        end else if(do_sub) begin
            second_count <= second_count - 1;
        end else begin
            if(second_count >= 9999) begin
                second_count <= 9999;
            end
            else begin
                second_count <= second_count;
            end
        end
    end

endmodule
