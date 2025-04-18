module top(clk, btns, swtchs, leds, segs, an);
input clk;
input[3:0] btns;
input[7:0] swtchs;
output[7:0] leds;
output[6:0] segs;
output[3:0] an;
//might need to change some of these from wires to regs
wire cs;
wire we;
wire[6:0] addr;
wire[7:0] data_out_mem;
wire[7:0] data_out_ctrl;
wire[7:0] data_bus;
wire [3:0] btns1;
wire out_clk;
//CHANGE THESE TWO LINES
assign data_bus = we ? data_out_ctrl : 8'bZ; // 1st driver of the data bus -- tri state switches
// function of we and data_out_ctrl
assign data_bus = we ? 8'bz: data_out_mem; // 2nd driver of the data bus -- tri state switches
// function of we and data_out_mem
controller ctrl(clk, cs, we, addr, data_bus, data_out_ctrl,
btns1, swtchs, leds, segs, an);
memory mem(clk, cs, we, addr, data_bus, data_out_mem);

debounce db0(btns[0],clk,btns1[0]);
debounce db1(btns[1],clk,btns1[1]);

assign btns1[3:2]=btns[3:2];

assign btns1=btns;

//add any other functions you need
//(e.g. debouncing, multiplexing, clock-division, etc)
endmodule