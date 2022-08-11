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
        li   x31 , 0x4000 # memory offset
        addi x1, x0, 5
        add  x2, x1, x1
        add  x3, x1, x1
        nop
        nop
        nop
        sw   x1  , 0x0(x31)
        sw   x2  , 0x4(x31)
        sw   x3  , 0x8(x31)
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