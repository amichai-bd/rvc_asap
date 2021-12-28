#!/bin/bash -li
#========== Project   : rvc_asap ===========================================#
#========== File      : buildl.sh ==========================================#
#========== Descrition: This Script - ======================================#
#==========             (1) Compile the assembly programs to elf ===========#
#==========             (2) Compile the elf files to sv ====================#
#==========             (3) Build the test with vlog.exe ===================#
#==========             (4) Simulte the tests with vsim.exe ================#
#==========             (5) Check the results ==============================#
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
	export TARGET="./target"
	export GOLDEN_IMAGE="./verif/golden_image"

	#==== Print usage in case there are no argumnets provided by the user ====# 
	if [ $# -eq 1 ]; then
		echo "usage: $0 [test_0] [test_1] ... [test_n]"
    	echo "  all        build all tests"
    	echo "  All        build all tests"
    	echo "  example_1 : ./build.sh all"
        echo "  example_2 : ./build.sh ALL"
        echo "  example_3 : ./build.sh basic_commands1 basic_commands2 ... basic_commandsn"
    	exit 1
	fi

    #===== 1. Compile the Assembly files in apps/asm to apps/elf =====#
    for f in "$APPS_ASM"/*; do
    file_name="$(basename -- $f)"
    clean_file_name="${file_name%.*}"
        #==== 1.1 Compile Only the tests that were specified by the user ====#
        for test in "$@"
        do	
        if [ "$test" = "$clean_file_name" ] || [ "$test" = "all" ] || [ "$test" = "ALL" ] || [ $# -eq 1 ]; then
           rv_gcc -O3 -march=rv32i -T$APPS/link.common.ld -nostartfiles -D__riscv__ $APPS_ASM/$file_name -o $APPS_ELF/$clean_file_name.elf
           if [[ ! -d "./target/$clean_file_name" ]]
           then
           mkdir ./target/$clean_file_name
           fi
        fi
        done
    done

	#===== 2. Compile all the elf files in apps/elf to apps/sv =====#
	for f in "$APPS_ELF"/*; do
	file_name="$(basename -- $f)"
	clean_file_name="${file_name%.*}"
		#==== 2.1 Compile Only the tests that were specified by the user ====#
		for test in "$@"
		do	
			if [ "$test" = "$clean_file_name" ] || [ "$test" = "all" ] || [ "$test" = "ALL" ] || [ $# -eq 1 ]; then	
    			rv_objcopy --srec-len 1 --output-target=verilog $APPS_ELF/$file_name $APPS_SV/$clean_file_name.sv
    			rv_objdump -gd -M numeric $APPS_ELF/$file_name > $APPS_ELF_TXT/$file_name.txt
			fi
		done
	done

	#===== 3 & 4. Build the tests with vlog.exe & vsim.exe =====#
	for f in "$APPS_SV"/*; do
	file_name="$(basename -- $f)"
	clean_file_name="${file_name%.*}"
		#==== 3.1 Compile Only the tests that were specified by the user ====#
		for test in "$@"
		do	
			if [ "$test" = "$clean_file_name" ] || [ "$test" = "all" ] || [ "$test" = "ALL" ] || [ $# -eq 1 ]; then	
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
			fi
		done
    done

	#===== 5. Check the results  =====#
	for f in "$TARGET"/*; do
	file_name="$(basename -- $f)"
	clean_file_name="${file_name%.*}"
		#==== 5.1 Check Only the tests that were specified by the user ====#
		for test in "$@"
		do	
			if [ "$test" = "$clean_file_name" ] || [ "$test" = "all" ] || [ "$test" = "ALL" ] || [ $# -eq 1 ]; then	
				MSG="Check: $clean_file_name" BG="103m" FG="30m"
				echo "========================================================="
				echo -en "              \033[$FG\033[$BG$MSG\033[0m\n"
				echo "========================================================="
                input1="$TARGET/$clean_file_name/mem_snapshot.log"
				input2="$GOLDEN_IMAGE/$clean_file_name/mem_snapshot.log"
                if [ -f "$input1" ] && [ -f "$input2" ]; then
                   while read compareFile1 <&3 && read compareFile2 <&4; do     
                   if [ "$compareFile1" != "$compareFile2" ]; then
                      MSG1="Error: Inequality" BG="101m" FG="30m"
				      echo -en "              \033[$FG\033[$BG$MSG1\033[0m\n"
					  echo "Real line: $compareFile1"
					  echo "Gold line: $compareFile2"
                   fi 
                   done 3<$input1 4<$input2
                else
				echo "           This test have no memory snapshot             "
				fi
				echo "========================================================="
				MSG="End Check: $clean_file_name" BG="103m" FG="30m"
				echo -en "              \033[$FG\033[$BG$MSG\033[0m\n"
				echo "========================================================="
			fi
		done
    done

}

main "$@" "$#" # End main
