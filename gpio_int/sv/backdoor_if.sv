`ifndef BACKDOOR_IF__SV
`define BACKDOOR_IF__SV

interface backdoor_if(input clk_50m, input rstn_50m);

	// r_sh_mask0 : write & read
	function void poke_r_sh_mask0(input bit[`SK_W-1:0] value);
		`DUT.m_gpio_int_cfg.r_sh_mask0 = value;
	endfunction

	function void peek_r_sh_mask0(output bit[`SK_W-1:0] value);
		value = `DUT.m_gpio_int_cfg.r_sh_mask0;
	endfunction

	// r_info_mask0 : write & read
	function void poke_r_info_mask0(input bit[31:0] value);
		`DUT.m_gpio_int_cfg.r_info_mask0 = value;
	endfunction

	function void peek_r_info_mask0(output bit[31:0] value);
		value = `DUT.m_gpio_int_cfg.r_info_mask0;
	endfunction

	// r_info_mask1 : write & read
	function void poke_r_info_mask1(input bit[`INF_W-33:0] value);
		`DUT.m_gpio_int_cfg.r_info_mask1 = value;
	endfunction

	function void peek_r_info_mask1(output bit[`INF_W-33:0] value);
		value = `DUT.m_gpio_int_cfg.r_info_mask1;
	endfunction

	// r_err_mask0 : write & read
	function void poke_r_err_mask0(input bit[31:0] value);
		`DUT.m_gpio_int_cfg.r_err_mask0 = value;
	endfunction

	function void peek_r_err_mask0(output bit[31:0] value);
		value = `DUT.m_gpio_int_cfg.r_err_mask0;
	endfunction

	// r_err_mask1 : write & read
	function void poke_r_err_mask1(input bit[`ERR_W-33:0] value);
		`DUT.m_gpio_int_cfg.r_err_mask1 = value;
	endfunction

	function void peek_r_err_mask1(output bit[`ERR_W-33:0] value);
		value = `DUT.m_gpio_int_cfg.r_err_mask1;
	endfunction

endinterface

`endif
