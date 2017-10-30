`ifndef BUS_TRANSACTION__SV
`define BUS_TRANSACTION__SV

typedef enum{BUS_RD, BUS_WR} bus_op_e;

class bus_transaction extends uvm_sequence_item;

   rand bit[31:0] rd_data;
   rand bit[31:0] wr_data;
   rand bit[23:0] addr;

   //rand bit		  wr_en;
   //rand bit		  rd_en;
   rand bus_op_e	  bus_op;

   //read and write cannot happen in the same time
//   constraint wr_rd_con{
//	   if(wr_en == 1'b0)
//		   rd_en inside {1'b0, 1'b1};
//	   if(wr_en == 1'b1)
//		   rd_en == 1'b0;
//   }

	constraint bus_op_con {bus_op inside {BUS_RD, BUS_WR};}

   `uvm_object_utils_begin(bus_transaction)
      `uvm_field_int(rd_data, UVM_ALL_ON)
      `uvm_field_int(wr_data, UVM_ALL_ON)
      `uvm_field_int(addr   , UVM_ALL_ON)
     // `uvm_field_int(wr_en  , UVM_ALL_ON)
     // `uvm_field_int(rd_en  , UVM_ALL_ON)
	 `uvm_field_enum(bus_op_e, bus_op, UVM_ALL_ON)
   `uvm_object_utils_end

   function new(string name = "bus_transaction");
      super.new();
   endfunction

endclass
`endif
