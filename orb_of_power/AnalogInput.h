/*
 * ATtiny84 analog input
 * Section 16
 */

#ifndef __ANALOGINPUT_H__
#define __ANALOGINPUT_H__

#include <avr/io.h>

#define ANALOG_MAX 0x3FF

// set this:
#define ANALOG_PIN 0

void     analogInit (void);
uint16_t analogRead (void);

#endif // __ANALOGINPUT_H__
