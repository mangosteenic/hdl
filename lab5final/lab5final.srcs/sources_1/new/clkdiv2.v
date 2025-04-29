`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2023 04:39:18 PM
// Design Name: 
// Module Name: clkdiv2
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


module clkdiv2(
    input clk,
    output clk_out
    );
    
    reg [14:0] COUNT;
    
    assign clk_out=COUNT[14];
    
    always @ (posedge clk) 
        begin
            COUNT = COUNT + 1;
        end
endmodule