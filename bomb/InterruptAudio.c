/*
 * Timer-Based Audio on ATtiny84
 * Section 12
 *
 * Useful registers
 * ----------------
 * 
 * TCNT1, OCR1A, OCR1B, ICR1 are 16-bit registers.
 * TCCR1A, TCCR1B are 8-bit.
 * All should work as expected in C.
 * 
 * Compares OCR1A/B to TCNT1.
 * Output on OCnx
 * 
 * TCCR1A
 * +--------+--------+--------+--------+-------+-------+-------+-------+
 * | COM1A1 | COM1A0 | COM1B1 | COM1B0 |   –   |   –   | WGM11 | WGM10 |
 * +--------+--------+--------+--------+-------+-------+-------+-------+
 * 
 * TCCR1B
 * +-------+-------+-------+-------+-------+------+------+------+
 * | ICNC1 | ICES1 |   -   | WGM13 | WGM12 | CS12 | CS11 | CS10 |
 * +-------+-------+-------+-------+-------+------+------+------+
 * 
 * TCCR1C
 * +-------+-------+-------+-------+-------+-------+-------+-------+
 * | FOC1A | FOC1B |   -   |   -   |   -   |   -   |   -   |   -   |
 * +-------+-------+-------+-------+-------+-------+-------+-------+
 * 
 * COM1A1 COM1A0 controls what happens to OC1A
 * 0b00 = disconnected
 * 0b01 = toggle on match
 * 0b10 = clear on match
 * 0b01 = set on match
 * 
 * COM1B1 COM1B0 same as above
 * 
 * WGM13 WGM12 WGM11 WGM10 control mode
 * 0b0000 = normal, what we want
 * 0b0100 = CTC (Clear Timer on Compare)
 * 
 * ICNC1, ICES1 are input-capture related, just keep them 0b00
 * 
 * CS12 CS11 CS10: Clock select
 * 0x000 = no clock (timer/counter stopped)
 * 0x001 = clk
 * 0x010 = clk /    8  (2 ^  3)
 * 0x011 = clk /   64  (2 ^  5)
 * 0x100 = clk /  256  (2 ^  8)
 * 0x101 = clk / 1024  (2 ^ 10)
 * 
 * FOC1A, FOC1B, Force Output Compare for Channel x
 * Performs action from COMnxm
 * 
 * Notes
 * -----
 * 
 * Okay, I want to set it to various frequencies.
 * 16-bit counter means that I have periods up to 65535 ticks.
 * Plus the pre-scaler timing dividers.
 * Using 8MHz clock.
 * f = (f_clk / pre) / (comp + 1)
 * 8MHz / 8 / 65536 = 15Hz
 * Okay, so use 8 prescaler:
 *     CS12 CS11 CS10 = 0b010
 * I can probably afford the cycles to do the division, but the math is too big.
 * Highest I use is 7000Hz, that's 143 cycles
 * That's a wide range.
 * 
 * Let's try to generate 300Hz, 3333 cycles, OCR1A = 3332
 * 
 * OC1A = PA6 (pin 7, lower left)
 * 
 * DDRA |= (1 << 6);
 * 
 * for reset:
 *     // clear OC1A on match, clear timer on match, no clock/pre-scaler, force match
 *     TCCR1A = (1 << COM1A1);
 *     TCCR1B = (1 << WGM12);
 *     TCCR1C = (1 << FOC1A);
 * 
 * for play:
 *     // toggle OC1A on match, normal mode, clock / 8 (=1MHz)
 *     TCCR1A = (1 << COM1A0);
 *     TCCR1B = (1 << CS11);
 *     TCCR1C = 0;
 *     OCR1A  = 3332;
 * 
 * 66ms = 15Hz
 * 
 * 
 * --------------------------------
 * 
 * getting super-brief cut-out periods
 * I think that in CTC mode, when I set ORC1A lower than the counter, it goes a full cycle
 * notes seem to agree, recommend fast PWM (12.8.2, paragraph after the diagram)
 * 
 * note at the bottom of 12.8.3:
 * A frequency (with 50% duty cycle) waveform output in fast PWM mode can be achieved
 * by set-ting OC1A to toggle its logical level on each compare match (COM1A1:0 = 1).
 * The waveformgenerated will have a maximum frequency of 1A = fclk_I/O/2 when OCR1A is set to zero (0x0000).
 * This feature is similar to the OC1A toggle in CTC mode, except the double buffer feature of the
 * Output Compare unit is enabled in the fast PWM mode.
 * 
 * COM1A1:0 = 1
 * table 12-3:
 *      WGM13=1: Toggle OC1A, OC1B reserved
 * table 12-5:
 *     mode 15, WGM13:0 = 1111, Fast PWM, TOP = OCR1A, TOP, TOP
 * 
 * Keep old CS to keep old math: CS12 CS11 CS10 = 0b010
 * 
 * 
 */

#include "InterruptAudio.h"

void init_audio (void) {
    // PA6 as output
    DDRA  |=  (1 << AUDIO_PIN);
    // no pull-up
    PORTA &= ~(1 << AUDIO_PIN);
    // set low
    PINA  &= ~(1 << AUDIO_PIN); 

    noTone();
}

void rest (uint16_t duration_ms) {
    noTone();
    wait(duration_ms);
}

void toneOn (uint16_t freq) {
    changeTone(freq);
    // toggle OC1A on match, normal mode, clock / 8 (=1MHz)
    TCCR1A = (0<<COM1A1) | (1<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (1<<WGM11) | (1<<WGM10);
    TCCR1B = (0<<ICNC1)  | (0<<ICES1)  | (1<<WGM13)  | (1<<WGM12)  | (0<<CS12)  | (1<<CS11)  | (0<<CS10);
    TCCR1C = (0<<FOC1A)  | (0<<FOC1B);
}

void changeTone (uint16_t freq) {
    uint16_t cycles = ((uint32_t) ((uint32_t) 500000) / freq);
    // set cycles - 1
    OCR1A = cycles - 1;
}

void noTone (void) {
    // disconnect OC1A, clear timer on match, keep pre-scaler, force match
    TCCR1A = (0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (1<<WGM11) | (1<<WGM10);
    TCCR1B = (0<<ICNC1)  | (0<<ICES1)  | (1<<WGM13)  | (1<<WGM12)  | (0<<CS12)  | (1<<CS11)  | (0<<CS10);
    TCCR1C = (1<<FOC1A)  | (0<<FOC1B);
    // set low
    PINA &=  ~(1 << AUDIO_PIN); 
}

void tone (uint16_t freq, uint16_t duration_ms) {
    toneOn(freq);
    wait(duration_ms);
    noTone();
}

void wait (uint16_t duration_ms) {
    // ignoring cycles needed for loop
    // at 1MHz, should be close enough
    for (uint16_t i = 0; i < duration_ms; i++) {
        _delay_ms(1);
    }
}
