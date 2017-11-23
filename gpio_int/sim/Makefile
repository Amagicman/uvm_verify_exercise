SEED = `date +%s%N | cut -c 5-13`
TESTCASE = test_intr_code
#TESTCASE = test_reg_rw
#TESTCASE = test_int_priority
#TESTCASE = test_int_same_domain_multi
#TESTCASE = test_gpio_int_cov
LINE_NUM = 10
HAVE_MODEL = yes

w:wave

h:help

IRUN = irun
IRUN_OPTS = -access +rwc +sv \
		 -f filelist.f \
		 -seed $(SEED) \
		 -licqueue \
		 -timescale 1ps/1ps \
		 -uvm -uvmhome $(UVM_HOME) \
		 +LINEDEBUG \
		 +UVM_TESTNAME=$(TESTCASE) \

IRUN_OPTS += +define+LINE_NUM=$(LINE_NUM)

ifeq ($(HAVE_MODEL),no)
	IRUN_OPTS += +define+__NO_MODEL
endif

all:
	$(IRUN) $(IRUN_OPTS)

wave:
	@simvision top_tb.shm &

clean:
	rm -rf *.log *.err INCA* *.key *.vcd *.history *.dsn *.trn *.shm .simvision *.diag ../.simvision ../*.diag

help:
	@echo -e "1.To run this script, type:"
	@echo -e "\tmake TESTCASE=[case_name] HAVE_MODEL=[yes/no] LINE_NUM=[number]"
	@echo -e "By default, TESTCASE=test_intr_code, HAVE_MODEL=yes, LINE_NUM=10"
	@echo -e "2.To watch the waveform, type:"
	@echo -e "\tmake w, OR make wave"
	@echo -e "3.To clean the generated files, type:"
	@echo -e "\tmake clean"
