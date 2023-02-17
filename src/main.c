#include "stm8s.h"
#include "milis.h"
#include "max7219.h"
#include "uart1.h"



#define _ISOC99_SOURCE
#define _GNU_SOURCE





void setup(void)
{
    CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);      // taktovani MCU na 16MHz

    init_uart1();
    init_max();
    init_milis();
    //init_uart1();
}

int main(void)
{
setup();
while(1){
    HIGH(CS);
}


}
/*-------------------------------  Assert -----------------------------------*/
#include "__assert__.h"
