#-----------------------------------------------------------------------------
#
# Filename    :  Makefile ,v 1.0 2014-1-8 16:52:43
#
# Created by  :  VerificationTeam
#
# Description : Demonstrates Verilog DUT and SV TB using IES
#
#   The Makefile works on two seperate flows.   The DEBUG flow is intended to be used
#   during debugging of a testcase and/or the DUT.   The REGRESSION flow is used
#   during regression runs and collects coverage data.
#  
#   The DEBUG flow turns on VPD dumping and turns off coverage collection.   After 
#   building a testcase using the debug targets, you can debug the TB and the DUT 
#   source code using the testbench debugger and SimVision.   Of course, you can turn on
#   coverage metrics and run in debug mode by changing compile and runtime options
#   in the makefile.   These changes are independent of the regression flow so that
#   the regressions will still run optimally without the interference of VPD 
#   dumping.
#  
#   The REGRESSION flow turns off VPD dumping and turns on Coverage Metrics and TB
#   coverage collection.   This flow is intended to support verification engineers who
#   are working through the regression process and are interested in coverage
#   collection and urg.
#  
#   Command Line
#   ------------
#   The Makefile supports the following command line
#  
#   % make target_name_* <SEED=xxx> <VERBOSITY=xxxx>
#  
#   Where target_name is the name of a testcase located in the test directory.   Every
#   test in the test directory is named using tc_{test_name}.   All of the test targets
#   are listed in the TEST TARGETS section of the makefile.
#  
#   Compile and Run Testcases
#   -------------------------
#   To compile and run a tescase use the tc_* and regress_tc_* targets.
#  
#   % make tc_1           // Builds and runs test 1 with VPD dumping and debug on
#   % make regress_tc_1 // Builds and runs test 1 with coverage turned on
#  
#   Debugging Testcases
#   -------------------
#   You can use SimVision and the testbench debugger to visualize waveforms and testbench
#   execution.   You must first build the testbench using the make compile_* command.
#  
#   % make compile_tc_1        // Builds test 1 for debugging
#  
#   Once you have built the environment with the proper debug switches, you can use SimVision
#   and the testbench debugger.
#  
#   % make gui_tc_1          // Debug test 1 with SimVision
#   % make tb_gui_tc_1       // Debug test 1 with the testbench debugger
#   % make both_guis_tc_1    // Debug using both guis
#   % make pp_tc_1           // Debug using the VPD file
#  
#   If you want, you can turn on coverage for the DEBUG flow by uncommenting the 
#   coverage flag in the makefile.   If you do this, you can still look at coverage.
#   This may be useful in helping those who are debugging coverage related issues.
#  
#   % make urg              // Visualize coverage data from debug runs
#  
#   Regression Testcases
#   --------------------
#   Regression tests are used to collect coverage information.   To build a testcase
#   for coverage collection use a command similar to the following.
#  
#   % make regress_build_tc_1   // Build and run a regression test with a default seed
#   Once the test has been built, you can run it again with a new seed.
#  
#   % make regress_run_tc_1 SEED=1234
#  
#   After running one or more regression runs, you can visualize the coverage data
#   using urg and the following command
#  
#   % make regress_urg
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
#
# HOW TO REUSE THIS FILE ON ANOTHER DUT
#
# STEP 1:   Update the file locations as required
# STEP 2:   Update the DUT section with directory and source location info
# STEP 3:   Update the TB section with directory and source location info
# STEP 4:   Update the Coverage section with name of dut top (eg top.dut)
# STEP 5:   Add test targets to the debug and regression targets section
# STEP 5:   Adjust the debug and regression compile and run time arguments
# STEP 7:   Adjust command line options as required
# STEP 8:   Run the debug and regression targets
#          % make tc_*
#
#----------------------------------------------------------------------------- 


PHONY : default help clean regress_clean
default: help 



