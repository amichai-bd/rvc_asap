/* VGA defines */
#define VGA_PTR(PTR,OFF)   PTR    = (volatile int *) (VGA_MEM_BASE + OFF)

/* Control registers addresses */
#define CR_CURSOR_H (volatile int *) (CR_MEM_BASE + 0x2c)
#define CR_CURSOR_V (volatile int *) (CR_MEM_BASE + 0x28)

#define VGA_MEM_SIZE_BYTES 38400
#define VGA_MEM_SIZE_WORDS 9600
#define LINE               320
#define BYTES              4
#define COLUMN             80 /* COLUMN between 0 - 79 (80x60) */
#define RAWS               60 /* RAWS between 0 - 59 (80x60) */

/* ASCII Values */
#define SPACE_TOP    0x0                         
#define SPACE_BOTTOM 0x0                         
#define COMMA_TOP    0x00000000                  
#define COMMA_BOTTOM 0x061E1818                  
#define POINT_TOP    0x00000000                  
#define POINT_BOTTOM 0x00181800                  
#define ZERO_TOP     0x52623C00                  
#define ZERO_BOTTOM  0x003C464A                  
#define ONE_TOP      0x1A1C1800                  
#define ONE_BOTTOM   0x007E1818                  
#define TWO_TOP      0x40423C00                  
#define TWO_BOTTOM   0x007E023C                  
#define THREE_TOP    0x40423C00                  
#define THREE_BOTTOM 0x003C4238                  
#define FOUR_TOP     0x24283000                  
#define FOUR_BOTTOM  0x0020207E                  
#define FIVE_TOP     0x3E027E00                  
#define FIVE_BOTTOM  0x003C4240                  
#define SIX_TOP      0x02423C00                  
#define SIX_BOTTOM   0x003C423E                  
#define SEVEN_TOP    0x30407E00                  
#define SEVEN_BOTTOM 0x00080808                  
#define EIGHT_TOP    0x42423C00                  
#define EIGHT_BOTTOM 0x003C423C                  
#define NINE_TOP     0x42423C00                  
#define NINE_BOTTOM  0x003E407C                  
#define A_TOP        0x663C1800                  
#define A_BOTTOM     0x00667E66                  
#define B_TOP        0x3E221E00                  
#define B_BOTTOM     0x001E223E                  
#define C_TOP        0x023E3C00                  
#define C_BOTTOM     0x003C3E02                  
#define D_TOP        0x223E1E00                  
#define D_BOTTOM     0x001E3E22                  
#define E_TOP        0x06067E00                  
#define E_BOTTOM     0x007E067E                  
#define F_TOP        0x06067E00                  
#define F_BOTTOM     0x0006067E                  
#define G_TOP        0x023E3C00                  
#define G_BOTTOM     0x003C223A                  
#define H_TOP        0x66666600                  
#define H_BOTTOM     0x0066667E                  
#define I_TOP        0x18187E00                  
#define I_BOTTOM     0x007E1818                  
#define J_TOP        0x60606000                  
#define J_BOTTOM     0x007C6666                  
#define K_TOP        0x3E664600                  
#define K_BOTTOM     0x0046663E                  
#define L_TOP        0x06060600                  
#define L_BOTTOM     0x007E0606                  
#define M_TOP        0x5A664200                  
#define M_BOTTOM     0x0042425A                  
#define N_TOP        0x6E666200                  
#define N_BOTTOM     0x00466676                  
#define O_TOP        0x66663C00                  
#define O_BOTTOM     0x003C6666                  
#define P_TOP        0x66663E00                  
#define P_BOTTOM     0x0006063E                  
#define Q_TOP        0x42423C00                  
#define Q_BOTTOM     0x007C6252                  
#define R_TOP        0x66663E00                  
#define R_BOTTOM     0x0066663E                  
#define S_TOP        0x1E067C00                  
#define S_BOTTOM     0x003E6078                  
#define T_TOP        0x18187E00                  
#define T_BOTTOM     0x00181818                  
#define U_TOP        0x66666600                  
#define U_BOTTOM     0x003C7E66                  
#define V_TOP        0x66666600                  
#define V_BOTTOM     0x00183C66                  
#define W_TOP        0x42424200                  
#define W_BOTTOM     0x00427E5A                  
#define X_TOP        0x3C666600                  
#define X_BOTTOM     0x0066663C                  
#define Y_TOP        0x3C666600                  
#define Y_BOTTOM     0x00181818                  
#define Z_TOP        0x10207E00                  
#define Z_BOTTOM     0x007E0408

