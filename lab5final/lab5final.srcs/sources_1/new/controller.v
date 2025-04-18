module controller(clk, cs, we, address, data_in, data_out, btns, swtchs, leds, segs, an);
input clk;
output cs;
output reg we;
output reg[6:0] address=0;
input[7:0] data_in;
output reg [7:0] data_out;
input[3:0] btns;
input[7:0] swtchs;
output[7:0] leds;
output[6:0] segs;
output[3:0] an;
//WRITE THE FUNCTION OF THE CONTROLLER

reg [7:0] register0=0;
reg [7:0] register1=0;
reg [6:0] stack_ptr=127;
reg [6:0] dar=0;
reg [15:0] dvr=0;

reg led_hold;





reg [4:0] state=0;
reg [4:0] next_state=0;
reg [6:0] current_dar;
reg [15:0] current_dvr;
reg [6:0] current_spr;
reg [15:0] current_reg0;
reg [15:0] current_reg1;


time_multiplexing_main multi(clk,current_dvr,an,segs);
initial
begin
    stack_ptr=127;
    current_spr=127;
end

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
    
 case(state)
 5'b00000: begin //wait state
    
 end
 5'b00001: begin //enter
       
       led_hold=0;
       address=current_spr;
       dar=current_spr;
       we=1;
 end
  5'b00010: begin //enter
        we=1;
       data_out=swtchs;
       dvr=swtchs;
       stack_ptr=current_spr-1;
    
 end
 5'b00011: begin //delete
        address=current_spr;
        if(current_spr>=126)
            led_hold=1;
       stack_ptr=current_spr+1;
       dar=current_dar-1;
       
 end
 5'b00100: begin //add
    we=0;
    address=current_spr+1;
    stack_ptr=current_spr+1;
   
 end
 5'b00101: begin //add
    register0=data_in;
   
 
 end
 5'b00110: begin //add
    address=current_spr+1;
    stack_ptr=current_spr+1;
 
    register1=data_in;
  
    
 end
 5'b00111: begin //add
    //address<=stack_ptr;
      address=current_spr;
    stack_ptr=current_spr-1;
    we=1;
    data_out=current_reg0+current_reg1;
    dar=current_dar+1;
    dvr=current_reg0+current_reg1;
    //stack_ptr<=stack_ptr-1;
 end
 
  5'b01000: begin //sub
    we=0;
    address=current_spr+1;
    stack_ptr=current_spr+1;
    
 end
 5'b01001: begin //sub
    register0=data_in;

   
 end
 5'b01010: begin //sub
     address=current_spr+1;
    stack_ptr=current_spr+1;
 
    register1=data_in;

    
 end
 5'b01011: begin //sub
     address=current_spr;
    stack_ptr=current_spr-1;
 
    we=1;
    // address<=stack_ptr;
    data_out=current_reg1-current_reg0;
    dar=current_dar+1;
    dvr=current_reg1-current_reg0;
   // stack_ptr<=stack_ptr+1;
 end
  5'b01100: begin //top
       dar=current_spr+1;
       we=0;
 end
   5'b01101: begin //top
       address=current_spr+1;
 end
  5'b01110: begin //top
       dvr=data_in;
 end
   5'b01111: begin //clr
      
       dar=0;
       dvr=0;
       led_hold=1;
       stack_ptr=127;
 end
    5'b10000: begin //inc addr
        we=0;
        dar=current_dar+1;
 end
     5'b10001: begin //inc addr
        address=current_dar;
 end
      5'b10010: begin //inc addr
        dvr=data_in;
 end
     5'b10011: begin //dec addr
        we=0;
        dar=current_dar-1;
 end
     5'b10100: begin //dec addr
        address=current_dar;
 end
      5'b10101: begin //dec addr
        dvr=data_in;
 end
    5'b10110: begin
        dvr=data_in;
    end
 
 
endcase
end


always @ (*)
begin
case (state)
5'b00000: begin
next_state=0;
if (btns==1)
    next_state=1;
if (btns==2)
    next_state=3;
if (btns==5)
    next_state=4;
if(btns==6)
    next_state=8;
if (btns==9)
    next_state=12;
if (btns==10)
    next_state=15;
if (btns==13)
    next_state=16;
if (btns==14)
    next_state=19;
end
5'b00001: next_state=2;
5'b00010: next_state=0;
5'b00011: next_state=22;
5'b00100: next_state=5;
5'b00101: next_state=6;
5'b00110: next_state=7;
5'b00111: next_state=0;
5'b01000: next_state=9;
5'b01001: next_state=10;
5'b01010: next_state=11;
5'b01011: next_state=0;
5'b01100: next_state=13;
5'b01101: next_state=14;
5'b01110: next_state=0;
5'b01111: next_state=0;
5'b10000: next_state=17;
5'b10001: next_state=18;
5'b10010: next_state=0;
5'b10011: next_state=20;
5'b10100: next_state=21;
5'b10101: next_state=0;
5'b10110: next_state=0;
default : next_state=0;
endcase
end


always @ (posedge clk)
begin
    state<=next_state;
    current_dar<=dar;
    current_dvr<=dvr;
    current_spr<=stack_ptr;
    current_reg0<=register0;
    current_reg1<=register1;
end










endmodule