// =============================================================================
// Filename: gpio_int_rst.v
// Description:local reset manage.Input a global asyn reset and generate
// according clock domain reset.
// Author: Shi shuguang
// Created: Thu Jan 19 13:56:23 CST 2017
// =============================================================================
// Release History
//      Version        Date        Author        Description
//      V001           Created     Shishuguang   Initial version                         
// =============================================================================
// Global Parameters
//      Parameter Name  Range       : Description       : Default   : Units
//      NA
// =============================================================================
module gpio_int_rst(
    input   rstn_50m        ,
    input   clk_50m         ,
    input   clk_cpu         ,
    input   clk_100m        ,
    input   clk_200m        ,
    input   clk_400m        ,
    input   I_IT_RX_IFCLK   ,
    input   I_OT_RX_IFCLK   ,
    output  o_rstn_50m      ,
    output  rstn_cpu        ,
    output  rstn_100m       ,
    output  rstn_200m       ,
    output  rstn_400m       ,
    output  rstn_it         ,
    output  rstn_ot         

);

//--------------------------------------
//-------- Local Parameters  -----------
//--------------------------------------
localparam  L_RST_NUM   = 7;

//--------------------------------------
//-------  Port Declaration  -----------
//--------------------------------------

//--------------------------------------
//------- Local Vars Declaration -------
//--------------------------------------
genvar i;//loop var
wire    [L_RST_NUM-1:0] c_collect_clk   ;
wire    [L_RST_NUM-1:0] c_collect_rst   ;

//--------------------------------------
// Function 1:
//--------------------------------------
assign  c_collect_clk   = {
                                             I_OT_RX_IFCLK    ,I_IT_RX_IFCLK  ,clk_400m   ,
                           clk_200m         ,clk_100m         ,clk_cpu        ,clk_50m
    };
assign  rstn_ot     =   c_collect_rst[6];    
assign  rstn_it     =   c_collect_rst[5];    
assign  rstn_400m   =   c_collect_rst[4];    
assign  rstn_200m   =   c_collect_rst[3];    
assign  rstn_100m   =   c_collect_rst[2];
assign  rstn_cpu    =   c_collect_rst[1];
assign  o_rstn_50m  =   c_collect_rst[0];
    
//--------------------------------------
// Function 2:
//--------------------------------------

//--------------------------------------
// Module Instance 
//--------------------------------------
generate
for(i=0;i<L_RST_NUM;i=i+1) begin:RST_MANAGE
asyn_rst_syn_rls
m_asyn_rst_manage
(
    .i_reset    (rstn_50m           ),
    .i_clkin    (c_collect_clk[i]   ),

    .o_reset    (c_collect_rst[i]   )
);
end
endgenerate

endmodule
//gpio_int_rst.v ends here
