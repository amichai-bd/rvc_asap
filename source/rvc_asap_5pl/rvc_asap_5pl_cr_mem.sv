//-----------------------------------------------------------------------------
// Title            : riscv as-fast-as-possible 
// Project          : rvc_asap
//-----------------------------------------------------------------------------
// File             : rvc_asap_5pl_cr_mem
// Original Author  : Gil Ya'akov
// Code Owner       : 
// Adviser          : Amichai Ben-David
// Created          : 06/2022
//-----------------------------------------------------------------------------
// Description :
// This module serves as the CR (Control Register) memory of the core.
// CR_MEM will support sync memory read and write.
`include "rvc_asap_macros.sv"

module rvc_asap_5pl_cr_mem (
    input  logic       Clock,
    input  logic       Rst,

    // Core interface
    input  logic [31:0] data,
    input  logic [31:0] address,
    input  logic        wren,
    input  logic        rden,
    output logic [31:0] q,

    // FPGA interface inputs
    input  logic       Button_0,
    input  logic       Button_1,
    input  logic [9:0] Switch,

    // FPGA interface outputs
    output logic [7:0] SEG7_0,
    output logic [7:0] SEG7_1,
    output logic [7:0] SEG7_2,
    output logic [7:0] SEG7_3,
    output logic [7:0] SEG7_4,
    output logic [7:0] SEG7_5,
    output logic [9:0] LED
);
import rvc_asap_pkg::*;

// Memory CR objects (behavrial - not for FPGA/ASIC)
t_cr_ro cr_ro;
t_cr_rw cr_rw;
t_cr_ro cr_ro_next;
t_cr_rw cr_rw_next;

// Data-Path signals
logic [31:0] pre_q;

//==============================
// Memory Access
//------------------------------
// 1. Access CR_MEM for Wrote (STORE) and Reads (LOAD)
//==============================
always_comb begin
    cr_ro_next = cr_ro;
    cr_rw_next = cr_rw; 
    if(wren) begin
        unique casez (address) // address holds the offset
            // ---- RW memory ----
            CR_SEG7_0   : cr_rw_next.SEG7_0         = data[7:0];
            CR_SEG7_1   : cr_rw_next.SEG7_1         = data[7:0];
            CR_SEG7_2   : cr_rw_next.SEG7_2         = data[7:0];
            CR_SEG7_3   : cr_rw_next.SEG7_3         = data[7:0];
            CR_SEG7_4   : cr_rw_next.SEG7_4         = data[7:0];
            CR_SEG7_5   : cr_rw_next.SEG7_5         = data[7:0];
            CR_LED      : cr_rw_next.LED            = data[9:0];
            CR_CURSOR_H : cr_rw_next.CR_CURSOR_H    = data[31:0];
            CR_CURSOR_V : cr_rw_next.CR_CURSOR_V    = data[31:0];
            // ---- Other ----
            default   : /* Do nothing */;
        endcase
    end
    // ---- RO memory - writes from FPGA ----
    cr_ro_next.Button_0 = Button_0;
    cr_ro_next.Button_1 = Button_1;
    cr_ro_next.Switch   = Switch;
end

`RVC_MSFF(cr_rw, cr_rw_next, Clock)
`RVC_MSFF(cr_ro, cr_ro_next, Clock)

// This is the load
always_comb begin
    if(rden) begin
        unique casez (address) // address holds the offset
            // ---- RW memory ----
            CR_SEG7_0   : pre_q = {24'b0 , cr_rw_next.SEG7_0}   ; 
            CR_SEG7_1   : pre_q = {24'b0 , cr_rw_next.SEG7_1}   ;
            CR_SEG7_2   : pre_q = {24'b0 , cr_rw_next.SEG7_2}   ;
            CR_SEG7_3   : pre_q = {24'b0 , cr_rw_next.SEG7_3}   ;
            CR_SEG7_4   : pre_q = {24'b0 , cr_rw_next.SEG7_4}   ;
            CR_SEG7_5   : pre_q = {24'b0 , cr_rw_next.SEG7_5}   ;
            CR_LED      : pre_q = {22'b0 , cr_rw_next.LED}      ;
            CR_CURSOR_H : pre_q = cr_rw_next.CR_CURSOR_H        ;
            CR_CURSOR_V : pre_q = cr_rw_next.CR_CURSOR_V        ;
            // ---- RO memory ----
            CR_Button_0 : pre_q = {31'b0 , cr_ro_next.Button_0} ;
            CR_Button_1 : pre_q = {31'b0 , cr_ro_next.Button_1} ;
            CR_Switch   : pre_q = {22'b0 , cr_ro_next.Switch}   ;
            default     : pre_q = 32'b0                         ;
        endcase
    end
end

// Sample the data load - synchorus load
`RVC_MSFF(q, pre_q, Clock)

// Reflects outputs to the FPGA - synchorus reflects
`RVC_MSFF(SEG7_0 , cr_rw_next.SEG7_0 , Clock)
`RVC_MSFF(SEG7_1 , cr_rw_next.SEG7_1 , Clock)
`RVC_MSFF(SEG7_2 , cr_rw_next.SEG7_2 , Clock)
`RVC_MSFF(SEG7_3 , cr_rw_next.SEG7_3 , Clock)
`RVC_MSFF(SEG7_4 , cr_rw_next.SEG7_4 , Clock)
`RVC_MSFF(SEG7_5 , cr_rw_next.SEG7_5 , Clock)
`RVC_MSFF(LED    , cr_rw_next.LED    , Clock)

endmodule // Module rvc_asap_5pl_cr_mem