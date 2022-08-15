//-----------------------------------------------------------------------------
// Title            : riscv as-fast-as-possible 
// Project          : rvc_asap
//-----------------------------------------------------------------------------
// File             : rvc_asap_5pl_vga_mem
// Original Author  : Matan Eshel & Gil Ya'akov
// Code Owner       : 
// Adviser          : Amichai Ben-David
// Created          : 06/2022
//-----------------------------------------------------------------------------
// Description :
// This module serves as the vga memory of the core.
// VGA_MEM will support sync memory read.
`include "rvc_asap_macros.sv"

module rvc_asap_5pl_vga_mem (
    input  logic        clock_a,
    input  logic        clock_b,
    // Write core
    input  logic [31:0] data_a,
    input  logic [13:2] address_a,
    input  logic [3:0]  byteena_a,
    input  logic        wren_a,
    // Read core
    input  logic        rden_a,
    output logic [31:0] q_a,
    // Read vga controller
    input  logic [13:0] address_b,
    output logic [31:0] q_b
);
import rvc_asap_pkg::*;
// Memory array (behavrial - not for FPGA/ASIC)
logic [7:0]  VGAMem     [SIZE_VGA_MEM-1:0];
logic [7:0]  NextVGAMem [SIZE_VGA_MEM-1:0];

// Data-Path signals core
logic [31:0] pre_q_core;

// Data-Path signals vga ctrl
logic [7:0]  RdByte0;
logic [7:0]  RdByte1;
logic [7:0]  RdByte2;
logic [7:0]  RdByte3;
logic [31:0] pre_q_vga;
logic [15:0] RdAddressByteAl;
logic [31:0] address_aligned;
assign address_aligned = {address_a,2'b00};
assign RdAddressByteAl = {address_b,2'b00}; // The memory is "32bit aligned" but we save and measure the memory in Bytes.
                                            // This is to make this model behave as the FPGA Memory we use.

//==============================
// Memory Access
//------------------------------
// 1. Access VGA_MEM for Wrote (STORE) and Reads (LOAD)
//==============================
always_comb begin
    NextVGAMem = VGAMem;
    if(wren_a) begin
        if(byteena_a[0]) NextVGAMem[address_aligned[15:0]+0] = data_a[7:0];
        if(byteena_a[1]) NextVGAMem[address_aligned[15:0]+1] = data_a[15:8];
        if(byteena_a[2]) NextVGAMem[address_aligned[15:0]+2] = data_a[23:16];
        if(byteena_a[3]) NextVGAMem[address_aligned[15:0]+3] = data_a[31:24];
    end
end

`RVC_MSFF(VGAMem , NextVGAMem , clock_a)

// This is the read from the core

assign pre_q_core = rden_a ? {VGAMem[address_aligned+3], VGAMem[address_aligned+2], VGAMem[address_aligned+1], VGAMem[address_aligned+0]} : '0;

// Sample the data load - synchorus load
`RVC_MSFF(q_a, pre_q_core, clock_a)

// This is the read from the vga controller
assign RdByte0 = VGAMem[RdAddressByteAl+0];
assign RdByte1 = VGAMem[RdAddressByteAl+1];
assign RdByte2 = VGAMem[RdAddressByteAl+2];
assign RdByte3 = VGAMem[RdAddressByteAl+3];
assign pre_q_vga   = {RdByte3, RdByte2, RdByte1, RdByte0};

// sample the read - synchorus read
`RVC_MSFF(q_b, pre_q_vga, clock_b)

endmodule // Module rvc_asap_5pl_vga_mem