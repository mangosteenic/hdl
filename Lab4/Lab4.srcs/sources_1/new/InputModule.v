`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2025 07:52:27 PM
// Design Name: 
// Module Name: InputModule
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


module InputModule
    #(parameter CLOCKS_PER_50MS = 5000000)

    (
    input btnU, btnL, btnR, btnD,
    input [1:0] sw,
    input clk,
    output add_10, add_180, add_200, add_550,
    output rst_to_10, rst_to_205
    );

    // Slow clock generation (for debounce)
    // Clock divider for 50ms
    reg debounce_clk = 0;
    reg [31:0] clock_count = 0;
    always @(posedge clk) begin
        if(clock_count >= CLOCKS_PER_50MS) begin
            debounce_clk <= 1;
            clock_count <= 0;
        end else begin
            debounce_clk <= 0;
            clock_count <= clock_count + 1;
        end
    end

    // Synchronizers
    // BtnU
    reg btnU_synch_temp = 0;
    reg btnU_synch = 0;
    always @(posedge debounce_clk) begin
        btnU_synch_temp <= btnU;
        btnU_synch <= btnU_synch_temp;
    end

    // BtnL
    reg btnL_synch_temp = 0;
    reg btnL_synch = 0;
    always @(posedge debounce_clk) begin
        btnL_synch_temp <= btnL;
        btnL_synch <= btnL_synch_temp;
    end

    // BtnR
    reg btnR_synch_temp = 0;
    reg btnR_synch = 0;
    always @(posedge debounce_clk) begin
        btnR_synch_temp <= btnR;
        btnR_synch <= btnR_synch_temp;
    end

    // BtnD
    reg btnD_synch_temp = 0;
    reg btnD_synch = 0;
    always @(posedge debounce_clk) begin
        btnD_synch_temp <= btnD;
        btnD_synch <= btnD_synch_temp;
    end

    // Single pulse generation
    // BtnU
    wire btnU_singlepress;
    reg btnU_sp_temp = 0;
    always @(posedge clk) begin
        btnU_sp_temp <= btnU_synch;
    end
    assign btnU_singlepress = (~btnU_sp_temp) & btnU_synch;

    // BtnL
    wire btnL_singlepress;
    reg btnL_sp_temp = 0;
    always @(posedge clk) begin
        btnL_sp_temp <= btnL_synch;
    end
    assign btnL_singlepress = (~btnL_sp_temp) & btnL_synch;

    // BtnR
    wire btnR_singlepress;
    reg btnR_sp_temp = 0;
    always @(posedge clk) begin
        btnR_sp_temp <= btnR_synch;
    end
    assign btnR_singlepress = (~btnR_sp_temp) & btnR_synch;

    // BtnD
    wire btnD_singlepress;
    reg btnD_sp_temp = 0;
    always @(posedge clk) begin
        btnD_sp_temp <= btnD_synch;
    end
    assign btnD_singlepress = (~btnD_sp_temp) & btnD_synch;

    assign add_10 = btnU_singlepress;
    assign add_180 = btnL_singlepress;
    assign add_200 = btnR_singlepress;
    assign add_550 = btnD_singlepress;

    assign rst_to_10 = sw[0];
    assign rst_to_205 = sw[1];
endmodule
