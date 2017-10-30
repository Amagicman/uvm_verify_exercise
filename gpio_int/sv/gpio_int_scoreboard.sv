`ifndef GPIO_INT_SCOREBOARD__SV
`define GPIO_INT_SCOREBOARD__SV

`define MAX_UN_MTCH_NUM 10 

class usr_scoreboard_uvc #(type T = uvm_sequence_item) extends uvm_component;
  `uvm_component_param_utils(usr_scoreboard_uvc#(T))
  static int inst_num = 0;
  string name;
  uvm_blocking_get_port#(T) dut2scb_mtr_blk_gp;
  uvm_blocking_get_port#(T) mdl2scb_mtr_blk_gp;
  T dut_mtr,mdl_mtr,tmp_mtr,tmp_mtr_cp;
  T mdl_mtr_exp_q[$];
  int num_dut_rcv_mtr;
  int num_mdl_rcv_mtr;
  int num_mch_mtr;
  int num_nmch_mtr;
  time drain_time;

  function new(string name ,uvm_component parent);
    super.new(name,parent);
    this.name = name;
    dut2scb_mtr_blk_gp = new("dut2scb_mtr_blk_gp",this);
    mdl2scb_mtr_blk_gp  = new("mdl2scb_mtr_blk_gp" ,this);
    inst_num ++;
    //$display("\t%s--%s static int inst_num = %0d",get_full_name(),this.name,inst_num);
  endfunction

  virtual function void reset();
    mdl_mtr_exp_q.delete();
    num_dut_rcv_mtr = 0;
    num_mdl_rcv_mtr  = 0;
    num_mch_mtr     = 0;
    //num_nmch_mtr    = 0;
  endfunction

  task compare_run();
    mdl_mtr  = T::type_id::create("mdl_mtr" ,this);
    dut_mtr = T::type_id::create("dut_mtr",this);
    tmp_mtr = T::type_id::create("tmp_mtr" ,this);
    tmp_mtr_cp = T::type_id::create("tmp_mtr_cp",this);
    fork
      while(1) begin // get expect tr thread
        mdl2scb_mtr_blk_gp.get(tmp_mtr);
        //$display("[%s] %0t \nmdl2scb_mtr_blk_gp get tr is:\n%s",get_full_name(),$time,tmp_mtr.sprint());
        if(!$cast(tmp_mtr_cp,tmp_mtr.clone()))
          `uvm_fatal(get_type_name,"cast err")
        mdl_mtr_exp_q.push_back(tmp_mtr_cp);
        num_mdl_rcv_mtr++;
      end
      while(1) begin // compare thread
        dut2scb_mtr_blk_gp.get(dut_mtr);
        //$display("[%s] %0t \ndut2scb_mtr_blk_gp get tr is:\n%s",get_full_name(),$time,dut_mtr.sprint());
        num_dut_rcv_mtr++;
        if(mdl_mtr_exp_q.size()>0) begin // expect queue not empty
          mdl_mtr = mdl_mtr_exp_q.pop_front();
          if(dut_mtr.compare(mdl_mtr)) begin // compare success
            num_mch_mtr++;
          end
          else begin // compare failed
            num_nmch_mtr++;
            $display({name,$sformatf(" NO.%0d %0tps compare failed!\ndut is:\n%s\nbut mdl expect is:\n%s\n",
              num_dut_rcv_mtr,$time,dut_mtr.sprint(),mdl_mtr.sprint())});
            if(num_nmch_mtr>`MAX_UN_MTCH_NUM)
              `uvm_fatal({"scoreboard - ",name},{name," over MAX_UN_MTCH_NUM failed"})
          end
        end
        else begin // expect queue empty
          num_nmch_mtr++;
          $display({name,$sformatf(" NO.%0d failed! %0tps expect queue is empty!\ndut is:\n%s",num_dut_rcv_mtr,$time,dut_mtr.sprint())});
          if(num_nmch_mtr>`MAX_UN_MTCH_NUM)
            `uvm_fatal({"scoreboard - ",name},{name," over MAX_UN_MTCH_NUM failed"})
          //`usr_check_exp_empt_num(cfg,0);
        end
      end
    join_none
  endtask

  virtual function void mon_transfer_sprint();
     $display("\t\t\t--------->> %s No.%0d <<-------------",this.name,num_dut_rcv_mtr);
     $display("dut is:\n%s\nmdl is:\n%s",dut_mtr.sprint(),mdl_mtr.sprint());
     $display("===========================================================================\n\n");
  endfunction

  virtual function void report_comp_result();
    if(`__SCOREBOARD_RESULT_ALL_ON || ((!`__SCOREBOARD_RESULT_ALL_ON)&&num_dut_rcv_mtr!=0&&num_mdl_rcv_mtr!=0)) begin
      $display("\t-------------->>>  %s  <<<--------------",name);
      $display("\t\t[ %s ] -> dut_mtr  =%0d",name,num_dut_rcv_mtr);
      $display("\t\t[ %s ] -> mdl_mtr  =%0d",name,num_mdl_rcv_mtr );
      $display("\t\t[ %s ] -> mch_mtr  =%0d",name,num_mch_mtr    );
      $display("\t\t[ %s ] -> nmch_mtr =%0d",name,num_nmch_mtr   );
      if(num_mdl_rcv_mtr!=num_dut_rcv_mtr)
        $display("\t\t[%s] *E DUT and REFM output num doesn't match\n\n",get_type_name());
      else
        $display("\n");
    end
  endfunction

endclass

class gpio_int_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(gpio_int_scoreboard)
  localparam NUM=5;

  usr_scoreboard_uvc#(gpio_int_mon_transfer) gpio_int;

  function new(string name,uvm_component parent);
    super.new(name,parent);
    gpio_int = usr_scoreboard_uvc#(gpio_int_mon_transfer)::type_id::create("gpio_int",this);
  endfunction

  virtual task main_phase(uvm_phase phase);
    gpio_int.compare_run();
  endtask

  virtual function void report();
    $display("\n\n\n\t---------------->>  SCOREBOARD COMPARE RESULTS  <<-----------------\n");
    gpio_int.report_comp_result();
  endfunction

endclass


`endif
