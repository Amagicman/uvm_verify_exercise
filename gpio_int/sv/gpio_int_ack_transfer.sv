`ifndef GPIO_INT_ACK_TRANSFER__SV
`define GPIO_INT_ACK_TRANSFER__SV

class gpio_int_ack_transfer extends uvm_sequence_item;

	bit int_ack;
	`uvm_object_utils_begin(gpio_int_ack_transfer)
		`uvm_field_int(int_ack, UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name = "gpio_int_ack_transfer");
		super.new(name);
	endfunction

endclass

`endif
