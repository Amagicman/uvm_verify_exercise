#!/bin/csh -f
# ====================================================
# Filename: run.csh
# Description: this file is similation execute script
# Version : v001
# Author:
# Created:
# ====================================================

#block path set
setenv BLOCKPATH	"/home/jg/workspace/PJ001_NP3/verify/sv_verify_env/gpio_int"

##SET PATH
setenv AST_PATH      "$BLOCKPATH/ast"
setenv COV_PATH      "$BLOCKPATH/cov"

set SIM_PATH       = "$BLOCKPATH/sim"
set TB_PATH        = "$BLOCKPATH/tb"
set UVC_PATH       = "$BLOCKPATH/sv"
set PATTERN_PATH   = "$BLOCKPATH/tests"
set SEQS_LIB_PATH  = "$BLOCKPATH/tests/seq_lib"

set SCRIPT_PATH    = "$SIM_PATH/script"

##VARIABLE INITIAL
set IRUN_OPTS   = ""
set DUMP_OPTS   = ""
set OTHER_OPTS  = ""
set GUI_OPT     = ""
set INC_DIR     = ""
set RTL_FILES   = ""
set RTL_FILE    = ""
set SUFFIX_EXT  = ""
set AST_FILES   = ""
set COV_FILES   = ""
set ASTFLAG     = ""
set COVFLAG     = ""
set LINE_NUM    = "1"
set LOCAL_FREQ  = ""
set VERBOSITY   = "LOW"
#set VERBOSITY   = "HIGH"
set UVM_CONFIG  = ""

##SEED GENERATE
#@ seed_time   = `date +%s%N`
#@ seed_dev    = `head -200 /dev/urandom | cksum | cut -f1 -d" "`
#@ seed_uuid   = `cat /proc/sys/kernel/random/uuid| cksum | cut -f1 -d" "`
#@ seed_random = $seed_time + $seed_dev + $seed_uuid
#set SEED      = `echo $seed_random | tr -d -`
set SEED	   = `date +%s%N | cut -c 5-13`

