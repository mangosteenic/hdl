`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2025 12:26:55 PM`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2023 06:23:52 PM
// Design Name: 
// Module Name: time_multiplexing_main
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


 module time_multiplexing_main(
    input clk,
    input [15:0] sw,
    output [3:0] an,
    output [6:0] sseg);
   
   wire [6:0] in0, in1, in2, in3;
   wire slow_clk;
   
   //module instantiation of hexto7segment
   hexto7segment c1 (.x(sw[3:0]), .r(in0));
   hexto7segment c2 (.x(sw[7:4]), .r(in1));
   hexto7segment c3 (.x(sw[11:8]), .r(in2));
   hexto7segment c4 (.x(sw[15:12]), .r(in3));
   
   //module instantiation of the clock divider
   clkdiv2 c5 (.clk(clk), .clk_out(slow_clk));
   
   //model instantiation of the multiplexer
   time_mux_state_machine c6(
    .clk(slow_clk),
    .in0 (in0),
    .in1 (in1),
    .in2 (in2),
    .in3(in3),
    .an(an),
    .sseg(sseg));
    
endmodule