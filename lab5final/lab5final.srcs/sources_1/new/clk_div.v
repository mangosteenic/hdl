`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2025 03:58:03 PM
// Design Name: 
// Module Name: clk_div
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


module clk_div(
    input in_clk,
    output reg out_clk
    );
    
    reg [25:0] count;
    
    always @ (posedge in_clk)
    begin
        count<=count+1;
        if (count>=25000000)
        begin
            out_clk<=~out_clk;
            count<=0;
        end
    end
    
    
    
    
endmodule