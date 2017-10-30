`ifndef GPIO_INT_SEQUENCE_ITEM
`define GPIO_INT_SEQUENCE_ITEM

class gpio_int_sequence_item extends uvm_sequence_item;

	bit	[`INT_NUM-1:0]		has_int;
	rand int unsigned int_bit;
	rand int unsigned del_to_ack;//cycles of INTA_N goes low after INTR goes high

  `uvm_object_utils_begin(gpio_int_sequence_item)
	`uvm_field_int(has_int, UVM_ALL_ON)
	`uvm_field_int(int_bit, UVM_ALL_ON)
	`uvm_field_int(del_to_ack, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "gpio_int_sequence_item");
    super.new(name);
  endfunction : new

  constraint int_bit_con {
	  int_bit inside {[0:108]};
  }

  constraint del_to_ack_con {
	  del_to_ack inside {[2:8]};
  }

function void post_randomize();
	has_int = (1<<int_bit);
endfunction

endclass : gpio_int_sequence_item

`endif
