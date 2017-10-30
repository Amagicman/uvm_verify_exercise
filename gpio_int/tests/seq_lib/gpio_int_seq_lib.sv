`ifndef GPIO_INT_SEQ_LIB__SV
`define GPIO_INT_SEQ_LIB__SV

class gpio_int_base_seq extends uvm_sequence #(gpio_int_sequence_item);

	function new(string name = "gpio_int_base_seq");
		super.new(name);
	endfunction

	`uvm_object_utils(gpio_int_base_seq)
	`uvm_declare_p_sequencer(gpio_int_sequencer)

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

endclass : gpio_int_base_seq

// Generate an error interrupt
class int_err_seq extends gpio_int_base_seq;

	rand int unsigned int_bit_err;

	function new(string name = "int_err_seq");
		super.new(name);
	endfunction

	`uvm_object_utils(int_err_seq)

	constraint int_bit_err_ct {int_bit_err inside {[(`SK_W + `INF_W):(`INT_NUM-1)]};}

	virtual task body();
		`uvm_do_with(req, {req.int_bit == int_bit_err;})
	endtask

endclass : int_err_seq

// Generate an information interrupt
class int_info_seq extends gpio_int_base_seq;

	rand int unsigned int_bit_info;

	function new(string name = "int_err_seq");
		super.new(name);
	endfunction

	`uvm_object_utils(int_info_seq)

	constraint int_bit_info_ct {int_bit_info inside {[`SK_W:(`SK_W+`INF_W-1)]};}

	virtual task body();
		`uvm_do_with(req, {req.int_bit == int_bit_info;})
	endtask

endclass : int_info_seq

// Generate a shakehand interrupt
class int_shake_seq extends gpio_int_base_seq;

	rand int unsigned int_bit_sh;

	function new(string name = "int_shake_seq");
		super.new(name);
	endfunction

	`uvm_object_utils(int_shake_seq)

	constraint int_bit_sh_ct {int_bit_sh inside {[0:(`SK_W-1)]};}

	virtual task body();
		`uvm_do_with(req, {req.int_bit == int_bit_sh;})
	endtask

endclass : int_shake_seq

// Generate a random interrupt
class int_rand_seq extends gpio_int_base_seq;

   function  new(string name= "int_rand_seq");
      super.new(name);
   endfunction 
   
   virtual task body();
	`uvm_do(req)
	get_response(rsp);
	`uvm_info("seq", "get one response", UVM_LOW)
	//rsp.print();
   endtask

   `uvm_object_utils(int_rand_seq)
endclass : int_rand_seq

`endif
