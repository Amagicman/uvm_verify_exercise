// =============================================================================
// Filename: gpio_int_do.v
// Description:detect interrupt sources value 1 from left hand.and send code
// to cpu.
// Author: Shi shuguang
// Created: Thu Jan 19 14:18:24 CST 2017
// =============================================================================
// Release History
//      Version        Date        Author        Description
//      V001           Created     Shishuguang   Initial version                         
// =============================================================================
// Global Parameters
//      Parameter Name  Range       : Description       : Default   : Units
//      ERR_W                         error interrupt number
//      INF_W                         information interrupt number
//      SK_W                          handshake interrupt number
// =============================================================================
module gpio_int_do #(
    parameter   ERR_W   = 2 ,
    parameter   INF_W   = 2 ,
    parameter   SK_W    = 2
)
(
    input                   clk_cpu             ,
    output  reg             INTR                ,
    output  reg [6:0]       INT_CODE            ,
    input                   INTA_N              ,

    input                   rstn_cpu            ,
    input   [ERR_W-1:0]     error_int_cpu       ,
    input   [INF_W-1:0]     inform_int_cpu      ,
    input   [SK_W-1:0]      shake_int_cpu       ,
    input   [ERR_W-1:0]     error_mask_cpu      ,
    input   [INF_W-1:0]     inform_mask_cpu     ,
    input   [SK_W-1:0]      shake_maske_cpu     ,
    output  [ERR_W-1:0]     error_state_cpu     ,
    output  [INF_W-1:0]     inform_state_cpu    ,
    output  [SK_W-1:0]      shake_state_cpu   
);

