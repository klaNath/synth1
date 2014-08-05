module dsm_test();

	reg		clk, reset_n;
	reg	[15:0]	data;
	wire		outsignal, rdreq;

dsm dsm(
	.clk(clk),
	.reset_n(reset_n),
	.data_in(data),
	.outsignal(outsignal),
	.rdreq(rdreq));

parameter CLOCK = 2;

initial
begin
	clk <= 0;
	reset_n <= 0;
	data <= 0;
#50
	reset_n <= 1;
	data <= 16'sd456;
#5000
	data <= 16'sd10000;
#5000
	data <= 16'sd30000;
#5000
	data <= 16'sh80F0;
#5000
	data <= 0;
end

always #(CLOCK / 2) clk <= ~clk;

endmodule
