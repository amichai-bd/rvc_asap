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
void draw_char(char note, int raw, int col)
{
    unsigned int vertical   = raw * LINE;
    unsigned int horizontal = col * BYTES;
    volatile int *ptr_top;
    volatile int *ptr_bottom;

    VGA_PTR(ptr_top    , horizontal + vertical);
    VGA_PTR(ptr_bottom , horizontal + vertical + LINE);

    WRITE_REG(ptr_top    , ASCII_TOP_BASE[note]);
    WRITE_REG(ptr_bottom , ASCII_BOTTOM_BASE[note]);
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
        if(c[i] == '\n') /* End of line */
        {
            col = 0;
            raw = raw + 2 ;
            if(raw == (RAWS * 2)) /* End of screen */
            {
                raw = 0;
            }
            i++;
            continue;
        }

        draw_char(c[i], raw, col);
        col++;
        if(col == COLUMN) /* End of line */
        {
            col = 0;
            raw = raw + 2 ;
            if(raw == (RAWS * 2)) /* End of screen */
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

/* This function print a symbol from anime table on the screen in (raw,col) position */
void draw_symbol(int symbol, int raw, int col)
{
    unsigned int vertical   = raw * LINE;
    unsigned int horizontal = col * BYTES;
    volatile int *ptr_top;
    volatile int *ptr_bottom;

    VGA_PTR(ptr_top    , horizontal + vertical);
    VGA_PTR(ptr_bottom , horizontal + vertical + LINE);

    WRITE_REG(ptr_top    , ANIME_TOP_BASE[symbol]);
    WRITE_REG(ptr_bottom , ANIME_BOTTOM_BASE[symbol]);
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
    int i = 0;

    for(i = 0 ; i < 1 ; i++)
    {
        rvc_printf("WE ARE THE PEOPLE THAT RULE THE WORLD.\n");
        rvc_printf("A FORCE RUNNING IN EVERY BOY AND GIRL.\n");
        rvc_printf("ALL REJOICING IN THE WORLD, TAKE ME NOW WE CAN TRY.\n");
        rvc_printf("0123456789\n");
    }

    draw_symbol(1, 10, 15);
    draw_symbol(2, 10, 16);
    draw_symbol(3, 10, 17);
    draw_symbol(4, 10, 18);
    draw_symbol(5, 10, 19);

    return 0;
}