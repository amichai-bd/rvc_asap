//-----------------------------------------------------------------------------
// Title            : riscv as-fast-as-possible 
// Project          : rvc_asap
//-----------------------------------------------------------------------------
// File             : rvc_asap_5pl_mem_wrap
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

module rvc_asap_5pl_mem_wrap (
    input  logic Clock,
    input  logic Rst,
    input  logic [31:0] Pc,               // I_MEM
    output logic [31:0] InstructionQ101H, // I_MEM
    input  logic [31:0] data,             // D_MEM
    input  logic [31:0] address,          // D_MEM
    input  logic [3:0]  byteena,          // D_MEM
    input  logic wren,                    // D_MEM
    input  logic rden,                    // D_MEM
    output logic [31:0] q,                // D_MEM
    // FPGA interface inputs              
    input  logic       Button_0,          // CR_MEM
    input  logic       Button_1,          // CR_MEM
    input  logic [9:0] Switch,            // CR_MEM
    // FPGA interface outputs
    output logic [7:0] SEG7_0,            // CR_MEM
    output logic [7:0] SEG7_1,            // CR_MEM
    output logic [7:0] SEG7_2,            // CR_MEM
    output logic [7:0] SEG7_3,            // CR_MEM
    output logic [7:0] SEG7_4,            // CR_MEM
    output logic [7:0] SEG7_5,            // CR_MEM
    output logic [9:0] LED,               // CR_MEM
    // VGA output
    output logic [3:0]  RED,
    output logic [3:0]  GREEN,
    output logic [3:0]  BLUE,
    output logic        h_sync,
    output logic        v_sync
);
import rvc_asap_pkg::*;

// Control signals
logic MatchDMemRegionQ103H, MatchDMemRegionQ104H;
logic MatchCRMemRegionQ103H, MatchCRMemRegionQ104H;
logic MatchVGAMemRegionQ103H, MatchVGAMemRegionQ104H;
logic [31:0] PreDMemRdDataQ104H;
logic [31:0] PreCRMemRdDataQ104H;
logic [31:0] PreVGAMemRdDataQ104H;

always_comb begin
    MatchVGAMemRegionQ103H = ((address[VGA_MSB_REGION:VGA_LSB_REGION] >= VGA_MEM_REGION_FLOOR) && (address[VGA_MSB_REGION:VGA_LSB_REGION] <= VGA_MEM_REGION_ROOF));
    MatchDMemRegionQ103H   = MatchVGAMemRegionQ103H ? 1'b0 : (address[MSB_REGION:LSB_REGION] == D_MEM_REGION);
    MatchCRMemRegionQ103H  = MatchVGAMemRegionQ103H ? 1'b0 : (address[MSB_REGION:LSB_REGION] == CR_MEM_REGION);
end

// Q103H to Q104H Flip Flops
`RVC_MSFF(MatchDMemRegionQ104H   , MatchDMemRegionQ103H    , Clock)
`RVC_MSFF(MatchCRMemRegionQ104H  , MatchCRMemRegionQ103H   , Clock)
`RVC_MSFF(MatchVGAMemRegionQ104H , MatchVGAMemRegionQ103H  , Clock)

// Mux between CR ,data and vga memory
assign q = MatchCRMemRegionQ104H  ? PreCRMemRdDataQ104H  :
           MatchDMemRegionQ104H   ? PreDMemRdDataQ104H   :
           MatchVGAMemRegionQ104H ? PreVGAMemRdDataQ104H :
                                    32'b0                ;
                                                 
// Instantiating the rvc_asap_5pl_i_mem instruction memory
`ifndef SIMULATION_ON // if NOT def
i_mem_4kb rvc_asap_5pl_i_mem (
`else
rvc_asap_5pl_i_mem rvc_asap_5pl_i_mem (
`endif
    .clock          (Clock),
    .address        (Pc[31:2]),
    .q              (InstructionQ101H)
);

// Instantiating the rvc_asap_5pl_d_mem data memory
`ifndef SIMULATION_ON // if NOT def
d_mem_4kb rvc_asap_5pl_d_mem (
`else
rvc_asap_5pl_d_mem rvc_asap_5pl_d_mem (
    .clock          (Clock),
    .data           (data),
    .address        (address[31:2]),
    .byteena        (byteena),
    .wren           (wren && MatchDMemRegionQ103H),
    .rden           (rden && MatchDMemRegionQ103H),
    .q              (PreDMemRdDataQ104H)
);

// Instantiating the rvc_asap_5pl_cr_mem data memory
rvc_asap_5pl_cr_mem rvc_asap_5pl_cr_mem (
    .Clock            (Clock),
    .Rst              (Rst),
    .data             (data),
    .address          (address),
    .wren             (wren && MatchCRMemRegionQ103H),
    .rden             (rden && MatchCRMemRegionQ103H),
    .q                (PreCRMemRdDataQ104H),
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

// Instantiating the rvc_asap_5pl_vga_ctrl
rvc_asap_5pl_vga_ctrl rvc_asap_5pl_vga_ctrl (
    .CLK_50            (Clock),
    .Reset             (Rst),
    .data              (data),
    .address           (address),
    .byteena           (byteena),
    .wren              (wren && MatchVGAMemRegionQ103H),
    .rden              (rden && MatchVGAMemRegionQ103H),
    .q                 (PreVGAMemRdDataQ104H),
    .RED               (RED),
    .GREEN             (GREEN),
    .BLUE              (BLUE),
    .h_sync            (h_sync),
    .v_sync            (v_sync)
);

endmodule // Module rvc_asap_5pl_mem_wrap