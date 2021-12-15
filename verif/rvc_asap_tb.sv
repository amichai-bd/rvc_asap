//-----------------------------------------------------------------------------
// Title            : riscv as-fast-as-possible 
// Project          : rvc_asap
//-----------------------------------------------------------------------------
// File             : rvc_asap_tb
// Original Author  : Amichai Ben-David
// Code Owner       : 
// Adviser          : Amichai Ben-David
// Created          : 10/2021
//-----------------------------------------------------------------------------
// Description :
// This module will comtain the test bench of the rvc_asap core 
// (1) generate the clock & rts. 
// (2) load backdoor the I_MEM & D_MEM.
// (3) End the test when the ebrake command is executed

`define TEST_DEFINE(x) `"x`"
`define HPATH 
string hpath = `TEST_DEFINE(`HPATH);

module rvc_asap_tb ();
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
    $readmemh({"../apps/SV/",hpath,".sv"}, IMem);
    //$readmemh({"../apps/file_name_inst_mem_rv32i.sv"}, DMem);
    // Backdoor load the Instruction memory
    force rvc_asap_tb.rvc_asap.IMem = IMem; //XMR - cross module reference
    assign Ebrake = rvc_asap_tb.rvc_asap.Instruction; //XMR - cross module reference
    // Backdoor load the Instruction memory
    //force rvc_asap_tb.rvc_asap.DMem = DMem;
    #10000 $finish;
end: test_seq
//Instantiating the rvc_asap core (!!)
    rvc_asap rvc_asap (
        .Clock  (Clock),
        .Rst    (Rst)
    );
//================================================================================
//===============================  End-Of-Test  ==================================
//================================================================================

task end_tb;
    input string msg;
    $display({"Test : ",msg});        
    $finish;
endtask
endmodule // test_tb