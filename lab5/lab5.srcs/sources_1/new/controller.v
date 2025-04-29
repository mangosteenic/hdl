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
    output cs;
    output reg we;
    output reg [6:0] address;
    input[7:0] data_in;
    output reg [7:0] data_out;
    input[3:0] btns;
    input[7:0] swtchs;
<<<<<<< Updated upstream
    output reg [7:0] leds;
    input[6:0] segs;
=======
    output [7:0] leds;
    output[6:0] segs;
>>>>>>> Stashed changes
    output[3:0] an;
    
    //WRITE THE FUNCTION OF THE CONTROLLER
    //reg [6:0] spr = 7'b1111111;  // next free address past the top of the stack
    //reg [6:0] dar = 7'b0000000;  // address of data that should be displayed on the output
    //reg [7:0] dvr = 8'b00000000;  // value that should be displayed on the output
    
    // State machine for functionality
<<<<<<< Updated upstream
    localparam S_RST_START = 0;
    localparam S_IDLE = 1;
    localparam S_PUSH_START = 2;
    localparam S_ADD_START = 3;
    localparam S_ADD_1 = 4;
    localparam S_ADD_2 = 5;
    localparam S_ADD_3 = 6;
    localparam S_SUB_START = 7;
    localparam S_SUB_1 = 8;
    localparam S_SUB_2 = 9;
    localparam S_SUB_3 = 10;
    localparam S_MEM_WAIT = 11;
    
    // For operation state machine
    reg [2:0] current_state = S_RST_START;
    reg [2:0] next_state = 0;
=======
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
    localparam S_RST_START = 11;
    localparam S_POP = 12;
    localparam S_PUSH_1 = 13;
    localparam S_TOP = 14;
    localparam S_TOP_1 = 15;
    localparam S_TOP_2 = 16;
    localparam S_INC = 17;
    localparam S_INC_1 = 18;
    localparam S_DEC = 19;
    localparam S_DEC_1 = 20;
    localparam S_DEC_2 = 21;
    
    /*// For operation state machine
    reg [2:0] current_state = S_IDLE;
    reg [2:0] next_state = S_IDLE;*/
>>>>>>> Stashed changes
    
    // Operands for math
    reg [7:0] op_1 = 8'b00000000;
    reg [7:0] op_2 = 8'b00000000;
    
    reg [7:0] register0=0;
    reg [7:0] register1=0;
    reg [6:0] stack_ptr=127;
    reg [6:0] dar=0;
    reg [15:0] dvr=0;
    
    reg led_hold;
    
    reg [4:0] state=0;
    reg [4:0] next_state=0;
    reg [6:0] current_dar;
    reg [7:0] current_dvr;
    reg [6:0] current_spr;
    reg [15:0] current_reg0;
    reg [15:0] current_reg1;
    
    initial
    begin
        stack_ptr=127;
        current_spr=127;
    end
    
<<<<<<< Updated upstream
    always @(posedge clk) begin
        case(current_state)
            S_RST_START: begin
                address <= 7'b1111111;
                data_out <= 8'b00000000;
                spr <= 7'b1111111;
                dar <= 7'b0000000;
                current_state <= S_IDLE;
            end
            S_IDLE: begin
                if(!btns[1] && !btns[0]) begin
                    cs <= 1'b0;
                    we <= 1'b0;
                    address <= address;
                    data_out <= data_out;
                    spr <= spr;
                    dar <= dar;
                    current_state <= S_IDLE;
                end
                else begin
                    case(btns[3:2])
                        2'b00: begin                    // PUSH/POP MODE
                            if (btns[1]) begin          // delete/pop
                                spr <= spr + 1;
                                dar <= spr;
                                cs <= 1'b1;
                                we <= 1'b0;
                                address <= dar;
                                current_state <= S_MEM_WAIT;
                            end else if (btns[0]) begin // enter/push
                                we <= 1'b1;
                                cs <= 1'b1;
                                address <= spr;
                                dar <= spr;
                                data_out <= swtchs;
                                spr <= spr - 1;
                                current_state <= S_PUSH_START;
                            end
