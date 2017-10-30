// =============================================================================
// Filename: gpio_int_synchro.v
// Description:two level Synchronizer.width of data config.CDC happen in
// SYNCHRON2 block.
// Author: Shi shuguang
// Created: Thu Jan 19 13:42:14 CST 2017
// =============================================================================
// Release History
//      Version        Date        Author        Description
//      V001           Created     Shishuguang   Initial version                         
// =============================================================================
// Global Parameters
//      Parameter Name  Range       : Description       : Default   : Units
//      DAT_W           [1,n]       : width of data     : 1
// =============================================================================
module gpio_int_synchro #(
    parameter   DAT_W =1 )
(
    input                   src_clk     ,
    input                   src_rstn    ,
    input   [DAT_W-1:0]     i_src_dat   ,
    input                   des_clk     ,
    input                   des_rstn    ,
    output reg  [DAT_W-1:0] o_des_dat   

);

//--------------------------------------
//-------- Local Parameters  -----------
//--------------------------------------

//--------------------------------------
//-------  Port Declaration  -----------
//--------------------------------------

//--------------------------------------
//------- Local Vars Declaration -------
//--------------------------------------
reg [DAT_W-1:0] r_src_dat   ;
reg [DAT_W-1:0] r_des_syn   ;

//--------------------------------------
// Function 1:input register
//--------------------------------------
//D flop
always @(posedge src_clk or negedge src_rstn) begin:IN_REG
    if(~src_rstn) begin
        r_src_dat   <= {DAT_W{1'b0}};
    end else begin
        r_src_dat   <= i_src_dat;
    end
end

//--------------------------------------
// Function 2:synchronizer 2
//--------------------------------------
always @(posedge des_clk or negedge des_rstn) begin:SYNCHRON2
    if(~des_rstn) begin
        r_des_syn   <= {DAT_W{1'b0}};
        o_des_dat   <= {DAT_W{1'b0}};
    end else begin
        r_des_syn   <= r_src_dat;
        o_des_dat   <= r_des_syn;
    end
end

//--------------------------------------
// Module Instance 
//--------------------------------------


endmodule
//gpio_int_synchro.v ends here
