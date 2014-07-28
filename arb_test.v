`timescale 1ns/1ns


module arb_test();

  reg         clk, reset_n, wreq, fifo_full;
  reg   [7:0] memadrs, memdata;
  wire  [7:0] synth_ctrl, synth_data;
  
  reg   [7:0] test_state;
  reg   [7:0] wait_cnt;
  
  synth_arb arb1(
    .clk(clk),
    .reset_n(reset_n), 
    .memadrs(memadrs), 
    .memdata(memdata), 
    .wreq(wreq), 
    .synth_ctrl(synth_ctrl),
    .synth_data(synth_data),
    .fifo_full(fifo_full));
  
  parameter CLOCK = 10;
  
  initial clk <= 0;
  always #(CLOCK / 2) clk <= ~clk;
  
  initial test_state <= 0;
  initial reset_n <= 1;
  initial wreq <= 0;
  initial fifo_full <= 0;
  initial memadrs <= 0;
  initial memdata <= 0;
  initial wait_cnt <= 0;
  
  always @(posedge clk)
  begin
    case(test_state)
      8'D0  : test_state <= test_state + 1;
      
      8'D1  : begin
                test_state <= test_state + 1;
                reset_n <= 0;
              end
              
      8'D2  : begin
                test_state <= test_state + 1;
                reset_n <= 1;
              end
              
      8'D3  : begin //Normal Operation
                if(wait_cnt != 8'b11111111)
                begin
                  wait_cnt <= wait_cnt + 1;
                end
                else
                begin
                  wait_cnt <= 0;
                  test_state <= test_state + 1;
                end
              end
              
      8'D4  : begin //FIFO Full Operation Test
                if(wait_cnt != 8'b00001111)
                begin
                  wait_cnt <= wait_cnt + 1;
                  fifo_full <= 1;
                end
                else
                begin
                  wait_cnt <= 0;
                  fifo_full <= 0;
                  test_state <= test_state + 1;
                end
              end
              
      8'D5  : begin //Frequency Register Write Operation 1
                if(wait_cnt != 8'b00001111)
                begin
                  memadrs <= 8'h01;
                  memdata <= 8'h08;
                  wreq <= 1;
                  wait_cnt <= wait_cnt + 1;
                  test_state <= test_state;
                end
                else
                begin
                  memadrs <= 8'h00;
                  memdata <= 8'h00;
                  wreq <= 0;
                  test_state <= test_state + 1;
                  wait_cnt <= 0;
                end
              end
              
      8'D6  : begin
                wreq <= 0;
                test_state <= test_state + 1;
              end
              
      8'D7  : begin //Frequency Register Write Operation 2
                if(wait_cnt != 8'b00001111)
                begin
                  memadrs <= 8'h11;
                  memdata <= 8'h0A;
                  wreq <= 1;
                  wait_cnt <= wait_cnt + 1;
                  test_state <= test_state;
                end
                else
                begin
                  memadrs <= 8'h00;
                  memdata <= 8'h00;
                  wreq <= 0;
                  test_state <= test_state + 1;
                  wait_cnt <= 0;
                end
              end
             
      8'D8  : begin
                wreq <= 0;
                test_state <= test_state + 1;
              end
              
      8'D9  : test_state <= test_state;
      
      default : test_state <= 0;
    endcase
  end                
endmodule