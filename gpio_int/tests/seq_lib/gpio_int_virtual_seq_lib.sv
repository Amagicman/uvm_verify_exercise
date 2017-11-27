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

// SEQUENCE : gpio_int_reg_rst_val_fd_vseq
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
	  if(value != sh_mask)
		  `uvm_error(get_type_name(), "r_sh_mask0 read write error!")
      `uvm_info(get_type_name(), $sformatf("r_sh_mask0's config value is %0h", value), UVM_LOW)
	  //$display("\n\t[%s] r_sh_mask0's config value is 0x%0h", get_type_name, value);

	  info_mask0 = $urandom_range(0, {32{1'b1}});
      p_sequencer.p_rm.gpio_int_rf.r_info_mask0.write(status, info_mask0, UVM_FRONTDOOR);
      p_sequencer.p_rm.gpio_int_rf.r_info_mask0.read(status, value, UVM_FRONTDOOR);
	  if(value != info_mask0)
		  `uvm_error(get_type_name(), "r_info_mask0 read write error!")
      `uvm_info(get_type_name(), $sformatf("r_info_mask0's config value is %0h", value), UVM_LOW)
	  //$display("\t[%s] r_info_mask0's config value is 0x%0h", get_type_name, value);

	  info_mask1 = $urandom_range(0, {{64-`INF_W{1'b0}},{`INF_W-32{1'b1}}});
      p_sequencer.p_rm.gpio_int_rf.r_info_mask1.write(status, info_mask1, UVM_FRONTDOOR);
      p_sequencer.p_rm.gpio_int_rf.r_info_mask1.read(status, value, UVM_FRONTDOOR);
	  if(value != info_mask1)
		  `uvm_error(get_type_name(), "r_info_mask1 read write error!")
      `uvm_info(get_type_name(), $sformatf("r_info_mask1's config value is %0h", value), UVM_LOW)
	  //$display("\t[%s] r_info_mask1's config value is 0x%0h", get_type_name, value);

	  err_mask0 = $urandom_range(0, {32{1'b1}});
      p_sequencer.p_rm.gpio_int_rf.r_err_mask0.write(status, err_mask0, UVM_FRONTDOOR);
      p_sequencer.p_rm.gpio_int_rf.r_err_mask0.read(status, value, UVM_FRONTDOOR);
	  if(value != err_mask0)
		  `uvm_error(get_type_name(), "r_err_mask0 read write error!")
      `uvm_info(get_type_name(), $sformatf("r_err_mask0's config value is %0h", value), UVM_LOW)
	  //$display("\t[%s] r_err_mask0's config value is 0x%0h", get_type_name, value);

	  err_mask1 = $urandom_range(0, {{64-`ERR_W{1'b0}},{`ERR_W-32{1'b1}}});
      p_sequencer.p_rm.gpio_int_rf.r_err_mask1.write(status, err_mask1, UVM_FRONTDOOR);
      p_sequencer.p_rm.gpio_int_rf.r_err_mask1.read(status, value, UVM_FRONTDOOR);
	  if(value != err_mask1)
		  `uvm_error(get_type_name(), "r_err_mask1 read write error!")
      `uvm_info(get_type_name(), $sformatf("r_err_mask1's config value is %0h", value), UVM_LOW)
	  //$display("\t[%s] r_err_mask1's config value is 0x%0h\n", get_type_name, value);

	  //$display("\n\t============== Registers config end =================\n");

	endtask : body
endclass : gpio_int_cfg_fd_vseq

// SEQUENCE : gpio_int_read_int_state_fd_vseq
class gpio_int_read_int_state_fd_vseq extends base_vseq;

	function new(string name = "gpio_int_read_int_state_fd_vseq");
		super.new(name);
	endfunction

	rand bit [`INT_NUM-1:0] int_state_c;

	`uvm_object_utils(gpio_int_read_int_state_fd_vseq)

	virtual task body();

      uvm_status_e   status;
      //uvm_reg_data_t value;
	  uvm_reg_data_t sh_state, info_state0, info_state1, err_state0, err_state1;
	  uvm_reg_data_t sh_state_c, info_state0_c, info_state1_c, err_state0_c, err_state1_c;

	  sh_state_c = int_state_c & {`SK_W{1'b1}} ;
	  info_state0_c = (int_state_c >> `SK_W) & {32{1'b1}};
	  info_state1_c = (int_state_c >> (32 + `SK_W)) & {`INF_W-32{1'b1}};
	  err_state0_c = (int_state_c >> (`SK_W + `INF_W)) & {32{1'b1}};
	  err_state1_c = (int_state_c >> (32 + `SK_W + `INF_W)) & {`ERR_W-32{1'b1}};

      p_sequencer.p_rm.gpio_int_rf.shake_state0.read(status, sh_state, UVM_FRONTDOOR);
	  if(sh_state != sh_state_c)
		  `uvm_error(get_type_name(), "shake_state0 read error!")
      `uvm_info(get_type_name(), $sformatf("shake_state0's value is %0h", sh_state), UVM_LOW)
	  //$display("\n\t[%s] shake_state is 0x%0h", get_type_name, sh_state);
      p_sequencer.p_rm.gpio_int_rf.info_state0.read(status, info_state0, UVM_FRONTDOOR);
	  if(info_state0 != info_state0_c)
		  `uvm_error(get_type_name(), "info_state0 read error!")
      `uvm_info(get_type_name(), $sformatf("info_state0's value is %0h", info_state0), UVM_LOW)
	  //$display("\t[%s] info_state0 is 0x%0h", get_type_name, info_state0);
      p_sequencer.p_rm.gpio_int_rf.info_state1.read(status, info_state1, UVM_FRONTDOOR);
	  if(info_state1 != info_state1_c)
		  `uvm_error(get_type_name(), "info_state1 read error!")
      `uvm_info(get_type_name(), $sformatf("info_state1's value is %0h", info_state1), UVM_LOW)
	  //$display("\t[%s] info_state1 is 0x%0h", get_type_name, info_state1);
      p_sequencer.p_rm.gpio_int_rf.error_state0.read(status, err_state0, UVM_FRONTDOOR);
	  if(err_state0 != err_state0_c)
		  `uvm_error(get_type_name(), "err_state0 read error!")
      `uvm_info(get_type_name(), $sformatf("error_state0's value is %0h", err_state0), UVM_LOW)
	  //$display("\t[%s] error_state0 is 0x%0h", get_type_name, err_state0);
      p_sequencer.p_rm.gpio_int_rf.error_state1.read(status, err_state1, UVM_FRONTDOOR);
	  if(err_state1 != err_state1_c)
		  `uvm_error(get_type_name(), "err_state1 read error!")
      `uvm_info(get_type_name(), $sformatf("error_state1's value is %0h", err_state1), UVM_LOW)
	  //$display("\t[%s] error_state1 is 0x%0h\n", get_type_name, err_state1);

	endtask

  endclass : gpio_int_read_int_state_fd_vseq

//----------------------------------------------------------------------------
// SEQUENCE : generate random interrupt requests for int_code and int_state compare
//----------------------------------------------------------------------------
class gpio_int_intr_code_vseq extends base_vseq;

	function new(string name = "gpio_int_intr_code_vseq");
		super.new(name);
	endfunction
	`uvm_object_utils(gpio_int_intr_code_vseq)

	virtual task body();
		gpio_int_sequence_item item;
		gpio_int_cfg_fd_vseq cfg_seq;
		get_int_state_seq int_state_seq;
		repeat (`LINE_NUM) begin
			//`uvm_do(cfg_seq)
			`uvm_do_on_with(item, p_sequencer.p_gpio_int_sqr, {item.int_num == SINGLE; item.int_ack == 1'b0;})
			`uvm_do_on(int_state_seq, p_sequencer.p_bus_sqr)
		end
	endtask : body

endclass : gpio_int_intr_code_vseq

//----------------------------------------------------------------------------
// SEQUENCE : generate random interrupt requests from the same clock domain 
//----------------------------------------------------------------------------
class gpio_int_same_domain_multi_vseq extends base_vseq;
	rand bit [`INT_NUM-1:0] multi_int_r;
	function new(string name = "gpio_int_same_domain_multi_vseq");
		super.new(name);
	endfunction
	`uvm_object_utils(gpio_int_same_domain_multi_vseq)

	constraint multi_int_ct {
		multi_int_r inside {
		//1<<108,
		//1<<107,
		//[1<<104:{`ERR_200M'b{1}}<<104],
		[1<<65:{`ERR_400M{1'b1}}<<65],
		[1<<63:{`INF_300M{1'b1}}<<63]
	};
	}

	virtual task body();
		gpio_int_sequence_item item;
		gpio_int_cfg_fd_vseq cfg_seq;
		repeat (`LINE_NUM) begin
			`uvm_do(cfg_seq)
			`uvm_do_on_with(item, p_sequencer.p_gpio_int_sqr, {item.int_num == MULTI;
															   item.multi_int == multi_int_r;
															   item.int_ack == 1'b0;})
		end
	endtask : body

endclass : gpio_int_same_domain_multi_vseq

//----------------------------------------------------------------------------
// SEQUENCE : generate random interrupt requests for int_src, int_code and int_state coverage
//----------------------------------------------------------------------------
class gpio_int_cov_vseq extends base_vseq;

	function new(string name = "gpio_int_cov_vseq");
		super.new(name);
	endfunction
	`uvm_object_utils(gpio_int_cov_vseq)

	virtual task body();
		gpio_int_sequence_item item;
		gpio_int_cfg_fd_vseq cfg_seq;
		get_int_state_seq int_state_seq;
		repeat (`LINE_NUM) begin
			`uvm_do(cfg_seq)
			`uvm_do_on_with(item, p_sequencer.p_gpio_int_sqr, {item.int_num == SINGLE; item.int_ack == 0;})
			`uvm_do_on(int_state_seq, p_sequencer.p_bus_sqr)
		end
	endtask : body

endclass : gpio_int_cov_vseq

//----------------------------------------------------------------------------
// SEQUENCE : generate interrupt requests of different types for priority comparation 
//----------------------------------------------------------------------------
class intr_priority_compare_vseq extends base_vseq;

	function new(string name = "intr_priority_compare_vseq");
		super.new(name);
	endfunction

	`uvm_object_utils(intr_priority_compare_vseq)

	virtual task body();
		gpio_int_sequence_item item;

		repeat(`LINE_NUM) begin
			`uvm_do_on_with(item, p_sequencer.p_gpio_int_sqr, {item.int_num == SINGLE; 
															   item.int_ack == 1'b1;})
		end

		repeat(`LINE_NUM) begin
			`uvm_do_on_with(item, p_sequencer.p_gpio_int_sqr, {item.int_num == SINGLE;
															   item.int_bit == 0;
															   item.int_ack == 1'b0;})
		end

	endtask : body

endclass : intr_priority_compare_vseq

class reg_rw_vseq extends base_vseq;

	function new(string name = "reg_rw_vseq");
		super.new(name);
	endfunction

	rand bit [`INT_NUM-1:0] int_state_c_r;

	`uvm_object_utils(reg_rw_vseq)

	virtual task body();
		gpio_int_cfg_fd_vseq cfg_vseq;
		gpio_int_state_wr_seq wr_state_seq;
		gpio_int_read_int_state_fd_vseq get_state_vseq;

		repeat (`LINE_NUM) begin
			`uvm_do(cfg_vseq)
			`uvm_do_with(wr_state_seq, {wr_state_seq.int_state == int_state_c_r;})
			`uvm_do_with(get_state_vseq, {get_state_vseq.int_state_c == int_state_c_r;})
		end
	endtask
endclass : reg_rw_vseq

`endif
