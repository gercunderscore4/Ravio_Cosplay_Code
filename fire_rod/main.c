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
#include "Gyro.h"
#include "stdlib.h"


#define LED_COUNT 14

/****************************************************************
 * MAIN
 ****************************************************************/

int main (void)
{
    rgb_color leds[LED_COUNT];
    APA102Init(leds, LED_COUNT);

    int16_t x, y, z, a;
    //uint8_t r, g, b;
    //uint16_t f;
    gyroInit();

    //uint8_t d;
    uint8_t divindex = NOTE_C;
    uint8_t octave = 4;
    init_audio();

    int i;


    while (1) {
        // activate if over 4 gravities
        gyroRead(&x,&y,&z);
		a = abs(x) + abs(y) + abs(z)
		if ( > 0x180) {
            // magic sound
            // C4 -> E4
            // F4 -> G#4, loop 4 times

            // lights:
            // C4 -> E4, F4 -> G#4
            // red travels along LEDs
            // F4 -> G#4
            // yellow travels along LEDs, fast pace
            // F4 -> G#4, F4 -> G#4
            // darkness travels along LEDs, fast pace
            
            // NNN  0  1  2  3  4  5  6  7  8  9 10 11 12
            // C4   .  .  .  .  .  .  .  .  .  .  .  .  .
            // C#4  R  .  .  .  .  .  .  .  .  .  .  .  .
            // D4   R  R  .  .  .  .  .  .  .  .  .  .  .
            // D#4  R  R  R  .  .  .  .  .  .  .  .  .  .
            // E4   R  R  R  R  R  .  .  .  .  .  .  .  .
            // F4   R  R  R  R  R  R  R  .  .  .  .  .  .
            // F#4  R  R  R  R  R  R  R  R  R  .  .  .  .
            // G4   R  R  R  R  R  R  R  R  R  R  R  R  .
            // G#4  R  R  R  R  R  R  R  R  R  R  R  R  R

            divindex = NOTE_C;
            octave = 4;
            i = 0;

            // C4
            tone(divindex, octave, 1);
            inc_half(&divindex, &octave);
            APA102WriteColors(leds, LED_COUNT);
            // C#4 0
            leds[i++].red = 0xFF;
            tone(divindex, octave, 1);
            inc_half(&divindex, &octave);
            APA102WriteColors(leds, LED_COUNT);
            // D4  1
            leds[i++].red = 0xFF;
            tone(divindex, octave, 1);
            inc_half(&divindex, &octave);
            APA102WriteColors(leds, LED_COUNT);
            // D#4 2
            leds[i++].red = 0xFF;
            tone(divindex, octave, 1);
            inc_half(&divindex, &octave);
            APA102WriteColors(leds, LED_COUNT);
            // E4  3,4
            leds[i++].red = 0xFF;
            leds[i++].red = 0xFF;
            tone(divindex, octave, 1);
            inc_half(&divindex, &octave);
            APA102WriteColors(leds, LED_COUNT);
            // F4  5,6
            leds[i++].red = 0xFF;
            leds[i++].red = 0xFF;
            tone(divindex, octave, 1);
            inc_half(&divindex, &octave);
            APA102WriteColors(leds, LED_COUNT);
            // F#4 7,8
            leds[i++].red = 0xFF;
            leds[i++].red = 0xFF;
            tone(divindex, octave, 1);
            inc_half(&divindex, &octave);
            APA102WriteColors(leds, LED_COUNT);
            // G4  9,10,11
            leds[i++].red = 0xFF;
            leds[i++].red = 0xFF;
            leds[i++].red = 0xFF;
            tone(divindex, octave, 1);
            inc_half(&divindex, &octave);
            APA102WriteColors(leds, LED_COUNT);
            // G#4 12
            leds[i++].red = 0xFF;
            tone(divindex, octave, 1);
            inc_half(&divindex, &octave);
            APA102WriteColors(leds, LED_COUNT);

            // NNN  0  1  2  3  4  5  6  7  8  9 10 11 12
            // F4   Y  Y  Y  R  R  R  R  R  R  R  R  R  R
            // F#4  Y  Y  Y  Y  Y  Y  R  R  R  R  R  R  R
            // G4   Y  Y  Y  Y  Y  Y  Y  Y  Y  R  R  R  R
            // G#4  Y  Y  Y  Y  Y  Y  Y  Y  Y  Y  Y  Y  Y
            divindex = NOTE_F;
            i = 0;
            // F4  0,1,2
            leds[i++].green = 0xFF;
            leds[i++].green = 0xFF;
            leds[i++].green = 0xFF;
            tone(divindex, octave, 1);
            inc_half(&divindex, &octave);
            APA102WriteColors(leds, LED_COUNT);
            // F#4 3,4,5
            leds[i++].green = 0xFF;
            leds[i++].green = 0xFF;
            leds[i++].green = 0xFF;
            tone(divindex, octave, 1);
            inc_half(&divindex, &octave);
            APA102WriteColors(leds, LED_COUNT);
            // G4  6,7,8
            leds[i++].green = 0xFF;
            leds[i++].green = 0xFF;
            leds[i++].green = 0xFF;
            tone(divindex, octave, 1);
            inc_half(&divindex, &octave);
            APA102WriteColors(leds, LED_COUNT);
            // G#4  9,10,11,12
            leds[i++].green = 0xFF;
            leds[i++].green = 0xFF;
            leds[i++].green = 0xFF;
            leds[i++].green = 0xFF;
            tone(divindex, octave, 1);
            inc_half(&divindex, &octave);
            APA102WriteColors(leds, LED_COUNT);

            // repeat with blue
            divindex = NOTE_F;
            i = 0;
            // F4  0,1,2
            leds[i++].blue = 0xFF;
            leds[i++].blue = 0xFF;
            leds[i++].blue = 0xFF;
            tone(divindex, octave, 1);
            inc_half(&divindex, &octave);
            APA102WriteColors(leds, LED_COUNT);
            // F#4 3,4,5
            leds[i++].blue = 0xFF;
            leds[i++].blue = 0xFF;
            leds[i++].blue = 0xFF;
            tone(divindex, octave, 1);
            inc_half(&divindex, &octave);
            APA102WriteColors(leds, LED_COUNT);
            // G4  6,7,8
            leds[i++].blue = 0xFF;
            leds[i++].blue = 0xFF;
            leds[i++].blue = 0xFF;
            tone(divindex, octave, 1);
            inc_half(&divindex, &octave);
            APA102WriteColors(leds, LED_COUNT);
            // G#4  9,10,11,12
            leds[i++].blue = 0xFF;
            leds[i++].blue = 0xFF;
            leds[i++].blue = 0xFF;
            leds[i++].blue = 0xFF;
            tone(divindex, octave, 1);
            inc_half(&divindex, &octave);
            APA102WriteColors(leds, LED_COUNT);

            // repeat with black
            divindex = NOTE_F;
            i = 0;
            // F4  0,1,2
            leds[i].red = 0x00;
            leds[i].green = 0x00;
            leds[i++].blue = 0x00;
            leds[i].red = 0x00;
            leds[i].green = 0x00;
            leds[i++].blue = 0x00;
            leds[i].red = 0x00;
            leds[i].green = 0x00;
            leds[i++].blue = 0x00;
            tone(divindex, octave, 1);
            inc_half(&divindex, &octave);
            APA102WriteColors(leds, LED_COUNT);
            // F#4 3,4,5
            leds[i].red = 0x00;
            leds[i].green = 0x00;
            leds[i++].blue = 0x00;
            leds[i].red = 0x00;
            leds[i].green = 0x00;
            leds[i++].blue = 0x00;
            leds[i].red = 0x00;
            leds[i].green = 0x00;
            leds[i++].blue = 0x00;
            tone(divindex, octave, 1);
            inc_half(&divindex, &octave);
            APA102WriteColors(leds, LED_COUNT);
            // G4  6,7,8
            leds[i].red = 0x00;
            leds[i].green = 0x00;
            leds[i++].blue = 0x00;
            leds[i].red = 0x00;
            leds[i].green = 0x00;
            leds[i++].blue = 0x00;
            leds[i].red = 0x00;
            leds[i].green = 0x00;
            leds[i++].blue = 0x00;
            tone(divindex, octave, 1);
            inc_half(&divindex, &octave);
            APA102WriteColors(leds, LED_COUNT);
            // G#4  9,10,11,12
            leds[i].red = 0x00;
            leds[i].green = 0x00;
            leds[i++].blue = 0x00;
            leds[i].red = 0x00;
            leds[i].green = 0x00;
            leds[i++].blue = 0x00;
            leds[i].red = 0x00;
            leds[i].green = 0x00;
            leds[i++].blue = 0x00;
            leds[i].red = 0x00;
            leds[i].green = 0x00;
            leds[i++].blue = 0x00;
            tone(divindex, octave, 1);
            inc_half(&divindex, &octave);
            APA102WriteColors(leds, LED_COUNT);

            for (i = 0; i < LED_COUNT; i++) {
                leds[i].red   = 0x00;
                leds[i].green = 0x00;
                leds[i].blue  = 0x00;
            }
        }
    }
    return 1;
}
