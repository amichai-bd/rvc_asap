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
parameter VGA_MEM_MSB = 'hc600-1;

// Region bits
parameter LSB_REGION = 12;
parameter MSB_REGION = 13;

// VGA Region bits
parameter VGA_LSB_REGION = 0;
parameter VGA_MSB_REGION = 15;

// Encoded regions
parameter I_MEM_REGION         = 2'b00;
parameter D_MEM_REGION         = 2'b01;
parameter CR_MEM_REGION        = 2'b10;
parameter VGA_MEM_REGION_FLOOR = 16'h3000;
parameter VGA_MEM_REGION_ROOF  = 16'hc600;

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
parameter CR_LED       = 20'h2018 ; // RW 10 bit
parameter CR_Button_0  = 20'h201c ; // RO 1 bit
parameter CR_Button_1  = 20'h2020 ; // RO 1 bit
parameter CR_Switch    = 20'h2024 ; // RO 10 bit
parameter CR_CURSOR_H  = 20'h2028 ; // RW 32 bit
parameter CR_CURSOR_V  = 20'h202c ; // RW 32 bit

// ASCII Table Top
parameter ASCII_TOP_BASE = 20'h2100 ; // RO 32 bit
parameter SPACE_TOP      = 20'h2180 ; // RO 32 bit ASCII_TOP_BASE[0x20]
parameter COMMA_TOP      = 20'h21b0 ; // RO 32 bit ASCII_TOP_BASE[0x2c]
parameter POINT_TOP      = 20'h21b8 ; // RO 32 bit ASCII_TOP_BASE[0x2e]
parameter ZERO_TOP       = 20'h21c0 ; // RO 32 bit ASCII_TOP_BASE[0x30]
parameter ONE_TOP        = 20'h21c4 ; // RO 32 bit ASCII_TOP_BASE[0x31]
parameter TWO_TOP        = 20'h21c8 ; // RO 32 bit ASCII_TOP_BASE[0x32]
parameter THREE_TOP      = 20'h21cc ; // RO 32 bit ASCII_TOP_BASE[0x33]
parameter FOUR_TOP       = 20'h21d0 ; // RO 32 bit ASCII_TOP_BASE[0x34]
parameter FIVE_TOP       = 20'h21d4 ; // RO 32 bit ASCII_TOP_BASE[0x35]
parameter SIX_TOP        = 20'h21d8 ; // RO 32 bit ASCII_TOP_BASE[0x36]
parameter SEVEN_TOP      = 20'h21dc ; // RO 32 bit ASCII_TOP_BASE[0x37]
parameter EIGHT_TOP      = 20'h21e0 ; // RO 32 bit ASCII_TOP_BASE[0x38]
parameter NINE_TOP      = 20'h21e4 ; // RO 32 bit ASCII_TOP_BASE[0x39]
parameter A_TOP          = 20'h2204 ; // RO 32 bit ASCII_TOP_BASE[0x41]
parameter B_TOP          = 20'h2208 ; // RO 32 bit ASCII_TOP_BASE[0x42]
parameter C_TOP          = 20'h220c ; // RO 32 bit ASCII_TOP_BASE[0x43]
parameter D_TOP          = 20'h2210 ; // RO 32 bit ASCII_TOP_BASE[0x44]
parameter E_TOP          = 20'h2214 ; // RO 32 bit ASCII_TOP_BASE[0x45]
parameter F_TOP          = 20'h2218 ; // RO 32 bit ASCII_TOP_BASE[0x46]
parameter G_TOP          = 20'h221c ; // RO 32 bit ASCII_TOP_BASE[0x47]
parameter H_TOP          = 20'h2220 ; // RO 32 bit ASCII_TOP_BASE[0x48]
parameter I_TOP          = 20'h2224 ; // RO 32 bit ASCII_TOP_BASE[0x49]
parameter J_TOP          = 20'h2228 ; // RO 32 bit ASCII_TOP_BASE[0x4a]
parameter K_TOP          = 20'h222c ; // RO 32 bit ASCII_TOP_BASE[0x4b]
parameter L_TOP          = 20'h2230 ; // RO 32 bit ASCII_TOP_BASE[0x4c]
parameter M_TOP          = 20'h2234 ; // RO 32 bit ASCII_TOP_BASE[0x4d]
parameter N_TOP          = 20'h2238 ; // RO 32 bit ASCII_TOP_BASE[0x4e]
parameter O_TOP          = 20'h223c ; // RO 32 bit ASCII_TOP_BASE[0x4f]
parameter P_TOP          = 20'h2240 ; // RO 32 bit ASCII_TOP_BASE[0x50]
parameter Q_TOP          = 20'h2244 ; // RO 32 bit ASCII_TOP_BASE[0x51]
parameter R_TOP          = 20'h2248 ; // RO 32 bit ASCII_TOP_BASE[0x52]
parameter S_TOP          = 20'h224c ; // RO 32 bit ASCII_TOP_BASE[0x53]
parameter T_TOP          = 20'h2250 ; // RO 32 bit ASCII_TOP_BASE[0x54]
parameter U_TOP          = 20'h2254 ; // RO 32 bit ASCII_TOP_BASE[0x55]
parameter V_TOP          = 20'h2258 ; // RO 32 bit ASCII_TOP_BASE[0x56]
parameter W_TOP          = 20'h225c ; // RO 32 bit ASCII_TOP_BASE[0x57]
parameter X_TOP          = 20'h2260 ; // RO 32 bit ASCII_TOP_BASE[0x58]
parameter Y_TOP          = 20'h2264 ; // RO 32 bit ASCII_TOP_BASE[0x59]
parameter Z_TOP          = 20'h2268 ; // RO 32 bit ASCII_TOP_BASE[0x5a]

