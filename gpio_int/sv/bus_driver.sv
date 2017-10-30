`ifndef BUS_DRIVER__SV
`define BUS_DRIVER__SV
class bus_driver extends uvm_driver#(bus_transaction);

   virtual bus_if vif;

   `uvm_component_utils(bus_driver)
   function new(string name = "bus_driver", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual bus_if)::get(this, "", "vif", vif))
         `uvm_fatal("bus_driver", "virtual interface must be set for vif!!!")
   endfunction

   extern task run_phase(uvm_phase phase);
   extern task get_and_drive();
   extern task reset_signals();
   extern task drive_one_pkt(bus_transaction tr);
   extern task drive_address_phase(bus_transaction tr);
   extern task drive_data_phase(bus_transaction tr);

endclass

task bus_driver::run_phase(uvm_phase phase);
		get_and_drive();
endtask

task bus_driver::get_and_drive();
	while(1) begin
//		reset_signals();
		fork
			@(negedge vif.rstn_50m)
		begin
			forever begin
				@(posedge vif.clk_50m iff (vif.rstn_50m))
				seq_item_port.get_next_item(req);
				drive_one_pkt(req);
				seq_item_port.item_done(req);
			end
		end
		join_any
		disable fork;
	
		if(req.is_active()) this.end_tr(req);
	end
endtask

task bus_driver::reset_signals();
		wait(!vif.rstn_50m);
		`uvm_info(get_type_name(), "Reset observed", UVM_MEDIUM);
		vif.i_csn_50m <= 1'b1;
		vif.i_wr_50m <= 1'b0;
		vif.i_rd_50m <= 1'b0;
		vif.i_addr_50m <= 24'b0;
		vif.i_datin_50m <= 32'b0;
endtask

task bus_driver::drive_one_pkt(bus_transaction tr);
	void'(this.begin_tr(tr, "BUS_DRIVER", "UVM_Debug", "bus transaction from get_and_drive"));
   `uvm_info("bus_driver", "begin to drive one pkt", UVM_HIGH);
	vif.wr_valid <= 1'b0;
	vif.rd_valid <= 1'b0;
	repeat(1) @(posedge vif.clk_50m);

	drive_address_phase(tr);
	drive_data_phase(tr);
	//For Debug
	`uvm_info("BUS_DRIVER_TR", $sformatf("Finished Driving One Bus Transfer \n%s", tr.sprint()), UVM_HIGH)

	this.end_tr(tr);

	`uvm_info("bus_driver", "end drive one pkt", UVM_HIGH);
endtask

// Drive the address phase of the transfer
task bus_driver::drive_address_phase(bus_transaction tr);
	vif.i_addr_50m <= tr.addr;
	vif.i_csn_50m <= 1'b0;
	if (tr.bus_op == BUS_RD) begin
		vif.i_rd_50m <= 1'b1;
		vif.i_wr_50m <= 1'b0;
	end
	else begin
		vif.i_rd_50m <= 1'b0;
		vif.i_wr_50m <= 1'b1;
		vif.wr_valid <= 1'b1;
		vif.i_datin_50m <= tr.wr_data;
		//@(posedge vif.clk_50m);
	end
endtask

task bus_driver::drive_data_phase(bus_transaction tr);
	@(posedge vif.clk_50m);
	if (tr.bus_op == BUS_RD) begin
		repeat(6) @(posedge vif.clk_50m);
		vif.rd_valid <= 1'b1;
		tr.rd_data = vif.o_datout_50m;
	end
		vif.i_csn_50m <= 1'b1;
endtask

`endif
