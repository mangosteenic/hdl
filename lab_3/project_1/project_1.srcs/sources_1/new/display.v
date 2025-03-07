`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2025 09:23:59 AM
// Design Name: 
// Module Name: display
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


module display(
    input CLK,
    input RESET,
    input [15:0] stepcount,
    input [15:0] distance,
    input [15:0] steps_over_32,
    input [15:0] high_activity_time_secs,
    output [3:0] an,
    output [6:0] sseg
    );
    
    reg [1:0] state;
    reg [1:0] next_state;
    reg [31:0] counter;
    reg [15:0] data;
    
    wire [6:0] in0, in1, in2, in3;
    
    always @ (*) begin
        case(state)     // state transition
            2'b00 : next_state = 2'b01;
            2'b01 : next_state = 2'b10;
            2'b10 : next_state = 2'b11;
            2'b11 : next_state = 2'b00;
        endcase
	end
	
	always @ (*) begin
        case (state)    // multiplexer
            2'b00 : data = stepcount;
            2'b01 : data = distance;
            2'b10 : data = steps_over_32;
            2'b11 : data = high_activity_time_secs;
		endcase
	end

    always @(posedge CLK or posedge RESET) begin
        if (RESET)
        begin
            state <= 2'b00;
            counter <= 0;
        end
		else
		begin
            if (counter == 32'd200000000)
            begin
                counter <= 0;
                state <= next_state;
            end
            else counter <= counter + 1;
        end
	end
        
    // module instantiation of hexto7segment decoder
    bcd_seven c1 (.x(data[3:0]), .r(in0));
    bcd_seven c2 (.x(data[7:4]), .r(in1));
    bcd_seven c3 (.x(data[11:8]), .r(in2));
    bcd_seven c4 (.x(data[15:12]), .r(in3));
    
    // module instantiation of the multiplexer
    time_mux_state_machine c6 (
        .clk (CLK),
        .reset (RESET),
        .in0 (in0),
        .in1 (in1),
        .in2 (in2),
        .in3 (in3),
        .an (an),
        .sseg (sseg)
        );

endmodule