=======
    assign leds[6:0]= current_dar;
    assign leds[7]=led_hold;
    assign cs=1;
    
    always @(*)
 begin
        we=0;
        dar=current_dar;
        dvr=current_dvr;
        stack_ptr=current_spr;
        register1=current_reg1;
        register0=current_reg0;
        data_out = current_dvr;
        case(state)
            S_IDLE: begin
                case(btns[3:2])
                    2'b00: begin                    // PUSH/POP MODE
                        if (btns[1]) begin          // delete/pop
                            next_state = S_POP;
                        end else if (btns[0]) begin // enter/push
                            next_state = S_PUSH_START;
>>>>>>> Stashed changes
                        end
                        2'b01: begin                    // ADD/SUBTRACT MODE
                            if (btns[1]) begin          // subtract
                                current_state <= S_SUB_START;
                            end else if (btns[0]) begin // add
                                current_state <= S_ADD_START;
                            end
                            else current_state <= S_IDLE;
                        end
<<<<<<< Updated upstream
                        2'b10: begin                    // CLEAR/TOP MODE
                            if (btns[1]) begin          // clear/rst
                                we <= 1'b1;
                                address <= 7'b1111111;
                                data_out <= 8'b00000000;
                                dar <= 7'b0000000;
                                dvr <= 8'b00000000;
                                current_state <= S_RST_START;
                            end else if (btns[0]) begin // top
                                dar <= spr + 1;
                                address <= dar;
                                cs <= 1'b1;
                                we <= 1'b0;
                                current_state <= S_MEM_WAIT;
                            end
                            else current_state <= S_IDLE;
                        end
                        2'b11: begin                    // DEC/INC MODE
                            if (btns[1]) begin          // dec addr
                                dar <= dar - 1;
                                address <= dar;
                                cs <= 1'b1;
                                we <= 1'b0;
                                current_state <= S_MEM_WAIT;
                            end else if (btns[0]) begin // inc addr
                                dar <= dar + 1;
                                address <= dar;
                                cs <= 1'b1;
                                we <= 1'b0;
                                current_state <= S_MEM_WAIT;
                            end
                            else current_state <= S_IDLE;
                        end
                        default: begin
                            current_state <= S_IDLE;
                        end
                    endcase
                end
=======
                    end
                    2'b10: begin                    // CLEAR/TOP MODE
                        if (btns[1]) begin          // clear/rst
                            next_state = S_RST_START;
                        end else if (btns[0]) begin // top
                            next_state = S_TOP;
                        end
                    end
                    2'b11: begin                    // DEC/INC MODE
                        if (btns[1]) begin          // dec addr
                            next_state = S_DEC;
                        end else if (btns[0]) begin // inc addr
                            next_state = S_INC;
                        end
                    end
                    default: begin
                        next_state = S_IDLE;
                    end
                endcase
>>>>>>> Stashed changes
            end
            
            S_RST_START: begin
               dar=0;
               dvr=0;
               led_hold=1;
               stack_ptr=127;
               next_state = S_IDLE;
            end
            
            S_PUSH_START: begin
<<<<<<< Updated upstream
                we <= 1'b0;
                cs <= 1'b1;
                address <= dar;
                current_state <= S_MEM_WAIT;
            end
            
            S_ADD_START: begin
                cs <= 1'b1;
                we <= 1'b0;
                spr <= spr + 1;
                address <= spr + 1;
                current_state <= S_ADD_1;
=======
                led_hold=0;
                address=current_spr;
                dar=current_spr;
                we=1;
                next_state = S_PUSH_1;
            end
            
            S_PUSH_1: begin
               we=1;
               data_out=swtchs;
               dvr=swtchs;
               stack_ptr=current_spr-1;
               next_state = S_IDLE;
            end
            
            S_ADD_START: begin
                we = 1'b0;
                stack_ptr = current_spr + 1;
                address = current_spr + 1;
                next_state = S_ADD_1;
>>>>>>> Stashed changes
            end
            
            S_ADD_1: begin
                op_1 <= data_in;
                
<<<<<<< Updated upstream
                cs <= 1'b1;
                we <= 1'b0;
                spr <= spr + 1;
                address <= spr + 1;
                current_state <= S_ADD_2;
=======
                stack_ptr = current_spr + 1;
                address = current_spr + 1;
                next_state = S_ADD_2;
>>>>>>> Stashed changes
            end
            
            S_ADD_2: begin
                op_2 <= data_in;
                data_out <= op_1 + op_2;
                                
