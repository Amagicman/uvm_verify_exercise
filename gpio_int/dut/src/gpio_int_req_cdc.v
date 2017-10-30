// =============================================================================
// Filename: gpio_int_req_cdc.v
// Description:source interrupt cross domain and all change to pulse interrupt. 
// Author: Shi shuguang
// Created: Mon Jan 23 14:05:04 CST 2017
// =============================================================================
// Release History
//      Version        Date        Author        Description
//      V001           Created     Shishuguang   Initial version                         
// =============================================================================
// Global Parameters
//      Parameter Name  Range       : Description       : Default   : Units
// =============================================================================
module gpio_int_req_cdc #(
    parameter ERR_W  = 42   ,
    parameter INF_W  = 50   ,
    parameter SK_W   = 15   
)(
    input           clk_50m                 ,
    input           clk_cpu                 ,
    input           clk_100m                ,
    input           clk_200m                ,
    input           clk_400m                ,
    input           I_IT_RX_IFCLK           ,
    input           I_OT_RX_IFCLK           ,
    input           rstn_50m                ,
    input           rstn_cpu                ,
    input           rstn_100m               ,
    input           rstn_200m               ,
    input           rstn_400m               ,
    input           rstn_it                 ,
    input           rstn_ot                 ,    
    input           ns_asip_err_int_400m    ,
    input           pcm_asip_err_int_400m   ,
    input           crm_rst_done_50m        ,
    input           lbus_err_int_cpu        ,
    input   [15:0]  ns_sw_int_400m          ,
    input           ns_otm_int_400m         ,
    input           ns_check_int_400m       ,
    //input           ns_err_int_400m         ,
    input           ns_peri_err_int_400m    ,
    input   [15:0]  pcm_sw_int_400m         ,
    input           pcm_check_int_400m      ,
    input           pcm_peri_err_int_400m   ,
    //input           pcm_err_int_400m        ,
    input           spi_ctrl_int_50m        ,
    input           spi_ill_int_50m         ,
    input           spi_load_int_50m        ,
    input           spi_err_int_50m         ,
    input           mg_err_int_200m         ,
    input           ia2xg_err_int_200m      ,
    input           ibufd_err_int_400m      ,
    input           itcam_err_int_400m      ,
    input           itcam_check_int_rclk    ,
    input           icfg_err_int_400m       ,
    input           inif_err_int_400m       ,
    input           ienif_err_int_400m      ,
    input           iama1_err_int_400m      ,
    input           iama1_normal_int_400m   ,
    input           iama2_err_int_400m      ,
    input           iama2_normal_int_400m   ,
    input           iamf_err_int_400m       ,
    input           isec_err_int_400m       ,
    input           isch_err_int_400m       ,
    input           isram_err_int_400m      ,
    input           iqos0_err_int_400m      ,
    input           iqos1_err_int_400m      ,
    input           iminsch_err_int_400m    ,
    input           imeter_err_int_400m     ,
    input           oa2xg_err_int_200m      ,
    input           obufd_err_int_400m      ,
    input           otcam_err_int_400m      ,
    input           otcam_check_int_rclk    ,
    input           ocfg_err_int_400m       ,
    input           onif_err_int_400m       ,
    input           oenif_err_int_400m      ,
    input           oama1_err_int_400m      ,
    input           oama1_normal_int_400m   ,
    input           oama2_err_int_400m      ,
    input           oama2_normal_int_400m   ,
    input           oamf_err_int_400m       ,
    input           osec_err_int_400m       ,
    input           osch_err_int_400m       ,
    input           osram_err_int_400m      ,
    input           oqos0_err_int_400m      ,
    input           oqos1_err_int_400m      ,
    input           ominsch_err_int_400m    ,
    input           ometer_err_int_400m     ,    
    input           alg_err_int_400m        ,
    input           jcon_err_int_400m       ,
    input           dmspi_err_int_400m      ,
    input           dmilbus_err_int_400m    ,
    input           dmolbus_err_int_400m    ,
    input           ibufd_ctrl_int          ,
    input           obufd_ctrl_int          ,
    input           xi_sbd_int              ,
    input           xi_pma_int              ,
    input           xi_link_int             ,
    input           xo_sbd_int              ,
    input           xo_pma_int              ,
    input           xo_link_int             ,
    input           xa_sbd_int              ,
    input           xa_pma_int              ,
    input           xa_link_int             ,
    input           xb_sbd_int              ,
    input           xb_pma_int              ,
    input           xb_link_int             ,
    input           xc_sbd_int              ,
    input           xc_pma_int              ,
    input           xc_link_int             ,
    input           xd_sbd_int              ,
    input           xd_pma_int              ,
    input           xd_link_int             ,

    output  [ERR_W-1:0]     error_int_cpu   ,
    output  [INF_W-1:0]     inform_int_cpu  ,
    output  [SK_W-1:0]      shake_int_cpu   
);

