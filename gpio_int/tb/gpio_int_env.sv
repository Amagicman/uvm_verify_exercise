`ifndef GPIO_INT_ENV__SV
`define GPIO_INT_ENV__SV

class gpio_int_env extends uvm_env;

   gpio_int_agent   i_agt;
   //gpio_int_agent   o_agt;
   bus_agent  bus_agt;
   `ifndef __NO_MODEL
	  gpio_int_model   mdl;
      gpio_int_scoreboard scb;
   `endif

   reg_model  p_rm;
   
   `ifndef __NO_MODEL
       uvm_tlm_analysis_fifo #(gpio_int_mon_transfer) agt_scb_fifo;
       uvm_tlm_analysis_fifo #(gpio_int_sequence_item) agt_mdl_fifo;
       uvm_tlm_analysis_fifo #(gpio_int_mon_transfer) mdl_scb_fifo;
   `endif
   
   function new(string name = "gpio_int_env", uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      i_agt = gpio_int_agent::type_id::create("i_agt", this);
      //o_agt = gpio_int_agent::type_id::create("o_agt", this);
      i_agt.is_active = UVM_ACTIVE;
      //o_agt.is_active = UVM_PASSIVE;
      bus_agt = bus_agent::type_id::create("bus_agt", this);
      bus_agt.is_active = UVM_ACTIVE;
	  `ifndef __NO_MODEL
          mdl = gpio_int_model::type_id::create("mdl", this);
          scb = gpio_int_scoreboard::type_id::create("scb", this);
          agt_scb_fifo = new("agt_scb_fifo", this);
          agt_mdl_fifo = new("agt_mdl_fifo", this);
          mdl_scb_fifo = new("mdl_scb_fifo", this);
	  `endif

   endfunction

   extern virtual function void connect_phase(uvm_phase phase);
   
   `uvm_component_utils(gpio_int_env)
endclass

function void gpio_int_env::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   `ifndef __NO_MODEL
       i_agt.drv2mdl_item_ap.connect(agt_mdl_fifo.analysis_export);
       mdl.drv2mdl_item_blk_gp.connect(agt_mdl_fifo.blocking_get_export);
       mdl.mdl2scb_mtr_ap.connect(mdl_scb_fifo.analysis_export);
       scb.gpio_int.mdl2scb_mtr_blk_gp.connect(mdl_scb_fifo.blocking_get_export);
       //o_agt.dut2scb_mtr_ap.connect(agt_scb_fifo.analysis_export);
       i_agt.dut2scb_mtr_ap.connect(agt_scb_fifo.analysis_export); //add by jg
       scb.gpio_int.dut2scb_mtr_blk_gp.connect(agt_scb_fifo.blocking_get_export); 
       mdl.p_rm = this.p_rm;
   `endif
   i_agt.p_rm = this.p_rm;
endfunction

`endif
