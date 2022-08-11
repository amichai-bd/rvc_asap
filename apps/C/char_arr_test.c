#define _ASMLANGUAGE

int main()
{
    volatile char *ptr = (char*) 0x00004000;

    ptr[0] = 'a';
    ptr[1] = 'b';
    ptr[2] = 'c';
    ptr[3] = 'd';

    return 0;
}