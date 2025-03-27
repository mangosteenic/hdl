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
    //CHANGE THESE TWO LINES
    assign data_bus = (we) ? data_out_ctrl : 7'bz; // 1st driver of the data bus -- tri state switches
    // function of we and data_out_ctrl
    assign data_bus = (!we) ? data_out_mem : 7'bz; // 2nd driver of the data bus -- tri state switches
    // function of we and data_out_mem
    controller ctrl(clk, cs, we, addr, data_bus, data_out_ctrl,
    btns, swtchs, leds, segs, an);
    memory mem(clk, cs, we, addr, data_bus, data_out_mem);
    //add any other functions you need
    //(e.g. debouncing, multiplexing, clock-division, etc)
endmodule
