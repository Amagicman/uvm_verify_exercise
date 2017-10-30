`ifndef REG_MODEL
`define REG_MODEL

//r_sh_mask0
class r_sh_mask0_c extends uvm_reg;

	rand uvm_reg_field mask_val;

	virtual function void build();
		mask_val = uvm_reg_field::type_id::create("mask_val");
		mask_val.configure(this, `SK_W, 0, "RW", 0, 0, 1, 1, 1);
		wr_cg.set_inst_name($sformatf("%s.wcov", get_full_name()));
		rd_cg.set_inst_name($sformatf("%s.rcov", get_full_name()));
	endfunction

	covergroup wr_cg;
		option.per_instance = 1;
		mask_val : coverpoint mask_val.value[`SK_W-1:0];
	endgroup
	covergroup rd_cg;
		option.per_instance = 1;
		mask_val : coverpoint mask_val.value[`SK_W-1:0];
	endgroup

	protected virtual function void sample(uvm_reg_data_t data, byte_en, bit is_read, uvm_reg_map map);
		super.sample(data, byte_en, is_read, map);
		if(!is_read) wr_cg.sample();
		if(is_read) rd_cg.sample();
	endfunction

	`uvm_register_cb(r_sh_mask0_c, uvm_reg_cbs)
	`uvm_set_super_type(r_sh_mask0_c, uvm_reg)
	`uvm_object_utils(r_sh_mask0_c)

	function new(input string name = "unnamed-r_sh_mask0_c");
		super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
		wr_cg = new;
		rd_cg = new;
	endfunction

endclass : r_sh_mask0_c

//r_info_mask0
class r_info_mask0_c extends uvm_reg;

	rand uvm_reg_field mask_val;

	virtual function void build();
		mask_val = uvm_reg_field::type_id::create("mask_val");
		mask_val.configure(this, 32, 0, "RW", 0, 0, 1, 1, 1);
		wr_cg.set_inst_name($sformatf("%s.wcov", get_full_name()));
		rd_cg.set_inst_name($sformatf("%s.rcov", get_full_name()));
	endfunction

	covergroup wr_cg;
		option.per_instance = 1;
		mask_val : coverpoint mask_val.value[31:0];
	endgroup
	covergroup rd_cg;
		option.per_instance = 1;
		mask_val : coverpoint mask_val.value[31:0];
	endgroup

	protected virtual function void sample(uvm_reg_data_t data, byte_en, bit is_read, uvm_reg_map map);
		super.sample(data, byte_en, is_read, map);
		if(!is_read) wr_cg.sample();
		if(is_read) rd_cg.sample();
	endfunction

	`uvm_register_cb(r_info_mask0_c, uvm_reg_cbs)
	`uvm_set_super_type(r_info_mask0_c, uvm_reg)
	`uvm_object_utils(r_info_mask0_c)

	function new(input string name = "unnamed-r_info_mask0_c");
		super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
		wr_cg = new;
		rd_cg = new;
	endfunction

endclass : r_info_mask0_c

//r_info_mask1
class r_info_mask1_c extends uvm_reg;

	rand uvm_reg_field mask_val;

	virtual function void build();
		mask_val = uvm_reg_field::type_id::create("mask_val");
		mask_val.configure(this, `INF_W-32, 0, "RW", 0, 0, 1, 1, 1);
		wr_cg.set_inst_name($sformatf("%s.wcov", get_full_name()));
		rd_cg.set_inst_name($sformatf("%s.rcov", get_full_name()));
	endfunction

	covergroup wr_cg;
		option.per_instance = 1;
		mask_val : coverpoint mask_val.value[`INF_W-33:0];
	endgroup
	covergroup rd_cg;
		option.per_instance = 1;
		mask_val : coverpoint mask_val.value[`INF_W-33:0];
	endgroup

	protected virtual function void sample(uvm_reg_data_t data, byte_en, bit is_read, uvm_reg_map map);
		super.sample(data, byte_en, is_read, map);
		if(!is_read) wr_cg.sample();
		if(is_read) rd_cg.sample();
	endfunction

	`uvm_register_cb(r_info_mask1_c, uvm_reg_cbs)
	`uvm_set_super_type(r_info_mask1_c, uvm_reg)
	`uvm_object_utils(r_info_mask1_c)

	function new(input string name = "unnamed-r_info_mask1_c");
		super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
		wr_cg = new;
		rd_cg = new;
	endfunction

endclass : r_info_mask1_c

//r_err_mask0
class r_err_mask0_c extends uvm_reg;

	rand uvm_reg_field mask_val;

	virtual function void build();
		mask_val = uvm_reg_field::type_id::create("mask_val");
		mask_val.configure(this, 32, 0, "RW", 0, 32'hffff_ffff, 1, 1, 1);
		wr_cg.set_inst_name($sformatf("%s.wcov", get_full_name()));
		rd_cg.set_inst_name($sformatf("%s.rcov", get_full_name()));
	endfunction

	covergroup wr_cg;
		option.per_instance = 1;
		mask_val : coverpoint mask_val.value[31:0];
	endgroup
	covergroup rd_cg;
		option.per_instance = 1;
		mask_val : coverpoint mask_val.value[31:0];
	endgroup

	protected virtual function void sample(uvm_reg_data_t data, byte_en, bit is_read, uvm_reg_map map);
		super.sample(data, byte_en, is_read, map);
		if(!is_read) wr_cg.sample();
		if(is_read) rd_cg.sample();
	endfunction

	`uvm_register_cb(r_err_mask0_c, uvm_reg_cbs)
	`uvm_set_super_type(r_err_mask0_c, uvm_reg)
	`uvm_object_utils(r_err_mask0_c)

	function new(input string name = "unnamed-r_err_mask0_c");
		super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
		wr_cg = new;
		rd_cg = new;
	endfunction

