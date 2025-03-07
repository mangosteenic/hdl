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


module over_32(CLK, RESET, pulse, seconds_over32);

    input CLK, RESET, pulse;
    output [15:0] seconds_over32;
    
    reg [8:0] steps;
    reg [3:0] seconds;
    reg [26:0] cycles;
    reg [15:0] seconds_over32_int;
    reg hold_value;
    
    always @(posedge CLK or posedge RESET)
    begin
        if (RESET)
        begin
            steps <= 0;
            seconds <= 0;
            cycles <= 0;
            seconds_over32_int <= 0;
            hold_value <= 0;
        end
        else
        begin
            if (seconds < 9)
            begin
                if (cycles < 100000000)
                    cycles <= cycles + 1;
                else
                begin
                    cycles <= 0;
                    if (steps > 32)
                        seconds_over32_int <= seconds_over32_int + 1;
                    steps <= 0;
                    seconds <= seconds + 1;
                end
            end
            else
            begin
                hold_value <= 1;
            end
        end
    end
    
    always @(posedge CLK)
    begin
        if (pulse && seconds < 9)
            steps <= steps + 1;
    end
    
    assign seconds_over32 = hold_value ? seconds_over32_int : 0;
    
endmodule
