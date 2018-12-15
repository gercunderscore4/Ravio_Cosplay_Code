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
 * PB3 : LEDs (DO)
 * PB4 : LEDs (CO)
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
    uint8_t counter = 0;

    uint8_t r,g,b;
    int16_t x,y,z;
    uint16_t f;

    accelInit();

    while (1) {
        accelUpdate(&x, &y, &z, &(leds[0].red), &(leds[0].green), &(leds[0].blue), &f);
        APA102WriteColors(leds, LED_COUNT);
    }
    return 1;
}
