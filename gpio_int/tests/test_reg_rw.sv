
class test_reg_rw extends base_test;

   function new(string name = "test_reg_rw", uvm_component parent = null);
      super.new(name,parent);
   endfunction 
   extern virtual function void build_phase(uvm_phase phase); 
   `uvm_component_utils(test_reg_rw)
endclass


function void test_reg_rw::build_phase(uvm_phase phase);
   super.build_phase(phase);

   $display("\n\t========================================================");
   $display("\t\tExcuting test pattern is : [ %s ]", get_type_name());
   $display("\t========================================================\n\n");

   uvm_config_db#(uvm_object_wrapper)::set(this, 
                                           "v_sqr.main_phase", 
                                           "default_sequence", 
                                           reg_rw_vseq::type_id::get());
endfunction
