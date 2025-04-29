`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2025 05:19:32 PM
// Design Name: 
// Module Name: debounce
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


module debounce(
    input button,
    input clk,
    output reg pulse=0
    );
    
    reg pulse_help=0;
    
    reg flag;
    initial flag=1;
    
    reg [20:0] count;
    reg [20:0] count1;
    reg button1;
    
    always @ (posedge clk)
    begin
    if (button)
    begin
    count<=count+1;
        if (count[20])
        begin
            button1<=1;
            count<=0;
            count1<=0;
        end
    end
    else
    begin
        count1<=count1+1;
        if (count1[20])
        begin
            button1<=0;
            count<=0;
            count1<=0;
        end
    end
    
    
            if (button1&&flag)
        begin
            pulse=1;
            flag=0;
        end
        else 
        begin 
            pulse=0;
        end
        if (!button1)
            flag=1;
    end
    
endmodule
