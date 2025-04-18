`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2025 05:16:12 PM
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
    output reg cs;
    output reg we;
    output reg [6:0] address;
    input[7:0] data_in;
    output reg [7:0] data_out;
    input[3:0] btns;
    input[7:0] swtchs;
    output reg [7:0] leds;
    output[6:0] segs;
    output[3:0] an;
    
    //WRITE THE FUNCTION OF THE CONTROLLER
    reg [6:0] spr = 7'b1111111;  // next free address past the top of the stack
    reg [6:0] dar = 7'b0000000;  // address of data that should be displayed on the output
    reg [7:0] dvr = 8'b00000000;  // value that should be displayed on the output
    
    // State machine for functionality
    localparam S_IDLE = 0;
    localparam S_PUSH_START = 1;
    localparam S_ADD_START = 2;
    localparam S_ADD_1 = 3;
    localparam S_ADD_2 = 4;
    localparam S_ADD_3 = 5;
    localparam S_SUB_START = 6;
    localparam S_SUB_1 = 7;
    localparam S_SUB_2 = 8;
    localparam S_SUB_3 = 9;
    localparam S_MEM_WAIT = 10;
    
    // For operation state machine
    reg [2:0] current_state = S_IDLE;
    reg [2:0] next_state = S_IDLE;
    
    // Operands for math
    reg [7:0] op_1 = 8'b00000000;
    reg [7:0] op_2 = 8'b00000000;
    
    initial begin
        cs = 0;
        we = 0;
        address = 7'b0000000;
        data_out = 8'b00000000;
    end
    
    always @(*) begin
        case(current_state)
            /*S_RST_START: begin
                address = 7'b1111111;
                data_out = 8'b00000000;
                leds[7] = 1'b1;
                leds[6:0] = 7'b0000000;
                next_state = S_IDLE;
            end*/
            S_IDLE: begin
                case(btns[3:2])
                    2'b00: begin                    // PUSH/POP MODE
                        if (btns[1]) begin          // delete/pop
                            spr = spr + 1;
                            dar = spr;
                            cs = 1'b1;
                            we = 1'b0;
                            address = dar;
                            next_state = S_MEM_WAIT;
                        end else if (btns[0]) begin // enter/push
                            we = 1'b1;
                            cs = 1'b1;
                            address = spr;
                            dar = spr;
                            data_out = swtchs;
                            spr = spr - 1;
                            next_state = S_PUSH_START;
                        end
                    end
                    2'b01: begin                    // ADD/SUBTRACT MODE
                        if (btns[1]) begin          // subtract
                            next_state = S_SUB_START;
                        end else if (btns[0]) begin // add
                            next_state = S_ADD_START;
                        end
                    end
                    2'b10: begin                    // CLEAR/TOP MODE
                        if (btns[1]) begin          // clear/rst
                            we = 1'b1;
                            address = 7'b1111111;
                            data_out = 8'b00000000;
                            dar = 7'b0000000;
                            dvr = 8'b00000000;
                            next_state = S_IDLE;
                        end else if (btns[0]) begin // top
                            dar = spr + 1;
                            address = dar;
                            cs = 1'b1;
                            we = 1'b0;
                            next_state = S_MEM_WAIT;
                        end
                    end
                    2'b11: begin                    // DEC/INC MODE
                        if (btns[1]) begin          // dec addr
                            dar = dar - 1;
                            address = dar;
                            cs = 1'b1;
                            we = 1'b0;
                            next_state = S_MEM_WAIT;
                        end else if (btns[0]) begin // inc addr
                            dar = dar + 1;
                            address = dar;
                            cs = 1'b1;
                            we = 1'b0;
                            next_state = S_MEM_WAIT;
                        end
                    end
                endcase
            end
            
            S_PUSH_START: begin
                we = 1'b0;
                cs = 1'b1;
                address = dar;
                next_state = S_MEM_WAIT;
            end
            
            S_ADD_START: begin
                cs = 1'b1;
                we = 1'b0;
                spr = spr + 1;
                address = spr + 1;
                next_state = S_ADD_1;
            end
            
            S_ADD_1: begin
                op_1 = data_in;
                
                cs = 1'b1;
                we = 1'b0;
                spr = spr + 1;
                address = spr + 1;
                next_state = S_ADD_2;
            end
            
            S_ADD_2: begin
                op_2 = data_in;
                data_out = op_1 + op_2;
                                
                we = 1'b1;
                cs = 1'b1;
                address = spr;
                next_state = S_ADD_3;
            end
            
            S_ADD_3: begin
                we = 1'b0;
                cs = 1'b1;
                spr = spr + 1;
                dar = spr + 1;
                address = dar;
                next_state = S_MEM_WAIT;
            end
            
            S_SUB_START: begin
                spr = spr + 1;
                dar = spr + 1;
                cs = 1'b1;
                we = 1'b0;
                address = dar;
                next_state = S_SUB_1;
            end
            
            S_SUB_1: begin
                op_2 = data_in;
                spr = spr + 1;
                dar = spr + 1;
                cs = 1'b1;
                we = 1'b0;
                address = dar;
                next_state = S_SUB_2;
            end
            
            S_SUB_2: begin
                op_1 = data_in;
                spr = spr - 1;
                cs = 1'b1;
                we = 1'b1;
                address = spr;
                data_out = op_1 - op_2;
                next_state = S_SUB_3;
            end
            
            S_SUB_3: begin
                we = 1'b0;
                dar = spr + 1;
                address = dar;
                cs = 1'b1;
                next_state = S_MEM_WAIT;
            end
            
            S_MEM_WAIT: begin
                dvr = data_in;
                next_state = S_IDLE;
            end
        endcase
    end
    
    always @(posedge clk) begin
        current_state <= next_state;
        
        leds[7] <= (spr == 7'b1111111); // EMPTY flag
        leds[6:0] <= dar;
    end
    
endmodule
