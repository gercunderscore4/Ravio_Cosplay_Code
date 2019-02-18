/*
 * File: main.c
 * Purpose: LoZ treasure chest using ATtiny85
 * Notes:
 *     - uc: ATtiny85
 *     - LEDs: APA102
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
 * PB0 : NC
 * PB1 : PWM (audio)
 * PB2 : NC
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

int main (void)
{
    rgb_color leds[LED_COUNT];
    APA102Init(leds, LED_COUNT);

    init_audio();

    while (1) {

        leds[0].red   = r >> 0;
        leds[0].green = g >> 0;
        leds[0].blue  = b >> 0;
        APA102WriteColors(leds, LED_COUNT);
        
        
    }
    return 1;
}
