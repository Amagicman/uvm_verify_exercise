// =============================================================================
// Filename: gpio_int.v
// Description:
// Author: Shi shuguang
// Created: Tue Jan  3 08:00:18 CST 2017
// =============================================================================
// Release History
//      Version        Date        Author        Description
//      V001           Created     Shishuguang   Initial version                         
// =============================================================================
// Global Parameters
//      Parameter Name  Range       : Description       : Default   : Units
//      P_DATA_W        [32,16]     : width of data     : 32
// =============================================================================
module gpio_int(
    input           clk_cpu                 ,
    input           clk_50m                 ,
    input           clk_100m                ,
    input           clk_200m                ,
    input           clk_400m                ,
    input           I_IT_RX_IFCLK           ,
    input           I_OT_RX_IFCLK           ,
    input           rstn_50m                ,
    input           INTA_N                  ,
    output          INTR                    ,
    output [6:0]    INT_CODE                ,
    input           i_csn_50m               ,
    input           i_wr_50m                ,
    input           i_rd_50m                ,
    input   [23:0]  i_addr_50m              ,
    input   [31:0]  i_datin_50m             ,
    output  [31:0]  o_datout_50m            ,
    input           ns_asip_err_int_400m    ,
    input           pcm_asip_err_int_400m   ,
    input           crm_rst_done_50m        ,
    input           lbus_err_int_cpu        ,
    input   [15:0]  ns_sw_int_400m          ,
    input           ns_otm_int_400m         ,
    input           ns_check_int_400m       ,
    input           ns_peri_err_int_400m    ,
    //input           ns_err_int_400m         ,
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
    input           xd_link_int             

);

//--------------------------------------
//-------- Local Parameters  -----------
//--------------------------------------
//constraint ERR_W + INF_W + SK_W <= 128
localparam  ERR_W   = 44  ;//(32,64)
localparam  INF_W   = 50  ;//(32,64)
localparam  SK_W    = 15  ;//(0 ,32)

//--------------------------------------
//-------  Port Declaration  -----------
//--------------------------------------

//--------------------------------------
//------- Local Vars Declaration -------
//--------------------------------------
//local asyn_reset
wire                    c_rstn_50m          ;
wire                    c_rstn_cpu          ;
wire                    c_rstn_100m         ;
wire                    c_rstn_200m         ;
wire                    c_rstn_400m         ;
wire                    c_rstn_it           ;
wire                    c_rstn_ot           ;
//50M domain cfg
wire    [ERR_W-1:0]     c_error_mask_50m   ;
wire    [INF_W-1:0]     c_inform_mask_50m  ;
wire    [SK_W-1:0]      c_shake_maske_50m  ;
wire    [ERR_W-1:0]     c_error_state_50m  ;
wire    [INF_W-1:0]     c_inform_state_50m ;
wire    [SK_W-1:0]      c_shake_state_50m  ;
//cpu domain cfg
wire    [ERR_W-1:0]     c_error_mask_cpu   ;
wire    [INF_W-1:0]     c_inform_mask_cpu  ;
wire    [SK_W-1:0]      c_shake_maske_cpu  ;
wire    [ERR_W-1:0]     c_error_state_cpu  ;
wire    [INF_W-1:0]     c_inform_state_cpu ;
wire    [SK_W-1:0]      c_shake_state_cpu  ;
//shape int
wire    [ERR_W-1:0]     c_error_int_cpu    ; 
wire    [INF_W-1:0]     c_inform_int_cpu   ; 
wire    [SK_W-1:0]      c_shake_int_cpu    ; 

//--------------------------------------
// Function 1:
//--------------------------------------

//--------------------------------------
// Function 2:
//--------------------------------------

