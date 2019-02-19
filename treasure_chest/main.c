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
 * DO  -+O   +- NC
 * CO  -+    +- PWM
 * GND -+----+- NC
 */

#include <avr/io.h>
#include <util/delay.h>
#include "APA102.h"
#include "InterruptAudio.h"

////////////////////////////////////////////////////////////////
// LIGHTS
////////////////////////////////////////////////////////////////

#define LED_COUNT 65
#define SPARKLE_COUNT ((LED_COUNT * 2) - 1)
#define JIFFY_MS 25

rgb_color sparkles[SPARKLE_COUNT];
uint8_t sparkle_index = 0;

void stop_sparkle (void) {
    APA102WriteBlack(LED_COUNT);
}

void sparkle (uint8_t jiffies) {
    for (uint8_t i = 0; i < jiffies; i++) {
        sparkle_index++;
        sparkle_index %= LED_COUNT;
        APA102WriteColors(&(sparkles[sparkle_index]), LED_COUNT);
        _delay_ms(JIFFY_MS);
    }
}

void init_sparkle (void) {
    APA102Init();

    uint8_t temp = 0;
    for (uint8_t i = 0; i < SPARKLE_COUNT; i++) {
        if ((i % 14) < 7) {
            temp = (0x01 << (i % 7));
        } else {
            temp = (0x80 >> (i % 7));
        }
        sparkles[i].red   = temp;
        sparkles[i].green = temp;
        sparkles[i].blue  = 0x00;
    }
    stop_sparkle();
}

////////////////////////////////////////////////////////////////
// SOUND
////////////////////////////////////////////////////////////////

#define BEAT_IN_JIFFIES 10

void play_sparkle_tone (uint8_t divindex, uint8_t octave, uint8_t jiffies) {
    begin_tone (divindex, octave);
    sparkle(jiffies);
    end_tone();
}

void play_sparkle_quad (uint8_t divindex, uint8_t octave) {
    play_sparkle_tone(divindex, octave, BEAT_IN_JIFFIES);
    inc_whole(&divindex, &octave);
    play_sparkle_tone(divindex, octave, BEAT_IN_JIFFIES);
    inc_whole(&divindex, &octave);
    play_sparkle_tone(divindex, octave, BEAT_IN_JIFFIES);
    inc_whole(&divindex, &octave);
    play_sparkle_tone(divindex, octave, BEAT_IN_JIFFIES);
}

void play_section_0 (uint8_t* divindex, uint8_t* octave) {
    (*divindex) = 4;
    (*octave) = 4;
}

void play_section_1 (uint8_t* divindex, uint8_t* octave) {
    play_sparkle_quad((*divindex), (*octave));
    play_sparkle_quad((*divindex), (*octave));
    inc_half(divindex, octave);
}

void play_section_2 (uint8_t* divindex, uint8_t* octave) {
    play_sparkle_quad((*divindex), (*octave));
    inc_half(divindex, octave);
}

void play_section_3 (uint8_t* divindex, uint8_t* octave) {
    sparkle(BEAT_IN_JIFFIES * 4);
    inc_whole(divindex, octave);
    inc_whole(divindex, octave);
    inc_whole(divindex, octave);
}

void play_section_4 (uint8_t* divindex, uint8_t* octave) {
    play_sparkle_tone((*divindex), (*octave), BEAT_IN_JIFFIES * 2);
    inc_half(divindex, octave);
    play_sparkle_tone((*divindex), (*octave), BEAT_IN_JIFFIES * 2);
    inc_half(divindex, octave);
    play_sparkle_tone((*divindex), (*octave), BEAT_IN_JIFFIES * 2);
    inc_half(divindex, octave);
    play_sparkle_tone((*divindex), (*octave), BEAT_IN_JIFFIES * 4);
}

////////////////////////////////////////////////////////////////
// SWITCHES
////////////////////////////////////////////////////////////////

void init_switches (void) {
    DDRB  &=  ~( (1 << DDB0) | (1 << DDB2) ); // inputs
    PORTB |=  (1 << PORTB0) | (1 << PORTB2);      // pull-up
}

uint8_t get_sw2 (void) {
    return !(PINB & PINB0)
}

uint8_t get_sw3 (void) {
    return !(PINB & PINB2)
}

////////////////////////////////////////////////////////////////
// MAIN
////////////////////////////////////////////////////////////////

int main (void)
{
    init_sparkle();
    init_audio();


    uint8_t* divindex = 4;
    uint8_t* octave   = 4;
    play_section_0(&divindex, &octave);
    
    played_2 = 0;
    played_4 = 0;
    while (!played_4) {
        if (get_sw3()) {
            if (played_2) play_section_3(&divindex, &octave);
            play_section_4(&divindex, &octave);
            played_4 = 1;
        } else if (get_sw2()){
            play_section_2(&divindex, &octave);
            played_2 = 1;
        } else {
            play_section_1(&divindex, &octave);
        }
    }
    stop_sparkle();
    while (1);

    return 1;
}
