`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 01:57:03 PM
// Design Name: 
// Module Name: MAC
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


module MAC(
    input clk,
    input reset,
    input start,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out
    );

    assign sign_a = a[7];
    assign sign_b = b[7];
    
    assign exp_a = a[6:4];
    assign exp_b = b[6:4];

    assign frac_a = a[3:0];
    assign frac_b = b[3:0];

    // Multiply FP numbers by multiplying the fraction and adding the exponent
    // Then sign the output accordingly
    always @(posedge clk) begin
        out[6:4] <= exp_a + exp_b; // Exponent
        out[3:0] <= frac_a * frac_b; // Fraction
        out[7] = sign_a ^ sign_b; // Sign
    end

endmodule
