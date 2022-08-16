#include "../defines/rvc_defines.h"
#include "../defines/graphic_screen.h"

/* This function print a char note on the screen in (raw,col) position */
void draw_char(char note, int raw, int col)
{
    unsigned int vertical   = raw * LINE;
    unsigned int horizontal = col * BYTES;
    volatile int *ptr_top;
    volatile int *ptr_bottom;

    VGA_PTR(ptr_top    , horizontal + vertical);
    VGA_PTR(ptr_bottom , horizontal + vertical + LINE);

    WRITE_REG(ptr_top    , ASCII_TOP[note]);
    WRITE_REG(ptr_bottom , ASCII_BOTTOM[note]);
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
    unsigned int vertical   = raw * (2*LINE);
    unsigned int horizontal = col * BYTES;
    volatile int *ptr_top;
    volatile int *ptr_bottom;

    VGA_PTR(ptr_top    , horizontal + vertical);
    VGA_PTR(ptr_bottom , horizontal + vertical + LINE);

    WRITE_REG(ptr_top    , ANIME_TOP[symbol]);
    WRITE_REG(ptr_bottom , ANIME_BOTTOM[symbol]);
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

void set_cursor(int raw, int col)
{
    WRITE_REG(CR_CURSOR_H, col);
    WRITE_REG(CR_CURSOR_V, raw);
}

void draw_horizontal_line(int start, int end, int raw)
{
    for(int i = start ; i < (end + 1) ; i++)
    {
        draw_symbol(5, raw, i);
    }
}

void clear_horizontal_line(int start, int end, int raw)
{
    for(int i = start ; i < (end + 1) ; i++)
    {
        draw_symbol(6, raw, i);
    }
}

void draw_vertical_line(int start, int end, int col)
{
    for(int i = start ; i < (end + 1) ; i++)
    {
        draw_symbol(5, i, col);
    }
}

struct point {
    int pos_x;
    int pos_y;
};

struct game_tool {
    struct point center;
    int start;
    int end;
};

void set_gt(struct game_tool *gt, int pos_x, int pos_y) 
{
    gt->center.pos_x = pos_x;
    gt->center.pos_y = pos_y;
    gt->start = pos_x - 5;
    gt->end   = pos_x + 5;
}

void display(struct game_tool gt) 
{
    draw_horizontal_line(gt.start,gt.end,gt.center.pos_y);
}

void clear(struct game_tool gt) 
{
    clear_horizontal_line(gt.start,gt.end,gt.center.pos_y);
}

void move_left(struct game_tool *gt)
{
    if((gt->start - 1) == 0){
        return;
    }
    else{
        set_gt(gt, gt->center.pos_x - 1, gt->center.pos_y);
    }
}

void move_right(struct game_tool *gt)
{
    if((gt->end + 1) == 60){
        return;
    }
    else{
        set_gt(gt, gt->center.pos_x + 1, gt->center.pos_y);
    }
}

void delay(int num) {
    int counter = 0;
    int i = 0;
    for (int i = 0; i < num; i++){counter++;}
    return;
}

int main() {

    clear_screen();

    /* Create the board game */
    draw_horizontal_line(0, 79, 0);
    draw_horizontal_line(0, 79, 59);
    draw_vertical_line(0,59, 0);
    draw_vertical_line(0,59, 79);
    draw_vertical_line(0,59, 60);
    set_cursor(15, 63);
    rvc_printf("BREAKOUT GAME");
    draw_horizontal_line(60, 79, 15);
    set_cursor(45, 63);
    rvc_printf("SCORE");
    set_cursor(55, 63);
    rvc_printf("LEVEL");
    set_cursor(65, 63);
    rvc_printf("HIGHEST SCORE");

    /* Initialize game tool and keys */
    struct game_tool gt;
    set_gt(&gt, 30, 57);
    int left = 0;
    int right = 0;
   while(1){
    left     = *CR_Button_1;
    right    = *CR_Button_0;

    clear(gt);

    if(left){
        move_left(&gt);
        right = 0;
    }

    if(right){
        move_right(&gt);
        left = 0;
    }

    display(gt);
    delay(200000);

   }

    return 0;
}