//-----------------------------------------------------------------------------
// Title            : riscv as-fast-as-possible 
// Project          : rvc_asap
//-----------------------------------------------------------------------------
// File             : rvc_asap 
// Original Author  : Amichai Ben-David
// Code Owner       : 
// Adviser          : Amichai Ben-David
// Created          : 10/2021
//-----------------------------------------------------------------------------
// Description :
// This module will comtain a complite RISCV Core supportint the RV32I
// will be implemented in a single cycle fasion.
// the I_MEM & the D_MEM will be support async memory read. (This will allow the single-cycle arch)

`ifndef RVC_ASAP_MACROS
`define RVC_ASAP_MACROS
`define  RVC_MSFF(q,i,clk)             \
         always_ff @(posedge clk)       \
            q<=i;

`define  RVC_EN_MSFF(q,i,clk,en)       \
         always_ff @(posedge clk)       \
            if(en) q<=i;

`define  RVC_RST_MSFF(q,i,clk,rst)     \
         always_ff @(posedge clk) begin \
            if (rst) q <='0;            \
            else     q <= i;            \
         end

`define  RVC_EN_RST_MSFF(q,i,clk,en,rst)\
         always_ff @(posedge clk)       \
            if (rst)    q <='0;         \
            else if(en) q <= i;
`endif //RVC_ASAP_MACROS

`ifndef RVC_ASAP_PKG
`define RVC_ASAP_PKG
typedef enum logic [2:0] {
    U_TYPE   = 3'b000 , 
    I_TYPE   = 3'b001 ,
    S_TYPE   = 3'b010 , 
    B_TYPE   = 3'b011 , 
    J_TYPE   = 3'b100 
} t_immediate ;

typedef enum logic [3:0] {
    ADD   = 4'b0000 ,
    SUB   = 4'b0001 , 
    SLT   = 4'b0010 , 
    SLTU  = 4'b0011 , 
    SLL   = 4'b0100 , 
    SRL   = 4'b0101 , 
    SRA   = 4'b0110 , 
    XOR   = 4'b0111 , 
    OR    = 4'b1000 , 
    AND   = 4'b1001
} t_alu_op ;


typedef enum logic [2:0] {
   BEQ  = 3'b000 ,
   BNE  = 3'b001 , 
   BLT  = 3'b010 , 
   BGE  = 3'b011 , 
   BLTU = 3'b100 , 
   BGEU = 3'b101 , 
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

`endif // RVC_ASAP_PKG
module rvc_asap (
    input logic Clock,
    input logic Rst
);

