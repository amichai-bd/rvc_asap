/*
* This test Sequentially lights the LEDs in the FPGA back and forth. 
* The number of the turning lit LED is displayed in all 7SEG. 
* KEY0 determines the rate of program operation. 
* When Switch 0-9 turns on it is displayed in 7SEG.
*/

#include "../defines/rvc_defines.h"

int power(int base, int exponent) {
    int result = 1;
    for (exponent; exponent > 0 ; exponent--){
        result = result * base;
    }
    return result;
}

void delay(int num) {
    int counter = 0;
    int i = 0;
    for (int i = 0; i < num; i++){counter++;}
    return;
}

int SEG7_arr[] = {0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,0x80,0x90};

void main(){
    int exp           = 0;
    int val           = 0;
    int up            = 1;
    int tempo         = 1000000;
    int ctrl_tempo    = 0;
    int switch_status = 0;
    while (1){
        switch_status = *CR_Switch;
        if(switch_status){
           *CR_SEG7_5 = SEG7_arr[5];
           for(int i = 0 ; i < 10 ; i++){
                int set = switch_status & (1 << i);
                if(set){
                    *CR_SEG7_4 = SEG7_arr[i];
                    break;
                }
           }
           *CR_SEG7_3 = 0xFF;
           *CR_SEG7_2 = 0xFF;
           *CR_SEG7_1 = 0xFF;
           *CR_SEG7_0 = 0xFF;    
        delay(1000000);
        }
        else{
        ctrl_tempo    = *CR_Button_1;
        if(ctrl_tempo){   
            tempo = tempo - 100000;
            if (tempo < 100000)
                tempo = 1000000;
        }
        val = power(2,exp);
        *CR_LED = val;
        *CR_SEG7_0 = SEG7_arr[exp];
        *CR_SEG7_1 = SEG7_arr[exp];
        *CR_SEG7_2 = SEG7_arr[exp];
        *CR_SEG7_3 = SEG7_arr[exp];
        *CR_SEG7_4 = SEG7_arr[exp];
        *CR_SEG7_5 = SEG7_arr[exp];
        delay(tempo);
        if(up){
            exp++;
            if (exp == 9)
                up = 0;
        }else{
            exp--;
            if (exp == 0)
                up = 1;
            }
        }
    }
}