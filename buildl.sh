#!/bin/bash
#========== Project   : rvc_asap ===========================================#
#========== File      : buildl.sh ==========================================#
#========== Descrition: This Script - ======================================#
#==========             (1) Compile all the assembly programs to elf =======#
#==========             (2) Compile all the elf files to sv ================#
#==========             (3) Build the test with vlog.exe ===================#
#==========             (4) Simulte the tests with vsim.exe ================#
#==========             (5) Check the results - TO DO ======================#
#===========================================================================#
#========== Author    : Gil Ya'akov & Matan Eshel ==========================#
#===========================================================================#
#========== Date      : 04DEC21 ============================================#
main(){
	export APPS="./apps"
	export APPS_ASM="./apps/asm"
	export APPS_ELF="./apps/elf"
	export APPS_ELF_TXT="./apps/elf_txt"
	export APPS_SV="./apps/sv"
	export MODELSIM_RUN="./modelsim_run"
	export VERIF="./verif"

	gcc=/c/Users/gilya/AppData/Roaming/xpack-riscv-none-embed-gcc-10.1.0-1.1/bin/riscv-none-embed-gcc-10.1.0 # Path to gcc

	#===== 1. Compile all the Assembly files in apps/asm to apps/elf =====#
	for f in "$APPS_ASM"/*; do
	file_name="$(basename -- $f)"
	clean_file_name="${file_name%.*}"
    $gcc -O3 -march=rv32i -T$APPS/link.common.ld -nostartfiles -D__riscv__ $APPS_ASM/$file_name -o $APPS_ELF/$clean_file_name.elf
    done

	#===== 2. Compile all the elf files in apps/elf to apps/sv =====#
	for f in "$APPS_ELF"/*; do
	file_name="$(basename -- $f)"
	clean_file_name="${file_name%.*}"
    objcopy --srec-len 1 --output-target=verilog $APPS_ELF/$file_name $APPS_SV/$clean_file_name.sv
    done

	#===== 3 & 4. Build the tests with vlog.exe & vsim.exe =====#
	for f in "$APPS_SV"/*; do
	file_name="$(basename -- $f)"
	clean_file_name="${file_name%.*}"
	sed -i "s/file_name/$clean_file_name/g" ./$VERIF/rvc_asap_tb.sv
	echo "========================================================="
	echo "========================================================="
	echo "                Test: $clean_file_name                   "
	echo "========================================================="
	echo "========================================================="
	cd modelsim_run 
	vlog.exe -f rvc_asap_list.f
	vsim.exe work.rvc_asap_tb -c -do 'run -all'
	cd ..
	sed -i "s/$clean_file_name/file_name/g" ./$VERIF/rvc_asap_tb.sv
	echo "========================================================="
	echo "========================================================="
	echo "              End Test: $clean_file_name                 "
	echo "========================================================="
	echo "========================================================="
    done

	#===== 5. Check the results - TO DO (Calling to python script) =====#
}
main # End main
