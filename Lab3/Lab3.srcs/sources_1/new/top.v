`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2025 01:41:08 PM
// Design Name: 
// Module Name: top
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


module top(CLK, RESET, START, MODE, an, sseg, SI);

    input CLK, RESET, START;
    input [1:0] MODE;
    output [3:0] an;
    output [6:0] sseg;
    output SI;
    
    wire slowClk, disp_clk, pulse;
    wire [31:0] stepcount_raw;
    wire [31:0] distance;
    wire [31:0] seconds_over32;
    wire [31:0] high_activity_time_secs;
    wire [6:0] in0, in1, in2, in3;
    
    pulse_gen pg1 (START, MODE, CLK, RESET, pulse, slowClk);
    
    StepCounter sc1 (slowClk, RESET, pulse, stepcount_raw, SI);
    DistanceCovered dc1 (CLK, RESET, stepcount_raw, distance);
    over_32 o1 (CLK, RESET, pulse, seconds_over32);
    HighActivityTime hat1 (CLK, RESET, pulse, high_activity_time_secs);
    
    clk_div_disp c7 (.clk(CLK), .clk_out(disp_clk));
        
    time_mux_state_machine c6 (
        .clk (disp_clk),
        .reset (RESET),
        .in0 (in0),
        .in1 (in1),
        .in2 (in2),
        .in3 (in3),
        .an (an),
        .sseg (sseg));
        
    reg [1:0] state;
    reg [1:0] next_state;
    
    always @ (*) begin
        case(state)     // state transition
            2'b00 : next_state = 2'b01;
            2'b01 : next_state = 2'b10;
            2'b10 : next_state = 2'b11;
            2'b11 : next_state = 2'b00;
        endcase
	end

    always @(posedge CLK or posedge RESET) begin
		if(RESET)
			state <= 2'b00;
		else
			state <= next_state;
	end
	
	reg [15:0] data;
	
    always @ (*) begin
        case (state)
            2'b00 : data = stepcount_raw;
            2'b01 : data = distance;
            2'b10 : data = seconds_over32;
            2'b11 : data = high_activity_time_secs;
		endcase
	end
	
	bcd_seven c1 (.bcd(data[3:0]), .seven(in0));
    bcd_seven c2 (.bcd(data[7:4]), .seven(in1));
    bcd_seven c3 (.bcd(data[11:8]), .seven(in2));
    bcd_seven c4 (.bcd(data[15:12]), .seven(in3));
        
endmodule