//--------------------------------------
//-------- Local Parameters  -----------
//--------------------------------------
localparam ERR400_W = 39;
localparam ERR200_W = 3 ;
localparam ERR50_W  = 1 ;
localparam INF400_W = 39;
localparam INF50_W  = 3;
localparam XAUI_NUM = 6;
//--------------------------------------
//-------  Port Declaration  -----------
//--------------------------------------

//--------------------------------------
//------- Local Vars Declaration -------
//--------------------------------------
genvar i                                       ;
//error type interrupt vars
wire    [ERR400_W-1:0]  c_err_int_400m         ; //collect 400m source int
wire    [ERR200_W-1:0]  c_err_int_200m         ; //collect 200m source int
wire    [ERR50_W-1:0]   c_err_int_50m          ; //collect 50m source int
reg                     r_lbus_err_int_cpu     ; //regiset source lbus error int
wire                    c_lbus_err_int_cpu_pos ; //posedge pulse
wire    [ERR400_W-1:0]  c_err_int_lower        ; //shaped error lower
wire    [ERR200_W-1:0]  c_err_int_mid          ; //shaped error middle
wire    [ERR50_W-1:0]   c_err_int_high         ; //shaped error high

//information type interrupt vars
wire    [INF400_W-1:0]  c_info_int_400m        ; //collect 400m source int
wire    [INF50_W-1:0]   c_info_int_50m         ; //collect 50m source int
wire    [XAUI_NUM-1:0]  c_info_int_xgxs        ; //collect xgxs domain source int
reg     [XAUI_NUM-1:0]  r_inf_int_xgxs         ; //synchro2
reg     [XAUI_NUM-1:0]  r_inf_int_xgxs_1d      ; //synchro2
reg     [XAUI_NUM-1:0]  r_inf_int_xgxs_2d      ; //
reg     [XAUI_NUM-1:0]  r_inf_int_xgxs_2d_pos  ; //shaped xgxs int
wire                    c_itcam_check_int_cpu  ; //shaped itcam int
wire                    c_otcam_check_int_cpu  ; //shaped otcam int
wire    [INF400_W-1:0]  c_info_int_lower       ; //shaped low int from 400m
wire    [INF50_W-1:0]   c_info_int_high        ; //shaped high int from 50m
//shakehand type interrupt vares
wire    [XAUI_NUM*2-1:0]c_shakehand_int_100m   ; //collect xaui source int
wire    [1:0]           c_bufd_int_266m        ; //collect bufd source int
reg     [1:0]           r_bufd_int_266m        ; //synchro2
reg     [1:0]           r_bufd_int_266m_1d     ; //synchro2
reg     [1:0]           r_bufd_int_2d          ;
reg     [1:0]           r_bufd_int_2d_pos      ; //shaped bufdctrl int
wire    [XAUI_NUM*2-1:0]c_shakehand_int        ; //shaped xaui int
wire                    c_spictrl_int_cpu      ; //shaped spictrl int

//--------------------------------------
// Function 1:error interrupt  cdc
//--------------------------------------
assign  c_err_int_400m = {
                                             ns_asip_err_int_400m ,pcm_asip_err_int_400m, dmolbus_err_int_400m,
                        ns_peri_err_int_400m     ,pcm_peri_err_int_400m   ,ibufd_err_int_400m     ,itcam_err_int_400m     ,
                        icfg_err_int_400m   ,inif_err_int_400m  ,ienif_err_int_400m     ,iama1_err_int_400m     ,
                        iama2_err_int_400m  ,iamf_err_int_400m  ,isec_err_int_400m      ,isch_err_int_400m      ,
                        isram_err_int_400m  ,iqos0_err_int_400m ,iqos1_err_int_400m     ,iminsch_err_int_400m   ,
                        imeter_err_int_400m ,obufd_err_int_400m ,otcam_err_int_400m     ,ocfg_err_int_400m      ,
                        onif_err_int_400m   ,oenif_err_int_400m ,oama1_err_int_400m     ,oama2_err_int_400m     ,
                        oamf_err_int_400m   ,osec_err_int_400m  ,osch_err_int_400m      ,osram_err_int_400m     ,
                        oqos0_err_int_400m  ,oqos1_err_int_400m ,ominsch_err_int_400m   ,ometer_err_int_400m    ,
                        alg_err_int_400m    ,jcon_err_int_400m  ,dmspi_err_int_400m     ,dmilbus_err_int_400m   
    };
