// =============================================================================
// Filename: gpio_int_cfg.v
// Description:config register.
// Author: Shi shuguang
// Created: Mon Jan 23 09:23:25 CST 2017
// =============================================================================
// Release History
//      Version        Date        Author        Description
//      V001           Created     Shishuguang   Initial version                         
// =============================================================================
// Global Parameters
//      Parameter Name  Range       : Description       : Default   : Units
//      ERR_W           (64,32)                           48
//      INF_W           (64,32)                           50
//      SK_W            (32,0 )                           15
// =============================================================================
module gpio_int_cfg #(
    parameter   ERR_W   = 42 ,
    parameter   INF_W   = 50 ,
    parameter   SK_W    = 15
)
(
    input                       clk_50m          ,
    input                       rstn_50m         ,
    input                       i_csn_50m        ,
    input                       i_wr_50m         ,
    input                       i_rd_50m         ,
    input       [23:0]          i_addr_50m       ,
    input       [31:0]          i_datin_50m      ,
    output  reg [31:0]          o_datout_50m     ,
    output      [ERR_W-1:0]     error_mask_50m   ,
    output      [INF_W-1:0]     inform_mask_50m  ,
    output      [SK_W-1:0]      shake_maske_50m  ,
    input       [ERR_W-1:0]     error_state_50m  ,
    input       [INF_W-1:0]     inform_state_50m ,
    input       [SK_W-1:0]      shake_state_50m   
);

//--------------------------------------
//-------- Local Parameters  -----------
//--------------------------------------
localparam  P_SH_MASK_ADDR0         = 24'h00_0000;
localparam  P_INFO_MASK_ADDR0       = 24'h00_0010;
localparam  P_INFO_MASK_ADDR1       = 24'h00_0014;
localparam  P_ERR_MASK_ADDR0        = 24'h00_0020;
localparam  P_ERR_MASK_ADDR1        = 24'h00_0024;
localparam  P_SH_STA_ADDR0          = 24'h00_0030;
localparam  P_INFO_STA_ADDR0        = 24'h00_0040;
localparam  P_INFO_STA_ADDR1        = 24'h00_0044;
localparam  P_ERR_STA_ADDR0         = 24'h00_0050;
localparam  P_ERR_STA_ADDR1         = 24'h00_0054;

//--------------------------------------
//-------  Port Declaration  -----------
//--------------------------------------

//--------------------------------------
//------- Local Vars Declaration -------
//--------------------------------------
reg         r_csn               ;
reg         r_rd_en             ;
reg         r_wr_en             ;
reg [23:0]  r_addr              ;
reg [31:0]  r_data_in           ;
wire        c_cfg_wr_vld        ;
wire        c_cfg_rd_vld        ;
reg [31:0]  r_rdata             ;
reg [31:0]  r_rdata_3d;
reg [31:0]  r_rdata_4d;
reg [31:0]  r_rdata_5d;

reg [31:0]  r_sh_mask0          ;
reg [31:0]  r_info_mask0        ;
reg [31:0]  r_info_mask1        ;
reg [31:0]  r_err_mask0         ;
reg [31:0]  r_err_mask1         ;


//--------------------------------------
// Function 1:
//--------------------------------------
always @(posedge clk_50m or negedge rstn_50m) begin
    if(~rstn_50m) begin
        r_csn   <= 1'b1;
        r_rd_en <= 1'b0;
        r_wr_en <= 1'b0;
        r_addr  <= 24'b0;
        r_data_in<= 32'b0;
    end else begin
        r_csn   <= i_csn_50m;
        r_rd_en <= i_rd_50m;
        r_wr_en <= i_wr_50m;
        r_addr  <= i_addr_50m;
        r_data_in<= i_datin_50m;
    end
end

assign  c_cfg_wr_vld = (~r_csn) & r_wr_en;
assign  c_cfg_rd_vld = (~r_csn) & r_rd_en;
//shakehand mask
always @(posedge clk_50m or negedge rstn_50m) begin
    if(~rstn_50m) begin
        r_sh_mask0 <= 32'b0;
    end else if(c_cfg_wr_vld & (r_addr==P_SH_MASK_ADDR0)) begin
        r_sh_mask0 <= r_data_in;
    end else begin
        r_sh_mask0 <= r_sh_mask0;
    end
