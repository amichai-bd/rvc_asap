//-----------------------------------------------------------------------------
// Title            : riscv as-fast-as-possible 
// Project          : rvc_asap
//-----------------------------------------------------------------------------
// File             : rvc_asap_5pl 
// Original Author  : Amichai Ben-David
// Code Owner       : 
// Adviser          : Amichai Ben-David
// Created          : 10/2021
//-----------------------------------------------------------------------------
// Description :
// This module will comtain a complite RISCV Core supportint the RV32I
// Will be implemented in a single cycle microarchitecture.
// The I_MEM & D_MEM will support async memory read. (This will allow the single-cycle arch)
// ---- 5 Pipeline Stages -----
// 1) Q100H Instruction Fetch
// 2) Q101H Instruction Decode 
// 3) Q102H Execute 
// 4) Q103H Memory Access
// 5) Q104H Write back data from Memory/ALU to Registerfile

`include "rvc_asap_macros.sv"

module rvc_asap_5pl (
    input  logic Clock,
    input  logic Rst,
    // Instruction Memory
    output logic [31:0] Pc_To_ImemQ100H,     // To I_MEM
    input  logic [31:0] PreInstructionQ101H, // From I_MEM
    // Data Memory
    output logic [31:0] data,                // To D_MEM
    output logic [31:0] address,             // To D_MEM
    output logic [3:0]  byteena,             // To D_MEM
    output logic wren,                       // To D_MEM
    output logic rden,                       // To D_MEM
    input  logic [31:0] q                    // From D_MEM
);
import rvc_asap_pkg::*;
// ---- Data-Path signals ----
// Program counter
logic [31:0]        PcQ100H, PcQ101H, PcQ102H;
logic [31:0]        PcPlus4Q100H, PcPlus4Q101H, PcPlus4Q102H, PcPlus4Q103H, PcPlus4Q104H;
logic [31:0]        NextPcQ102H;
logic [31:0]        InstructionQ101H;

logic [31:1][31:0]  Register; 
logic [31:0]        ImmediateQ101H, ImmediateQ102H;
logic [4:0]         ShamtQ102H;
logic [31:0]        AluIn1Q102H;
logic [31:0]        AluIn2Q102H;
logic [31:0]        AluOutQ102H, AluOutQ103H, AluOutQ104H;
logic [31:0]        RegRdData1Q101H, PreRegRdData1Q102H, RegRdData1Q102H, RegRdData1Q103H;
logic [31:0]        RegRdData2Q101H, PreRegRdData2Q102H, RegRdData2Q102H, RegRdData2Q103H;
logic [31:0]        RegWrDataQ104H; 
logic [31:0]        WrBackDataQ104H;
logic [31:0]        PostDMemRdData_From_DmemQ104H;

// Control bits
logic               SelNextPcAluOutJQ101H, SelNextPcAluOutJQ102H;
logic               SelNextPcAluOutBQ101H, SelNextPcAluOutBQ102H;
logic               SelNextPcAluOutQ102H;
logic               SelRegWrPcQ101H, SelRegWrPcQ102H, SelRegWrPcQ103H, SelRegWrPcQ104H;
logic               BranchCondMetQ102H;
logic               SelDMemWbQ101H, SelDMemWbQ102H, SelDMemWbQ103H, SelDMemWbQ104H;
logic [2:0]         Funct3Q101H;
logic [6:0]         Funct7Q101H;
logic [4:0]         PreRegSrc1Q101H, RegSrc1Q101H, RegSrc1Q102H; 
logic [4:0]         PreRegSrc2Q101H, RegSrc2Q101H, RegSrc2Q102H;
logic [4:0]         RegDstQ101H, RegDstQ102H, RegDstQ103H, RegDstQ104H;
logic [3:0]         CtrlDMemByteEnQ101H, CtrlDMemByteEnQ102H, CtrlDMemByteEnQ103H, CtrlDMemByteEnQ104H;
logic               CtrlDMemWrEnQ101H, CtrlDMemWrEnQ102H, CtrlDMemWrEnQ103H;
logic               CtrlSignExtQ101H, CtrlSignExtQ102H, CtrlSignExtQ103H, CtrlSignExtQ104H;
logic               CtrlLuiQ101H, CtrlLuiQ102H;
logic               CtrlRegWrEnQ101H, CtrlRegWrEnQ102H, CtrlRegWrEnQ103H, CtrlRegWrEnQ104H;
logic               SelAluPcQ101H, SelAluPcQ102H;
logic               SelAluImmQ101H, SelAluImmQ102H;

// Hazard unit detection ctrl
logic               PcEnQ101H;
logic [31:0]        PreviousInstructionQ101H;
logic               LoadHzrdDetectQ101H, LoadHzrdDetectQ102H;
// End hazard unit detection ctrl

// For fetch and decode stages flush
logic               flushQ102H, flushQ103H;

t_immediate         SelImmTypeQ101H;
t_alu_op            CtrlAluOpQ101H, CtrlAluOpQ102H;
t_branch_type       CtrlBranchOpQ101H, CtrlBranchOpQ102H;
t_opcode            OpcodeQ101H, OpcodeQ102H;

//////////////////////////////////////////////////////////////////////////////////////////////////
//   _____  __     __   _____   _        ______          ____    __    ___     ___    _    _ 
//  / ____| \ \   / /  / ____| | |      |  ____|        / __ \  /_ |  / _ \   / _ \  | |  | |
// | |       \ \_/ /  | |      | |      | |__          | |  | |  | | | | | | | | | | | |__| |
// | |        \   /   | |      | |      |  __|         | |  | |  | | | | | | | | | | |  __  |
// | |____     | |    | |____  | |____  | |____        | |__| |  | | | |_| | | |_| | | |  | |
//  \_____|    |_|     \_____| |______| |______|        \___\_\  |_|  \___/   \___/  |_|  |_|
//
//////////////////////////////////////////////////////////////////////////////////////////////////
// Instruction fetch
// -----------------
// 1. Send the PC (program counter) to the I_MEM
// 2. Calc/Set the NextPc
// -----------------
//////////////////////////////////////////////////////////////////////////////////////////////////

assign Pc_To_ImemQ100H  = PcQ100H;
assign PcPlus4Q100H     = PcQ100H + 3'h4;
`RVC_EN_RST_MSFF(PcQ100H, NextPcQ102H, Clock, PcEnQ101H, Rst)

