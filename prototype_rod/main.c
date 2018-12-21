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
 * PB3 : DO (LEDs)
 * PB4 : CO (LEDs)
 * PB5 : NC
 *
 * NC  -+----+- VCC
 * DO  -+O   +- SCL
 * CO  -+    +- PWM
 * GND -+----+- SDA
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
    rgb_color leds[LED_COUNT];
    APA102Init(leds, LED_COUNT);

    int16_t x,y,z;
    uint8_t d, divindex, octave;
    uint16_t f;
    accelInit();

    init_audio();

    while (1) {
        accelUpdate(&x, &y, &z, &(leds[0].red), &(leds[0].green), &(leds[0].blue), &d, &f);

        APA102WriteColors(leds, LED_COUNT);

        if (d > DIVISIORS_SIZE) {
            divindex = d - DIVISIORS_SIZE;
            octave = 1;
        } else {
            divindex = d;
            octave = 0;
        }
    }
    return 1;
}
