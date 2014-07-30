
module operator(
  clk,
  reset_n, 
  synth_ctrl, 
  synth_data, 
  data_out, 
  wreq);
  
  input   wire          clk, reset_n;
  input   wire  [7:0]   synth_data, synth_ctrl;
  output  wire          wreq;
  output  wire  [15:0]  data_out;

          wire  [15:0]  sine_out;
          wire  [20:0]  phase;
          
          reg   [20:0]  phase_1;
          reg   [31:0]  accum_1;
          reg   [23:0]  add_1;
          reg   [7:0]   p_synth_ctrl;
          reg           wreq_r, wr_now;
  
  assign  data_out = accum_1[15:0];
  assign  phase = phase_1;
  assign  wreq = wreq_r;
  
  always @(posedge clk, negedge reset_n)
  begin
    if(!reset_n)
      begin
        phase_1 <= 0;
        accum_1 <= 0;
        add_1 <= 0;
        wreq_r <= 0;
        wr_now <= 0;
      end
    else
      begin
        p_synth_ctrl <= synth_ctrl;
        case(synth_ctrl)
          8'b00000001 : phase_1 <= phase_1 + add_1;
          8'b10000001 : wreq_r <= 1;
          8'b01000001 : begin
                          add_1[7:0] <= synth_data;
                          wr_now <= 1;
                        end
          8'b00010001 : add_1[15:8] <= synth_data;
          8'b01010001 : begin
                          add_1[23:16] <= synth_data;
                          wr_now <= 0;
                        end
          8'b00100000 : begin
                          phase_1 <= 0;
                          accum_1 <= 0;
                          add_1 <= 0;
                          wreq_r <= 0;
                          wr_now <= 0;
                        end
          default     : phase_1 <= phase_1;
        endcase
        case(p_synth_ctrl)
          8'b00000001 : accum_1 <= sine_out;
          8'b10000001 : wreq_r <= 0;
        endcase
      end
  end
  
  sine sine(
    .phase(phase),
    .sine_out(sine_out));
    
endmodule