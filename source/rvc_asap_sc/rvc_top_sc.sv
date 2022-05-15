//-----------------------------------------------------------------------------
// Title            : riscv as-fast-as-possible 
// Project          : rvc_asap_sc
//-----------------------------------------------------------------------------
// File             : rvc_top 
// Original Author  : Matan Eshel & Gil Ya'akov
// Code Owner       : 
// Adviser          : Amichai Ben-David
// Created          : 03/2022
//-----------------------------------------------------------------------------
// Description :
// This module serves as the top module of the core and the memory.
`include "rvc_asap_macros.sv"

module rvc_top_sc (
    input logic Clock,
    input logic Rst
);
import rvc_asap_pkg::*;  

//=========================================
//     Core - Memory interface
//=========================================
logic [31:0] Pc;             // I_MEM
logic [31:0] Instruction;    // I_MEM
logic [31:0] RegRdData2;     // D_MEM
logic [31:0] AluOut;         // D_MEM
logic [3:0]  CtrlDMemByteEn; // D_MEM
logic CtrlDMemWrEn;          // D_MEM
logic SelDMemWb;             // D_MEM
logic CtrlSignExt;           // D_MEM
logic [31:0] DMemRdData;     // D_MEM

// Instantiating the rvc_asap core
rvc_asap_sc rvc_asap_sc (
    .Clock                  (Clock),
    .Pc_To_Imem             (Pc),             // To I_MEM
    .Instruction_From_Imem  (Instruction),    // From I_MEM
    .RegRdData2_To_Dmem     (RegRdData2),     // To D_MEM
    .AluOut_To_Dmem         (AluOut),         // To D_MEM
    .CtrlDMemByteEn_To_Dmem (CtrlDMemByteEn), // To D_MEM
    .CtrlDMemWrEn_To_Dmem   (CtrlDMemWrEn),   // To D_MEM
    .SelDMemWb_To_Dmem      (SelDMemWb),      // To D_MEM
    .CtrlSignExt_To_Dmem    (CtrlSignExt),    // To D_MEM
    .DMemRdData_From_Dmem   (DMemRdData),     // From D_MEM
    .Rst                    (Rst)
);

// Instantiating the rvc_mem_wrap memory
rvc_mem_wrap_sc rvc_mem_wrap_sc (
    .Clock          (Clock),
    .Pc             (Pc),             // I_MEM
    .Instruction    (Instruction),    // I_MEM
    .RegRdData2     (RegRdData2),     // D_MEM
    .AluOut         (AluOut),         // D_MEM
    .CtrlDMemByteEn (CtrlDMemByteEn), // D_MEM
    .CtrlDMemWrEn   (CtrlDMemWrEn),   // D_MEM
    .SelDMemWb      (SelDMemWb),      // D_MEM
    .CtrlSignExt    (CtrlSignExt),    // D_MEM
    .DMemRdData     (DMemRdData),     // D_MEM
    .Rst            (Rst)
);

endmodule // module rvc_top_sc