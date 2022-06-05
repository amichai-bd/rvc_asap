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
  li    x1,  0xFFFFFFFF
  li    x30 , 0x1000    # D_MEM memory region
  li    x31 , 0x2000    # CR memory region
  sw    x1  , 0x0(x31)  # -> FFFFFFFFh to CR_SEG7_0
  sw    x1  , 0x4(x31)  # -> FFFFFFFFh to CR_SEG7_1
  sw    x1  , 0x8(x31)  # -> FFFFFFFFh to CR_SEG7_2
  sw    x1  , 0xc(x31)  # -> FFFFFFFFh to CR_SEG7_3
  sw    x1  , 0x10(x31) # -> FFFFFFFFh to CR_SEG7_4
  sw    x1  , 0x14(x31) # -> FFFFFFFFh to CR_SEG7_5
  sw    x1  , 0x18(x31) # -> FFFFFFFFh to LED
  # Don't need to work because it is just read only memory
  sw    x1  , 0x1c(x31) # -> FFFFFFFFh to CR_Button_0
  sw    x1  , 0x20(x31) # -> FFFFFFFFh to CR_Button_1
  sw    x1  , 0x24(x31) # -> FFFFFFFFh to CR_Swith

load_from_memory:
  lw    x3   , 0x0(x31)  # -> 0000007Fh to x3
  lw    x4   , 0x4(x31)  # -> 0000007Fh to x4
  lw    x5   , 0x8(x31)  # -> 0000007Fh to x5
  lw    x6   , 0xc(x31)  # -> 0000007Fh to x6
  lw    x7   , 0x10(x31) # -> 0000007Fh to x7
  lw    x8   , 0x14(x31) # -> 0000007Fh to x8
  lw    x9   , 0x18(x31) # -> 0000007Fh to x9
  # Don't need to work because it is just read only memory
  lw    x10  , 0x1c(x31) # -> 0000000Xh to x10
  lw    x11  , 0x20(x31) # -> 0000000Xh to x11
  lw    x12  , 0x24(x31) # -> XXXXXXXXh to x12

store_results_in_D_MEM:
  sw    x3   , 0x0(x30)  # -> 0000007Fh to 0x00001000
  sw    x4   , 0x4(x30)  # -> 0000007Fh to 0x00001004
  sw    x5   , 0x8(x30)  # -> 0000007Fh to 0x00001008
  sw    x6   , 0xc(x30)  # -> 0000007Fh to 0x0000100c
  sw    x7   , 0x10(x30) # -> 0000007Fh to 0x00001010
  sw    x8   , 0x14(x30) # -> 0000007Fh to 0x00001014
  sw    x9   , 0x18(x30) # -> 0000007Fh to 0x00001018
  sw    x10  , 0x1c(x30) # -> XXXXXXXXh to 0x0000101C
  sw    x11  , 0x20(x30) # -> XXXXXXXXh to 0x00001020
  sw    x12  , 0x24(x30) # -> XXXXXXXXh to 0x00001024

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
