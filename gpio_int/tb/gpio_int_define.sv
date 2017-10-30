`define TOP_RST_EVT global_rst_evt
`define DRV_OVER_EVT drv2dut_complete_event

`define TB_TOP          gpio_int_top_tb
`define DUT             `TB_TOP.gpio_int_dut
`define __SCOREBOARD_RESULT_ALL_ON		1

//reg addr
`define		P_SH_MASK_ADDR0          24'h00_0000
`define		P_INFO_MASK_ADDR0        24'h00_0010
`define		P_INFO_MASK_ADDR1        24'h00_0014
`define		P_ERR_MASK_ADDR0         24'h00_0020
`define		P_ERR_MASK_ADDR1         24'h00_0024
`define		P_SH_STA_ADDR0           24'h00_0030
`define		P_INFO_STA_ADDR0         24'h00_0040
`define		P_INFO_STA_ADDR1         24'h00_0044
`define		P_ERR_STA_ADDR0          24'h00_0050
`define		P_ERR_STA_ADDR1          24'h00_0054

//parameter
`define		XAUI_NUM	6

`define		INT_NUM		109 //44+50+15
`define		ERR_W		44
`define		INF_W		50		
`define		SK_W		15

`define		ERR_LBUS	1
`define		ERR_50M 	1
`define		ERR_200M	3
`define		ERR_400M	39

`define		INF_300M	2
`define		INF_XAUI	`XAUI_NUM
`define		INF_50M		3
`define		INF_400M	39

`define		SK_50M		1
`define		SK_BUFD		2
`define		SK_100M		`XAUI_NUM * 2


`define		 PERIOD_400M  2500
`define		 PERIOD_300M  3333
`define		 PERIOD_200M  5000
`define		 PERIOD_100M  10000
`define		 PERIOD_50M   20000
`define		 PERIOD_CPU   20000