endclass : r_err_mask0_c

//r_err_mask1
class r_err_mask1_c extends uvm_reg;

	rand uvm_reg_field mask_val;

	virtual function void build();
		mask_val = uvm_reg_field::type_id::create("mask_val");
		mask_val.configure(this, `ERR_W-32, 0, "RW", 0, {`ERR_W-32{1'b1}}, 1, 1, 1);
		wr_cg.set_inst_name($sformatf("%s.wcov", get_full_name()));
		rd_cg.set_inst_name($sformatf("%s.rcov", get_full_name()));
	endfunction

	covergroup wr_cg;
		option.per_instance = 1;
		mask_val : coverpoint mask_val.value[`ERR_W-33:0];
	endgroup
	covergroup rd_cg;
		option.per_instance = 1;
		mask_val : coverpoint mask_val.value[`ERR_W-33:0];
	endgroup

	protected virtual function void sample(uvm_reg_data_t data, byte_en, bit is_read, uvm_reg_map map);
		super.sample(data, byte_en, is_read, map);
		if(!is_read) wr_cg.sample();
		if(is_read) rd_cg.sample();
	endfunction

	`uvm_register_cb(r_err_mask1_c, uvm_reg_cbs)
	`uvm_set_super_type(r_err_mask1_c, uvm_reg)
	`uvm_object_utils(r_err_mask1_c)

	function new(input string name = "unnamed-r_err_mask1_c");
		super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
		wr_cg = new;
		rd_cg = new;
	endfunction

endclass : r_err_mask1_c

//shake_state0
class shake_state0_c extends uvm_reg;

	rand uvm_reg_field state_val;

	virtual function void build();
		state_val = uvm_reg_field::type_id::create("state_val");
		state_val.configure(this, `SK_W, 0, "RO", 0, 0, 1, 0, 1);
		rd_cg.set_inst_name($sformatf("%s.rcov", get_full_name()));
	endfunction

	covergroup rd_cg;
		option.per_instance = 1;
		state_val : coverpoint state_val.value[`SK_W-1:0];
		//state_val : coverpoint state_val.value {
		//	bins value[16] = {[`SK_W:0]};
		//}
	endgroup

	protected virtual function void sample(uvm_reg_data_t data, byte_en, bit is_read, uvm_reg_map map);
		super.sample(data, byte_en, is_read, map);
		if(is_read) rd_cg.sample();
	endfunction

	`uvm_register_cb(shake_state0_c, uvm_reg_cbs)
	`uvm_set_super_type(shake_state0_c, uvm_reg)
	`uvm_object_utils(shake_state0_c)

	function new(input string name = "unnamed-shake_state0_c");
		super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
		rd_cg = new;
	endfunction

endclass : shake_state0_c

//info_state0
class info_state0_c extends uvm_reg;

	rand uvm_reg_field state_val;

	virtual function void build();
		state_val = uvm_reg_field::type_id::create("state_val");
		state_val.configure(this, 32, 0, "RO", 0, 0, 1, 0, 1);
		rd_cg.set_inst_name($sformatf("%s.rcov", get_full_name()));
	endfunction

	covergroup rd_cg;
		option.per_instance = 1;
		state_val : coverpoint state_val.value[31:0];
		//state_val : coverpoint state_val.value {
		//	bins value[16] = {[31:0]};
		//}
	endgroup

	protected virtual function void sample(uvm_reg_data_t data, byte_en, bit is_read, uvm_reg_map map);
		super.sample(data, byte_en, is_read, map);
		if(is_read) rd_cg.sample();
	endfunction

	`uvm_register_cb(info_state0_c, uvm_reg_cbs)
	`uvm_set_super_type(info_state0_c, uvm_reg)
	`uvm_object_utils(info_state0_c)

	function new(input string name = "unnamed-info_state0_c");
		super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
		rd_cg = new;
	endfunction