//Data-Path signals
logic [31:0]        Pc;
logic [31:0]        NextPc;
logic [31:0]        PcPlus4;
logic [31:0]        AluOut;
logic [7:0][1023:0] IMem;
logic [7:0][1023:0] DMem;
logic [31:0]        Instruction;
logic [31:0][31:0]  Register ;
logic [31:0]        U_Immediate;
logic [31:0]        I_Immediate;
logic [31:0]        S_Immediate;
logic [31:0]        B_Immediate;
logic [31:0]        J_Immediate;
logic [4:0] Shamt;
//Ctrl Bits
logic           SelNextPcAluOut;
logic           SelRegWrPc;
t_immediate     SelImmType;
t_alu_op        CtrlAluOp;
t_branch_type   CtrlBranchOp;
t_opcode        Opcode;
//======================
// Instruction fetch
//------------------
// 1. Send the PC ( program counter) to the I_MEM
// 2. Calc/Set the NextPc
//======================
assign PcPlus4 = Pc + 3'h4;
assign NextPc = SelNextPcAluOut ? AluOut : PcPlus4 ; //Mux
`RVC_RST_MSFF(Pc, NextPc, Clock, Rst)

`RVC_MSFF(IMem, IMem, Clock)//FIXME - currently this logic wont allow to update the I_MEM - (Only Backdoor is possible)
// This is the load
assign Instruction[7:0]   = IMem[Pc+0]; // mux - Pc is the selector, IMem is the Data, Instuction is the Out
assign Instruction[15:8]  = IMem[Pc+1];
assign Instruction[23:16] = IMem[Pc+2];
assign Instruction[31:24] = IMem[Pc+3];
//=========================
//  Decode
//--------------------------------
// 1. Get the instruciton from I_MEM and use the "decoder" to set the Ctrl Bits
// 2. Use the rs1 & rs2 (RegSrc) to read the Register file data.
// 3. construct the Immidiate types.
//=================================
//TODO FIXME  - Set a table to to set the ctrl bits:
assign Opcode          =   Instruction[6:0];
assign SelNextPcAluOut = (Opcode == JAL) || (Opcode == JALR) || ((Opcode == BRANCH) && BranchCondMet);
assign SelRegWritePc   =  
assign SelAluPc
assign SelAluImm
assign SelImmType
assign SelDMemWb
assign CtrlAluOp
assign CtrlBranchOp  
assign CtrlRegWrEn
assign CtrlDMemByteEn
assign RegDst = Instruction[11:7];
assign RegSr1 = Instruction[19:15];
assign RegSr2 = Instruction[24:20];
// --- Select what Write to register file --------
assign RegWrData = SelRegWrPc ? PcPlus4 : WrBackData;
//---- The Register File  ------
`RVC_EN_MSFF(Register[RegDst] , RegWrData , Clock , CtrlRegWrEn )
// --- read Register File --------
assign RegRdData1 = Register[RegSrc1];
assign RegRdData2 = Register[RegSrc2];
//  Immediate Generator
always_comb begin
    U_Immediate = { Instruction[31:12]    ,12'b0 } ; 
    I_Immediate = { {20{Instruction[31]}} , Instruction[31:20] }; 
    S_Immediate = { {20{Instruction[31]}} , Instruction[31:25] , Instruction[11:7]  }; 
    B_Immediate = { {20{Instruction[31]}} , Instruction[7]     , Instruction[30:25] , Instruction[11:8]  , 1'b0}; 
    J_Immediate = { {12{Instruction[31]}} , Instruction[19:12] , Instruction[20]    , Instruction[30:21] , 1'b0}; 
    
    unique casez (SelImmType)    //mux
        U_TYPE  :  Immediate = U_Immediate;
        I_TYPE  :  Immediate = I_Immediate;
        S_TYPE  :  Immediate = S_Immediate;
        B_TYPE  :  Immediate = B_Immediate;
        J_TYPE  :  Immediate = J_Immediate;
        defualt :  Immediate = U_Immediate;
    endcase
end
//=============================
// Execute
//------------------------------
// 1. Use the Imm/Registers to compute:
//      a) data to write back to register.
//      b) Calculate address for load/store
//      c) Calculate branch/jump target.
// 2. Check branch condition
assign AluIn1 = SelAluPc  ? Pc          : RegRdData1 ;
assign AluIn2 = SelAluImm ? Immediate   : RegRdData2 ;
always_comb begin : alu_logic
    Shamt      = AluIn2[4:0];
    unique casez (CtrlAluOp) 
        //use adder
        ADD   : AluOut = AluIn1 +   AluIn2                          ;//ADD/LW/SW
        SUB   : AluOut = AluIn1 + (~AluIn2) + 1'b1                  ;//SUB
        SLT   : AluOut = {31'b0, ($signed(AluIn1) < $signed(AluIn2))} ;//SLT
        SLTU  : AluOut = {31'b0 , AluIn1 < AluIn2}                  ;//SLTU
        //shift
        SLL   : AluOut = AluIn1 << Shamt                            ;//SLL
        SRL   : AluOut = AluIn1 >> Shamt                            ;//SRL
        SRA   : AluOut = $signed(AluIn1) >>> Shamt                  ;//SRA
        //bit wise opirations
        XOR   : AluOut = AluIn1 ^ AluIn2                            ;//XOR
        OR    : AluOut = AluIn1 | AluIn2                            ;//OR
        AND   : AluOut = AluIn1 & AluIn2                            ;//AND
        default  : AluOut = 32'b0                                                ;
    endcase
end

always_comb begin : branch_comp
    //for branch condition.
    unique casez ({CtrlBranchOp})
        BEQ     : BranchCondMet =  (AluIn1==AluIn2)                   ;// BEQ
        BNE     : BranchCondMet = ~(AluIn1==AluIn2)                   ;// BNE
        BLT     : BranchCondMet =  ($signed(AluIn1)<$signed(AluIn2))  ;// BLT
        BGE     : BranchCondMet = ~($signed(AluIn1)<$signed(AluIn2))  ;// BGE
        BLTU    : BranchCondMet =  (AluIn1<AluIn2)                    ;// BLTU
        BGEU    : BranchCondMet = ~(AluIn1<AluIn2)                    ;// BGEU
       default  : BranchCondMet = 1'b0                                          ;
    endcase
end
//==============================
// Memory Access
//------------------------------
// aceess D_MEM for Wrote (STORE) and Reads (LOAD)
//==============================
`RVC_EN_MSFF(DMem[AluOut+0] , RegRdData2[7:0]   , Clock , CtrlDMemByteEn[0])
`RVC_EN_MSFF(DMem[AluOut+1] , RegRdData2[15:8]  , Clock , CtrlDMemByteEn[1])
`RVC_EN_MSFF(DMem[AluOut+2] , RegRdData2[23:16] , Clock , CtrlDMemByteEn[2])
`RVC_EN_MSFF(DMem[AluOut+3] , RegRdData2[31:24] , Clock , CtrlDMemByteEn[3])
// This is the load
assign PreDMemRdData[7:0]   =  DMem[AluOut+0]; 
assign PreDMemRdData[15:8]  =  DMem[AluOut+1];
assign PreDMemRdData[23:16] =  DMem[AluOut+2];
assign PreDMemRdData[31:24] =  DMem[AluOut+3];
assign DMemRdData[7:0]      =  CtrlDMemByteEn[0] ? PreDMemRdData[7:0]   : 8'b0;
assign DMemRdData[15:8]     =  CtrlDMemByteEn[1] ? PreDMemRdData[15:8]  :
                               CtrlSignExt       ? {8{DMemRdData[7]}}   : 8'b0;
assign DMemRdData[23:16]    =  CtrlDMemByteEn[2] ? PreDMemRdData[23:16] :
                               CtrlSignExt       ? {8{DMemRdData[15]}}  : 8'b0;
assign DMemRdData[31:24]    =  CtrlDMemByteEn[3] ? PreDMemRdData[31:24] :
                               CtrlSignExt       ? {8{DMemRdData[23]}}  : 8'b0;
//==============================
// Write-Back
//------------------------------
// Select which data should be write backed to the register file
// AluOut vs DMemRdData
//==============================
assign WriteBackData        =  SelDMemWb ? DMemRdData : AluOut;
endmodule 