//-----------------------------------------------------------------------------
// Title            : riscv as-fast-as-possible 
// Project          : rvc_asap
//-----------------------------------------------------------------------------
// File             : rvc_asap_5pl_tb
// Original Author  : Amichai Ben-David
// Code Owner       : 
// Adviser          : Amichai Ben-David
// Created          : 10/2021
//-----------------------------------------------------------------------------
// Description :
// This module will contain the test bench of the rvc_asap_5pl core 
// (1) generate the clock & rts. 
// (2) load backdoor the I_MEM & D_MEM.
// (3) End the test when the ebrake command is executed

`define TEST_DEFINE(x) `"x`"
`define HPATH 
string hpath = `TEST_DEFINE(`HPATH);

module rvc_asap_5pl_tb ();
    logic Clock;
    logic Rst;
`include "rvc_asap_macros.sv"
import rvc_asap_pkg::*;  
// clock generation
initial begin: clock_gen
    forever begin
        #5 Clock = 1'b0;
        #5 Clock = 1'b1;
    end
end: clock_gen
// reset generation
initial begin: reset_gen
    Rst = 1'b1;
#40 Rst = 1'b0;
end: reset_gen

logic  [31:0] Ebrake;

// Ebrake detection
always @(posedge Clock) begin : ebrake_status
    if (Ebrake == 32'h00100073) begin // ebrake instruction opcode
        end_tb("The test ended");
    end
end

logic  [7:0] IMem [I_MEM_MSB:0];
logic  [7:0] DMem [D_MEM_MSB:I_MEM_MSB+1];

`RVC_MSFF(IMem, IMem, Clock)
`RVC_MSFF(DMem, DMem, Clock)

initial begin: test_seq
    //======================================
    //load the program to the TB
    //======================================
    $readmemh({"../apps/sv/",hpath,"-inst_mem_rv32i.sv"}, IMem);
    $readmemh({"../apps/sv/",hpath,"-data_mem_rv32i.sv"}, DMem);
    // Backdoor load the Instruction memory
    force rvc_asap_5pl_tb.rvc_top_5pl.rvc_asap_5pl_mem_wrap.rvc_asap_5pl_i_mem.IMem = IMem; //XMR - cross module reference
    assign Ebrake = rvc_asap_5pl_tb.rvc_top_5pl.rvc_asap_5pl.InstructionQ101H; //XMR - cross module reference
    // Backdoor load the data memory
    force rvc_asap_5pl_tb.rvc_top_5pl.rvc_asap_5pl_mem_wrap.rvc_asap_5pl_d_mem.DMem = DMem; //XMR - cross module reference
    # 10
    release rvc_asap_5pl_tb.rvc_top_5pl.rvc_asap_5pl_mem_wrap.rvc_asap_5pl_d_mem.DMem;
    #100000000 $finish;
end: test_seq

//=========================================
//     FPGA - Core interface
//=========================================
// FPGA interface inputs              
logic       Button_0;
logic       Button_1;
logic [9:0] Switch;

// FPGA interface outputs
logic [6:0] SEG7_0;
logic [6:0] SEG7_1;
logic [6:0] SEG7_2;
logic [6:0] SEG7_3;
logic [6:0] SEG7_4;
logic [6:0] SEG7_5;
logic [6:0] LED;

//=========================================
//     VGA - Core interface
//=========================================
// VGA output
logic [3:0] RED;
logic [3:0] GREEN;
logic [3:0] BLUE;
logic       h_sync;
logic       v_sync;

// Instantiating the rvc_top_5pl module
rvc_top_5pl rvc_top_5pl (
    .Clock    (Clock),
    .Rst      (Rst),
    .Button_0 (Button_0), // CR_MEM
    .Button_1 (Button_1), // CR_MEM
    .Switch   (Switch),   // CR_MEM
    .SEG7_0   (SEG7_0),   // CR_MEM
    .SEG7_1   (SEG7_1),   // CR_MEM
    .SEG7_2   (SEG7_2),   // CR_MEM
    .SEG7_3   (SEG7_3),   // CR_MEM
    .SEG7_4   (SEG7_4),   // CR_MEM
    .SEG7_5   (SEG7_5),   // CR_MEM
    .LED      (LED),      // CR_MEM
    .RED      (RED),
    .GREEN    (GREEN),
    .BLUE     (BLUE),
    .h_sync   (h_sync),
    .v_sync   (v_sync)
);

//================================================================================
//===============================  End-Of-Test  ==================================
//================================================================================

// define data memory sizes
parameter D_MEM_OFFSET     = 'h1000;  
parameter MSB_D_MEM        = 11;
parameter SIZE_D_MEM       = 2**(MSB_D_MEM + 1);

// define VGA memory sizes
parameter VGA_MEM_OFFSET     = 'h3000;  
parameter SIZE_VGA_MEM       = 38400;

task end_tb;
    input string msg;
    integer fd, fd1;
    int i,j,k,l;
    // Data memory snapshot
    fd = $fopen({"../target/",hpath,"/mem_snapshot.log"},"w");
    if (fd) $display("File was open succesfully : %0d", fd);
    else $display("File was not open succesfully : %0d", fd);
    for (i = 0 ; i < SIZE_D_MEM; i = i+4) begin  
        $fwrite(fd,"Offset %08x : %02x%02x%02x%02x\n",i+D_MEM_OFFSET, rvc_asap_5pl_tb.rvc_top_5pl.rvc_asap_5pl_mem_wrap.rvc_asap_5pl_d_mem.DMem[i+D_MEM_OFFSET+3],
                                                                      rvc_asap_5pl_tb.rvc_top_5pl.rvc_asap_5pl_mem_wrap.rvc_asap_5pl_d_mem.DMem[i+D_MEM_OFFSET+2],
                                                                      rvc_asap_5pl_tb.rvc_top_5pl.rvc_asap_5pl_mem_wrap.rvc_asap_5pl_d_mem.DMem[i+D_MEM_OFFSET+1],
                                                                      rvc_asap_5pl_tb.rvc_top_5pl.rvc_asap_5pl_mem_wrap.rvc_asap_5pl_d_mem.DMem[i+D_MEM_OFFSET]);
    end
    $fclose(fd);

    // VGA memory snapshot - simulate a screen
    fd1 = $fopen({"../target/",hpath,"/screen.log"},"w");
    if (fd1) $display("File was open succesfully : %0d", fd1);
    else $display("File was not open succesfully : %0d", fd1);
    for (i = 0 ; i < 38400; i = i+320) begin // Lines
        for (j = 0 ; j < 4; j = j+1) begin // Bytes
            for (k = 0 ; k < 320; k = k+4) begin // Words
                for (l = 0 ; l < 8; l = l+1) begin // Bits  
                    $fwrite(fd1,"%01b",rvc_asap_5pl_tb.rvc_top_5pl.rvc_asap_5pl_mem_wrap.rvc_asap_5pl_vga_ctrl.rvc_asap_5pl_vga_mem.VGAMem[VGA_MEM_OFFSET+k+j+i][l]);
                end        
            end 
            $fwrite(fd1,"\n");
        end
    end
    $fclose(fd1);
    $display({"Test : ",msg});        
    $finish;
endtask
endmodule // module rvc_asap_5pl_tb