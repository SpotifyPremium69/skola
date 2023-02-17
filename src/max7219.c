
#include "stm8s.h"
#include "max7219.h"

void init_max(void){
    GPIO_Init(DIN_PORT,DIN_PIN,GPIO_MODE_OUT_PP_LOW_SLOW);
    GPIO_Init(CS_PORT,CS_PIN,GPIO_MODE_OUT_PP_LOW_SLOW);
    GPIO_Init(CLK_PORT,CLK_PIN,GPIO_MODE_OUT_PP_LOW_SLOW);
}

void send_max(uint8_t command, uint8_t value)
{
uint8_t mask;
LOW(CS);  // zahájení komunikace

 
mask = 0b10000000;
while(mask){
    if (command & mask){  // příprava dat
        HIGH(DIN);
    }
    else{
        LOW(DIN);
    }
    HIGH(CLK);  // tiknu hodinovým impulsem
    mask = mask >> 1;
    LOW(CLK);
}

mask = 0b10000000;
while(mask){
    if (value & mask){  // příprava dat
        HIGH(DIN);
    }
    else{
        LOW(DIN);
    }
    HIGH(CLK);  // tiknu hodinovým impulsem
    mask = mask >> 1;
    LOW(CLK);
}

HIGH(CS);  // ukončení komunikace
}

