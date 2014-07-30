
module synth1_test();
  
  `timescale 1ns / 1ns
  
  reg         clk, reset_n, ss_n, sck_r;
  
  wire          sdi, sck;
  
  reg   [15:0]  shift_reg, add_reg;
  
  assign sdi = shift_reg[15];
  
  initial
  begin
    clk <= 0;
    reset_n <= 0;
    ss_n <= 0;
    sck_r <= 1;
    add_reg <= 16'h01AB;
    shift_reg <= 16'h01AB;
    #1000
    reset_n <= 1;
  end
  
  parameter CLOCK_INT = 20;
  
  always #(CLOCK_INT / 10) clk <= ~clk;
  always #(CLOCK_INT / 2 ) if(reset_n)sck_r <= ~sck_r;
  
  always @(posedge sck_r)
  begin
    if(!reset_n)
      begin
        shift_reg <= shift_reg;
      end
    else
      begin
        shift_reg <= {shift_reg[14:0], 1'b0};
     end
 end
  
synth1 s1(
        .clk(clk),
        .reset_n(reset_n),
        .sdi(sdi),
        .sck(sck_r),
        .ss_n(ss_n),
        .lrck(),
        .sdo(),
        .bck());
        
endmodule