// ASCII Table Bottom
parameter ASCII_BOTTOM_BASE = 20'h2300 ; // RO 32 bit
parameter SPACE_BOTTOM      = 20'h2380 ; // RO 32 bit ASCII_BOTTOM_BASE[0x20]
parameter COMMA_BOTTOM      = 20'h23B0 ; // RO 32 bit ASCII_BOTTOM_BASE[0x2c]
parameter POINT_BOTTOM      = 20'h23B8 ; // RO 32 bit ASCII_BOTTOM_BASE[0x2e]
parameter ZERO_BOTTOM       = 20'h23c0 ; // RO 32 bit ASCII_BOTTOM_BASE[0x30]
parameter ONE_BOTTOM        = 20'h23c4 ; // RO 32 bit ASCII_BOTTOM_BASE[0x31]
parameter TWO_BOTTOM        = 20'h23c8 ; // RO 32 bit ASCII_BOTTOM_BASE[0x32]
parameter THREE_BOTTOM      = 20'h23cc ; // RO 32 bit ASCII_BOTTOM_BASE[0x33]
parameter FOUR_BOTTOM       = 20'h23d0 ; // RO 32 bit ASCII_BOTTOM_BASE[0x34]
parameter FIVE_BOTTOM       = 20'h23d4 ; // RO 32 bit ASCII_BOTTOM_BASE[0x35]
parameter SIX_BOTTOM        = 20'h23d8 ; // RO 32 bit ASCII_BOTTOM_BASE[0x36]
parameter SEVEN_BOTTOM      = 20'h23dc ; // RO 32 bit ASCII_BOTTOM_BASE[0x37]
parameter EIGHT_BOTTOM      = 20'h23e0 ; // RO 32 bit ASCII_BOTTOM_BASE[0x38]
parameter NINE_BOTTOM       = 20'h23e4 ; // RO 32 bit ASCII_BOTTOM_BASE[0x39]
parameter A_BOTTOM          = 20'h2404 ; // RO 32 bit ASCII_BOTTOM_BASE[0x41]
parameter B_BOTTOM          = 20'h2408 ; // RO 32 bit ASCII_BOTTOM_BASE[0x42]
parameter C_BOTTOM          = 20'h240c ; // RO 32 bit ASCII_BOTTOM_BASE[0x43]
parameter D_BOTTOM          = 20'h2410 ; // RO 32 bit ASCII_BOTTOM_BASE[0x44]
parameter E_BOTTOM          = 20'h2414 ; // RO 32 bit ASCII_BOTTOM_BASE[0x45]
parameter F_BOTTOM          = 20'h2418 ; // RO 32 bit ASCII_BOTTOM_BASE[0x46]
parameter G_BOTTOM          = 20'h241c ; // RO 32 bit ASCII_BOTTOM_BASE[0x47]
parameter H_BOTTOM          = 20'h2420 ; // RO 32 bit ASCII_BOTTOM_BASE[0x48]
parameter I_BOTTOM          = 20'h2424 ; // RO 32 bit ASCII_BOTTOM_BASE[0x49]
parameter J_BOTTOM          = 20'h2428 ; // RO 32 bit ASCII_BOTTOM_BASE[0x4a]
parameter K_BOTTOM          = 20'h242c ; // RO 32 bit ASCII_BOTTOM_BASE[0x4b]
parameter L_BOTTOM          = 20'h2430 ; // RO 32 bit ASCII_BOTTOM_BASE[0x4c]
parameter M_BOTTOM          = 20'h2434 ; // RO 32 bit ASCII_BOTTOM_BASE[0x4d]
parameter N_BOTTOM          = 20'h2438 ; // RO 32 bit ASCII_BOTTOM_BASE[0x4e]
parameter O_BOTTOM          = 20'h243c ; // RO 32 bit ASCII_BOTTOM_BASE[0x4f]
parameter P_BOTTOM          = 20'h2440 ; // RO 32 bit ASCII_BOTTOM_BASE[0x50]
parameter Q_BOTTOM          = 20'h2444 ; // RO 32 bit ASCII_BOTTOM_BASE[0x51]
parameter R_BOTTOM          = 20'h2448 ; // RO 32 bit ASCII_BOTTOM_BASE[0x52]
parameter S_BOTTOM          = 20'h244c ; // RO 32 bit ASCII_BOTTOM_BASE[0x53]
parameter T_BOTTOM          = 20'h2450 ; // RO 32 bit ASCII_BOTTOM_BASE[0x54]
parameter U_BOTTOM          = 20'h2454 ; // RO 32 bit ASCII_BOTTOM_BASE[0x55]
parameter V_BOTTOM          = 20'h2458 ; // RO 32 bit ASCII_BOTTOM_BASE[0x56]
parameter W_BOTTOM          = 20'h245c ; // RO 32 bit ASCII_BOTTOM_BASE[0x57]
parameter X_BOTTOM          = 20'h2460 ; // RO 32 bit ASCII_BOTTOM_BASE[0x58]
parameter Y_BOTTOM          = 20'h2464 ; // RO 32 bit ASCII_BOTTOM_BASE[0x59]
parameter Z_BOTTOM          = 20'h2468 ; // RO 32 bit ASCII_BOTTOM_BASE[0x5a]

