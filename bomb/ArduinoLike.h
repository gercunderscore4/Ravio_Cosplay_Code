/*
 * write some Arduino-like functions to make conversion easier
 */

#ifndef __ARDUINOLIKE_H__
#define __ARDUINOLIKE_H__

#include <avr/io.h>
#include <util/delay.h>
#include "stdlib.h"

#define INPUT  0
#define OUTPUT 1

#define LOW  0
#define HIGH 1

uint16_t wyhash16_x; 

void pinMode (uint8_t pin, uint8_t value);
void digitalWrite (uint8_t pin, uint8_t value);
uint16_t randomWMin (uint16_t howbig);
uint16_t randomWMinMax (uint16_t howsmall, uint16_t howbig);
void delay (uint16_t duration_ms);
uint16_t max (uint16_t a, uint16_t b);

#endif // __ARDUINOLIKE_H__
