#define _ASMLANGUAGE
#include "../defines/rvc_defines.h"
#define MEM_SCRATCH_PAD  ((volatile float *) (FP_RESULTS))

float sub(float x, float y);

int main() 
{
    float a = 10.237;
    float b = 28.49954;
    float c = -10.237;
    float d = -28.49954;

    // sub
    MEM_SCRATCH_PAD[0]  = sub(a,b); // + +
    MEM_SCRATCH_PAD[1]  = sub(c,b); // - +
    MEM_SCRATCH_PAD[2]  = sub(a,d); // + -
    MEM_SCRATCH_PAD[3]  = sub(c,d); // - -

    return 0;
}

float sub(float x, float y)
{
    return x - y;
}