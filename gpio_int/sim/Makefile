SEED = `date +%s%N | cut -c 5-13`
#TESTCASE = test_intr_code
#TESTCASE = test_reg_rw
#TESTCASE = test_int_priority
TESTCASE = test_int_same_domain_multi
#TESTCASE = test_gpio_int_cov
LINE_NUM = 10

all:
	irun -access +rwc +sv \
		 +define+LINE_NUM=$(LINE_NUM) \
		 +define+__NO_MODEL \
		 -f filelist.f \
		 -seed $(SEED) \
		 -licqueue \
		 -timescale 1ps/1ps \
		 -uvm -uvmhome $(UVM_HOME) \
		 +LINEDEBUG \
		 +UVM_TESTNAME=$(TESTCASE)
w:
	@simvision top_tb.shm &

clean:
	rm -rf *.log *.err INCA* *.key *.vcd *.history *.dsn *.trn *.shm .simvision *.diag ../.simvision ../*.diag
