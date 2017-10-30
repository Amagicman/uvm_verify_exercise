SEED = `date +%s%N | cut -c 5-13`
TESTCASE = test_gpio_int_int_code
#TESTCASE = test_gpio_int_reg_rw
#TESTCASE = test_gpio_int_priority
LINE_NUM = 100

all:
	irun -access +rwc +sv \
		 +define+LINE_NUM=$(LINE_NUM) \
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
