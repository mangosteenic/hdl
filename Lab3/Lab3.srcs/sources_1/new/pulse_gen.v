`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2025 02:13:28 PM
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


module pulse_gen(START, MODE, CLK, RESET, slowClk, pulse);
    
    input START, CLK, RESET;
    input [1:0] MODE;
    output slowClk, pulse;  
    
    reg [27:0] threshold;
    wire slowClk;
    
    reg pulse_int;
    
    reg [7:0] seconds;
    reg [6:0] pulses;
    reg [6:0] sequence [0:144];
    
    divider d1 (CLK, threshold, slowClk);
    
    initial
    begin
        sequence[0] = 20;
        sequence[1] = 33;
        sequence[2] = 66;
        sequence[3] = 27;
        sequence[4] = 70;
        sequence[5] = 30;
        sequence[6] = 19;
        sequence[7] = 30;
        sequence[8] = 33;
        sequence[9] = 69;
        sequence[74] = 34;
        sequence[80] = 124;
        sequence[145] = 0;
    end
    
    always @(posedge slowClk or posedge RESET)
    begin
        if (RESET)
            pulse_int <= 0;
        else if (START && pulses > 0)
        begin
            pulse_int <= ~pulse_int;
            pulses <= pulses -1;
        end
        else
            pulse_int <= 0;
    end
    
    always @(posedge CLK or posedge RESET) 
    begin
        if (RESET)
        begin
            threshold <= 0;
            seconds <= 0;
        end
        else if (START)
        begin
            case (MODE)
                2'b00: threshold <= 1562500; // 100,000,000 / (2 * 32)
                2'b01: threshold <= 781250;  // 100,000,000 / (2 * 64)
                2'b10: threshold <= 390625;  // 100,000,000 / (2 * 128)
                2'b11: begin
                    if (seconds < 145)
                    begin
                        pulses <= sequence[seconds];
                        seconds <= seconds + 1;
                    end
                    else
                        pulses <= 0;
                end
                default: threshold <= 0;
            endcase
        end
    end
    
    assign pulse = pulse_int;
    
endmodule
