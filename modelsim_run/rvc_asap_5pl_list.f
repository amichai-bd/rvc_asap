//include dir - the Machine code for I_MEM load.
+incdir+../verif/
+incdir+../source/common

//Source File (PKG, RTL, MACROS)
../source/common/rvc_asap_pkg.sv
../source/rvc_asap_5pl/rvc_asap_5pl_core/rvc_asap_5pl.sv
../source/rvc_asap_5pl/rvc_asap_5pl_memory/rvc_asap_mem_wrap_5pl.sv
../source/rvc_asap_5pl/rvc_asap_5pl_memory/rvc_asap_5pl_i_mem.sv
../source/rvc_asap_5pl/rvc_asap_5pl_memory/rvc_asap_5pl_d_mem.sv
../source/rvc_asap_5pl/rvc_asap_5pl_memory/rvc_asap_5pl_cr_mem.sv
../source/rvc_asap_5pl/rvc_top_5pl.sv

//Test Bench
../verif/rvc_asap_5pl_tb.sv