//--------------------------------------
//-------- Local Parameters  -----------
//--------------------------------------
localparam L_INT_NUM = ERR_W + INF_W + SK_W;
//--------------------------------------
//-------  Port Declaration  -----------
//--------------------------------------
//clk_cpu             //pad,
//INTR                //pad,
//INT_CODE            //pad,
//INTA_N              //pad,
//rstn_cpu            //local reset,
//error_int_cpu       //interrupt source,
//inform_int_cpu      //interrupt source,
//shake_int_cpu       //interrupt source,
//error_mask_cpu      //interrupt mask,
//inform_mask_cpu     //interrupt mask,
//shake_maske_cpu     //interrupt mask,
//error_state_cpu     //interrupt state  ,
//inform_state_cpu    //interrupt state  ,
//shake_state_cpu     //interrupt state
//--------------------------------------
//------- Local Vars Declaration -------
//--------------------------------------
genvar i;//loop vars
reg     [L_INT_NUM  -1:0]   r_isr              ;
reg     [L_INT_NUM  -1:0]   r_imr              ;
reg                         r_initial_mask     ;
reg     [L_INT_NUM  -1:0]   r_isr_one_hot      ;
wire    [L_INT_NUM  -1:0]   c_int_collect      ;
wire    [L_INT_NUM  -1:0]   c_int_mask_collect ;
wire    [L_INT_NUM  -1:0]   c_ack_clr          ;
wire                        c_clr_mask         ;
wire                        c_load_mask        ;
wire    [L_INT_NUM  -1:0]   c_isr_v            ;
wire                        c_isr_vld          ;
//wire    [L_INT_NUM  -1:0]   c_isr_v_rsh        ;
//wire    [L_INT_NUM  -1:0]   c_isr_v_rsh_inv    ;
wire    [L_INT_NUM  -1:0]   c_isr_one_hot      ;
wire                        c_ack_vld          ;
wire    [6:0]               c_dec_bin          ;
wire    [127:0]             c_isr_v_expand     ;
wire    [128-L_INT_NUM-1:0] c_isr_rev0         ;//reserve bits
wire    [63:0]              sel1               ;
wire    [31:0]              sel2               ;
wire    [15:0]              sel3               ;
wire    [7:0]               sel4               ;
wire    [3:0]               sel5               ;
wire    [1:0]               sel6               ;
//--------------------------------------
// Function 1:ISR block
//--------------------------------------
assign  c_int_collect   = {error_int_cpu,inform_int_cpu,shake_int_cpu};
assign  error_state_cpu = r_isr[L_INT_NUM-1 : INF_W+SK_W];
assign  inform_state_cpu= r_isr[INF_W+SK_W-1: SK_W];
assign  shake_state_cpu = r_isr[SK_W-1      : 0];
generate
for(i=0;i<L_INT_NUM;i=i+1) begin:ISR_CELL
    always@(posedge clk_cpu or negedge rstn_cpu) begin
        if(~rstn_cpu) begin
            r_isr[i] <= 1'b0;
        end else if(c_int_collect[i]==1'b1) begin:SET_ISR
            r_isr[i] <= 1'b1;
        end else if(c_ack_clr[i]) begin:CLEAR_ISR
            r_isr[i] <= 1'b0;
        end else begin
            r_isr[i] <= r_isr[i];
        end

    end
end
endgenerate
//--------------------------------------
// Function 2:IMR block
//--------------------------------------
assign  c_int_mask_collect = {error_mask_cpu,inform_mask_cpu,shake_maske_cpu};
generate
for(i=0;i<L_INT_NUM;i=i+1) begin:IMR_CELL
    always@(posedge clk_cpu or negedge rstn_cpu) begin
        if(~rstn_cpu) begin
            r_imr[i] <= 1'b0;
        end else if(c_clr_mask)begin:CLEAR_MASK
            r_imr[i] <= 1'b0;
        end else if(c_load_mask) begin:LOAD_MASK
            r_imr[i] <= c_int_mask_collect[i];
        end else if(~r_initial_mask) begin:INITIAL_MASK
            r_imr[i] <= c_int_mask_collect[i];
        end else begin
            r_imr[i] <= r_imr[i];
        end
    end
end 
endgenerate

//--------------------------------------
// Function 3:ISR_V  and ISR_VLD
//--------------------------------------
assign  c_isr_v = r_isr & r_imr;
assign  c_isr_vld = |c_isr_v;
assign  c_clr_mask  = c_isr_vld;
always@(posedge clk_cpu or negedge rstn_cpu) begin
    if(~rstn_cpu) begin
        r_initial_mask <= 1'b0;
    end else if(c_clr_mask) begin
        r_initial_mask <= 1'b1;
    end else begin
        r_initial_mask <= r_initial_mask;
    end
end

//--------------------------------------
// Function 4:one hot,reserved left one
// bit and right one bit clear.
//--------------------------------------
assign c_isr_one_hot = {127'b0,1'b1} << c_dec_bin;
//assign  c_isr_v_rsh = c_isr_v >> 1;
//assign  c_isr_v_rsh_inv = ~c_isr_v_rsh;
//assign  c_isr_one_hot = c_isr_v & c_isr_v_rsh_inv;

generate
for(i=0;i<L_INT_NUM;i=i+1) begin:ONE_HOT_CELL
    always@(posedge clk_cpu or negedge rstn_cpu) begin
        if(~rstn_cpu) begin
            r_isr_one_hot[i] <= 1'b0;
        end else if(c_isr_vld)begin:SET_HOT
            r_isr_one_hot[i] <= c_isr_one_hot[i];
        end else begin
            r_isr_one_hot[i] <= r_isr_one_hot[i];
        end
    end
end 
endgenerate

assign  c_ack_clr = {L_INT_NUM{c_ack_vld}} & r_isr_one_hot;
//--------------------------------------
// Function 5:check one from left hand
// and decode to binary code.
//--------------------------------------
assign  c_isr_rev0 = {128-L_INT_NUM{1'b0}};
assign  c_isr_v_expand = {c_isr_rev0,c_isr_v};
//two divide fucntion
assign {sel1,c_dec_bin[6]} = (c_isr_v_expand[127:64]==0) ? {c_isr_v_expand[63:0],1'b0} : {c_isr_v_expand[127:64],1'b1};
assign {sel2,c_dec_bin[5]} = (sel1[63:32]==0)     ? {sel1[31:0],1'b0}    : {sel1[63:32],1'b1};
assign {sel3,c_dec_bin[4]} = (sel2[31:16]==0)     ? {sel2[15:0],1'b0}    : {sel2[31:16],1'b1};
assign {sel4,c_dec_bin[3]} = (sel3[15:8] ==0)     ? {sel3[7:0] ,1'b0}    : {sel3[15:8] ,1'b1};
assign {sel5,c_dec_bin[2]} = (sel4[7:4]  ==0)     ? {sel4[3:0] ,1'b0}    : {sel4[7:4]  ,1'b1};
assign {sel6,c_dec_bin[1]} = (sel5[3:2]  ==0)     ? {sel5[1:0] ,1'b0}    : {sel5[3:2]  ,1'b1};
assign c_dec_bin[0]        = (sel6[1]    ==0)     ? 1'b0                 : 1'b1;

//--------------------------------------
// Function 6:INTR and INT_CODE block
//--------------------------------------
assign  c_ack_vld  = INTR & (~INTA_N);
assign  c_load_mask = c_ack_vld;
//INTR
always@(posedge clk_cpu or negedge rstn_cpu) begin
    if(~rstn_cpu) begin
        INTR    <= 1'b0;
    end else if(c_isr_vld) begin:SET_REQ
        INTR    <= 1'b1;
    end else if(c_ack_vld) begin:CLEAR_REQ
        INTR    <= 1'b0;
    end else begin
        INTR    <= INTR;
    end
end
//INT_CODE  
always@(posedge clk_cpu or negedge rstn_cpu) begin
    if(~rstn_cpu) begin
        INT_CODE    <= 7'b0;
    end else if(c_isr_vld) begin:LATCH_CODE
        INT_CODE    <= c_dec_bin;
    end else begin
        INT_CODE    <= INT_CODE;
    end
end

//--------------------------------------
// Module Instance 
//--------------------------------------


endmodule
//gpio_int_do.v ends here
