`ifndef COV_GPIO_INT_TR__SV
`define COV_GPIO_INT_TR__SV

class cov_gpio_int_seq;

	event sample_tr_evt;
	gpio_int_sequence_item tr;

	covergroup cg_gpio_int_intr@(sample_tr_evt);
		cp_gpio_int_type : coverpoint tr.int_bit {
			bins int_bit_type[64] = {[0:`INT_NUM-1]};
		}

		cp_gpio_int_trig : coverpoint tr.trig {
			bins int_trig_type[2] = {LEVEL, EDGE};
		}

		cross_int_bit_trig : cross cp_gpio_int_type, cp_gpio_int_trig;
	endgroup

	string name;
	function new(string name);
		cg_gpio_int_intr = new();
		cg_gpio_int_intr.set_inst_name({"cg_gpio_int_intr.", name});
	endfunction

	task sample_tr(const ref gpio_int_sequence_item tr_cov);
		tr = tr_cov;
		-> sample_tr_evt;
	endtask

endclass : cov_gpio_int_seq

class cov_gpio_int_mtr;

	event sample_rd_return_evt;
	gpio_int_mon_transfer mtr;

	covergroup cg_rd_return@(sample_rd_return_evt);
		cp_rd_int_code : coverpoint mtr.INT_CODE {
			bins int_code[64] = {[0:`INT_NUM-1]};
		}
	endgroup

	string name;
	function new(string name);
		cg_rd_return = new();
		cg_rd_return.set_inst_name({"cg_rd_return.", name});
	endfunction

	function void sample_tr(const ref gpio_int_mon_transfer mtr_cov);
		mtr = mtr_cov;
		-> sample_rd_return_evt;
	endfunction

endclass : cov_gpio_int_mtr

`endif