assign c_err_int_200m = {
                        mg_err_int_200m ,ia2xg_err_int_200m ,oa2xg_err_int_200m 
};

assign  c_err_int_50m = {
                        spi_err_int_50m 
};
//register
always @(posedge clk_cpu or negedge rstn_cpu) begin:FLOP_LBUS_ERR
    if(~rstn_cpu) begin
        r_lbus_err_int_cpu  <= 1'b0;
    end else begin
        r_lbus_err_int_cpu  <= lbus_err_int_cpu;
    end
end
//posedge pulse
assign  c_lbus_err_int_cpu_pos = lbus_err_int_cpu & (~r_lbus_err_int_cpu);
//CDC,generate pusle sychro to cpu domain
generate
//400m
for(i=0;i<ERR400_W  ;i=i+1) begin:ERROR_400M_CDC
signal_cross_rope_tie 
m_err_400m_cdc(
    .src_clk    (clk_400m   ),
    .src_rstn   (rstn_400m  ),
    .des_clk    (clk_cpu    ),
    .des_rstn   (rstn_cpu   ),
    .i_sig      (c_err_int_400m[i]),
    .o_sig      (c_err_int_lower[i])    
);
end

//200m
for(i=0;i<ERR200_W  ;i=i+1) begin:ERROR_200M_CDC
signal_cross_rope_tie 
m_err_200m_cdc(
    .src_clk    (clk_200m   ),
    .src_rstn   (rstn_200m  ),
    .des_clk    (clk_cpu    ),
    .des_rstn   (rstn_cpu   ),
    .i_sig      (c_err_int_200m[i]),
    .o_sig      (c_err_int_mid[i])    
);
end
//50m
for(i=0;i<ERR50_W  ;i=i+1) begin:ERROR_50M_CDC
signal_cross_rope_tie 
m_err_50m_cdc(
    .src_clk    (clk_50m   ),
    .src_rstn   (rstn_50m  ),
    .des_clk    (clk_cpu    ),
    .des_rstn   (rstn_cpu   ),
    .i_sig      (c_err_int_50m[i]),
    .o_sig      (c_err_int_high[i])    
);

end
endgenerate

//collect error pulse interrupt
assign error_int_cpu = {c_lbus_err_int_cpu_pos,c_err_int_high,c_err_int_mid,c_err_int_lower};
//--------------------------------------
// Function 2:info interrupt  cdc
//--------------------------------------
assign  c_info_int_400m={
                        ns_sw_int_400m          ,
                        ns_otm_int_400m         ,ns_check_int_400m      ,pcm_sw_int_400m        , pcm_check_int_400m    ,
                        iama1_normal_int_400m   ,iama2_normal_int_400m  ,oama1_normal_int_400m  ,oama2_normal_int_400m
    };
assign  c_info_int_50m = {
                        crm_rst_done_50m    ,spi_ill_int_50m ,spi_load_int_50m               
    };

assign  c_info_int_xgxs= {
                        xi_link_int ,xo_link_int    ,
                        xa_link_int ,xb_link_int    ,xc_link_int    ,xd_link_int   
    };    
//i/otcam int 
signal_cross_rope_tie 
m_info_itm_cdc(
    .src_clk    (I_IT_RX_IFCLK          ),
    .src_rstn   (rstn_it                ),
    .des_clk    (clk_cpu                ),
    .des_rstn   (rstn_cpu               ),
    .i_sig      (itcam_check_int_rclk   ),
    .o_sig      (c_itcam_check_int_cpu  )    
);

signal_cross_rope_tie 
m_info_otm_cdc(
    .src_clk    (I_OT_RX_IFCLK          ),
    .src_rstn   (rstn_ot                ),
    .des_clk    (clk_cpu                ),
    .des_rstn   (rstn_cpu               ),
    .i_sig      (otcam_check_int_rclk   ),
    .o_sig      (c_otcam_check_int_cpu  )    
);


