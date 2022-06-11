//include dir - the Machine code for I_MEM load.
+incdir+../verif/
+incdir+../source/common
+define+SIMULATION_ON

//Source File (PKG, RTL, MACROS)
../source/common/rvc_asap_pkg.sv
../source/rvc_asap_5pl/rvc_asap_5pl.sv
../source/rvc_asap_5pl/rvc_asap_5pl_mem_wrap.sv
../source/rvc_asap_5pl/rvc_asap_5pl_i_mem.sv
../source/rvc_asap_5pl/rvc_asap_5pl_d_mem.sv
../source/rvc_asap_5pl/rvc_asap_5pl_cr_mem.sv
../source/rvc_asap_5pl/rvc_asap_5pl_vga_mem.sv
../source/rvc_asap_5pl/rvc_asap_5pl_vga_ctrl.sv
../source/rvc_asap_5pl/rvc_asap_5pl_sync_gen.sv
../source/rvc_asap_5pl/rvc_top_5pl.sv

//Test Bench
../verif/rvc_asap_5pl_tb.sv