`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2025 01:21:40 PM
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


module bcd_seven(bcd, seven);
    input [3:0] bcd;
    output [7:1] seven;
    
    reg [7:1] seven;
    
    always @(bcd) begin
        case (bcd)
            0000: seven = 7'b1000000;
            0001: seven = 7'b1111001;
            0010: seven = 7'b0100100;
            0011: seven = 7'b0110000;
            0100: seven = 7'b0011001;
            0101: seven = 7'b0010010;
            0110: seven = 7'b0000010;
            0111: seven = 7'b1111000;
            1000: seven = 7'b0000000;
            1001: seven = 7'b0010000;
            1010: seven = 7'b1110111;
            default: seven = 7'bxxxxxxx;
        endcase;
    end
endmodule