endclass : info_state0_c

//info_state1
class info_state1_c extends uvm_reg;

	rand uvm_reg_field state_val;

	virtual function void build();
		state_val = uvm_reg_field::type_id::create("state_val");
		state_val.configure(this, `INF_W-32, 0, "RO", 0, 0, 1, 0, 1);
		rd_cg.set_inst_name($sformatf("%s.rcov", get_full_name()));
	endfunction

	covergroup rd_cg;
		option.per_instance = 1;
		state_val : coverpoint state_val.value[`INF_W-33:0];
		//state_val : coverpoint state_val.value{
		//	bins value[16] = {[`INF_W-33:0]};
		//}
	endgroup

	protected virtual function void sample(uvm_reg_data_t data, byte_en, bit is_read, uvm_reg_map map);
		super.sample(data, byte_en, is_read, map);
		if(is_read) rd_cg.sample();
	endfunction

	`uvm_register_cb(info_state1_c, uvm_reg_cbs)
	`uvm_set_super_type(info_state1_c, uvm_reg)
	`uvm_object_utils(info_state1_c)

	function new(input string name = "unnamed-info_state1_c");
		super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
		rd_cg = new;
	endfunction

endclass : info_state1_c

//error_state0
class error_state0_c extends uvm_reg;

	rand uvm_reg_field state_val;

	virtual function void build();
		state_val = uvm_reg_field::type_id::create("state_val");
		state_val.configure(this, 32, 0, "RO", 0, 0, 1, 0, 1);
		rd_cg.set_inst_name($sformatf("%s.rcov", get_full_name()));
	endfunction

	covergroup rd_cg;
		option.per_instance = 1;
		state_val : coverpoint state_val.value[31:0];
		//state_val : coverpoint state_val.value {
		//	bins value[16] = {[31:0]};
		//}
	endgroup

	protected virtual function void sample(uvm_reg_data_t data, byte_en, bit is_read, uvm_reg_map map);
		super.sample(data, byte_en, is_read, map);
		if(is_read) rd_cg.sample();
	endfunction

	`uvm_register_cb(error_state0_c, uvm_reg_cbs)
	`uvm_set_super_type(error_state0_c, uvm_reg)
	`uvm_object_utils(error_state0_c)

	function new(input string name = "unnamed-error_state0_c");
		super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
		rd_cg = new;
	endfunction

endclass : error_state0_c

