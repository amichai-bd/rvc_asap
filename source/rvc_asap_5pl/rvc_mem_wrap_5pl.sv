//-----------------------------------------------------------------------------
// Title            : riscv as-fast-as-possible 
// Project          : rvc_asap
//-----------------------------------------------------------------------------
// File             : rvc_mem_wrap_5pl
// Original Author  : Matan Eshel & Gil Ya'akov
// Code Owner       : 
// Adviser          : Amichai Ben-David
// Created          : 03/2022
//-----------------------------------------------------------------------------
// Description :
// This module serves as the memory of the core. This module contains both data memory and
// instruction memory. The I_MEM & D_MEM will support async memory read.
`include "rvc_asap_macros.sv"

module rvc_mem_wrap_5pl (
    input  logic Clock,
    input  logic [31:0] Pc,               // I_MEM
    output logic [31:0] InstructionQ101H, // I_MEM
    input  logic [31:0] RegRdData2,       // D_MEM
    input  logic [31:0] AluOut,           // D_MEM
    input  logic [3:0]  CtrlDMemByteEn,   // D_MEM
    input  logic CtrlDMemWrEn,            // D_MEM
    input  logic SelDMemWb,               // D_MEM
    input  logic CtrlSignExt,             // D_MEM
    output logic [31:0] DMemRdDataQ104H,  // D_MEM
    input  logic Rst
);
import rvc_asap_pkg::*;  
// Memory array (behavrial - not for FPGA/ASIC)
logic [7:0]         IMem [I_MEM_MSB:0];
logic [7:0]         DMem [D_MEM_MSB:I_MEM_MSB+1];
logic [7:0]         NextDMem [D_MEM_MSB:I_MEM_MSB+1];

// Data-Path signals
logic [31:0]        PreDMemRdData;
logic [31:0]        InstructionQ100H;
logic [31:0]        DMemRdDataQ103H;

// Note: This memory is writtin in behavrial way for simulation - for FPGA/ASIC should be replaced with SRAM/RF/LATCH based memory etc.
// FIXME - currently this logic wont allow to load the I_MEM from HW interface - for simulation we will use Backdoor. (force with XMR)
`RVC_MSFF(IMem, IMem, Clock)
// This is the instruction fetch. (input pc, output Instruction)
assign InstructionQ100H[7:0]   = IMem[Pc+0]; // mux - Pc is the selector, IMem is the Data, Instuction is the Out
assign InstructionQ100H[15:8]  = IMem[Pc+1];
assign InstructionQ100H[23:16] = IMem[Pc+2];
assign InstructionQ100H[31:24] = IMem[Pc+3];

// Sample the instruction read - synchorus read
`RVC_MSFF(InstructionQ101H, InstructionQ100H, Clock)
//==============================
// Memory Access
//------------------------------
// 1. Access D_MEM for Wrote (STORE) and Reads (LOAD)
//==============================
// Note: This memory is writtin in behavrial way for simulation - for FPGA/ASIC should be replaced with SRAM/RF/LATCH based memory etc.
//`RVC_EN_MSFF(DMem[AluOut+0] , RegRdData2[7:0]   , Clock , (CtrlDMemWrEn && CtrlDMemByteEn[0]))
//`RVC_EN_MSFF(DMem[AluOut+1] , RegRdData2[15:8]  , Clock , (CtrlDMemWrEn && CtrlDMemByteEn[1]))
//`RVC_EN_MSFF(DMem[AluOut+2] , RegRdData2[23:16] , Clock , (CtrlDMemWrEn && CtrlDMemByteEn[2]))
//`RVC_EN_MSFF(DMem[AluOut+3] , RegRdData2[31:24] , Clock , (CtrlDMemWrEn && CtrlDMemByteEn[3]))
always_comb begin
    NextDMem = DMem;
    for(int i = I_MEM_MSB+1 ; i<D_MEM_MSB+1; i=i+4) begin
        if(AluOut+0 == i) begin
            if(CtrlDMemWrEn && CtrlDMemByteEn[0]) NextDMem[i]   = RegRdData2[7:0];
            if(CtrlDMemWrEn && CtrlDMemByteEn[1]) NextDMem[i+1] = RegRdData2[15:8] ;
            if(CtrlDMemWrEn && CtrlDMemByteEn[2]) NextDMem[i+2] = RegRdData2[23:16];
            if(CtrlDMemWrEn && CtrlDMemByteEn[3]) NextDMem[i+3] = RegRdData2[31:24];
        end
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
endmodule // Module rvc_mem_wrap_5pl