// Q100H to Q101H Flip Flops. 
`RVC_EN_MSFF(PcQ101H, PcQ100H, Clock, PcEnQ101H)
`RVC_EN_MSFF(PcPlus4Q101H, PcPlus4Q100H, Clock, PcEnQ101H)

//////////////////////////////////////////////////////////////////////////////////////////////////
//   _____  __     __   _____   _        ______          ____    __    ___    __   _    _ 
//  / ____| \ \   / /  / ____| | |      |  ____|        / __ \  /_ |  / _ \  /_ | | |  | |
// | |       \ \_/ /  | |      | |      | |__          | |  | |  | | | | | |  | | | |__| |
// | |        \   /   | |      | |      |  __|         | |  | |  | | | | | |  | | |  __  |
// | |____     | |    | |____  | |____  | |____        | |__| |  | | | |_| |  | | | |  | |
//  \_____|    |_|     \_____| |______| |______|        \___\_\  |_|  \___/   |_| |_|  |_|
//
//////////////////////////////////////////////////////////////////////////////////////////////////
// Decode
// -----------------
// 1. Load hazard detection.
// 2. Get the instruciton from I_MEM and use the decoder to set the Ctrl Bits.
// 3. Use the rs1 & rs2 (RegSrc) to read the Register file data.
// 4. construct the Immediate types.
// ----------------- 
//////////////////////////////////////////////////////////////////////////////////////////////////

