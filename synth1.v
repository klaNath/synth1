/*
 *This HDL is top level module.
 *HDL depends on other modules.
 *It is
 *  spi_rx.v
 *  synth_arb.v
 *  operator.v
 *  -sine.v
 *   -diff_rom.v
 *   -sin_rom.v
 *  pwm_out.v
 *  fifo_tx.v(Altera QuartusII Megafunction IP dcfifo)
 *  pll.v(Altera QuartusII Megafunction IP altpll)
 *
 *External MicroController can controll module by 3wire-Serial interface like SPI(mode 0,0)
 *
 *Input Freq : 12.288MHz(XO or TCXO)
 *
 *PLL output Freq :
 *  C0 24.576MHz
 *  C1 196.608MHz
 */

module  synth1(
        input   wire        clk,
        input   wire        reset_n,
        input   wire        sdi,
        input   wire        sck,
        input   wire        ss_n,
        output  wire        pwm_out_l,
        output  wire        pwm_out_r,
        input   wire  [3:0] gnd);

/*Signal Declaration*/

  reg           clr_reg1, clr_reg2;
  wire          clr_n, wrreq, wwreq2arb, rdreq, full, empty, clk_int, clk_ext;
  wire  [20:0]  phase;
  wire  [15:0]  data_out;
  wire  [31:0]  data, fifo_in;
  wire  [7:0]   synth_ctrl, synth_data, memadrs, memdata;
  reg	  [7:0]	 clr_cnt = 8'h00;



/*End Declaration*/

/*Instantiation Modules*/

  synth_arb arbiter(
    .clk(clk_int),
    .reset_n(clr_n),
    .memadrs(memadrs),
    .memdata(memdata),
    .wreq(wrreq2arb),
    .synth_ctrl(synth_ctrl),
    .synth_data(synth_data),
    .fifo_full(full)
    );

  spi_rx spi_rx(
    .clk(clk_int),
    .reset_n(clr_n),
    .sdi(sdi),
    .sck(sck),
    .ss_n(ss_n),
    .adrs(memadrs),
    .data(memdata),
    .rx_valid(wrreq2arb));

    pwm_out pwm_out(
    .clk(clk_ext),
    .reset_n(clr_n),
    .fifo_rdreq(rdreq),
    .fifo_empty(empty),
    .fifo_data(data),
    .pwm_out_r(pwm_out_r),
    .pwm_out_l(pwm_out_l)
    );

  operator operator_1(
    .clk(clk_int),
    .reset_n(clr_n),
    .synth_ctrl(synth_ctrl),
    .synth_data(synth_data),
    .data_out(data_out),
    .wreq(wrreq));

  fifo_tx	fifo_tx (
	.aclr ( clr ),
	.data ( fifo_in ),
	.rdclk ( clk_ext ),
	.rdreq ( rdreq ),
	.wrclk ( clk_int ),
	.wrreq ( wrreq ),
	.q ( data ),
	.rdempty ( empty ),
	.wrfull ( full )
	);

  pll	pll (
	.inclk0 ( clk ),
	.c0 ( clk_int ),
	.c1 ( clk_ext )
	);



/*End Instantiation*/

/*Reset Logic*/

  assign clr_n = clr_reg2 | (~&clr_cnt);

  always @(posedge clk_int, negedge reset_n)
  begin
    if(!reset_n)
      begin
        clr_reg1 <= 0;
        clr_reg2 <= 0;
      end
    else
      begin
        clr_reg1 <= 1;
        clr_reg2 <= clr_reg1;
      end
  end

  always @(posedge clk_int)
  begin
    if(clr_cnt == 8'hFF) clr_cnt <= clr_cnt;
    else clr_cnt <= clr_cnt + 1;
  end

/*Assign*/

  assign fifo_in = {12'd0, gnd, data_out};
  assign clr = ~clr_n;

endmodule
