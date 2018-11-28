/*
 * File: main.cpp
 * Purpose: test code for making a magical wand (rod) look and sound cool
 * Notes:
 *     - uc: ATtiny85
 *     - LEDs: APA102
 *     - accelerometer: LIS2DH
 *     - audio amplifier: TPA2005D1
 *     - code is currently incomplete, DO NOT COMPILE OR FLASH
 */

#include <avr/io.h>
#include <util/delay.h>

int main (void)
{
    // set PB3 to be output
    DDRB = 0b00001000;
    while (1) {
        // set PB3 high
        PORTB = 0b00001000;
        _delay_ms(250);
        // set PB3 low
        PORTB = 0b00000000;
        _delay_ms(250);
    }
    return 1;
}
