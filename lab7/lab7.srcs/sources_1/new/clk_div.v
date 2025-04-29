module clk_div(clk100Mhz, slowClk);
  input clk100Mhz; //fast clock
  output slowClk; //slow clock

  reg[27:0] counter;
  assign slowClk= counter[22];  //(2^27 / 100E6) = 1.34seconds

  initial begin
    counter = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    counter <= counter + 1; //increment the counter every 10ns (1/100 Mhz) cycle.
  end

endmodule