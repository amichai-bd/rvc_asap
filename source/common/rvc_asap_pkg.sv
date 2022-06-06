//-----------------------------------------------------------------------------
// Title            : riscv as-fast-as-possible 
// Project          : rvc_asap
//-----------------------------------------------------------------------------
// File             : rvc_asap_pkg.sv
// Original Author  : Amichai Ben-David
// Code Owner       : 
// Created          : 11/2021
//-----------------------------------------------------------------------------
// Description :
// enum & parameters for the RVC core
//-----------------------------------------------------------------------------

package rvc_asap_pkg;

parameter I_MEM_MSB   = 'h1000-1; 
parameter D_MEM_MSB   = 'h2000-1;
parameter CR_MEM_MSB  = 'h3000-1;
parameter VGA_MEM_MSB = 'h4000-1;

// Region bits
parameter LSB_REGION = 12;
parameter MSB_REGION = 13;

// Encoded regions
parameter I_MEM_REGION   = 2'b00;
parameter D_MEM_REGION   = 2'b01;
parameter CR_MEM_REGION  = 2'b10;
parameter VGA_MEM_REGION = 2'b11;

typedef enum logic [2:0] {
    U_TYPE = 3'b000 , 
    I_TYPE = 3'b001 ,  
    S_TYPE = 3'b010 ,     
    B_TYPE = 3'b011 , 
    J_TYPE = 3'b100 
} t_immediate ;

typedef enum logic [3:0] {
    ADD  = 4'b0000 ,
    SUB  = 4'b1000 ,
    SLT  = 4'b0010 ,
    SLTU = 4'b0011 ,
    SLL  = 4'b0001 , 
    SRL  = 4'b0101 ,
    SRA  = 4'b1101 ,
    XOR  = 4'b0100 ,
    OR   = 4'b0110 ,
    AND  = 4'b0111
} t_alu_op ;

typedef enum logic [2:0] {
   BEQ  = 3'b000 ,
   BNE  = 3'b001 ,
   BLT  = 3'b100 ,
   BGE  = 3'b101 ,
   BLTU = 3'b110 ,
   BGEU = 3'b111
} t_branch_type ;

typedef enum logic [6:0] {
   LUI    = 7'b0110111 ,
   AUIPC  = 7'b0010111 ,
   JAL    = 7'b1101111 ,
   JALR   = 7'b1100111 ,
   BRANCH = 7'b1100011 ,
   LOAD   = 7'b0000011 ,
   STORE  = 7'b0100011 ,
   I_OP   = 7'b0010011 ,
   R_OP   = 7'b0110011 ,
   FENCE  = 7'b0001111 ,
   SYSCAL = 7'b1110011
} t_opcode ;

parameter NOP = 32'b000000000000000000000000010011; // addi x0 , x0 , 0

// CR Address Offsets
parameter CR_SEG7_0    = 20'h2000 ; // RW 7 bit
parameter CR_SEG7_1    = 20'h2004 ; // RW 7 bit
parameter CR_SEG7_2    = 20'h2008 ; // RW 7 bit
parameter CR_SEG7_3    = 20'h200c ; // RW 7 bit
parameter CR_SEG7_4    = 20'h2010 ; // RW 7 bit
parameter CR_SEG7_5    = 20'h2014 ; // RW 7 bit
parameter CR_LED       = 20'h2018 ; // RW 7 bit
parameter CR_Button_0  = 20'h201c ; // RO 1 bit
parameter CR_Button_1  = 20'h2020 ; // RO 1 bit
parameter CR_Switch    = 20'h2024 ; // RO 10 bit

typedef struct packed { // RO
    logic       Button_0;
    logic       Button_1;
    logic [9:0] Switch;
} t_cr_ro ;

typedef struct packed { // RW
    logic [6:0] SEG7_0;
    logic [6:0] SEG7_1;
    logic [6:0] SEG7_2;
    logic [6:0] SEG7_3;
    logic [6:0] SEG7_4;
    logic [6:0] SEG7_5;
    logic [6:0] LED;
} t_cr_rw ;

endpackage