#define _ASMLANGUAGE
#include "../defines/rvc_defines.h"

int main()
{
    volatile char *ptr = (char*) D_MEM_BASE;

    ptr[0] = 'a';
    ptr[1] = 'b';
    ptr[2] = 'c';
    ptr[3] = 'd';

    return 0;
}