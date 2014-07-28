/*
 *This HDL is top level module.
 *HDL depends on other modules. 
 *It is
 *  synth_arb.v
 *  sine.v
 *  -diff_rom.v
 *  -sin_rom.v
 *  lj24tx.v
 *
 *External MicroController can controll module by 3wire-Serial interface like SPI(mode 0,0)
 *Output data format is Left Justified 16bit Two-Complement data. 
 *It is based on PCM1741 default interface. 
 */

module  synth_top(
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
  wire          clr_n, wrreq, rdreq, full, empty;
  wire  [20:0]  phase;
  wire  [15:0]  sine_out;
  wire  [31:0]  data;
  wire  [7:0]   synth_ctrl, synth_data, memadrs, memdata;

  

/*End Declaration*/        
        
/*Instantiation Modules*/

  synth_arb arbiter(
    .clk(clk),
    .reset_n(clr_n), 
    .memadrs(memadrs), 
    .memdata(memdata), 
    .wreq(wrreq), 
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
    
  sine sine (
    .phase(phase),
    .sine_out(sine_out)
    );
    
  fifo_tx	fifo_tx (
	.aclr ( clr_n ),
	.data ( sine_out ),
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
  
  
  
endmodule