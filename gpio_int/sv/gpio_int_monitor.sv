`ifndef GPIO_INT_MONITOR__SV
`define GPIO_INT_MONITOR__SV

class usr_mon_cb_cls#(type MTR = int) extends uvm_callback;

  virtual task mon_tr_cb(ref MTR mtr);
    `uvm_info(get_full_name(),"mon_tr_cb pro",UVM_HIGH)
  endtask

endclass


class usr_monitor#(type MTR=uvm_sequence_item) extends uvm_monitor;
  `uvm_component_param_utils(usr_monitor#(MTR))
  //`uvm_register_cb(usr_monitor#(MTR),mon_cb_cls)
  
  uvm_analysis_port#(MTR) dut2scb_mtr_ap;
  event rst_evt;

  // new constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction:new

  // build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    dut2scb_mtr_ap = new("dut2scb_mtr_ap",this);
  endfunction:build_phase

  //virtual task run_phase(uvm_phase phase);
  //  super.run_phase(phase);
  //  `uvm_do_callbacks(usr_monitor,mon_cb_cls#(MTR),mon_run_cb(this,dut2scb_mtr_ap));
  //endtask

endclass

class gpio_int_monitor extends usr_monitor#(gpio_int_mon_transfer);

   virtual gpio_int_if vif;
   reg_model p_rm;
   cov_gpio_int_mtr mtr_cov;

   `uvm_component_utils(gpio_int_monitor)
   function new(string name = "gpio_int_monitor", uvm_component parent = null);
      super.new(name, parent);
	  `ifdef __COV_ENABLE
		 mtr_cov = new("gpio_int");
	 `endif
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual gpio_int_if)::get(this, "", "vif", vif))
         `uvm_fatal("gpio_int_monitor", "virtual interface must be set for vif!!!")
   endfunction

   extern task main_phase(uvm_phase phase);
   extern task collect_one_pkt(gpio_int_mon_transfer mon_tr);
   extern task read_int_state_reg(output bit [`INT_NUM-1:0] int_state);
endclass

task gpio_int_monitor::main_phase(uvm_phase phase);
   gpio_int_mon_transfer mon_tr;
   uvm_status_e status;//jg
   uvm_reg_data_t value;//jg
   while(1) begin
      mon_tr = new("mon_tr");
      collect_one_pkt(mon_tr);
      dut2scb_mtr_ap.write(mon_tr);
	  `ifdef __COV_ENABLE
		if(mon_tr.INTR) mtr_cov.sample_tr(mon_tr);
	`endif
   end
endtask

// num_collect : counter of transfers collected for monitor
int num_collect = 0;
task gpio_int_monitor::collect_one_pkt(gpio_int_mon_transfer mon_tr);
	bit [`INT_NUM-1:0] int_state;
   while(1) begin
      @(posedge vif.clk[0]);
      if(vif.rstn_50m) break;
   end
   
   `uvm_info("gpio_int_monitor", "begin to collect one pkt", UVM_HIGH);

   @(`DRV_OVER_EVT);
   begin
	   mon_tr.INTR = vif.INTR;
	   //mon_tr.INTR = 1'b1;
	   mon_tr.INT_CODE = vif.INT_CODE;
	   //read_int_state_reg(int_state);
	   //mon_tr.int_state = int_state;
	   mon_tr.int_state = `DUT.m_gpio_int_do.r_isr;

   num_collect++;
   `uvm_info("gpio_int_monitor", "end collect one pkt", UVM_HIGH);
   `uvm_info(get_type_name(), $sformatf("\n\n\t=======[#Monitor#] The NO.#%0d# tranfser collected is : \n%s", num_collect, mon_tr.sprint()), UVM_LOW);
   end
endtask

task gpio_int_monitor::read_int_state_reg(output bit [`INT_NUM-1:0] int_state);
   uvm_status_e status;
   uvm_reg_data_t sh_state, info_state0, info_state1, err_state0, err_state1;
   bit [`INF_W-1:0] info_state;
   bit [`ERR_W-1:0] err_state;

   p_rm.gpio_int_rf.shake_state0.read(status, sh_state, UVM_FRONTDOOR);
   p_rm.gpio_int_rf.info_state0.read(status, info_state0, UVM_FRONTDOOR);
   p_rm.gpio_int_rf.info_state1.read(status, info_state1, UVM_FRONTDOOR);
   p_rm.gpio_int_rf.error_state0.read(status, err_state0, UVM_FRONTDOOR);
   p_rm.gpio_int_rf.error_state1.read(status, err_state1, UVM_FRONTDOOR);

   info_state = (info_state1 << 32) | info_state0;
   err_state = (err_state1 << 32) | err_state0;

   int_state = (err_state << (`INF_W + `SK_W)) | (info_state << `SK_W) | sh_state;
   `uvm_info(get_type_name(), $sformatf("int_state's value is %0h ", int_state), UVM_LOW)//jg
	
endtask

`endif
