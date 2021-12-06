#!/bin/bash
#========== Project   : rvc_asap ===========================================#
#========== File      : buildl.sh ==========================================#
#========== Descrition: This Script - ======================================#
#==========             (1) Compile all the assembly programs to elf =======#
#==========             (2) Compile all the elf files to sv - TO DO ========#
#==========             (3) Build the test with vlog.exe - TO DO ===========#
#==========             (4) Simulte the tests with vsim.exe - TO DO ========#
#==========             (5) Check the results - TO DO ======================#
#===========================================================================#
#========== Author    : Gil Ya'akov & Matan Eshel ==========================#
#===========================================================================#
#========== Date      : 04DEC21 ============================================#
main(){
	export APPS_ASM="./apps/asm"
	export APPS_ELF="./apps/elf"
	export APPS="./apps"

	gcc=/c/Users/gilya/AppData/Roaming/xpack-riscv-none-embed-gcc-10.1.0-1.1/bin/riscv-none-embed-gcc-10.1.0 # Path to gcc

	#===== Compile all the Assembly files in app/asm to app/sv =====#
	dir="./apps/asm"
	for f in "$dir"/*; do
	file_name="$(basename -- $f)"
    $gcc -O3 -march=rv32i -T$APPS/link.common.ld -nostartfiles -D__riscv_ $APPS_ASM/$file_name -o $APPS_ELF/$file_name.elf
    done
}

main # End main