//xaui int(6) 
//xpcs_link_status level interrupt(two shifter synchro to cpu domain)
always @(posedge clk_cpu or negedge rstn_cpu) begin:SYNCHROZIER_XAUI_INFO
    if(~rstn_cpu) begin
        r_inf_int_xgxs      <= {XAUI_NUM{1'b0}};
        r_inf_int_xgxs_1d   <= {XAUI_NUM{1'b0}};
    end else begin
        r_inf_int_xgxs      <= c_info_int_xgxs;
        r_inf_int_xgxs_1d   <= r_inf_int_xgxs;
    end
end

always @(posedge clk_cpu or negedge rstn_cpu) begin:XAUI_INFO_POS
    if(~rstn_cpu) begin
        r_inf_int_xgxs_2d   <= {XAUI_NUM{1'b0}};
        r_inf_int_xgxs_2d_pos<= {XAUI_NUM{1'b0}};
    end else begin
        r_inf_int_xgxs_2d   <= r_inf_int_xgxs_1d;
        r_inf_int_xgxs_2d_pos    <= r_inf_int_xgxs_1d & (~r_inf_int_xgxs_2d);
    end
end 
//others
generate
for(i=0;i<INF400_W;i=i+1) begin:INFO_400M_CDC
signal_cross_rope_tie 
m_info_400m_cdc(
    .src_clk    (clk_400m   ),
    .src_rstn   (rstn_400m  ),
    .des_clk    (clk_cpu    ),
    .des_rstn   (rstn_cpu   ),
    .i_sig      (c_info_int_400m[i]),
    .o_sig      (c_info_int_lower[i])    
);
end

for(i=0;i<INF50_W;i=i+1) begin:INFO_50M_CDC
signal_cross_rope_tie 
m_info_50m_cdc(
    .src_clk    (clk_50m   ),
    .src_rstn   (rstn_50m  ),
    .des_clk    (clk_cpu    ),
    .des_rstn   (rstn_cpu   ),
    .i_sig      (c_info_int_50m[i]),
    .o_sig      (c_info_int_high[i])    
);
end

endgenerate
//collect info pulse interrupt
assign  inform_int_cpu    = {c_itcam_check_int_cpu    ,c_otcam_check_int_cpu  ,r_inf_int_xgxs_2d_pos,
                           c_info_int_high          ,c_info_int_lower
};

//--------------------------------------
// Function 3:shakehand interrupt  cdc
//--------------------------------------
assign  c_shakehand_int_100m = {
                                xi_sbd_int  , xo_sbd_int    ,xa_sbd_int ,xb_sbd_int ,
                                xc_sbd_int  , xd_sbd_int    ,xi_pma_int ,xo_pma_int ,
                                xa_pma_int  , xb_pma_int    ,xc_pma_int ,xd_pma_int    
    };
assign  c_bufd_int_266m = {ibufd_ctrl_int,obufd_ctrl_int};
    
always @(posedge clk_cpu or negedge rstn_cpu) begin:SYNCHROZIER_DDR3_SHAKE
    if(~rstn_cpu) begin
        r_bufd_int_266m <= 2'b0;
        r_bufd_int_266m_1d <= 2'b0;
    end else begin
        r_bufd_int_266m     <= c_bufd_int_266m;
        r_bufd_int_266m_1d  <= r_bufd_int_266m;    
    end
end
always @(posedge clk_cpu or negedge rstn_cpu) begin:DDR3_SHAKE_POS
    if(~rstn_cpu) begin
        r_bufd_int_2d  <= 2'b0;
        r_bufd_int_2d_pos <= 2'b0;
    end else begin
        r_bufd_int_2d  <= r_bufd_int_266m_1d;
        r_bufd_int_2d_pos <= r_bufd_int_266m_1d & (~r_bufd_int_2d);
    end
end
generate
for(i=0;i<XAUI_NUM*2;i=i+1) begin:SH_100M_CDC
signal_cross_rope_tie 
m_sh_100m_cdc(
    .src_clk    (clk_100m   ),
    .src_rstn   (rstn_100m  ),
    .des_clk    (clk_cpu    ),
    .des_rstn   (rstn_cpu   ),
    .i_sig      (c_shakehand_int_100m[i]),
    .o_sig      (c_shakehand_int[i])    
);
end
endgenerate
signal_cross_rope_tie 
m_sh_50m_cdc(
    .src_clk    (clk_50m   ),
    .src_rstn   (rstn_50m  ),
    .des_clk    (clk_cpu    ),
    .des_rstn   (rstn_cpu   ),
    .i_sig      (spi_ctrl_int_50m),
    .o_sig      (c_spictrl_int_cpu)    
);


assign  shake_int_cpu = {
                        c_spictrl_int_cpu   ,r_bufd_int_2d_pos  ,
                        c_shakehand_int
};
//--------------------------------------
// Module Instance 
//--------------------------------------


endmodule
//gpio_int_req_cdc.v ends here
