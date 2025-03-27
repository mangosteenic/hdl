`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2025 03:05:53 PM
// Design Name: 
// Module Name: controller
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


module controller(clk, cs, we, address, data_in, data_out, btns, swtchs, leds, segs, an);
    input clk;
    output cs;
    output we;
    output[6:0] address;
    input[7:0] data_in;
    output[7:0] data_out;
    input[3:0] btns;
    input[7:0] swtchs;
    output[7:0] leds;
    output[6:0] segs;
    output[3:0] an;
    
    //WRITE THE FUNCTION OF THE CONTROLLER
    reg [6:0] spr;  // next free address past the top of the stack
    reg [6:0] dar;  // address of data that should be displayed on the output
    reg [7:0] dvr;  // value that should be displayed on the output
    reg EMPTY; // empty flag

    always @(posedge clk) begin
        // Clear/RST
        if (btns[3] && !btns[2] && btns[1]) begin
            spr <= 2'h7F;
            dar <= 2'h00;
            dvr <= 2'h00;
            EMPTY <= 1'b1;
        end
    end

    assign leds[7] = EMPTY;
    
endmodule
