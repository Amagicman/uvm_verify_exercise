`ifndef GPIO_INT_VIRTUAL_SEQ_LIB__SV
`define GPIO_INT_VIRTUAL_SEQ_LIB__SV

class base_vseq extends uvm_sequence;
	function new(string name = "base_vseq");
		super.new(name);
	endfunction

	`uvm_object_utils(base_vseq)
	`uvm_declare_p_sequencer(gpio_int_vsqr)

	//----------------------------------------------------------------------------
	// Use a base sequence to raise/drop objections if this is a default sequence
	//----------------------------------------------------------------------------
	virtual task pre_body();
		if (starting_phase != null)
			starting_phase.raise_objection(this, {"Running sequence '",
												  get_full_name(), "'"});
	endtask

	virtual task post_body();
		if (starting_phase != null)
			starting_phase.drop_objection(this, {"Completed sequence '",
												 get_full_name(), "'"});
	endtask

endclass : base_vseq

// SEQUENCE : gpio_int_reg_rst_val_fd__vseq
class gpio_int_reg_rst_val_fd_vseq extends base_vseq;

	function new(string name = "gpio_int_reg_rst_val_fd_vseq");
		super.new(name);
	endfunction

	`uvm_object_utils(gpio_int_reg_rst_val_fd_vseq)

	virtual task body();

      uvm_status_e   status;
      uvm_reg_data_t value;
	  uvm_reg_data_t sh_mask, info_mask0, info_mask1, err_mask0, err_mask1;

	  // Initial value of registers
	  //$display("\n\t==============The initial value of registers : =================\n");
      p_sequencer.p_rm.gpio_int_rf.r_sh_mask0.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("r_sh_mask0's initial value is %0h", value), UVM_LOW)
      p_sequencer.p_rm.gpio_int_rf.r_info_mask0.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("r_info_mask0's initial value is %0h", value), UVM_LOW)
      p_sequencer.p_rm.gpio_int_rf.r_info_mask1.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("r_info_mask1's initial value is %0h", value), UVM_LOW)
      p_sequencer.p_rm.gpio_int_rf.r_err_mask0.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("r_err_mask0's initial value is %0h", value), UVM_LOW)
      p_sequencer.p_rm.gpio_int_rf.r_err_mask1.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("r_err_mask1's initial value is %0h", value), UVM_LOW)

      p_sequencer.p_rm.gpio_int_rf.shake_state0.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("shake_state0's initial value is %0h", value), UVM_LOW)
      p_sequencer.p_rm.gpio_int_rf.info_state0.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("info_state0's initial value is %0h", value), UVM_LOW)
      p_sequencer.p_rm.gpio_int_rf.info_state1.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("info_state1's initial value is %0h", value), UVM_LOW)
      p_sequencer.p_rm.gpio_int_rf.error_state0.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("error_state0's initial value is %0h", value), UVM_LOW)
      p_sequencer.p_rm.gpio_int_rf.error_state1.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("shake_state1's initial value is %0h", value), UVM_LOW)
	  //$display("\n\t==============The initial value of registers : =================\n");

	endtask : body
endclass : gpio_int_reg_rst_val_fd_vseq

// SEQUENCE : gpio_int_cfg_fd_vseq
class gpio_int_cfg_fd_vseq extends base_vseq;

	function new(string name = "gpio_int_cfg_fd_vseq");
		super.new(name);
	endfunction

	`uvm_object_utils(gpio_int_cfg_fd_vseq)

	virtual task body();

      uvm_status_e   status;
      uvm_reg_data_t value;
	  uvm_reg_data_t sh_mask, info_mask0, info_mask1, err_mask0, err_mask1;

	  // Configuration values of registers
	  //$display("\n\t==============After config,  value of registers : =================\n");
	  sh_mask = $urandom_range(0, {{32-`SK_W{1'b0}},{`SK_W{1'b1}}});
      p_sequencer.p_rm.gpio_int_rf.r_sh_mask0.write(status, sh_mask, UVM_FRONTDOOR);
      p_sequencer.p_rm.gpio_int_rf.r_sh_mask0.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("r_sh_mask0's config value is %0h", value), UVM_LOW)
	  //$display("\n\t[%s] r_sh_mask0's config value is 0x%0h", get_type_name, value);

	  info_mask0 = $urandom_range(0, {32{1'b1}});
      p_sequencer.p_rm.gpio_int_rf.r_info_mask0.write(status, info_mask0, UVM_FRONTDOOR);
      p_sequencer.p_rm.gpio_int_rf.r_info_mask0.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("r_info_mask0's config value is %0h", value), UVM_LOW)
	  //$display("\t[%s] r_info_mask0's config value is 0x%0h", get_type_name, value);

	  info_mask1 = $urandom_range(0, {{64-`INF_W{1'b0}},{`INF_W-32{1'b1}}});
      p_sequencer.p_rm.gpio_int_rf.r_info_mask1.write(status, info_mask1, UVM_FRONTDOOR);
      p_sequencer.p_rm.gpio_int_rf.r_info_mask1.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("r_info_mask1's config value is %0h", value), UVM_LOW)
	  //$display("\t[%s] r_info_mask1's config value is 0x%0h", get_type_name, value);

	  err_mask0 = $urandom_range(0, {32{1'b1}});
      p_sequencer.p_rm.gpio_int_rf.r_err_mask0.write(status, err_mask0, UVM_FRONTDOOR);
      p_sequencer.p_rm.gpio_int_rf.r_err_mask0.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("r_err_mask0's config value is %0h", value), UVM_LOW)
	  //$display("\t[%s] r_err_mask0's config value is 0x%0h", get_type_name, value);

	  err_mask1 = $urandom_range(0, {{64-`ERR_W{1'b0}},{`ERR_W-32{1'b1}}});
      p_sequencer.p_rm.gpio_int_rf.r_err_mask1.write(status, err_mask1, UVM_FRONTDOOR);
      p_sequencer.p_rm.gpio_int_rf.r_err_mask1.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("r_err_mask1's config value is %0h", value), UVM_LOW)
	  //$display("\t[%s] r_err_mask1's config value is 0x%0h\n", get_type_name, value);

	  //$display("\n\t============== Registers config end =================\n");

	endtask : body
endclass : gpio_int_cfg_fd_vseq

// SEQUENCE : gpio_int_default_cfg_fd_vseq
class gpio_int_default_cfg_fd_vseq extends base_vseq;

	function new(string name = "gpio_int_default_cfg_fd_vseq");
		super.new(name);
	endfunction

	`uvm_object_utils(gpio_int_default_cfg_fd_vseq)

	virtual task body();

      uvm_status_e   status;
      uvm_reg_data_t value;
	  uvm_reg_data_t sh_mask, info_mask0, info_mask1, err_mask0, err_mask1;

	  // Configuration values of registers
	  //$display("\n\t==============After config,  value of registers : =================\n");
	  sh_mask = {`SK_W{1'b1}};
      p_sequencer.p_rm.gpio_int_rf.r_sh_mask0.write(status, sh_mask, UVM_FRONTDOOR);
      p_sequencer.p_rm.gpio_int_rf.r_sh_mask0.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("r_sh_mask0's default config is %0h", value), UVM_LOW)

	  info_mask0 = {32{1'b1}};
      p_sequencer.p_rm.gpio_int_rf.r_info_mask0.write(status, info_mask0, UVM_FRONTDOOR);
      p_sequencer.p_rm.gpio_int_rf.r_info_mask0.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("r_info_mask0's default config is %0h", value), UVM_LOW)

	  info_mask1 = {`INF_W-32{1'b1}};
      p_sequencer.p_rm.gpio_int_rf.r_info_mask1.write(status, info_mask1, UVM_FRONTDOOR);
      p_sequencer.p_rm.gpio_int_rf.r_info_mask1.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("r_info_mask1's default config is %0h", value), UVM_LOW)

	  err_mask0 = {32{1'b1}};
      p_sequencer.p_rm.gpio_int_rf.r_err_mask0.write(status, err_mask0, UVM_FRONTDOOR);
      p_sequencer.p_rm.gpio_int_rf.r_err_mask0.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("r_err_mask0's default config is %0h", value), UVM_LOW)

	  err_mask1 = {`ERR_W-32{1'b1}};
      p_sequencer.p_rm.gpio_int_rf.r_err_mask1.write(status, err_mask1, UVM_FRONTDOOR);
      p_sequencer.p_rm.gpio_int_rf.r_err_mask1.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("r_err_mask1's default config is %0h", value), UVM_LOW)

	  //$display("\n\t============== Registers config end =================\n");

	endtask : body

endclass : gpio_int_default_cfg_fd_vseq

// SEQUENCE : gpio_int_mask_clr_fd_vseq
class gpio_int_mask_clr_fd_vseq extends base_vseq;

	function new(string name = "gpio_int_mask_clr_fd_vseq");
		super.new(name);
	endfunction

	`uvm_object_utils(gpio_int_mask_clr_fd_vseq)

	virtual task body();

      uvm_status_e   status;
      uvm_reg_data_t value;
	  uvm_reg_data_t sh_mask, info_mask0, info_mask1, err_mask0, err_mask1;

	  // Configuration values of registers
	  //$display("\n\t==============After config,  value of registers : =================\n");
	  sh_mask = {`SK_W{1'b0}};
      p_sequencer.p_rm.gpio_int_rf.r_sh_mask0.write(status, sh_mask, UVM_FRONTDOOR);
      //p_sequencer.p_rm.gpio_int_rf.r_sh_mask0.read(status, value, UVM_FRONTDOOR);
      //`uvm_info(get_type_name(), $sformatf("r_sh_mask0's default config is %0h", value), UVM_LOW)

	  info_mask0 = {32{1'b0}};
      p_sequencer.p_rm.gpio_int_rf.r_info_mask0.write(status, info_mask0, UVM_FRONTDOOR);
      //p_sequencer.p_rm.gpio_int_rf.r_info_mask0.read(status, value, UVM_FRONTDOOR);
      //`uvm_info(get_type_name(), $sformatf("r_info_mask0's default config is %0h", value), UVM_LOW)

	  info_mask1 = {`INF_W-32{1'b0}};
      p_sequencer.p_rm.gpio_int_rf.r_info_mask1.write(status, info_mask1, UVM_FRONTDOOR);
      //p_sequencer.p_rm.gpio_int_rf.r_info_mask1.read(status, value, UVM_FRONTDOOR);
      //`uvm_info(get_type_name(), $sformatf("r_info_mask1's default config is %0h", value), UVM_LOW)

	  err_mask0 = {32{1'b0}};
      p_sequencer.p_rm.gpio_int_rf.r_err_mask0.write(status, err_mask0, UVM_FRONTDOOR);
      //p_sequencer.p_rm.gpio_int_rf.r_err_mask0.read(status, value, UVM_FRONTDOOR);
      //`uvm_info(get_type_name(), $sformatf("r_err_mask0's default config is %0h", value), UVM_LOW)

	  err_mask1 = {`ERR_W-32{1'b0}};
      p_sequencer.p_rm.gpio_int_rf.r_err_mask1.write(status, err_mask1, UVM_FRONTDOOR);
      //p_sequencer.p_rm.gpio_int_rf.r_err_mask1.read(status, value, UVM_FRONTDOOR);
      //`uvm_info(get_type_name(), $sformatf("r_err_mask1's default config is %0h", value), UVM_LOW)

	  //$display("\n\t============== Registers config end =================\n");

	endtask : body

endclass : gpio_int_mask_clr_fd_vseq


// SEQUENCE : gpio_int_read_int_state_fd_vseq
class gpio_int_read_int_state_fd_vseq extends base_vseq;

	function new(string name = "gpio_int_read_int_state_fd_vseq");
		super.new(name);
	endfunction

	`uvm_object_utils(gpio_int_read_int_state_fd_vseq)

	virtual task body();

      uvm_status_e   status;
      uvm_reg_data_t value;

      p_sequencer.p_rm.gpio_int_rf.shake_state0.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("shake_state0's value is %0h", value), UVM_LOW)
	  //$display("\n\t[%s] shake_state is 0x%0h", get_type_name, value);
      p_sequencer.p_rm.gpio_int_rf.info_state0.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("info_state0's value is %0h", value), UVM_LOW)
	  //$display("\t[%s] info_state0 is 0x%0h", get_type_name, value);
      p_sequencer.p_rm.gpio_int_rf.info_state1.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("info_state1's value is %0h", value), UVM_LOW)
	  //$display("\t[%s] info_state1 is 0x%0h", get_type_name, value);
      p_sequencer.p_rm.gpio_int_rf.error_state0.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("error_state0's value is %0h", value), UVM_LOW)
	  //$display("\t[%s] error_state0 is 0x%0h", get_type_name, value);
      p_sequencer.p_rm.gpio_int_rf.error_state1.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("error_state1's value is %0h", value), UVM_LOW)
	  //$display("\t[%s] error_state1 is 0x%0h\n", get_type_name, value);

	endtask

  endclass : gpio_int_read_int_state_fd_vseq

// SEQUENCE : mask_set_backdoor_vseq
// Access registers through backdoor : write mask registers
class mask_set_backdoor_vseq extends base_vseq;
	reg_model rm;
	`uvm_object_utils(mask_set_backdoor_vseq)

	function new(string name = "mask_set_backdoor_vseq");
		super.new(name);
	endfunction

	task body();
		uvm_status_e status;
		uvm_reg_data_t value;

		fork
			p_sequencer.p_rm.gpio_int_rf.r_sh_mask0.poke(status, {`SK_W{1'b1}});
			p_sequencer.p_rm.gpio_int_rf.r_info_mask0.poke(status, {32{1'b1}});
			p_sequencer.p_rm.gpio_int_rf.r_info_mask1.poke(status, {`INF_W-32{1'b1}});
			p_sequencer.p_rm.gpio_int_rf.r_err_mask0.poke(status, {`ERR_W{1'b1}});
			p_sequencer.p_rm.gpio_int_rf.r_err_mask1.poke(status, {`ERR_W-32{1'b1}});
		join
			p_sequencer.p_rm.gpio_int_rf.r_sh_mask0.read(status, value, UVM_FRONTDOOR);
			//p_sequencer.p_rm.gpio_int_rf.r_sh_mask0.peek(status, value);

	endtask
endclass : mask_set_backdoor_vseq

//----------------------------------------------------------------------------
// SEQUENCE : generate random interrupt requests
//----------------------------------------------------------------------------
class gen_rand_intr_vseq extends base_vseq;

	function new(string name = "gen_rand_intr_vseq");
		super.new(name);
	endfunction
	`uvm_object_utils(gen_rand_intr_vseq)

	virtual task body();
		gpio_int_cfg_fd_vseq cfg_seq;
		int_rand_seq dseq;
		get_int_state_seq int_state_seq;
		gpio_int_read_int_state_fd_vseq state_vseq;
		repeat (`LINE_NUM) begin
			//`uvm_do(cfg_seq)
			//fork
				`uvm_do_on(dseq, p_sequencer.p_gpio_int_sqr)
				`uvm_do_on(int_state_seq, p_sequencer.p_bus_sqr)
				//`uvm_do(state_vseq)
			//join
		end
	endtask : body

endclass : gen_rand_intr_vseq 

//----------------------------------------------------------------------------
// SEQUENCE : generate interrupt requests of different types for priority comparation 
//----------------------------------------------------------------------------
class intr_priority_compare_vseq extends base_vseq;

	function new(string name = "intr_priority_compare_vseq");
		super.new(name);
	endfunction

	`uvm_object_utils(intr_priority_compare_vseq)

	virtual task body();
		int_err_seq err_seq;
		int_info_seq info_seq;
		int_shake_seq sh_seq;

		mask_set_backdoor_vseq mask_set_vseq;
		
		repeat(`LINE_NUM) begin
			fork
				`uvm_do_on(sh_seq, p_sequencer.p_gpio_int_sqr)
				`uvm_do_on(info_seq, p_sequencer.p_gpio_int_sqr)
				`uvm_do_on(err_seq, p_sequencer.p_gpio_int_sqr)
			join
		end

		#100000;
		`uvm_do(mask_set_vseq)
		#1000;

	endtask : body

endclass : intr_priority_compare_vseq

class reg_rw_vseq extends base_vseq;

	function new(string name = "reg_rw_vseq");
		super.new(name);
	endfunction

	`uvm_object_utils(reg_rw_vseq)

	virtual task body();
		gpio_int_cfg_fd_vseq cfg_vseq;
		gpio_int_state_wr_seq wr_state_seq;
		gpio_int_read_int_state_fd_vseq get_state_vseq;

		repeat (`LINE_NUM) begin
			`uvm_do(cfg_vseq)
			`uvm_do(wr_state_seq)
			`uvm_do(get_state_vseq)
		end
	endtask
endclass : reg_rw_vseq

`endif
