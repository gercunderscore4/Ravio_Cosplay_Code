/*
 * File: main.c
 * Purpose: test code for making a magical rod look and sound cool
 * Notes:
 *     - uc: ATtiny85
 *     - LEDs: APA102
 *     - accelerometer: LIS2DH
 *     - gyro: L3GD20
 *     - audio amplifier: TPA2005D1
 *     - Code is incomplete
 * Todo:
 *     - Write interrupt-based audio output
 *     - Test with audio HW
 *
 *     ATtiny85
 * PB5 -+----+- VCC
 * PB3 -+O   +- PB2/SCL
 * PB4 -+    +- PB1/OC0B/OC1A
 * GND -+----+- PB0/SDA
 *
 * PB0 : SDA (I2C)
 * PB1 : PWM (audio)
 * PB2 : SCL (I2C)
 * PB3 : CO (LEDs)
 * PB4 : DO (LEDs)
 * PB5 : NC
 *
 * NC  -+----+- VCC
 * CO  -+O   +- SCL
 * DO  -+    +- PWM
 * GND -+----+- SDA
 */

#include <avr/io.h>
#include <util/delay.h>
#include "APA102.h"
#include "InterruptAudio.h"
#include "Gyro.h"


#define LED_COUNT 7

/****************************************************************
 * MAIN
 ****************************************************************/

int main (void)
{
    rgb_color leds[LED_COUNT];
    APA102Init(leds, LED_COUNT);
    leds[6].red   = 0x10;
    leds[6].green = 0x10;
    leds[6].blue  = 0x10;
    APA102WriteColors(leds, LED_COUNT);

    int16_t x, y, z;
    //uint8_t r, g, b;
    //uint8_t d, divindex, octave;
    //uint16_t f;
    gyroInit();

    init_audio();

    while (1) {
        //gyroUpdate(&x, &y, &z, &r, &g, &b, &d, &f);
		gyroRead(&x,&y,&z);
        leds[0].red   = (uint8_t) abs(x / 0x100);
        leds[1].red   = (uint8_t) abs(x % 0x100);
        leds[2].green = (uint8_t) abs(y / 0x100);
        leds[3].green = (uint8_t) abs(y % 0x100);
        leds[4].blue  = (uint8_t) abs(z / 0x100);
        leds[5].blue  = (uint8_t) abs(z % 0x100);
        APA102WriteColors(leds, LED_COUNT);

        //divindex = d<<3;
        //octave = 0;
        //while (divindex >= DIVISORS_SIZE) {
        //    divindex -= DIVISORS_SIZE;
        //    octave += 1;
        //}
        //begin_tone(divindex, octave);
    }
    return 1;
}
