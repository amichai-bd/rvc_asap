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
// This module serves as the top module of the core, memory and FPGA.
`include "rvc_asap_macros.sv"

module rvc_top_5pl (
    input logic Clock,
    input logic Rst,
    // FPGA interface inputs              
    input  logic       Button_0, // CR_MEM
    input  logic       Button_1, // CR_MEM
    input  logic [9:0] Switch,   // CR_MEM
    // FPGA interface outputs
    output logic [6:0] SEG7_0,   // CR_MEM
    output logic [6:0] SEG7_1,   // CR_MEM
    output logic [6:0] SEG7_2,   // CR_MEM
    output logic [6:0] SEG7_3,   // CR_MEM
    output logic [6:0] SEG7_4,   // CR_MEM
    output logic [6:0] SEG7_5,   // CR_MEM
    output logic [6:0] LED,      // CR_MEM
    // VGA output
    output logic [3:0] RED,
    output logic [3:0] GREEN,
    output logic [3:0] BLUE,
    output logic       h_sync,
    output logic       v_sync
);
import rvc_asap_pkg::*;  

//=========================================
//     Core - Memory interface
//=========================================
logic [31:0] Pc;                  // I_MEM
logic [31:0] PreInstructionQ101H; // I_MEM
logic [31:0] RegRdData2;          // D_MEM
logic [31:0] AluOut;              // D_MEM
logic [3:0]  CtrlDMemByteEn;      // D_MEM
logic CtrlDMemWrEn;               // D_MEM
logic SelDMemWb;                  // D_MEM
logic CtrlSignExt;                // D_MEM
logic [31:0] DMemRdDataQ104H;     // D_MEM

// Instantiating the rvc_asap_5pl core
rvc_asap_5pl rvc_asap_5pl (
    .Clock                       (Clock),
    .Rst                         (Rst),
    .Pc_To_ImemQ100H             (Pc),                  // To I_MEM
    .PreInstructionQ101H         (PreInstructionQ101H), // From I_MEM
    .RegRdData2_To_DmemQ103H     (RegRdData2),          // To D_MEM
    .AluOut_To_DmemQ103H         (AluOut),              // To D_MEM
    .CtrlDMemByteEn_To_DmemQ103H (CtrlDMemByteEn),      // To D_MEM
    .CtrlDMemWrEn_To_DmemQ103H   (CtrlDMemWrEn),        // To D_MEM
    .SelDMemWb_To_DmemQ103H      (SelDMemWb),           // To D_MEM
    .CtrlSignExt_To_DmemQ103H    (CtrlSignExt),         // To D_MEM
    .DMemRdData_From_DmemQ104H   (DMemRdDataQ104H)      // From D_MEM
);

// Instantiating the rvc_asap_5pl_mem_wrap memory
rvc_asap_5pl_mem_wrap rvc_asap_5pl_mem_wrap (
    .Clock            (Clock),
    .Rst              (Rst),
    .Pc               (Pc),                  // I_MEM
    .InstructionQ101H (PreInstructionQ101H), // I_MEM
    .RegRdData2       (RegRdData2),          // D_MEM
    .AluOut           (AluOut),              // D_MEM
    .CtrlDMemByteEn   (CtrlDMemByteEn),      // D_MEM
    .CtrlDMemWrEn     (CtrlDMemWrEn),        // D_MEM
    .SelDMemWb        (SelDMemWb),           // D_MEM
    .CtrlSignExt      (CtrlSignExt),         // D_MEM
    .DMemRdDataQ104H  (DMemRdDataQ104H),     // D_MEM
    .Button_0         (Button_0),            // CR_MEM
    .Button_1         (Button_1),            // CR_MEM
    .Switch           (Switch),              // CR_MEM
    .SEG7_0           (SEG7_0),              // CR_MEM
    .SEG7_1           (SEG7_1),              // CR_MEM
    .SEG7_2           (SEG7_2),              // CR_MEM
    .SEG7_3           (SEG7_3),              // CR_MEM
    .SEG7_4           (SEG7_4),              // CR_MEM
    .SEG7_5           (SEG7_5),              // CR_MEM
    .LED              (LED),                 // CR_MEM
    .RED              (RED),                 // VGA_OUTPUT
    .GREEN            (GREEN),               // VGA_OUTPUT
    .BLUE             (BLUE),                // VGA_OUTPUT
    .h_sync           (h_sync),              // VGA_OUTPUT
    .v_sync           (v_sync)               // VGA_OUTPUT
);

endmodule // Module rvc_top_5pl