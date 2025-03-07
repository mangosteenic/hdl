`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2025 09:26:39 AM
// Design Name: 
// Module Name: bcd_seven
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


module bcd_seven(
    input [3:0] x,
    output reg [6:0] r
    );
    always @(*)
        case (x)
            4'b0000 : r = 7'b0000001;   // 0
            4'b0001 : r = 7'b1001111;   // 1
            4'b0010 : r = 7'b0010010;   // 2
            4'b0011 : r = 7'b0000110;   // 3
            4'b0100 : r = 7'b1001100;   // 4
            4'b0101 : r = 7'b0100100;   // 5
            4'b0110 : r = 7'b0100000;   // 6
            4'b0111 : r = 7'b0001111;   // 7
            4'b1000 : r = 7'b0000000;   // 8
            4'b1001 : r = 7'b0000100;   // 9
            4'b1010 : r = 7'b1110111;   // _
            default : r = 7'b0000001;
        endcase
endmodule
