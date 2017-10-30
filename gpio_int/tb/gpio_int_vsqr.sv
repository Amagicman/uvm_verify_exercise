`ifndef GPIO_INT_VSQR__SV
`define GPIO_INT_VSQR__SV

class gpio_int_vsqr extends uvm_sequencer;
  
   gpio_int_sequencer  p_gpio_int_sqr;
   bus_sequencer p_bus_sqr;
   reg_model     p_rm;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 
   
   `uvm_component_utils(gpio_int_vsqr)
endclass

`endif