//--------------------------------------
// Module Instance 
//--------------------------------------
gpio_int_cfg 
#(
    .ERR_W   (ERR_W),
    .INF_W   (INF_W),
    .SK_W    (SK_W)
)
m_gpio_int_cfg
(
    .clk_50m          (clk_50m          ),
    .rstn_50m         (c_rstn_50m       ),
    .i_csn_50m        (i_csn_50m        ),
    .i_wr_50m         (i_wr_50m         ),
    .i_rd_50m         (i_rd_50m         ),
    .i_addr_50m       (i_addr_50m       ),
    .i_datin_50m      (i_datin_50m      ),
    .o_datout_50m     (o_datout_50m     ),
    .error_mask_50m   (c_error_mask_50m   ),
    .inform_mask_50m  (c_inform_mask_50m  ),
    .shake_maske_50m  (c_shake_maske_50m  ),
    .error_state_50m  (c_error_state_50m  ),
    .inform_state_50m (c_inform_state_50m ),
    .shake_state_50m  (c_shake_state_50m  ) 
);

gpio_int_rst
m_gpio_int_rst
(
    .rstn_50m        (rstn_50m          ),
    .clk_50m         (clk_50m           ),
    .clk_cpu         (clk_cpu           ),
    .clk_100m        (clk_100m          ),
    .clk_200m        (clk_200m          ),
    .clk_400m        (clk_400m          ),
    .I_IT_RX_IFCLK   (I_IT_RX_IFCLK     ),
    .I_OT_RX_IFCLK   (I_OT_RX_IFCLK     ),
    .o_rstn_50m      (c_rstn_50m        ),
    .rstn_cpu        (c_rstn_cpu        ),
    .rstn_100m       (c_rstn_100m       ),
    .rstn_200m       (c_rstn_200m       ),
    .rstn_400m       (c_rstn_400m       ),
    .rstn_it         (c_rstn_it         ),
    .rstn_ot         (c_rstn_ot         )

);
//50M syncho to cpu domain
gpio_int_synchro 
#(
    .DAT_W (ERR_W) 
)
m_gpio_int_synto_cpu_err
(
    .src_clk     (clk_50m           ),
    .src_rstn    (c_rstn_50m        ),
    .i_src_dat   (c_error_mask_50m  ),
    .des_clk     (clk_cpu           ),
    .des_rstn    (c_rstn_cpu        ),
    .o_des_dat   (c_error_mask_cpu  )
);
gpio_int_synchro 
#(
    .DAT_W (INF_W) 
)
m_gpio_int_synto_cpu_inf
(
    .src_clk     (clk_50m           ),
    .src_rstn    (c_rstn_50m        ),
    .i_src_dat   (c_inform_mask_50m ),
    .des_clk     (clk_cpu           ),
    .des_rstn    (c_rstn_cpu        ),
    .o_des_dat   (c_inform_mask_cpu )
);
gpio_int_synchro 
#(
    .DAT_W (SK_W) 
)
m_gpio_int_synto_cpu_sk
(
    .src_clk     (clk_50m           ),
    .src_rstn    (c_rstn_50m        ),
    .i_src_dat   (c_shake_maske_50m ),
    .des_clk     (clk_cpu           ),
    .des_rstn    (c_rstn_cpu        ),
    .o_des_dat   (c_shake_maske_cpu )
);
//cpu synchro to 50m domain
gpio_int_synchro 
#(
    .DAT_W (ERR_W) 
)
m_gpio_int_synto_50m_err
(
    .src_clk     (clk_cpu           ),
    .src_rstn    (c_rstn_cpu        ),
    .i_src_dat   (c_error_state_cpu ),
    .des_clk     (clk_50m           ),
    .des_rstn    (c_rstn_50m        ),
    .o_des_dat   (c_error_state_50m )

);
gpio_int_synchro 
#(
    .DAT_W (INF_W) 
)
m_gpio_int_synto_50m_inf
(
    .src_clk     (clk_cpu           ),
    .src_rstn    (c_rstn_cpu        ),
    .i_src_dat   (c_inform_state_cpu),
    .des_clk     (clk_50m           ),
    .des_rstn    (c_rstn_50m        ),
    .o_des_dat   (c_inform_state_50m)

);
gpio_int_synchro 
#(
    .DAT_W (SK_W) 
)
m_gpio_int_synto_50m_sk
(
    .src_clk     (clk_cpu           ),
    .src_rstn    (c_rstn_cpu        ),
    .i_src_dat   (c_shake_state_cpu ),
    .des_clk     (clk_50m           ),
    .des_rstn    (c_rstn_50m        ),
    .o_des_dat   (c_shake_state_50m )

);
//request collect and translate to pulse
gpio_int_req_cdc #(
    .ERR_W  (ERR_W  ),
    .INF_W  (INF_W  ),
    .SK_W   (SK_W   )
)
m_gpio_int_req_cdc
(
    .clk_50m                (clk_50m           ),
    .clk_cpu                (clk_cpu           ),
    .clk_100m               (clk_100m          ),
    .clk_200m               (clk_200m          ),
    .clk_400m               (clk_400m          ),
    .I_IT_RX_IFCLK          (I_IT_RX_IFCLK     ),
    .I_OT_RX_IFCLK          (I_OT_RX_IFCLK     ),
    .rstn_50m               (c_rstn_50m        ),
    .rstn_cpu               (c_rstn_cpu        ),
    .rstn_100m              (c_rstn_100m       ),
    .rstn_200m              (c_rstn_200m       ),
    .rstn_400m              (c_rstn_400m       ),
    .rstn_it                (c_rstn_it         ),
    .rstn_ot                (c_rstn_ot         ),    
    .ns_asip_err_int_400m    (ns_asip_err_int_400m),
    .pcm_asip_err_int_400m   (pcm_asip_err_int_400m),
    .crm_rst_done_50m        (crm_rst_done_50m        ),
    .lbus_err_int_cpu        (lbus_err_int_cpu        ),
    .ns_sw_int_400m          (ns_sw_int_400m          ),
    .ns_otm_int_400m         (ns_otm_int_400m         ),
    .ns_check_int_400m       (ns_check_int_400m       ),
    //.ns_err_int_400m         (ns_err_int_400m         ),
    .ns_peri_err_int_400m    (ns_peri_err_int_400m    ),
    .pcm_sw_int_400m         (pcm_sw_int_400m         ),
    .pcm_check_int_400m      (pcm_check_int_400m      ),
    //.pcm_err_int_400m        (pcm_err_int_400m        ),
    .pcm_peri_err_int_400m   (pcm_peri_err_int_400m   ),
    .spi_ctrl_int_50m        (spi_ctrl_int_50m        ),
    .spi_ill_int_50m         (spi_ill_int_50m         ),
    .spi_load_int_50m        (spi_load_int_50m        ),
    .spi_err_int_50m         (spi_err_int_50m         ),
    .mg_err_int_200m         (mg_err_int_200m         ),
    .ia2xg_err_int_200m      (ia2xg_err_int_200m      ),
    .ibufd_err_int_400m      (ibufd_err_int_400m      ),
    .itcam_err_int_400m      (itcam_err_int_400m      ),
    .itcam_check_int_rclk    (itcam_check_int_rclk    ),
    .icfg_err_int_400m       (icfg_err_int_400m       ),
    .inif_err_int_400m       (inif_err_int_400m       ),
    .ienif_err_int_400m      (ienif_err_int_400m      ),
    .iama1_err_int_400m      (iama1_err_int_400m      ),
    .iama1_normal_int_400m   (iama1_normal_int_400m   ),
    .iama2_err_int_400m      (iama2_err_int_400m      ),
    .iama2_normal_int_400m   (iama2_normal_int_400m   ),
    .iamf_err_int_400m       (iamf_err_int_400m       ),
    .isec_err_int_400m       (isec_err_int_400m       ),
    .isch_err_int_400m       (isch_err_int_400m       ),
    .isram_err_int_400m      (isram_err_int_400m      ),
    .iqos0_err_int_400m      (iqos0_err_int_400m      ),
    .iqos1_err_int_400m      (iqos1_err_int_400m      ),
    .iminsch_err_int_400m    (iminsch_err_int_400m    ),
    .imeter_err_int_400m     (imeter_err_int_400m     ),
    .oa2xg_err_int_200m      (oa2xg_err_int_200m      ),
    .obufd_err_int_400m      (obufd_err_int_400m      ),
    .otcam_err_int_400m      (otcam_err_int_400m      ),
    .otcam_check_int_rclk    (otcam_check_int_rclk    ),
    .ocfg_err_int_400m       (ocfg_err_int_400m       ),
    .onif_err_int_400m       (onif_err_int_400m       ),
    .oenif_err_int_400m      (oenif_err_int_400m      ),
    .oama1_err_int_400m      (oama1_err_int_400m      ),
    .oama1_normal_int_400m   (oama1_normal_int_400m   ),
    .oama2_err_int_400m      (oama2_err_int_400m      ),
    .oama2_normal_int_400m   (oama2_normal_int_400m   ),
    .oamf_err_int_400m       (oamf_err_int_400m       ),
    .osec_err_int_400m       (osec_err_int_400m       ),
    .osch_err_int_400m       (osch_err_int_400m       ),
    .osram_err_int_400m      (osram_err_int_400m      ),
    .oqos0_err_int_400m      (oqos0_err_int_400m      ),
    .oqos1_err_int_400m      (oqos1_err_int_400m      ),
    .ominsch_err_int_400m    (ominsch_err_int_400m    ),
    .ometer_err_int_400m     (ometer_err_int_400m     ),    
    .alg_err_int_400m        (alg_err_int_400m        ),
    .jcon_err_int_400m       (jcon_err_int_400m       ),
    .dmspi_err_int_400m      (dmspi_err_int_400m      ),
    .dmilbus_err_int_400m    (dmilbus_err_int_400m    ),
    .dmolbus_err_int_400m    (dmolbus_err_int_400m    ),
    .ibufd_ctrl_int          (ibufd_ctrl_int          ),
    .obufd_ctrl_int          (obufd_ctrl_int          ),
    .xi_sbd_int              (xi_sbd_int              ),
    .xi_pma_int              (xi_pma_int              ),
    .xi_link_int             (xi_link_int             ),
    .xo_sbd_int              (xo_sbd_int              ),
    .xo_pma_int              (xo_pma_int              ),
    .xo_link_int             (xo_link_int             ),
    .xa_sbd_int              (xa_sbd_int              ),
    .xa_pma_int              (xa_pma_int              ),
    .xa_link_int             (xa_link_int             ),
    .xb_sbd_int              (xb_sbd_int              ),
    .xb_pma_int              (xb_pma_int              ),
    .xb_link_int             (xb_link_int             ),
    .xc_sbd_int              (xc_sbd_int              ),
    .xc_pma_int              (xc_pma_int              ),
    .xc_link_int             (xc_link_int             ),
    .xd_sbd_int              (xd_sbd_int              ),
    .xd_pma_int              (xd_pma_int              ),
    .xd_link_int             (xd_link_int             ),
    .error_int_cpu           (c_error_int_cpu         ),
    .inform_int_cpu          (c_inform_int_cpu        ),
    .shake_int_cpu           (c_shake_int_cpu         )
);

gpio_int_do #(
    .ERR_W  (ERR_W  ),
    .INF_W  (INF_W  ),
    .SK_W   (SK_W   )
)
m_gpio_int_do
(
    .clk_cpu             (clk_cpu            ),
    .INTR                (INTR               ),
    .INT_CODE            (INT_CODE           ),
    .INTA_N              (INTA_N             ),

    .rstn_cpu            (c_rstn_cpu         ),
    .error_int_cpu       (c_error_int_cpu    ),
    .inform_int_cpu      (c_inform_int_cpu   ),
    .shake_int_cpu       (c_shake_int_cpu    ),
    .error_mask_cpu      (c_error_mask_cpu   ),
    .inform_mask_cpu     (c_inform_mask_cpu  ),
    .shake_maske_cpu     (c_shake_maske_cpu  ),
    .error_state_cpu     (c_error_state_cpu  ),
    .inform_state_cpu    (c_inform_state_cpu ),
    .shake_state_cpu     (c_shake_state_cpu  )
);

endmodule
//gpio_int.v ends here
