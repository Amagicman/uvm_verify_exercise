
class usr_agent#(type DRIVER=uvm_driver,MONITOR=uvm_monitor,SEQR=uvm_sequencer,SEQ=uvm_sequence_item,MTR=SEQ) extends uvm_agent;
  `uvm_component_param_utils(usr_agent#(DRIVER,MONITOR,SEQR,SEQ,MTR))
  uvm_active_passive_enum dut2mdl_active = UVM_PASSIVE;
  protected uvm_active_passive_enum drv_active = UVM_ACTIVE;
  
  DRIVER  drv;
  MONITOR mon;
  SEQR    sqr;

  uvm_analysis_port#(MTR)     dut2scb_mtr_ap;
  uvm_analysis_port#(SEQ)     drv2mdl_item_ap;
  uvm_analysis_port#(MTR)     dut2mdl_mtr_ap;
  // uvm_blocking_get_port#(MTR) mdl2dut_blk_gp;

  // new constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction:new
  
  function void set_dut2mdl_active(uvm_active_passive_enum dut2mdl_active = UVM_PASSIVE);
    if(dut2mdl_active==UVM_ACTIVE&&drv_active!=UVM_ACTIVE)
      `uvm_fatal(get_type_name(),"drv_active is not UVM_ACTIVE when set dut2mdl_active UVM_ACTIVE")
    this.dut2mdl_active = dut2mdl_active;
  endfunction

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon   = MONITOR::type_id::create("mon",this);
    dut2scb_mtr_ap = new("dut2scb_mtr_ap",this);
    if(drv_active==UVM_ACTIVE) begin
      drv    = DRIVER::type_id::create("drv",this);
      sqr = SEQR::type_id::create("sqr",this);
      drv2mdl_item_ap = new("drv2mdl_item_ap",this);
      drv.set_dut2mdl_active(dut2mdl_active);
    end
    if(dut2mdl_active==UVM_ACTIVE) begin
      dut2mdl_mtr_ap = new("dut2mdl_mtr_ap",this);
      // mdl2dut_blk_gp = new("mdl2dut_blk_gp",this);
    end
  endfunction:build_phase
  
  // connect
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(drv_active==UVM_ACTIVE) begin
      drv.seq_item_port.connect(sqr.seq_item_export);
      drv2mdl_item_ap = drv.drv2mdl_item_ap;
    end
    if(dut2mdl_active==UVM_ACTIVE) begin
      this.dut2mdl_mtr_ap = mon.dut2scb_mtr_ap;
      if(drv_active!=UVM_ACTIVE)
        `uvm_fatal(get_type_name(),"drv_active is not UVM_ACTIVE when connect dut <--> mdl tlm port")
      // drv.mdl2dut_blk_gp = this.mdl2dut_blk_gp;
    end
    this.dut2scb_mtr_ap = mon.dut2scb_mtr_ap;
  endfunction:connect_phase

endclass

//`define usr_agent_decl(UNIT) typedef usr_agent#(UNIT``_driver,UNIT``_monitor, \
//        UNIT``_sequencer,UNIT``_sequence_item,UNIT``_mon_transfer) UNIT``_agent;
//
//`usr_agent_decl(gpio_int)
class gpio_int_agent extends usr_agent #(gpio_int_driver, gpio_int_monitor, gpio_int_sequencer, gpio_int_sequence_item, gpio_int_mon_transfer);

	reg_model p_rm;

	function new(string name = "gpio_int_agent", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		mon.p_rm = this.p_rm;
	endfunction

	`uvm_component_utils(gpio_int_agent)

endclass : gpio_int_agent
