//-----------------------------------------------------------------------------
// Title            : riscv as-fast-as-possible 
// Project          : rvc_asap
//-----------------------------------------------------------------------------
// File             : rvc_asap 
// Original Author  : Amichai Ben-David
// Code Owner       : 
// Adviser          : Amichai Ben-David
// Created          : 10/2021
//-----------------------------------------------------------------------------
// Description :
`ifndef RVC_ASAP_MACROS
`define RVC_ASAP_MACROS
`define  RVC_MSFF(q,i,clk)             \
         always_ff @(posedge clk)      \
            q<=i;

`define  RVC_EN_MSFF(q,i,clk,en)       \
         always_ff @(posedge clk)      \
            if(en) q<=i;

`define  RVC_RST_MSFF(q,i,clk,rst)      \
         always_ff @(posedge clk) begin \
            if (rst) q <='0;            \
            else     q <= i;            \
         end

`define  RVC_EN_RST_MSFF(q,i,clk,en,rst)\
         always_ff @(posedge clk)       \
            if (rst)    q <='0;         \
            else if(en) q <= i;
`endif //RVC_ASAP_MACROS