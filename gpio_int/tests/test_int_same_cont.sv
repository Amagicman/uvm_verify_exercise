
class test_int_same_int_cont extends base_test;

   function new(string name = "test_int_same_int_cont", uvm_component parent = null);
      super.new(name,parent);
   endfunction 
   extern virtual function void build_phase(uvm_phase phase); 
   `uvm_component_utils(test_int_same_int_cont)
endclass

function void test_int_same_int_cont::build_phase(uvm_phase phase);
   super.build_phase(phase);

   $display("\n\t========================================================");
   $display("\t\tExcuting test pattern is : [ %s ]", get_type_name);
   $display("\t========================================================\n\n");

   uvm_config_db#(uvm_object_wrapper)::set(this, 
                                           "v_sqr.configure_phase", 
                                           "default_sequence", 
                                           gpio_int_cfg_fd_vseq::type_id::get());
   uvm_config_db#(uvm_object_wrapper)::set(this, 
                                           "v_sqr.main_phase", 
                                           "default_sequence", 
                                           gpio_int_same_int_cont_vseq::type_id::get());
endfunction
