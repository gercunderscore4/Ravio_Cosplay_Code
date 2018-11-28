/****************************************************************
 * APA102 on ATtiny85
 *
 * Designed to handle up to 240 LEDs.
 * Based on APA102 library for Arduino.
 ****************************************************************/

#ifndef __APA102_H__
#define __APA102_H__

/* SET THESE VALUES */

#define BRIGHTNESS 31
#define LED_DATA_PORT  5
#define LED_CLOCK_PORT 4

/* LEAVE THE REST ALONE */

#include <avr/io.h>

// brightness can be controlled by lowering the rgb values
// therefore, optimize it out
#define BRIGHTNESS_BYTE (0xE0 | BRIGHTNESS)

#define BIT_DI (1 << LED_DATA_PORT)
#define BIT_CI (1 << LED_CLOCK_PORT)

// use "CYCLE_CLOCK;" to avoid bad-looking line endings
#define CYCLE_CLOCK PORTB |=  BIT_CI; PORTB &= ~BIT_CI;

typedef struct rgb_color
{
    uint8_t red, green, blue;
} rgb_color;

void APA102Transfer (uint8_t b);
void APA102WriteColors (rgb_color* colors, uint8_t count);

#endif // __APA102_H__