//error_state1
class error_state1_c extends uvm_reg;

	rand uvm_reg_field state_val;

	virtual function void build();
		state_val = uvm_reg_field::type_id::create("state_val");
		state_val.configure(this, `ERR_W-32, 0, "RO", 0, 0, 1, 0, 1);
		rd_cg.set_inst_name($sformatf("%s.rcov", get_full_name()));
	endfunction

	covergroup rd_cg;
		option.per_instance = 1;
		state_val : coverpoint state_val.value[`ERR_W-33:0];
		//state_val : coverpoint state_val.value {
		//	bins value[16] = {[`ERR_W-33:0]};
		//}
	endgroup

	protected virtual function void sample(uvm_reg_data_t data, byte_en, bit is_read, uvm_reg_map map);
		super.sample(data, byte_en, is_read, map);
		if(is_read) rd_cg.sample();
	endfunction

	`uvm_register_cb(error_state1_c, uvm_reg_cbs)
	`uvm_set_super_type(error_state1_c, uvm_reg)
	`uvm_object_utils(error_state1_c)

	function new(input string name = "unnamed-error_state1_c");
		super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
		rd_cg = new;
	endfunction

endclass : error_state1_c

class gpio_int_rf_c extends uvm_reg_block;
	rand r_sh_mask0_c r_sh_mask0;
	rand r_info_mask0_c r_info_mask0;
	rand r_info_mask1_c r_info_mask1;
	rand r_err_mask0_c r_err_mask0;
	rand r_err_mask1_c r_err_mask1;
	rand shake_state0_c shake_state0;
	rand info_state0_c info_state0;
	rand info_state1_c info_state1;
	rand error_state0_c error_state0;
	rand error_state1_c error_state1;

	virtual function void build();

		//Create all registers
		r_sh_mask0 = r_sh_mask0_c::type_id::create("r_sh_mask0", , get_full_name());
		r_info_mask0 = r_info_mask0_c::type_id::create("r_info_mask0", , get_full_name());
		r_info_mask1 = r_info_mask1_c::type_id::create("r_info_mask1", , get_full_name());
		r_err_mask0 = r_err_mask0_c::type_id::create("r_err_mask0", , get_full_name());
		r_err_mask1 = r_err_mask1_c::type_id::create("r_err_mask1", , get_full_name());
		shake_state0 = shake_state0_c::type_id::create("shake_state0", , get_full_name());
		info_state0 = info_state0_c::type_id::create("info_state0", , get_full_name());
		info_state1 = info_state1_c::type_id::create("info_state1", , get_full_name());
		error_state0 = error_state0_c::type_id::create("error_state0", , get_full_name());
		error_state1 = error_state1_c::type_id::create("error_state1", , get_full_name());
	
		//Build the registers. Set parent and hdl_paths
		r_sh_mask0.configure(this, null, "r_sh_mask0");
		r_sh_mask0.build();
		r_info_mask0.configure(this, null, "r_info_mask0");
		r_info_mask0.build();
		r_info_mask1.configure(this, null, "r_info_mask1");
		r_info_mask1.build();
		r_err_mask0.configure(this, null, "r_err_mask0");
		r_err_mask0.build();
		r_err_mask1.configure(this, null, "r_err_mask1");
		r_err_mask1.build();
		shake_state0.configure(this, null, "shake_state0");
		shake_state0.build();
		info_state0.configure(this, null, "info_state0");
		info_state0.build();
		info_state1.configure(this, null, "info_state1");
		info_state1.build();
		error_state0.configure(this, null, "error_state0");
		error_state0.build();
		error_state1.configure(this, null, "error_state1");
		error_state1.build();

		//Define address mappings
		default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
		//default_map = create_map("default_map", 0, 4, UVM_BIG_ENDIAN);
		default_map.add_reg(r_sh_mask0, 24'h00, "RW");
		default_map.add_reg(r_info_mask0, 24'h10, "RW");
		default_map.add_reg(r_info_mask1, 24'h14, "RW");
		default_map.add_reg(r_err_mask0, 24'h20, "RW");
		default_map.add_reg(r_err_mask1, 24'h24, "RW");
		default_map.add_reg(shake_state0, 24'h30, "RO");
		default_map.add_reg(info_state0, 24'h40, "RO");
		default_map.add_reg(info_state1, 24'h44, "RO");
		default_map.add_reg(error_state0, 24'h50, "RO");
		default_map.add_reg(error_state1, 24'h54, "RO");
	endfunction

	`uvm_object_utils(gpio_int_rf_c)

	function new(input string name = "unnamed-gpio_int_rf");
		super.new(name, UVM_NO_COVERAGE);
	endfunction

endclass : gpio_int_rf_c

class reg_model extends uvm_reg_block;

	rand gpio_int_rf_c gpio_int_rf;

	function void build();
		//Define address mappings
		default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
		//default_map = create_map("default_map", 0, 4, UVM_BIG_ENDIAN);
		gpio_int_rf = gpio_int_rf_c::type_id::create("gpio_int_rf", , get_full_name());
		gpio_int_rf.configure(this, "m_gpio_int_cfg");
		gpio_int_rf.build();
		gpio_int_rf.lock_model();
		default_map.add_submap(gpio_int_rf.default_map, 24'h00);
		set_hdl_path_root("gpio_int_top_tb.gpio_int_dut");
		this.lock_model();
		default_map.set_check_on_read(0);
	endfunction

	`uvm_object_utils(reg_model)

	function new(input string name = "unnamed-gpio_int_reg_model_c");
		super.new(name, UVM_NO_COVERAGE);
	endfunction

endclass : reg_model

`endif
