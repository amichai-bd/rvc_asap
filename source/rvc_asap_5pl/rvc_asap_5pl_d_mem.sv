//-----------------------------------------------------------------------------
// Title            : riscv as-fast-as-possible 
// Project          : rvc_asap
//-----------------------------------------------------------------------------
// File             : rvc_asap_5pl_d_mem
// Original Author  : Matan Eshel & Gil Ya'akov
// Code Owner       : 
// Adviser          : Amichai Ben-David
// Created          : 06/2022
//-----------------------------------------------------------------------------
// Description :
// This module serves as the data memory of the core.
// D_MEM will support sync memory read.
`include "rvc_asap_macros.sv"

module rvc_asap_5pl_d_mem (
    input  logic        clock,
    input  logic [31:0] data_a,
    input  logic [31:0] address_a,
    input  logic [3:0]  byteena_a,
    input  logic        wren_a,
    input  logic        rden_a,
    output logic [31:0] q_a
);
import rvc_asap_pkg::*;
// Memory array (behavrial - not for FPGA/ASIC)
logic [7:0]         DMem [D_MEM_MSB:I_MEM_MSB+1];
logic [7:0]         NextDMem [D_MEM_MSB:I_MEM_MSB+1];

// Data-Path signals
logic [31:0]        PreDMemRdData;
logic [31:0]        DMemRdDataQ103H;

//==============================
// Memory Access
//------------------------------
// 1. Access D_MEM for Wrote (STORE) and Reads (LOAD)
//==============================
always_comb begin
    NextDMem = DMem;
    if(wren_a) begin
        if(byteena_a[0]) NextDMem[address_a+0] = data_a[7:0];
        if(byteena_a[1]) NextDMem[address_a+1] = data_a[15:8] ;
        if(byteena_a[2]) NextDMem[address_a+2] = data_a[23:16];
        if(byteena_a[3]) NextDMem[address_a+3] = data_a[31:24];
    end
end

`RVC_MSFF(DMem , NextDMem , clock)
// This is the load
assign PreDMemRdData[7:0]     =  rden_a ? DMem[address_a+0] : 8'b0; 
assign PreDMemRdData[15:8]    =  rden_a ? DMem[address_a+1] : 8'b0;
assign PreDMemRdData[23:16]   =  rden_a ? DMem[address_a+2] : 8'b0;
assign PreDMemRdData[31:24]   =  rden_a ? DMem[address_a+3] : 8'b0;
assign DMemRdDataQ103H[7:0]   =  byteena_a[0] ? PreDMemRdData[7:0]   : 8'b0;
assign DMemRdDataQ103H[15:8]  =  byteena_a[1] ? PreDMemRdData[15:8]  : 8'b0;
assign DMemRdDataQ103H[23:16] =  byteena_a[2] ? PreDMemRdData[23:16] : 8'b0;
assign DMemRdDataQ103H[31:24] =  byteena_a[3] ? PreDMemRdData[31:24] : 8'b0;
// Sample the data load - synchorus load
`RVC_MSFF(q_a, DMemRdDataQ103H, clock)

endmodule // Module rvc_asap_5pl_d_mem