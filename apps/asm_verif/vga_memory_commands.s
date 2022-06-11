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
  li    x1,  0xFFFFFFF0
  li    x30 , 0x1000    # D_MEM memory region
  li    x31 , 0x3000    # VGA_MEM memory region
  sw    x1  , 0x0(x31)  # -> FFFFFFF0h to 0x3000
  li    x1,  0xFFFFFFF1
  sw    x1  , 0x4(x31)  # -> FFFFFFF1h to 0x3004
  li    x1,  0xFFFFFFF2
  sw    x1  , 0x8(x31)  # -> FFFFFFF2h to 0x3008
  li    x1,  0xFFFFFFF3
  sw    x1  , 0xc(x31)  # -> FFFFFFF3h to 0x300c
  li    x1,  0xFFFFFFF4
  sw    x1  , 0x10(x31) # -> FFFFFFF4h to 0x3010
  li    x1,  0xFFFFFFF5
  sw    x1  , 0x14(x31) # -> FFFFFFF5h to 0x3014
  li    x1,  0xFFFFFFF6
  sw    x1  , 0x18(x31) # -> FFFFFFF6h to 0x3018
  li    x1,  0xFFFFFFF7
  sw    x1  , 0x1c(x31) # -> FFFFFFF7h to 0x301c
  li    x1,  0xFFFFFFF8
  sw    x1  , 0x20(x31) # -> FFFFFFF8h to 0x3020
  li    x1,  0xFFFFFFF9
  sw    x1  , 0x24(x31) # -> FFFFFFF9h to 0x3024

load_from_memory:
  lw    x3   , 0x0(x31)  # -> FFFFFFF0h to x3
  lw    x4   , 0x4(x31)  # -> FFFFFFF1h to x4
  lw    x5   , 0x8(x31)  # -> FFFFFFF2h to x5
  lw    x6   , 0xc(x31)  # -> FFFFFFF3h to x6
  lw    x7   , 0x10(x31) # -> FFFFFFF4h to x7
  lw    x8   , 0x14(x31) # -> FFFFFFF5h to x8
  lw    x9   , 0x18(x31) # -> FFFFFFF6h to x9
  lw    x10  , 0x1c(x31) # -> FFFFFFF7h to x10
  lw    x11  , 0x20(x31) # -> FFFFFFF8h to x11
  lw    x12  , 0x24(x31) # -> FFFFFFF9h to x12

store_results_in_D_MEM:
  sw    x3   , 0x0(x30)  # -> FFFFFFF0h to 0x00001000
  sw    x4   , 0x4(x30)  # -> FFFFFFF1h to 0x00001004
  sw    x5   , 0x8(x30)  # -> FFFFFFF2h to 0x00001008
  sw    x6   , 0xc(x30)  # -> FFFFFFF3h to 0x0000100c
  sw    x7   , 0x10(x30) # -> FFFFFFF4h to 0x00001010
  sw    x8   , 0x14(x30) # -> FFFFFFF5h to 0x00001014
  sw    x9   , 0x18(x30) # -> FFFFFFF6h to 0x00001018
  sw    x10  , 0x1c(x30) # -> FFFFFFF7h to 0x0000101C
  sw    x11  , 0x20(x30) # -> FFFFFFF8h to 0x00001020
  sw    x12  , 0x24(x30) # -> FFFFFFF9h to 0x00001024

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
