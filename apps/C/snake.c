#define _ASMLANGUAGE
#include "../defines/rvc_defines.h"
#include "../defines/graphic_screen.h"

/* This function print a char note on the screen in (raw,col) position */
//void draw_char(char note, int raw, int col) ->FIXME use char
void draw_char(int note, int raw, int col)
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
void clear_screen () {
    for(int x = 0; x<80; x++) {
        for(int y = 0; y<60 ; y++){
            draw_char(' ', 2*y, x);
        }
    }
}
void print_sqr () {
    for(int x = 0; x<80; x++) {
        draw_char('O', 0  , x);
        draw_char('O', 2*59, x);
    }
    for(int y = 0; y<60; y++) {
        draw_char('O', 2*y,  0);
        draw_char('O', 2*y, 79);
    }
}
void delay (int delay){
    while (delay>0)  { delay--;}
}

#define SNK_RIGHT 1
#define SNK_DOWN  2
#define SNK_UP    4
#define SNK_LEFT  8
#define SNK_SIZE  15
int new_direction(int cur_direction){
    int new_direction;
    new_direction = *CR_Switch;
    //if read a value that is not LEFT,RIGT,UP.DOWN
    if((new_direction != SNK_RIGHT) && (new_direction != SNK_UP) && (new_direction != SNK_LEFT) && (new_direction != SNK_DOWN)){
        new_direction = cur_direction;
    }
    // Cant go right from lest
    if((cur_direction == SNK_RIGHT) && (new_direction == SNK_LEFT)){
        new_direction = cur_direction;
    }
    // Cant go left from right
    if((cur_direction == SNK_LEFT) && (new_direction == SNK_RIGHT)){
        new_direction = cur_direction;
    }
    // Cant go donw from up
    if((cur_direction == SNK_UP) && (new_direction == SNK_DOWN)){
        new_direction = cur_direction;
    }
    // Cant go up from down
    if((cur_direction == SNK_DOWN) && (new_direction == SNK_UP)){
        new_direction = cur_direction;
    }

    return new_direction;
}
void snk_move (int direction, int *snk_x_pos, int *snk_y_pos, int size){
    for (int i =(size-1); i>0 ; i--){
        snk_x_pos[i] = snk_x_pos[i-1];
        snk_y_pos[i] = snk_y_pos[i-1];
    } //for
    if(direction == SNK_UP) {
        snk_x_pos[0] = snk_x_pos[1];
        snk_y_pos[0] = snk_y_pos[1] -1;
    } //if SNK_UP
    if(direction == SNK_DOWN) {
        snk_x_pos[0] = snk_x_pos[1];
        snk_y_pos[0] = snk_y_pos[1] + 1;
    } //if SNK_DOWN
    if(direction == SNK_LEFT) {
        snk_x_pos[0] = snk_x_pos[1] - 1;
        snk_y_pos[0] = snk_y_pos[1];
    } //if SNK_LEFT
    if(direction == SNK_RIGHT) {
        snk_x_pos[0] = snk_x_pos[1] + 1;
        snk_y_pos[0] = snk_y_pos[1];
    } //if SNK_RIGHT
    if(direction == 0) {
        snk_x_pos[0] = snk_x_pos[1] + 1;
        snk_y_pos[0] = snk_y_pos[1];
    } //if NO direction set
}
void print_snake (int hit, int *snk_valid, int *snk_x_pos, int *snk_y_pos, int size) {
    for(int i = 0; i<size; i++) {
        if(snk_valid[i]){
            draw_char('O', 2*snk_y_pos[i],  snk_x_pos[i]);
            if(snk_valid[i+1] == 0) {
                if(hit) {
                    snk_valid[i+1] = 1;
                    hit = 0;
                } else {
                    draw_char(' ', 2*snk_y_pos[i+1],  snk_x_pos[i+1]);
                }
            } 
        }
    }
}
int eat(int *snk_valid, int snk_x_pos, int snk_y_pos, int apple_x, int apple_y , int *apple_indx){
    int hit = ((snk_x_pos == apple_x) && (snk_y_pos == apple_y)) ? 1 : 0;
    if (hit) {
         *apple_indx = *apple_indx +1;
    }
    return hit;
}
int check_hit (int snk_x_pos, int snk_y_pos) {
    int kill = 0;
    if(snk_x_pos == 0)  kill = 1;
    if(snk_x_pos == 79) kill = 1;
    if(snk_y_pos == 0)  kill = 1;
    if(snk_y_pos == 59) kill = 1;
    return kill;
}
void new_apple (int * apple_x, int *apple_y){
    *apple_x = (((*apple_y/3)*(*apple_x)) % 32) + 2;
    *apple_y = (((*apple_x/4)*(*apple_y)) % 32) + 2;
}

void snake_game (){
    int snk_x_pos [SNK_SIZE];
    int snk_y_pos [SNK_SIZE];
    int snk_valid [SNK_SIZE];
    int direction = SNK_RIGHT;
    int apple_x = 5;
    int apple_y = 5;
    int apple_indx = 0;
    int hit_apple;
    int score = 0;
    int kill = 0;
    print_sqr();
    for(int i = 0; i < SNK_SIZE ; i ++) {
        snk_x_pos[i] = i+20;
        snk_y_pos[i] = 20;
        snk_valid[i] = (i<5) ? 1 : 0;
    }
    
    while (1)
    { 
        direction = new_direction(direction);
        if(kill == 0 ){
            snk_move(direction, snk_x_pos, snk_y_pos, SNK_SIZE);
        }
        hit_apple = eat(snk_valid, snk_x_pos[0], snk_y_pos[0], apple_x, apple_y, &apple_indx);
        if( hit_apple == 1 ) {
            new_apple(&apple_x, &apple_y);
            score++;
        }
        rvc_printf("\n snake game:");
        //print_apple
        draw_char('O', 2*apple_y,  apple_x);
        print_snake(hit_apple, snk_valid, snk_x_pos, snk_y_pos, SNK_SIZE);   
        //print_score
        draw_char((score+'0'), 3,  39);
        kill = check_hit(snk_x_pos[0], snk_y_pos[0]);
        hit_apple =0;

        delay(20000);
    }
    
}
int main() {
    snake_game();
    while(1); 
return 0;

}