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

    output [7:0] M1_out,
    output [7:0] M2_out,
    output [7:0] M3_out,
    output [7:0] M4_out,
    output [7:0] M5_out,
    output [7:0] M6_out,
    output [7:0] M7_out,
    output [7:0] M8_out,
    output [7:0] M9_out,
    output reg done = 0
    );

    // reg M1_start = 0;
    // reg M2_start = 0;
    // reg M3_start = 0;
    // reg M4_start = 0;
    // reg M5_start = 0;
    // reg M6_start = 0;
    // reg M7_start = 0;
    // reg M8_start = 0;
    // reg M9_start = 0;

    reg M1_start = 0;
    wire M2_start;
    wire M3_start;
    wire M4_start;
    wire M5_start;
    wire M6_start;
    wire M7_start;
    wire M8_start;
    wire M9_start;

    // Porpagate inputs to top-level MACs
    reg [7:0] in_M1a = 0;
    reg [7:0] in_M1b = 0;
    reg [7:0] in_M2b = 0;
    reg [7:0] in_M3b = 0;
    reg [7:0] in_M4a = 0;
    reg [7:0] in_M7a = 0;
    reg [5:0] count = 0;
    wire [4:0] state = count[4:0];

    always @(*) begin
        case(state)
            1: begin
                M1_start <= 1;

                in_M1a <= a00;
                in_M1b <= b00;
            end
            2: begin
                M1_start <= 0;
            end
            5: begin
                M1_start <= 1;
                // M2_start <= 1;
                // M4_start <= 1;

                in_M1a <= a01;
                in_M1b <= b10;

                in_M2b <= b01;

                in_M4a <= a10;
            end
            6: begin
                M1_start <= 0;
            end
            9: begin
                M1_start <= 1;
                // M3_start <= 1;
                // M5_start <= 1;
                // M7_start <= 1;

                in_M1a <= a02;
                in_M1b <= b20;

                in_M2b <= b11;

                in_M3b <= b02;
                // M2_start <= 0;
                // M4_start <= 0;

                in_M4a <= a11;

                in_M3b <= b22;
                in_M7a <= a20;
            end
            10: begin
                M1_start <= 0;
            end
            13: begin
                // M3_start <= 0;
                // M5_start <= 0;
                // M7_start <= 0;

                in_M2b <= b21;

                in_M3b <= b12;

                in_M4a <= a12;

                in_M7a <= a21;
            end
            14: begin
                // M6_start <= 0;
                // M8_start <= 0;
            end
            17: begin
                // M9_start <= 0;

                in_M3b <= b22;

                in_M7a <= a22;
            end
            21: begin
                done <= 1;
            end
            default: begin
                // M1_start <= 0;
                // M2_start <= 0;
                // M3_start <= 0;
                // M4_start <= 0;
                // M5_start <= 0;
                // M6_start <= 0;
                // M7_start <= 0;
                // M8_start <= 0;
                // M9_start <= 0;
            end
        endcase
    end

    always @(posedge clk) begin
        if(start) begin
            if(!done) begin
                count <= count + 1;
            end
        end
    end

    wire t2;
    wire t3;
    wire t4;
    wire t5;

    wire dummy1;
    wire dummy2;
    wire dummy3;
    wire dummy4;

    wire [7:0] M1_a_prop;
    wire [7:0] M2_a_prop;
    wire [7:0] M3_a_prop;
    wire [7:0] M4_a_prop;
    wire [7:0] M5_a_prop;
    wire [7:0] M6_a_prop;
    wire [7:0] M7_a_prop;
    wire [7:0] M8_a_prop;
    wire [7:0] M9_a_prop;
    wire [7:0] M1_b_prop;
    wire [7:0] M2_b_prop;
    wire [7:0] M3_b_prop;
    wire [7:0] M4_b_prop;
    wire [7:0] M5_b_prop;
    wire [7:0] M6_b_prop;
    wire [7:0] M7_b_prop;
    wire [7:0] M8_b_prop;
    wire [7:0] M9_b_prop;

    MAC M1(clk, reset, M1_start, in_M1a, in_M1b, t2, M1_out, M1_a_prop, M1_b_prop);
    MAC M2(clk, reset, t2, M1_a_prop, in_M2b, t3, M2_out, M2_a_prop, M2_b_prop);
    MAC M3(clk, reset, t3, M2_a_prop, in_M3b, t4, M3_out, M3_a_prop, M3_b_prop);
    MAC M4(clk, reset, t2, in_M4a, M1_b_prop, dummy1, M4_out, M4_a_prop, M4_b_prop);
    MAC M5(clk, reset, t3, M4_a_prop, M2_b_prop, dummy2, M5_out, M5_a_prop, M5_b_prop);
    MAC M6(clk, reset, t4, M5_a_prop, M3_b_prop, M9_start, M6_out, M6_a_prop, M6_b_prop);
    MAC M7(clk, reset, t3, in_M7a, M4_b_prop, dummy3, M7_out, M7_a_prop, M7_b_prop);
    MAC M8(clk, reset, t4, M7_a_prop, M5_b_prop, t5, M8_out, M8_a_prop, M8_b_prop);
    MAC M9(clk, reset, t5, M8_a_prop, M6_b_prop, dummy4, M9_out, M9_a_prop, M9_b_prop);

endmodule
