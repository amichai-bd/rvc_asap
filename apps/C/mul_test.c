#define _ASMLANGUAGE
#include "../defines/rvc_defines.h"
#define MEM_SCRATCH_PAD  ((volatile int *) (D_MEM_BASE))

int  mul(int x, int y);

int main() 
{
    int a = 5;
    int b = 3;
    int c = -3;
    int d = -3;
    int e = 12333;
    int f = 1422;

    MEM_SCRATCH_PAD[0] = mul(a,b);
    MEM_SCRATCH_PAD[1] = mul(a,c);
    MEM_SCRATCH_PAD[2] = mul(c,d);
    MEM_SCRATCH_PAD[3] = mul(e,f);

    return 0;
}

int mul(int x, int y)
{
    return x * y;
}
