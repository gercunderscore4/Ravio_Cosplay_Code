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


#define LED_COUNT 4

/****************************************************************
 * MAIN
 ****************************************************************/

int main (void)
{
    rgb_color leds[LED_COUNT];
    APA102Init(leds, LED_COUNT);
    leds[1].red   = 0xFF;
    leds[1].green = 0x00;
    leds[1].blue  = 0x00;
    APA102WriteColors(leds, LED_COUNT);

    int16_t x, y, z;
    uint8_t r, g, b;
    uint8_t d, divindex, octave;
    uint16_t f;
    gyroInit();
    leds[2].red   = 0x00;
    leds[2].green = 0xFF;
    leds[2].blue  = 0x00;
    APA102WriteColors(leds, LED_COUNT);

    //init_audio();
    leds[3].red   = 0x00;
    leds[3].green = 0x00;
    leds[3].blue  = 0xFF;
    APA102WriteColors(leds, LED_COUNT);

    while (1) {
        gyroUpdate(&x, &y, &z, &r, &g, &b, &d, &f);

        leds[0].red   = r >> 0;
        leds[0].green = g >> 0;
        leds[0].blue  = b >> 0;
        APA102WriteColors(leds, LED_COUNT);

        divindex = d<<3;
        octave = 0;
        while (divindex >= DIVISORS_SIZE) {
            divindex -= DIVISORS_SIZE;
            octave += 1;
        }
        //begin_tone(divindex, octave);
    }
    return 1;
}
