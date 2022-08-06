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
  li    x31 , 0x3000   # VGA_MEM base address

  # First Line
  li    x1 , 0b00111111001100110011001100000000
  sw    x1  , 0x4(x31)
  li    x1 , 0b00011111000000110011111100000000
  sw    x1  , 0x8(x31)
  li    x1 , 0b00000011000000110000001100000000
  sw    x1  , 0xc(x31)
  li    x1 , 0b00000011000000110000001100000000
  sw    x1  , 0x10(x31)
  li    x1 , 0b00110011001100110001111000000000
  sw    x1  , 0x14(x31)

  # Seconed Line
  li    x1 , 0b00000000001100110011001100110011
  sw    x1  , 0x144(x31)
  li    x1 , 0b00000000001111110000001100000011
  sw    x1  , 0x148(x31)
  li    x1 , 0b00000000001111110000001100000011
  sw    x1  , 0x14c(x31)
  li    x1 , 0b00000000001111110000001100000011
  sw    x1  , 0x150(x31)
  li    x1 , 0b00000000000111100011001100110011
  sw    x1  , 0x154(x31)

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

# Expected output:
# 00000000 00000000 00000000 00000000 00000000 00000000
# 00000000 **00**00 ******00 **000000 **000000 0****000
# 00000000 **00**00 **000000 **000000 **000000 **00**00
# 00000000 ******00 *****000 **000000 **000000 **00**00
# 00000000 **00**00 **000000 **000000 **000000 **00**00
# 00000000 **00**00 **000000 **000000 **000000 **00**00 
# 00000000 **00**00 ******00 ******00 ******00 0****000
# 00000000 00000000 00000000 00000000 00000000 00000000