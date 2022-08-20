#include "../defines/rvc_defines.h"
#include "../defines/graphic_screen.h"

#define UP_WALL     0
#define LEFT_WALL   0
#define RIGHT_WALL  60
#define BOTTOM_WALL 59

/* This function print a char note on the screen in (raw,col) position */
void draw_char(char note, int raw, int col) {
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
void rvc_printf(const char *c) {
    int i = 0;
    unsigned int raw = 0;
    unsigned int col = 0;

    READ_REG(col,CR_CURSOR_H);
    READ_REG(raw,CR_CURSOR_V);

    while(c[i] != '\0') {
        if(c[i] == '\n') {/* End of line */
            col = 0;
            raw = raw + 2 ;
            if(raw == (RAWS * 2)) { /* End of screen */
                raw = 0;
            }
            i++;
            continue;
        }

        draw_char(c[i], raw, col);
        col++;
        if(col == COLUMN) {/* End of line */
            col = 0;
            raw = raw + 2 ;
            if(raw == (RAWS * 2)) {/* End of screen */
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
void draw_symbol(int symbol, int raw, int col) {
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
void clear_screen() {
    int i = 0;
    volatile int *ptr;
    VGA_PTR(ptr , 0);
    for(i = 0 ; i < VGA_MEM_SIZE_WORDS ; i++) {
        ptr[i] = 0;
    }
}

void set_cursor(int raw, int col) {
    WRITE_REG(CR_CURSOR_H, col);
    WRITE_REG(CR_CURSOR_V, raw);
}

void draw_horizontal_line(short int start, short int end, short int raw) {
    for(short int i = start ; i < (end + 1) ; i++) {
        draw_symbol(5, raw, i);
    }
}

void clear_horizontal_line(short int start, short int end, short int raw) {
    for(short int i = start ; i < (end + 1) ; i++) {
        draw_symbol(6, raw, i);
    }
}

void draw_vertical_line(short int start, short int end, short int col) {
    for(short int i = start ; i < (end + 1) ; i++) {
        draw_symbol(5, i, col);
    }
}

struct point {
    short int pos_x;
    short int pos_y;
};

struct game_tool {
    struct point center;
    short int    start;
    short int    end;
    short int    size;
};

typedef enum {TL,TR,BR,BL} State;

struct Ball {
    struct point center;
    State        s;
};

struct Brick {
    short int    display;
};

struct Brick_arr {                   // 56 * 59
    struct Brick arr[56][59];        // (1,1)   (1,59)
                                     // (56,1)  (56,59)
    short int    max_line;
    short int    max_column;
    short int    current_border;
};

void init_Brick_arr(struct Brick_arr *ba) {
    ba->max_line       = 56;
    ba->max_column     = 59;
    ba->current_border = 15;
    for(short int i = 1; i <= ba->max_line; i++) {
        for(short int j = 1; j <= ba->max_column; j++) {
            if(i <= ba->current_border)
                ba->arr[i][j].display = 1;
            else
                ba->arr[i][j].display = 0;
        }
    }
}

void display_Brick_arr(struct Brick_arr *ba, struct Ball *b) {
    for(short int i = 1; i <= ba->current_border; i++) {
        for(short int j = 1; j <= ba->max_column; j++) {
            if((i != b->center.pos_y) && (j != b->center.pos_x)) {
                if(ba->arr[i][j].display) {
                    draw_symbol(8, i, j);
                }
                else {
                    draw_symbol(6, i, j);
                }
            }
        }
    }
}

void init_ball(struct Ball *b, short int pos_x, short int pos_y) {
    b->center.pos_x = pos_x;
    b->center.pos_y = pos_y;
    b->s = BR;
}

void delay(int num) {
    int counter = 0;
    int i = 0;
    for (int i = 0; i < num; i++){counter++;}
    return;
}

short int check_brick(struct Brick_arr *ba, short int pos_y, short int pos_x) {
    if(((pos_y <= ba->current_border) && (pos_y >= 1)) && ((pos_x <= 59) && (pos_x >= 1))) {
        return ba->arr[pos_y][pos_x].display;
    }
    return 0;
}

void clear_brick(struct Brick_arr *ba, short int pos_y, short int pos_x) {
    if(((pos_y <= 56) && (pos_y >= 1)) && ((pos_x <= 59) && (pos_x >= 1))) {
        ba->arr[pos_y][pos_x].display = 0;
    }
    return;
}

static short int score         = 0;
static short int highest_score = 0;
static short int level         = 1;
static short int level_counter = 0;

void set_position(struct Ball *b) {
    switch (b->s) {
    case TL:
        b->center.pos_x -= 1;
        b->center.pos_y -= 1;
        break;
    case TR:
        b->center.pos_x += 1;
        b->center.pos_y -= 1;
        break;
    case BL:
        b->center.pos_x -= 1;
        b->center.pos_y += 1;
        break;
    case BR:
        b->center.pos_x += 1;
        b->center.pos_y += 1;
        break;
    
    default:
        break;
    }

    return;
}
              
short int check_hit(struct Ball *b, struct Brick_arr *ba) {//  n0   n1   n2
                                                           //  n3  Ball  n5
                                                           //  n6   n7   n8
    short int pos_x = b->center.pos_x - 1;
    short int pos_y = b->center.pos_y - 1;
    short int n0 = check_brick(ba,(pos_y + 0),(pos_x + 0));
    short int n1 = check_brick(ba,(pos_y + 0),(pos_x + 1));
    short int n2 = check_brick(ba,(pos_y + 0),(pos_x + 2));
    short int n3 = check_brick(ba,(pos_y + 1),(pos_x + 0));
    short int n5 = check_brick(ba,(pos_y + 1),(pos_x + 2));
    short int n6 = check_brick(ba,(pos_y + 2),(pos_x + 0));
    short int n7 = check_brick(ba,(pos_y + 2),(pos_x + 1));
    short int n8 = check_brick(ba,(pos_y + 2),(pos_x + 2));
    short int result = 0;

    switch (b->s) {
        case TL:
                if(n1 && n3) {
                    b->s = BR;
                    clear_brick(ba, pos_y, pos_x + 1);
                    clear_brick(ba, pos_y + 1, pos_x);
                    result = 1;
                    break;             
                }
                if(n1 && (b->center.pos_x - 1 != LEFT_WALL)) {
                    clear_brick(ba, pos_y, pos_x + 1);
                    b->s = BL;
                    result = 1;
                    break;             
                }
                if(n1 && (b->center.pos_x - 1 == LEFT_WALL)) {
                    clear_brick(ba, pos_y, pos_x + 1);
                    b->s = BR;
                    result = 1;
                    break;             
                }
                if(n3 && (b->center.pos_y - 1 != UP_WALL)) {
                    clear_brick(ba, pos_y + 1, pos_x);
                    b->s = TR;
                    result = 1;
                    break;             
                }
                if(n3 && (b->center.pos_y - 1 == UP_WALL)) {
                    clear_brick(ba, pos_y + 1, pos_x);
                    b->s = BR;
                    result = 1;
                    break;             
                }
                if(n0) {
                    clear_brick(ba, pos_y, pos_x);
                    b->s = BR;
                    result = 1;
                    break;             
                }
                if(n6 && (b->center.pos_y - 1 == UP_WALL)) {
                    clear_brick(ba, pos_y + 2, pos_x + 0);
                    b->s = BR;
                    result = 1;
                    break;                    
                }
                if(n2 && (b->center.pos_x - 1 == LEFT_WALL)) {
                    clear_brick(ba, pos_y, pos_x + 2);
                    b->s = BR;
                    result = 1;
                    break;             
                }
            break;
        case TR:
                if(n1 && n5) {
                    b->s = BL;
                    clear_brick(ba, pos_y, pos_x + 1);
                    clear_brick(ba, pos_y + 1, pos_x + 2);
                    result = 1;
                    break;             
                }
                if(n1 && (b->center.pos_x + 1 != RIGHT_WALL)) {
                    clear_brick(ba, pos_y, pos_x + 1);
                    b->s = BR;
                    result = 1;
                    break;             
                }
                if(n1 && (b->center.pos_x + 1 == RIGHT_WALL)) {
                    clear_brick(ba, pos_y, pos_x + 1);
                    b->s = BL;
                    result = 1;
                    break;             
                }
                if(n5 && (b->center.pos_y - 1 != UP_WALL)) {
                    clear_brick(ba, pos_y + 1, pos_x + 2);
                    b->s = TL;
                    result = 1;
                    break;             
                }
                if(n5 && (b->center.pos_y - 1 == UP_WALL)) {
                    clear_brick(ba, pos_y + 1, pos_x + 2);
                    b->s = BL;
                    result = 1;
                    break;             
                }
                if(n2) {
                    clear_brick(ba, pos_y, pos_x + 2);
                    b->s = BL;
                    result = 1;
                    break;             
                }
                if(n8 && (b->center.pos_y - 1 == UP_WALL)) {
                    clear_brick(ba, pos_y + 2, pos_x + 2);
                    b->s = BL;
                    result = 1;
                    break;                    
                }
                if(n0 && (b->center.pos_x + 1 == RIGHT_WALL)) {
                    clear_brick(ba, pos_y, pos_x);
                    b->s = BL;
                    result = 1;
                    break;             
                }
            break;
        case BL:
                if(n3 && n7) {
                    b->s = TR;
                    clear_brick(ba, pos_y + 1, pos_x);
                    clear_brick(ba, pos_y + 2, pos_x + 1);
                    result = 1;
                    break;             
                }
                if(n3) {
                    clear_brick(ba, pos_y + 1, pos_x);
                    b->s = BR;
                    result = 1;
                    break;             
                }
                if(n7 && (b->center.pos_x - 1 != LEFT_WALL)) {
                    clear_brick(ba, pos_y + 2, pos_x + 1);
                    b->s = TL;
                    result = 1;
                    break;             
                }
                if(n7 && (b->center.pos_x - 1 == LEFT_WALL)) {
                    clear_brick(ba, pos_y + 2, pos_x + 1);
                    b->s = TR;
                    result = 1;
                    break;             
                }
                if(n6) {
                    clear_brick(ba, pos_y + 2, pos_x);
                    b->s = TR;
                    result = 1;
                    break;             
                }
                if(n8 && (b->center.pos_x - 1 == LEFT_WALL)) {
                    clear_brick(ba, pos_y + 2, pos_x + 2);
                    b->s = TR;
                    result = 1;
                    break;                    
                }
            break;
        case BR:
                if(n5 && n7) {
                    b->s = TL;
                    clear_brick(ba, pos_y + 1, pos_x + 2);
                    clear_brick(ba, pos_y + 2, pos_x + 1);
                    result = 1;
                    break;             
                }
                if(n5) {
                    clear_brick(ba, pos_y + 1, pos_x + 2);
                    b->s = BL;
                    result = 1;
                    break;             
                }
                if(n7 && (b->center.pos_x + 1 != RIGHT_WALL)) {
                    clear_brick(ba, pos_y + 2, pos_x + 1);
                    b->s = TR;
                    result = 1;
                    break;             
                }
                if(n7 && (b->center.pos_x + 1 == RIGHT_WALL)) {
                    clear_brick(ba, pos_y + 2, pos_x + 1);
                    b->s = TL;
                    result = 1;
                    break;             
                }
                if(n8) {
                    clear_brick(ba, pos_y + 2, pos_x + 2);
                    b->s = TL;
                    result = 1;
                    break;             
                }
                if(n6 && (b->center.pos_x + 1 == RIGHT_WALL)) {
                    clear_brick(ba, pos_y + 2, pos_x + 0);
                    b->s = TL;
                    result = 1;
                    break;                    
                }
            break;
        default:
            break;
    }

    if(result) {
        draw_symbol(6, b->center.pos_y, b->center.pos_x);
        set_position(b);
        draw_symbol(7, b->center.pos_y, b->center.pos_x);
        score++;
        return 1;
    }

    return 0; // No hit
}

short int set_next_state(struct Ball *b, struct game_tool *gt ,struct Brick_arr *ba) {
    short int pos_x    = b->center.pos_x;
    short int pos_y    = b->center.pos_y;
    short int gt_start = gt->start;
    short int gt_end   = gt->end;
    short int gt_y     = gt->center.pos_y;
    short int gt_x     = gt->center.pos_x;

    switch(b->s) { 
        case TL: 
                /* Corner */
                if (((pos_x - 1) == LEFT_WALL) && ((pos_y - 1) == UP_WALL)) {
                    b->s = BR;
                    break;                
                }
                /* Wall from left */
                if (((pos_x - 1) == LEFT_WALL)) {
                    b->s = TR;
                    break;                
                }
                /* Wall from up */
                if (((pos_y - 1) == UP_WALL)) {
                    b->s = BL;
                    break;                
                }
                /* No obstcale */
                b->s = TL;
            break;
        case TR:
                /* Corner */
                if (((pos_x + 1) == RIGHT_WALL) && ((pos_y - 1) == UP_WALL)) {
                    b->s = BL;
                    break;                
                }
                /* Wall from right */
                if (((pos_x + 1) == RIGHT_WALL)) {
                    b->s = TL;
                    break;                
                }
                /* Wall from up */
                if (((pos_y - 1) == UP_WALL)) {
                    b->s = BR;
                    break;                
                }
                /* No obstcale */
                b->s = TR;
            break;
        case BR:
                /* Corner */
                if (((pos_x + 1) == RIGHT_WALL) && ((pos_y + 1) == gt_y) && ((gt_end + 1) == RIGHT_WALL)) {
                    draw_symbol(6, b->center.pos_y, b->center.pos_x);
                    b->center.pos_x = 30;
                    b->center.pos_y = 30;
                    draw_symbol(7, b->center.pos_y, b->center.pos_x);
                    b->s = TR;
                    return 0;
                    break;            
                }
                /* Wall from right */
                if (((pos_x + 1) == RIGHT_WALL) && !((pos_y + 1) == gt_y)) {
                    b->s = BL;
                    break;                
                }
                /* Wall from down gt exists */
                if (((pos_y + 1) == gt_y) && (pos_x <= gt_end) && (gt_start <= pos_x + 1)) {
                    if(pos_x < (gt_x - 2)) {
                        b->s = TL;
                    }
                    else {
                        b->s = TR;
                    }
                    break;                
                }
                /* Wall from down gt not exists */
                if (((pos_y + 1) == gt_y) && (!((pos_x <= gt_end) && (pos_x + 1 >= gt_start)))) {
                    return 1;
                    break;                
                }
                /* No obstcale */
                b->s = BR;
            break;
        case BL:
                /* Corner */
                if (((pos_x - 1) == LEFT_WALL) && ((pos_y + 1) == gt_y) && ((gt_start - 1) == LEFT_WALL)) {
                    draw_symbol(6, b->center.pos_y, b->center.pos_x);
                    b->center.pos_x = 30;
                    b->center.pos_y = 30;
                    draw_symbol(7, b->center.pos_y, b->center.pos_x);
                    b->s = TL;
                    return 0;
                    break;                
                }
                /* Wall from left */
                if (((pos_x - 1) == LEFT_WALL) && !((pos_y + 1) == gt_y)) {
                    b->s = BR;
                    break;                
                }
                /* Wall from down gt exists */ 
                if (((pos_y + 1) == gt_y) && (pos_x <= gt_end) && (pos_x >= gt_start)) {
                    if(pos_x > (gt_x + 2)) {
                        b->s = TR;
                    }
                    else {
                        b->s = TL;
                    }
                    break;                
                }
                /* Wall from down gt not exists*/
                if (((pos_y + 1) == gt_y) && (!((pos_x <= gt_end) && (pos_x >= gt_start)))) {
                    return 1;
                    break;
                }
                /* No obstcale */
                b->s = BL;
            break;
        default:
            break;
    }

    draw_symbol(6, b->center.pos_y, b->center.pos_x);
    set_position(b);
    draw_symbol(7, b->center.pos_y, b->center.pos_x);
    return 0;
}

void set_gt(struct game_tool *gt, short int pos_x, short int pos_y) {
    gt->center.pos_x = pos_x;
    gt->center.pos_y = pos_y;
    gt->start = pos_x - gt->size;
    gt->end   = pos_x + gt->size;
}

void display(struct game_tool gt) {
    draw_horizontal_line(gt.start,gt.end,gt.center.pos_y);
}

void clear(struct game_tool gt) {
    clear_horizontal_line(gt.start,gt.end,gt.center.pos_y);
}

void move_left(struct game_tool *gt) {
    if((gt->start - 1) == 0) {
        return;
    }
    else {
        set_gt(gt, gt->center.pos_x - 1, gt->center.pos_y);
    }
}

void move_right(struct game_tool *gt) {
    if((gt->end + 1) == 60) {
        return;
    }
    else {
        set_gt(gt, gt->center.pos_x + 1, gt->center.pos_y);
    }
}

void create_board_game() {
    /* Create the board game */
    draw_horizontal_line(0, 79, 0);
    draw_horizontal_line(0, 79, 59);
    draw_vertical_line(0,59, 0);
    draw_vertical_line(0,59, 79);
    draw_vertical_line(0,59, 60);
    set_cursor(15, 63);
    rvc_printf("BREAKOUT GAME!");
    draw_horizontal_line(60, 79, 15);
    set_cursor(45, 63);
    rvc_printf("SCORE:");
    set_cursor(55, 63);
    rvc_printf("LEVEL: 1");
    set_cursor(65, 63);
    rvc_printf("BEST SCORE:");

    return;
}

void game_end() {
    set_cursor(75, 63);
    rvc_printf("GAME OVER!");
    delay(2000000);
    set_cursor(85, 63);
    rvc_printf("9");
    delay(2000000);
    set_cursor(85, 63);
    rvc_printf("8");
    delay(2000000);
    set_cursor(85, 63);
    rvc_printf("7");
    delay(2000000);
    set_cursor(85, 63);
    rvc_printf("6");
    delay(2000000);
    set_cursor(85, 63);
    rvc_printf("5");
    delay(2000000);
    set_cursor(85, 63);
    rvc_printf("4");
    delay(2000000);
    set_cursor(85, 63);
    rvc_printf("3");
    delay(2000000);
    set_cursor(85, 63);
    rvc_printf("2");
    delay(2000000);
    set_cursor(85, 63);
    rvc_printf("1");
    delay(2000000);
    set_cursor(85, 63);
    rvc_printf("0");
    delay(2000000);
    return;
}

void print_score(short int score, int raw, int col) {
    short int frac = 0;
    short int i = 0;

    if(score == 0) {
        draw_char('0', raw, col + 1);
        return;
    }
    char arr[4] = {'N','N','N','\0'};
    while(score > 0) {
        frac = (score % 10);
        char temp = (char)(frac + '0');
        arr[i] = temp;
        score = (score / 10);
        i++;
    }

    short int k = 0;
    for(short int j = (sizeof(arr) - 1) ; j >=0 ; j--) {
        if(arr[j] != 'N'){
            draw_char(arr[j], raw, col + k);
            k++;
        }
    }

    return;
}

short int cut_gt(struct game_tool *gt) {
    if ((gt->end - 2) >= gt->center.pos_x) {
        draw_symbol(6, gt->center.pos_y, gt->end);
        gt->end = gt->end - 1;
        return 1; 
    }
    if ((gt->start + 2) <= gt->center.pos_x) {
        draw_symbol(6, gt->center.pos_y, gt->start);
        gt->start = gt->start + 1;
        return 1;
    }
    return 0;
}

short int roll_brick(struct Brick_arr *ba, struct Ball *b, struct game_tool *gt) {
    if (ba->current_border + 3 == gt->center.pos_y) {
        return 1;
    }
    
    for(short int i = (ba->current_border + 1) ; i >= 1; i--) {
        for(short int j = 1; j <= ba->max_column; j++) {
            if((i != b->center.pos_y) || (j != b->center.pos_x)) {
                if(i == 1) {
                    ba->arr[i][j].display = 1;
                }
                else {
                    ba->arr[i][j] = ba->arr[i - 1][j];
                }
            }
        }
    }
    ba->current_border = ba->current_border + 1;
    return 0; 
}

int main() {

    while(1) {

        clear_screen();
        create_board_game();

        /* Initialize game tool, keys and brick wall */
        static struct game_tool gt;
        static struct Ball      b;
        static struct Brick_arr ba;
        gt.size = 5;
        set_gt(&gt, 30, 57);
        init_ball(&b, 15, 30);
        init_Brick_arr(&ba);
        display_Brick_arr(&ba, &b);
        int left = 0;
        int right = 0;
        score = 0;
        level = 1;
        int del = 200000;

        /* Game start */
        while(1) {
            left     = *CR_Button_1;
            right    = *CR_Button_0;
            clear(gt);
            if(left) {
                move_left(&gt);
                right = 0;
            }

            if(right) {
                move_right(&gt);
                left = 0;
            }

            display(gt);

            if (!check_hit(&b,&ba)) {
                if (set_next_state(&b,&gt,&ba)) {
                    game_end();
                    break;
                }
            }
            display_Brick_arr(&ba, &b);
            print_score(score, 45, 69);
            print_score(level, 55, 69);
            print_score(highest_score, 65, 74);
            level_counter++;
            if(level_counter == 1000) {
                level++;
                level_counter = 0;
                if((del - 40000) > 0) {
                    del = del - 40000;
                }
                if(cut_gt(&gt)) {
                    gt.size = gt.size - 1;
                }
                set_cursor(75, 63);
                rvc_printf("LEVEL UP!");
                delay(5000000);
                if(roll_brick(&ba,&b,&gt)) {
                    game_end();
                    break;
                }
            }
            delay(del);
            set_cursor(75, 63);
            rvc_printf("         ");
        }

        if(score > highest_score)
            highest_score = score;
   }

   return 0;
}