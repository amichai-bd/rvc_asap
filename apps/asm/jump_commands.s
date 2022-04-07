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
        li   x31 , 0x1000 # memory offset
        li    x30,  1     # act like true
        li    x29,  0     # act like false

        # registers to work with
        li    x1,  1
        li    x2,  1
        li    x3,  2

        beq x1,x2,LABEL_0     # need to jump
        sw   x29  , 0x0(x31)  # store false
        jal x28, LABEL_1      # jump over LABEL_0
LABEL_0:
        sw   x30  , 0x0(x31)  # store true
LABEL_1:bne x1,x2,LABEL_2     # don't need to jump
        jal x1, LABEL_3      # jump over LABEL_2 
LABEL_2:
        sw   x30  , 0x4(x31)  # store false
        jal x1, LABEL_35      
LABEL_3:
        jalr x0, x1, 0
LABEL_35:
        blt x1,x3,LABEL_4     # need to jump
        sw   x29  , 0x8(x31)  # store false
        jal x28, LABEL_5      # jump over LABEL_4
LABEL_4:
        sw   x30  , 0x8(x31)  # store true
LABEL_5:
        bge x1,x2,LABEL_6     # need to jump
        sw   x29  , 0xc(x31)  # store false
        jal x28, LABEL_7      # jump over LABEL_6
LABEL_6:
        sw   x30  , 0xc(x31)  # store true
LABEL_7:
        bltu x1,x3,LABEL_8     # need to jump
        sw   x29  , 0x10(x31)  # store false
        jal x28, LABEL_9      # jump over LABEL_8
LABEL_8:
        sw   x30  , 0x10(x31)  # store true
LABEL_9:
        bgeu x1,x2,LABEL_10     # need to jump
        sw   x29  , 0x14(x31)  # store false
        jal x28, LABEL_11      # jump over LABEL_10
LABEL_10:
        sw   x30  , 0x14(x31)  # store true
LABEL_11:
        auipc x4, 0xFFFFF
        sw   x4  , 0x18(x31)
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