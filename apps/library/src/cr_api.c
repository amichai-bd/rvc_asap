#include "cr_api.h"
/* Control registers API functions */
/* Write functions */
void cr_seg7_0_write(unsigned int val)
{
    WRITE_REG(CR_SEG7_0 , val);
}

void cr_seg7_1_write(unsigned int val)
{
    WRITE_REG(CR_SEG7_1 , val);
}

void cr_seg7_2_write(unsigned int val)
{
    WRITE_REG(CR_SEG7_2 , val);
}

void cr_seg7_3_write(unsigned int val)
{
    WRITE_REG(CR_SEG7_3 , val);
}

void cr_seg7_4_write(unsigned int val)
{
    WRITE_REG(CR_SEG7_4 , val);
}

void cr_seg7_5_write(unsigned int val)
{
    WRITE_REG(CR_SEG7_5 , val);
}

void cr_led_write(unsigned int val)
{
    WRITE_REG(CR_LED , val);
}

// /* Read functions */
int cr_seg7_0_read()
{
    int val = 0;
    READ_REG(val , CR_SEG7_0);
    return val;
}

int cr_seg7_1_read()
{
    int val = 0;
    READ_REG(val , CR_SEG7_1);
    return val;
}

int cr_seg7_2_read()
{
    int val = 0;
    READ_REG(val , CR_SEG7_2);
    return val;
}

int cr_seg7_3_read()
{
    int val = 0;
    READ_REG(val , CR_SEG7_3);
    return val;
}

int cr_seg7_4_read()
{
    int val = 0;
    READ_REG(val , CR_SEG7_4);
    return val;
}

int cr_seg7_5_read()
{
    int val = 0;
    READ_REG(val , CR_SEG7_5);
    return val;
}

int cr_led_read()
{
    int val = 0;
    READ_REG(val , CR_LED);
    return val;
}

int cr_button_0_read()
{
    int val = 0;
    READ_REG(val , CR_Button_0);
    return val;
}

int cr_button_1_read()
{
    int val = 0;
    READ_REG(val , CR_Button_1);
    return val;
}

int cr_switch_read()
{
    int val = 0;
    READ_REG(val , CR_Switch);
    return val;
}