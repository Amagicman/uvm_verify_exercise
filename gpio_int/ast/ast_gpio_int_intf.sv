`ifndef AST_GPIO_INT_INTF__SV
`define AST_GPIO_INT_INTF__SV

bind gpio_int_top_tb ast_gpio_int_intf
ast_gpio_int_intf_inst(
	.gpio_int_if0  (`TB_TOP.gpio_int_if0),
	.dbus_if0	   (`TB_TOP.dbus_if0)
);

module ast_gpio_int_intf(
	gpio_int_if gpio_int_if0,
	bus_if		dbus_if0
);

// system reset
property a_ast_gpio_int_intf_REST_CHK(CLK,RSTN,OUT,VAL='h0);
	@(posedge CLK)
	~RSTN |-> OUT == VAL;
endproperty

a_ast_gpio_int_intf_REST_CHK_0 : assert property(a_ast_gpio_int_intf_REST_CHK(gpio_int_if0.clk[0], gpio_int_if0.rstn_50m, gpio_int_if0.INTR));
a_ast_gpio_int_intf_REST_CHK_1 : assert property(a_ast_gpio_int_intf_REST_CHK(gpio_int_if0.clk[0], gpio_int_if0.rstn_50m, gpio_int_if0.INT_CODE));
a_ast_gpio_int_intf_REST_CHK_2 : assert property(a_ast_gpio_int_intf_REST_CHK(dbus_if0.clk_50m, dbus_if0.rstn_50m, dbus_if0.o_datout_50m));

// Bus write
property a_ast_gpio_int_intf_data_csn_wr(CLK,RSTN,BUS_WR,CS_N,VALID);
	@(posedge CLK)
	$fell(CS_N) && BUS_WR |=> VALID==1'b1;
endproperty

a_ast_gpio_int_intf_data_csn_wr_0 : assert property(a_ast_gpio_int_intf_data_csn_wr(dbus_if0.clk_50m,dbus_if0.rstn_50m,dbus_if0.i_wr_50m,dbus_if0.i_csn_50m,dbus_if0.wr_valid));

// Bus read
property a_ast_gpio_int_intf_data_csn_rd(CLK,RSTN,BUS_RD,CS_N,VALID);
	@(posedge CLK)
	$fell(CS_N) && BUS_RD |=> ##6 VALID==1'b1;
endproperty

a_ast_gpio_int_intf_data_csn_rd_0 : assert property(a_ast_gpio_int_intf_data_csn_rd(dbus_if0.clk_50m,dbus_if0.rstn_50m,dbus_if0.i_rd_50m,dbus_if0.i_csn_50m,dbus_if0.rd_valid));

// interrupt shakehand
property a_ast_gpio_int_intf_shakehand(CLK,RSTN,INTR,INTA_N);
	@(posedge CLK)
	($fell(INTA_N) && (INTR)) || ($fell(INTA_N) && $rose(INTR)) || (~INTA_N) && $rose(INTR) |=> INTR==1'b0;
endproperty

a_ast_gpio_int_intf_shakehand_0 : assert property(a_ast_gpio_int_intf_shakehand(gpio_int_if0.clk[0],gpio_int_if0.rstn_50m,gpio_int_if0.INTR,gpio_int_if0.INTA_N));
	
endmodule

`endif
