//-----------------------------------------------------------------------------
// Title            : riscv as-fast-as-possible 
// Project          : rvc_asap
//-----------------------------------------------------------------------------
// File             : graphic_screen_api.h 
// Original Author  : Gil Ya'akov
// Code Owner       : 
// Adviser          : Amichai Ben-David
// Created          : 06/2022
//-----------------------------------------------------------------------------
// Description : This API provides a convenient and efficient way to 
//               interface with the VGA screen. The API 
//               provides Several functions that allow the use of 
//               standard screen output and advanced graphics.

#ifndef GRAPHIC_SCREEN_API_H
#define GRAPHIC_SCREEN_API_H
#define WRITE_REG(REG,VAL) (*REG) = VAL
#define READ_REG(VAL,REG)  VAL    = (*REG)
#define VGA_PTR(PTR,OFF)   PTR    = (volatile int *) (VGA_MEM_BASE + OFF)

/* Control registers addresses */
#define CR_MEM_BASE 0x00002000
#define CR_CURSOR_H (volatile int *) (CR_MEM_BASE + 0x2c)
#define CR_CURSOR_V (volatile int *) (CR_MEM_BASE + 0x28)

/* VGA defines */
#define VGA_MEM_BASE       0x00003000
#define VGA_MEM_SIZE_BYTES 38400
#define VGA_MEM_SIZE_WORDS 9600
#define LINE               320
#define BYTES              4
#define COLUMN             80 /* COLUMN between 0 - 79 (80x60) */
#define RAWS               60 /* RAWS between 0 - 59 (80x60) */

/* ASCII tables addresses */
#define ASCII_TOP_BASE    ((volatile int *) 0x00002100)
#define ASCII_BOTTOM_BASE ((volatile int *) 0x00002300)

/* ANIME tables addresses */
#define ANIME_TOP_BASE    ((volatile int *) 0x00002500)
#define ANIME_BOTTOM_BASE ((volatile int *) 0x00002600)

/* This function print a char note on the screen in (raw,col) position */
void draw_char(char note, int raw, int col);

/* This function print a symbol from anime table on the screen in (raw,col) position */
void draw_symbol(int symbol, int raw, int col);

/* This function print a string on the screen in (CR_CURSOR_V,CR_CURSOR_H) position */
void rvc_printf(const char *c);

/* This function clear the screen */
void clear_screen();

#endif /* GRAPHIC_SCREEN_API_H */

/*** end of file ***/