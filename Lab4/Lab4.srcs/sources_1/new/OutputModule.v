`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2025 07:52:27 PM
// Design Name: 
// Module Name: OutputModule
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

module OutputModule(
    input clk,
    input enable,
    input [15:0] in,
    output [3:0] an,
    output dp,
    output [6:0] sseg
    );

    // TODO: Binary to BCD conversion
    
    wire [6:0] in0, in1, in2, in3;
    wire slow_clk;
    // wire slow_clock_gate = slow_clk & enable;

    wire [3:0] bcd_1, bcd_2, bcd_3, bcd_4;
    bin_to_bcd bin_conv(clk, in, bcd_1, bcd_2, bcd_3, bcd_4);
    
    // Instantiate hexto7segment decoder
    hexto7segment c1 (.x(bcd_1), .out(in0));
    hexto7segment c2 (.x(bcd_2), .out(in1));
    hexto7segment c3 (.x(bcd_3), .out(in2));
    hexto7segment c4 (.x(bcd_4), .out(in3));
    
    // Instantiate clock divider
    clkdiv c5 (.clk(clk), .reset(reset), .clk_out_2pow(slow_clk));
    
    time_mux_state_machine c6(
        .clk(slow_clk),
        .enable(enable),
        .reset(reset),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .an(an),
        .dp(dp),
        .sseg(sseg)
    );
endmodule

module disp_out(
    input [3:0] hundredths,
    input [3:0] tenths,
    input [3:0] ones,
    input [3:0] tens,
    input clk,
    input rst,
    output [3:0] an,
    output dp,
    output [6:0] sseg
    );
    
    wire [15:0] intermediate;
    
    assign intermediate[15:12] = tens;
    assign intermediate[11:8] = ones;
    assign intermediate[7:4] = tenths;
    assign intermediate[3:0] = hundredths;

    time_multiplexing_main disp(
        .clk(clk),
        .reset(rst),
        .in(intermediate),
        .an(an),
        .dp(dp),
        .sseg(sseg)
    );

endmodule

module time_mux_state_machine(
    input clk,
    input enable,
    input reset,
    input [6:0] in0,
    input [6:0] in1,
    input [6:0] in2,
    input [6:0] in3,
    output reg [3:0] an,
    output reg dp,
    output reg [6:0] sseg
    );
    
    reg [1:0] state;
    reg [1:0] next_state;
    
    always @(*) begin // State Transition
        case(state)
            2'b00: next_state = 2'b01;
            2'b01: next_state = 2'b10;
            2'b10: next_state = 2'b11;
            2'b11: next_state = 2'b00;
        endcase
    end
    
    always @(*) begin // Multiplexer
        if(!enable) begin
            sseg <= 7'b1111111;
            an <= 7'b1111111;
            dp <= 7'b1111111;
        end
        else begin
            case(state)
                2'b00: sseg = in0;
                2'b01: sseg = in1;
                2'b10: sseg = in2;
                2'b11: sseg = in3;
            endcase
            
            case(state)
                2'b00: dp = 1'b1;
                2'b01: dp = 1'b1;
                2'b10: dp = 1'b0;
                2'b11: dp = 1'b1;
            endcase

            case(state) // Decoder
                2'b00: an = 4'b1110;
                2'b01: an = 4'b1101;
                2'b10: an = 4'b1011;
                2'b11: an = 4'b0111;
            endcase
        end
    end
    
    always @(posedge clk or posedge reset) begin
        if(reset)
            state <= 2'b00;
        else
            state <= next_state;
    end
    
endmodule

module hexto7segment(
    input [3:0] x,
    output [6:0] out
    );

    reg [6:0] r;

    always @(*) begin
        case(x)
            4'b0000 : r = 7'b0000001;
            4'b0001 : r = 7'b1001111;
            4'b0010 : r = 7'b0010010;
            4'b0011 : r = 7'b0000110;
            4'b0100 : r = 7'b1001100;
            4'b0101 : r = 7'b0100100;
            4'b0110 : r = 7'b0100000;
            4'b0111 : r = 7'b0001111;
            4'b1000 : r = 7'b0000000;
            4'b1001 : r = 7'b0000100;
            4'b1010 : r = 7'b0001000;
            4'b1011 : r = 7'b1100000;
            4'b1100 : r = 7'b0110001;
            4'b1101 : r = 7'b1000010;
            4'b1110 : r = 7'b0110000;
            4'b1111 : r = 7'b0111000;
        endcase
    end
    
    // Bit reversal
    genvar i;
    generate
        for(i=0; i<7; i = i + 1)
            assign out[i]=r[7-i-1];
    endgenerate

endmodule

module clkdiv(
    input clk,
    input reset,
    output clk_out_10div,
    output clk_out_2pow
    );
    // 25 for RED
    reg [63:0] COUNT1 = 64'b0;
    reg [63:0] COUNT2 = 64'b0;
    
    reg div_stat = 0;
    
    assign clk_out_2pow = COUNT1[10];
    assign clk_out_10div = div_stat;
    
    always @(posedge clk)
    begin
        if(reset) begin
            COUNT1 <= 0;
        end
        else begin
            COUNT1 <= COUNT1 + 1;
        end
        // 64'b000011110100001001000000 = 1M
        if(reset || COUNT2 == 64'b000001111010000100100000) begin //Divide by 1000000 for 100hz output
            COUNT2 <= 0;
            div_stat <= (div_stat ? 1'b0 : 1'b1);
        end
        else begin
            COUNT2 <= COUNT2 + 1;
        end
    end
endmodule