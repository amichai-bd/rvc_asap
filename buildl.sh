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

	#=== TO DO: need to fix the aliases ===#
	rv_gcc=/c/Users/gilya/AppData/Roaming/xpack-riscv-none-embed-gcc-10.1.0-1.1/bin/rv_gcc
	rv_objcopy=/c/Users/gilya/AppData/Roaming/xpack-riscv-none-embed-gcc-10.1.0-1.1/bin/rv_objcopy
	rv_objdump=/c/Users/gilya/AppData/Roaming/xpack-riscv-none-embed-gcc-10.1.0-1.1/bin/rv_objdump

	#===== 1. Compile all the Assembly files in apps/asm to apps/elf =====#
	for f in "$APPS_ASM"/*; do
	file_name="$(basename -- $f)"
	clean_file_name="${file_name%.*}"
    $rv_gcc -O3 -march=rv32i -T$APPS/link.common.ld -nostartfiles -D__riscv__ $APPS_ASM/$file_name -o $APPS_ELF/$clean_file_name.elf
	mkdir ./target/$clean_file_name
    done

	#===== 2. Compile all the elf files in apps/elf to apps/sv =====#
	for f in "$APPS_ELF"/*; do
	file_name="$(basename -- $f)"
	clean_file_name="${file_name%.*}"
    $rv_objcopy --srec-len 1 --output-target=verilog $APPS_ELF/$file_name $APPS_SV/$clean_file_name.sv
    $rv_objdump -gd -M numeric $APPS_ELF/$file_name > $APPS_ELF_TXT/$file_name.txt
	done

	#===== 3 & 4. Build the tests with vlog.exe & vsim.exe =====#
	for f in "$APPS_SV"/*; do
	file_name="$(basename -- $f)"
	clean_file_name="${file_name%.*}"
	MSG="Test: $clean_file_name" BG="42m" FG="30m"
	echo "========================================================="
	echo "========================================================="
	echo -en "              \033[$FG\033[$BG$MSG\033[0m\n"
	echo "========================================================="
	echo "========================================================="
	cd modelsim_run 
	vlog.exe +define+HPATH=$clean_file_name -f rvc_asap_list.f
	vsim.exe work.rvc_asap_tb -c -do 'run -all'
	cd ..
	echo "========================================================="
	echo "========================================================="
	MSG="End Test: $clean_file_name" BG="42m" FG="30m"
	echo -en "              \033[$FG\033[$BG$MSG\033[0m\n"
	echo "========================================================="
	echo "========================================================="
    done

	#===== 5. Check the results - TO DO (Calling to python script) =====#
}
main # End main
