/*
 *This HDL is top level module.
 *HDL depends on other modules. 
 *It is
 *  synth_arb.v
 *  operator.v
 *  -sine.v
 *   -diff_rom.v
 *   -sin_rom.v
 *  lj24tx.v
 *  fifo_tx.v(Altera QuartusII Megafunction IP dcfifo)
 *
 *External MicroController can controll module by 3wire-Serial interface like SPI(mode 0,0)
 *Output data format is Left Justified 16bit Two-Complement data. 
 *It is based on PCM1741 default interface. 
 */

module  synth1(
        input   wire        clk,
        input   wire        reset_n, 
        input   wire        sdi, 
        input   wire        sck,
        input   wire        ss_n,
        output  wire        lrck,
        output  wire        sdo,
        output  wire        bck);
        
/*Signal Declaration*/

  reg           clr_reg1, clr_reg2;
  wire          clr_n, wrreq, wwreq2arb, rdreq, full, empty;
  wire  [20:0]  phase;
  wire  [15:0]  data_out;
  wire  [31:0]  data, fifo_in;
  wire  [7:0]   synth_ctrl, synth_data, memadrs, memdata;

  

/*End Declaration*/        
        
/*Instantiation Modules*/

  synth_arb arbiter(
    .clk(clk),
    .reset_n(clr_n), 
    .memadrs(memadrs), 
    .memdata(memdata), 
    .wreq(wrreq2arb), 
    .synth_ctrl(synth_ctrl),
    .synth_data(synth_data),
    .fifo_full(full)
    );
    
  lj24tx lj24tx(
    .clk(clk),
    .reset_n(clr_n), 
    .fifo_rdreq(rdreq), 
    .fifo_empty(empty),
    .fifo_data(data),
    .lrck(lrck),
    .bck(bck),
    .data(sdo)
    );
    
  operator operator_1(
    .clk(clk),
    .reset_n(clr_n), 
    .synth_ctrl(synth_ctrl), 
    .synth_data(synth_data), 
    .data_out(data_out), 
    .wreq(wrreq));
    
  fifo_tx	fifo_tx (
	.aclr ( clr ),
	.data ( fifo_in ),
	.rdclk ( clk ),
	.rdreq ( rdreq ),
	.wrclk ( clk ),
	.wrreq ( wrreq ),
	.q ( data ),
	.rdempty ( empty ),
	.wrfull ( full )
	);
  

/*End Instantiation*/

/*Reset Logic*/

  assign clr_n = clr_reg2;

  always @(posedge clk, negedge reset_n)
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
  
/*Assign*/

  assign fifo_in = {16'd0, data_out};
  assign clr = ~clr_n;
  
endmodule