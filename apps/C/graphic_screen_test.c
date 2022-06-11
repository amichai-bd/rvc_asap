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

/* ASCII table */
#define H        0x48
#define E        0x45
#define L        0x4C
#define O        0x4F
/* Letters */
#define H_TOP    0b00111111001100110011001100000000
#define H_BOTTOM 0b00000000001100110011001100110011

#define E_TOP    0b00011111000000110011111100000000
#define E_BOTTOM 0b00000000001111110000001100000011

#define L_TOP    0b00000011000000110000001100000000
#define L_BOTTOM 0b00000000001111110000001100000011

#define O_TOP    0b00110011001100110001111000000000
#define O_BOTTOM 0b00000000000111100011001100110011

/* This function print a char note on the screen in (raw,col) position */
void draw_char(char note, int raw, int col)
{
    unsigned int vertical   = raw * 320;
    unsigned int horizontal = col * 4;
    volatile int *ptr_top;
    volatile int *ptr_bottom;
    VGA_PTR(ptr_top    , horizontal + vertical);
    VGA_PTR(ptr_bottom , horizontal + vertical + 320);

    switch (note)
    {
    case H:
        WRITE_REG(ptr_top    , H_TOP);
        WRITE_REG(ptr_bottom , H_BOTTOM);
        break;

    case E:
        WRITE_REG(ptr_top    , E_TOP);
        WRITE_REG(ptr_bottom , E_BOTTOM);
        break;

    case L:
        WRITE_REG(ptr_top    , L_TOP);
        WRITE_REG(ptr_bottom , L_BOTTOM);
        break;
    case O:
        WRITE_REG(ptr_top    , O_TOP);
        WRITE_REG(ptr_bottom , O_BOTTOM);
        break;
    default:
        break;
    }
}

/* This function print a string on the screen in (CR_CURSOR_V,CR_CURSOR_H) position */
void rvc_printf(const char *c)
{
    int i = 0;
    unsigned int raw = 0;
    unsigned int col = 0;

    READ_REG(col,CR_CURSOR_H);
    READ_REG(raw,CR_CURSOR_V);

    while(c[i] != '\0')
    {
        draw_char(c[i], raw, col);
        col++;
        if(col == 80) /* End of line */
        {
            col = 0;
            raw = raw + 2 ;
            if(raw == 120) /* End of screen */
            {
                raw = 0;
            }
        }
        i++;
    }
    
    /* Update CR_CURSOR */
    WRITE_REG(CR_CURSOR_H, col);
    WRITE_REG(CR_CURSOR_V, raw);
}

/* This function clear the screen */
void clear_screen()
{
    int i = 0;
    volatile int *ptr;
    VGA_PTR(ptr , 0);
    for(i = 0 ; i < VGA_MEM_SIZE_WORDS ; i++)
    {
        ptr[i] = 0;
    }
}

int main()
{
    //clear_screen();          // TO DO: insert it as part of crt0
    WRITE_REG(CR_CURSOR_H, 0); // TO DO: insert it as part of crt0
    WRITE_REG(CR_CURSOR_V, 0); // TO DO: insert it as part of crt0
    int i = 0;

    for(i = 0 ; i < 960 ; i++)
    {
        rvc_printf("HELLO");
    }
    return 0;
}