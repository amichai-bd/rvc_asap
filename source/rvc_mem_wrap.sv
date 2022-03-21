//-----------------------------------------------------------------------------
// Title            : riscv as-fast-as-possible 
// Project          : rvc_asap
//-----------------------------------------------------------------------------
// File             : rvc_mem_wrap
// Original Author  : Matan Eshel & Gil Ya'akov
// Code Owner       : 
// Adviser          : Amichai Ben-David
// Created          : 03/2022
//-----------------------------------------------------------------------------
// Description :
// This module serves as the memory of the core. This module contains both data memory and
// instruction memory. The I_MEM & D_MEM will support async memory read.

module rvc_mem_wrap (
    input  logic Clock,
    input  logic [31:0] Pc,             // I_MEM
    output logic [31:0] Instruction,    // I_MEM
    input  logic [31:0] RegRdData2,     // D_MEM
    input  logic [31:0] AluOut,         // D_MEM
    input  logic [3:0]  CtrlDMemByteEn, // D_MEM
    input  logic CtrlDMemWrEn,          // D_MEM
    input  logic SelDMemWb,             // D_MEM
    input  logic CtrlSignExt,           // D_MEM
    output logic [31:0] DMemRdData,     // D_MEM
    input  logic Rst
);
`include "rvc_asap_macros.sv"
import rvc_asap_pkg::*;  
//Memory array (behavrial - not for FPGA/ASIC)
logic [7:0]         IMem [I_MEM_MSB:0];
logic [7:0]         DMem [D_MEM_MSB:I_MEM_MSB+1];

//Data-Path signals
logic [31:0]        PreDMemRdData;

// Note: This memory is writtin in behavrial way for simulation - for FPGA/ASIC should be replaced with SRAM/RF/LATCH based memory etc.
// FIXME - currently this logic wont allow to load the I_MEM from HW interface - for simulation we will use Backdoor. (force with XMR)
`RVC_MSFF(IMem, IMem, Clock)
// This is the instruction fetch. (input pc, output Instruction)
assign Instruction[7:0]   = IMem[Pc+0]; // mux - Pc is the selector, IMem is the Data, Instuction is the Out
assign Instruction[15:8]  = IMem[Pc+1];
assign Instruction[23:16] = IMem[Pc+2];
assign Instruction[31:24] = IMem[Pc+3];
//==============================
// Memory Access
//------------------------------
// aceess D_MEM for Wrote (STORE) and Reads (LOAD)
//==============================
// Note: This memory is writtin in behavrial way for simulation - for FPGA/ASIC should be replaced with SRAM/RF/LATCH based memory etc.
`RVC_EN_MSFF(DMem[AluOut+0] , RegRdData2[7:0]   , Clock , (CtrlDMemWrEn && CtrlDMemByteEn[0]))
`RVC_EN_MSFF(DMem[AluOut+1] , RegRdData2[15:8]  , Clock , (CtrlDMemWrEn && CtrlDMemByteEn[1]))
`RVC_EN_MSFF(DMem[AluOut+2] , RegRdData2[23:16] , Clock , (CtrlDMemWrEn && CtrlDMemByteEn[2]))
`RVC_EN_MSFF(DMem[AluOut+3] , RegRdData2[31:24] , Clock , (CtrlDMemWrEn && CtrlDMemByteEn[3]))
// This is the load
assign PreDMemRdData[7:0]   =  SelDMemWb ? DMem[AluOut+0] : 8'b0; 
assign PreDMemRdData[15:8]  =  SelDMemWb ? DMem[AluOut+1] : 8'b0;
assign PreDMemRdData[23:16] =  SelDMemWb ? DMem[AluOut+2] : 8'b0;
assign PreDMemRdData[31:24] =  SelDMemWb ? DMem[AluOut+3] : 8'b0;
assign DMemRdData[7:0]      =  CtrlDMemByteEn[0] ? PreDMemRdData[7:0]   : 8'b0;
assign DMemRdData[15:8]     =  CtrlDMemByteEn[1] ? PreDMemRdData[15:8]  :
                               CtrlSignExt       ? {8{DMemRdData[7]}}   : 8'b0;
assign DMemRdData[23:16]    =  CtrlDMemByteEn[2] ? PreDMemRdData[23:16] :
                               CtrlSignExt       ? {8{DMemRdData[15]}}  : 8'b0;
assign DMemRdData[31:24]    =  CtrlDMemByteEn[3] ? PreDMemRdData[31:24] :
                               CtrlSignExt       ? {8{DMemRdData[23]}}  : 8'b0;
endmodule // module rvc_mem_wrap