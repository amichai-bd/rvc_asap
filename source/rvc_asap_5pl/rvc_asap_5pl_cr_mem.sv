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
    input  logic [31:0] RegRdData2,
    input  logic [31:0] AluOut,
    input  logic        CtrlCRMemWrEn,
    input  logic        SelCRMemWb,
    output logic [31:0] CRMemRdDataQ104H,

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
logic [31:0] CRMemRdDataQ103H;

//==============================
// Memory Access
//------------------------------
// 1. Access CR_MEM for Wrote (STORE) and Reads (LOAD)
//==============================
always_comb begin
    cr_ro_next = cr_ro;
    cr_rw_next = cr_rw; 
    if(CtrlCRMemWrEn) begin
        unique casez (AluOut) // AluOut holds the offset
            // ---- RW memory ----
            CR_SEG7_0   : cr_rw_next.SEG7_0         = RegRdData2[7:0];
            CR_SEG7_1   : cr_rw_next.SEG7_1         = RegRdData2[7:0];
            CR_SEG7_2   : cr_rw_next.SEG7_2         = RegRdData2[7:0];
            CR_SEG7_3   : cr_rw_next.SEG7_3         = RegRdData2[7:0];
            CR_SEG7_4   : cr_rw_next.SEG7_4         = RegRdData2[7:0];
            CR_SEG7_5   : cr_rw_next.SEG7_5         = RegRdData2[7:0];
            CR_LED      : cr_rw_next.LED            = RegRdData2[9:0];
            CR_CURSOR_H : cr_rw_next.CR_CURSOR_H    = RegRdData2[31:0];
            CR_CURSOR_V : cr_rw_next.CR_CURSOR_V    = RegRdData2[31:0];
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
    if(SelCRMemWb) begin
        unique casez (AluOut) // AluOut holds the offset
            // ---- RW memory ----
            CR_SEG7_0   : CRMemRdDataQ103H = {24'b0 , cr_rw_next.SEG7_0}   ; 
            CR_SEG7_1   : CRMemRdDataQ103H = {24'b0 , cr_rw_next.SEG7_1}   ;
            CR_SEG7_2   : CRMemRdDataQ103H = {24'b0 , cr_rw_next.SEG7_2}   ;
            CR_SEG7_3   : CRMemRdDataQ103H = {24'b0 , cr_rw_next.SEG7_3}   ;
            CR_SEG7_4   : CRMemRdDataQ103H = {24'b0 , cr_rw_next.SEG7_4}   ;
            CR_SEG7_5   : CRMemRdDataQ103H = {24'b0 , cr_rw_next.SEG7_5}   ;
            CR_LED      : CRMemRdDataQ103H = {22'b0 , cr_rw_next.LED}      ;
            CR_CURSOR_H : CRMemRdDataQ103H = cr_rw_next.CR_CURSOR_H        ;
            CR_CURSOR_V : CRMemRdDataQ103H = cr_rw_next.CR_CURSOR_V        ;
            // ---- RO memory ----
            CR_Button_0 : CRMemRdDataQ103H = {31'b0 , cr_ro_next.Button_0} ;
            CR_Button_1 : CRMemRdDataQ103H = {31'b0 , cr_ro_next.Button_1} ;
            CR_Switch   : CRMemRdDataQ103H = {22'b0 , cr_ro_next.Switch}   ;
            // ---- ASCII Table ----
            SPACE_TOP    : CRMemRdDataQ103H = 32'h0                         ;
            SPACE_BOTTOM : CRMemRdDataQ103H = 32'h0                         ;
            COMMA_TOP    : CRMemRdDataQ103H = 32'h00000000                  ;
            COMMA_BOTTOM : CRMemRdDataQ103H = 32'h061E1818                  ;
            POINT_TOP    : CRMemRdDataQ103H = 32'h00000000                  ;
            POINT_BOTTOM : CRMemRdDataQ103H = 32'h00181800                  ;
            ZERO_TOP     : CRMemRdDataQ103H = 32'h52623C00                  ;
            ZERO_BOTTOM  : CRMemRdDataQ103H = 32'h003C464A                  ;
            ONE_TOP      : CRMemRdDataQ103H = 32'h1A1C1800                  ;
            ONE_BOTTOM   : CRMemRdDataQ103H = 32'h007E1818                  ;
            TWO_TOP      : CRMemRdDataQ103H = 32'h40423C00                  ;
            TWO_BOTTOM   : CRMemRdDataQ103H = 32'h007E023C                  ;
            THREE_TOP    : CRMemRdDataQ103H = 32'h40423C00                  ;
            THREE_BOTTOM : CRMemRdDataQ103H = 32'h003C4238                  ;
            FOUR_TOP     : CRMemRdDataQ103H = 32'h24283000                  ;
            FOUR_BOTTOM  : CRMemRdDataQ103H = 32'h0020207E                  ;
            FIVE_TOP     : CRMemRdDataQ103H = 32'h3E027E00                  ;
            FIVE_BOTTOM  : CRMemRdDataQ103H = 32'h003C4240                  ;
            SIX_TOP      : CRMemRdDataQ103H = 32'h02423C00                  ;
            SIX_BOTTOM   : CRMemRdDataQ103H = 32'h003C423E                  ;
            SEVEN_TOP    : CRMemRdDataQ103H = 32'h30407E00                  ;
            SEVEN_BOTTOM : CRMemRdDataQ103H = 32'h00080808                  ;
            EIGHT_TOP    : CRMemRdDataQ103H = 32'h42423C00                  ;
            EIGHT_BOTTOM : CRMemRdDataQ103H = 32'h003C423C                  ;
            NINE_TOP     : CRMemRdDataQ103H = 32'h42423C00                  ;
            NINE_BOTTOM  : CRMemRdDataQ103H = 32'h003E407C                  ;
            A_TOP        : CRMemRdDataQ103H = 32'h663C1800                  ;
            A_BOTTOM     : CRMemRdDataQ103H = 32'h00667E66                  ;
            B_TOP        : CRMemRdDataQ103H = 32'h3E221E00                  ;
            B_BOTTOM     : CRMemRdDataQ103H = 32'h001E223E                  ;
            C_TOP        : CRMemRdDataQ103H = 32'h023E3C00                  ;
            C_BOTTOM     : CRMemRdDataQ103H = 32'h003C3E02                  ;
            D_TOP        : CRMemRdDataQ103H = 32'h223E1E00                  ;
            D_BOTTOM     : CRMemRdDataQ103H = 32'h001E3E22                  ;
            E_TOP        : CRMemRdDataQ103H = 32'h06067E00                  ;
            E_BOTTOM     : CRMemRdDataQ103H = 32'h007E067E                  ;
            F_TOP        : CRMemRdDataQ103H = 32'h06067E00                  ;
            F_BOTTOM     : CRMemRdDataQ103H = 32'h0006067E                  ;
            G_TOP        : CRMemRdDataQ103H = 32'h023E3C00                  ;
            G_BOTTOM     : CRMemRdDataQ103H = 32'h003C223A                  ;
            H_TOP        : CRMemRdDataQ103H = 32'h66666600                  ;
            H_BOTTOM     : CRMemRdDataQ103H = 32'h0066667E                  ;
            I_TOP        : CRMemRdDataQ103H = 32'h18187E00                  ;
            I_BOTTOM     : CRMemRdDataQ103H = 32'h007E1818                  ;
            J_TOP        : CRMemRdDataQ103H = 32'h60606000                  ;
            J_BOTTOM     : CRMemRdDataQ103H = 32'h007C6666                  ;
            K_TOP        : CRMemRdDataQ103H = 32'h3E664600                  ;
            K_BOTTOM     : CRMemRdDataQ103H = 32'h0046663E                  ;
            L_TOP        : CRMemRdDataQ103H = 32'h06060600                  ;
            L_BOTTOM     : CRMemRdDataQ103H = 32'h007E0606                  ;
            M_TOP        : CRMemRdDataQ103H = 32'h5A664200                  ;
            M_BOTTOM     : CRMemRdDataQ103H = 32'h0042425A                  ;
            N_TOP        : CRMemRdDataQ103H = 32'h6E666200                  ;
            N_BOTTOM     : CRMemRdDataQ103H = 32'h00466676                  ;
            O_TOP        : CRMemRdDataQ103H = 32'h66663C00                  ;
            O_BOTTOM     : CRMemRdDataQ103H = 32'h003C6666                  ;
            P_TOP        : CRMemRdDataQ103H = 32'h66663E00                  ;
            P_BOTTOM     : CRMemRdDataQ103H = 32'h0006063E                  ;
            Q_TOP        : CRMemRdDataQ103H = 32'h42423C00                  ;
            Q_BOTTOM     : CRMemRdDataQ103H = 32'h007C6252                  ;
            R_TOP        : CRMemRdDataQ103H = 32'h66663E00                  ;
            R_BOTTOM     : CRMemRdDataQ103H = 32'h0066663E                  ;
            S_TOP        : CRMemRdDataQ103H = 32'h1E067C00                  ;
            S_BOTTOM     : CRMemRdDataQ103H = 32'h003E6078                  ;
            T_TOP        : CRMemRdDataQ103H = 32'h18187E00                  ;
            T_BOTTOM     : CRMemRdDataQ103H = 32'h00181818                  ;
            U_TOP        : CRMemRdDataQ103H = 32'h66666600                  ;
            U_BOTTOM     : CRMemRdDataQ103H = 32'h003C7E66                  ;
            V_TOP        : CRMemRdDataQ103H = 32'h66666600                  ;
            V_BOTTOM     : CRMemRdDataQ103H = 32'h00183C66                  ;
            W_TOP        : CRMemRdDataQ103H = 32'h42424200                  ;
            W_BOTTOM     : CRMemRdDataQ103H = 32'h00427E5A                  ;
            X_TOP        : CRMemRdDataQ103H = 32'h3C666600                  ;
            X_BOTTOM     : CRMemRdDataQ103H = 32'h0066663C                  ;
            Y_TOP        : CRMemRdDataQ103H = 32'h3C666600                  ;
            Y_BOTTOM     : CRMemRdDataQ103H = 32'h00181818                  ;
            Z_TOP        : CRMemRdDataQ103H = 32'h10207E00                  ;
            Z_BOTTOM     : CRMemRdDataQ103H = 32'h007E0408                  ;
            WALK_MAN_TOP_0    : CRMemRdDataQ103H = 32'h7c381030             ;
            WALK_MAN_BOTTOM_0 : CRMemRdDataQ103H = 32'h828448ba             ;
            WALK_MAN_TOP_1    : CRMemRdDataQ103H = 32'h38381030             ;
            WALK_MAN_BOTTOM_1 : CRMemRdDataQ103H = 32'h4448ac78             ;
            WALK_MAN_TOP_2    : CRMemRdDataQ103H = 32'h38381030             ;
            WALK_MAN_BOTTOM_2 : CRMemRdDataQ103H = 32'h10282878             ;
            WALK_MAN_TOP_3    : CRMemRdDataQ103H = 32'h7c381030             ;
            WALK_MAN_BOTTOM_3 : CRMemRdDataQ103H = 32'h281038ba             ;
            WALK_MAN_TOP_4    : CRMemRdDataQ103H = 32'h38381030             ;
            WALK_MAN_BOTTOM_4 : CRMemRdDataQ103H = 32'h4848387c             ;
            default      : CRMemRdDataQ103H = 32'b0                         ;
        endcase
    end
end

// Sample the data load - synchorus load
`RVC_MSFF(CRMemRdDataQ104H, CRMemRdDataQ103H, Clock)

// Reflects outputs to the FPGA - synchorus reflects
`RVC_MSFF(SEG7_0 , cr_rw_next.SEG7_0 , Clock)
`RVC_MSFF(SEG7_1 , cr_rw_next.SEG7_1 , Clock)
`RVC_MSFF(SEG7_2 , cr_rw_next.SEG7_2 , Clock)
`RVC_MSFF(SEG7_3 , cr_rw_next.SEG7_3 , Clock)
`RVC_MSFF(SEG7_4 , cr_rw_next.SEG7_4 , Clock)
`RVC_MSFF(SEG7_5 , cr_rw_next.SEG7_5 , Clock)
`RVC_MSFF(LED    , cr_rw_next.LED    , Clock)

endmodule // Module rvc_asap_5pl_cr_mem