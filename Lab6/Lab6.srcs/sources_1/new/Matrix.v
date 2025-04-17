`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 01:57:48 PM
// Design Name: 
// Module Name: Matrix
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

/*
Matrix DUT( clk, 
                reset, 
                start, 
                a00, 
                a01, 
                a02, 
                a10, 
                a11, 
                a12, 
                a20, 
                a21, 
                a22, 
                b00, 
                b01, 
                b02, 
                b10, 
                b11, 
                b12, 
                b20, 
                b21, 
                b22,
                //make sure the above wires/ports are identicaly
                
                //You can choose not to have below wires/ports in your design
                M1_out, 
                M2_out, 
                M3_out, 
                M4_out, 
                M5_out, 
                M6_out, 
                M7_out, 
                M8_out, 
                M9_out, 
                done);
*/
module Matrix(
    input clk,
    input reset,
    input start,
    input [7:0] a00, 
    input [7:0] a01, 
    input [7:0] a02, 
    input [7:0] a10, 
    input [7:0] a11, 
    input [7:0] a12, 
    input [7:0] a20, 
    input [7:0] a21, 
    input [7:0] a22, 
    input [7:0] b00, 
    input [7:0] b01, 
    input [7:0] b02, 
    input [7:0] b10, 
    input [7:0] b11, 
    input [7:0] b12, 
    input [7:0] b20, 
    input [7:0] b21, 
    input [7:0] b22,

    output M1_out,
    output M2_out,
    output M3_out,
    output M4_out,
    output M5_out,
    output M6_out,
    output M7_out,
    output M8_out,
    output M9_out,
    output reg done = 0
    );

    reg M1_start = 0;
    reg M2_start = 0;
    reg M3_start = 0;
    reg M4_start = 0;
    reg M5_start = 0;
    reg M6_start = 0;
    reg M7_start = 0;
    reg M8_start = 0;
    reg M9_start = 0;

    // Porpagate inputs to top-level MACs
    reg [7:0] in_M1a = 0;
    reg [7:0] in_M1b = 0;
    reg [7:0] in_M2b = 0;
    reg [7:0] in_M3b = 0;
    reg [7:0] in_M4a = 0;
    reg [7:0] in_M7a = 0;
    reg [2:0] count = 0;
    always @(posedge clk) begin
        if(start) begin
            case(count)
                0: begin
                    M1_start <= 1;

                    in_M1a <= a00;
                    in_M1b <= b00;
                end
                1: begin
                    M2_start <= 1;
                    M4_start <= 1;

                    in_M1a <= a01;
                    in_M1b <= b10;

                    in_M2b <= b01;

                    in_M4a <= a10;
                end
                2: begin
                    M3_start <= 1;
                    M5_start <= 1;
                    M7_start <= 1;

                    in_M1a <= a02;
                    in_M1b <= b20;

                    in_M2b <= b11;

                    in_M3b <= b02;

                    in_M4a <= a11;

                    in_M7a <= a20;
                end
                3: begin
                    M1_start <= 0;
                    M6_start <= 1;
                    M8_start <= 1;

                    in_M2b <= b21;

                    in_M3b <= b12;

                    in_M4a <= a12;

                    in_M7a <= a21;
                end
                4: begin
                    M9_start <= 1;
                    M2_start <= 0;
                    M4_start <= 0;

                    in_M3b <= b22;
                    in_M7a <= a22;
                end
                5: begin
                    M3_start <= 0;
                    M5_start <= 0;
                    M7_start <= 0;
                end
                6: begin
                    M6_start <= 0;
                    M8_start <= 0;
                end
                7: begin
                    M9_start <= 0;
                end
                default: begin
                    M1_start <= 0;
                    M2_start <= 0;
                    M3_start <= 0;
                    M4_start <= 0;
                    M5_start <= 0;
                    M6_start <= 0;
                    M7_start <= 0;
                    M8_start <= 0;
                    M9_start <= 0;
                end
            endcase

            count <= count + 1;
        end
    end

    MAC M1(clk, reset, M1_start, in_M1a, in_M1b, M1_out);
    MAC M2(clk, reset, M2_start, M1_out, in_M2b, M2_out);
    MAC M3(clk, reset, M3_start, M2_out, in_M3b, M3_out);
    MAC M4(clk, reset, M4_start, in_M4a, M1_out, M4_out);
    MAC M5(clk, reset, M5_start, M4_out, M2_out, M5_out);
    MAC M6(clk, reset, M6_start, M5_out, M3_out, M6_out);
    MAC M7(clk, reset, M7_start, in_M7a, M4_out, M7_out);
    MAC M8(clk, reset, M8_start, M7_out, M5_out, M8_out);
    MAC M9(clk, reset, M9_start, M8_out, M6_out, M9_out);

endmodule
