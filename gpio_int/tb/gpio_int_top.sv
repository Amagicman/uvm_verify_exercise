`timescale 1ps/1ps
`include "uvm_macros.svh"

`include "gpio_int_define.sv"
`include "gpio_int_if.sv"
`include "bus_if.sv"
`include "backdoor_if.sv"

module gpio_int_top_tb;
	event drv2dut_complete_event;

	import uvm_pkg::*;
	`include "gpio_int_sequence_item.sv"
	`include "gpio_int_mon_transfer.sv"
	`include "gpio_int_sequencer.sv"
	`include "../cov/cov_gpio_int_tr.sv"
	`include "gpio_int_driver.sv"
	`include "gpio_int_monitor.sv"
	`include "gpio_int_agent.sv"
	`include "bus_transaction.sv"
	`include "bus_sequencer.sv"
	`include "bus_driver.sv"
	`include "bus_monitor.sv"
	`include "bus_agent.sv"
	`include "reg_model.sv"
	`include "gpio_int_adapter.sv"
	`include "gpio_int_model.sv"
	`include "gpio_int_scoreboard.sv"
	`include "gpio_int_env.sv"
	`include "gpio_int_vsqr.sv"
	`include "gpio_int_seq_lib.sv"
	`include "gpio_int_bus_seq_lib.sv"
	`include "gpio_int_virtual_seq_lib.sv"
	`include "base_test.sv"
	`include "gpio_int_case.svh"

	wire [0:6] clk;
	reg rstn_50m;
	reg clk_cpu,clk_50m,clk_100m,clk_200m,clk_400m,I_IT_RX_IFCLK,I_OT_RX_IFCLK;

	assign	clk = {clk_cpu, clk_50m, clk_100m, clk_200m, clk_400m, I_IT_RX_IFCLK, I_OT_RX_IFCLK};

	gpio_int_if gpio_int_if0(clk, rstn_50m);
	bus_if dbus_if0(clk[1], rstn_50m);
	backdoor_if bk_if0(clk[1], rstn_50m);

	gpio_int gpio_int_dut(
		.clk_cpu                 (clk[0]                            ),
		.clk_50m                 (clk[1]                            ),
		.clk_100m                (clk[2]                            ),
		.clk_200m                (clk[3]                            ),
		.clk_400m                (clk[4]                            ),
		.I_IT_RX_IFCLK           (clk[5]                            ),
		.I_OT_RX_IFCLK           (clk[6]	                        ),
		.rstn_50m                (rstn_50m                          ),

		.INTA_N                  (gpio_int_if0.INTA_N               ),

		.lbus_err_int_cpu        (gpio_int_if0.int_err_lbus	        ),
		.spi_err_int_50m         (gpio_int_if0.int_err_50m          ),
		.mg_err_int_200m         (gpio_int_if0.int_err_200m[2]      ),
		.ia2xg_err_int_200m      (gpio_int_if0.int_err_200m[1]      ),
		.oa2xg_err_int_200m      (gpio_int_if0.int_err_200m[0]      ),
		.ns_asip_err_int_400m    (gpio_int_if0.int_err_400m[38]     ),
		.pcm_asip_err_int_400m   (gpio_int_if0.int_err_400m[37]     ),
		.dmolbus_err_int_400m    (gpio_int_if0.int_err_400m[36]     ),
		.ns_peri_err_int_400m    (gpio_int_if0.int_err_400m[35]     ),
		.pcm_peri_err_int_400m   (gpio_int_if0.int_err_400m[34]     ),
		.ibufd_err_int_400m      (gpio_int_if0.int_err_400m[33]     ),
		.itcam_err_int_400m      (gpio_int_if0.int_err_400m[32]     ),
		.icfg_err_int_400m       (gpio_int_if0.int_err_400m[31]     ),
		.inif_err_int_400m       (gpio_int_if0.int_err_400m[30]     ),
		.ienif_err_int_400m      (gpio_int_if0.int_err_400m[29]     ),
		.iama1_err_int_400m      (gpio_int_if0.int_err_400m[28]     ),
		.iama2_err_int_400m      (gpio_int_if0.int_err_400m[27]     ),
		.iamf_err_int_400m       (gpio_int_if0.int_err_400m[26]     ),
		.isec_err_int_400m       (gpio_int_if0.int_err_400m[25]     ),
		.isch_err_int_400m       (gpio_int_if0.int_err_400m[24]     ),
		.isram_err_int_400m      (gpio_int_if0.int_err_400m[23]     ),
		.iqos0_err_int_400m      (gpio_int_if0.int_err_400m[22]     ),
		.iqos1_err_int_400m      (gpio_int_if0.int_err_400m[21]     ),
		.iminsch_err_int_400m    (gpio_int_if0.int_err_400m[20]     ),
		.imeter_err_int_400m     (gpio_int_if0.int_err_400m[19]     ),
		.obufd_err_int_400m      (gpio_int_if0.int_err_400m[18]     ),
		.otcam_err_int_400m      (gpio_int_if0.int_err_400m[17]     ),
		.ocfg_err_int_400m       (gpio_int_if0.int_err_400m[16]     ),
		.onif_err_int_400m       (gpio_int_if0.int_err_400m[15]     ),
		.oenif_err_int_400m      (gpio_int_if0.int_err_400m[14]     ),
		.oama1_err_int_400m      (gpio_int_if0.int_err_400m[13]     ),
		.oama2_err_int_400m      (gpio_int_if0.int_err_400m[12]     ),
		.oamf_err_int_400m       (gpio_int_if0.int_err_400m[11]     ),
		.osec_err_int_400m       (gpio_int_if0.int_err_400m[10]     ),
		.osch_err_int_400m       (gpio_int_if0.int_err_400m[9]      ),
		.osram_err_int_400m      (gpio_int_if0.int_err_400m[8]      ),
		.oqos0_err_int_400m      (gpio_int_if0.int_err_400m[7]      ),
		.oqos1_err_int_400m      (gpio_int_if0.int_err_400m[6]      ),
		.ominsch_err_int_400m    (gpio_int_if0.int_err_400m[5]      ),
		.ometer_err_int_400m     (gpio_int_if0.int_err_400m[4]      ),    
		.alg_err_int_400m        (gpio_int_if0.int_err_400m[3]      ),
		.jcon_err_int_400m       (gpio_int_if0.int_err_400m[2]      ),
		.dmspi_err_int_400m      (gpio_int_if0.int_err_400m[1]      ),
		.dmilbus_err_int_400m    (gpio_int_if0.int_err_400m[0]      ),

		.itcam_check_int_rclk    (gpio_int_if0.int_info_300m[1]     ),
		.otcam_check_int_rclk    (gpio_int_if0.int_info_300m[0]     ),
		.xi_link_int             (gpio_int_if0.int_info_xaui[5]     ),
		.xo_link_int             (gpio_int_if0.int_info_xaui[4]     ),
		.xa_link_int             (gpio_int_if0.int_info_xaui[3]     ),
		.xb_link_int             (gpio_int_if0.int_info_xaui[2]     ),
		.xc_link_int             (gpio_int_if0.int_info_xaui[1]     ),
		.xd_link_int             (gpio_int_if0.int_info_xaui[0]     ),
		.crm_rst_done_50m        (gpio_int_if0.int_info_50m[2]      ),
		.spi_ill_int_50m         (gpio_int_if0.int_info_50m[1]      ),
		.spi_load_int_50m        (gpio_int_if0.int_info_50m[0]      ),
		.ns_sw_int_400m          (gpio_int_if0.int_info_400m[38:23] ),
		.ns_otm_int_400m         (gpio_int_if0.int_info_400m[22]    ),
		.ns_check_int_400m       (gpio_int_if0.int_info_400m[21]    ),
		.pcm_sw_int_400m         (gpio_int_if0.int_info_400m[20:5]  ),
		.pcm_check_int_400m      (gpio_int_if0.int_info_400m[4]     ),
		.iama1_normal_int_400m   (gpio_int_if0.int_info_400m[3]     ),
		.iama2_normal_int_400m   (gpio_int_if0.int_info_400m[2]     ),
		.oama1_normal_int_400m   (gpio_int_if0.int_info_400m[1]     ),
		.oama2_normal_int_400m   (gpio_int_if0.int_info_400m[0]     ),

		.spi_ctrl_int_50m        (gpio_int_if0.int_shake_50m        ),
		.ibufd_ctrl_int          (gpio_int_if0.int_shake_bufd[1]    ),
		.obufd_ctrl_int          (gpio_int_if0.int_shake_bufd[0]    ),
		.xi_sbd_int              (gpio_int_if0.int_shake_100m[11]   ),
		.xo_sbd_int              (gpio_int_if0.int_shake_100m[10]   ),
		.xa_sbd_int              (gpio_int_if0.int_shake_100m[9]    ),
		.xb_sbd_int              (gpio_int_if0.int_shake_100m[8]    ),
		.xc_sbd_int              (gpio_int_if0.int_shake_100m[7]    ),
		.xd_sbd_int              (gpio_int_if0.int_shake_100m[6]    ),
		.xi_pma_int              (gpio_int_if0.int_shake_100m[5]    ),
		.xo_pma_int              (gpio_int_if0.int_shake_100m[4]    ),
		.xa_pma_int              (gpio_int_if0.int_shake_100m[3]    ),
		.xb_pma_int              (gpio_int_if0.int_shake_100m[2]    ),
		.xc_pma_int              (gpio_int_if0.int_shake_100m[1]    ),
		.xd_pma_int              (gpio_int_if0.int_shake_100m[0]    ),

		.INTR                    (gpio_int_if0.INTR                 ),
		.INT_CODE                (gpio_int_if0.INT_CODE             ),

		.i_csn_50m               (dbus_if0.i_csn_50m                ),
		.i_wr_50m                (dbus_if0.i_wr_50m                 ),
		.i_rd_50m                (dbus_if0.i_rd_50m                 ),
		.i_addr_50m              (dbus_if0.i_addr_50m               ),
		.i_datin_50m             (dbus_if0.i_datin_50m              ),
		.o_datout_50m            (dbus_if0.o_datout_50m             )

	);

	localparam PERIOD_400M = 2500;
	localparam PERIOD_300M = 3333;
	localparam PERIOD_200M = 5000;
	localparam PERIOD_100M = 10000;
	localparam PERIOD_50M  = 20000;
	localparam PERIOD_CPU  = 20000;
	// gen clock
	initial begin
		clk_cpu = 1'b0;
		clk_50m = 1'b0;
		clk_100m = 1'b0;
		clk_200m  = 1'b0;
		I_IT_RX_IFCLK  = 1'b0;
		I_OT_RX_IFCLK  = 1'b0;
		clk_400m = 1'b0;

		fork
			#($urandom_range(0,PERIOD_CPU)) forever #(PERIOD_CPU/2)  clk_cpu  = ~clk_cpu  ;
			#($urandom_range(0,PERIOD_CPU)) forever #(PERIOD_400M/2) clk_400m = ~clk_400m ;
			#($urandom_range(0,PERIOD_CPU)) forever #(PERIOD_200M/2) clk_200m = ~clk_200m ;
			#($urandom_range(0,PERIOD_CPU)) forever #(PERIOD_100M/2) clk_100m = ~clk_100m ;
			#($urandom_range(0,PERIOD_CPU)) forever #(PERIOD_50M/2)  clk_50m  = ~clk_50m ;
			#($urandom_range(0,PERIOD_CPU)) forever #(PERIOD_300M/2) I_IT_RX_IFCLK = ~I_IT_RX_IFCLK; 
			#($urandom_range(0,PERIOD_CPU)) forever #(PERIOD_300M/2) I_OT_RX_IFCLK = ~I_OT_RX_IFCLK ;
		join
	end

	// gen rst op
	initial begin
		rstn_50m = 1'b1;
		#(PERIOD_50M*2) rstn_50m = 1'b0;
		#(PERIOD_50M*2) rstn_50m = 1'b1;
	end

	initial begin
		run_test();
	end

	initial begin
		uvm_config_db#(virtual gpio_int_if)::set(null, "uvm_test_top.env.i_agt.drv", "vif", gpio_int_if0);
		uvm_config_db#(virtual gpio_int_if)::set(null, "uvm_test_top.env.i_agt.mon", "vif", gpio_int_if0);
		uvm_config_db#(virtual bus_if)::set(null, "uvm_test_top.env.bus_agt.drv", "vif", dbus_if0);
		uvm_config_db#(virtual bus_if)::set(null, "uvm_test_top.env.bus_agt.mon", "vif", dbus_if0);
		uvm_config_db#(virtual backdoor_if)::set(null, "uvm_test_top", "vif", bk_if0);
		uvm_config_db#(virtual backdoor_if)::set(null, "uvm_test_top.env.mdl", "vif", bk_if0);
	end

	//initial begin
	//   $dumpfile("top_tb.vcd");
	//   $dumpvars(0, gpio_int_top_tb);
	//end

	initial begin
		$shm_open("top_tb.shm");
		$shm_probe("AST");
	end

endmodule
