#define _ASMLANGUAGE
#include "../defines/rvc_defines.h"

float div(float x, float y);

int main() 
{
    float a = 10.237;
    float b = 28.49954;
    float c = -10.237;
    float d = -28.49954;

    // div
    MEM_SCRATCH_PAD_FP[0]  = div(a,b); // + +
    MEM_SCRATCH_PAD_FP[1]  = div(c,b); // - +
    MEM_SCRATCH_PAD_FP[2]  = div(a,d); // + -
    MEM_SCRATCH_PAD_FP[3]  = div(c,d); // - -

    return 0;
}

float div(float x, float y)
{
    return x / y;
}