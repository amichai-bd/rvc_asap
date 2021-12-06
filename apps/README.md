### Compile -> Link -> assembler -> machine code:  
create assembly file from c file  
link new ams file with gpc initializer and creates elf file  
creates readable elf file  
creates the instruction file   
>  gcc -S -ffreestanding -march=rv32i <file>.c -o <file>rv32i.c.s
>  gcc -O3 -march=rv32i -T./link.common.ld -nostartfiles -D__riscv__ crt0.S `<file>`.c.s -o `<file>`_rv32i.elf  
>  objdump -gd `<file>`_rv32i.elf > `<file>`_rv32i_elf.txt  
>  objcopy --srec-len 1 --output-target=verilog `<file>`_rv32i.elf `<file>`_inst_mem_rv32i.sv  
#### Example:  
>  gcc -O3 -march=rv32i -T./link.common.ld -nostartfiles -D__riscv__ crt0.S `alive`.c.s -o `alive`_rv32i.elf   
>  objdump -gd `alive`_rv32i.elf > `alive`_rv32i_elf.txt    
>  objcopy --srec-len 1 --output-target=verilog `alive`_rv32i.elf `alive`_inst_mem_rv32i.sv   

#### run this:  
gcc -O3 -march=rv32i -T./link.common.ld -nostartfiles -D__riscv__ alive_asap.s -o alive_asap_rv32i.elf   
objdump -gd alive_asap_rv32i.elf > alive_asap_rv32i_elf.txt    
objcopy --srec-len 1 --output-target=verilog alive_asap_rv32i.elf alive_asap_inst_mem_rv32i.sv   

gcc -O3 -march=rv32i -T./link.common.ld -nostartfiles -D__riscv__ crt0.S test_asap.c -o test_asap_rv32i.elf   
objdump -gd test_asap_rv32i.elf > test_asap_rv32i_elf.txt    
objcopy --srec-len 1 --output-target=verilog test_asap_rv32i.elf test_asap_inst_mem_rv32i.sv   
