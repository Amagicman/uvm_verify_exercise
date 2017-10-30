`ifndef GPIO_INT_CASE1__SV
`define GPIO_INT_CASE1__SV

class gen_oriented_intr_seq extends gpio_int_base_seq;

	function new(string name = "gen_oriented_intr_seq");
		super.new(name);
	endfunction
	`uvm_object_utils(gen_oriented_intr_seq)
	
	rand int unsigned int_bit_oriented;
	constraint int_bit_oriented_con {
		int_bit_oriented inside {19,42};
	}
	virtual task body();
			`uvm_do_with(req, {req.int_bit == int_bit_oriented;})
	endtask : body

endclass : gen_oriented_intr_seq

class gen_oriented_intr_vseq extends base_vseq;

	function new(string name = "gen_oriented_intr_vseq");
		super.new(name);
	endfunction
	`uvm_object_utils(gen_oriented_intr_vseq)

	virtual task body();
		gen_oriented_intr_seq intr_seq;
		repeat(`LINE_NUM) begin
			`uvm_do_on(intr_seq, p_sequencer.p_gpio_int_sqr)
		end
	endtask : body

endclass : gen_oriented_intr_vseq


class test_gpio_int_oriented extends base_test;

   function new(string name = "test_gpio_int_oriented", uvm_component parent = null);
      super.new(name,parent);
   endfunction 
   extern virtual function void build_phase(uvm_phase phase); 
   `uvm_component_utils(test_gpio_int_oriented)
endclass

function void test_gpio_int_oriented::build_phase(uvm_phase phase);
   super.build_phase(phase);

   $display("\n\t========================================================");
   $display("\t\tExcuting test pattern is : [ %s ]", get_type_name);
   $display("\t========================================================\n\n");

   uvm_config_db#(uvm_object_wrapper)::set(this, 
                                           "v_sqr.configure_phase", 
                                           "default_sequence", 
                                           gpio_int_default_cfg_fd_vseq::type_id::get());
   uvm_config_db#(uvm_object_wrapper)::set(this, 
                                           "v_sqr.main_phase", 
                                           "default_sequence", 
                                           gen_oriented_intr_vseq::type_id::get());
endfunction

`endif
