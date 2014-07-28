
module  synth_arb (
  clk,
  reset_n, 
  memadrs, 
  memdata, 
  wreq, 
  synth_ctrl,
  synth_data,
  fifo_full);
  
  input   wire        clk, reset_n, wreq, fifo_full;
  input   wire  [7:0] memadrs, memdata;
  output  reg   [7:0] synth_ctrl, synth_data;
  
          reg   [7:0] state_reg;
          reg   [3:0] wait_cnt;
          reg         wreq_inter, w_done;
          
  always @(posedge wreq, posedge w_done, negedge reset_n)
  begin
    if(reset_n == 0) wreq_inter <= 0;
    else if(w_done == 1) wreq_inter <= 0;
    else if(wreq == 1 && w_done != 1) wreq_inter <= 1;
  end
          
  always @(posedge clk, negedge reset_n)
  begin
    if(!reset_n)
    begin
      state_reg <= 0;
      synth_ctrl <= 0;
      synth_data <= 0;
      wait_cnt <= 0;
      w_done <= 0;
    end
    else
    begin
      case(state_reg)
        8'D0    : state_reg <= state_reg + 1;
        
        8'D1    : begin
                    if(wait_cnt != 4'b1111) wait_cnt <= wait_cnt + 1;
                    else  state_reg <= state_reg + 1;
                  end
                  
        8'D2    : begin
                    state_reg <= state_reg + 1;
                    synth_ctrl <= 8'b00000001;
                  end
                  
        8'D3    : begin
                    synth_ctrl <= 8'b00000000;
                    if(fifo_full != 1) state_reg <= state_reg + 1;
                    else state_reg <= state_reg; 
                  end
                  
        8'D4    : begin
                    state_reg <= state_reg + 1;
                    synth_ctrl <= 8'b10000001;
                  end
                  
        8'D5    : begin
                    state_reg <= state_reg + 1;
                    synth_ctrl <= 8'b00000000;
                  end
                  
        8'D6    : begin
                    if(wreq_inter == 1) state_reg <= state_reg + 1;
                    else state_reg <= 2;
                  end
                  
        8'D7    : begin
                    synth_data <= memdata;
                    synth_ctrl <= d2ctrl_synth(memadrs);
                    state_reg <= state_reg + 1;
                    w_done <= 1;
                  end
                  
        8'D8    : begin
                    state_reg <= 2;
                    synth_ctrl <= 8'b00000000;
                    w_done <= 0;
                  end
                 
        default : state_reg <= 0;     
      endcase
    end
  end
  
  function  [7:0] d2ctrl_synth;
    input [7:0] adrs;
    begin
      casex(adrs)
        8'b00000001 : d2ctrl_synth = 8'b01000001;
        8'b00010001 : d2ctrl_synth = 8'b00010001;
        8'b1000xxxx : d2ctrl_synth = 8'b00100000;
        default     : d2ctrl_synth = 0;
      endcase
    end
  endfunction
  
endmodule
      
          