// ANIME Table TOP
parameter ANIME_TOP_BASE    = 20'h2500 ; // RO 32 bit
parameter WALK_MAN_TOP_0    = 20'h2504 ; // RO 32 bit
parameter WALK_MAN_TOP_1    = 20'h2508 ; // RO 32 bit
parameter WALK_MAN_TOP_2    = 20'h250c ; // RO 32 bit
parameter WALK_MAN_TOP_3    = 20'h2510 ; // RO 32 bit
parameter WALK_MAN_TOP_4    = 20'h2514 ; // RO 32 bit

// ANIME Table BOTTOM
parameter ANIME_BOTTOM_BASE    = 20'h2600 ; // RO 32 bit
parameter WALK_MAN_BOTTOM_0    = 20'h2604 ; // RO 32 bit
parameter WALK_MAN_BOTTOM_1    = 20'h2608 ; // RO 32 bit
parameter WALK_MAN_BOTTOM_2    = 20'h260c ; // RO 32 bit
parameter WALK_MAN_BOTTOM_3    = 20'h2610 ; // RO 32 bit
parameter WALK_MAN_BOTTOM_4    = 20'h2614 ; // RO 32 bit

typedef struct packed { // RO
    logic       Button_0;
    logic       Button_1;
    logic [9:0] Switch;
} t_cr_ro ;

typedef struct packed { // RW
    logic [7:0]  SEG7_0;
    logic [7:0]  SEG7_1;
    logic [7:0]  SEG7_2;
    logic [7:0]  SEG7_3;
    logic [7:0]  SEG7_4;
    logic [7:0]  SEG7_5;
    logic [9:0]  LED;
    logic [31:0] CR_CURSOR_H;
    logic [31:0] CR_CURSOR_V;
} t_cr_rw ;

endpackage