// Load and Ctrl hazard detection
assign PreRegSrc1Q101H           = PreInstructionQ101H[19:15];
assign PreRegSrc2Q101H           = PreInstructionQ101H[24:20];
assign LoadHzrdDetectQ101H       = Rst ? 1'b0 : 
                                 ((PreRegSrc1Q101H == RegDstQ102H) && (OpcodeQ102H == LOAD)) ? 1'b1:
                                 ((PreRegSrc2Q101H == RegDstQ102H) && (OpcodeQ102H == LOAD)) ? 1'b1:
                                                                                               1'b0;
assign PcEnQ101H                = !LoadHzrdDetectQ101H;
assign InstructionQ101H         = flushQ102H ? NOP :
                                  flushQ103H ? NOP :
                                  LoadHzrdDetectQ101H ? NOP: 
                                  LoadHzrdDetectQ102H ? PreviousInstructionQ101H :
                                                        PreInstructionQ101H;

// End Load and Ctrl hazard detection

assign OpcodeQ101H           = t_opcode'(InstructionQ101H[6:0]);
assign Funct3Q101H           = InstructionQ101H[14:12];
assign Funct7Q101H           = InstructionQ101H[31:25];
assign SelNextPcAluOutJQ101H = (OpcodeQ101H == JAL) || (OpcodeQ101H == JALR);
assign SelNextPcAluOutBQ101H = (OpcodeQ101H == BRANCH);
assign SelRegWrPcQ101H       = (OpcodeQ101H == JAL) || (OpcodeQ101H == JALR);
assign SelAluPcQ101H         = (OpcodeQ101H == JAL) || (OpcodeQ101H == BRANCH) || (OpcodeQ101H == AUIPC);
assign SelAluImmQ101H        =!(OpcodeQ101H == R_OP); // Only in case of RegReg Operation the Imm Selector is deasserted - defualt is asserted
assign SelDMemWbQ101H        = (OpcodeQ101H == LOAD);
assign CtrlLuiQ101H          = (OpcodeQ101H == LUI);
assign CtrlRegWrEnQ101H      = (OpcodeQ101H == LUI ) || (OpcodeQ101H == AUIPC) || (OpcodeQ101H == JAL)  || (OpcodeQ101H == JALR) ||
                               (OpcodeQ101H == LOAD) || (OpcodeQ101H == I_OP)  || (OpcodeQ101H == R_OP) || (OpcodeQ101H == FENCE);
