//*************************************************************************
// Description : This module crosses i_sig from src to des;
//               This module independ on frequnce either src or des;
//               This module must be used for 1-bit signal;
// Date        : 2016-04-12
// Project     : NP2
// Author      : Gxl
//*************************************************************************

module signal_cross_rope_tie(src_clk,src_rstn,des_clk,des_rstn,i_sig,o_sig);

input src_clk;
input src_rstn;
input des_clk;
input des_rstn;
input i_sig;
output reg o_sig;

reg r_i_sig_d0;
wire c_i_sig_pos;
reg r_rope;
reg [1:0]r_css;
reg r_des_d;
reg [1:0] r_feedback;
wire    c_css_pos;//added by ssg

always@(posedge src_clk or negedge src_rstn)
    if(~src_rstn)
        r_i_sig_d0 <= 1'b0;
    else r_i_sig_d0 <= i_sig;

assign c_i_sig_pos = i_sig & (~r_i_sig_d0);

always@(posedge src_clk or negedge src_rstn)
    if(~src_rstn)
        r_rope <= 1'b0;
    else if(c_i_sig_pos)
        r_rope <= 1'b1;
    else if(r_feedback[1])
        r_rope <= 1'b0;

always@(posedge des_clk or negedge des_rstn)
    if(~des_rstn)begin
        r_css[0] <= 1'b0;
        r_css[1] <= 1'b0;
    end
    else begin
        r_css[0] <= r_rope;
        r_css[1] <= r_css[0];
    end

always@(posedge des_clk or negedge des_rstn)
    if(~des_rstn)
        r_des_d <= 1'b0;
    else r_des_d <= r_css[1]; 

assign c_css_pos = r_css[1] & (~r_des_d);

always@(posedge src_clk or negedge src_rstn)
    if(~src_rstn)begin
        r_feedback[0] <= 1'b0;
        r_feedback[1] <= 1'b0;
    end
    else begin
        r_feedback[0] <= r_css[1];
        r_feedback[1] <= r_feedback[0];
    end

always@(posedge des_clk or negedge des_rstn)
    if(~des_rstn)
        o_sig <= 1'b0;
    else o_sig <= c_css_pos;

endmodule
