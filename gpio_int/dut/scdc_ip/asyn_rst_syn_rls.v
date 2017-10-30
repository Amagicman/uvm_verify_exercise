//------------------------------------------------------------------------
// Project:     SCDC-NP2
//------------------------------------------------------------------------
// Date   :     3/29/2016
//------------------------------------------------------------------------
// Author :     gxl
//------------------------------------------------------------------------
// Version:     v1.0
//------------------------------------------------------------------------
// Name   :     Asynchronous Reset and Synchronous Release
//------------------------------------------------------------------------
// Description: A asyn reset input 2-flip-flop and 1 be released by Q
//              i_clkin is the syn clk domian
//              i_reset is a asyn reset signal
//------------------------------------------------------------------------

module asyn_rst_syn_rls(
    input       i_reset,
    input       i_clkin,

    output      o_reset
);



reg [1:0] r_syn;




always @ (posedge i_clkin or negedge i_reset)
    if(~i_reset)
        r_syn[0] <= 1'b0;
    else r_syn[0] <= 1'b1;


always @ (posedge i_clkin or negedge i_reset)
    if(~i_reset)
        r_syn[1] <= 1'b0;
    else r_syn[1] <= r_syn[0];


assign o_reset = r_syn[1];


endmodule//end of asyn_rst_syn_rls.v
