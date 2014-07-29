
module synth1_test();
  
  `timescale 1ns / 1ns
  
  reg         clk, reset_n;

  parameter CLOCK = 10;
  
  initial clk <= 0;
  
  always #(CLOCK / 2) clk = ~clk;  
  
  initial
  begin
    reset_n <= 0;
    #10
    reset_n <= 1;
  end
  
synth1 s1(
        .clk(clk),
        .reset_n(reset_n),
        .sck(),
        .ss_n(),
        .lrck(),
        .sdo(),
        .bck());
        
endmodule