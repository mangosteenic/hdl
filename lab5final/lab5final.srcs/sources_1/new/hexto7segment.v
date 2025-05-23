`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2023 06:34:18 PM
// Design Name: 
// Module Name: hexto7segment
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


module hexto7segment(
    input [3:0] x,
    output reg [6:0] r
);
always @(*)
	case (x)
		4'b0000 : r=7'b1000000;
		4'b0001 : r=7'b1111001;
		4'b0010 : r=7'b0100100;
		4'b0011 : r=7'b0110000;
		4'b0100 : r=7'b0011001;
		4'b0101 : r=7'b0010010;
		4'b0110 : r=7'b0000010;
		4'b0111 : r=7'b1111000;
		4'b1000 : r=7'b0000000;
		4'b1001 : r=7'b0011000;
		4'b1010 : r=7'b0001000;
		4'b1011 : r=7'b0000011;
		4'b1100 : r=7'b1000110;
		4'b1101 : r=7'b0100001;
		4'b1110 : r=7'b0000110;
		4'b1111 : r=7'b0001110;
	endcase

endmodule