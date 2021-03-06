
`timescale 1ns/1ns

module sine_test();

reg     [20:0]  phase_21;
reg     signed  [15:0]  sine_out_reg;

reg     clk;
wire    signed  [15:0]  sine_out;

parameter CLOCK = 10;

sine s1(
        .phase(phase_21),
        .sine_out(sine_out));

initial clk <= 0;
always #(CLOCK / 2)
clk <= ~clk;

initial phase_21 <= 0;
initial sine_out_reg <= 0;

always @(posedge clk)
begin
        phase_21 <= phase_21 + 21'd307582;
        sine_out_reg <= sine_out;
end

endmodule


