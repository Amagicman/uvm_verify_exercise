`ifndef GPIO_INT_MODEL__SV
`define GPIO_INT_MODEL__SV

class gpio_int_model extends uvm_component;
   
   uvm_blocking_get_port #(gpio_int_sequence_item)  drv2mdl_item_blk_gp;
   uvm_analysis_port #(gpio_int_mon_transfer)  mdl2scb_mtr_ap;

   //reg_model p_rm;

   // Access the dut registers from backdoor interface
   virtual backdoor_if vif;//jg

   extern function new(string name, uvm_component parent);
   extern function void build_phase(uvm_phase phase);
   extern virtual  task main_phase(uvm_phase phase);
   extern virtual task calc_int_mask(output bit [`INT_NUM-1:0] int_mask);
   extern virtual task get_int_req_code(input gpio_int_sequence_item tr, output bit int_req_o, output bit [6:0] int_code_o, output bit [108:0] int_state_o);

   `uvm_component_utils(gpio_int_model)
endclass 

function gpio_int_model::new(string name, uvm_component parent);
   super.new(name, parent);
endfunction 

function void gpio_int_model::build_phase(uvm_phase phase);
   super.build_phase(phase);
   drv2mdl_item_blk_gp = new("drv2mdl_item_blk_gp", this);
   mdl2scb_mtr_ap = new("mdl2scb_mtr_ap", this);

   void'(uvm_config_db#(virtual backdoor_if)::get(this, "", "vif", vif));
endfunction

task gpio_int_model::calc_int_mask(output bit [`INT_NUM-1:0] int_mask);
   //uvm_status_e status;
   uvm_reg_data_t sh_mask, info_mask0, info_mask1, err_mask0, err_mask1;
   bit [`INF_W-1:0] info_mask;
   bit [`ERR_W-1:0] err_mask;

//   p_rm.gpio_int_rf.r_sh_mask0.read(status, sh_mask, UVM_FRONTDOOR);
//   p_rm.gpio_int_rf.r_info_mask0.read(status, info_mask0, UVM_FRONTDOOR);
//   p_rm.gpio_int_rf.r_info_mask1.read(status, info_mask1, UVM_FRONTDOOR);
//   p_rm.gpio_int_rf.r_err_mask0.read(status, err_mask0, UVM_FRONTDOOR);
//   p_rm.gpio_int_rf.r_err_mask1.read(status, err_mask1, UVM_FRONTDOOR);

   // Get the interrupt masks from backdoor interface
   vif.peek_r_sh_mask0(sh_mask);
   vif.peek_r_info_mask0(info_mask0);
   vif.peek_r_info_mask1(info_mask1);
   vif.peek_r_err_mask0(err_mask0);
   vif.peek_r_err_mask1(err_mask1);

   info_mask = (info_mask1 << 32) | info_mask0;
   err_mask = (err_mask1 << 32) | err_mask0;

   int_mask = (err_mask << (`INF_W + `SK_W)) | (info_mask << `SK_W) | sh_mask;
   `uvm_info(get_type_name(), $sformatf("int_mask's value is %0h ", int_mask), UVM_LOW)//jg

endtask : calc_int_mask

//bit [`INT_NUM-1:0] has_int_c = 0;
//task gpio_int_model::get_int_req_code(input gpio_int_sequence_item tr, output bit int_req, output bit [6:0] int_code);
//
//	bit  [`INT_NUM-1:0] int_bit_collect;
//	bit  [`INT_NUM-1:0] int_mask;
//
//	calc_int_mask(int_mask);
//	has_int_c |= tr.has_int;
//	int_bit_collect = has_int_c & int_mask;
//	for (int i = `INT_NUM -1; i >= 0; i--) begin
//		if(int_bit_collect[i]) begin
//			int_req = 1'b1;
//			int_code = i;
//			has_int_c[i] = 0;
//			break;
//		end
//	end
//
//endtask : get_int_req_code

bit [108:0] int_state_current = 0;
bit int_req_current = 0;
bit [6:0] int_code_current = 0;
task gpio_int_model::get_int_req_code(input gpio_int_sequence_item tr, output bit int_req_o, output bit [6:0] int_code_o, output bit [108:0] int_state_o);

    bit [108:0] int_real, int_mask;
	bit int_req_next;
	bit int_ack_current;

	calc_int_mask(int_mask);
	int_state_current |= tr.has_int;
	int_real = int_state_current & int_mask;
	int_ack_current = tr.int_ack;
	int_state_o = int_state_current;

	if(~int_req_current ) begin

		for(int i = 108; i >= 0; i--) begin
			if(int_real[i]) begin
				int_req_current = 1;
				int_code_current = i;
				break;
			end else begin
				int_req_current = 0;
			end
		end	

		if(~int_ack_current) begin
			int_req_o = int_req_current;
			int_code_o = int_code_current;
			int_state_current &= ~(1 << int_code_o);

			int_req_next = 0;
		end else begin
			int_req_o = int_req_current;
			int_code_o = int_code_current;

			if(~int_req_current) begin
				int_req_next = 0;
			end else begin
				int_req_next = 1;
			end
		end
	end else if(int_ack_current) begin
		int_req_o = int_req_current;
		int_code_o = int_code_current;

		int_req_next = 1;
	end else begin
		for(int i = 108; i >= 0; i--) begin
			if(int_real[i]) begin
				int_real[i] = 0;
				int_state_current[i] = 0;
				break;
			end
		end	
		for(int i = 108; i >= 0; i--) begin
			if(int_real[i]) begin
				int_req_o = 1;
				int_code_o = i;
				int_state_current[i] = 0;
				break;
			end else begin
				int_req_o = 0;
				int_code_o = int_code_current;
			end
		end	
		
		int_req_next = 0;
	end

	int_req_current = int_req_next;

endtask : get_int_req_code

// num_co : counter of transfers getted for reference model
int num_co = 0;
task gpio_int_model::main_phase(uvm_phase phase);
   gpio_int_sequence_item tr;
   gpio_int_mon_transfer mtr;

   bit int_req;
   bit [6:0] int_code;
   bit [108:0] int_state;

   super.main_phase(phase);

   while(1) begin
      drv2mdl_item_blk_gp.get(tr);
      mtr = new("mtr");
	  get_int_req_code(tr, int_req, int_code, int_state);
	  mtr.INT_CODE = int_code;
	  mtr.INTR = int_req;
	  mtr.int_state = int_state;

	  //if(mtr.INTR) begin
		  mdl2scb_mtr_ap.write(mtr);
		  num_co++;
		  `uvm_info(get_type_name(), $sformatf("\n\n\t=======[#Model#] The NO.#%0d# tranfser collected is : \n%s", num_co, mtr.sprint()), UVM_LOW);
	  //end
   end
endtask
`endif
