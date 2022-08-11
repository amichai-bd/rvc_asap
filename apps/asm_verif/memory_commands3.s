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
    addi x16, x1, 0
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
    li x1, 0x4000
    li x2, 0x04030201
    li x3, 0xF0E0D0B0
    li x4, 0x4004 # Results

    sw x3   , 0x0(x1) # 0x4000 F0E0D0B0 
    lw x10  , 0x0(x1) # F0E0D0B0
    lh x11  , 0x0(x1) # FFFFD0B0
    lb x12  , 0x0(x1) # FFFFFFB0
    lhu x13 , 0x0(x1) # 0000D0B0
    lbu x14 , 0x0(x1) # 000000B0

    sw x10 , 0x0(x4)  # 0x4004 F0E0D0B0
    sw x11 , 0x4(x4)  # 0x4008 FFFFD0B0
    sw x12 , 0x8(x4)  # 0x400c FFFFFFB0
    sw x13 , 0xc(x4)  # 0x4010 0000D0B0
    sw x14 , 0x10(x4) # 0x4014 000000B0

    lh x11  , 0x1(x1) # FFFFE0D0
    lb x12  , 0x1(x1) # FFFFFFD0
    lhu x13 , 0x1(x1) # 0000E0D0
    lbu x14 , 0x1(x1) # 000000D0

    sw x11 , 0x14(x4) # 0x4018 FFFFE0D0
    sw x12 , 0x18(x4) # 0x401c FFFFFFD0
    sw x13 , 0x1c(x4) # 0x4020 0000E0D0
    sw x14 , 0x20(x4) # 0x4024 000000D0

    lh x11  , 0x2(x1) # FFFFF0E0
    lb x12  , 0x2(x1) # FFFFFFE0
    lhu x13 , 0x2(x1) # 0000F0E0
    lbu x14 , 0x2(x1) # 000000E0

    sw x11 , 0x24(x4) # 0x4028 FFFFF0E0
    sw x12 , 0x28(x4) # 0x402c FFFFFFE0
    sw x13 , 0x2c(x4) # 0x4030 0000F0E0
    sw x14 , 0x30(x4) # 0x4034 000000E0

    lh x11  , 0x3(x1) # FFFFFFF0
    lb x12  , 0x3(x1) # FFFFFFF0
    lhu x13 , 0x3(x1) # FFFFFFF0
    lbu x14 , 0x3(x1) # FFFFFFF0

    sw x11 , 0x34(x4) # 0x4038 FFFFFFF0
    sw x12 , 0x38(x4) # 0x403c FFFFFFF0
    sw x13 , 0x3c(x4) # 0x4040 000000F0
    sw x14 , 0x40(x4) # 0x4044 000000F0

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