end
//info mask
always @(posedge clk_50m or negedge rstn_50m) begin
    if(~rstn_50m) begin
        r_info_mask0 <= 32'b0;
    end else if(c_cfg_wr_vld & (r_addr==P_INFO_MASK_ADDR0)) begin
        r_info_mask0 <= r_data_in;
    end else begin
        r_info_mask0 <= r_info_mask0;
    end
end
always @(posedge clk_50m or negedge rstn_50m) begin
    if(~rstn_50m) begin
        r_info_mask1 <= 32'b0;
    end else if(c_cfg_wr_vld & (r_addr==P_INFO_MASK_ADDR1)) begin
        r_info_mask1 <= r_data_in;
    end else begin
        r_info_mask1 <= r_info_mask1;
    end
end
//error mask
always @(posedge clk_50m or negedge rstn_50m) begin
    if(~rstn_50m) begin
        r_err_mask0 <= 32'hffff_ffff;
    end else if(c_cfg_wr_vld & (r_addr==P_ERR_MASK_ADDR0)) begin
        r_err_mask0 <= r_data_in;
    end else begin
        r_err_mask0 <= r_err_mask0;
    end
end
always @(posedge clk_50m or negedge rstn_50m) begin
    if(~rstn_50m) begin
        r_err_mask1 <= {{64-ERR_W{1'b0}},{ERR_W-32{1'b1}}};
    end else if(c_cfg_wr_vld & (r_addr==P_ERR_MASK_ADDR1)) begin
        r_err_mask1 <= r_data_in;
    end else begin
        r_err_mask1 <= r_err_mask1;
    end
end
assign  error_mask_50m  = {r_err_mask1[ERR_W-33:0],r_err_mask0};
assign  inform_mask_50m = {r_info_mask1[INF_W-33:0],r_info_mask0}; 
assign  shake_maske_50m =  r_sh_mask0[SK_W-1:0];
//--------------------------------------
// Function 2:read block
//--------------------------------------
always @(posedge clk_50m or negedge rstn_50m) begin
    if(~rstn_50m) begin
        r_rdata <= 32'b0;
    end else if(c_cfg_rd_vld) begin
        case(r_addr)
            P_SH_MASK_ADDR0   : r_rdata <= r_sh_mask0;
            P_INFO_MASK_ADDR0 : r_rdata <= r_info_mask0;
            P_INFO_MASK_ADDR1 : r_rdata <= r_info_mask1;
            P_ERR_MASK_ADDR0  : r_rdata <= r_err_mask0;
            P_ERR_MASK_ADDR1  : r_rdata <= r_err_mask1;
            P_SH_STA_ADDR0    : r_rdata <= {{32-SK_W{1'b0}},shake_state_50m};
            P_INFO_STA_ADDR0  : r_rdata <= inform_state_50m[31:0];
            P_INFO_STA_ADDR1  : r_rdata <= {{64-INF_W{1'b0}},inform_state_50m[INF_W-1:32]};
            P_ERR_STA_ADDR0   : r_rdata <= error_state_50m[31:0];
            P_ERR_STA_ADDR1   : r_rdata <=  {{64-ERR_W{1'b0}},error_state_50m[ERR_W-1:32]};
            default:r_rdata <= 32'b0;
        endcase
    end else begin
        r_rdata <= 32'b0;
    end
end
always @(posedge clk_50m or negedge rstn_50m) begin
    if(~rstn_50m) begin
        r_rdata_3d   <= 32'b0;
        r_rdata_4d   <= 32'b0;
        r_rdata_5d   <= 32'b0;
        o_datout_50m <= 32'b0;
    end else begin
        r_rdata_3d   <= r_rdata;
        r_rdata_4d   <= r_rdata_3d;
        r_rdata_5d   <= r_rdata_4d;
        o_datout_50m <= r_rdata_5d;
    end
end
//--------------------------------------
// Module Instance 
//--------------------------------------


endmodule
//gpio_int_cfg.v ends here
