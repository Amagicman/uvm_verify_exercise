#!/bin/csh -f

set WAVE = ""
set COV = "-cov"
set AST = "-ast"
#set AST = ""
set LINE_NUM = "1000"

./run.csh -t test_gpio_int_int_code $WAVE -line_num $LINE_NUM $COV $AST -verbos NONE -seed 595825204
./run.csh -t test_gpio_int_int_code $WAVE -line_num $LINE_NUM $COV $AST -verbos NONE -seed 312961682
./run.csh -t test_gpio_int_int_code $WAVE -line_num $LINE_NUM $COV $AST -verbos NONE -seed 399423346
./run.csh -t test_gpio_int_int_code $WAVE -line_num $LINE_NUM $COV $AST -verbos NONE -seed 400422134
./run.csh -t test_gpio_int_oriented $WAVE -line_num $LINE_NUM $COV $AST -verbos NONE
./run.csh -t test_gpio_int_reg_rw $WAVE -line_num $LINE_NUM $COV $AST -verbos NONE -seed 595855776
./run.csh -t test_gpio_int_priority $WAVE -line_num $LINE_NUM $COV $AST -verbos NONE -seed 595839632
./run.csh -cov_merge
./run.csh -ast_merge

iccr -gui -test ./cov_work/scope/merge_code &
