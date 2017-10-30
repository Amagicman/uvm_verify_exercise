
This is the git repository for gpio_int verification.

Description of the directories in this repo :
	
.
|-- dut : the rtl source codes
|-- readme.txt
|-- sim : the run scripts of the verification runtime
|-- sv : the uvm component verification files
|-- tb : the top and some macro files
`-- tests : the testcases

To run this verification environment with some steps as follow :
	1. cd sim
	2. make

make w to get the wave files, and make clean to clean up the env.

To run different testcases, just change the "+UVM_TESTNAME" option in sim/Makefile.
