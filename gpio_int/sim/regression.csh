#!/bin/csh -f

set WAVE = ""
set COV = "-cov"
set AST = "-ast"
#set AST = ""
set LINE_NUM = "1000"

./run.csh -t test_reg_rw $WAVE -line_num $LINE_NUM $COV $AST -no_model -verbos NONE -seed 595855776
./run.csh -t test_intr_code $WAVE -line_num $LINE_NUM $COV $AST -verbos NONE -seed 595825204
./run.csh -t test_int_priority $WAVE -line_num $LINE_NUM $COV $AST -no_model -verbos NONE -seed 595839632
./run.csh -t test_int_same_domain_multi $WAVE -line_num $LINE_NUM $COV $AST -no_model -verbos NONE -seed 595838692
./run.csh -t test_gpio_int_cov $WAVE -line_num $LINE_NUM $COV $AST -no_model -verbos NONE -seed 595864632
./run.csh -cov_merge
./run.csh -ast_merge

iccr -gui -test ./cov_work/scope/merge_code &
