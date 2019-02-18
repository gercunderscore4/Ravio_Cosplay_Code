/****************************************************************
 * Interrupt-Based Audio on ATtiny85
 ****************************************************************/

#include "InterruptAudio.h"

void init_audio (void) {
    DDRB |= BIT_AO;
}

void tone (uint8_t divindex, uint8_t octave, uint8_t duration_cs) {
    TCCR1 = TCCR1_BITS | (11-octave);
    OCR1C = DIVISORS[divindex]-1;
    for (uint8_t i = 0; i < duration_cs; i++) {
        _delay_ms(10);
    }
    TCCR1 = TCCR1_BITS;
}

void begin_tone (uint8_t divindex, uint8_t octave) {
    TCCR1 = TCCR1_BITS | (11-octave);
    OCR1C = DIVISORS[divindex]-1;
}

void end_tone(void) {
    TCCR1 = TCCR1_BITS;
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

void play_quad (uint8_t divindex, uint8_t octave, uint8_t duration_cs) {
    tone(divindex, octave, duration_cs);
    inc_whole(&divindex, &octave);
    tone(divindex, octave, duration_cs);
    inc_whole(&divindex, &octave);
    tone(divindex, octave, duration_cs);
    inc_whole(&divindex, &octave);
    tone(divindex, octave, duration_cs);
}

void item_song (void) {
    //uint8_t divindex = 4;
    //uint8_t octave = 4;
    //for (uint8_t i = 0; i < 4; i++) {
    //    play_quad(divindex, octave, 15);
    //    play_quad(divindex, octave, 15);
    //    inc_half(&divindex, &octave);
    //}
    //for (uint8_t i = 0; i < 4; i++) {
    //    play_quad(divindex, octave, 15);
    //    inc_half(&divindex, &octave);
    //}
    //tone(0, 0, 60);
    //inc_whole(&divindex, &octave);
    //inc_whole(&divindex, &octave);
    //inc_whole(&divindex, &octave);
    //for (uint8_t i = 0; i < 3; i++) {
    //    tone(divindex, octave, 30);
    //    inc_half(&divindex, &octave);
    //}
    //tone(divindex, octave, 60);
    //tone(0, 0, 100);
    tone(divindex, octave, 500);
    tone(0, 0, 100);
}
