#ifndef _MAX7219_H_
#define _MAX7219_H_

#include "stm8s.h"

#define DIN_PORT GPIOD
#define DIN_PIN  GPIO_PIN_4
#define CS_PORT GPIOD
#define CS_PIN  GPIO_PIN_6
#define CLK_PORT GPIOD
#define CLK_PIN  GPIO_PIN_5

#define DIN_HIGH   GPIO_WriteHigh(DIN_PORT, DIN_PIN)
#define DIN_LOW  GPIO_WriteLow(DIN_PORT, DIN_PIN)
#define DIN_REVERSE GPIO_WriteReverse(DIN_PORT, DIN_PIN)
#define CS_HIGH   GPIO_WriteHigh(CS_PORT, CS_PIN)
#define CS_LOW  GPIO_WriteLow(CS_PORT, CS_PIN)
#define CS_REVERSE GPIO_WriteReverse(CS_PORT, CS_PIN)

#define HIGH(BAGR) GPIO_WriteHigh(BAGR##_PORT, BAGR##_PIN)
#define LOW(BAGR) GPIO_WriteLow(BAGR##_PORT, BAGR##_PIN)
#define REVERSE(BAGR) GPIO_WriteReverse(BAGR##_PORT, BAGR##_PIN)

void init_max(void);
void send_max(uint8_t command, uint8_t value);

#endif
