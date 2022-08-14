#define _ASMLANGUAGE
#include "../defines/rvc_defines.h"

float add(float x, float y);

int main() 
{
    float a = 10.237;
    float b = 28.49954;
    float c = -10.237;
    float d = -28.49954;

    // add
    MEM_SCRATCH_PAD_FP[0]  = add(a,b); // + +
    MEM_SCRATCH_PAD_FP[1]  = add(c,b); // - +
    MEM_SCRATCH_PAD_FP[2]  = add(a,d); // + -
    MEM_SCRATCH_PAD_FP[3]  = add(c,d); // - -

    return 0;
}

float add(float x, float y)
{
    return x + y;
}