#define _ASMLANGUAGE
#define MEM_SCRATCH_PAD  ((volatile float *) (0x00001f00))

float mul(float x, float y);

int main() 
{
    float a = 10.237;
    float b = 28.49954;
    float c = -10.237;
    float d = -28.49954;

    // mul
    MEM_SCRATCH_PAD[0]  = mul(a,b); // + +
    MEM_SCRATCH_PAD[1]  = mul(c,b); // - +
    MEM_SCRATCH_PAD[2]  = mul(a,d); // + -
    MEM_SCRATCH_PAD[3]  = mul(c,d); // - -

    return 0;
}

float mul(float x, float y)
{
    return x * y;
}