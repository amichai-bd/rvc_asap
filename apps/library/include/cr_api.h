//-----------------------------------------------------------------------------
// Title            : riscv as-fast-as-possible 
// Project          : rvc_asap
//-----------------------------------------------------------------------------
// File             : cr_api.h 
// Original Author  : Gil Ya'akov
// Code Owner       : 
// Adviser          : Amichai Ben-David
// Created          : 06/2022
//-----------------------------------------------------------------------------
// Description : This API provides a convenient and efficient way to 
//               interface with the FPGA control registers. The API 
//               provides write and read functions for all control registers.

#ifndef CR_API_H
#define CR_API_H
#define WRITE_REG(REG,VAL) (*REG) = VAL
#define READ_REG(VAL,REG)  VAL    = (*REG)

/* Control registers addresses */
#define CR_MEM_BASE 0x00002000
#define CR_SEG7_0   (volatile int *) (CR_MEM_BASE + 0x0)
#define CR_SEG7_1   (volatile int *) (CR_MEM_BASE + 0x4)
#define CR_SEG7_2   (volatile int *) (CR_MEM_BASE + 0x8)
#define CR_SEG7_3   (volatile int *) (CR_MEM_BASE + 0xc)
#define CR_SEG7_4   (volatile int *) (CR_MEM_BASE + 0x10)
#define CR_SEG7_5   (volatile int *) (CR_MEM_BASE + 0x14)
#define CR_LED      (volatile int *) (CR_MEM_BASE + 0x18)
#define CR_Button_0 (volatile int *) (CR_MEM_BASE + 0x1c)
#define CR_Button_1 (volatile int *) (CR_MEM_BASE + 0x20)
#define CR_Switch   (volatile int *) (CR_MEM_BASE + 0x24)

/* Control registers API functions */
/* Write functions */
void cr_seg7_0_write(unsigned int val);
void cr_seg7_1_write(unsigned int val);
void cr_seg7_2_write(unsigned int val);
void cr_seg7_3_write(unsigned int val);
void cr_seg7_4_write(unsigned int val);
void cr_seg7_5_write(unsigned int val);
void cr_led_write(unsigned int val);

/* Read functions */
int cr_seg7_0_read();
int cr_seg7_1_read();
int cr_seg7_2_read();
int cr_seg7_3_read();
int cr_seg7_4_read();
int cr_seg7_5_read();
int cr_led_read();
int cr_button_0_read();
int cr_button_1_read();
int cr_switch_read();

#endif /* CR_API_H */

/*** end of file ***/