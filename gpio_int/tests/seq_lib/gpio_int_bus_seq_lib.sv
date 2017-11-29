`ifndef GPIO_INT_BUS_SEQ_LIB__SV
`define GPIO_INT_BUS_SEQ_LIB__SV

class gpio_int_bus_base_seq extends uvm_sequence #(bus_transaction);

	function new(string name = "gpio_int_bus_base_seq");
		super.new(name);
	endfunction

	`uvm_object_utils(gpio_int_bus_base_seq)
	`uvm_declare_p_sequencer(bus_sequencer)

	//----------------------------------------------------------
	// Use pre_body() and post_body() tasks to raise/drop objections.
	//		These tasks only execute for a default sequence
	//----------------------------------------------------------
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

endclass : gpio_int_bus_base_seq

// SEQUENCE : set_int_mask_seq
class set_int_mask_seq extends gpio_int_bus_base_seq;
	bus_transaction m_trans;

	bit [31:0] sh_mask0 = $urandom_range(0, {{32-`SK_W{1'b0}},{`SK_W{1'b1}}});
	bit [31:0] info_mask0 = $urandom_range(0, {32{1'b1}});
	bit [`INF_W-33:0] info_mask1 = $urandom_range(0, {{64-`INF_W{1'b0}},{`INF_W-32{1'b1}}});
	bit [31:0] err_mask0 = $urandom_range(0, {32{1'b1}});
	bit [`ERR_W-33:0] err_mask1 = $urandom_range(0, {{64-`ERR_W{1'b0}},{`ERR_W-32{1'b1}}});

	function new(string name = "set_int_mask_seq");
		super.new(name);
	endfunction

	virtual task body();

		// sh_mask0 : write
		`uvm_do_with(m_trans, {m_trans.addr == `P_SH_MASK_ADDR0;
							   m_trans.bus_op == BUS_WR;
							   m_trans.wr_data == sh_mask0;})

		// info_mask0: write
		`uvm_do_with(m_trans, {m_trans.addr == `P_INFO_MASK_ADDR0;
							   m_trans.bus_op == BUS_WR;
						       m_trans.wr_data == info_mask0;})

		// info_mask1: write
		`uvm_do_with(m_trans, {m_trans.addr == `P_INFO_MASK_ADDR1;
							   m_trans.bus_op == BUS_WR;
							   m_trans.wr_data == info_mask1;})

		// err_mask0: write
		`uvm_do_with(m_trans, {m_trans.addr == `P_ERR_MASK_ADDR0;
							   m_trans.bus_op == BUS_WR;
							   m_trans.wr_data == err_mask0;})

		// err_mask1: write
		`uvm_do_with(m_trans, {m_trans.addr == `P_ERR_MASK_ADDR1;
							   m_trans.bus_op == BUS_WR;
							   m_trans.wr_data == err_mask1;})

	endtask

	`uvm_object_utils(set_int_mask_seq)

endclass : set_int_mask_seq

// SEQUENCE : gpio_int_state_wr_seq
// Just for coverage test of int_state registes
class gpio_int_state_wr_seq extends uvm_sequence;

	//bit [`INT_NUM-1:0] int_state = $urandom_range(0, {`INT_NUM{1'b1}});
	rand bit [`INT_NUM-1:0] int_state; 

	function new(string name = "gpio_int_state_wr_seq");
		super.new(name);
	endfunction
	`uvm_object_utils(gpio_int_state_wr_seq)

	virtual task body();
			`DUT.m_gpio_int_do.r_isr = int_state;
	endtask
endclass : gpio_int_state_wr_seq

// SEQUENCE : get_int_state_seq
class get_int_state_seq extends gpio_int_bus_base_seq;
	bus_transaction m_trans;

	function new(string name = "get_int_state_seq");
		super.new(name);
	endfunction

	virtual task body();
	//	bit [31:0] sh_state0;
	//	bit [31:0] info_state0;
	//	bit [`INF_W-33:0] info_state1;
	//	bit [31:0] err_sate0;
	//	bit [`ERR_W-33:0] err_state1;

		// sh_state0 : read
		`uvm_do_with(m_trans, {m_trans.addr == `P_SH_STA_ADDR0;
							   m_trans.bus_op == BUS_RD;})
		`uvm_info(get_type_name(), $sformatf("sh_state0's value is %0h", m_trans.rd_data), UVM_LOW)
		//$display("\n\t[%s] sh_state0 is 0x%0h", get_type_name, m_trans.rd_data);

		// info_state0: read
		`uvm_do_with(m_trans, {m_trans.addr == `P_INFO_STA_ADDR0;
							   m_trans.bus_op == BUS_RD;})
		`uvm_info(get_type_name(), $sformatf("info_state0's value is %0h", m_trans.rd_data), UVM_LOW)
		//$display("\t[%s] info_state0 is 0x%0h", get_type_name, m_trans.rd_data);

		// info_state1: read
		`uvm_do_with(m_trans, {m_trans.addr == `P_INFO_STA_ADDR1;
							   m_trans.bus_op == BUS_RD;})
		`uvm_info(get_type_name(), $sformatf("info_state1's value is %0h", m_trans.rd_data), UVM_LOW)
		//$display("\t[%s] info_state1 is 0x%0h", get_type_name, m_trans.rd_data);

		// err_state0: read
		`uvm_do_with(m_trans, {m_trans.addr == `P_ERR_STA_ADDR0;
							   m_trans.bus_op == BUS_RD;})
		`uvm_info(get_type_name(), $sformatf("err_state0's value is %0h", m_trans.rd_data), UVM_LOW)
		//$display("\t[%s] err_state0 is 0x%0h", get_type_name, m_trans.rd_data);

		// err_state1: read
		`uvm_do_with(m_trans, {m_trans.addr == `P_ERR_STA_ADDR1;
							   m_trans.bus_op == BUS_RD;})
		`uvm_info(get_type_name(), $sformatf("err_state1's value is %0h", m_trans.rd_data), UVM_LOW)
		//$display("\t[%s] err_state1 is 0x%0h\n", get_type_name, m_trans.rd_data);

	endtask

	`uvm_object_utils(get_int_state_seq)

endclass : get_int_state_seq
`endif
