`ifndef GPIO_INT_SEQUENCE_ITEM
`define GPIO_INT_SEQUENCE_ITEM

typedef enum{ACK_AFTER_REQ, ACK_BEFORE_REQ} shake_type;
typedef enum{LEVEL, EDGE} trig_type;
typedef enum{SINGLE, MULTI} int_num_type;

class gpio_int_sequence_item extends uvm_sequence_item;

	rand trig_type trig;
	rand int_num_type int_num;
	bit	[`INT_NUM-1:0]		has_int;
	rand bit	[`INT_NUM-1:0]		multi_int;
	rand int unsigned int_bit;
	rand bit unsigned int_ack;
	rand shake_type shake;
	rand int unsigned del_to_ack;//cycles of INTA_N goes low after INTR goes high

  `uvm_object_utils_begin(gpio_int_sequence_item)
	`uvm_field_enum(int_num_type, int_num, UVM_ALL_ON)
	if(int_num == MULTI) begin
		`uvm_field_int(multi_int, UVM_ALL_ON)
	end
	if(int_num == SINGLE) begin
		`uvm_field_int(has_int, UVM_ALL_ON)
	end
	`uvm_field_int(int_bit, UVM_ALL_ON)
	`uvm_field_enum(trig_type, trig, UVM_ALL_ON)
	`uvm_field_int(int_ack, UVM_ALL_ON)
	`uvm_field_enum(shake_type, shake, UVM_ALL_ON)
	`uvm_field_int(del_to_ack, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "gpio_int_sequence_item");
    super.new(name);
  endfunction : new

  constraint int_bit_con {
	  int_bit inside {[0:108]};
  }

  constraint del_to_ack_con {
	  del_to_ack inside {[0:4]};
  }

function void post_randomize();
	if(int_num == SINGLE) begin
		has_int = (1<<int_bit);
	end
	if(int_num == MULTI) begin
		has_int = multi_int;
	end
endfunction

endclass : gpio_int_sequence_item

`endif