##ARGUMENT CHECK
if ($#argv == 0) then
  goto HELP
endif

while ($#argv >0)
    switch($1)
    case "-h":
            goto HELP
    breaksw
    case "-t":
            set PATTERN_NAME = $2:r:t
            set IRUN_OPTS = "$IRUN_OPTS +UVM_TESTNAME=${PATTERN_NAME}"
            shift
    breaksw
    case "-r":
            set IRUN_OPTS = "$IRUN_OPTS -clean"
    breaksw
    case "-g":
            set GUI_OPT   = "$GUI_OPT -gui -s"
			#set DUMP_OPTS = "$DUMP_OPTS +tcl+$SIM_PATH/irun.tcl"
    breaksw
    case "-seed":
            set SEED      = $2
            shift
    breaksw
    case "-verbos":
            if ( $2 != "NONE" & $2 != "LOW" & $2 != "MEDIUM" & $2 != "HIGH" & $2 != "FULL") then
                set ERROR_MSG = "*RUN_ERROR: UNKNOWN ARGS [-verbos $2], UNCAPITALIZATION?"
                goto ERROR_END
            else
                set VERBOSITY = $2
            endif
            shift
    breaksw
    case "-line_num":
            set LINE_NUM  = $2
            set LINE_NUM_CHK = `echo $LINE_NUM | sed "s/[0-9]//g"`
            if ( $LINE_NUM_CHK != "" ) then
                set ERROR_MSG = "*RUN_ERROR: [-line_num $LINE_NUM] MUST BE A INTEGER"
            endif
            shift
    breaksw
    case "-freq":
            set LOCAL_FREQ = $2
            set IRUN_OPTS  = "$IRUN_OPTS +define+LOCAL_FREQ=$LOCAL_FREQ"
            shift
    breaksw
    case "-wave":
            set DUMP_OPTS = "$DUMP_OPTS +define+WAVE_ON"
    breaksw
    case "-cov":
            set COVFLAG   = "ON"
    breaksw
    case "-ast":
            set ASTFLAG   = "ON"
    breaksw
    case "-clear":
            goto CLEAR
    breaksw
    case "-cov_merge":
            goto COV_MERGE
    breaksw
    case "-ast_merge":
            goto AST_MERGE
    breaksw
    default:
            set ERROR_MSG = "*RUN_ERROR: UNKNOWN OPTION $1"
            goto ERROR_END
    breaksw
    endsw
    shift
end

##SET DIRECTORY
set RESULT_DIR     = "$SIM_PATH/${PATTERN_NAME}/${SEED}"
set IRUN_LOG_NAME  = "${PATTERN_NAME}_${SEED}.log"
set WAVE_NAME = "${PATTERN_NAME}_${SEED}.shm"
set LOG_DIR        = "$SIM_PATH/log"

##SIM FILE TRANSFER
if( ! -d $RESULT_DIR) then
    mkdir -p $RESULT_DIR/
endif

if( ! -d $RESULT_DIR) then
    mkdir -p $RESULT_DIR/
endif

cd $RESULT_DIR
#rm -rf INCA_libs

##SET RUN OPT
set EXE        = "irun -64bit -uvm "
set SUFFIX_EXT = "+libext+.v +vlog_ext+.v+.tb+.vlib+.h"

set IRUN_OPTS  = "$IRUN_OPTS -timescale 1ps/1ps"
set IRUN_OPTS  = "$IRUN_OPTS -access +wr"
set IRUN_OPTS  = "$IRUN_OPTS -svseed $SEED"
set IRUN_OPTS  = "$IRUN_OPTS $SUFFIX_EXT"
set IRUN_OPTS  = "$IRUN_OPTS -nclibdirpath $SIM_PATH/${PATTERN_NAME}/${SEED}"
set IRUN_OPTS  = "$IRUN_OPTS -nclibdirname INCA_libs"
set IRUN_OPTS  = "$IRUN_OPTS -l $RESULT_DIR/${IRUN_LOG_NAME}"
set IRUN_OPTS  = "$IRUN_OPTS -status"
set IRUN_OPTS  = "$IRUN_OPTS +UVM_VERBOSITY=UVM_${VERBOSITY}"
set IRUN_OPTS  = "$IRUN_OPTS +define+LINE_NUM=$LINE_NUM"
set IRUN_OPTS  = "$IRUN_OPTS +define+NO_MBIST_EDA"
set IRUN_OPTS  = "$IRUN_OPTS +define+NO_FTEST_EDA"
set IRUN_OPTS  = "$IRUN_OPTS +nowarn+NONPRT"
set IRUN_OPTS  = "$IRUN_OPTS -licqueue"
set IRUN_OPTS  = "$IRUN_OPTS +notimingchecks +nospecify"
set IRUN_OPTS  = "$IRUN_OPTS -nowarn CVMPRO"
set IRUN_OPTS  = "$IRUN_OPTS -nowarn LIBNOU"
set IRUN_OPTS  = "$IRUN_OPTS -nowarn FUNTSK"

set DUMP_OPTS  = "$DUMP_OPTS +define+WAVE_FILE="'"'"$RESULT_DIR/${WAVE_NAME}"'"'

set INC_DIR    = "$INC_DIR -incdir $BLOCKPATH/tb"
set INC_DIR    = "$INC_DIR -incdir $BLOCKPATH/tests"
set INC_DIR    = "$INC_DIR -incdir $BLOCKPATH/tests/seq_lib"
set INC_DIR    = "$INC_DIR -incdir $BLOCKPATH/sv"
set INC_DIR    = "$INC_DIR -incdir $BLOCKPATH/sim"

set RTL_FILES  = "$RTL_FILES -define ARM_UD_MODEL"

set RTL_FILES  = "$RTL_FILES $BLOCKPATH/dut/src/*.v"
set RTL_FILES  = "$RTL_FILES $BLOCKPATH/dut/scdc_ip/*.v"

set TB_FILES   = "$BLOCKPATH/tb/gpio_int_top.sv"

set UVM_CONFIG = "$UVM_CONFIG +UVM_NO_RELNOTES"

if ( $COVFLAG == "ON" ) then
    if ( ! -d $SIM_PATH/cov_work ) then
        mkdir -p $SIM_PATH/cov_work
    endif
    if( ! -d $LOG_DIR/cov) then
        mkdir -p $LOG_DIR/cov
    endif
    set COV_FILES = "$COV_FILES $COV_PATH/cov_gpio_int_tr.sv"
    set IRUN_OPTS  = "$IRUN_OPTS +define+__COV_ENABLE"
    set OTHER_OPTS = "$OTHER_OPTS -covtest covtest_${PATTERN_NAME}_${SEED}"
    set OTHER_OPTS = "$OTHER_OPTS -covscope scope"
    set OTHER_OPTS = "$OTHER_OPTS -covworkdir $SIM_PATH/cov_work"
    set OTHER_OPTS = "$OTHER_OPTS -covfile $SCRIPT_PATH/covfile.ccf -covdut gpio_int_top_tb"
    set OTHER_OPTS = "$OTHER_OPTS -covoverwrite"
endif

if ( $ASTFLAG == "ON" ) then
    set AST_FILES = "$AST_FILES -f $AST_PATH/gpio_int_ast.flist"
    set OTHER_OPTS = "$OTHER_OPTS +tcl+$SCRIPT_PATH/assert.tcl"
endif

#EXE RUN
$EXE \
    $INC_DIR \
    $RTL_FILES\
    $TB_FILES \
    $AST_FILES \
    $COV_FILES \
    $IRUN_OPTS \
    $DUMP_OPTS \
    $UVM_CONFIG \
    $OTHER_OPTS \
    $GUI_OPT


#POST-PROCESSING
if ( $ASTFLAG == "ON" ) then
    if( ! -d $LOG_DIR/ast) then
        mkdir -p $LOG_DIR/ast
    endif
	if( -e assertion_summary.txt) then
		mv assertion_summary.txt $RESULT_DIR/${PATTERN_NAME}_${SEED}_assertion.log
		cp $RESULT_DIR/${PATTERN_NAME}_${SEED}_assertion.log $LOG_DIR/ast
	else
		echo "*RUN_ERROR: assertion_summary.txt generate failed!"
	endif
endif

if( -e $RESULT_DIR/${IRUN_LOG_NAME} ) then
    if( ! -d $LOG_DIR/irun) then
        mkdir -p $LOG_DIR/irun
    endif
    cp $RESULT_DIR/${IRUN_LOG_NAME} $LOG_DIR/irun
endif

cd $SIM_PATH

echo "*RUN_INFO: RESULTS IN ${PATTERN_NAME} NU:${SEED}"
echo "*RUN_INFO: RUN FINISH"
exit

#GET COV MERGE RESULT
COV_MERGE:
    cd ${SIM_PATH}
    iccr ${SCRIPT_PATH}/cov_iccr.cmd
exit 1

#GET AST MERGE RESULT
AST_MERGE:
    cd $SIM_PATH/log/ast
    ../../script/sva_merge.pl
    cd -
exit 1

#USAGE INFO
ERROR_END:
echo "**********************************************************"
echo "$ERROR_MSG"
goto HELP

HELP:
    echo "--HELP--"
    echo "EXAMPLE   :  ./run.csh -t ipcm_new_sram4_11_test"
    echo "SIM CMD   :  ./run.csh -t ipcm_new_sram4_11_test"
    echo "GUI       :  ./run.csh -t ipcm_new_sram4_11_test -g"
    echo "RECOMPILE :  ./run.csh -t ipcm_new_sram4_11_test -r"
    echo "AST/COV   :  ./run.csh -t ipcm_new_sram4_11_test -ast -cov"
    echo "LINE_NUM  :  ./run.csh -t ipcm_new_sram4_11_test -line_num 10"
    echo "FREQ      :  ./run.csh -t ipcm_new_sram4_11_test -freq 100"
    echo "SEED      :  ./run.csh -t ipcm_new_sram4_11_test -seed 12345"
    echo "WAVE DUMP :  ./run.csh -t ipcm_new_sram4_11_test -wave"
    echo "VERBOSITY :  ./run.csh -t ipcm_new_sram4_11_test -verbos HIGH"
    echo "COV MERGE :  ./run.csh -cov_merge"
    echo "AST MERGE :  ./run.csh -ast_merge"
    echo "CLEAR DIR :  ./run.csh -clear"
exit 1

#CLEAR SIM RESULT
CLEAR:
    set STATUS = 0
    rm -rf *test*
    set STATUS = $?
    if ( $STATUS == 0 ) then
        echo "*RUN_INFO: SIM DIRECTORYS BEEN CLEARED."
    endif
    if( -d cov_work ) then
        set STATUS = 0
        rm -rf cov_work
        set STATUS = $?
        if ( $STATUS == 0 ) then
            echo "*RUN_INFO: COV DIRECTORYS BEEN CLEARED."
        endif
    endif
    if( -e iccr.key ) then
        rm -rf iccr.key
    endif
    if( -e iccr.log ) then
        rm -rf iccr.log
    endif
    if( -d log ) then
      rm log -rf
    endif
exit 1



