_start:
  .global _start
  .section .vectors, "ax"
  .option norvc;
  .org 0x00
  nop
  nop
  nop
  nop
  nop
  .org 0x14
  jal x0, reset_handler

# Resets
reset_handler:
  li  x31 , 0x2028 # CR_CURSOR_H Address
  mv  x1, x0
  sw  x1  , 0x0(x31) # Reset CR_CURSOR_H
  sw  x1  , 0x4(x31) # Reset CR_CURSOR_V
  li  x2, 0x00001E00 # Stack pointer
  mv  x3, x1
  mv  x4, x1
  mv  x5, x1
  mv  x6, x1
  mv  x7, x1
  mv  x8, x1
  mv  x9, x1
  mv x10, x1
  mv x11, x1
  mv x12, x1
  mv x13, x1
  mv x14, x1
  mv x15, x1
  mv x16, x1
  mv x17, x1
  mv x18, x1
  mv x19, x1
  mv x20, x1
  mv x21, x1
  mv x22, x1
  mv x23, x1
  mv x24, x1
  mv x25, x1
  mv x26, x1
  mv x27, x1
  mv x28, x1
  mv x29, x1
  mv x30, x1
  mv x31, x1
  jal x1, main
  ebreak
.section .text
