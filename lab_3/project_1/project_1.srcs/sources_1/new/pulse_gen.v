`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2025 09:35:46 PM
// Design Name: 
// Module Name: pulse_gen
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


module pulse_gen
    # (
        parameter CLOCKS_PER_PULSE = 100
    )
    
    (CLK, RESET, START, MODE, pulse);
    
    input CLK, RESET, START;
    input [1:0] MODE;
    output pulse;
    
    reg [31:0] counter;
    reg [31:0] freq;
    reg [31:0] seconds;
    reg [31:0] cycles;
    
    reg pulse_int = 0;
    
    always @ (posedge CLK or posedge RESET)
    begin
        if (RESET)
        begin
            counter <= 0;
            freq <= 0;
            seconds <= 0;
            cycles <= 0;
            pulse_int <= 0;
        end
        else if (START)
        begin
            cycles <= cycles + 1;
            if (cycles >= 100000000)
            begin
                cycles <= 0;
                seconds <= seconds + 1;
            end
            case (MODE)
                2'b00: freq <= 32;
                2'b01: freq <= 64;
                2'b10: freq <= 128;
                2'b11: begin
                    if (seconds == 0) freq <= 20;
                    else if (seconds == 1) freq <= 33;
                    else if (seconds == 2) freq <= 66;
                    else if (seconds == 3) freq <= 27;
                    else if (seconds == 4) freq <= 70;
                    else if (seconds == 5) freq <= 30;
                    else if (seconds == 6) freq <= 19;
                    else if (seconds == 7) freq <= 30;
                    else if (seconds == 8) freq <= 33;
                    else if (seconds < 73) freq <= 69;
                    else if (seconds < 79) freq <= 34;
                    else if (seconds < 144) freq <= 124;
                    else freq <= 0;
                end
            endcase
    
            if (counter >= (100000000 / (2 * freq))) begin
                counter <= 1;
                pulse_int <= ~pulse_int;
            end
            else begin
                counter <= counter + 1;
            end
        end
        else
        begin
            counter <= counter;
            freq <= freq;
            seconds <= seconds;
            cycles <= cycles;
            pulse_int <= pulse_int;
        end
    end
    
    assign pulse = pulse_int;
    
endmodule
