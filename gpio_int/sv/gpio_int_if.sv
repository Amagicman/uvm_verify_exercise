`ifndef GPIO_INT_IF
`define	GPIO_INT_IF

interface gpio_int_if(input [0:6] clk, input rstn_50m);

	/*
	* interrupt source : priority from high to low.
	*/
	//error interrupt source
	logic						int_err_lbus			;
	logic						int_err_50m				;
	logic	 [`ERR_200M-1:0]	int_err_200m			;
	logic	 [`ERR_400M-1:0]	int_err_400m			;
    
	//infomation interrupt source
	logic	 [`INF_300M-1:0]	int_info_300m			;
	logic	 [`INF_XAUI-1:0]	int_info_xaui			;
	logic	 [`INF_50M-1:0]		int_info_50m			;
	logic	 [`INF_400M-1:0]	int_info_400m			;
     
	//shakehand interrupt source
	logic						int_shake_50m			;
	logic	 [`SK_BUFD-1:0]		int_shake_bufd			;
	logic	 [`SK_100M-1:0]		int_shake_100m			;

	//interrupt ack input
	logic						INTA_N                  ;
	
	//interrupt request output
	logic						INTR					;
	//interrupt code output
	logic	 [6:0]				INT_CODE                ;

endinterface

`endif
