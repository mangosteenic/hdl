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
    output reg done = 0,
    output reg [7:0] out = 0, // Zero
    output reg [7:0] prop_a = 0,
    output reg [7:0] prop_b = 0
    );
    
    reg [7:0] in_a = 0;
    reg [7:0] in_b = 0;

    reg valid_0 = 0;
    reg valid_1 = 0;
    reg valid_2 = 0;
    reg valid_3 = 0;
    reg valid_4 = 0;

    reg run_state = 0;
    reg [7:0] curr_mult_out = 0;

    wire sign_a = in_a[7];
    wire sign_b = in_b[7];
    
    wire [2:0] exp_a = in_a[6:4];
    wire [2:0] exp_b = in_b[6:4];

    wire [3:0] frac_a = in_a[3:0];
    wire [3:0] frac_b = in_b[3:0];

    wire sign_accum = out[7];
    reg [2:0] exp_accum = 0;
    reg [4:0] frac_accum = 0;

    wire sign_mult = curr_mult_out[7];
    reg [2:0] exp_mult = 0;
    reg [4:0] frac_mult = 0;

    reg [7:0] temp = 0; // Buffer for pipeline
    
    wire [15:0] temp_mult = ({1'b1, frac_a} * {1'b1, frac_b});
    // For easy sign extending
    wire [7:0] frac_mult_sextendable = {4'b0001, temp_mult[7:4]};
    wire [7:0] out_sextendable = {4'b0001, out[3:0]};

    reg [5:0] temp_add = 0; // ({1'b0, frac_mult} + {1'b0, frac_accum});
    reg temp_sign = 0;

    // If we are adding/subtracting from zero
    wire zero_case = (out == 0) || (curr_mult_out == 0);

    always @(*) begin
        // Find sign of result
        if(curr_mult_out[7] == sign_accum) begin
            temp_sign = sign_accum; // If they are the same, the output sign is the same
        end
        else begin
            // See which one is larger - exps should be the same
            // Take the sign of the larger one
            
            if(frac_mult == frac_accum) begin
                temp_sign = 0; // Results in a zero
            end
            else if(frac_mult > frac_accum) begin
                temp_sign = curr_mult_out[7]; // Take sign of mult
            end
            else begin //frac_mult < frac_accum
                temp_sign = sign_accum; // Take sign of accumulator
            end
        end
    end

    // Multiply FP numbers by multiplying the fraction and adding the exponent
    // Then sign the output accordingly

    // always @(*) begin
    //     if(start) begin
    //         // Reset
    //         run_state <= 1;
    //         done <= 0;
    //     end
    //     else if(done) begin
    //         // Done
    //         run_state <= 0;
    //     end
    //     else begin
    //         // Do nothing
    //         run_state <= run_state;
    //     end
    // end

    reg [7:0] prop_a_buf = 0;
    reg [7:0] prop_b_buf = 0;

    always @(posedge start) begin
        run_state <= 1;
        // done <= 0;
        // in_a <= a;
        // in_b <= b;
        valid_0 <= 1;

        prop_a_buf <= a;
        prop_b_buf <= b;
    end

    // Add to accumulator
    always @(posedge clk) begin
        if(run_state) begin
            // Stage 0: Sample
            if(valid_0) begin
                in_a <= a;
                in_b <= b;
                valid_0 <= 0;
                valid_1 <= 1;
            end

            // Stage 1: Multiply
            if(valid_1) begin
                in_a <= a;
                in_b <= b;
                
                // Multiply
                // Handle zero case
                if(a == 0 || b == 0) begin
                    curr_mult_out <= 0;
                end
                else begin
                    curr_mult_out[6:4] <= ((exp_a - 3) + (exp_b - 3) + 3) + (temp_mult[9] ? 1 : 0); // Exponent
                    curr_mult_out[3:0] <= temp_mult[9] ? temp_mult[8:5] : temp_mult[7:4]; // Fraction
                    curr_mult_out[7] <= sign_a ^ sign_b; // Sign
                end

                valid_1 <= 0;
                valid_2 <= 1;
            end

            // Stage 2: Shift exponents
            if(valid_2) begin
                // Handle zero case
                if(curr_mult_out == 0) begin
                    exp_mult <= out[6:4];
                    exp_accum <= out[6:4];
                    frac_mult <= 0;
                    frac_accum <= {1'b1, out[3:0]};
                end
                else if(out == 0) begin
                    exp_mult <= curr_mult_out[6:4];
                    exp_accum <= curr_mult_out[6:4];
                    frac_mult <= {1'b1, curr_mult_out[3:0]};
                    frac_accum <= 0;
                end
                else begin
                    // Shift exponents if needed
                    if(curr_mult_out[6:4] == out[6:4]) begin // Same exp
                        exp_mult <= curr_mult_out[6:4];
                        frac_mult <= {1'b1, curr_mult_out[3:0]};
                        
                        exp_accum <= out[6:4];
                        frac_accum <= {1'b1, out[3:0]};
                    end
                    else if(curr_mult_out[6:4] <= out[6:4]) begin // Curr mult is less than accum
                        // Shift curr_mult
                        exp_mult <= out[6:4];
                        frac_mult <= frac_mult_sextendable >> (out[6:4] - curr_mult_out[6:4]);
                        
                        exp_accum <= out[6:4];
                        frac_accum <= {1'b1, out[3:0]};
                    end
                    else if(curr_mult_out[6:4] >= out[6:4]) begin // Accum is less than curr mult
                        // Shift curr_mult
                        exp_mult <= curr_mult_out[6:4];
                        frac_mult <= {1'b1, curr_mult_out[3:0]};
                        
                        exp_accum <= curr_mult_out[6:4];
                        frac_accum <= out_sextendable >> (curr_mult_out[6:4] - out[6:4]);
                    end
                end

                valid_3 <= 1;
                valid_2 <= 0;
            end

            // Stage 3: Add/Subtract
            if(valid_3) begin
                // Handle zero case
                if(frac_mult == 0) begin
                    temp_add <= out;
                    valid_3 <= 0;
                    valid_4 <= 1;
                end
                else if(frac_accum == 0) begin
                    temp_add <= curr_mult_out;
                    valid_3 <= 0;
                    valid_4 <= 1;
                end
                else begin
                    // Add
                    temp[6:4] <= exp_mult; // Exponent

                    // If subtracting different signs, always subtract the smaller one
                    // If the signs are the same, add
                    if(sign_mult == sign_accum) begin
                        temp_add <= frac_mult + frac_accum; // Fraction
                    end
                    else begin
                        // Subtract the smaller one
                        if(frac_mult > frac_accum) begin
                            temp_add <= frac_mult - frac_accum; // Fraction
                        end
                        else begin
                           temp_add <= frac_accum - frac_mult; // Fraction 
                        end
                    end

                    // Sign
                    temp[7] <= temp_sign; // Subtract
                end

                valid_3 <= 0;
                valid_4 <= 1;
            end
            

            // Stage 4: Put into accumulator buffer
            if(valid_4) begin
                out[7] <= temp_sign;

                // Overflow
                if((temp_add[5]) && !zero_case) begin
                    out[3:0] <= temp_add[4:1];
                    exp_mult = exp_mult + 1;
                end
                // Underflow
                else if((temp_add[4] == 0) && !zero_case) begin
                    out[3:0] <= {temp_add[2:0], 1'b0}; // Shift with zero
                    if(exp_mult > 0) begin
                        exp_mult = exp_mult - 1;
                    end
                    else begin
                        // Fault?
                        exp_mult = 0;
                    end
                end
                else begin
                    out[3:0] <= temp_add[3:0];
                    exp_mult = exp_mult;
                end

                out[6:4] <= exp_mult; // == exp_accum

                // // Put into accumulator
                // out <= temp;

                // valid_3 <= 0;
                valid_4 <= 0;
                done <= 1;

                prop_a <= in_a;
                prop_b <= in_b;
            end

            // // Stage 4: Buffer
            // if(valid_4) begin
            //     // Buffer
            //     valid_4 <= 0;
            //     done <= 1;
            // end
            
            if(done) begin
                // Reset
                // run_state <= 0;
                done <= 0;

                if(!valid_0 && !valid_1 && !valid_2 && !valid_3 && !valid_4) begin
                    // Reset
                    in_a <= 0;
                    in_b <= 0;
                    curr_mult_out <= 0;
                    exp_mult <= 0;
                    frac_mult <= 0;
                    exp_accum <= 0;
                    frac_accum <= 0;
                end
            end
        end
    end

endmodule
