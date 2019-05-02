/****************************************************************
 * Interrupt-Based Audio on ATtiny85
 ****************************************************************/

#include "InterruptAudio.h"

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

void init_audio (void) {
    DDRB |= BIT_AO;
}

void tone (uint8_t divindex, uint8_t octave, uint8_t duration) {
    TCCR1 = 0x90 | (11-octave);
    OCR1C = DIVISORS[divindex]-1;
    for (uint8_t i = 0; i < duration; i++) {
        _delay_ms(10);
    }
    TCCR1 = 0x90;
}

void begin_tone (uint8_t divindex, uint8_t octave) {
    TCCR1 = 0x90 | (11-octave);
    OCR1C = DIVISORS[divindex]-1;
}

void end_tone(void) {
    TCCR1 = 0x90;
}

void inc_whole (uint8_t* divindex, uint8_t* octave) {
    if ((*divindex) < (DIVISORS_SIZE - 2)) {
        (*divindex) += 2;
    } else if ((*divindex) == (DIVISORS_SIZE - 2)) {
        (*divindex) = 0;
        (*octave) += 1;
    } else {
        (*divindex) = 1;
        (*octave) += 1;
    }
}

void inc_half (uint8_t* divindex, uint8_t* octave) {
    if ((*divindex) < (DIVISORS_SIZE - 1)) {
        (*divindex) += 1;
    } else {
        (*divindex) = 0;
        (*octave) += 1;
    }
}

void play_quad (uint8_t divindex, uint8_t octave) {
    tone(divindex, octave, 15);
    inc_whole(&divindex, &octave);
    tone(divindex, octave, 15);
    inc_whole(&divindex, &octave);
    tone(divindex, octave, 15);
    inc_whole(&divindex, &octave);
    tone(divindex, octave, 15);
}

void item_song (void) {
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
