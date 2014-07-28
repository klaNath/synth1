module phase_ary(
  clk,
  reset_n, 
  phase_ctrl,
  phase_data,
  phase_out);
  
  
  input   wire          clk, reset_n;
  input   wire  [3:0]   phase_ctrl;
  input   wire  [15:0]  phase_data;
  output  wire  [20:0]  phase_out;
  
  reg   [20:0]  phase;
  reg   [15:0]  phase_add;
  
  assign  phase_out = phase;
  
  always @(posedge clk, negedge reset_n)
  begin
    if(!reset_n)
      begin
        phase <= 0;
        phase_add <= 0;
      end
    else if(phase_ctrl == 4'b0001)
      begin
        phase <= phase + phase_add;
        phase_add <= phase_add;
      end
    else if(phase_ctrl == 4'b1001)
      begin
        phase <= phase;
        phase_add <= phase_data;
      end
    else
      begin
        phase <= phase;
        phase_add <= phase_add;
      end
  end

endmodule