`ifndef BUS_MONITOR__SV
`define BUS_MONITOR__SV
class bus_monitor extends uvm_monitor;

	// The virtual interface used to view HDL signals.
	virtual bus_if vif;

	// Property indicating the number of transactions occuring on the bus.
	protected int unsigned num_tr = 0;

	// TML Ports - transfer collected for monitor other components
	uvm_analysis_port #(bus_transaction)  ap;

	// TML Ports - Allows sequencer access to transfer during address phase
	uvm_blocking_peek_imp#(bus_transaction,bus_monitor) addr_trans_export;
	event addr_trans_grabbed;

	bus_transaction tr;

	`uvm_component_utils(bus_monitor)
	function new(string name = "bus_monitor", uvm_component parent = null);
		super.new(name, parent);
		tr = bus_transaction::type_id::create("tr");
		// TML ports are created here
		ap = new("ap", this);
		addr_trans_export = new("addr_trans_export", this);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual bus_if)::get(this, "", "vif", vif))
			`uvm_fatal("bus_monitor", "virtual interface must be set for vif!!!")
	endfunction

	extern task main_phase(uvm_phase phase);
	extern task collect_one_pkt(bus_transaction tr);
	extern task peek(output bus_transaction trans);
	extern virtual function void report_phase(uvm_phase phase);
endclass

task bus_monitor::main_phase(uvm_phase phase);
	@(posedge vif.rstn_50m);
	`uvm_info(get_type_name(), "Detected Reset Done", UVM_LOW)
	collect_one_pkt(tr);
endtask

task bus_monitor::collect_one_pkt(bus_transaction tr);
	forever begin
		@(posedge vif.clk_50m iff (vif.i_csn_50m != 0));
		void'(this.begin_tr(tr,"BUS_MONITOR","UVM Debug","Bus monitor transaction inside collect_one_pkt()"));
		tr.addr = vif.i_addr_50m;
		if(vif.i_rd_50m) begin
			tr.bus_op = BUS_RD;
		end else if(vif.i_wr_50m) begin
			tr.bus_op = BUS_WR;
		end

		@(posedge vif.clk_50m);
		if(tr.bus_op == BUS_RD)
			tr.rd_data = vif.o_datout_50m;
		if(tr.bus_op == BUS_WR)
			tr.wr_data = vif.i_datin_50m;
		->addr_trans_grabbed;
		this.end_tr(tr);

		ap.write(tr);
		`uvm_info(get_type_name(), $sformatf("Bus Transfer collected : \n%s", tr.sprint()), UVM_HIGH)
		num_tr++;
	end
endtask

task bus_monitor::peek(output bus_transaction trans);
	@addr_trans_grabbed;
	trans = tr;
endtask

function void bus_monitor::report_phase(uvm_phase phase);
	`uvm_info(get_type_name(), $sformatf("Report: Bus monitor collected %0d tranfers", num_tr), UVM_LOW)
endfunction

`endif
