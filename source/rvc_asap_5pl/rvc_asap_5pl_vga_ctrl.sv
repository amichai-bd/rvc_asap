//-----------------------------------------------------------------------------
// Title            : riscv as-fast-as-possible 
// Project          : rvc_asap
//-----------------------------------------------------------------------------
// File             : rvc_asap_5pl_vga_ctrl
// Original Author  : Amichai Ben-David
// Code Owner       : 
// Adviser          : Amichai Ben-David
// Created          : 06/2022
//-----------------------------------------------------------------------------
// Description :
// This module serves as the vga controller of the architecture.
// This module include the vga memory and the logic necessary for its management.

`include "rvc_asap_macros.sv"

module rvc_asap_5pl_vga_ctrl (
    input  logic        CLK_50,
    input  logic        Reset,
    // VGA memory Access
    input  logic [31:0] data,
    input  logic [31:0] address,
    input  logic [3:0]  byteena,
    input  logic        wren,
    // Read core
    input  logic        rden,
    output logic [31:0] q,
    // VGA output
    output logic [3:0]  RED,
    output logic [3:0]  GREEN,
    output logic [3:0]  BLUE,
    output logic        h_sync,
    output logic        v_sync
);

// Only One or the other (FPGA_ON vs SIMULATION_ON )
`ifndef SIMULATION_ON
    `define FPGA_ON    
`endif

logic [9:0]  pixel_y;
logic        CLK_25;
logic        inDisplayArea;
logic        next_h_sync;
logic        next_v_sync;
logic [3:0]  NextRED;
logic [3:0]  NextGREEN;
logic [3:0]  NextBLUE;
logic        CurentPixelQ2;
logic [8:0]  LineQ0, LineQ1;
logic [31:0] RdDataQ2;
logic [4:0]  SampleReset;
logic [6:0]  HEX; 
logic [13:0] WordOffsetQ1;
logic [2:0]  CountBitOffsetQ1, CountBitOffsetQ2 ;
logic [1:0]  CountByteOffsetQ1, CountByteOffsetQ2;
logic [7:0]  CountWordOffsetQ1;
logic        EnCountBitOffset,  EnCountByteOffset,  EnCountWordOffset ;
logic        RstCountBitOffset, RstCountByteOffset, RstCountWordOffset;

//=========================
//Reset For Clk Simulation 
//=========================
assign SampleReset[0] = Reset;
`RVC_MSFF(SampleReset[4:1], SampleReset[3:0], CLK_50)

//=========================
//gen Clock 25Mhz
//=========================
`ifdef SIMULATION_ON
    `RVC_RST_MSFF(CLK_25, !CLK_25, CLK_50, Reset)
`elsif FPGA_ON
pll_2 pll_2 (
    .inclk0 (CLK_50),    // input
    .c0     (CLK_25)     // output
); 
`endif // FPGA_ON

//=========================
// VGA sync Machine
//=========================
rvc_asap_5pl_sync_gen sync_inst (
    .CLK_25         (CLK_25),          // input
    .Reset          (SampleReset[4]),  // input
    .vga_h_sync     (next_h_sync),     // output
    .vga_v_sync     (next_v_sync),     // output
    .CounterX       (),                // output
    .CounterY       (pixel_y),         // output
    .inDisplayArea  (inDisplayArea)    // output
);

//=========================
// VGA Display Line #
//=========================
assign LineQ0   = pixel_y[8:0];
`RVC_MSFF(LineQ1 , LineQ0 , CLK_25)

//=========================
// Read CurrentPixelQ2 using VGA Virtual Address -> Physical Address in RAM
//=========================
assign EnCountByteOffset  = ((CountWordOffsetQ1 == 79) && EnCountWordOffset);
assign EnCountWordOffset  = (CountBitOffsetQ1 == 3'b111);
assign RstCountBitOffset  = SampleReset[4] || (!inDisplayArea);
assign RstCountByteOffset = SampleReset[4];
assign RstCountWordOffset = SampleReset[4] || ((CountWordOffsetQ1 == 8'd79) && EnCountWordOffset);
`RVC_RST_MSFF   (CountBitOffsetQ1 , (CountBitOffsetQ1 +3'b01), CLK_25, RstCountBitOffset )
`RVC_EN_RST_MSFF(CountByteOffsetQ1, (CountByteOffsetQ1+2'b01), CLK_25, EnCountByteOffset, RstCountByteOffset)
`RVC_EN_RST_MSFF(CountWordOffsetQ1, (CountWordOffsetQ1+8'b01), CLK_25, EnCountWordOffset, RstCountWordOffset)

assign WordOffsetQ1 = ((LineQ1[8:2])*8'd80 + CountWordOffsetQ1);

// Align latency
`RVC_MSFF(CountBitOffsetQ2  , CountBitOffsetQ1  , CLK_25)
`RVC_MSFF(CountByteOffsetQ2 , CountByteOffsetQ1 , CLK_25)

assign CurentPixelQ2 = RdDataQ2[{CountByteOffsetQ2,CountBitOffsetQ2}];

//=========================
// VGA memory
//=========================
logic [31:0] address_fix_offset;
assign address_fix_offset = address - (32'h8000);

`ifdef SIMULATION_ON
rvc_asap_5pl_vga_mem rvc_asap_5pl_vga_mem (
    .clock_a             (CLK_50),
    .clock_b             (CLK_25),
    // Write
    .data_a              (data),
    .address_a           (address_fix_offset[15:2]),
    .byteena_a           (byteena),
    .wren_a              (wren),
    // Read from core
    .rden_a              (rden),
    .q_a                 (q),
    // Read from vga controller
    .address_b           (WordOffsetQ1), // Word offset (not Byte)
    .q_b                 (RdDataQ2)
);
`else
vga_mem rvc_asap_5pl_vga_mem(
    .clock_a             (CLK_50),
    .clock_b             (CLK_25),
    // Write
    .data_a              (data),
    .address_a           (address_fix_offset[15:2]),
    .byteena_a           (byteena),
    .wren_a              (wren),
    // Read from core
    .rden_a              (rden),
    .q_a                 (q),
    // Read from vga controller
    .address_b           (WordOffsetQ1), // Word offset (not Byte)
    .q_b                 (RdDataQ2)
);
`endif

assign NextRED   = (inDisplayArea) ? {4{CurentPixelQ2}} : '0;
assign NextGREEN = (inDisplayArea) ? {4{CurentPixelQ2}} : '0;
assign NextBLUE  = (inDisplayArea) ? {4{CurentPixelQ2}} : '0;
`RVC_MSFF(RED    , NextRED     , CLK_25)
`RVC_MSFF(GREEN  , NextGREEN   , CLK_25)
`RVC_MSFF(BLUE   , NextBLUE    , CLK_25)
`RVC_MSFF(h_sync , next_h_sync , CLK_25)
`RVC_MSFF(v_sync , next_v_sync , CLK_25)

endmodule // Module rvc_asap_5pl_vga_ctrl