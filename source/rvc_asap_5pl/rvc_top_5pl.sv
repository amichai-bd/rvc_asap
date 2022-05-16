//-----------------------------------------------------------------------------
// Title            : riscv as-fast-as-possible 
// Project          : rvc_asap
//-----------------------------------------------------------------------------
// File             : rvc_top_5pl 
// Original Author  : Matan Eshel & Gil Ya'akov
// Code Owner       : 
// Adviser          : Amichai Ben-David
// Created          : 03/2022
//-----------------------------------------------------------------------------
// Description :
// This module serves as the top module of the core and the memory.
`include "rvc_asap_macros.sv"

module rvc_top_5pl (
    input logic Clock,
    input logic Rst
);
import rvc_asap_pkg::*;  

//=========================================
//     Core - Memory interface
//=========================================
logic [31:0] Pc;               // I_MEM
logic [31:0] InstructionQ101H; // I_MEM
logic [31:0] RegRdData2;       // D_MEM
logic [31:0] AluOut;           // D_MEM
logic [3:0]  CtrlDMemByteEn;   // D_MEM
logic CtrlDMemWrEn;            // D_MEM
logic SelDMemWb;               // D_MEM
logic CtrlSignExt;             // D_MEM
logic [31:0] DMemRdDataQ104H;  // D_MEM

// Instantiating the rvc_asap_5pl core
rvc_asap_5pl rvc_asap_5pl (
    .Clock                       (Clock),
    .Pc_To_ImemQ100H             (Pc),               // To I_MEM
    .InstructionQ101H            (InstructionQ101H), // From I_MEM
    .RegRdData2_To_DmemQ103H     (RegRdData2),       // To D_MEM
    .AluOut_To_DmemQ103H         (AluOut),           // To D_MEM
    .CtrlDMemByteEn_To_DmemQ103H (CtrlDMemByteEn),   // To D_MEM
    .CtrlDMemWrEn_To_DmemQ103H   (CtrlDMemWrEn),     // To D_MEM
    .SelDMemWb_To_DmemQ103H      (SelDMemWb),        // To D_MEM
    .CtrlSignExt_To_DmemQ103H    (CtrlSignExt),      // To D_MEM
    .DMemRdData_From_DmemQ104H   (DMemRdDataQ104H),  // From D_MEM
    .Rst                         (Rst)
);

// Instantiating the rvc_mem_wrap_5pl memory
rvc_mem_wrap_5pl rvc_mem_wrap_5pl (
    .Clock            (Clock),
    .Pc               (Pc),               // I_MEM
    .InstructionQ101H (InstructionQ101H), // I_MEM
    .RegRdData2       (RegRdData2),       // D_MEM
    .AluOut           (AluOut),           // D_MEM
    .CtrlDMemByteEn   (CtrlDMemByteEn),   // D_MEM
    .CtrlDMemWrEn     (CtrlDMemWrEn),     // D_MEM
    .SelDMemWb        (SelDMemWb),        // D_MEM
    .CtrlSignExt      (CtrlSignExt),      // D_MEM
    .DMemRdDataQ104H  (DMemRdDataQ104H),  // D_MEM
    .Rst              (Rst)
);

endmodule // Module rvc_top_5pl