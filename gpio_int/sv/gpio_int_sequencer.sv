`ifndef GPIO_INT_SEQUENCER__SV
`define GPIO_INT_SEQUENCER__SV

class gpio_int_sequencer extends uvm_sequencer #(gpio_int_sequence_item);
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 
   
   `uvm_component_utils(gpio_int_sequencer)
endclass

`endif
