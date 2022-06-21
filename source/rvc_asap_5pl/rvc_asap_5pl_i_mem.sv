//-----------------------------------------------------------------------------
// Title            : riscv as-fast-as-possible 
// Project          : rvc_asap
//-----------------------------------------------------------------------------
// File             : rvc_asap_5pl_i_mem
// Original Author  : Matan Eshel & Gil Ya'akov
// Code Owner       : 
// Adviser          : Amichai Ben-David
// Created          : 03/2022
//-----------------------------------------------------------------------------
// Description :
// This module serves as the instruction memory of the core.
// The I_MEM will support sync memory read.
`include "rvc_asap_macros.sv"

module rvc_asap_5pl_i_mem (
    input  logic clock,
    input  logic [31:0] address,
    output logic [31:0] q
);
import rvc_asap_pkg::*;  
// Memory array (behavrial - not for FPGA/ASIC)
logic [7:0]         IMem [I_MEM_MSB:0];

// Data-Path signals
logic [31:0]        InstructionQ100H;

// Note: This memory is writtin in behavrial way for simulation - for FPGA/ASIC should be replaced with SRAM/RF/LATCH based memory etc.
// FIXME - currently this logic wont allow to load the I_MEM from HW interface - for simulation we will use Backdoor. (force with XMR)
`RVC_MSFF(IMem, IMem, clock)
// This is the instruction fetch. (input pc, output Instruction)
assign InstructionQ100H[7:0]   = IMem[address+0]; // mux - address is the selector, IMem is the Data, Instuction is the Out
assign InstructionQ100H[15:8]  = IMem[address+1];
assign InstructionQ100H[23:16] = IMem[address+2];
assign InstructionQ100H[31:24] = IMem[address+3];

// Sample the instruction read - synchorus read
`RVC_MSFF(q, InstructionQ100H, clock)

endmodule // Module rvc_asap_5pl_i_mem