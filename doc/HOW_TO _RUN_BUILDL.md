# Welcome to Explanation of the bash script buildl.sh 
## (1) First lets take a look in the usage of the script:
        usage: ./buildl.sh [test_0] [test_1] ... [test_n]
          all        build all tests"
          All        build all tests"
          example_1 : ./build.sh all"
          example_2 : ./build.sh ALL"
          example_3 : ./build.sh basic_commands1 basic_commands2 ... basic_commandsn

## (2) Let's dive into the details now:
- The script need to be excecuted from rvc_asap dir.
- The purpose of the script is to transfer an assembly file throughout the compilation chain to a   gui-free simulation. That is, assembly -> elf -> elf.txt -> system verilog -> compile the test bench -> vsim simulation.
- If the excecuted commands will be "./buildl.sh all" or "./buildl.sh ALL" the script will pass every assembly file in apps/asm dir in the compilation chain noted in the previous point.
- For convenience, we have also provided an option to pass selected tests in the compilation chain. For example, the executed command "./build.sh basic_commands1 basic_commands2" will pass the tests basic_commands1.s and basic_commands2.s in the compilation chain.
- The ouput of a test will be provided in the "rvc_asap/target" dir under the name of the specific test. This output is a memory snapshot after running the test under the rvc_asap core.
- Note that you have correctly defined the following aliases in "~/.aliases" or C:\Program      Files\Git\etc\profile.d\aliases.sh:

    alias rv_gcc='/c/Users/Amichaib/AppData/Roaming/xPacks/riscv-none-embed-gcc/xpack-riscv-none-embed-gcc-10.1.0-1.1/bin/riscv-none-embed-gcc.exe'  
    alias rv_objcopy='/c/Users/Amichaib/AppData/Roaming/xPacks/riscv-none-embed-gcc/xpack-riscv-none-embed-gcc-10.1.0-1.1/bin/riscv-none-embed-objcopy.exe'  
    alias rv_objdump='/c/Users/Amichaib/AppData/Roaming/xPacks/riscv-none-embed-gcc/xpack-riscv-none-embed-gcc-10.1.0-1.1/bin/riscv-none-embed-objdump.exe'  
