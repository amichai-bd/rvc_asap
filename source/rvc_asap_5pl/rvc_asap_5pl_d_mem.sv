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
    input  logic [31:0] data,
    input  logic [31:0] address,
    input  logic [3:0]  byteena,
    input  logic        wren,
    input  logic        rden,
    output logic [31:0] q
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
    if(wren) begin
        if(byteena[0]) NextDMem[address+0] = data[7:0];
        if(byteena[1]) NextDMem[address+1] = data[15:8] ;
        if(byteena[2]) NextDMem[address+2] = data[23:16];
        if(byteena[3]) NextDMem[address+3] = data[31:24];
    end
end

`RVC_MSFF(DMem , NextDMem , clock)
// This is the load
assign PreDMemRdData[7:0]     =  rden ? DMem[address+0] : 8'b0; 
assign PreDMemRdData[15:8]    =  rden ? DMem[address+1] : 8'b0;
assign PreDMemRdData[23:16]   =  rden ? DMem[address+2] : 8'b0;
assign PreDMemRdData[31:24]   =  rden ? DMem[address+3] : 8'b0;
assign DMemRdDataQ103H[7:0]   =  byteena[0] ? PreDMemRdData[7:0]   : 8'b0;
assign DMemRdDataQ103H[15:8]  =  byteena[1] ? PreDMemRdData[15:8]  : 8'b0;
assign DMemRdDataQ103H[23:16] =  byteena[2] ? PreDMemRdData[23:16] : 8'b0;
assign DMemRdDataQ103H[31:24] =  byteena[3] ? PreDMemRdData[31:24] : 8'b0;
// Sample the data load - synchorus load
`RVC_MSFF(q, DMemRdDataQ103H, clock)

endmodule // Module rvc_asap_5pl_d_mem