/* ANIME Values */
#define WALK_MAN_TOP_0    0x7c381030
#define WALK_MAN_BOTTOM_0 0x828448ba             
#define WALK_MAN_TOP_1    0x38381030             
#define WALK_MAN_BOTTOM_1 0x4448ac78             
#define WALK_MAN_TOP_2    0x38381030             
#define WALK_MAN_BOTTOM_2 0x10282878             
#define WALK_MAN_TOP_3    0x7c381030             
#define WALK_MAN_BOTTOM_3 0x281038ba             
#define WALK_MAN_TOP_4    0x38381030             
#define WALK_MAN_BOTTOM_4 0x4848387c             

/* ASCII tabels */
unsigned int ASCII_TOP[97] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,SPACE_TOP,
                              0,0,0,0,0,0,0,0,0,0,COMMA_TOP,0,POINT_TOP,0,ZERO_TOP,ONE_TOP,TWO_TOP,
                              THREE_TOP,FOUR_TOP,FIVE_TOP,SIX_TOP,SEVEN_TOP,EIGHT_TOP,NINE_TOP,0,0,0,0,0,0,0,A_TOP,
                              B_TOP,C_TOP,D_TOP,E_TOP,F_TOP,G_TOP,H_TOP,I_TOP,J_TOP,K_TOP,L_TOP,M_TOP,
                              N_TOP,O_TOP,P_TOP,Q_TOP,R_TOP,S_TOP,T_TOP,U_TOP,V_TOP,W_TOP,X_TOP,Y_TOP,Z_TOP};
unsigned int ASCII_BOTTOM[97] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                                 SPACE_BOTTOM,0,0,0,0,0,0,0,0,0,0,COMMA_BOTTOM,0,POINT_BOTTOM,0,ZERO_BOTTOM,
                                 ONE_BOTTOM,TWO_BOTTOM,THREE_BOTTOM,FOUR_BOTTOM,FIVE_BOTTOM,SIX_BOTTOM,
                                 SEVEN_BOTTOM,EIGHT_BOTTOM,NINE_BOTTOM,0,0,0,0,0,0,0,A_BOTTOM,B_BOTTOM,C_BOTTOM,D_BOTTOM,
                                 E_BOTTOM,F_BOTTOM,G_BOTTOM,H_BOTTOM,I_BOTTOM,J_BOTTOM,K_BOTTOM,L_BOTTOM,
                                 M_BOTTOM,N_BOTTOM,O_BOTTOM,P_BOTTOM,Q_BOTTOM,R_BOTTOM,S_BOTTOM,T_BOTTOM,
                                 U_BOTTOM,V_BOTTOM,W_BOTTOM,X_BOTTOM,Y_BOTTOM,Z_BOTTOM};

/* ANIME tabels */
unsigned int ANIME_TOP[5] = {WALK_MAN_TOP_0,WALK_MAN_TOP_1,WALK_MAN_TOP_2,WALK_MAN_TOP_3,WALK_MAN_TOP_4};
unsigned int ANIME_BOTTOM[5] = {WALK_MAN_BOTTOM_0,WALK_MAN_BOTTOM_1,WALK_MAN_BOTTOM_2,WALK_MAN_BOTTOM_3,
                                WALK_MAN_BOTTOM_4};