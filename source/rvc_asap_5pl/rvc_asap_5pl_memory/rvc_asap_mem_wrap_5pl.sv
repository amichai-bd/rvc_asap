//-----------------------------------------------------------------------------
// Title            : riscv as-fast-as-possible 
// Project          : rvc_asap
//-----------------------------------------------------------------------------
// File             : rvc_asap_mem_wrap_5pl
// Original Author  : Matan Eshel & Gil Ya'akov
// Code Owner       : 
// Adviser          : Amichai Ben-David
// Created          : 03/2022
//-----------------------------------------------------------------------------
// Description :
// This module serves as the memory of the core. This module contains data memory,
// instruction memory and control registers memory.
// I_MEM, D_MEM and CR_MEM will support sync memory read.
`include "rvc_asap_macros.sv"

module rvc_asap_mem_wrap_5pl (
    input  logic Clock,
    input  logic Rst,

    input  logic [31:0] Pc,               // I_MEM
    output logic [31:0] InstructionQ101H, // I_MEM

    input  logic [31:0] RegRdData2,       // D_MEM
    input  logic [31:0] AluOut,           // D_MEM
    input  logic [3:0]  CtrlDMemByteEn,   // D_MEM
    input  logic CtrlDMemWrEn,            // D_MEM
    input  logic SelDMemWb,               // D_MEM
    input  logic CtrlSignExt,             // D_MEM
    output logic [31:0] DMemRdDataQ104H,  // D_MEM

    // FPGA interface inputs              
    input  logic       Button_0,          // CR_MEM
    input  logic       Button_1,          // CR_MEM
    input  logic [9:0] Switch,            // CR_MEM

    // FPGA interface outputs
    output logic [6:0] SEG7_0,            // CR_MEM
    output logic [6:0] SEG7_1,            // CR_MEM
    output logic [6:0] SEG7_2,            // CR_MEM
    output logic [6:0] SEG7_3,            // CR_MEM
    output logic [6:0] SEG7_4,            // CR_MEM
    output logic [6:0] SEG7_5,            // CR_MEM
    output logic [6:0] LED                // CR_MEM
);
import rvc_asap_pkg::*;

// Control signals
logic MatchDMemRegionQ103H, MatchDMemRegionQ104H;
logic MatchCRMemRegionQ103H, MatchCRMemRegionQ104H;
logic [31:0] PreDMemRdDataQ104H;
logic [31:0] PreCRMemRdDataQ104H;

always_comb begin
    MatchDMemRegionQ103H  = (AluOut[MSB_REGION:LSB_REGION] == D_MEM_REGION);
    MatchCRMemRegionQ103H = (AluOut[MSB_REGION:LSB_REGION] == CR_MEM_REGION);
end

// Q103H to Q104H Flip Flops
`RVC_MSFF(MatchDMemRegionQ104H  , MatchDMemRegionQ103H   , Clock)
`RVC_MSFF(MatchCRMemRegionQ104H , MatchCRMemRegionQ103H  , Clock)

// Mux between CR and data memory
assign DMemRdDataQ104H = MatchCRMemRegionQ104H ? PreCRMemRdDataQ104H :
                         MatchDMemRegionQ104H  ? PreDMemRdDataQ104H  :
                                                 32'b0               ;
                                                 
// Instantiating the rvc_asap_5pl_i_mem instruction memory
rvc_asap_5pl_i_mem rvc_asap_5pl_i_mem (
    .Clock            (Clock),
    .Rst              (Rst),
    .Pc               (Pc),
    .InstructionQ101H (InstructionQ101H)
);

// Instantiating the rvc_asap_5pl_d_mem data memory
rvc_asap_5pl_d_mem rvc_asap_5pl_d_mem (
    .Clock            (Clock),
    .Rst              (Rst),
    .RegRdData2       (RegRdData2),
    .AluOut           (AluOut),
    .CtrlDMemByteEn   (CtrlDMemByteEn),
    .CtrlDMemWrEn     (CtrlDMemWrEn && MatchDMemRegionQ103H),
    .SelDMemWb        (SelDMemWb && MatchDMemRegionQ103H),
    .CtrlSignExt      (CtrlSignExt),
    .DMemRdDataQ104H  (PreDMemRdDataQ104H)
);

// Instantiating the rvc_asap_5pl_cr_mem data memory
rvc_asap_5pl_cr_mem rvc_asap_5pl_cr_mem (
    .Clock            (Clock),
    .Rst              (Rst),
    .RegRdData2       (RegRdData2),
    .AluOut           (AluOut),
    .CtrlCRMemWrEn    (CtrlDMemWrEn && MatchCRMemRegionQ103H),
    .SelCRMemWb       (SelDMemWb && MatchCRMemRegionQ103H),
    .CRMemRdDataQ104H (PreCRMemRdDataQ104H),
    .Button_0         (Button_0),
    .Button_1         (Button_1),
    .Switch           (Switch),
    .SEG7_0           (SEG7_0),
    .SEG7_1           (SEG7_1),
    .SEG7_2           (SEG7_2),
    .SEG7_3           (SEG7_3),
    .SEG7_4           (SEG7_4),
    .SEG7_5           (SEG7_5),
    .LED              (LED)
);

endmodule // Module rvc_asap_mem_wrap_5pl