#-----------------------------------------------------------------------------
#
# DIRECTORIES AND PUBLIC OPTIONS
#
#-----------------------------------------------------------------------------
#-------------------------------------
# ENVIRONMENT DIRECTORIES        
#-------------------------------------
WORK          = ./work
OUTPUT_DIR    = ./output
COV_DIR       = ./coverage
LOG_DIR       = ./logs
#-------------------------------------
# DUT(Device Under Test) DIRECTORIES        
#-------------------------------------
DUT_SRC_DIR   =  ../dut
DUT_SRC       = -f $(DUT_SRC_DIR)/rtl_list.f    
DUT_INC      += +incdir+/user/myproj/PROJECT/RTL/SRC/mymodule/
#-------------------------------------
#  TB(Testbench) DIRECTORIES       
#-------------------------------------
TB_SRC_DIR    = ../testbench
TB_SRC       += ../testbench_top.sv
TB_SRC       += ../*_intf.sv
TB_SRC       += ../testcase/$(TB_TEST).sv
TB_SRC       += $(TB_SRC_DIR)/dut_rm_top.sv 
TB_INC       += +incdir+$(TB_SRC_DIR)/mpdu_trx_tb/vip           
TB_INC       += +incdir+$(TB_SRC_DIR)/mpdu_trx_tb/env           
TB_INC       += +incdir+$(TB_SRC_DIR)/mpdu_trx_tb/tests         
TB_INC       += +incdir+$(DW_MODELS_DIR)/include/svtb       
TB_INC       += +incdir+$(DW_MODELS_DIR)/include/verilog    
TB_INC       += +incdir+$(DW_MODELS_DIR)/svtb               
#-------------------------------------
# REM(Reference Module) DIRECTORIES        
#-------------------------------------
REM_SRC_DIR   =  ../refm
REM_SRC       = -f $(REM_SRC_DIR)/rtl_list.f               
REM_INC      += +incdir+/user/myproj/PROJECT/RTL/SRC/mymodule/
#-------------------------------------
# SVA(Systemverilog Assertion) DIRECTORIES       
#-------------------------------------
SVA_SRC_DIR   = ../sva
SVA_SRC      += ../$(SVA_SRC_DIR)/*.sv
#-------------------------------------
# VIP(Verification IP) DIRECTORIES       
#-------------------------------------
# Set this to the location where you installed the designware models.   This
# depends on whether you ran the setup_vip_dw_home to install the models or
# the setup_vip_here script.
DW_MODELS_DIR = /user/synopsys/designware                                                            #ljw  修改为IES指定的VIP安装目录
DESIGNWARE_HOME = ~synopsys/bk/designware                                                            #ljw  修改为IES指定的VIP文件目录
#----------------------------------------------------------------------------
# DEVICE UNDER TEST(DUT) OPTIONS
#-----------------------------------------------------------------------------
DUT_CMP_OPTIONS   += +libext+.v                                                                      #ljw  指定dut 所需的库文件，此处是vcs的库     
DUT_CMP_OPTIONS   += -timescale=1ps/1ps                                                              #ljw  指定dut的timescale
DUT_CMP_OPTIONS   += -override_timescale=1ps/1ps                                                     #ljw  是否dut的timescale需要override 覆盖           
#-----------------------------------------------------------------------------
# TESTBENCH OPTIONS
#-----------------------------------------------------------------------------
TB_CMP_OPTIONS += -tb_timescale=1ns/1ps                                                              #ljw  指定tb的timescale
TB_CMP_OPTIONS += +pkgdir+$(DW_MODELS_DIR)/include/svtb                                              #ljw  修改为IES指定的VIP文件目录 
TB_CMP_OPTIONS += -ntb_incdir $(DW_MODELS_DIR)/include/vera                                          #ljw  根据实际情况修改
                                                                                                    
TB_CMP_OPTIONS += -ntb_incdir $(DESIGNWARE_HOME)/vip/vmt/latest/vera/src                             #ljw  include vip source file directory    根据实际情况修改
TB_CMP_OPTIONS += -ntb_incdir $(DESIGNWARE_HOME)/vip/amba/latest/vera/src                            #ljw  include vip source file directory    根据实际情况修改
TB_CMP_OPTIONS += -ntb_incdir $(DESIGNWARE_HOME)/vip/amba/latest/axi_master_v                        #ljw  include vip source file directory    根据实际情况修改
TB_CMP_OPTIONS += -ntb_incdir $(DESIGNWARE_HOME)/vip/amba/latest/axi_master_r                        #ljw  include vip source file directory    根据实际情况修改
TB_CMP_OPTIONS += -ntb_incdir $(DESIGNWARE_HOME)/vip/amba/latest/axi_slave_vm                        #ljw  include vip source file directory    根据实际情况修改
TB_CMP_OPTIONS += -ntb_incdir $(DESIGNWARE_HOME)/vip/amba/latest/axi_slave_rv                        #ljw  include vip source file directory    根据实际情况修改
TB_CMP_OPTIONS += -ntb_incdir $(DESIGNWARE_HOME)/vip/amba/latest/axi_monitor_                        #ljw  include vip source file directory    根据实际情况修改
TB_CMP_OPTIONS += -ntb_incdir $(DESIGNWARE_HOME)/vip/amba/latest/axi_monitor_                        #ljw  include vip source file directory    根据实际情况修改
TB_CMP_OPTIONS += -ntb_incdir $(DESIGNWARE_HOME)/vip/amba/latest/axi_port_mon                        #ljw  include vip source file directory    根据实际情况修改
TB_CMP_OPTIONS += -ntb_incdir $(DESIGNWARE_HOME)/vip/amba/latest/axi_port_mon                        #ljw  include vip source file directory    根据实际情况修改
TB_CMP_OPTIONS += -ntb_incdir $(DESIGNWARE_HOME)/vip/amba/latest/axi_intercon                        #ljw  include vip source file directory    根据实际情况修改
TB_CMP_OPTIONS += -ntb_incdir $(DESIGNWARE_HOME)/vip/amba/latest/axi_intercon                        #ljw  include vip source file directory    根据实际情况修改
TB_CMP_OPTIONS += -ntb_incdir $(DESIGNWARE_HOME)/vip/amba/latest/ahb_master_v                        #ljw  include vip source file directory    根据实际情况修改
TB_CMP_OPTIONS += -ntb_incdir $(DESIGNWARE_HOME)/vip/amba/latest/ahb_slave_vm                        #ljw  include vip source file directory    根据实际情况修改
TB_CMP_OPTIONS += -ntb_incdir $(DESIGNWARE_HOME)/vip/amba/latest/ahb_monitor_                        #ljw  include vip source file directory    根据实际情况修改
TB_CMP_OPTIONS += -ntb_incdir $(DESIGNWARE_HOME)/vip/amba/latest/ahb_bus_vmt/                        #ljw  include vip source file directory    根据实际情况修改
TB_CMP_OPTIONS += -ntb_incdir $(DESIGNWARE_HOME)/vip/amba/latest/ahb_master_r                        #ljw  include vip source file directory    根据实际情况修改
TB_CMP_OPTIONS += -ntb_incdir $(DESIGNWARE_HOME)/vip/amba/latest/ahb_slave_rv                        #ljw  include vip source file directory    根据实际情况修改
TB_CMP_OPTIONS += -ntb_incdir $(DESIGNWARE_HOME)/vip/amba/latest/ahb_monitor_                        #ljw  include vip source file directory    根据实际情况修改
TB_CMP_OPTIONS += -ntb_incdir $(DESIGNWARE_HOME)/vip/amba/latest/ahb_bus_rvm_                        #ljw  include vip source file directory    根据实际情况修改
                                                                             
TB_CMP_OPTIONS += -ntb_define NTB                                                                    #ljw  vcs options    根据实际情况修改为 IES options
TB_CMP_OPTIONS += -ntb_define DW_VIP_AXI_MAX_NO_MSTRS=6                                              #ljw  vcs options    根据实际情况修改为 IES options
TB_CMP_OPTIONS += -ntb_define DW_VIP_AXI_MAX_NO_SLVS=2                                               #ljw  vcs options    根据实际情况修改为 IES options
TB_CMP_OPTIONS += +define+DW_VIP_AXI_MAX_NO_MSTRS_6                                                  #ljw  vcs options    根据实际情况修改为 IES options
TB_CMP_OPTIONS += +define+DW_VIP_AXI_MAX_NO_SLVS_2                                                   #ljw  vcs options    根据实际情况修改为 IES options
TB_CMP_OPTIONS += -ntb_opts rvm                                                                      #ljw  vcs options    根据实际情况修改为 IES options
TB_CMP_OPTIONS += -ntb_opts dtm                                                                      #ljw  vcs options    根据实际情况修改为 IES options
TB_CMP_OPTIONS += -ntb_opts use_sigprop                                                              #ljw  vcs options    根据实际情况修改为 IES options
TB_CMP_OPTIONS += -ntb_opts interop                                                                  #ljw  vcs options    根据实际情况修改为 IES options
TB_CMP_OPTIONS += -ntb_opts dw_vip                                                                   #ljw  vcs options    根据实际情况修改为 IES options
TB_CMP_OPTIONS += +define+NT                                                                         #ljw  vcs options    根据实际情况修改为 IES options
#-----------------------------------------------------------------------------
# COVERAGE  OPTIONS
#-----------------------------------------------------------------------------
COV_TREE         += '+tree mpdu_tb_top'        
COV_CM_OPTIONS   += -cm line+cond+fsm+assert  
#-----------------------------------------------------------------------------
# SVA  OPTIONS
#-----------------------------------------------------------------------------
SVA_OPTIONS    +=
#-----------------------------------------------------------------------------
# TEST TARGETS
#-----------------------------------------------------------------------------
# debug targets
.PHONY:tc_%
tc_%: clean_% compile_tc_% run_tc_%
	echo "Testcase compilation and simulation completes!"
# regression targets  
.PHONY:tc_%                                              
regress_%:  regress_clean regress_build_tc_% regress_run_tc_%                            
	echo "Testcase (regression) compilation and simulation completes !"

#-----------------------------------------------------------------------------
#
# COMPILE AND RUN TIME ARGUMENTS
#
#-----------------------------------------------------------------------------
#--------------
# Debug
#--------------
# Debug compile time arguments               
DBG_CMP           += $(COV_CMP_OPTIONS)                                                            #ljw  vcs options 
DBG_CMP           += -debug_all                                                                    #ljw  vcs options  debug_all 和 debug_pp互斥故注释一个行
#DBG_CMP           += -debug_pp                                                                    #ljw  vcs options 
DBG_CMP           += +define+VPD_ON                                                                #ljw  vcs options   VPN_ON 和 VPN_OFF互斥故注释一行
#DBG_CMP           += +define+VPD_OFF                                                              #ljw  vcs options 
DBG_CMP           += +define+LOG_FMT_OFF                                                           #ljw  vcs options 
# Debug run time arguments             
DBG_RUN           += $(COV_SIM_OPTIONS)
#--------------
# Regression
#--------------
# Regression compile time arguments
REG_CMP           += $(COV_CMP_OPTIONS)   														#ljw  vcs options
REG_CMP           += +define+VPD_OFF                                                            #ljw  vcs options
# Regression run time arguments                                                                 
REG_RUN           += $(COV_SIM_OPTIONS)                                                         #ljw  vcs options
# Define where the coverage data is for URG                                                     
COV_DBG_DATA     += -dir $(COV_DIR)/debug/simv.vdb -dir   $(COV_DIR)/debug/simv.cm              #ljw  vcs options
COV_REG_DATA     += -dir $(COV_DIR)/regress/simv.vdb -dir   $(COV_DIR)/debug/simv.cm            #ljw  vcs options
#-----------------------------------------------------------------------------
#
# COMMAND LINE ARGUMENTS
#
#-----------------------------------------------------------------------------
SEED       = 766
#VERBOSITY  = UVM_HIGH
#VERBOSITY  = UVM_MEDIUM
#VERBOSITY  = UVM_LOW
VERBOSITY  = UVM_DEBUG
##############################################################################
##############################################################################
##############################################################################
##############################################################################
#
# PRIVATE
#
# You should not need to modify anything below this point
#
# The following code supports a SV DUT and SVTB.
#
##############################################################################
##############################################################################
##############################################################################
##############################################################################
DIR          = $(/user/synopsys/Gaon/Platform)
##########################################################################
#
# DEVICE UNDER TEST
#
##########################################################################
DUT_CMP_OPTIONS   += -sverilog +v2k                                                       #ljw  vcs dut compile oiptions      根据实际情况修改为 IES 编译器进行编译
DUT_CMP_OPTIONS   += -o $(DUT_SIM_EXEC)                                                   #ljw  vcs dut compile oiptions      根据实际情况修改为 IES 编译器进行编译
DUT_CMP_OPTIONS   += -Mdir=$(OUTPUT_DIR)/$(TB_TEST_ID)_csrc                               #ljw  vcs dut compile oiptions      根据实际情况修改为 IES 编译器进行编译
DUT_CMP_OPTIONS   += -l $(LOG_DIR)/$(TB_TEST).cmp_log                                     #ljw  vcs dut compile oiptions      根据实际情况修改为 IES 编译器进行编译
DUT_CMP_OPTIONS   += +vcs+lic+wait +plusarg_save                                          #ljw  vcs dut compile oiptions      根据实际情况修改为 IES 编译器进行编译
DUT_CMP_OPTIONS   += $(DUT_INC)                                                           #ljw  vcs dut compile oiptions      根据实际情况修改为 IES 编译器进行编译
                                                                                   
DUT_SIM_OPTIONS   += -l $(LOG_DIR)/$(TB_TEST_ID).run_log                                  #ljw  vcs dut simulation oiptions      根据实际情况修改为 IES 仿真器进行仿真
DUT_SIM_OPTIONS   += +vcs+lic+wait                                                        #ljw  vcs dut simulation oiptions      根据实际情况修改为 IES 仿真器进行仿真  
DUT_SIM_OPTIONS   += +vpdfile+$(OUTPUT_DIR)/$(TB_TEST_ID).vpd                             #ljw  vcs dut simulation oiptions      根据实际情况修改为 IES 仿真器进行仿真                                                                                    

#DUT_SIM_OPTIONS   += +ntb_random_seed=$(SEED)                                             #ljw  vcs dut simulation oiptions      根据实际情况修改为 IES 仿真器进行仿真
DUT_SIM_OPTIONS   += +ntb_random_seed_automatic                                            #ljw  vcs dut simulation oiptions      根据实际情况修改为 IES 仿真器进行仿真 
DUT_SIM_OPTIONS   += -assert nopostproc+report=$(LOG_DIR)/$(TB_TEST_ID).sva_log            #ljw  vcs dut simulation oiptions      根据实际情况修改为 IES 仿真器进行仿真 
DUT_SIM_OPTIONS   += -cm_assert_name $(TB_TEST_ID)                                         #ljw  vcs dut simulation oiptions      根据实际情况修改为 IES 仿真器进行仿真 
DUT_SIM_OPTIONS   += $(VERBOSITY)                                                          #ljw  vcs dut simulation oiptions      根据实际情况修改为 IES 仿真器进行仿真 
                                                                                   
DUT_SIM_EXEC     += $(OUTPUT_DIR)/$(TB_TEST)_simv                                  

##########################################################################
#
# TESTBENCH
#
##########################################################################
TB_TEST       += tc_$*
TB_TEST_ID    += $(TB_TEST)_$(SEED)

TB_INC           += +incdir+$(TB_SRC_DIR)/vk
TB_CMP_OPTIONS +=   $(TB_INC)
##########################################################################
#
# COVERAGE
#
##########################################################################
COV_CM_OPTIONS += +tb_cov_db_name=$(TB_TEST_ID) 
COV_CM_OPTIONS += -cm_name $(TB_TEST_ID)

COV_CMP_OPTIONS   += $(COV_CM_OPTIONS) -cm_hier $(COV_HIER) 

COV_SIM_OPTIONS   += $(COV_CM_OPTIONS)
COV_SIM_OPTIONS   += -cm_log $(LOG_DIR)/$(TB_TEST_ID).cm_log 

COV_HIER       += $(OUTPUT_DIR)/vcm.cfg

# Coverage options for build and run with debug                                                    
COV_CM_DBG     += -cm_dir $(COV_DIR)/debug/simv.cm                                                    #ljw  vcs coverage options    根据实际情况修改为 IES options   
COV_CM_DBG     += -ova_dir $(COV_DIR)/debug/simv.vdb                                                  #ljw  vcs coverage options    根据实际情况修改为 IES options   
COV_CM_DBG     += +tb_cov_db_dir=$(COV_DIR)/debug/simv.vdb                                            #ljw  vcs coverage options    根据实际情况修改为 IES options   

# Coverage options for build and run with regressions
COV_CM_REG     += -cm_dir $(COV_DIR)/regress/simv.cm                                                  #ljw  vcs coverage options    根据实际情况修改为 IES options     
COV_CM_REG     += -ova_dir $(COV_DIR)/regress/simv.vdb                                                #ljw  vcs coverage options    根据实际情况修改为 IES options     
COV_CM_REG     += +tb_cov_db_dir=$(COV_DIR)/regress/simv.vdb                                          #ljw  vcs coverage options    根据实际情况修改为 IES options     

##########################################################################
#
# DEBUG TARGETS
#
##########################################################################
compile_tc_%: 
	vcs $(TB_CMP_OPTIONS) \                                                             #ljw  vcs 编译器编译    根据实际情况修改为 IES 编译器进行编译，TB_CMP_OPTIONS  为tb  compile options 
    $(DUT_CMP_OPTIONS) \                                                                #ljw  vcs 编译器编译    根据实际情况修改为 IES 编译器进行编译，DUT_CMP_OPTIONS 为dut compile options
    $(DUT_SRC) \                                                                        #ljw  dut source file
    $(TB_SRC) \                                                                         #ljw  tb  source file
    $(SVA_SRC) \                                                                        #ljw  sva source file 暂时未定义，根据实际情况需要定义该变量
    $(SVA_OPTIONS) \                                                                    #ljw  sva compile options 暂时未定义，根据实际情况需要定义该变量
    $(COV_CM_DBG) \                                                                     #ljw
    $(DBG_CMP)                                                                          #ljw  
#############################
#### 编译的时候，还需要考虑  参考模型的编译   vip的编译 脚本需要完善
############################

run_tc_%:                                                                                #ljw  调用vcs仿真器，需要根据情况调用IES的单步仿真器，注意与 gui_%的区别在于一个此处不带gui而是cli仿真
	$(DUT_SIM_EXEC) $(DUT_SIM_OPTIONS) $(DBG_RUN) $(COV_CM_DBG)

gui_tc_%:                                                                                #ljw  调用vcs仿真器，需要根据情况调用IES的单步仿真器，gui仿真,vcs下是DVE
	$(DUT_SIM_EXEC) $(DUT_SIM_OPTIONS) $(DBG_RUN) $(COV_CM_DBG) \
    -gui

tb_gui_tc_%:                                                                             #ljw  调用vcs仿真器，需要根据情况调用IES的单步仿真器，gui仿真,与gui_%的区别是，此处仿真tb
	$(DUT_SIM_EXEC) $(DUT_SIM_OPTIONS) $(DBG_RUN) $(COV_CM_DBG) \
    -tb_gui +ntb_debug_on_start

both_guis_%:                                                                          #ljw  调用vcs仿真器，需要根据情况调用IES的单步仿真器，gui仿真,即仿真tb又仿真dut
	$(DUT_SIM_EXEC) $(DUT_SIM_OPTIONS) $(DBG_RUN) $(COV_CM_DBG) \
    -gui \
    -tb_gui +ntb_debug_on_start

new_gui_tc_%:
	$(DUT_SIM_EXEC) $(DUT_SIM_OPTIONS) $(DBG_RUN) $(COV_CM_DBG) \                     #ljw  调用vcs仿真器，需要根据情况调用IES的单步仿真器，gui仿真,与gui_%的区别是，打开一个新的DVE界面
    -gui \
    -tbug

pp_tc_%:                                                                                 #ljw  调用vcs仿真器，需要根据情况调用IES的单步仿真器，此处是使用DVE打开vpd波形文件
	dve -vpd $(OUTPUT_DIR)/$(TB_TEST_ID).vpd

urg:                                                                                  #ljw  调用vcs仿真器，需要根据情况调用IES的单步仿真器，功能是：Make a coverage report for debug runs.
	urg $(COV_DBG_DATA)   -report $(COV_DIR)/debug/urgReport -lca
	mozilla $(DIR)/$(COV_DIR)/debug/urgReport/dashboard.html &

dve_cov:                                                                              #ljw  调用vcs仿真器，需要根据情况调用IES的单步仿真器?  功能是：Brings up DVE for coverage reporting. 
	@echo ""
	@echo "WARNING: Did you run this command?"
	@echo ""
	@echo " % source ./utils/setup_dve_cov"
	@echo ""
	dve -cov &


##########################################################################
#
# REGRESSION TARGETS
#
##########################################################################
regress_clean: clean                                                                    #ljw  Remove all coverage files.
	@rm -rf $(COV_DIR)/*                                                                #ljw
	@mkdir -p $(COV_DIR)/debug                                                          #ljw
	@mkdir -p $(COV_DIR)/regress                                                        #ljw
	@mkdir -p $(LOG_DIR)                                                                #ljw
	@mkdir -p $(OUTPUT_DIR)                                                             #ljw

regress_build_tc_%:                                                                        #ljw  调用vcs仿真器，需要根据情况调用IES的单步仿真器，功能是：Build test_*.
	vcs $(TB_CMP_OPTIONS) $(DUT_CMP_OPTIONS) \
    $(DUT_SRC) \
    $(TB_SRC) \
    $(SVA_SRC) \
    $(SVA_OPTIONS) \
    $(COV_CM_REG) \                                                                     #ljw 与 compile_% 不同之处
    $(REG_CMP)                                                                          #ljw 与 compile_% 不同之处

regress_run_tc_%:                                                                         #ljw  调用vcs仿真器，需要根据情况调用IES的单步仿真器，功能是：Run test * collecting coverage information.
	$(DUT_SIM_EXEC) $(DUT_SIM_OPTIONS) $(REG_RUN) $(COV_CM_REG)

regress_urg:                                                                           #ljw  调用vcs仿真器，需要根据情况调用IES的单步仿真器，功能是：Make a coverage report for regression runs.
	urg $(COV_REG_DATA) -grade -report $(COV_DIR)/regress/urgReport
	mozilla $(DIR)/$(COV_DIR)/regress/urgReport/dashboard.html &

regress_dve_cov:                                                                       #ljw  调用vcs仿真器，需要根据情况调用IES的单步仿真器，功能是：Brings up DVE for coverage reporting.
	@echo ""
	@echo "WARNING: Did you run this command?"
	@echo ""
	@echo " % source ./utils/setup_dve_cov"
	@echo ""
	dve -cov &
##########################################################################
#
# ADMINISTRATIVE
#
##########################################################################


help:
	@echo =======================================================================
	@echo   "        "
	@echo   " USAGE: %make tc_* <SEED=xxx> <VERBOSITY=xxxx>             "
	@echo   "        "
	@echo   " ------------------------ DEBUG TARGETS ----------------------------"
	@echo   " tc_*                => Compile TB and DUT files, runs the simulation.   "   
	@echo   " clean               => Clean the intermediate files.                "       
	@echo   " compile_tc_*        => Compile the TB and DUT.                      "       
	@echo   " run_tc_*            => Run the simulation.                             "    
	@echo   " gui_tc_*            => Run simulation interactively with DVE.       "       
	@echo   " tb_gui_tc_*         => Runs simulation interactively with TB Debugger. "    
	@echo   " both_guis_tc_*      => Run both debuggers.                             "    
	@echo   " new_gui_tc_*        => Run new integrated debuggers.                "       
	@echo   " pp_*                => Post process VPD with DVE.                   "       
	@echo   " urg                 => Make a coverage report for debug runs.       "       
	@echo   " dve_cov             => Brings up DVE for coverage reporting.           "    
	@echo   "                                                                    "
	@echo   " ----------------------- REGRESSION TARGETS ------------------------"
	@echo   " regress_tc_*        => Compile and run with coverage.                "    
	@echo   " regress_clean       => Remove all coverage files.                   "     
	@echo   " regress_build_tc_*  => Build test_*.                                   "  
	@echo   " regress_run_tc_*    => Run test * collecting coverage information.     "  
	@echo   " regress_urg        => Make a coverage report for regression runs.     "  
	@echo   " regress_dve_cov    => Brings up DVE for coverage reporting.           "  
	@echo   "                                                                    "
	@echo   " -------------------- ADMINISTRATIVE TARGETS -----------------------"
	@echo   " help             => Displays this message.                         "
	@echo   " init             => Clean all files, including coverage files.    "
	@echo   "        "
	@echo   " e.g.   make tc_1                                              "
	@echo =======================================================================

clean:
	@rm -rf $(OUTPUT_DIR)/*   \ 
            $(COV_DIR)/*       \
            $(LOG_DIR)/*
            
clean_%:
	@rm -rf $(OUTPUT_DIR)/$(TB_TEST_ID)*  \ 
            $(OUTPUT_DIR)/$(TB_TEST)_simv       \
            $(COV_DIR)/*       \
            $(LOG_DIR)/$(TB_TEST_ID)*  \
            $(LOG_DIR)/$(TB_TEST)*
            
init:              
	@rm -rf $(COV_DIR)           
	@rm -rf $(LOG_DIR)           
	@rm -rf $(OUTPUT_DIR)           
	@mkdir -p $(COV_DIR)  
	@mkdir -p $(COV_DIR)/debug  
	@mkdir -p $(COV_DIR)/regress
	@mkdir -p $(LOG_DIR)        
	@mkdir -p $(OUTPUT_DIR)     



