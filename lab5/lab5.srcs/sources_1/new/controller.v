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


module controller(clk, cs, we, address, data_in, data_out, btns, swtchs, leds, segs, state);
    input clk;
    output reg cs;
    output reg we;
    output reg [6:0] address;
    input[7:0] data_in;
    output reg [7:0] data_out;
    input[3:0] btns;
    input[7:0] swtchs;
    output[7:0] leds;
    input [6:0] segs;
    output [3:0] state;
    
    assign state = current_state;
    
    //WRITE THE FUNCTION OF THE CONTROLLER
    reg [6:0] spr;  // next free address past the top of the stack
    reg [6:0] dar;  // address of data that should be displayed on the output
    reg [7:0] dvr;  // value that should be displayed on the output
    reg EMPTY = 1;      // empty flag

    reg input_en = 1; // Disallow inputs while operations are happening

    // For operation state machine
    reg [3:0] current_state = S_RESET;
    reg [3:0] next_state = S_IDLE;
    
    // // Get Input and handle it
    // always @(posedge clk) begin
    //     if(input_en) begin
    //         case(btns[3:2])
    //             2'b00 : begin                   // PUSH/POP MODE
    //                 if (btns[1]) begin          // delete/pop
    //                     current_state <= S_POP_START;
    //                 end else if (btns[0]) begin // enter/push
    //                     current_state <= S_PUSH_START;
    //                 end else begin
    //                     current_state <= S_IDLE;
    //                 end
    //             end
    //             2'b01 : begin                   // ADD/SUBTRACT MODE
    //                 if (btns[1]) begin          // subtract
    //                     current_state <= S_SUB_START;
    //                 end else if (btns[0]) begin // add
    //                     current_state <= S_ADD_START;
    //                 end
    //             end
    //             2'b10 : begin                   // CLEAR/TOP MODE
    //                 if (btns[1]) begin          // clear/RST
    //                     current_state <= S_RESET;
    //                 end else if (btns[0]) begin // top
    //                     current_state <= S_TOP_START;
    //                 end
    //             end
    //             2'b11 : begin                   // DEC/INC MODE
    //                 if (btns[1]) begin          // dec addr
    //                     current_state <= S_DEC_START;
    //                 end else if (btns[0]) begin // inc addr
    //                     current_state <= S_INC_START;
    //                 end
    //             end
    //         endcase
    //     end
    //     else begin
    //         current_state <= next_state;
    //     end
    // end

    // State machine for functionality
    localparam S_RESET = 15;
    localparam S_IDLE = 0;
    localparam S_PUSH_START = 1;
    localparam S_POP_START = 2;
    localparam S_ADD_START = 3;
    localparam S_SUB_START = 4;
    // RST handled up there
    localparam S_TOP_START = 5;
    localparam S_DEC_START = 6;
    localparam S_INC_START = 7;
    localparam S_MEM_WAIT = 8;
    localparam S_ADD_1 = 9;
    localparam S_ADD_2 = 10;
    localparam S_ADD_3 = 11;
    localparam S_SUB_1 = 12;
    localparam S_SUB_2 = 13;
    localparam S_SUB_3 = 14;

    // Operands for math
    reg [7:0] op_1;
    reg [7:0] op_2;

    always @(posedge clk) begin
        case(current_state)
            S_RESET: begin
                spr <= 7'h7F;
                dar <= 7'h00;
                dvr <= 8'h00;
                EMPTY <= 1'b1;

                current_state <= S_IDLE;
            end
            
            S_IDLE: begin
                // Change state based on input
                case(btns[3:2])
                    2'b00 : begin                   // PUSH/POP MODE
                        if (btns[1]) begin          // delete/pop
                            current_state <= S_POP_START;
                        end else if (btns[0]) begin // enter/push
                            current_state <= S_PUSH_START;
                        end else begin
                            current_state <= S_IDLE;
                        end
                    end
                    2'b01 : begin                   // ADD/SUBTRACT MODE
                        if (btns[1]) begin          // subtract
                            current_state <= S_SUB_START;
                        end else if (btns[0]) begin // add
                            current_state <= S_ADD_START;
                        end else begin
                            current_state <= S_IDLE;
                        end
                    end
                    2'b10 : begin                   // CLEAR/TOP MODE
                        if (btns[1]) begin          // clear/RST
                            current_state <= S_RESET;
                        end else if (btns[0]) begin // top
                            current_state <= S_TOP_START;
                        end else begin
                            current_state <= S_IDLE;
                        end
                    end
                    2'b11 : begin                   // DEC/INC MODE
                        if (btns[1]) begin          // dec addr
                            current_state <= S_DEC_START;
                        end else if (btns[0]) begin // inc addr
                            current_state <= S_INC_START;
                        end else begin
                            current_state <= S_IDLE;
                        end
                    end
                endcase

                input_en <= 1'b1;
                we <= 1'b0;
                cs <= 1'b0;
                dvr <= data_in;
                dar <= spr + 1;
                address <= dar;
            end

            S_PUSH_START: begin
                input_en <= 1'b0;

                address <= spr;
                data_out <= swtchs;
                spr <= spr - 1;
                we <= 1'b1;
                cs <= 1'b1;

                current_state <= S_MEM_WAIT;
            end

            S_POP_START: begin
                input_en <= 1'b0;

                spr <= spr + 1;

                current_state <= S_MEM_WAIT;
            end

            S_ADD_START: begin
                input_en <= 1'b0;

                // Pop off both operands and add them, then push that back
                spr <= spr + 1;
                address <= spr + 1;

                current_state <= S_ADD_1;
            end
            S_ADD_1: begin
                op_1 <= data_in;

                spr <= spr + 1;
                address <= spr + 1;

                current_state <= S_ADD_2;
            end
            S_ADD_2: begin
                op_2 <= data_in;

                current_state <= S_ADD_3;
            end
            S_ADD_3: begin
                data_out <= op_1 + op_2;

                spr <= spr - 1;
                address <= spr;
                we <= 1'b1;
                cs <= 1'b1;

                current_state <= S_MEM_WAIT;
            end

            S_SUB_START: begin
                input_en <= 1'b0;

                // Pop off both operands and subtract them, then push that back
                spr <= spr + 1;
                address <= spr + 1;

                current_state <= S_SUB_1;
            end
            S_SUB_1: begin
                op_1 <= data_in;

                spr <= spr + 1;
                address <= spr + 1;

                current_state <= S_SUB_2;
            end
            S_SUB_2: begin
                op_2 <= data_in;

                current_state <= S_SUB_3;
            end
            S_SUB_3: begin
                data_out <= op_1 - op_2;

                spr <= spr - 1;
                address <= spr;
                we <= 1'b1;
                cs <= 1'b1;

                current_state <= S_MEM_WAIT;
            end

            S_TOP_START: begin
                input_en <= 1'b0;

                // Set DAR to top of stack
                dar <= spr + 1;

                current_state <= S_MEM_WAIT;
            end

            S_DEC_START: begin
                input_en <= 1'b0;

                dar <= dar - 1;

                current_state <= S_MEM_WAIT;
            end

            S_INC_START: begin
                input_en <= 1'b0;

                dar <= dar + 1;

                current_state <= S_MEM_WAIT;
            end

            S_MEM_WAIT: begin
                // Wait one cycle for memory operation
                current_state <= S_IDLE;
                // address <= dar;
            end
        endcase
    end

    assign leds[7] = (spr == 7'h7F);
    assign leds[6:0] = dar;
    
endmodule
