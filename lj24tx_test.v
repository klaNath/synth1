`timescale 1ns/1ns

module lj24tx_test();
  
  reg           clk, reset_n, empty;
  reg   [31:0]  data;
  reg   [3:0]  test_state;
  reg   [7:0]   wait_cnt;
  
  wire          lrck, bck, sdo, rdreq;
  
  
  lj24tx lj24tx(
    .clk(clk),
    .reset_n(reset_n), 
    .fifo_rdreq(rdreq), 
    .fifo_empty(empty),
    .fifo_data(data),
    .lrck(lrck),
    .bck(bck),
    .data(sdo));
    
  initial
  begin
    clk <= 0;
    reset_n <= 1;
    empty <= 0;
    data <= 0;
    test_state <= 0;
    wait_cnt <= 0;
  end
  
  parameter CLOCK = 4;
  
  always #(CLOCK / 2) clk = ~clk;
  
  always @(posedge clk)
  begin
    case(test_state)
      4'd0  : begin
              reset_n <= 0;
              test_state <= test_state + 1;
              end
              
      4'd1  : begin
              if(wait_cnt != 8'b00001111)
                begin
                  test_state <= test_state;
                  wait_cnt <= wait_cnt + 1;
                end
              else
                begin
                  test_state <= test_state + 1;
                  wait_cnt <= 0;
                  reset_n <= 1;
                end
              end
              
      4'd2  : begin
              if(wait_cnt != 8'b01111111)
                begin
                  wait_cnt <= wait_cnt + 1;
                  test_state <= test_state;
                  if(empty == 1) data <= 0;
                  else if(rdreq == 1) data <= {24'd1024, wait_cnt};
                end
              else if(wait_cnt != 8'b11111111)
                begin
                  wait_cnt <= wait_cnt + 1;
                  test_state <= test_state;
                  empty <= 1;
                  if(empty == 1) data <= 0;
                  else if(rdreq == 1) data <= {24'd1024, wait_cnt};
                end
              else if(wait_cnt == 8'b11111111)
                begin
                  test_state <= test_state;
                  empty <= 0;
                  if(empty == 1) data <= 0;
                  else if(rdreq == 1) data <= {24'd1024, wait_cnt};
                end
              end
              
      default : test_state <= 0;
    endcase
  end
endmodule