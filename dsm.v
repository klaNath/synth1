module dsm(
	clk,
	reset_n,
	outsignal,
	data_in,
	rdreq,
	empty);

input	wire		clk, reset_n, empty;
input	wire	[15:0]	data_in;
output	wire		rdreq, outsignal;

	wire	[15:0]	feedback;
	reg	[15:0]	accum_1;
	reg	[6:0]	add_cnt;
	reg		rdreq_r;

	assign	rdreq = rdreq_r & ~empty;
	assign	outsignal = accum_1[15];
	assign	feedback = (accum_1[15] == 0)? 16'h8001 : 16'h7FFF;

	always @(posedge clk)
	begin
		if(!reset_n)
		begin
			accum_1 <= 0;
			add_cnt <= 0;
			rdreq_r <= 0;
		end
		else if(add_cnt == 7'h0)
		begin
			add_cnt <= add_cnt + 1;
			accum_1 <= accum_1 + feedback;
			rdreq_r <= 1;
		end
		else if(add_cnt == 7'h1)
		begin
			add_cnt <= add_cnt + 1;
			accum_1 <= accum_1 + feedback;
			rdreq_r <= 0;
		end
		else if(add_cnt == 7'h2)
		begin
			add_cnt <= add_cnt + 1;
			accum_1 <= accum_1 + feedback + data_in;
		end
		else
		begin
			add_cnt <= add_cnt + 1;
			accum_1 <= accum_1 + feedback;
		end
	end

endmodule

