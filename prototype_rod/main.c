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
 *
 *     ATtiny85
 * PB5 -+----+- VCC
 * PB3 -+O   +- PB2/SCL
 * PB4 -+    +- PB1/OC0B/OC1A
 * GND -+----+- PB0/SDA
 *
 * PB0 : I2C (SDA)
 * PB1 : PWM (audio)
 * PB2 : I2c (SCL)
 * PB3 : LEDs (CO)
 * PB4 : LEDs (DO)
 * PB5 : NC
 */

#include <avr/io.h>
#include <util/delay.h>
#include "APA102.h"
#include "InterruptAudio.h"
#include "Accel.h"

#define LED_COUNT 1

/****************************************************************
 * MAIN
 ****************************************************************/

int main (void)
{
    rgb_color leds[LED_COUNT] = {{0xFF, 0x00, 0x00}};
    uint8_t state = 0;

    while (1) {
        APA102WriteColors(leds, LED_COUNT);
        if        (0 == state) {
            if (0xFF == (++leds[0].green)) state = 1;
        } else if (1 == state) {
            if (0x00 == (--leds[0].red))   state = 2;
        } else if (2 == state) {
            if (0xFF == (++leds[0].blue))  state = 3;
        } else if (3 == state) {
            if (0x00 == (--leds[0].green)) state = 4;
        } else if (4 == state) {
            if (0xFF == (++leds[0].red))   state = 5;
        } else if (5 == state) {
            if (0x00 == (--leds[0].blue))  state = 0;
        }
    }
    return 1;
}