<<<<<<< Updated upstream
                we <= 1'b1;
                cs <= 1'b1;
                address <= spr;
                current_state <= S_ADD_3;
            end
            
            S_ADD_3: begin
                we <= 1'b0;
                cs <= 1'b1;
                spr <= spr + 1;
                dar <= spr + 1;
                address <= dar;
                current_state <= S_MEM_WAIT;
            end
            
            S_SUB_START: begin
                spr <= spr + 1;
                dar <= spr + 1;
                cs <= 1'b1;
                we <= 1'b0;
                address <= dar;
                current_state <= S_SUB_1;
            end
            
            S_SUB_1: begin
                op_2 <= data_in;
                spr <= spr + 1;
                dar <= spr + 1;
                cs <= 1'b1;
                we <= 1'b0;
                address <= dar;
                current_state <= S_SUB_2;
            end
            
            S_SUB_2: begin
                op_1 <= data_in;
                spr <= spr - 1;
                cs <= 1'b1;
                we <= 1'b1;
                address <= spr;
                data_out <= op_1 - op_2;
                current_state <= S_SUB_3;
            end
            
            S_SUB_3: begin
                we <= 1'b0;
                dar <= spr + 1;
                address <= dar;
                cs <= 1'b1;
                current_state <= S_MEM_WAIT;
            end
=======
                we = 1'b1;
                stack_ptr = current_spr + 1;
                address = current_spr;
                dar = current_dar + 1;
                dvr = data_out;
                next_state = S_IDLE;
            end
            
            /*S_ADD_3: begin
                we = 1'b0;
                cs = 1'b1;
                spr = spr + 1;
                dar = spr + 1;
                address = dar;
                state = S_MEM_WAIT;
            end*/
            
            S_SUB_START: begin
                stack_ptr = current_spr + 1;
                we = 1'b0;
                address = current_spr + 1;
                next_state = S_SUB_1;
            end
            
            S_SUB_1: begin
                op_2 = data_in;
                stack_ptr = current_spr + 1;
                address = current_spr + 1;
                next_state = S_SUB_2;
            end
            
            S_SUB_2: begin
                op_1 = data_in;
                address = stack_ptr;
                stack_ptr = stack_ptr - 1;
                data_out = op_1 - op_2;
                dar = current_dar + 1;
                dvr = data_out;
                next_state = S_SUB_3;
            end
            
            /*S_SUB_3: begin
                we = 1'b0;
                dar = spr + 1;
                address = dar;
                cs = 1'b1;
                state = S_MEM_WAIT;
            end*/
>>>>>>> Stashed changes
            
            S_MEM_WAIT: begin
                dvr <= data_in;
                current_state <= S_IDLE;
            end
            
            default: begin
                next_state = S_IDLE;
            end
            
            S_POP: begin
                address=current_spr;
                if(current_spr>=126)
                    led_hold=1;
                stack_ptr=current_spr+1;
                dar=current_dar-1;
                next_state = S_DEC_2;
            end
            
            S_TOP: begin
                dar=current_spr+1;
                we=0;
                next_state = S_TOP_1;
            end
            
            S_TOP_1: begin
                address=current_spr+1;
                next_state = S_TOP_2;
            end
            
            S_TOP_2: begin
                dvr=data_in;
                next_state = S_IDLE;
            end
            
            S_INC: begin
                we=0;
                dar=current_dar+1;
                next_state = S_INC_1;
            end
            
            S_INC_1: begin
                address=current_dar;
                next_state = S_IDLE;
            end
            
            S_DEC: begin
                we=0;
                dar=current_dar-1;
                next_state = S_DEC_1;
            end
            
            S_DEC_1: begin
                address=current_dar;
                next_state = S_DEC_2;
            end
            
            S_DEC_2: begin
                dvr=data_in;
                next_state = S_IDLE;
            end
           
        endcase
    end
    
<<<<<<< Updated upstream
    // always @(posedge clk) begin
    //     current_state <= next_state;
    // end

    always @(*) begin
        leds[7] <= (spr == 7'b1111111); // EMPTY flag
        leds[6:0] <= dar;
=======
    always @ (posedge clk)
    begin
        state<=next_state;
        current_dar<=dar;
        current_dvr<=dvr;
        current_spr<=stack_ptr;
        current_reg0<=register0;
        current_reg1<=register1;
>>>>>>> Stashed changes
    end
    
endmodule
