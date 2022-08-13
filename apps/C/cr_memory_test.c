#define _ASMLANGUAGE
#include "../defines/rvc_defines.h"
#define WRITE_REG(REG,VAL) (*REG) = VAL
#define READ_REG(VAL,REG)  VAL    = (*REG)
#define MEM_SCRATCH_PAD    ((volatile int *) (D_MEM_BASE))

/* Control registers addresses */
#define CR_SEG7_0   (volatile int *) (CR_MEM_BASE + 0x0)
#define CR_SEG7_1   (volatile int *) (CR_MEM_BASE + 0x4)
#define CR_SEG7_2   (volatile int *) (CR_MEM_BASE + 0x8)
#define CR_SEG7_3   (volatile int *) (CR_MEM_BASE + 0xc)
#define CR_SEG7_4   (volatile int *) (CR_MEM_BASE + 0x10)
#define CR_SEG7_5   (volatile int *) (CR_MEM_BASE + 0x14)
#define CR_LED      (volatile int *) (CR_MEM_BASE + 0x18)
#define CR_Button_0 (volatile int *) (CR_MEM_BASE + 0x1c)
#define CR_Button_1 (volatile int *) (CR_MEM_BASE + 0x20)
#define CR_Switch   (volatile int *) (CR_MEM_BASE + 0x24)

/* Control registers API functions */
/* Write functions */
static void cr_seg7_0_write(unsigned int val)
{
    WRITE_REG(CR_SEG7_0 , val);
}

static void cr_seg7_1_write(unsigned int val)
{
    WRITE_REG(CR_SEG7_1 , val);
}

static void cr_seg7_2_write(unsigned int val)
{
    WRITE_REG(CR_SEG7_2 , val);
}

static void cr_seg7_3_write(unsigned int val)
{
    WRITE_REG(CR_SEG7_3 , val);
}

static void cr_seg7_4_write(unsigned int val)
{
    WRITE_REG(CR_SEG7_4 , val);
}

static void cr_seg7_5_write(unsigned int val)
{
    WRITE_REG(CR_SEG7_5 , val);
}

static void cr_led_write(unsigned int val)
{
    WRITE_REG(CR_LED , val);
}

// /* Read functions */
static int cr_seg7_0_read()
{
    int val = 0;
    READ_REG(val , CR_SEG7_0);
    return val;
}

static int cr_seg7_1_read()
{
    int val = 0;
    READ_REG(val , CR_SEG7_1);
    return val;
}

static int cr_seg7_2_read()
{
    int val = 0;
    READ_REG(val , CR_SEG7_2);
    return val;
}

static int cr_seg7_3_read()
{
    int val = 0;
    READ_REG(val , CR_SEG7_3);
    return val;
}

static int cr_seg7_4_read()
{
    int val = 0;
    READ_REG(val , CR_SEG7_4);
    return val;
}

static int cr_seg7_5_read()
{
    int val = 0;
    READ_REG(val , CR_SEG7_5);
    return val;
}

static int cr_led_read()
{
    int val = 0;
    READ_REG(val , CR_LED);
    return val;
}

static int cr_button_0_read()
{
    int val = 0;
    READ_REG(val , CR_Button_0);
    return val;
}

static int cr_button_1_read()
{
    int val = 0;
    READ_REG(val , CR_Button_1);
    return val;
}

static int cr_switch_read()
{
    int val = 0;
    READ_REG(val , CR_Switch);
    return val;
}

int main() 
{
    /* Test API */
    cr_seg7_0_write (0xFFFFFFF1);
    cr_seg7_1_write (0xFFFFFFF2);
    cr_seg7_2_write (0xFFFFFFF3);
    cr_seg7_3_write (0xFFFFFFF4);
    cr_seg7_4_write (0xFFFFFFF5);
    cr_seg7_5_write (0xFFFFFFF6);
    cr_led_write    (0xFFFFFFF7);
    
    MEM_SCRATCH_PAD[0] = cr_seg7_0_read();
    MEM_SCRATCH_PAD[1] = cr_seg7_1_read();
    MEM_SCRATCH_PAD[2] = cr_seg7_2_read();
    MEM_SCRATCH_PAD[3] = cr_seg7_3_read();
    MEM_SCRATCH_PAD[4] = cr_seg7_4_read();
    MEM_SCRATCH_PAD[5] = cr_seg7_5_read();
    MEM_SCRATCH_PAD[6] = cr_led_read();
    MEM_SCRATCH_PAD[7] = cr_button_0_read();
    MEM_SCRATCH_PAD[8] = cr_button_1_read();
    MEM_SCRATCH_PAD[9] = cr_switch_read();

    return 0;
}