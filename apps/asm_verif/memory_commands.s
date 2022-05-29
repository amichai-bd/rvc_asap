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
  li    x1,  0xFAFAFAFA
  li    x2,  0xBCBCBCBC
  li    x3,  0
  li    x4,  0
  li    x5,  0
  li    x6,  0
  li    x7,  0
  li    x31 , 0x1000
  sw    x1  , 0x0(x31) # -> FAFAFAFAh
  sh    x1  , 0x4(x31) # -> 0000FAFAh
  sb    x1  , 0x9(x31) # -> 0000FA00h
  sh    x2  , 0x0(x31) # -> FAFABCBCh
  lh    x3  , 0x0(x31) # -> FFFFBCBCh
  lb    x4  , 0x0(x31) # -> FFFFFFBCh
  lhu   x5  , 0x0(x31) # -> 0000BCBCh
  lbu   x6  , 0x0(x31) # -> 000000BCh
  lui   x7  , 0xFAFAF  # -> FAFAF000h
  
load_from_memory:
    lw   x17 , 0x20(x31)
    lw   x18 , 0x24(x31)
    lw   x19 , 0x28(x31)
    lw   x20 , 0x2c(x31)
    lw   x21 , 0x30(x31)
    lw   x22 , 0x34(x31)
    lw   x23 , 0x38(x31)
    lw   x24 , 0x3c(x31)
    lw   x25 , 0x40(x31)
    lw   x26 , 0x44(x31)
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
