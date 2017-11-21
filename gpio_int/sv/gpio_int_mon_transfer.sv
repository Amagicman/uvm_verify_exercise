`ifndef GPIO_INT_MON_TRANSFER
`define GPIO_INT_MON_TRANSFER

class gpio_int_mon_transfer extends uvm_sequence_item;

  //bit  [31:0]	datout;
  bit					INTR;
  bit  [6:0]			INT_CODE;
  bit  [`INT_NUM-1:0]	int_state;

  `uvm_object_utils_begin(gpio_int_mon_transfer)
   // `uvm_field_int(datout, UVM_ALL_ON)
    `uvm_field_int(INTR, UVM_ALL_ON)
    `uvm_field_int(INT_CODE, UVM_ALL_ON)
    `uvm_field_int(int_state, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "gpio_int_mon_transfer");
    super.new(name);
  endfunction

endclass

`endif
