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
    input  logic        Clock,
    input  logic        Rst,
    input  logic [31:0] RegRdData2,
    input  logic [31:0] AluOut,
    input  logic [3:0]  CtrlDMemByteEn,
    input  logic        CtrlDMemWrEn,
    input  logic        SelDMemWb,
    input  logic        CtrlSignExt,
    output logic [31:0] DMemRdDataQ104H
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
    if(CtrlDMemWrEn) begin
        if(CtrlDMemByteEn[0]) NextDMem[AluOut+0] = RegRdData2[7:0];
        if(CtrlDMemByteEn[1]) NextDMem[AluOut+1] = RegRdData2[15:8] ;
        if(CtrlDMemByteEn[2]) NextDMem[AluOut+2] = RegRdData2[23:16];
        if(CtrlDMemByteEn[3]) NextDMem[AluOut+3] = RegRdData2[31:24];
    end
end

`RVC_MSFF(DMem , NextDMem , Clock)
// This is the load
assign PreDMemRdData[7:0]     =  SelDMemWb ? DMem[AluOut+0] : 8'b0; 
assign PreDMemRdData[15:8]    =  SelDMemWb ? DMem[AluOut+1] : 8'b0;
assign PreDMemRdData[23:16]   =  SelDMemWb ? DMem[AluOut+2] : 8'b0;
assign PreDMemRdData[31:24]   =  SelDMemWb ? DMem[AluOut+3] : 8'b0;
assign DMemRdDataQ103H[7:0]   =  CtrlDMemByteEn[0] ? PreDMemRdData[7:0]   : 8'b0;
assign DMemRdDataQ103H[15:8]  =  CtrlDMemByteEn[1] ? PreDMemRdData[15:8]  :
                                                     CtrlSignExt ? {8{DMemRdDataQ103H[7]}}   : 8'b0;
assign DMemRdDataQ103H[23:16] =  CtrlDMemByteEn[2] ? PreDMemRdData[23:16] :
                                                     CtrlSignExt ? {8{DMemRdDataQ103H[15]}}  : 8'b0;
assign DMemRdDataQ103H[31:24] =  CtrlDMemByteEn[3] ? PreDMemRdData[31:24] :
                                                     CtrlSignExt ? {8{DMemRdDataQ103H[23]}}  : 8'b0;
// Sample the data load - synchorus load
`RVC_MSFF(DMemRdDataQ104H, DMemRdDataQ103H, Clock)

endmodule // Module rvc_asap_5pl_d_mem