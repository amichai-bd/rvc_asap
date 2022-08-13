#define _ASMLANGUAGE
#include "../defines/rvc_defines.h"
#define MEM_SCRATCH_PAD  ((volatile int *) (D_MEM_BASE))

int  div(int x, int y);
int  mod(int x, int y);

int main() 
{
    int a = 15;
    int b = 3;
    int c = -3;
    int d = -15;
    int e = 12333;
    int f = 1422;
    int g = 5;
    int h = 128;

    // div
    MEM_SCRATCH_PAD[0] = div(a,b);
    MEM_SCRATCH_PAD[1] = div(a,c);
    MEM_SCRATCH_PAD[2] = div(d,c);
    MEM_SCRATCH_PAD[3] = div(e,f);

    // mod
    MEM_SCRATCH_PAD[4] = mod(g,b);
    MEM_SCRATCH_PAD[5] = mod(h,g);

    return 0;
}

int div(int x, int y)
{
    return x / y;
}

int mod(int x, int y)
{
    return x % y;
}