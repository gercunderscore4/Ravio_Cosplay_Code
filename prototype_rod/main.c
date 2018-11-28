/*
 * File: main.c
 * Purpose: test code for making a magical rod look and sound cool
 * Notes:
 *     - uc: ATtiny85
 *     - LEDs: APA102
 *     - accelerometer: LIS2DH
 *     - audio amplifier: TPA2005D1
 *     - Code is incomplete
 * Todo:
 *     - Test with APA102 HW
 *     - Write accelerometer interface code (I2C)
 *     - Test with acceleraometer HW
 *     - Write interrupt-based audio output
 *     - Test with audio HW
 */

#include <avr/io.h>
#include <util/delay.h>
#include "APA102.h"

#define LED_COUNT 1

/****************************************************************
 * MAIN
 ****************************************************************/

int main (void)
{
    rgb_color leds[LED_COUNT] = {{0x00, 0x00, 0x00}};

    // set PB3 to be output
    DDRB = 0b00001000;
    while (1) {
        // set PB3 high
        PORTB = 0b00001000;
        _delay_ms(250);
        // set PB3 low
        PORTB = 0b00000000;
        _delay_ms(250);
        APA102WriteColors(leds, LED_COUNT);
    }
    return 1;
}
