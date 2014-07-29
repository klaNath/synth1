
module spi_rx_test();
  
  reg           clk, reset_n, ss_n;
  wire  [7:0]   data, adrs;
  wire          valid, sdi;
  
  reg   [15:0]  shift_reg;
  
  assign sdi = shift_reg[15];
  
  initial
  begin
    clk <= 0;
    reset_n <= 0;
    ss_n <= 0;
    shift_reg <= 16'h51AB;
    #21
    reset_n <= 1;
  end
  
  parameter CLOCK_INT = 10;
  
  always #(CLOCK_INT / 2) clk <= ~clk;
  
  always @(posedge clk)
  begin
    if(!reset_n)
      begin
        shift_reg <= shift_reg;
      end
    else
      begin
        shift_reg <= {shift_reg[14:0], shift_reg[15]};
     end
 end
  
    
         
  spi_rx spi_rx(
  .clk(clk), 
  .reset_n(reset_n),
  .sdi(sdi),
  .sck(clk),
  .ss_n(ss_n),
  .adrs(adrs),
  .data(data),
  .rx_valid(valid));
  
endmodule
