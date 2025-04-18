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
    output reg [7:0] out = 0 // Zero
    );
    
    reg [7:0] curr_mult_out = 0;

    wire sign_a = a[7];
    wire sign_b = b[7];
    
    wire [2:0] exp_a = a[6:4];
    wire [2:0] exp_b = b[6:4];

    wire [3:0] frac_a = a[3:0];
    wire [3:0] frac_b = b[3:0];

    wire sign_accum = out[7];
    reg [2:0] exp_accum = 0;
    reg [3:0] frac_accum = 0;

    wire sign_mult = curr_mult_out[7];
    reg [2:0] exp_mult = 0;
    reg [3:0] frac_mult = 0;

    reg [7:0] temp = 0; // Buffer for pipeline
    
    wire [15:0] temp_mult = ({1'b1, frac_a} * {1'b1, frac_b});
    // For easy sign extending
    wire [7:0] frac_mult_sextendable = {4'b0001, temp_mult[7:4]};
    wire [7:0] out_sextable = {4'b0001, out[3:0]};

    wire [4:0] temp_add = ({1'b0, frac_mult} + {1'b0, frac_accum});

    // Multiply FP numbers by multiplying the fraction and adding the exponent
    // Then sign the output accordingly

    // Add to accumulator
    always @(posedge clk) begin
        if(start) begin

            // Multiply
            // Handle zero case
            if(a == 0 || b == 0) begin
                curr_mult_out <= 0;
            end
            else begin
                curr_mult_out[6:4] <= (exp_a - 3) + (exp_b - 3) + 3; // Exponent
                curr_mult_out[3:0] <= temp_mult[7:4]; // Fraction
                curr_mult_out[7] <= sign_a ^ sign_b; // Sign
            end

            // Add
            // Handle zero case
            if(curr_mult_out == 0) begin
                exp_mult <= out[6:4];
                frac_mult <= 0;
                frac_accum <= out[3:0];
            end
            else if(out == 0) begin
                exp_mult <= curr_mult_out[6:4];
                frac_mult <= curr_mult_out[3:0];
                frac_accum <= 0;
            end
            else begin
                // Shift exponents if needed
                if(curr_mult_out[6:4] == out[6:4]) begin // Same exp
                    exp_mult <= curr_mult_out[6:4];
                    frac_mult <= curr_mult_out[3:0];
                    
                    exp_accum <= out[6:4];
                    frac_accum <= out[3:0];
                end
                else if(curr_mult_out[6:4] <= out[6:4]) begin // Curr mult is less than accum
                    // Shift curr_mult
                    exp_mult <= out[6:4];
                    frac_mult <= frac_mult_sextendable >> (out[6:4] - curr_mult_out[6:4]);
                    
                    exp_accum <= out[6:4];
                    frac_accum <= out[3:0];
                end
                else if(curr_mult_out[6:4] >= out[6:4]) begin // Accum is less than curr mult
                    // Shift curr_mult
                    exp_mult <= curr_mult_out[6:4];
                    frac_mult <= curr_mult_out[3:0];
                    
                    exp_accum <= curr_mult_out[6:4];
                    frac_accum <= out_sextable >> (curr_mult_out[6:4] - out[6:4]);
                end
            end

            // Put into accumulator buffer
            out[7] <= out[7] ^ sign_mult;

            // Overflow
            if(frac_mult + frac_accum >= 'h10) begin
                out[3:0] <= temp_add[4:1];
                exp_mult = exp_mult + 1;
            end
            else begin
                out[3:0] <= frac_mult + frac_accum;
            end

            out[6:4] <= exp_mult; // == exp_accum

            // // Put into accumulator
            // out <= temp;
        end
    end

endmodule
