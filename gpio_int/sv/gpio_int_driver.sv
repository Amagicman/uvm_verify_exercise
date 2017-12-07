`ifndef GPIO_INT_DRIVER__SV
`define GPIO_INT_DRIVER__SV

class usr_drv_cb_cls#(type SEQ = int) extends uvm_callback;

  virtual task drv_item_cb(ref SEQ item);
    `uvm_info(get_full_name(),"drv cb item pro",UVM_HIGH);
  endtask

endclass


class usr_driver#(type SEQ = uvm_sequence_item,MTR = SEQ) extends uvm_driver #(SEQ);
  `uvm_component_param_utils(usr_driver#(SEQ))
  //`uvm_register_cb(usr_driver#(SEQ),drv_cb_cls)
  uvm_active_passive_enum dut2mdl_active = UVM_PASSIVE;

  uvm_analysis_port#(SEQ) drv2mdl_item_ap;
  uvm_blocking_get_port#(MTR) mdl2dut_blk_gp;
  event rst_evt;

  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction:new
  
  virtual function void set_dut2mdl_active(uvm_active_passive_enum dut2mdl_active = UVM_PASSIVE);
    this.dut2mdl_active = dut2mdl_active;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(dut2mdl_active==UVM_ACTIVE) begin
      mdl2dut_blk_gp = new("mdl2dut_blk_gp",this);
    end
    drv2mdl_item_ap = new("drv2mdl_item_ap",this);
  endfunction:build_phase

  //virtual task run_phase(uvm_phase phase);
  //  super.run_phase(phase);
  //  `uvm_do_callbacks(usr_driver,drv_cb_cls#(SEQ),drv_run_cb(this,drv2mdl_item_ap));
  //endtask

endclass

class gpio_int_driver extends usr_driver#(gpio_int_sequence_item, gpio_int_mon_transfer);

   virtual gpio_int_if vif;
   cov_gpio_int_seq tr_cov;

   `uvm_component_utils(gpio_int_driver)
   function new(string name = "gpio_int_driver", uvm_component parent = null);
      super.new(name, parent);
	  `ifdef __COV_ENABLE
		tr_cov = new("gpio_int");
	`endif
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual gpio_int_if)::get(this, "", "vif", vif))
         `uvm_fatal("gpio_int_driver", "virtual interface must be set for vif!!!")
   endfunction

   extern task main_phase(uvm_phase phase);
   extern task drive_one_pkt(gpio_int_sequence_item item);
   extern task signal_reset();
   extern task int_src_input(gpio_int_sequence_item item);
   extern task int_ack_input(gpio_int_sequence_item item);
endclass

task gpio_int_driver::main_phase(uvm_phase phase);
  signal_reset();
  @(posedge vif.clk[0] iff vif.rstn_50m == 1);
   repeat(3) @(posedge vif.clk[0]);
   while(1) begin
      seq_item_port.get_next_item(req);
	  drv2mdl_item_ap.write(req);
      drive_one_pkt(req);
	  repeat(1) @(posedge vif.clk[0]);
      seq_item_port.item_done();
	  `ifdef __COV_ENABLE
		tr_cov.sample_tr(req);
	`endif
   end
endtask

task gpio_int_driver::signal_reset();
  vif.INTA_N <= 1'b1;
  //vif.INTA_N <= 1'b0;
  vif.int_err_lbus <= `ERR_LBUS'b0;
  vif.int_err_50m <= `ERR_50M'b0;
  vif.int_err_200m <= `ERR_200M'b0;
  vif.int_err_400m <= `ERR_400M'b0;
  vif.int_info_300m <= `INF_300M'b0;
  vif.int_info_xaui <= `INF_XAUI'b0;
  vif.int_info_50m <= `INF_50M'b0;
  vif.int_info_400m <= `INF_400M'b0;
  vif.int_shake_50m <= `SK_50M'b0;
  vif.int_shake_bufd <= `SK_BUFD'b0;
  vif.int_shake_100m <= `SK_100M'b0;
endtask

task gpio_int_driver::drive_one_pkt(gpio_int_sequence_item item);
   `uvm_info("gpio_int_driver", "begin to drive one pkt", UVM_HIGH);
   if(item.shake == ACK_AFTER_REQ) begin
	   int_src_input(item);
	   int_ack_input(item);
   end else begin
	   int_ack_input(item);
	   int_src_input(item);
   end

   repeat(1) @(posedge vif.clk[0]);
   signal_reset();

   `uvm_info("gpio_int_driver", "end drive one pkt", UVM_HIGH);
endtask

task gpio_int_driver::int_src_input(gpio_int_sequence_item item);
   
   $display("\n\t===== the drived pkt is : \n");//jg
   item.print();//jg
   repeat(1) @(posedge vif.clk[0]);
   fork
	   vif.int_err_lbus <= item.has_int[108];

		begin
			vif.int_err_50m <= item.has_int[107];
			if(item.trig == EDGE) begin
				#`PERIOD_50M vif.int_err_50m <= 1'b0;
			end
		end

		begin
			vif.int_err_200m[`ERR_200M-1:0] <= item.has_int[106:104];
			if(item.trig == EDGE) begin
				#`PERIOD_200M vif.int_err_200m[`ERR_200M-1:0] <= 0;
			end
		end

		begin
			vif.int_err_400m[`ERR_400M-1:0] <= item.has_int[103:65];
			if(item.trig == EDGE) begin
				#`PERIOD_400M vif.int_err_400m[`ERR_400M-1:0] <= 0;
			end
		end

		begin
			vif.int_info_300m[`INF_300M-1:0] <= item.has_int[64:63];
			if(item.trig == EDGE) begin
				#`PERIOD_300M vif.int_info_300m[`INF_300M-1:0] <= 0;
			end
		end

		vif.int_info_xaui[`INF_XAUI-1:0] <= item.has_int[62:57];

		begin
			vif.int_info_50m[`INF_50M-1:0] <= item.has_int[56:54];
			if(item.trig == EDGE) begin
				#`PERIOD_50M vif.int_info_50m[`INF_50M-1:0] <= 0;
			end
		end

		begin
			vif.int_info_400m[`INF_400M-1:0] <= item.has_int[53:15];
			if(item.trig == EDGE) begin
				#`PERIOD_400M vif.int_info_400m[`INF_400M-1:0] <= 0;
			end
		end

		begin
			vif.int_shake_50m <= item.has_int[14];
			if(item.trig == EDGE) begin
				#`PERIOD_50M vif.int_shake_50m <= 1'b0;
			end
		end

		vif.int_shake_bufd[`SK_BUFD-1:0] <= item.has_int[13:12];

		begin
			vif.int_shake_100m[`SK_100M-1:0] <= item.has_int[11:0];
			if(item.trig == EDGE) begin
				#`PERIOD_100M vif.int_shake_100m[`SK_100M-1:0] <= 0;
			end
		end
	join

	fork
		wait(vif.INTR);
		#(`PERIOD_CPU * 6);
	join_any
	disable fork;
	-> `DRV_OVER_EVT;
	
endtask

task gpio_int_driver::int_ack_input(gpio_int_sequence_item item);
	begin
		repeat(item.del_to_ack) @(posedge vif.clk[0]);
		vif.INTA_N <= item.int_ack;
	end
endtask

`endif
