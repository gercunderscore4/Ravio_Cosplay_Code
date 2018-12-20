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

const uint8_t DIVISORS[] = {239,  // C
                            225,  // C#
                            213,  // D
                            201,  // D#
                            190,  // E
                            179,  // F
                            169,  // F#
                            159,  // G
                            150,  // G#
                            142,  // A
                            134,  // A#
                            127}; // B

void tone(uint8_t divindex, uint8_t octave, uint8_t duration) {
    TCCR1 = 0x90 | (11-octave);
    OCR1C = DIVISORS[divindex]-1;
    for (uint8_t i = 0; i < duration; i++) {
        _delay_ms(10);
    }
    TCCR1 = 0x90;
}

void inc_whole(uint8_t* divindex, uint8_t* octave) {
    if ((*divindex) < (sizeof(DIVISORS) - 2)) {
        (*divindex) += 2;
    } else if ((*divindex) == (sizeof(DIVISORS) - 2)) {
        (*divindex) = 0;
        (*octave) += 1;
    } else {
        (*divindex) = 1;
        (*octave) += 1;
    }
}

void inc_half(uint8_t* divindex, uint8_t* octave) {
    if ((*divindex) < (sizeof(DIVISORS) - 1)) {
        (*divindex) += 1;
    } else {
        (*divindex) = 0;
        (*octave) += 1;
    }
}

void play_quad(uint8_t divindex, uint8_t octave) {
    tone(divindex, octave, 15);
    inc_whole(&divindex, &octave);
    tone(divindex, octave, 15);
    inc_whole(&divindex, &octave);
    tone(divindex, octave, 15);
    inc_whole(&divindex, &octave);
    tone(divindex, octave, 15);
}

int main (void)
{
    rgb_color leds[LED_COUNT];

    //int16_t x,y,z;
    //uint16_t f;

    //accelInit();

    DDRB |= (1<<1);

    while (1) {
        //accelUpdate(&x, &y, &z, &(leds[0].red), &(leds[0].green), &(leds[0].blue), &f);
        APA102WriteColors(leds, LED_COUNT);
        //if (PORTB & (1<<1)) {
        //    PORTB &= ~(1<<1);
        //} else {
        //    PORTB |= (1<<1);
        //}
        uint8_t divindex = 4;
        uint8_t octave = 4;
        for (uint8_t i = 0; i < 4; i++) {
            play_quad(divindex, octave);
            play_quad(divindex, octave);
            inc_half(&divindex, &octave);
        }
        for (uint8_t i = 0; i < 4; i++) {
            play_quad(divindex, octave);
            inc_half(&divindex, &octave);
        }
        tone(0, 0, 60);
        inc_whole(&divindex, &octave);
        inc_whole(&divindex, &octave);
        inc_whole(&divindex, &octave);
        for (uint8_t i = 0; i < 3; i++) {
            tone(divindex, octave, 30);
            inc_half(&divindex, &octave);
        }
        tone(divindex, octave, 60);
        tone(0, 0, 100);
    }
    return 1;
}
