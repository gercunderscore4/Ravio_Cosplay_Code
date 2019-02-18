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

#define LED_COUNT 65
#define SPARKLE_COUNT ((LED_COUNT * 2) - 1)
#define JIFFY_MS 25

rgb_color sparkles[SPARKLE_COUNT];
uint8_t sparkle_index = 0

void init_sparkle (void) {
    for (uint8_t i = 0; i < SPARKLE_COUNT; i++) {
        if ((i % 16) < 8) {
            sparkles[i] = i % 8;
        } else {
            sparkles[i] = 7 - (i % 8)
        }
    }
}

void sparkle (uint8_t jiffies) {
    for (uint8_t i = 0; i < jiffies; i++) {
        sparkle_index++;
        sparkle_index %= LED_COUNT;
        APA102WriteColors(&(sparkles[sparkle_index]), LED_COUNT);
        _delay_ms(JIFFY_MS);
    }
}

void stop_sparkle (void) {
    APA102WriteBlack(LED_COUNT);
}

/*
void item_song (void) {
    uint8_t divindex = 4;
    uint8_t octave = 4;
    for (uint8_t i = 0; i < 4; i++) {
        play_quad(divindex, octave, 2);
        play_quad(divindex, octave, 2);
        inc_half(&divindex, &octave);
    }
    for (uint8_t i = 0; i < 4; i++) {
        play_quad(divindex, octave, 2);
        inc_half(&divindex, &octave);
    }
    rest(8);
    inc_whole(&divindex, &octave);
    inc_whole(&divindex, &octave);
    inc_whole(&divindex, &octave);
    for (uint8_t i = 0; i < 3; i++) {
        tone(divindex, octave, 4);
        inc_half(&divindex, &octave);
    }
    tone(divindex, octave, 8);
}
*/

int main (void)
{
    init_sparkle();
    init_audio();
    stop_sparkle();

    while (1) {

        sparkle(80);
        item_song();
    }

    return 1;
}
