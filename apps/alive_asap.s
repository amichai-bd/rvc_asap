clear:
    nop
    nop
    nop
    nop
    addi x1, x0, 0  
    addi x2, x0, 0  
    addi x3, x0, 0  
    addi x4, x0, 0  
    addi x5, x0, 0  
    addi x6, x0, 0  
    addi x7, x0, 0  
    addi x8, x0, 0  
    addi x9, x0, 0  
    addi x10, x0, 0  
    addi x11, x0, 0  
    addi x12, x0, 0  
    addi x13, x0, 0  
    addi x14, x0, 0  
    addi x15, x0, 0  
    addi x16, x0, 0  
    addi x17, x0, 0  
    addi x18, x0, 0  
    addi x19, x0, 0  
    addi x20, x0, 0  
    addi x21, x0, 0  
    addi x22, x0, 0  
    addi x23, x0, 0  
    addi x24, x0, 0  
    addi x25, x0, 0  
    addi x26, x0, 0  
    addi x27, x0, 0  
    addi x28, x0, 0  
    addi x29, x0, 0  
    addi x30, x0, 0  
    addi x31, x0, 0  
main:
# intial value
    addi x1, x0, 1  
    addi x2, x0, 2 
    addi x3, x0, 3 
    addi x4, x0, 4 
#test_add
    add  x5, x1, x2
    add  x6, x1, x4
    add  x7, x3, x4
    add  x8, x3, x2
store_to_memory:
    li   x31, 0x1000
    sw   x1 , 0x0(x31)
    sw   x2 , 0x4(x31)
    sw   x3 , 0x8(x31)
    sw   x4 , 0xc(x31)
    sw   x5 , 0x10(x31)
    sw   x6 , 0x14(x31)
    sw   x7 , 0x18(x31)
    sw   x8 , 0x1c(x31)
    lw   x11, 0x0(x31)
    lw   x12, 0x4(x31)
    lw   x13, 0x8(x31)
    lw   x14, 0xc(x31)
    lw   x15, 0x10(x31)
    lw   x16, 0x14(x31)
    lw   x17, 0x18(x31)
    lw   x18, 0x1c(x31)
eot:
    nop
    nop
    nop
    nop
    ebreak
    nop
    nop
    nop
    nop
