#include "stm8s.h"
#include "milis.h"

#include "delay.h"
#include "stm8s_gpio.h"
//#include <stdio.h>
//#include "uart1.h"

#define _ISOC99_SOURCE
#define _GNU_SOURCE

#define LED_PORT GPIOD
#define LED_PIN  GPIO_PIN_3
#define LED_HIGH   GPIO_WriteHigh(LED_PORT, LED_PIN)
#define LED_LOW  GPIO_WriteLow(LED_PORT, LED_PIN)
#define LED_REVERSE GPIO_WriteReverse(LED_PORT, LED_PIN)



void setup(void)
{
    CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);      // taktovani MCU na 16MHz
    GPIO_Init(LED_PORT, LED_PIN, GPIO_MODE_OUT_PP_LOW_SLOW);
    Uart2
    init_milis();
    //init_uart1();
}

GPIO_TypeDef *port[16];
GPIO_Pin_TypeDef pin[16];
#define N 16

void all_off(void)
{
    for (short i = 0; i < N; ++i) {
        GPIO_WriteHigh(port[i], pin[i]);
    }
}

void all_on(void)
{
    for (short i = 0; i < N; ++i) {
        GPIO_WriteLow(port[i], pin[i]);
    }
}


int main(void)
{
    uint32_t time = 0;


    port[0] = GPIOD;
    pin[0] = GPIO_PIN_3;
    port[1] = GPIOD;
    pin[1] = GPIO_PIN_2;
    port[2] = GPIOD;
    pin[2] = GPIO_PIN_1;
    port[3] = GPIOC;
    pin[3] = GPIO_PIN_7;
    port[4] = GPIOC;
    pin[4] = GPIO_PIN_6;
    port[5] = GPIOC;
    pin[5] = GPIO_PIN_5;
    port[6] = GPIOC;
    pin[6] = GPIO_PIN_4;
    port[7] = GPIOC;
    pin[7] = GPIO_PIN_3;
    port[8] = GPIOB;
    pin[8] = GPIO_PIN_4;
    port[9] = GPIOB;
    pin[9] = GPIO_PIN_5;
    port[10] = GPIOA;
    pin[10] = GPIO_PIN_3;
    port[11] = GPIOA;
    pin[11] = GPIO_PIN_2;
    port[12] = GPIOA;
    pin[12] = GPIO_PIN_1;
    port[13] = GPIOD;
    pin[13] = GPIO_PIN_6;
    port[14] = GPIOD;
    pin[14] = GPIO_PIN_5;
    port[15] = GPIOD;
    pin[15] = GPIO_PIN_4;


    setup();
    // init all ports
    for (short i = 0; i < N; i++) {
        GPIO_Init(port[i], pin[i], GPIO_MODE_OUT_PP_LOW_SLOW);
    }

    /*for (;;) {*/
    /*    all_on();*/
    /*    delay_ms(333);*/
    /*    delay_ms(333);*/
    /*    delay_ms(333);*/
    /*    all_off();*/
    /*    delay_ms(111);*/
    /*}*/

    short i = 0;
    while (1) {

        delay_ms(3000);
        for (int j = 0; j < 6; j++) {
            all_off();
            delay_ms(333);
            all_on();
            delay_ms(333);
        }

        all_off();
        delay_ms(333);
        for (short j = 0; j < 3; ++j) {
            for (short i = 0; i < N; i++) {
                GPIO_WriteLow(port[i], pin[i]);
                delay_ms(222);
                GPIO_WriteHigh(port[i], pin[i]);
            }
        }
        all_on();
        for (short j = 0; j < 3; ++j) {
            for (short i = 0; i < N; i++) {
                GPIO_WriteHigh(port[i], pin[i]);
                delay_ms(222);
                GPIO_WriteLow(port[i], pin[i]);
            }
        }

        for (short k = 0; k < 3; ++k) {
            if (milis() - time > 77) {
                time = milis();

                GPIO_WriteReverse(port[i], pin[i]);
                if (++i >= N) {
                    i = 0;
                }
            }
            if (milis() - time > 77) {
                time = milis();

                GPIO_WriteReverse(port[i], pin[i]);
                if (++i >= N) {
                    i = 0;
                }
            }
        }
    }
}

/*-------------------------------  Assert -----------------------------------*/
#include "__assert__.h"
