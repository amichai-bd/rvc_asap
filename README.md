# rvc_asap | riscv-core-as-simple-as-passible
RISCV CPU compatible with RV32I unprivileged spec.  
https://riscv.org/technical/specifications/

# Builed the model - SW, RTL, simulation, FPGA  
Read the "HOW_TO" and make sure you have all tools installed:
- modelsim - system verilog compiler & simulator (lite free version)  
- gcc - RISCV compiler & tools chains for SW

## building the model:
./buildl.sh all
1. Compile with GCC the source code C/Asembly, link it together, genreate <mem>.sv for simulation, <mem>.mif for FPGA.  
2. Compile the RTL & run simulation for the level0 tests
3. Automated scripts will report the simulation results
4. Use the quartus GUI to load the model to the DE10-lite FPGA 

## RISCV core capabile running programs compatible with the RV32I Spec.  
Demonstration running on DE10-lite FPGA:  
<img src="https://user-images.githubusercontent.com/81047407/185759832-5198ac3b-9fec-4154-9fb7-5eecbec85885.png" width="300">  


# Steps we completed for this 
1. Follow the "HOW_TO" under documentation
2. Study the RISCV spec.
3. Design RISCV block diagram.
4. Write SystemVerilog Core (RTL)
5. Write a TB. (validation & Stimuli)
6. Write c/assembly programs to run on the core.
7. Add MMIO & other FPGA capabilities such as VGA, SWITCH, 7SEG display, LED

# Single Cycle:
<img src="https://user-images.githubusercontent.com/72501420/159980340-d1d02fd5-02dc-41cb-a5d2-8bade3177f75.jpeg" width="500">  

# 5 Stage Pipe Line
<img src="https://user-images.githubusercontent.com/81047407/185759572-805c47b6-daee-4eb9-84eb-b5e7c08a8abb.png" width="700">  




