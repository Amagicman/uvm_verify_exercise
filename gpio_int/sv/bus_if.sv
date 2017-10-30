`ifndef BUS_IF__SV
`define BUS_IF__SV

interface bus_if(input clk_50m, input rstn_50m);

	logic				i_csn_50m;
	logic				i_wr_50m;
	logic				i_rd_50m;
	logic	[23:0]		i_addr_50m;
	logic	[31:0]		i_datin_50m;
	logic	[31:0]		o_datout_50m;

	logic				rd_valid;
	logic				wr_valid;

endinterface

`endif
