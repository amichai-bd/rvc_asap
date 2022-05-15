//-----------------------------------------------------------------------------
// Title            : riscv as-fast-as-possible 
// Project          : rvc_asap
//-----------------------------------------------------------------------------
// File             : rvc_asap_sc_tb
// Original Author  : Amichai Ben-David
// Code Owner       : 
// Adviser          : Amichai Ben-David
// Created          : 10/2021
//-----------------------------------------------------------------------------
// Description :
// This module will contain the test bench of the rvc_asap_sc core 
// (1) generate the clock & rts. 
// (2) load backdoor the I_MEM & D_MEM.
// (3) End the test when the ebrake command is executed

`define TEST_DEFINE(x) `"x`"
`define HPATH 
string hpath = `TEST_DEFINE(`HPATH);

module rvc_asap_sc_tb ();
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

//Ebrake detection
always @(posedge Clock) begin : ebrake_status
    if (Ebrake == 32'h00100073) begin // ebrake instruction opcode
        end_tb("The test ended");
    end //if
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
    force rvc_asap_sc_tb.rvc_top_sc.rvc_mem_wrap_sc.IMem = IMem; //XMR - cross module reference
    assign Ebrake = rvc_asap_sc_tb.rvc_top_sc.rvc_asap_sc.Instruction; //XMR - cross module reference
    // Backdoor load the data memory
    force rvc_asap_sc_tb.rvc_top_sc.rvc_mem_wrap_sc.DMem = DMem; //XMR - cross module reference
    # 10
    release rvc_asap_sc_tb.rvc_top_sc.rvc_mem_wrap_sc.DMem;
    #1000000 $finish;
end: test_seq
//Instantiating the rvc_top_sc module
    rvc_top_sc rvc_top_sc (
        .Clock  (Clock),
        .Rst    (Rst)
    );
//================================================================================
//===============================  End-Of-Test  ==================================
//================================================================================

// define data memory sizes
parameter D_MEM_OFFSET     = 'h1000;  
parameter MSB_D_MEM        = 11;
parameter SIZE_D_MEM       = 2**(MSB_D_MEM + 1);

task end_tb;
    input string msg;
    integer fd;
    int i;
    fd = $fopen({"../target/",hpath,"/mem_snapshot.log"},"w");
    if (fd) $display("File was open succesfully : %0d", fd);
    else $display("File was not open succesfully : %0d", fd);
    for (i = 0 ; i < SIZE_D_MEM; i = i+4) begin  
        $fwrite(fd,"Offset %08x : %02x%02x%02x%02x\n",i+D_MEM_OFFSET, rvc_asap_sc_tb.rvc_top_sc.rvc_mem_wrap_sc.DMem[i+D_MEM_OFFSET+3],
                                                                      rvc_asap_sc_tb.rvc_top_sc.rvc_mem_wrap_sc.DMem[i+D_MEM_OFFSET+2],
                                                                      rvc_asap_sc_tb.rvc_top_sc.rvc_mem_wrap_sc.DMem[i+D_MEM_OFFSET+1],
                                                                      rvc_asap_sc_tb.rvc_top_sc.rvc_mem_wrap_sc.DMem[i+D_MEM_OFFSET]);
    end
    $fclose(fd);
    $display({"Test : ",msg});        
    $finish;
endtask
endmodule // module rvc_asap_sc_tb