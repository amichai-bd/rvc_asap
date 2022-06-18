extern void rvc_printf(const char *c);

int main()
{
    int i = 0;

    for(i = 0 ; i < 1 ; i++)
    {
        rvc_printf("WE ARE THE PEOPLE THAT RULE THE WORLD.\n");
        rvc_printf("A FORCE RUNNING IN EVERY BOY AND GIRL.\n");
        rvc_printf("ALL REJOICING IN THE WORLD, TAKE ME NOW WE CAN TRY.\n");
        rvc_printf("0123456789\n");
    }

    draw_symbol(1, 10, 15);
    draw_symbol(2, 10, 16);
    draw_symbol(3, 10, 17);
    draw_symbol(4, 10, 18);
    draw_symbol(5, 10, 19);
    return 0;
}