assign CtrlDMemWrEnQ101H     = (OpcodeQ101H == STORE);
assign CtrlSignExtQ101H      = (OpcodeQ101H == LOAD) && (!Funct3Q101H[2]); // Sign extend the LOAD from memory read.
assign CtrlDMemByteEnQ101H   = ((OpcodeQ101H == LOAD) || (OpcodeQ101H == STORE)) && (Funct3Q101H[1:0] == 2'b00) ? 4'b0001 : // LB || SB
                               ((OpcodeQ101H == LOAD) || (OpcodeQ101H == STORE)) && (Funct3Q101H[1:0] == 2'b01) ? 4'b0011 : // LH || SH
                               ((OpcodeQ101H == LOAD) || (OpcodeQ101H == STORE)) && (Funct3Q101H[1:0] == 2'b10) ? 4'b1111 : // LW || SW
                                                                                              4'b0000 ;
assign CtrlBranchOpQ101H     = t_branch_type'(Funct3Q101H);

always_comb begin
    unique casez ({Funct3Q101H, Funct7Q101H, OpcodeQ101H})
    // ---- R type ----
    {3'b000, 7'b0000000, R_OP} : CtrlAluOpQ101H = ADD;  // ADD
    {3'b000, 7'b0100000, R_OP} : CtrlAluOpQ101H = SUB;  // SUB
    {3'b001, 7'b0000000, R_OP} : CtrlAluOpQ101H = SLL;  // SLL
    {3'b010, 7'b0000000, R_OP} : CtrlAluOpQ101H = SLT;  // SLT
    {3'b011, 7'b0000000, R_OP} : CtrlAluOpQ101H = SLTU; // SLTU
    {3'b100, 7'b0000000, R_OP} : CtrlAluOpQ101H = XOR;  // XOR
    {3'b101, 7'b0000000, R_OP} : CtrlAluOpQ101H = SRL;  // SRL
    {3'b101, 7'b0100000, R_OP} : CtrlAluOpQ101H = SRA;  // SRA
    {3'b110, 7'b0000000, R_OP} : CtrlAluOpQ101H = OR;   // OR
    {3'b111, 7'b0000000, R_OP} : CtrlAluOpQ101H = AND;  // AND
    // ---- I type ----
    {3'b000, 7'b???????, I_OP} : CtrlAluOpQ101H = ADD;  // ADDI
    {3'b010, 7'b???????, I_OP} : CtrlAluOpQ101H = SLT;  // SLTI
    {3'b011, 7'b???????, I_OP} : CtrlAluOpQ101H = SLTU; // SLTUI
    {3'b100, 7'b???????, I_OP} : CtrlAluOpQ101H = XOR;  // XORI
    {3'b110, 7'b???????, I_OP} : CtrlAluOpQ101H = OR;   // ORI
    {3'b111, 7'b???????, I_OP} : CtrlAluOpQ101H = AND;  // ANDI
    {3'b001, 7'b0000000, I_OP} : CtrlAluOpQ101H = SLL;  // SLLI
    {3'b101, 7'b0000000, I_OP} : CtrlAluOpQ101H = SRL;  // SRLI
    {3'b101, 7'b0100000, I_OP} : CtrlAluOpQ101H = SRA;  // SRAI
    // ---- Other ----
    default                    : CtrlAluOpQ101H = ADD;  // LUI || AUIPC || JAL || JALR || BRANCH || LOAD || STORE
    endcase
end
// Immediate Generator
always_comb begin
  unique casez (OpcodeQ101H) // Mux
    JALR, I_OP, LOAD : SelImmTypeQ101H = I_TYPE;
    LUI, AUIPC       : SelImmTypeQ101H = U_TYPE;
    JAL              : SelImmTypeQ101H = J_TYPE;
    BRANCH           : SelImmTypeQ101H = B_TYPE;
    STORE            : SelImmTypeQ101H = S_TYPE;
    default          : SelImmTypeQ101H = I_TYPE;
  endcase
  unique casez (SelImmTypeQ101H) // Mux
    U_TYPE : ImmediateQ101H = {     InstructionQ101H[31:12], 12'b0 } ;                                                                            // U_Immediate
    I_TYPE : ImmediateQ101H = { {20{InstructionQ101H[31]}} , InstructionQ101H[31:20] };                                                           // I_Immediate
    S_TYPE : ImmediateQ101H = { {20{InstructionQ101H[31]}} , InstructionQ101H[31:25] , InstructionQ101H[11:7]  };                                 // S_Immediate
    B_TYPE : ImmediateQ101H = { {20{InstructionQ101H[31]}} , InstructionQ101H[7]     , InstructionQ101H[30:25] , InstructionQ101H[11:8]  , 1'b0}; // B_Immediate
    J_TYPE : ImmediateQ101H = { {12{InstructionQ101H[31]}} , InstructionQ101H[19:12] , InstructionQ101H[20]    , InstructionQ101H[30:21] , 1'b0}; // J_Immediate
    default: ImmediateQ101H = {     InstructionQ101H[31:12], 12'b0 };                                                                             // U_Immediate
  endcase
end
//===================
//  Register File
//===================
assign RegDstQ101H  = InstructionQ101H[11:7];
assign RegSrc1Q101H = InstructionQ101H[19:15];
assign RegSrc2Q101H = InstructionQ101H[24:20];
// ---- Read Register File ----
assign RegRdData1Q101H = (RegSrc1Q101H == RegDstQ104H) && (CtrlRegWrEnQ104H) && (RegSrc1Q101H != 5'b0) ? RegWrDataQ104H:
                         (RegSrc1Q101H == 5'b0) ? 32'b0 : Register[RegSrc1Q101H];

assign RegRdData2Q101H = (RegSrc2Q101H == RegDstQ104H) && (CtrlRegWrEnQ104H) && (RegSrc2Q101H != 5'b0) ? RegWrDataQ104H:
                         (RegSrc2Q101H == 5'b0) ? 32'b0 : Register[RegSrc2Q101H];

// Q101H to Q102H Flip Flops
`RVC_MSFF(PcQ102H                  , PcQ101H               , Clock)
`RVC_MSFF(PcPlus4Q102H             , PcPlus4Q101H          , Clock)
`RVC_MSFF(SelNextPcAluOutJQ102H    , SelNextPcAluOutJQ101H , Clock)
`RVC_MSFF(SelNextPcAluOutBQ102H    , SelNextPcAluOutBQ101H , Clock)
`RVC_MSFF(SelRegWrPcQ102H          , SelRegWrPcQ101H       , Clock)
`RVC_MSFF(SelAluPcQ102H            , SelAluPcQ101H         , Clock)
`RVC_MSFF(SelAluImmQ102H           , SelAluImmQ101H        , Clock)
`RVC_MSFF(SelDMemWbQ102H           , SelDMemWbQ101H        , Clock)
`RVC_MSFF(CtrlLuiQ102H             , CtrlLuiQ101H          , Clock)
`RVC_MSFF(CtrlRegWrEnQ102H         , CtrlRegWrEnQ101H      , Clock)
`RVC_MSFF(CtrlDMemWrEnQ102H        , CtrlDMemWrEnQ101H     , Clock)
`RVC_MSFF(CtrlSignExtQ102H         , CtrlSignExtQ101H      , Clock)
`RVC_MSFF(CtrlDMemByteEnQ102H      , CtrlDMemByteEnQ101H   , Clock)
`RVC_MSFF(CtrlBranchOpQ102H        , CtrlBranchOpQ101H     , Clock)
`RVC_MSFF(CtrlAluOpQ102H           , CtrlAluOpQ101H        , Clock)
`RVC_MSFF(ImmediateQ102H           , ImmediateQ101H        , Clock)
`RVC_MSFF(RegSrc1Q102H             , RegSrc1Q101H          , Clock)
`RVC_MSFF(RegSrc2Q102H             , RegSrc2Q101H          , Clock)
`RVC_MSFF(PreRegRdData1Q102H       , RegRdData1Q101H       , Clock)
`RVC_MSFF(PreRegRdData2Q102H       , RegRdData2Q101H       , Clock)
`RVC_MSFF(RegDstQ102H              , RegDstQ101H           , Clock)
`RVC_MSFF(OpcodeQ102H              , OpcodeQ101H           , Clock)
`RVC_MSFF(PreviousInstructionQ101H , PreInstructionQ101H   , Clock)
`RVC_MSFF(LoadHzrdDetectQ102H      , LoadHzrdDetectQ101H   , Clock)

//////////////////////////////////////////////////////////////////////////////////////////////////
//    _____  __     __   _____   _        ______          ____    __    ___    ___    _    _ 
//   / ____| \ \   / /  / ____| | |      |  ____|        / __ \  /_ |  / _ \  |__ \  | |  | |
//  | |       \ \_/ /  | |      | |      | |__          | |  | |  | | | | | |    ) | | |__| |
//  | |        \   /   | |      | |      |  __|         | |  | |  | | | | | |   / /  |  __  |
//  | |____     | |    | |____  | |____  | |____        | |__| |  | | | |_| |  / /_  | |  | |
//   \_____|    |_|     \_____| |______| |______|        \___\_\  |_|  \___/  |____| |_|  |_|
//                                                                                           
//////////////////////////////////////////////////////////////////////////////////////////////////
// Execute
// -----------------
// 1. Use the Imm/Registers to compute:
//      a) data to write back to register.
//      b) Calculate address for load/store
//      c) Calculate branch/jump target.
// 2. Check branch condition.
//////////////////////////////////////////////////////////////////////////////////////////////////

// Take care to data hazard
assign RegRdData1Q102H = (RegSrc1Q102H == RegDstQ103H) && (CtrlRegWrEnQ103H) && (RegSrc1Q102H != 5'b0) ? AluOutQ103H :
                         (RegSrc1Q102H == RegDstQ104H) && (CtrlRegWrEnQ104H) && (RegSrc1Q102H != 5'b0) ? RegWrDataQ104H : PreRegRdData1Q102H;

assign RegRdData2Q102H = (RegSrc2Q102H == RegDstQ103H) && (CtrlRegWrEnQ103H) && (RegSrc2Q102H != 5'b0) ? AluOutQ103H :
                         (RegSrc2Q102H == RegDstQ104H) && (CtrlRegWrEnQ104H) && (RegSrc2Q102H != 5'b0) ? RegWrDataQ104H : PreRegRdData2Q102H;

// End Take care to data hazard
assign AluIn1Q102H = SelAluPcQ102H  ? PcQ102H          : RegRdData1Q102H;
assign AluIn2Q102H = SelAluImmQ102H ? ImmediateQ102H   : RegRdData2Q102H;

always_comb begin : alu_logic
  ShamtQ102H      = AluIn2Q102H[4:0];
  unique casez (CtrlAluOpQ102H) 
    // Adder
    ADD     : AluOutQ102H = AluIn1Q102H +   AluIn2Q102H;                            // ADD/LW/SW/AUIOC/JAL/JALR/BRANCH/
    SUB     : AluOutQ102H = AluIn1Q102H + (~AluIn2Q102H) + 1'b1;                    // SUB
    SLT     : AluOutQ102H = {31'b0, ($signed(AluIn1Q102H) < $signed(AluIn2Q102H))}; // SLT
    SLTU    : AluOutQ102H = {31'b0 , AluIn1Q102H < AluIn2Q102H};                    // SLTU
    // Shifter
    SLL     : AluOutQ102H = AluIn1Q102H << ShamtQ102H;                              // SLL
    SRL     : AluOutQ102H = AluIn1Q102H >> ShamtQ102H;                              // SRL
    SRA     : AluOutQ102H = $signed(AluIn1Q102H) >>> ShamtQ102H;                    // SRA
    // Bit wise operations
    XOR     : AluOutQ102H = AluIn1Q102H ^ AluIn2Q102H;                              // XOR
    OR      : AluOutQ102H = AluIn1Q102H | AluIn2Q102H;                              // OR
    AND     : AluOutQ102H = AluIn1Q102H & AluIn2Q102H;                              // AND
    default : AluOutQ102H = AluIn1Q102H + AluIn2Q102H;
  endcase
  if (CtrlLuiQ102H) AluOutQ102H = AluIn2Q102H;                                      // LUI
end

always_comb begin : branch_comp
  // Check branch condition
  unique casez ({CtrlBranchOpQ102H})
    BEQ     : BranchCondMetQ102H =  (RegRdData1Q102H == RegRdData2Q102H);                  // BEQ
    BNE     : BranchCondMetQ102H = ~(RegRdData1Q102H == RegRdData2Q102H);                  // BNE
    BLT     : BranchCondMetQ102H =  ($signed(RegRdData1Q102H) < $signed(RegRdData2Q102H)); // BLT
    BGE     : BranchCondMetQ102H = ~($signed(RegRdData1Q102H) < $signed(RegRdData2Q102H)); // BGE
    BLTU    : BranchCondMetQ102H =  (RegRdData1Q102H < RegRdData2Q102H);                   // BLTU
    BGEU    : BranchCondMetQ102H = ~(RegRdData1Q102H < RegRdData2Q102H);                   // BGEU
    default : BranchCondMetQ102H = 1'b0;
  endcase
end

assign SelNextPcAluOutQ102H = (SelNextPcAluOutBQ102H && BranchCondMetQ102H) || (SelNextPcAluOutJQ102H);   
assign NextPcQ102H = SelNextPcAluOutQ102H ? AluOutQ102H : PcPlus4Q100H;
assign flushQ102H = SelNextPcAluOutQ102H;

// Q102H to Q103H Flip Flops
`RVC_MSFF(RegRdData2Q103H     , RegRdData2Q102H     , Clock)
`RVC_MSFF(AluOutQ103H         , AluOutQ102H         , Clock)
`RVC_MSFF(CtrlDMemByteEnQ103H , CtrlDMemByteEnQ102H , Clock)
`RVC_MSFF(CtrlDMemWrEnQ103H   , CtrlDMemWrEnQ102H   , Clock)
`RVC_MSFF(SelDMemWbQ103H      , SelDMemWbQ102H      , Clock)
`RVC_MSFF(CtrlSignExtQ103H    , CtrlSignExtQ102H    , Clock)
`RVC_MSFF(PcPlus4Q103H        , PcPlus4Q102H        , Clock)
`RVC_MSFF(SelRegWrPcQ103H     , SelRegWrPcQ102H     , Clock)
`RVC_MSFF(RegDstQ103H         , RegDstQ102H         , Clock)
`RVC_MSFF(CtrlRegWrEnQ103H    , CtrlRegWrEnQ102H    , Clock)
`RVC_MSFF(flushQ103H          , flushQ102H          , Clock)

//////////////////////////////////////////////////////////////////////////////////////////////////
//   _____  __     __   _____   _        ______          ____    __    ___    ____    _    _ 
//  / ____| \ \   / /  / ____| | |      |  ____|        / __ \  /_ |  / _ \  |___ \  | |  | |
// | |       \ \_/ /  | |      | |      | |__          | |  | |  | | | | | |   __) | | |__| |
// | |        \   /   | |      | |      |  __|         | |  | |  | | | | | |  |__ <  |  __  |
// | |____     | |    | |____  | |____  | |____        | |__| |  | | | |_| |  ___) | | |  | |
//  \_____|    |_|     \_____| |______| |______|        \___\_\  |_|  \___/  |____/  |_|  |_|
//
//////////////////////////////////////////////////////////////////////////////////////////////////
// Memory Access
// -----------------
// 1. Access D_MEM for Wrote (STORE) and Reads (LOAD)
//////////////////////////////////////////////////////////////////////////////////////////////////

// Outputs to memory
always_comb begin
data          = (address[1:0] == 2'b01 ) ? { RegRdData2Q103H[23:0],8'b0  } :
                (address[1:0] == 2'b10 ) ? { RegRdData2Q103H[15:0],16'b0 } :
                (address[1:0] == 2'b11 ) ? { RegRdData2Q103H[7:0] ,24'b0 } :
                                             RegRdData2Q103H;
byteena       = (address[1:0] == 2'b01 ) ? { CtrlDMemByteEnQ103H[2:0],1'b0 } :
                (address[1:0] == 2'b10 ) ? { CtrlDMemByteEnQ103H[1:0],2'b0 } :
                (address[1:0] == 2'b11 ) ? { CtrlDMemByteEnQ103H[0]  ,3'b0 } :
                                             CtrlDMemByteEnQ103H;
end
assign address = AluOutQ103H;
assign wren    = CtrlDMemWrEnQ103H;
assign rden    = SelDMemWbQ103H;

// Q103H to Q104H Flip Flops
`RVC_MSFF(AluOutQ104H         , AluOutQ103H         , Clock)
`RVC_MSFF(SelDMemWbQ104H      , SelDMemWbQ103H      , Clock)
`RVC_MSFF(PcPlus4Q104H        , PcPlus4Q103H        , Clock)
`RVC_MSFF(SelRegWrPcQ104H     , SelRegWrPcQ103H     , Clock)
`RVC_MSFF(RegDstQ104H         , RegDstQ103H         , Clock)
`RVC_MSFF(CtrlRegWrEnQ104H    , CtrlRegWrEnQ103H    , Clock)
`RVC_MSFF(CtrlSignExtQ104H    , CtrlSignExtQ103H    , Clock)
`RVC_MSFF(CtrlDMemByteEnQ104H , CtrlDMemByteEnQ103H , Clock)

//////////////////////////////////////////////////////////////////////////////////////////////////
//    ____  __     __   _____   _        ______          ____    __    ___    _  _     _    _ 
//  / ____| \ \   / /  / ____| | |      |  ____|        / __ \  /_ |  / _ \  | || |   | |  | |
// | |       \ \_/ /  | |      | |      | |__          | |  | |  | | | | | | | || |_  | |__| |
// | |        \   /   | |      | |      |  __|         | |  | |  | | | | | | |__   _| |  __  |
// | |____     | |    | |____  | |____  | |____        | |__| |  | | | |_| |    | |   | |  | |
//  \_____|    |_|     \_____| |______| |______|        \___\_\  |_|  \___/     |_|   |_|  |_|
//
//////////////////////////////////////////////////////////////////////////////////////////////////
// Write-Back
// -----------------
// 1. Select which data should be written back to the register file AluOut or DMemRdData.
//////////////////////////////////////////////////////////////////////////////////////////////////

logic [1:0]  ByteOffset;
logic [31:0] RdDataAfterShiftQ104H;
assign ByteOffset = AluOutQ104H[1:0]; 
assign RdDataAfterShiftQ104H = (ByteOffset == 2'b00) ?        q         :
                               (ByteOffset == 2'b01) ? { 8'b0,q[31:8]}  :
                               (ByteOffset == 2'b10) ? {16'b0,q[31:16]} :
                               (ByteOffset == 2'b11) ? {24'b0,q[31:24]} :
                                                              q         ;

// Sign extend taking care of
assign PostDMemRdData_From_DmemQ104H[7:0]   =  CtrlDMemByteEnQ104H[0] ? RdDataAfterShiftQ104H[7:0]     : 8'b0;
assign PostDMemRdData_From_DmemQ104H[15:8]  =  CtrlDMemByteEnQ104H[1] ? RdDataAfterShiftQ104H[15:8]    :
                                                     CtrlSignExtQ104H ? {8{RdDataAfterShiftQ104H[7]}}  : 8'b0;
assign PostDMemRdData_From_DmemQ104H[23:16] =  CtrlDMemByteEnQ104H[2] ? RdDataAfterShiftQ104H[23:16]   :
                                                     CtrlSignExtQ104H ? {8{RdDataAfterShiftQ104H[15]}} : 8'b0;
assign PostDMemRdData_From_DmemQ104H[31:24] =  CtrlDMemByteEnQ104H[3] ? RdDataAfterShiftQ104H[31:24]   :
                                                     CtrlSignExtQ104H ? {8{RdDataAfterShiftQ104H[23]}} : 8'b0;

// ---- Select what write to the register file ----
assign WrBackDataQ104H = SelDMemWbQ104H ? PostDMemRdData_From_DmemQ104H : AluOutQ104H;
assign RegWrDataQ104H  = SelRegWrPcQ104H ? PcPlus4Q104H : WrBackDataQ104H;
//---- The Register File ----
 `RVC_EN_MSFF(Register[RegDstQ104H] , RegWrDataQ104H , Clock , (CtrlRegWrEnQ104H && (RegDstQ104H!=5'b0)))
endmodule // Module rvc_asap_5pl